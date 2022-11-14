<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:px="http://panax.io/entity"
  xmlns:container="http://panax.io/layout/container"
  xmlns:readonly="http://panax.io/state/readonly"
  xmlns:file="http://panax.io/widget/file"

  xmlns:form="http://panax.io/widget/form"
  xmlns:widget="http://panax.io/widget"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:cardview="http://panax.io/widget/cardview"
  exclude-result-prefixes="widget xo state xsl xsi form cardview data height width data container px readonly layout meta"
>
	<xsl:import href="../keys.xslt"/>

	<xsl:key name="styles" match="@height:*" use="concat(../@xo:id,'::',local-name())"/>
	<xsl:key name="styles" match="@width:*" use="concat(../@xo:id,'::',local-name())"/>

	<xsl:template mode="style" match="@width:*|@height:*">
		<xsl:value-of select="concat(substring-before(name(),':'),':',current(),'px;')"/>
	</xsl:template>

	<xsl:template mode="widget:attributes" match="@*" priority="-1">
		<xsl:apply-templates mode="widget-attributes" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="current" select="."/>
		<xsl:variable name="schema" select="key('reference',concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'::header::field:ref::',name()))/.."/>
		<input type="text" class="form-control {$class}" id="{$schema/@xo:id}" placeholder="" required="" xo-scope="{ancestor-or-self::*[1]/@xo:id}" xo-attribute="{name()}" onfocus="this.value=(scope.value || this.value)">
			<xsl:attribute name="maxLength">
				<xsl:value-of select="$schema/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="key('color',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">color</xsl:when>
					<xsl:when test="key('number',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">number</xsl:when>
					<xsl:when test="key('year',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">number</xsl:when>
					<xsl:when test="key('datetime',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">datetime-local</xsl:when>
					<xsl:when test="key('date',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">date</xsl:when>
					<xsl:otherwise>text</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="key('year',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">
					<xsl:attribute name="minValue">1900</xsl:attribute>
					<xsl:attribute name="maxValue">2099</xsl:attribute>
					<xsl:attribute name="step">1</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!--<xsl:attribute name="pattern">
				<xsl:choose>
					<xsl:when test="key('money',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">\${\d}{1,3}.00</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>-->
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="widget:attributes" select="."/>
		</input>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('textarea',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="current" select="."/>
		<textarea class="form-control" id="{$schema/@xo:id}" rows="3" placeholder="" required="" xo-scope="{$current/../@xo:id}" xo-attribute="{name()}">
			<xsl:attribute name="style">
				<xsl:apply-templates mode="style" select="key('styles',concat(../@xo:id,'::',local-name()))"/>
			</xsl:attribute>
			<xsl:apply-templates mode="widget:attributes" select="."/>
			<xsl:apply-templates select="."/>
		</textarea>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('yesNo',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<div class="btn-group" role="group" style="position:relative;">
			<button type="button" class="btn btn-outline-success" xo-scope="{../@xo:id}" xo-attribute="{name()}" onclick="scope.toggle('1')">
				<xsl:if test=".='1'">
					<xsl:attribute name="class">btn btn-success</xsl:attribute>
				</xsl:if>
				<xsl:text>Sí</xsl:text>
			</button>
			<button type="button" class="btn btn-outline-danger" xo-scope="{../@xo:id}" xo-attribute="{name()}" onclick="scope.toggle(0)">
				<xsl:if test=".='0'">
					<xsl:attribute name="class">btn btn-danger</xsl:attribute>
				</xsl:if>
				<xsl:text>No</xsl:text>
			</button>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('radiogroup',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="data_set" select="$schema/px:Entity/data:rows"/>
		<xsl:variable name="current" select="."/>

		<xsl:for-each select="$data_set/xo:r">
			<xsl:variable name="option" select="."/>
			<xsl:variable name="checked">
				<xsl:if test="$current = @value">checked</xsl:if>
			</xsl:variable>
			<div class="form-check form-check-inline" xo-scope="{$current/../@xo:id}">
				<input class="form-check-input" type="radio" value="{@value}" id="{../@xo:id}_{position()}" xo-attribute="{name($current)}">
					<xsl:for-each select="$schema/px:Mappings/px:Mapping">
						<xsl:attribute name="onclick">
							<xsl:text/>scope.parentNode.set('<xsl:value-of select="@Referencer"/>','<xsl:value-of select="$option/@*[name()=current()/@Referencee]"/>');<xsl:text/>
						</xsl:attribute>
					</xsl:for-each>
					<xsl:if test="$current = @value">
						<xsl:attribute name="checked"/>
					</xsl:if>
				</input>
				<label class="form-check-label" for="{../@xo:id}_{position()}">
					<xsl:value-of select="@meta:text"/>
				</label>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:key name="related_values" match="px:Mappings/px:Mapping/@Referencer" use="concat(ancestor::px:Entity[1]/@xo:id,'::',ancestor::px:Association[1]/@AssociationName,'::',.)"/>
	<!--<xsl:key name="related_values" match="data:rows/xo:r/@*" use="concat(ancestor::px:Entity[1]/@xo:id,'::',ancestor::px:Entity[1]/px:Record/px:Association[1]/@AssociationName,'::',name())"/>-->

	<xsl:template mode="widget" match="@*[key('association',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="value" select="."/>
		<xsl:variable name="current" select="."/>
		<div class="input-group">
			<!--Referencias: <xsl:value-of select="count(key('related_values',concat(ancestor::px:Entity[1]/@xo:id,'::',name(),'::','Rol')))"/>-->
			<xsl:variable name="related_values" select="../@*[key('related_values',concat(ancestor::px:Entity[1]/@xo:id,'::',name(current()),'::',name()))]"/>
			<br/>
			<xsl:value-of select="name($related_values)"/>: <xsl:value-of select="$related_values"/>
			<br/>Conteo: <xsl:value-of select="count($schema/px:Entity/data:rows/*)"/>
			<br/>Selection: <xsl:value-of select="$schema/px:Entity/data:rows/*[@meta:text=current()]/@meta:text"/>
			<br/>Value: <xsl:value-of select="name($value)"/>
			<br/>Current: <xsl:value-of select="name($schema)"/>
			<xsl:apply-templates mode="widget" select="$schema/px:Entity/@xo:id">
				<xsl:with-param name="dataset" select="$schema/px:Entity/data:rows/*"/>
				<xsl:with-param name="selection" select="$schema/px:Entity/data:rows/*[@meta:text=current()]"/>
				<xsl:with-param name="target" select="$related_values"/>
			</xsl:apply-templates>
			<!--<xsl:for-each select="$schema/px:Mappings/px:Mapping">
				<xsl:choose>
					<xsl:when test="position()=1">
						<span>
						<xsl:apply-templates mode="widget" select="$dataset/@*[name()=current()/@Referencer]">
							<xsl:with-param name="data_set" select="$schema/px:Entity/data:rows"/>
							<xsl:with-param name="schema" select="current()"/>
							<xsl:with-param name="dataset" select="$dataset"/>
						</xsl:apply-templates>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<div class="input-group-append">
							<xsl:apply-templates mode="widget" select="$dataset/@*[name()=current()/@Referencer]">
								<xsl:with-param name="data_set" select="$schema/px:Entity/data:rows"/>
								<xsl:with-param name="schema" select="current()"/>
								<xsl:with-param name="dataset" select="$dataset"/>
							</xsl:apply-templates>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>-->
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('readonly',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="current" select="."/>
		<input class="form-control" type="text" aria-label="Disabled input example" disabled="" readonly="">
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</input>
	</xsl:template>
</xsl:stylesheet>