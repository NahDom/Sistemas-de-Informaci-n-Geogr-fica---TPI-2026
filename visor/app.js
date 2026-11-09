/* =====================================================================
   Visor SIG 250 – TPI Sistemas de Información Geográfica (UTN FRRe)
   OpenLayers + GeoServer (WMS / WFS / WFS-T) + PostGIS
   ===================================================================== */

// ---------- Configuración ----------
// Si la app se sirve desde la carpeta www de GeoServer, se usa la misma
// dirección (sin problemas de CORS). Si se abre desde otro lado, se usa localhost.
const GEOSERVER = location.pathname.startsWith('/geoserver')
  ? '/geoserver'
  : 'http://localhost:8080/geoserver';
const WS = 'sig250';                        // espacio de trabajo
const NS_URI = 'http://tpi.gis/sig250'; // URI del espacio de nombres
const WMS_URL = `${GEOSERVER}/${WS}/wms`;
const WFS_URL = `${GEOSERVER}/${WS}/wfs`;
const CAPA_EDITABLE = 'incidencias_ruta';

// Capas del visor, de abajo hacia arriba.
// Para agregar otra capa publicada en GeoServer, sumar una línea acá.
const CAPAS = [
  { id: 'provincias',             titulo: 'Provincias',             visible: true  },
  { id: 'espejo_de_agua_hid',     titulo: 'Espejos de agua',        visible: true  },
  { id: 'curso_de_agua_hid',      titulo: 'Cursos de agua',         visible: true  },
  { id: 'red_ferroviaria',        titulo: 'Red ferroviaria',        visible: false },
  { id: 'red_vial',               titulo: 'Red vial',               visible: true  },
  { id: 'puente_red_vial_puntos', titulo: 'Puentes',                visible: true  },
  { id: 'localidades',            titulo: 'Localidades',            visible: true  },
  { id: CAPA_EDITABLE,            titulo: 'Incidencias en ruta (editable)', visible: true }
];

// Atributos técnicos del IGN que no aportan a la consulta
const CAMPOS_OCULTOS = /^(geom|geometry|id|gid|igds_.*|rotation|group|cell_name|fuente|operador|dataset|responsabl|cargo|progreso|t_act|coord|sp|datum|ac|signo|escala|precision|fclass|bbox)$/i;

const PROY_MAPA = 'EPSG:3857';
const EXTENSION_CHACO = ol.proj.transformExtent([-63.6, -28.1, -58.2, -24.0], 'EPSG:4326', PROY_MAPA);

// ---------- Capas ----------
const mapaBase = new ol.layer.Tile({
  source: new ol.source.OSM(),
  className: 'mapa-base'
});

const capasWMS = {};
CAPAS.forEach((c, i) => {
  const capa = new ol.layer.Image({
    source: new ol.source.ImageWMS({
      url: WMS_URL,
      params: { LAYERS: `${WS}:${c.id}`, FORMAT: 'image/png', TRANSPARENT: true, VERSION: '1.1.1' },
      serverType: 'geoserver',
      ratio: 1
    }),
    visible: c.visible,
    zIndex: 10 + i
  });
  capasWMS[c.id] = capa;
});

// Resaltado de resultados de consultas
const fuenteResaltado = new ol.source.Vector();
const capaResaltado = new ol.layer.Vector({
  source: fuenteResaltado,
  zIndex: 100,
  style: new ol.style.Style({
    stroke: new ol.style.Stroke({ color: '#00e5ff', width: 4 }),
    fill: new ol.style.Fill({ color: 'rgba(0, 229, 255, 0.25)' }),
    image: new ol.style.Circle({
      radius: 8,
      stroke: new ol.style.Stroke({ color: '#00e5ff', width: 3 }),
      fill: new ol.style.Fill({ color: 'rgba(0, 229, 255, 0.3)' })
    })
  })
});

