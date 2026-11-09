<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>provincias</Name>
    <UserStyle>
      <Title>Límites provinciales</Title>
      <FeatureTypeStyle>
        <Rule>
          <Name>provincia</Name>
          <Title>Provincia</Title>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#f2efe9</CssParameter>
              <CssParameter name="fill-opacity">0.35</CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#555555</CssParameter>
              <CssParameter name="stroke-width">1.2</CssParameter>
              <CssParameter name="stroke-dasharray">8 3 2 3</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
          <TextSymbolizer>
            <Label><ogc:PropertyName>provincia</ogc:PropertyName></Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">12</CssParameter>
              <CssParameter name="font-style">italic</CssParameter>
            </Font>
            <Halo><Radius>2</Radius><Fill><CssParameter name="fill">#FFFFFF</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#555555</CssParameter></Fill>
            <VendorOption name="autoWrap">100</VendorOption>
            <VendorOption name="maxDisplacement">50</VendorOption>
          </TextSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
