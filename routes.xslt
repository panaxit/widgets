<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout_datagrid="http://panax.io/layout"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:data="http://panax.io/source"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:meta="http://panax.io/metadata"
  xmlns:custom="http://panax.io/custom"
  xmlns:px="http://panax.io/entity"
  xmlns:route="http://panax.io/routes"
  exclude-result-prefixes="xo state xsl meta custom data route"
>
	<xsl:template mode="route:widget" match="*/@*">
		<xsl:param name="context" select="node-expected"/>
		<xsl:variable name="route" select="current()"/>
		<xsl:variable name="identity" select="$context/@meta:id"/>
		<xsl:variable name="reference">
			<xsl:choose>
				<xsl:when test="$identity">
					<xsl:value-of select="concat(':',$identity)"/>
				</xsl:when>
				<xsl:when test="$context/@meta:value">
					<xsl:value-of select="concat('/',$context/@meta:value)"/>
				</xsl:when>
				<xsl:when test="$context/self::xo:r">
					<xsl:value-of select="concat('@',$context/self::xo:r/@xo:id)"/>
				</xsl:when>
				<xsl:when test="$context/parent::px:Association">
					<xsl:value-of select="concat('@',$context/data:rows/@xo:id)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="$context">
			<a href="#{ancestor-or-self::px:Entity[1]/@Schema}/{ancestor-or-self::px:Entity[1]/@Name}{$reference}~{$route/../@Method}">
				<xsl:apply-templates mode="widget" select="$route">
					<xsl:with-param name="context" select="$context"/>
				</xsl:apply-templates>
			</a>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="px:Route[@Method='edit']/@*" priority="1">
		<xsl:param name="context" select="node-expected"/>
		<xsl:variable name="route" select="current()"/>
		<xsl:variable name="identity" select="$context/@meta:id"/>
		<xsl:variable name="reference">
			<xsl:choose>
				<xsl:when test="$identity">
					<xsl:value-of select="concat(':',$identity)"/>
				</xsl:when>
				<xsl:when test="$context/@meta:value">
					<xsl:value-of select="concat('/',$context/@meta:value)"/>
				</xsl:when>
				<xsl:when test="$context/self::xo:r">
					<xsl:value-of select="concat('@',$context/self::xo:r/@xo:id)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="$context[self::px:Entity or self::data:rows or self::xo:r]">
			<button class="btn btn-sm btn-primary" onclick="event.preventDefault(); px.navigateTo(parentNode.getAttribute('href'),'{ancestor-or-self::*[self::data:rows or self::xo:r][1]/@xo:id}');">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
					<path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
					<path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
				</svg>
			</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="px:Route[@Method='delete']/@*" priority="1">
		<xsl:param name="context" select="node-expected"/>
		<xsl:variable name="route" select="current()"/>
		<xsl:for-each select="$context[self::px:Entity or self::data:rows or self::xo:r]">
			<xo-listener attribute="state:delete"/>
			<button class="btn btn-sm btn-danger" onclick="scope.remove(); event.preventDefault();">
				<!--<xsl:if test="not($identity!='')">
						<xsl:attribute name="onclick">scope.remove()</xsl:attribute>
					</xsl:if>-->
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
					<path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
					<path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
				</svg>
			</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="px:Route[@Method='add']/@*" priority="1">
		<xsl:param name="context" select="node-expected"/>
		<xsl:variable name="route" select="current()"/>
		<xsl:for-each select="$context[self::px:Entity or self::data:rows or self::xo:r]">
			<xsl:choose>
				<xsl:when test="parent::px:Association">
					<button type="button" class="btn btn-success btn-sm" onclick="event.preventDefault(); px.navigateTo(parentNode.getAttribute('href'),'{ancestor-or-self::*[@meta:type='entity'][1]/data:rows/@xo:id}')" xo-scope="{data:rows/@xo:id}">Agregar registro</button>
				</xsl:when>
				<xsl:otherwise>
					<button class="btn btn-success" onclick="event.preventDefault(); px.navigateTo(parentNode.getAttribute('href'),'{ancestor-or-self::*[@meta:type='entity'][1]/data:rows/@xo:id}')" xo-scope="{data:rows/@xo:id}">Nuevo registro</button>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="px:Route[ancestor-or-self::*/@mode='readonly']/@*" priority="2">
		<xsl:text></xsl:text>
	</xsl:template>
</xsl:stylesheet>