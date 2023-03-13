<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:source="http://panax.io/fetch/request"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:session="http://panax.io/session"
  xmlns:state="http://panax.io/state"
  xmlns:px="http://panax.io"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:widget="http://panax.io/widget"
  xmlns:modal="http://panax.io/widget/modal"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:autocompleteBox="http://panax.io/widget/autocompleteBox"
  exclude-result-prefixes="xo source data meta session state px widget modal"
>
	<xsl:import href="panax/prompt.xslt"/>
	<xsl:import href="panax/combobox.xslt"/>
	<xsl:import href="panax/autocompleteBox.xslt"/>

	<xsl:key name="entity" match="Routine" use="@xo:id"/>
	<xsl:key name="widget" match="Routine/parameter[@controlType]/@name" use="concat(../@controlType,':',ancestor::Routine[1]/@xo:id,'::',.)"/>

	<xsl:template match="@*" mode="widget:attributes"/>
	
	<xsl:template mode="widget" match="@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="current" select="."/>
		<xsl:variable name="schema" select=".."/>
		<input type="text" class="form-control {$class}" id="{$schema/@xo:id}" placeholder="" required="" xo-scope="{ancestor-or-self::*[1]/@xo:id}" xo-attribute="{name()}" onfocus="this.value=(scope.value || this.value)" autocomplete="off" pattern="yyyy-mm-dd">
			<xsl:attribute name="maxlength">
				<xsl:value-of select="$schema/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="size">
				<xsl:value-of select="$schema/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="key('widget',concat('color:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">color</xsl:when>
					<xsl:when test="key('widget',concat('number:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">number</xsl:when>
					<xsl:when test="key('widget',concat('year:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">number</xsl:when>
					<xsl:when test="key('widget',concat('datetime:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">datetime-local</xsl:when>
					<xsl:when test="key('widget',concat('date:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">date</xsl:when>
					<xsl:when test="key('widget',concat('time:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">time</xsl:when>
					<xsl:when test="key('widget',concat('password:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">password</xsl:when>
					<xsl:otherwise>text</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="key('widget',concat('year:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@name))">
					<xsl:attribute name="minValue">1900</xsl:attribute>
					<xsl:attribute name="maxValue">2099</xsl:attribute>
					<xsl:attribute name="step">1</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="widget:attributes" select="."/>
		</input>		
	</xsl:template>

	<xsl:template mode="widget" match="parameter[@controlType='combobox']/@value">
		<xsl:apply-templates mode="combobox:widget" select=".">
			<xsl:with-param name="dataset" select="../data:rows/xo:r/@meta:text"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="parameter[@controlType='autocompleteBox']/@value">
		<xsl:apply-templates mode="autocompleteBox:widget" select=".">
			<xsl:with-param name="dataset" select="../data:rows/xo:r/@meta:text"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="autocompleteBox:attributes" match="*[data:rows]/@*" priority="-1">
		<xsl:attribute name="list">
			<xsl:value-of select="concat('datalist_',../@xo:id,'_',local-name())"/>
		</xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
