<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:x="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:widget="http://panax.io/widget"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
xmlns:xlink="http://www.w3.org/1999/xlink"
exclude-result-prefixes="#default x session sitemap shell state source"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:param name="session:user_login">User</xsl:param>

	<xsl:template match="/" priority="-1">
		<section>
			<xsl:apply-templates mode="widget"/>
		</section>
	</xsl:template>

	<xsl:template match="shell:shell" mode="widget">
		<div id="shell" class="wrapper sitemap_collapsed">
			<link rel="stylesheet" href="widgets/panax/shell.css" />
			<script>
				<![CDATA[
				function toggleSidebar(show) {
					let sidebar = document.querySelector('.sidebar');
					if (!sidebar) return
					let width = Number.parseInt(sidebar.style.width);
					sidebar.closest('.wrapper').classList.toggle('sitemap_collapsed', !!width || show === false)
					sidebar.style.width = width || show === false ? 0 : '350px';
				}
				
				xover.listener.on('keyup', async function (event) {
					if (event.keyCode == 27) {
						toggleSidebar(false);
						event.stopPropagation();
					}
				})
				]]>
			</script>
			<style>
				<![CDATA[
				body {
					overflow-y: hidden;
				}
				
				main { 
					margin-bottom: var(--margin-bottom);
					padding-bottom: var(--padding-bottom);
					overflow-y: scroll;
					height: calc(100vh - var(--footer-height, var(--margin-bottom, 135px)));

				}
				
				nav header h1 {
					color: var(--color-title-header);
					margin-bottom: 0;
					margin-left: 5px;
				}
				
				footer {
					border-top: 2px solid silver !important;
					position: fixed;
					bottom: 0;
					height: var(--footer-height, var(--margin-bottom, 135px));
					background-color: var(--bg-white) !important;
					z-index: 98;
					width: 100%;
					overflow: hidden;
				}
				
				.menu_toggle {
					color: silver; 
					cursor: wait;
				}
				]]>
			</style>
			<nav class="navbar navbar-expand navbar-light" style="padding:.6rem 1.25rem; position: sticky;">
				<span class="menu_toggle" style="font-size:30px;" onclick="toggleSidebar()">
					&#9776;
				</span>
				<div class="navbar-collapse collapse">
					<div>
						<!--Logo-->
						<a href="/" title="Ir a la página principal">
							<img class="logo" src="assets/logo.png" height="40.61px">
								<xsl:apply-templates mode="shell:nav-img-attributes" select="."/>
							</img>
						</a>
					</div>
					<div class="anteanter_section search navbar-left">
						<xsl:apply-templates mode="shell:nav-title" select="."/>
					</div>
					<div class="">
						<ul class="navbar-nav ml-auto">
							<li class="nav-item dropdown">
								<a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-toggle="dropdown">
									<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-settings align-middle">
										<circle cx="12" cy="12" r="3"></circle>
										<path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
									</svg>
								</a>

								<span xo-section="#menu">
								</span>
							</li>
						</ul>
					</div>
				</div>
			</nav>
			<main>
			</main>
			<footer class="d-flex flex-wrap justify-content-between align-items-center py-3 px-3">
				<xsl:apply-templates mode="shell:footer-content" select="."/>
			</footer>
			<xsl:apply-templates mode="shell:extra-content" select="."/>
		</div>
	</xsl:template>

	<xsl:template mode="shell:extra-content" match="*|@*"/>

	<xsl:template mode="shell:nav-img-attributes" match="*|@*"/>

	<xsl:template mode="shell:nav-title" match="*|@*"/>

	<xsl:template mode="shell:footer-content" match="*|@*"/>

</xsl:stylesheet>