// Mediciones
const fuenteMedicion = new ol.source.Vector();
const capaMedicion = new ol.layer.Vector({
  source: fuenteMedicion,
  zIndex: 101,
  style: new ol.style.Style({
    stroke: new ol.style.Stroke({ color: '#1f2933', width: 3, lineDash: [8, 6] }),
    image: new ol.style.Circle({ radius: 4, fill: new ol.style.Fill({ color: '#1f2933' }) })
  })
});

// Punto temporal mientras se completa el formulario de alta
const fuenteTemporal = new ol.source.Vector();
const capaTemporal = new ol.layer.Vector({ source: fuenteTemporal, zIndex: 102 });

// ---------- Mapa ----------
const vista = new ol.View({
  projection: PROY_MAPA,
  center: ol.proj.fromLonLat([-60.6, -26.4]),
  zoom: 7
});

const mapa = new ol.Map({
  target: 'mapa',
  layers: [mapaBase, ...Object.values(capasWMS), capaResaltado, capaMedicion, capaTemporal],
  view: vista
});

mapa.addControl(new ol.control.ScaleLine({ units: 'metric', bar: true, steps: 4, text: true, minWidth: 140 }));
mapa.addControl(new ol.control.ZoomToExtent({ extent: EXTENSION_CHACO, label: '⌂', tipLabel: 'Ver toda la provincia del Chaco' }));
mapa.addControl(new ol.control.FullScreen({ tipLabel: 'Pantalla completa' }));
mapa.addControl(new ol.control.MousePosition({
  projection: 'EPSG:4326',
  coordinateFormat: ol.coordinate.createStringXY(5),
  target: document.getElementById('coords'),
  className: 'pos-mouse',
  placeholder: '–'
}));

// ---------- Utilidades ----------
const $ = (sel) => document.querySelector(sel);

function avisar(texto, tipo = '') {
  const el = $('#aviso');
  el.textContent = texto;
  el.className = tipo;
  clearTimeout(avisar.t);
  avisar.t = setTimeout(() => el.classList.add('oculto'), 4500);
}

function tituloDe(id) {
  return (CAPAS.find((c) => c.id === id) || { titulo: id }).titulo;
}

function escapar(v) {
  return String(v ?? '').replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
}

// ---------- Escala numérica ----------
function actualizarEscala() {
  const res = vista.getResolution();
  const resTerreno = ol.proj.getPointResolution(PROY_MAPA, res, vista.getCenter(), 'm');
  const denominador = resTerreno / 0.00028; // tamaño de píxel estándar OGC (0,28 mm)
  $('#escala').textContent = '1:' + Math.round(denominador).toLocaleString('es-AR');
}

// ---------- Lista de capas (activar / desactivar) ----------
function armarListaCapas() {
  const ul = $('#listaCapas');
  [...CAPAS].reverse().forEach((c) => {
    const li = document.createElement('li');
    li.innerHTML = `<label><input type="checkbox" ${c.visible ? 'checked' : ''}> ${escapar(c.titulo)}</label>`;
    li.querySelector('input').addEventListener('change', (e) => {
      capasWMS[c.id].setVisible(e.target.checked);
      actualizarLeyenda();
    });
    ul.appendChild(li);
  });
  // Mapa base
  const li = document.createElement('li');
  li.innerHTML = '<label><input type="checkbox" checked> Mapa base (OpenStreetMap)</label>';
  li.querySelector('input').addEventListener('change', (e) => mapaBase.setVisible(e.target.checked));
  ul.appendChild(li);

  // Selector de capa a consultar
  const sel = $('#capaConsulta');
  [...CAPAS].reverse().forEach((c) => {
    const op = document.createElement('option');
    op.value = c.id;
    op.textContent = c.titulo;
    sel.appendChild(op);
  });
  sel.value = 'localidades';
}

