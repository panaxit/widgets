<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widget/form"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:container="http://panax.io/layout/container"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="px form datagrid combobox control data"
>
	<xsl:key name="entity" match="px:Entity" use="@xo:id"/>
	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'/',@Name)"/>
	<xsl:key name="entity" match="px:Entity[@control:type='datagrid:control']" use="concat('datagrid:',@Schema,'/',@Name)"/>
	<xsl:key name="datagrid:item" match="px:Entity[@controlType='datagridView']/*[local-name()='layout']//*" use="@xo:id"/>

	<xsl:key name="entity" match="px:Entity[@control:type='form:control']" use="concat('form:',@Schema,'/',@Name)"/>

	<!--Routes-->
	<xsl:key name="routes" match="px:Association/px:Entity/px:Routes/px:Route/@Method" use="concat(ancestor::px:Entity[2]/@xo:id,'::meta:',ancestor::px:Association[1]/@AssociationName)"/>
	<xsl:key name="routes" match="px:Entity/px:Routes/px:Route/@Method" use="ancestor::px:Entity[1]/@xo:id"/>

	<!--Datarows?-->
	<xsl:key name="data-rows" match="data:rows/@xsi:nil" use="ancestor::px:Entity[1]/@xo:id"/>
	<xsl:key name="data-rows" match="data:rows/xo:r/@xo:id" use="ancestor::px:Entity[1]/@xo:id"/>
	
	<!--Layout-->
	<xsl:key name="layout" match="px:Entity/*[local-name()='layout']/*/@Name|px:Entity[1]/*[local-name()='layout']/*[not(@Name)]/@xo:id" use="ancestor::px:Entity[1]/@xo:id"/>

	<!--Datasets-->
	<xsl:key name="dataset" match="px:Entity[not(data:rows)]/@xo:id" use="concat(../@xo:id,'::',../@xo:id)"/>
	<xsl:key name="dataset" match="data:rows[not(@xsi:nil) and not(xo:r)]/@xo:id" use="concat(../../@xo:id,'::',../../@xo:id)"/>
	<xsl:key name="dataset" match="data:rows/@xsi:nil" use="concat(../../@xo:id,'::',../../@xo:id)"/>
	<xsl:key name="dataset" match="data:rows/xo:r/@xo:id" use="concat(../../../@xo:id,'::',../../../@xo:id)"/>
	<xsl:key name="dataset" match="px:Association/px:Entity/data:rows/xo:r/@meta:text" use="concat(ancestor::px:Entity[2]/@xo:id,'::meta:',ancestor::px:Association[1]/@AssociationName)"/>

	<xsl:key name="dataset" match="xo:r/@*" use="concat(../@xo:id,'::','xo:id')"/>
	<xsl:key name="dataset" match="xo:r/@*" use="concat(../@xo:id,'::',name())"/>
	<xsl:key name="dataset" match="xo:r/xo:f/@Name" use="concat(../@xo:id,'::',.)"/>
	<xsl:key name="dataset" match="xo:r/px:Association/@AssociationName" use="concat(../../@xo:id,'::meta:',.)"/>
	
	<!--Schema-->
	<xsl:key name="schema" match="px:Record/px:Field/@Name" use="concat(ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="schema" match="px:Record/px:Association/@AssociationName" use="concat(ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>

	<!--widgets-->
	<xsl:key name="widget" match="*[@control:type]/@*" use="concat(substring-before(../@control:type,':'),':',ancestor::px:Entity[1]/@xo:id)"/>

	<xsl:key name="widget" match="*[@control:type][@Schema]/@Name" use="concat(substring-before(../@control:type,':'),':',ancestor::px:Entity[1]/@xo:id,'::',../@Schema,'/',.)"/>
	<xsl:key name="widget" match="*[@control:type][not(@Schema)][not(@AssociationName)]/@Name" use="concat(substring-before(../@control:type,':'),':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="*[@control:type][not(@Schema)]/@AssociationName" use="concat(substring-before(../@control:type,':'),':',ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>

	<xsl:key name="widget" match="*[@controlType][@Schema]/@Name" use="concat(../@controlType,':',ancestor::px:Entity[1]/@xo:id,'::',../@Schema,'/',.)"/>
	<xsl:key name="widget" match="*[@controlType][not(@Schema)][not(@AssociationName)]/@Name" use="concat(../@controlType,':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="*[@controlType][not(@Schema)]/@AssociationName" use="concat(../@controlType,':',ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>

	<xsl:key name="widget" match="*[@DataType][@Schema]/@Name" use="concat(../@DataType,':',ancestor::px:Entity[1]/@xo:id,'::',../@Schema,'/',.)"/>
	<xsl:key name="widget" match="*[@DataType][not(@Schema)][not(@AssociationName)]/@Name" use="concat(../@DataType,':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="*[@DataType][not(@Schema)]/@AssociationName" use="concat(../@DataType,':',ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>
	<xsl:key name="widget" match="px:Field[@DataType='filePath']/@Name" use="concat('file',':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>

	<xsl:key name="widget" match="px:Field[starts-with(@control:type,'string:') and @DataLength&gt;255]/@Name" use="concat('textarea',':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="px:Field[starts-with(@control:type,'string:') and @DataLength=-1]/@Name" use="concat('textarea',':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="px:Field[starts-with(@control:type,'bit:')]/@Name" use="concat('yesNo',':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="px:Field[starts-with(@control:type,'integer:')]/@Name" use="concat('number',':',ancestor::px:Entity[1]/@xo:id,'::',.)"/>

	<xsl:key name="widget" match="px:Record/px:Field[@mode='readonly']/@Name" use="concat('readonly:',ancestor::px:Entity[1]/@xo:id,'::',.)"/>
	<xsl:key name="widget" match="px:Record/px:Association[@mode='readonly']/@AssociationName" use="concat('readonly:',ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>

	<xsl:key name="widget" match="px:Record/px:Association[@Type='belongsTo']/@AssociationName" use="concat('combobox:',ancestor::px:Entity[1]/@xo:id,'::meta:',.)"/>

	<xsl:key name="widget" match="container:fieldSet/@Name" use="concat('fieldset:',ancestor::px:Entity[1]/@xo:id,'::',.)"/>

	<xsl:key name="widget" match="px:Record/px:Association[@Type='hasMany']/@AssociationName" use="concat('fieldset:',ancestor::px:Entity[1]/@xo:id,'::',.)"/>

	<xsl:key name="widget" match="px:Record/px:Association[@Type='hasOne']/@AssociationName" use="concat('fieldset:',ancestor::px:Entity[1]/@xo:id,'::',.)"/>

	<xsl:key name="form:item" match="px:Entity[@control:type='form:control']/*[local-name()='layout']//*" use="@xo:id"/>


</xsl:stylesheet>