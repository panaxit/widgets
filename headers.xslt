﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:sitemap="http://panax.io/sitemap"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io/entity"
  xmlns:data="http://panax.io/source"
  xmlns:form="http://panax.io/widgets/form"
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"
  exclude-result-prefixes="xo xsl sitemap layout px data form"
>

	<xsl:template mode="headerText" match="@*">
		<xsl:param name="dataset" select="ancestor::px:Entity[1]/px:Record/px:Field/@Name|ancestor::px:Entity[1]/px:Record/px:Association/@AssociationName"/>
		<xsl:variable name="ref_field" select="$dataset[.=current()]|$dataset[name()=current()[parent::field:ref]]|$dataset[name()=concat('meta:',current()[parent::association:ref])]"/>
		<xsl:choose>
			<xsl:when test="count($ref_field|current())=1">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="headerText" select="$ref_field"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="headerText" match="*[@headerText]/@*">
		<xsl:value-of select="../@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="xo:r/@*">
		<xsl:param name="dataset" select="ancestor::px:Entity[1]/px:Record/*/@Name"/>
		<xsl:variable name="ref_field" select="$dataset[.=local-name(current())]"/>
		<xsl:choose>
			<xsl:when test="count($ref_field|current())=1">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="headerText" select="$ref_field"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>