<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:px="http://panax.io/entity"
xmlns:xo="http://panax.io/xover"
xmlns:state="http://panax.io/state"
xmlns:site="http://panax.io/site"
xmlns:shell="http://panax.io/shell"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:initial="http://panax.io/state/initial"
xmlns:data="http://panax.io/source"
  xmlns:route="http://panax.io/routes"
exclude-result-prefixes="#default xsl px xo xsi route"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>
	<xsl:param name="site:active"/>
	<xsl:key name="changed" match="@initial:*" use="concat(../@xo:id,'::',local-name())"/>

	<xsl:template match="/">
		<ul id="shell_buttons" class="nav col-md-4 justify-content-end list-unstyled d-flex">
			<xo-listener attribute="initial:*"/>
			<xo-listener attribute="prev:*"/>
			<xo-listener attribute="state:delete"/>
			<xsl:apply-templates select="px:Entity/@xo:id" mode="shell:buttons"/>
		</ul>
	</xsl:template>

	<xsl:template match="text()|*[not(*)]" mode="shell:buttons"></xsl:template>

	<xsl:template match="px:Entity[@xsi:type='form:control']/data:rows/xo:r/@*" mode="shell:buttons">
		<xsl:if test="../descendant-or-self::xo:r/@*[namespace-uri()=''][.!=key('changed',concat(../@xo:id,'::',local-name()))]">
			<li class="ms-3">
				<a class="text-muted" href="#" onclick="px.submit(scope)">
					<button class="btn btn-success">Guardar</button>
				</a>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='form:control']/@*" mode="shell:buttons">
		<xsl:apply-templates mode="shell:buttons" select="../data:rows/xo:r/@xo:id"/>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='datagrid:control']/@*" mode="shell:buttons">
		<xsl:variable name="deleting_rows" select="../data:rows/*[@state:delete]"/>
		<xsl:choose>
			<xsl:when test="$deleting_rows">
				<li class="ms-3" xo-scope="{../@xo:id}">
					<a class="text-muted" href="#" onclick="px.submit(scope.$$('data:rows/*[@state:delete]'))">
						<button class="btn btn-danger">Eliminar </button>
					</a>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li class="ms-3">
					<xsl:apply-templates mode="route:widget" select="ancestor::px:Entity[1]/px:Routes/px:Route[@Method='add']/@xo:id">
						<xsl:with-param name="context" select=".."/>
					</xsl:apply-templates>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