// ---------- Leyenda (GetLegendGraphic, filtrada por escala) ----------
function actualizarLeyenda() {
  const cont = $('#leyenda');
  cont.innerHTML = '';
  const res = vista.getResolution();
  const visibles = [...CAPAS].reverse().filter((c) => capasWMS[c.id].getVisible());
  if (!visibles.length) {
    cont.innerHTML = '<p class="vacio">No hay capas activas.</p>';
    return;
  }
  visibles.forEach((c) => {
    const url = capasWMS[c.id].getSource().getLegendUrl(res, {
      FORMAT: 'image/png',
      LEGEND_OPTIONS: 'fontName:Arial;fontAntiAliasing:true;fontSize:11;forceLabels:on'
    });
    const div = document.createElement('div');
    div.className = 'item';
    div.innerHTML = `<strong>${escapar(c.titulo)}</strong><img alt="Leyenda de ${escapar(c.titulo)}" src="${url}">`;
    cont.appendChild(div);
  });
}

// ---------- Resultados de consultas ----------
function mostrarResultados(features, titulo) {
  fuenteResaltado.clear();
  fuenteResaltado.addFeatures(features);

  $('#resultados').classList.remove('oculto');
  $('#resTitulo').textContent = `${titulo} · ${features.length} elemento(s)`;

  if (!features.length) {
    $('#resCuerpo').innerHTML = '<p class="ayuda">No se encontraron elementos en esa ubicación.</p>';
    return;
  }
  const campos = Object.keys(features[0].getProperties()).filter((k) => !CAMPOS_OCULTOS.test(k));
  const filas = features.slice(0, 300).map((f) => {
    const p = f.getProperties();
    return '<tr>' + campos.map((k) => `<td>${escapar(p[k])}</td>`).join('') + '</tr>';
  });
  $('#resCuerpo').innerHTML =
    `<table><thead><tr>${campos.map((k) => `<th>${escapar(k)}</th>`).join('')}</tr></thead>` +
    `<tbody>${filas.join('')}</tbody></table>` +
    (features.length > 300 ? '<p class="ayuda">Se muestran los primeros 300.</p>' : '');
}

const formatoGeoJSON = new ol.format.GeoJSON();

// Consulta por punto: WMS GetFeatureInfo
async function consultarPunto(evt) {
  const id = $('#capaConsulta').value;
  const capa = capasWMS[id];
  if (!capa.getVisible()) {
    avisar('Active la capa en la lista para poder consultarla.', 'error');
    return;
  }
  const url = capa.getSource().getFeatureInfoUrl(evt.coordinate, vista.getResolution(), PROY_MAPA, {
    INFO_FORMAT: 'application/json',
    FEATURE_COUNT: 20,
    BUFFER: 8
  });
  try {
    const json = await (await fetch(url)).json();
    const features = formatoGeoJSON.readFeatures(json, { featureProjection: PROY_MAPA });
    mostrarResultados(features, `Consulta por punto: ${tituloDe(id)}`);
  } catch (e) {
    avisar('Error en GetFeatureInfo: ' + e.message, 'error');
  }
}

// Consulta por rectángulo: WFS GetFeature con filtro BBOX
const cajaSeleccion = new ol.interaction.DragBox({ className: 'caja-seleccion' });
cajaSeleccion.on('boxend', async () => {
  const id = $('#capaConsulta').value;
  const ext = cajaSeleccion.getGeometry().getExtent();
  const params = new URLSearchParams({
    service: 'WFS',
    version: '1.1.0',
    request: 'GetFeature',
    typeName: `${WS}:${id}`,
    outputFormat: 'application/json',
    srsName: PROY_MAPA,
    bbox: ext.join(',') + ',' + PROY_MAPA,
    maxFeatures: 1000
  });
  try {
    const json = await (await fetch(`${WFS_URL}?${params}`)).json();
    const features = formatoGeoJSON.readFeatures(json, { dataProjection: PROY_MAPA, featureProjection: PROY_MAPA });
    mostrarResultados(features, `Consulta por rectángulo: ${tituloDe(id)}`);
  } catch (e) {
    avisar('Error en WFS GetFeature: ' + e.message, 'error');
  }
});

