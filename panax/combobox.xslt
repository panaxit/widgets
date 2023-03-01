<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:custom="http://panax.io/custom"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:comboboxButton="http://panax.io/widget/combobox-button"
  xmlns:route="http://panax.io/routes"
  xmlns:px="http://panax.io/entity"
  exclude-result-prefixes="xo xsl combobox data px"
>
	<xsl:import href="keys.xslt"/>

	<xsl:key name="combobox:widget" match="node-expected" use="@xo:id"/>

	<xsl:template mode="widget-attributes" match="@*" priority="-1"/>

	<xsl:template mode="combobox:attributes" match="@*" priority="-1">
		<xsl:apply-templates mode="widget-attributes" select="."/>
	</xsl:template>

	<xsl:template mode="combobox:preceding-siblings" match="@*" priority="-1"></xsl:template>

	<xsl:template mode="combobox:following-siblings" match="@*" priority="-1"></xsl:template>

	<xsl:template mode="comboboxButton:widget" match="@*">
		<xsl:param name="selection" select="node-expected"/>
		<xsl:param name="items" select="ancestor-or-self::*[1]"/>
		<xsl:variable name="id" select="ancestor-or-self::*[@xo:id][1]/@xo:id"/>
		<span class="input-group-append" style="color:black;" xo-scope="{$id}">
			<button type="button" class="btn btn-secondary btn-lg dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" tabindex="-1">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16">
					<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
					<path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
				</svg>
			</button>
			<ul class="dropdown-menu">
				<xsl:apply-templates mode="comboboxButton:options" select=".">
					<xsl:with-param name="selection" select="$selection"/>
					<xsl:with-param name="items" select="$items"/>
				</xsl:apply-templates>
			</ul>
		</span>
	</xsl:template>

	<xsl:template mode="widget-attributes" match="px:Association/px:Entity/px:Routes/px:Route/@*">
		<xsl:attribute name="onclick">Promise.reject('Función no implementada')</xsl:attribute>
	</xsl:template>

	<xsl:template mode="widget-attributes" match="px:Association/px:Entity/px:Routes/px:Route[@Method='add']/@*">
		<!--<xsl:attribute name="onclick">px.navigateTo('#<xsl:value-of select="ancestor::px:Entity[1]/@Schema"/>/<xsl:value-of select="ancestor::px:Entity[1]/@Name"/>~add','')</xsl:attribute>-->
		<xsl:attribute name="href">
			<xsl:text/>#<xsl:value-of select="ancestor::px:Entity[1]/@Schema"/>/<xsl:value-of select="ancestor::px:Entity[1]/@Name"/>~add<xsl:text/>
		</xsl:attribute>
		<xsl:attribute name="xo-scope">disabled</xsl:attribute>
	</xsl:template>

	<xsl:template mode="widget-attributes" match="px:Association/px:Entity/px:Routes/px:Route[@Method='edit']/@*">
		<xsl:attribute name="onclick">px.editSelectedOption(selectSingleNode('ancestor::*[xhtml:select]/xhtml:select'))</xsl:attribute>
	</xsl:template>

	<xsl:template match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='add']/@*">
		<xsl:text>Crear nuevo</xsl:text>
	</xsl:template>

	<xsl:template match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='delete']/@*">
		<xsl:text>Borrar registro</xsl:text>
	</xsl:template>

	<xsl:template match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='edit']/@*">
		<xsl:text>Editar registro</xsl:text>
	</xsl:template>

	<xsl:template mode="comboboxButton:options" match="@*">
		<xsl:param name="scope" select="node-expected"/>
		<xsl:param name="items" select="*"/>
		<xsl:variable name="id" select="ancestor-or-self::*[@xo:id][1]/@xo:id"/>
		<li onclick="px.refreshCatalog(this)">
			<a class="dropdown-item" href="#">Actualizar</a>
		</li>
		<xsl:apply-templates mode="widget" select="key('routes',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">
			<xsl:with-param name="scope" select="."/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="combobox:widget" match="@*">
		<xsl:param name="dataset" select="key('dataset', concat(ancestor::px:Entity[1]/@xo:id,'::',name()))"/>
		<xsl:param name="selection" select="."/>
		<xsl:param name="target" select="."/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="schema" select="key('schema',concat(ancestor::px:Entity[1]/@xo:id,'::',name($selection)))/../px:Mappings/px:Mapping/@Referencee"/>
		<xsl:variable name="current" select="."/>
		<select class="form-select" xo-scope="{../@xo:id}" xo-attribute="{name()}">
			<xsl:attribute name="style">
				<xsl:text/>min-width:<xsl:value-of select="concat(string-length($selection)+1,'ch')"/>;<xsl:text/>
			</xsl:attribute>
			<xsl:attribute name="onmouseover">px.loadData(scope.$(`ancestor::px:Entity[1]/px:Record/px:Association[@AssociationName="${scope.localName}"]/px:Entity`))</xsl:attribute>
			<xsl:apply-templates mode="combobox:attributes" select="."/>
			<xsl:choose>
				<xsl:when test="$dataset[local-name()='nil' and namespace-uri()='http://www.w3.org/2001/XMLSchema-instance'] or not($dataset|$selection[not($dataset)])">
					<option value="">Sin opciones</option>
				</xsl:when>
				<xsl:when test="$dataset">
					<xsl:apply-templates mode="combobox:previous-options" select=".">
						<xsl:sort select="../@meta:text"/>
						<xsl:with-param name="selection" select="$selection"/>
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>
					<xsl:apply-templates mode="combobox:option" select="$dataset">
						<xsl:sort select="../@meta:text"/>
						<xsl:with-param name="selection" select="$selection"/>
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">cursor:wait</xsl:attribute>
					<option>
						<xsl:apply-templates select="$selection"/>
					</option>
				</xsl:otherwise>
			</xsl:choose>
		</select>
		<xsl:apply-templates mode="combobox:following-siblings" select=".">
			<xsl:with-param name="catalog" select="$dataset"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="combobox:previous-options" match="@*">
		<option value="">
			Selecciona...
		</option>
	</xsl:template>

	<xsl:template mode="combobox:option" match="@*">
		<xsl:param name="selection" select="node-expected|current()"/>
		<xsl:param name="schema" select="current()"/>
		<xsl:variable name="current" select="current()"/>
		<option value="{.}" xo-scope="{../@xo:id}">
			<xsl:variable name="differences">
				<xsl:for-each select="$schema">
					<xsl:if test="$current/../@*[name()=current()]!=$selection/../@*[name()=current()/../@Referencer]">1</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="$differences = ''">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:apply-templates select="."/>
		</option>
	</xsl:template>
</xsl:stylesheet>