<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>curso_de_agua_hid</Name>
    <UserStyle>
      <Title>Cursos de agua</Title>
      <FeatureTypeStyle>
        <Rule>
          <Name>curso_agua</Name>
          <Title>Curso de agua</Title>
          <LineSymbolizer>
            <Stroke>
              <CssParameter name="stroke">#3182bd</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </LineSymbolizer>
        </Rule>
        <Rule>
          <Name>etiqueta</Name>
          <MaxScaleDenominator>1000000</MaxScaleDenominator>
          <TextSymbolizer>
            <Label><ogc:PropertyName>nombre</ogc:PropertyName></Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">9</CssParameter>
              <CssParameter name="font-style">italic</CssParameter>
            </Font>
            <LabelPlacement><LinePlacement/></LabelPlacement>
            <Halo><Radius>1</Radius><Fill><CssParameter name="fill">#FFFFFF</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#08519c</CssParameter></Fill>
            <VendorOption name="followLine">true</VendorOption>
            <VendorOption name="repeat">400</VendorOption>
            <VendorOption name="group">yes</VendorOption>
          </TextSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