// ---------- Medición de distancias ----------
const medicion = new ol.interaction.Draw({
  source: fuenteMedicion,
  type: 'LineString',
  style: new ol.style.Style({
    stroke: new ol.style.Stroke({ color: '#b5312a', width: 3, lineDash: [8, 6] }),
    image: new ol.style.Circle({ radius: 5, stroke: new ol.style.Stroke({ color: '#b5312a', width: 2 }) })
  })
});
let tooltipActivo = null;
let geomEnCurso = null;

function alCambiarGeom() {
  tooltipActivo.getElement().textContent = formatearLongitud(geomEnCurso);
  tooltipActivo.setPosition(geomEnCurso.getLastCoordinate());
}

function formatearLongitud(linea) {
  const metros = ol.sphere.getLength(linea, { projection: PROY_MAPA }); // geodésica
  return metros >= 1000 ? (metros / 1000).toFixed(2) + ' km' : metros.toFixed(1) + ' m';
}

function nuevoTooltip() {
  const el = document.createElement('div');
  el.className = 'tooltip-medida';
  const ov = new ol.Overlay({ element: el, offset: [10, -10], positioning: 'bottom-left' });
  mapa.addOverlay(ov);
  return ov;
}

medicion.on('drawstart', (e) => {
  tooltipActivo = nuevoTooltip();
  geomEnCurso = e.feature.getGeometry();
  geomEnCurso.on('change', alCambiarGeom);
});
medicion.on('drawend', () => {
  geomEnCurso.un('change', alCambiarGeom);
  geomEnCurso = null;
  tooltipActivo = null;
});

// ---------- Alta de incidencias (WFS-T Insert) ----------
const dibujoAlta = new ol.interaction.Draw({ source: fuenteTemporal, type: 'Point' });
let puntoPendiente = null;
let nsCapaEditable = null;

// Lee de GeoServer el espacio de nombres real de la capa editable
// (WFS DescribeFeatureType), para no depender de escribirlo a mano.
async function obtenerNamespace() {
  if (nsCapaEditable) return nsCapaEditable;
  const params = new URLSearchParams({
    service: 'WFS',
    version: '1.1.0',
    request: 'DescribeFeatureType',
    typeName: `${WS}:${CAPA_EDITABLE}`,
    outputFormat: 'application/json'
  });
  const resp = await fetch(`${WFS_URL}?${params}`);
  const texto = await resp.text();
  let json;
  try {
    json = JSON.parse(texto);
  } catch (e) {
    console.error(texto);
    throw new Error(`la capa ${WS}:${CAPA_EDITABLE} no está publicada en GeoServer (o no es accesible por WFS).`);
  }
  nsCapaEditable = json.targetNamespace || NS_URI;
  console.log('Espacio de nombres de la capa editable:', nsCapaEditable);
  return nsCapaEditable;
}

dibujoAlta.on('drawend', (e) => {
  puntoPendiente = e.feature;
  const [lon, lat] = ol.proj.toLonLat(e.feature.getGeometry().getCoordinates());
  $('#altaCoords').textContent = `Ubicación: ${lon.toFixed(5)}, ${lat.toFixed(5)}`;
  $('#formAlta').fecha.value = new Date().toISOString().slice(0, 10);
  $('#modalAlta').classList.remove('oculto');
});

function cerrarAlta() {
  $('#modalAlta').classList.add('oculto');
  $('#formAlta').reset();
  fuenteTemporal.clear();
  puntoPendiente = null;
}
$('#cancelarAlta').addEventListener('click', cerrarAlta);

