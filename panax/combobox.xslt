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
	<xsl:import href="../keys.xslt"/>

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
				<xsl:apply-templates mode="comboboxButton:widget-options" select=".">
					<xsl:with-param name="selection" select="$selection"/>
					<xsl:with-param name="items" select="$items"/>
				</xsl:apply-templates>
			</ul>
		</span>
	</xsl:template>

	<xsl:template mode="combobox:route-widget" match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='add']/@*">
		<xsl:param name="context" select="node-expected"/>
		<li>
			<a class="dropdown-item" href="javascript:void(0)" onclick="px.navigateTo('#{ancestor::px:Entity[1]/@Schema}/{ancestor::px:Entity[1]/@Name}~add','')">
				<xsl:apply-templates mode="widget" select="."/>
			</a>
		</li>
	</xsl:template>

	<xsl:template mode="combobox:route-widget" match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='edit']/@*">
		<xsl:param name="context" select="node-expected"/>
		<li>
			<a class="dropdown-item" href="javascript:void(0)" onclick="px.editSelectedOption(selectSingleNode('ancestor::*[xhtml:select]/xhtml:select'))">
				<xsl:apply-templates mode="widget" select="."/>
			</a>
		</li>
	</xsl:template>

	<xsl:template mode="widget" match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route/@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="widget" match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='add']/@*" priority="2">
		<xsl:text>Crear nuevo</xsl:text>
	</xsl:template>

	<xsl:template mode="widget" match="px:Entity[@control:type='combobox:control']/px:Routes/px:Route[@Method='edit']/@*" priority="2">
		<xsl:text>Editar registro</xsl:text>
	</xsl:template>

	<xsl:template mode="comboboxButton:widget-options" match="@*">
		<xsl:param name="selection" select="node-expected"/>
		<xsl:param name="items" select="*"/>
		<xsl:variable name="id" select="ancestor-or-self::*[@xo:id][1]/@xo:id"/>
		<li onclick="scope.$$('descendant-or-self::data:rows[1]').remove()">
			<a class="dropdown-item" href="#">Actualizar</a>
		</li>
		<xsl:apply-templates mode="combobox:route-widget" select="ancestor::px:Entity[1]/px:Routes/px:Route[@Method='add' or @Method='edit']/@xo:id">
			<xsl:with-param name="context" select="parent::xo:r"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:key name="referencer" match="px:Association/px:Mappings/px:Mapping/@Referencer" use="concat(ancestor::px:Entity[1]/@xo:id,'::',ancestor::px:Association[1]/@AssociationName)"/>
	<xsl:key name="referencee" match="px:Association/px:Mappings/px:Mapping/@Referencee" use="concat(ancestor::px:Association[1]/@xo:id,'::',.)"/>
	<xsl:key name="mapping" match="px:Association/px:Mappings/px:Mapping" use="concat(ancestor::px:Association[1]/@xo:id,'::',@Referencer,'::',@Referencee)"/>
	<xsl:template mode="combobox:widget" match="@*">
		<xsl:param name="dataset" select="."/>
		<xsl:param name="selection" select="."/>
		<xsl:param name="target" select="."/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="current" select="."/>
		<!--<xsl:variable name="referencee_entity" select="$dataset/ancestor::px:Association[1]/px:Entity"/>-->
		<!--<xsl:variable name="selected_value">
			<xsl:for-each select="key('referencer',concat(ancestor::px:Entity[1]/@xo:id,'::',local-name()))">
				<xsl:if test="position()&gt;1">/</xsl:if>
				<xsl:value-of select="$selection/parent::xo:r/@*[name()=current()]"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="selected_id">
			<xsl:for-each select="$dataset/ancestor::px:Association[1]/px:Mappings/px:Mapping/@Referencer">
				<xsl:if test="position()&gt;1">/</xsl:if>
				<xsl:value-of select="$selection/parent::xo:r/@*[name()=current()]"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="referencers" select="key('referencer',concat(ancestor::px:Entity[1]/@xo:id,'::',local-name()))"/>
		<xsl:variable name="referencees" select="$dataset/@*[key('referencee',concat(ancestor::px:Association[1]/@xo:id,'::',local-name()))]"/>
		<xsl:variable name="selected_values">
			<xsl:for-each select="$referencees">
				<xsl:variable name="referencee" select="."/>
				<xsl:variable name="current_position" select="position()"/>
				<xsl:for-each select="$referencers[key('mapping',concat(ancestor::px:Association[1]/@xo:id,'::',.,'::',name($referencee)))]">
					<xsl:variable name="referencer" select="."/>
					<xsl:variable name="mappings" select="key('mapping',concat(ancestor::px:Association[1]/@xo:id,'::',$referencer,'::',name($referencee)))"/>
					<xsl:choose>
						<xsl:when test="not(key('mapping',concat(ancestor::px:Association[1]/@xo:id,'::',$referencer,'::',name($referencee)))/preceding-sibling::*)">|</xsl:when>
						<xsl:otherwise>/</xsl:otherwise>
					</xsl:choose>
					--><!--<xsl:value-of select="name($referencee)"/>: <xsl:value-of select="$referencee"/>--><!--
					<xsl:if test="$referencee=$selection/parent::xo:r/@*[name()=$referencer]">
						--><!--<xsl:value-of select="count(key('mapping',concat(ancestor::px:Association[1]/@xo:id,'::',$referencer,'::',name($referencee)))/preceding-sibling::*)"/>--><!--
						<xsl:value-of select="$referencee"/>
						--><!--<xsl:value-of select="position()"/>: <xsl:value-of select="name($referencee)"/>
						<xsl:value-of select="$referencee"/>--><!--
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:text>|</xsl:text>
		</xsl:variable>-->
		<!--$selection: <xsl:value-of select="count($referencees)"/>-->
		<!--<xsl:variable name="selected_values" select="($dataset/@meta:value|$dataset/@meta:id)[.=$selected_value]"/>-->
		<!--selected_values: <xsl:value-of select="$selected_values"/>-->
		<!--<xsl:variable name="referencers">
				<xsl:for-each select="$dataset/ancestor::px:Association[1]/px:Mappings/px:Mapping/@Referencer">
					<xsl:if test="position()&gt;1">/</xsl:if>
					<xsl:value-of select="current()"/>
				</xsl:for-each>
			</xsl:variable>-->
		<!--<xsl:apply-templates mode="combobox:preceding-siblings" select="."/>-->
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
						<!--<xsl:with-param name="referencees" select="$referencees"/>
						<xsl:with-param name="selected_value" select="$selected_value"/>
						<xsl:with-param name="selected_values" select="$selected_values"/>-->
					</xsl:apply-templates>
					<xsl:apply-templates mode="combobox:option" select="$dataset/@meta:text">
						<xsl:sort select="../@meta:text"/>
						<xsl:with-param name="referencer" select="$selection"/>
						<!--<xsl:with-param name="referencees" select="$referencees"/>
						<xsl:with-param name="selected_value" select="$selected_value"/>
						<xsl:with-param name="selected_values" select="$selected_values"/>-->
					</xsl:apply-templates>
					<!--<xsl:apply-templates mode="combobox:option" select="($dataset|$selection[not($dataset)])/@meta:id|($dataset|$selection)[not($dataset)]/@meta:value">
							<xsl:sort select="../@meta:text"/>
							<xsl:with-param name="value" select="@meta:id|@meta:value"/>
						</xsl:apply-templates>-->
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
		<xsl:param name="referencer" select="node-expected|current()"/>
		<!--
		<xsl:param name="selected_value"/>
		<xsl:param name="selected_values"></xsl:param>

		<xsl:param name="referencee_entity" select="ancestor-or-self::*[@meta:type='entity'][1]"/>
		<xsl:param name="referencees" select="../@meta:value"/>
		<xsl:variable name="value">
			<xsl:for-each select="$referencees[../@xo:id=current()]">
				<xsl:if test="position()!=1">/</xsl:if>
				<xsl:value-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="visible">
			<xsl:choose>
				<xsl:when test="count($referencees[../@xo:id=current()])=1 or translate($selected_values,'|/','')=''">1</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$referencees[../@xo:id=current()]">
						<xsl:if test="contains(translate($selected_values,'|','/'),concat('/',.,'/'))">1</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
		<option value="{.}" xo-scope="{../@xo:id}">
			<xsl:variable name="selected">
				<xsl:choose>
					<xsl:when test="current() = $referencer">true</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$selected = 'true'">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:apply-templates select="."/>
		</option>
	</xsl:template>
</xsl:stylesheet>