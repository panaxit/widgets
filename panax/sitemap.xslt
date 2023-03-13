<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:xo="http://panax.io/xover"
exclude-result-prefixes="#default session sitemap shell state"
>
	<xsl:import href="../keys.xslt"/>
	<xsl:import href="shell.xslt"/>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>
	<xsl:key name="item" match="dummy" use="'#any'"/>
	<xsl:key name="menu-item" match="dummy" use="'#any'"/>

	<xsl:template match="text()"/>

	<xsl:template match="/">
		<xsl:apply-templates mode="sitemap:widget" select="*/@xo:id"/>
	</xsl:template>

	<xsl:template mode="sitemap:widget" match="@*">
		<aside class="sidebar">
			<script>
				<![CDATA[xo.listener.on('click', function(){ 
			    if (!event.srcElement.closest('aside,.menu_toggle')) {
			        toggleSidebar(false);
				}
			})]]>
			</script>			
			<style>
				<![CDATA[
.menu_toggle {
    color: var(--menu-toggler,currentColor) !important;
    cursor: pointer
}

aside.sidebar {
	max-width: var(--sitemap-width, 33%);
}

aside.sidebar li {
    font-size: 1rem;
    display: block;
}

aside.sidebar a {
    padding: 8px 8px 8px 8px;
    transition: 0.3s;
}

aside.sidebar ul {
	height:100%; overflow-y:scroll; overflow-x: clip;
}]]>
			</style>
			<header>
				<xsl:apply-templates mode="sitemap:header" select="current()"/>
			</header>
			<ul class="sidebar-nav sidebar-dropdown">
				<xsl:apply-templates mode="sitemap:body" select="ancestor-or-self::*[1]/*"/>
			</ul>
			<xsl:apply-templates mode="sitemap:footer" select="current()"/>
		</aside>
	</xsl:template>

	<xsl:template mode="sitemap:body" match="key('item','#any')">
		<xsl:variable name="type">
			<xsl:if test="key('menu-item',@xo:id)">menu</xsl:if>
		</xsl:variable>
		<xsl:variable name="collapsed_status">
			<xsl:if test="1=1">collapsed</xsl:if>
		</xsl:variable>
		<li class="sidebar-item {$type}">
			<a href="javascript:void(0)" class="sidebar-link {$collapsed_status}" onclick="classList.toggle('collapsed'); parentElement.querySelector(':scope > ul').classList.toggle('show')">
				<xsl:apply-templates mode="sitemap:target-href" select="."/>
				<xsl:if test="$type='menu'">
					<xsl:attribute name="data-toggle">collapse</xsl:attribute>
					<!--<xsl:attribute name="onclick">
					<xsl:apply-templates mode="sitemap:script" select="."/><![CDATA[;/*toggle_sidebar();*/]]>
				</xsl:attribute>-->
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-layout align-middle">
						<rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
						<line x1="3" y1="9" x2="21" y2="9"></line>
						<line x1="9" y1="21" x2="9" y2="9"></line>
					</svg>
				</xsl:if>
				<xsl:value-of select="@title"/>
			</a>
			<xsl:variable name="show_status">
				<xsl:if test="$collapsed_status!='collapsed'">show</xsl:if>
			</xsl:variable>
			<ul id="{generate-id()}" class="sidebar-dropdown list-unstyled collapse {$show_status}">
				<xsl:apply-templates mode="sitemap:body" select="ancestor-or-self::*[1]/*"/>
			</ul>
		</li>
	</xsl:template>

	<xsl:template mode="sitemap:footer" match="@*">
	</xsl:template>

	<xsl:template mode="sitemap:header" match="@*">
		<span class="sidebar-brand mt-1 d-flex filter-white" style="padding-left: 15pt; padding-top: .5rem; padding-bottom: .5rem;">
			<span class="menu_toggle" style="font-size:30px; color:white;" onclick="toggleSidebar()">
				&#9776;
			</span>
			<a href="javascript:void(0)" onclick="toggleSidebar()" style="margin:0;padding:0;">
				<xsl:apply-templates mode="sitemap:brand" select="."/>
			</a>
		</span>
	</xsl:template>

	<xsl:template mode="sitemap:target-href" match="*"/>

	<xsl:template mode="sitemap:target-href" match="*[@catalogName]">
		<xsl:attribute name="href">
			<xsl:value-of select="concat('#',translate(substring-before(@catalogName,'].['),'[]',''),'/',translate(substring-after(@catalogName,'].['),'[]',''),'~',@mode)"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template mode="sitemap:target-href" match="*[@target]">
		<xsl:attribute name="href">
			<xsl:value-of select="@target"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template mode="sitemap:brand" match="@*">
		<xsl:apply-templates mode="shell:nav-brand" select="."/>
	</xsl:template>
</xsl:stylesheet>
