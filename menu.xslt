<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dropdown="http://xover.dev/widgets/dropdown"
xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:template match="/">
		<div>
			<xsl:apply-templates mode="dropdown:widget"></xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="@*|*" mode="dropdown:widget">
		<ul class="navbar-nav align-items-center">
			<xsl:apply-templates mode="dropdown:item" select="*"/>
		</ul>
	</xsl:template>

	<xsl:template match="@*|*" mode="dropdown:menu">
		<ul class="dropdown-menu">
			<xsl:apply-templates mode="dropdown:item" select="*"/>
		</ul>
	</xsl:template>

	<xsl:template match="*" mode="dropdown:icon-badge"/>

	<xsl:template match="messages[item]" mode="dropdown:icon-badge">
		<span class="position-absolute top-0 translate-middle badge rounded-pill bg-danger">
			<xsl:value-of select="count(item)"/>
			<span class="visually-hidden">unread messages</span>
		</span>
	</xsl:template>


	<xsl:template match="@*|*" mode="dropdown:icon"/>

	<xsl:template mode="dropdown:icon-attributes" match="@*|*"/>

	<xsl:template mode="dropdown:icon-attributes" match="*[contains(@class,'btn')]">
		<xsl:attribute name="fill">none</xsl:attribute>
		<xsl:attribute name="stroke">currentColor</xsl:attribute>
		<xsl:attribute name="stroke-width">2</xsl:attribute>
		<xsl:attribute name="stroke-linecap">round</xsl:attribute>
		<xsl:attribute name="stroke-linejoin">round</xsl:attribute>
		<xsl:attribute name="class">feather feather-grid</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[@icon]" mode="dropdown:icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-file-text text-primary" viewBox="0 0 16 16" style="margin-right: 5px">
			<xsl:apply-templates mode="dropdown:icon-attributes" select="."/>
			<use href="#{@icon}"/>
		</svg>
	</xsl:template>

	<xsl:template match="*" mode="dropdown:item-title">
		<xsl:choose>
			<xsl:when test="@title">
				<xsl:apply-templates select="@title"/>
			</xsl:when>
			<xsl:when test="not(@icon)">
				<xsl:value-of select="name()"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|*" mode="dropdown:item">
		<xsl:variable name="dropdown">
			<xsl:if test="*">dropdown</xsl:if>
		</xsl:variable>
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@class">
					<xsl:value-of select="@class"/>
				</xsl:when>
				<xsl:otherwise>dropdown-item</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li class="nav-item {$dropdown} {local-name()}-type">
			<xsl:apply-templates mode="dropdown:item-attributes" select="."/>
			<a class="nav-link {$dropdown}-toggle {$class}" href="#" role="button">
				<xsl:if test="$dropdown!=''">
					<xsl:attribute name="aria-expanded">false</xsl:attribute>
					<xsl:attribute name="data-bs-toggle">dropdown</xsl:attribute>
				</xsl:if>
				<xsl:copy-of select="@href"/>
				<xsl:apply-templates mode="dropdown:icon" select="."/>
				<xsl:apply-templates mode="dropdown:icon-badge" select="."/>
				<xsl:apply-templates mode="dropdown:item-title" select="."/>
			</a>
			<xsl:if test="$dropdown!=''">
				<xsl:apply-templates mode="dropdown:menu" select="."/>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="_" mode="dropdown:item">
		<li class="nav-item py-2 py-lg-1 col-12 col-lg-auto">
			<div class="vr d-none d-lg-flex h-100 mx-lg-2 text-white"></div>
			<hr class="d-lg-none my-2 text-white-50"/>
		</li>
	</xsl:template>
	
	<xsl:template match="*" mode="dropdown:item-attributes"></xsl:template>
</xsl:stylesheet>