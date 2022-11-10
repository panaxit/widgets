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
	<xsl:import href="../values.xslt"/>
	<xsl:import href="../headers.xslt"/>

	<!--<xsl:key name="readonly" match="@readonly:*" use="concat(@xo:id,'::',local-name())"/>-->

	<xsl:key name="form:widget" match="dummy" use="@xo:id"/>

	<xsl:template match="/">
		<div class="container-fluid" style="margin-top:0px;">
			<xsl:apply-templates mode="widget" select="px:Entity/@xo:id"/>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('form:widget',concat(ancestor::*[@meta:type='entity'][1]/@xo:id,'.',name()))]">
		<xsl:param name="dataset" select="../data:rows/xo:r"/>
		<xsl:param name="layout" select="../data:rows/xo:r[1]/@*"/>
		<xsl:param name="selection" select="dummy"/>
		<div class="row g-5" style="margin-top:0px;">
			<div class="col-md-9 col-lg-11">
				<xsl:apply-templates mode="form:widget" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
					<xsl:with-param name="selection" select="$selection"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="form:widget" match="@*">
		<xsl:param name="dataset" select="current()"/>
		<xsl:param name="schema" select="dummy"/>
		<xsl:param name="layout" select="$schema"/>
		<xsl:param name="selection" select="dummy"/>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<xsl:apply-templates mode="form:body" select="$layout">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>
			</div>
		</form>
	</xsl:template>

	<xsl:template mode="form:header" match="@*">
		<xsl:apply-templates mode="headerText" select="key('reference',concat(ancestor::*[@meta:type='entity'][1]/@xo:id,'::header::',name(..),'::',../@Name))"/>
	</xsl:template>

	<xsl:template mode="form:field" match="@*">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:value-of select="name(..)"/>
		<xsl:apply-templates mode="widget" select="key('reference',concat($dataset,'::body::',name(..),'::',../@Name))"/>
	</xsl:template>

	<xsl:template mode="form:body" match="@*">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="schema" select="dummy"/>
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

	<xsl:template mode="form:body" match="*[key('association',@xo:id)][key('foreignTable',concat(ancestor::px:Entity[1]/@xo:id,'::',@Name))]">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="schema" select="dummy"/>
		<xsl:variable name="value" select="$dataset/@*[name()=current()/@Name]|$schema[self::px:Association[not(@Type='belongsTo')]]/px:Entity"/>
		<div class="mb-3 row" xo-sections="{$dataset/@xo:id}">
			<fieldset>
				<legend>
					<xsl:apply-templates mode="headerText" select="$schema">
						<xsl:with-param name="schema" select="$schema"/>
					</xsl:apply-templates>
				</legend>
				<xsl:apply-templates mode="widget" select="$value">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="reference" select="$schema/self::Association"/>
				</xsl:apply-templates>
			</fieldset>
		</div>
	</xsl:template>

</xsl:stylesheet>