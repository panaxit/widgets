<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:source="http://panax.io/fetch/request"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:session="http://panax.io/session"
  xmlns:state="http://panax.io/state"
  xmlns:px="http://panax.io"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:widget="http://panax.io/widget"
  xmlns:modal="http://panax.io/widget/modal"
  exclude-result-prefixes="widget px state xo source"
>
	<xsl:import href="modal.xslt"/>
	<xsl:key name="hidden" match="node-expected" use="generate-id()"/>
	<xsl:key name="invalid" match="node-expected" use="generate-id()"/>
	<xsl:key name="optional" match="node-expected" use="generate-id()"/>

	<xsl:template match="Routine/@*" mode="widget">
		<xsl:apply-templates mode="widget"/>
	</xsl:template>

	<xsl:template mode="headerText" match="Routine/@*">
		<xsl:value-of select="concat(../@Schema,' - ',../@Name)"/>
	</xsl:template>

	<xsl:template mode="prepare_value" match="@*">
		<xsl:text>`</xsl:text>
		<xsl:apply-templates select="."/>
		<xsl:text>`</xsl:text>
	</xsl:template>

	<xsl:template mode="prepare_value" match="@value[.='DEFAULT' or .='NULL' or number(.)=.]">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="parameter/@name" mode="headerText">
		<xsl:value-of select="substring(.,2)"/>
	</xsl:template>

	<xsl:template match="parameter/@name[contains(.,'@Id')]" mode="headerText">
		<xsl:value-of select="substring(.,3)"/>
	</xsl:template>

	<xsl:template match="parameter/@value" mode="headerText">
		<xsl:apply-templates mode="headerText" select="../@name"/>
	</xsl:template>

	<xsl:template mode="widget:options" match="parameter/@value">
		<xsl:param name="catalog" select="xo:dummy"/>
		<datalist id="options_{../@xo:id}">
			<xsl:for-each select="../data:rows/xo:r">
				<option value="{@meta:text}"/>
			</xsl:for-each>
		</datalist>
	</xsl:template>

	<xsl:template mode="widget:attributes" match="parameter/@value">
		<xsl:attribute name="id">
			<xsl:value-of select="../@xo:id"/>
		</xsl:attribute>
		<xsl:attribute name="list">
			<xsl:text>options_</xsl:text>
			<xsl:value-of select="../@xo:id"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="parameter/@xo:id" mode="widget">
		<div class="form-group row">
			<label class="col-sm-3 col-form-label">
				<xsl:apply-templates select="../@name" mode="headerText"/>
			</label>
			<div class="col-sm-9">
				<!--<div class="input-group mb-3">-->
				<xsl:apply-templates mode="widget" select="../@value"/>
				<!--<div class="input-group-append">
            <div class="input-group-text">
              <input type="radio" aria-label="Usar default" id="_default_{@xo:id}" class="custom-control-input"/>
              <label class="custom-control-label" for="_default_{@xo:id}">Usar default</label>
            </div>
          </div>-->
				<!--</div>-->
				<xsl:apply-templates mode="widget:options" select="../@value"/>
			</div>
		</div>
		<!--<br/>-->
	</xsl:template>

	<xsl:template match="parameter[@name='@IdFraccionamiento' or @name='@IdCondominio']/@value">
		<!--<xsl:value-of select="$session:fraccionamiento"/>-->
	</xsl:template>

	<xsl:template match="*[parameter[not(key('hidden',generate-id()))]]/parameter[key('hidden',generate-id())]/@*" mode="widget"/>
	
	<xsl:template match="/">
		<xsl:apply-templates mode="modal:widget" select="xo:prompt/Routine/@xo:id"/>
	</xsl:template>

	<xsl:template mode="modal:widget-body" match="@*">
		<div>
			<xsl:apply-templates mode="widget" select="../parameter/@xo:id"/>
			<!--
		<div class="modal-dialog modal-prompt">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="staticBackdropLabel_x_prompt_3f599157_b5a2_4b83_a255_ec43a4b79a49">Finanzas - getEdoResultados</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" data-bs-target="#modal_x_prompt_3f599157_b5a2_4b83_a255_ec43a4b79a49" onclick="closest(`[role='alertdialog']`).remove()">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">
					<div xmlns:session="http://panax.io/session" class="form-group row">
						<label class="col-sm-3 col-form-label"></label>
						<div class="col-sm-9">
							<div class="input-group">
								<select id="parameter_9bd8c912_4f2a_408d_83d6_e9554047bc51" class="form-select  text-black " onchange="this.source.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}); ">
									<option value="" selected="">Selecciona </option>
									<option value="48">Ejemplo dev</option>
									<option value="45">Prueba Dev</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button xmlns:session="http://panax.io/session" type="button" class="btn btn_outline_information__data" data-dismiss="modal" onclick="closest(`[role='alertdialog']`).remove()">
						Cancelar
					</button>
					<button xmlns:session="http://panax.io/session" type="button" class="btn btn_information__data disabled">
						Enviar
					</button>
				</div>
			</div>
		</div>
		-->
		</div>
	</xsl:template>

	<xsl:template match="xo:prompt" mode="modal:widget-body">
		<xsl:apply-templates mode="widget" select="current()"/>
	</xsl:template>

	<xsl:template match="Routine/@*" mode="modal:widget-header-title-label">
		<xsl:apply-templates mode="headerText" select="../@Name"/>
	</xsl:template>

	<xsl:template match="Routine/@*" mode="modal:widget-footer">
		<xsl:for-each select="ancestor-or-self::*[1]">
		<button type="button" class="btn btn_outline_information__data" data-dismiss="modal">
			<xsl:attribute name="onclick">
				<xsl:apply-templates mode="modal:widget-buttons-close-attributes-onclick" select="."/>
			</xsl:attribute>
			Cancelar
		</button>
		<button type="button" class="btn btn_information__data">
			<xsl:choose>
				<xsl:when test="not(key('invalid',generate-id())[not(key('optional',generate-id()))])">
					<!--<xsl:attribute name="onclick">
						<xsl:text/>xo.server.request({command:`[<xsl:value-of select="@Schema"/>].[<xsl:value-of select="@Name"/>]`,parameters:`<xsl:text/>
						<xsl:for-each select="*">
							<xsl:text>&amp;</xsl:text>
							<xsl:apply-templates select="@name"/>
							<xsl:text>=</xsl:text>
							<xsl:choose>
								<xsl:when test="string(@value)!=''">
									<xsl:apply-templates select="@value"/>
								</xsl:when>
								<xsl:when test="text()">
									<xsl:apply-templates select="text()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>NULL</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:text>`});</xsl:text>
					</xsl:attribute>-->
					<xsl:attribute name="onclick">
						<xsl:text/>xo.server.request({command:`[<xsl:value-of select="@Schema"/>].[<xsl:value-of select="@Name"/>]`<xsl:text/>
						<xsl:for-each select="*">
							<xsl:text>,</xsl:text>
							<xsl:text>"</xsl:text>
							<xsl:apply-templates select="@name"/>
							<xsl:text>":</xsl:text>
							<xsl:choose>
								<xsl:when test="string(@value)!=''">
									<xsl:apply-templates mode="prepare_value" select="@value"/>
								</xsl:when>
								<xsl:when test="text()">
									<xsl:apply-templates select="text()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>NULL</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:text>})/*.then(_ => this.closest('[role="alertdialog"]').remove())*/;</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">btn btn_information__data disabled</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			Enviar
		</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="modal:widget-attributes-class">modal-prompt</xsl:template>

</xsl:stylesheet>
