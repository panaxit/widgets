<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widget/form"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"
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
		<xsl:for-each select="$dataset/ancestor-or-self::*[1]/xo:r/@xo:id">
			<form class="needs-validation" novalidate="">
				<div class="row g-3">
					<xsl:apply-templates mode="form:field" select="$layout">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="dataset" select="ancestor-or-self::xo:r/@*"/>
					</xsl:apply-templates>
				</div>
			</form>
			<hr/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="form:field-header" match="@*">
		<xsl:apply-templates mode="headerText" select="key('reference',concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'::header::',name(..),'::',../@Name))"/>
	</xsl:template>

	<xsl:template mode="form:field-body-prepend" match="@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="form:field-body-append" match="@*">
		<xsl:text>&#160;</xsl:text>
	</xsl:template>

	<xsl:template mode="form:field" match="@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="value" select="$dataset/@*[local-name()=current()/@Name]|$schema[self::px:Association[not(@Type='belongsTo')]]/px:Entity"/>
		<div class="mb-3 row">
			<label class="col-sm-2 col-form-label">
				<xsl:apply-templates mode="form:field-header" select="current()">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
				<xsl:text>: </xsl:text>
			</label>
			<div class="col-sm-10">
				<xsl:apply-templates mode="form:field-body" select="current()">
					<xsl:with-param name="field_ref" select="$schema"/>
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="form:field" match="*[key('association',@xo:id)][key('foreignTable',concat(ancestor::px:Entity[1]/@xo:id,'::',@Name))]/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="value" select="$dataset/@*[local-name()=current()/@Name]|$schema[../self::px:Association[not(@Type='belongsTo')]]/../px:Entity/@xo:id"/>
		<xsl:variable name="ref_field" select="$dataset/parent::*[not(@Name)]/@*[local-name()=current()]|$dataset/../px:Association[@AssociationName=current()]/@AssociationName"/>
		<div class="mb-3 row" xo-sections="{$dataset/@xo:id}">
			<fieldset>
				<legend>
					<xsl:apply-templates mode="form:field-header" select="current()"/>
					<xsl:text>: </xsl:text>
				</legend>
				<xsl:apply-templates mode="widget" select="$ref_field">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="reference" select="$schema/self::Association"/>
				</xsl:apply-templates>
			</fieldset>
		</div>
	</xsl:template>

	<xsl:template mode="form:field-body" match="@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="label">
			<xsl:apply-templates mode="headerText" select="."/>
		</xsl:variable>
		<div>
			<xsl:attribute name="style">
				<xsl:text/>min-width: calc(<xsl:value-of select="concat(string-length($label)+1,'ch')"/> + 6rem);<xsl:text/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:text>form-floating input-group</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates mode="widget" select="current()"/>
			<label for="{../@xo:id}" class="floating-label">
				<xsl:value-of select="$label"/>:
			</label>
		</div>
	</xsl:template>

	<xsl:template mode="form:field-body" match="field:ref/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="ref_field" select="$dataset[name()=current()]|$dataset[name()=current()]"/>
		<xsl:choose>
			<xsl:when test="count($ref_field|current())=1">
				<xsl:apply-templates mode="widget" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="form:field-body" select="$ref_field">
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="form:field-body" match="association:ref/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:variable name="ref_field" select="$dataset[name()=current()]|$dataset[name()=concat('meta:',current()[parent::association:ref])]"/>
		<xsl:choose>
			<xsl:when test="count($ref_field|current())=1">
				<xsl:apply-templates mode="widget" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="form:field-body" select="$ref_field">
					<xsl:with-param name="schema" select="$schema"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="form:field-body" match="container:*/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<div class="input-group">
			<xsl:for-each select="../*/@Name">
				<div class="input-group-append">
					<xsl:apply-templates mode="form:field-body" select="current()">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="dataset" select="$dataset"/>
					</xsl:apply-templates>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--<xsl:template mode="form:field-body" match="xo:*/@*">
	</xsl:template>-->

</xsl:stylesheet>