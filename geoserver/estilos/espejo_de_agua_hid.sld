<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>espejo_de_agua_hid</Name>
    <UserStyle>
      <Title>Espejos de agua</Title>
      <FeatureTypeStyle>
        <Rule>
          <Name>espejo_agua</Name>
          <Title>Espejo de agua</Title>
          <PolygonSymbolizer>
            <Fill><CssParameter name="fill">#a6cee3</CssParameter></Fill>
            <Stroke>
              <CssParameter name="stroke">#3182bd</CssParameter>
              <CssParameter name="stroke-width">0.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