$('#formAlta').addEventListener('submit', async (e) => {
  e.preventDefault();
  if (!puntoPendiente) return;
  const datos = new FormData(e.target);

  // El orden de los atributos sigue la tabla de PostGIS: tipo, descripcion, fecha, geom
  const nueva = new ol.Feature({
    tipo: datos.get('tipo'),
    descripcion: datos.get('descripcion'),
    fecha: datos.get('fecha')
  });
  nueva.setGeometryName('geom');
  nueva.setGeometry(puntoPendiente.getGeometry().clone());

  let namespace;
  try {
    namespace = await obtenerNamespace();
  } catch (err) {
    avisar('No se puede guardar: ' + err.message, 'error');
    return;
  }

  const formatoWFS = new ol.format.WFS();
  const nodo = formatoWFS.writeTransaction([nueva], null, null, {
    featureNS: namespace,
    featurePrefix: WS,
    featureType: CAPA_EDITABLE,
    srsName: PROY_MAPA, // GeoServer reproyecta a EPSG:4326 al guardar
    version: '1.1.0'
  });
  const xml = new XMLSerializer().serializeToString(nodo);

  try {
    const resp = await fetch(WFS_URL, { method: 'POST', headers: { 'Content-Type': 'text/xml' }, body: xml });
    const texto = await resp.text();
    const resultado = formatoWFS.readTransactionResponse(texto);
    const insertados = resultado && resultado.transactionSummary ? resultado.transactionSummary.totalInserted : 0;
    if (insertados > 0) {
      avisar('Incidencia guardada en la base de datos.', 'ok');
      cerrarAlta();
      capasWMS[CAPA_EDITABLE].getSource().updateParams({ _actualizado: Date.now() });
    } else {
      console.error(texto);
      const motivo = (texto.match(/<ows:ExceptionText>([\s\S]*?)<\/ows:ExceptionText>/) || [])[1];
      avisar('GeoServer rechazó la transacción: ' + (motivo || 'ver la consola del navegador (F12)'), 'error');
    }
  } catch (err) {
    avisar('Error al enviar la transacción WFS-T: ' + err.message, 'error');
  }
});

// ---------- Modos de trabajo ----------
const AYUDAS = {
  navegar: 'Arrastre para desplazar el mapa; rueda del mouse o +/− para el zoom.',
  punto: 'Haga clic sobre un elemento de la capa elegida en "Capa a consultar".',
  rectangulo: 'Arrastre un rectángulo sobre el mapa para consultar la capa elegida.',
  medir: 'Clic para agregar vértices; doble clic para terminar la medición.',
  alta: 'Haga clic en el mapa donde se ubica la incidencia y complete el formulario.'
};
let modo = 'navegar';

function cambiarModo(nuevo) {
  [cajaSeleccion, medicion, dibujoAlta].forEach((i) => mapa.removeInteraction(i));
  modo = nuevo;
  if (nuevo === 'rectangulo') mapa.addInteraction(cajaSeleccion);
  if (nuevo === 'medir') mapa.addInteraction(medicion);
  if (nuevo === 'alta') {
    capasWMS[CAPA_EDITABLE].setVisible(true);
    mapa.addInteraction(dibujoAlta);
  }
  document.querySelectorAll('#herramientas button').forEach((b) => b.classList.toggle('activo', b.dataset.modo === nuevo));
  $('#ayuda').textContent = AYUDAS[nuevo];
  mapa.getTargetElement().style.cursor = nuevo === 'navegar' ? '' : 'crosshair';
}

document.querySelectorAll('#herramientas button').forEach((b) =>
  b.addEventListener('click', () => cambiarModo(b.dataset.modo))
);

mapa.on('singleclick', (evt) => {
  if (modo === 'punto') consultarPunto(evt);
});

$('#limpiar').addEventListener('click', () => {
  fuenteResaltado.clear();
  fuenteMedicion.clear();
  mapa.getOverlays().getArray().slice().forEach((o) => mapa.removeOverlay(o));
  $('#resultados').classList.add('oculto');
});
$('#cerrarResultados').addEventListener('click', () => {
  $('#resultados').classList.add('oculto');
  fuenteResaltado.clear();
});

// ---------- Inicio ----------
armarListaCapas();
mapa.on('moveend', () => {
  actualizarEscala();
  actualizarLeyenda();
});
actualizarEscala();
actualizarLeyenda();
