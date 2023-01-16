<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widget/form"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="px form datagrid combobox xsi"
>
	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'/',@Name)"/>
	<xsl:key name="entity" match="px:Entity[@xsi:type='datagrid:control']" use="concat('datagrid:',@Schema,'/',@Name)"/>
	<xsl:key name="datagrid:item" match="px:Entity[@controlType='datagridView']/*[local-name()='layout']//*" use="@xo:id"/>	
	
	<xsl:key name="entity" match="px:Entity[@xsi:type='form:control']" use="concat('form:',@Schema,'/',@Name)"/>
	<xsl:key name="form:item" match="px:Entity[@xsi:type='form:control']/*[local-name()='layout']//*" use="@xo:id"/>
</xsl:stylesheet>