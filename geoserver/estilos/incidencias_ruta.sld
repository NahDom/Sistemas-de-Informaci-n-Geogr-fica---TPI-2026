<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>incidencias_ruta</Name>
    <UserStyle>
      <Title>Incidencias sobre la ruta</Title>
      <FeatureTypeStyle>

        <Rule>
          <Name>bache</Name>
          <Title>Bache</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName><ogc:Literal>Bache</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill><CssParameter name="fill">#e67e22</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#000000</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>14</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>senalizacion</Name>
          <Title>Señalización dañada</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName><ogc:Literal>Señalización dañada</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill><CssParameter name="fill">#f1c40f</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#000000</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>14</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>banquina</Name>
          <Title>Banquina deteriorada</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>tipo</ogc:PropertyName><ogc:Literal>Banquina deteriorada</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill><CssParameter name="fill">#8e44ad</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#000000</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>14</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>otro</Name>
          <Title>Otra incidencia</Title>
          <ElseFilter/>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>triangle</WellKnownName>
                <Fill><CssParameter name="fill">#7f8c8d</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#000000</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>14</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
