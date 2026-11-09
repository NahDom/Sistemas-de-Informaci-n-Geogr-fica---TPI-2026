<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>puente_red_vial_puntos</Name>
    <UserStyle>
      <Title>Puentes de la red vial por tipo</Title>
      <FeatureTypeStyle>

        <Rule>
          <Name>puente</Name>
          <Title>Puente vial</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName>
              <ogc:Literal>Puentes Para toda Clase de Vehículos</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>square</WellKnownName>
                <Fill><CssParameter name="fill">#1f3a5f</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>7</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>colgante</Name>
          <Title>Puente colgante</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName>
              <ogc:Literal>Colgante</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill><CssParameter name="fill">#16a085</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>viaducto</Name>
          <Title>Viaducto</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName>
              <ogc:Literal>Viaducto</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>square</WellKnownName>
                <Fill><CssParameter name="fill">#8e44ad</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>tunel</Name>
          <Title>Túnel</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName>
              <ogc:Literal>Túnel</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#000000</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>8</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
