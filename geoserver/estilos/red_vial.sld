<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>red_vial</Name>
    <UserStyle>
      <Title>Red vial por jurisdicción</Title>
      <FeatureTypeStyle>

        <!-- Rutas vecinales: solo a escalas grandes (muchos elementos) -->
        <Rule>
          <Name>vecinal</Name>
          <Title>Camino vecinal</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>administra</ogc:PropertyName>
              <ogc:Literal>Vecinal</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MaxScaleDenominator>1500000</MaxScaleDenominator>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#9e9e9e</CssParameter>
              <CssParameter name="stroke-width">0.6</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>

        <Rule>
          <Name>provincial</Name>
          <Title>Ruta provincial</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>administra</ogc:PropertyName>
              <ogc:Literal>Provincial</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#e67e22</CssParameter>
              <CssParameter name="stroke-width">1.4</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>

        <Rule>
          <Name>nacional</Name>
          <Title>Ruta nacional</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>administra</ogc:PropertyName>
              <ogc:Literal>Nacional</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#7b1e14</CssParameter>
              <CssParameter name="stroke-width">3.5</CssParameter>
              <CssParameter name="stroke-linecap">round</CssParameter>
            </Stroke>
          </LineSymbolizer>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#e74c3c</CssParameter>
              <CssParameter name="stroke-width">2</CssParameter>
              <CssParameter name="stroke-linecap">round</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>

        <Rule>
          <Name>internacional</Name>
          <Title>Ruta internacional</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>administra</ogc:PropertyName>
              <ogc:Literal>Internacional</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#6c3483</CssParameter>
              <CssParameter name="stroke-width">2.5</CssParameter>
              <CssParameter name="stroke-dasharray">6 3</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>

        <!-- Etiqueta con el número de ruta nacional a escalas medias/grandes -->
        <Rule>
          <Name>etiqueta_nacional</Name>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>administra</ogc:PropertyName>
              <ogc:Literal>Nacional</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <MaxScaleDenominator>3000000</MaxScaleDenominator>
          <TextSymbolizer>
            <Label>RN <ogc:PropertyName>nro_ruta</ogc:PropertyName></Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">10</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <LinePlacement/>
            </LabelPlacement>
            <Halo>
              <Radius>1.5</Radius>
              <Fill><CssParameter name="fill">#FFFFFF</CssParameter></Fill>
            </Halo>
            <Fill><CssParameter name="fill">#7b1e14</CssParameter></Fill>
            <VendorOption name="followLine">true</VendorOption>
            <VendorOption name="repeat">300</VendorOption>
            <VendorOption name="group">yes</VendorOption>
          </TextSymbolizer>
        </Rule>

      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
