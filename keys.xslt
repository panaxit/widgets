<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io/entity"
  xmlns:meta="http://panax.io/metadata"
  xmlns:form="http://panax.io/widget/form"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:autocompleteBox="http://panax.io/widget/autocompleteBox"
  xmlns:file="http://panax.io/widget/file"
  xmlns:percentage="http://panax.io/widget/percentage"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"
  exclude-result-prefixes="xo xsi px meta form datagrid combobox file field container association"
>
	<xsl:include href="../keys.xslt"/>
	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'.',@Name)"/>
	<xsl:key name="entity" match="px:Entity[@xsi:type='datagrid:control']" use="concat('datagrid:',@Schema,'.',@Name)"/>
	<xsl:key name="entity" match="px:Entity[@xsi:type='datagrid:control']" use="'datagrid:widget'"/>
	<xsl:key name="entity" match="px:Association/px:Entity" use="concat(ancestor::px:Entity[1]/@xo:id,'.meta:',ancestor::px:Association[1]/@AssociationName)"/>

	<xsl:key name="datagrid:widget" match="px:Entity/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="form:widget" match="px:Entity[@control:type='form:control']/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="form:widget" match="px:Entity[@Type='hasOne']/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>

	<xsl:key name="autocompleteBox:widget" match="px:Entity[@control:type='combobox:control']/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="autocompleteBox:widget" match="xo:r/@meta:*" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="file:widget" match="px:Field[@DataType='file']" use="concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'.',@Name)"/>
	<xsl:key name="file:widget" match="px:Field[@DataType='filePath']" use="concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'.',@Name)"/>
	<xsl:key name="percentage:widget" match="px:Field[@DataType='percent']" use="concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'.',@Name)"/>


</xsl:stylesheet>