<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xsl"
>	<xsl:template name="format">
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="mask">'$#,##0.00###;-$#,##0.00###'</xsl:param>
		<xsl:param name="value_for_invalid"></xsl:param>
		<xsl:choose>
			<xsl:when test="number($value)=$value">
		<xsl:value-of select="format-number($value,$mask)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value_for_invalid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>