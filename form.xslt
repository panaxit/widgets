<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widget/form"
  exclude-result-prefixes="xo state xsl form data px meta"
>
	<xsl:import href="../keys.xslt"/>

	<!--<xsl:key name="readonly" match="@readonly:*" use="concat(@xo:id,'::',local-name())"/>-->

	<xsl:template mode="form:widget" match="@*">
		<xsl:param name="headers" select="current()"/>
		<xsl:param name="dataset" select="current()"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="layout" select="$schema"/>
		<xsl:param name="selection" select="node-expected"/>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<xsl:apply-templates mode="form:body" select="$layout">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset/ancestor-or-self::*[1]/descendant-or-self::xo:r/@xo:id"/>
				</xsl:apply-templates>
			</div>
		</form>
	</xsl:template>

	<xsl:template mode="form:header" match="@*">
		<xsl:apply-templates mode="headerText" select="key('reference',concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'::header::',name(..),'::',../@Name))"/>
	</xsl:template>

	<xsl:template mode="form:field-prepend" match="@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="form:field-append" match="@*">
		<xsl:text>&#160;</xsl:text>
	</xsl:template>

	<!--<xsl:template mode="form:field" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="."/>
		<xsl:variable name="ref_field" select="$dataset/parent::*[not(@Name)]/@*[local-name()=current()]|$dataset/../@Name[.=current()]"/>
		<xsl:choose>
			<xsl:when test="count($ref_field|current())=1">
				<xsl:apply-templates mode="form:field-prepend" select="."/>
				<xsl:apply-templates mode="widget" select="."/>
				<xsl:apply-templates mode="form:field-append" select="."/>
			</xsl:when>
			<xsl:otherwise>
				<div class="mb-3 row">
					<label class="col-sm-2 col-form-label">
						<xsl:apply-templates mode="form:header" select="current()"/>
						<xsl:text>: </xsl:text>
					</label>
					<div class="col-sm-10">
						<xsl:apply-templates mode="form:field" select="$ref_field">
							<xsl:with-param name="dataset" select="current()"/>
						</xsl:apply-templates>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->

	<xsl:template mode="form:body" match="@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="value" select="$dataset/@*[local-name()=current()/@Name]|$schema[self::px:Association[not(@Type='belongsTo')]]/px:Entity"/>
		<div class="mb-3 row">
			<label class="col-sm-2 col-form-label">
				<xsl:apply-templates mode="form:header" select="current()"/>
				<xsl:text>: </xsl:text>
			</label>
			<div class="col-sm-10">
				<xsl:if test="not($dataset)">
					<xsl:attribute name="class">col-sm-10 skeleton skeleton-text skeleton-text__body</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates mode="widget" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="form:body" match="*[key('association',@xo:id)][key('foreignTable',concat(ancestor::px:Entity[1]/@xo:id,'::',@Name))]/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="value" select="$dataset/@*[local-name()=current()/@Name]|$schema[../self::px:Association[not(@Type='belongsTo')]]/../px:Entity/@xo:id"/>
		<xsl:variable name="ref_field" select="$dataset/parent::*[not(@Name)]/@*[local-name()=current()]|$schema[.=current()]/../@AssociationName"/>
		<div class="mb-3 row" xo-sections="{$dataset/@xo:id}">
			<fieldset>
				<legend>
					<xsl:apply-templates mode="form:header" select="current()"/>
					<xsl:text>: </xsl:text>
				</legend>
				<xsl:apply-templates mode="widget" select="$ref_field">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="reference" select="$schema/self::Association"/>
				</xsl:apply-templates>
			</fieldset>
		</div>
	</xsl:template>

</xsl:stylesheet>