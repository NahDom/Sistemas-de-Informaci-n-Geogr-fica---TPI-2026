<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>localidades</Name>
    <UserStyle>
      <Title>Localidades por cantidad de habitantes</Title>
      <FeatureTypeStyle>

        <Rule>
          <Name>sin_dato</Name>
          <Title>Sin dato de población</Title>
          <ogc:Filter>
            <ogc:Or>
              <ogc:PropertyIsNull><ogc:PropertyName>canthab</ogc:PropertyName></ogc:PropertyIsNull>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>0</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or>
          </ogc:Filter>
          <MaxScaleDenominator>1000000</MaxScaleDenominator>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#bdbdbd</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#757575</CssParameter><CssParameter name="stroke-width">0.5</CssParameter></Stroke>
              </Mark>
              <Size>3</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>c1</Name>
          <Title>Hasta 1.000 hab.</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThan>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>0</ogc:Literal>
              </ogc:PropertyIsGreaterThan>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>1000</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#fdd49e</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#7f2704</CssParameter><CssParameter name="stroke-width">0.6</CssParameter></Stroke>
              </Mark>
              <Size>5</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>c2</Name>
          <Title>1.000 a 10.000 hab.</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>1000</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>10000</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#fc8d59</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#7f2704</CssParameter><CssParameter name="stroke-width">0.6</CssParameter></Stroke>
              </Mark>
              <Size>7</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>c3</Name>
          <Title>10.000 a 50.000 hab.</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>10000</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>50000</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#e34a33</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#7f2704</CssParameter><CssParameter name="stroke-width">0.8</CssParameter></Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>c4</Name>
          <Title>50.000 a 200.000 hab.</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>50000</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThan>
                <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>200000</ogc:Literal>
              </ogc:PropertyIsLessThan>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#b30000</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1</CssParameter></Stroke>
              </Mark>
              <Size>14</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <Rule>
          <Name>c5</Name>
          <Title>Más de 200.000 hab.</Title>
          <ogc:Filter>
            <ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>200000</ogc:Literal>
            </ogc:PropertyIsGreaterThanOrEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill><CssParameter name="fill">#67000d</CssParameter></Fill>
                <Stroke><CssParameter name="stroke">#ffffff</CssParameter><CssParameter name="stroke-width">1.2</CssParameter></Stroke>
              </Mark>
              <Size>18</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>

        <!-- Nombres: ciudades grandes siempre; el resto solo con zoom -->
        <Rule>
          <Name>etiqueta_grandes</Name>
          <ogc:Filter>
            <ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>10000</ogc:Literal>
            </ogc:PropertyIsGreaterThanOrEqualTo>
          </ogc:Filter>
          <MaxScaleDenominator>5000000</MaxScaleDenominator>
          <TextSymbolizer>
            <Label><ogc:PropertyName>nombre</ogc:PropertyName></Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">11</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint><AnchorPointX>0</AnchorPointX><AnchorPointY>0.5</AnchorPointY></AnchorPoint>
                <Displacement><DisplacementX>8</DisplacementX><DisplacementY>0</DisplacementY></Displacement>
              </PointPlacement>
            </LabelPlacement>
            <Halo><Radius>1.5</Radius><Fill><CssParameter name="fill">#FFFFFF</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#222222</CssParameter></Fill>
            <VendorOption name="autoWrap">80</VendorOption>
          </TextSymbolizer>
        </Rule>

        <Rule>
          <Name>etiqueta_resto</Name>
          <ogc:Filter>
            <ogc:PropertyIsLessThan>
              <ogc:PropertyName>canthab</ogc:PropertyName><ogc:Literal>10000</ogc:Literal>
            </ogc:PropertyIsLessThan>
          </ogc:Filter>
          <MaxScaleDenominator>500000</MaxScaleDenominator>
          <TextSymbolizer>
            <Label><ogc:PropertyName>nombre</ogc:PropertyName></Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">9</CssParameter>
            </Font>
            <LabelPlacement>
              <PointPlacement>
                <AnchorPoint><AnchorPointX>0</AnchorPointX><AnchorPointY>0.5</AnchorPointY></AnchorPoint>
                <Displacement><DisplacementX>6</DisplacementX><DisplacementY>0</DisplacementY></Displacement>
              </PointPlacement>
            </LabelPlacement>
            <Halo><Radius>1</Radius><Fill><CssParameter name="fill">#FFFFFF</CssParameter></Fill></Halo>
            <Fill><CssParameter name="fill">#444444</CssParameter></Fill>
          </TextSymbolizer>
        </Rule>

      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
