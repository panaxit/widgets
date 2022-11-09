﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:widget="http://panax.io/widget"
xmlns:login="http://panax.io/widget/login"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
xmlns:js="http://panax.io/languages/javascript"
exclude-result-prefixes="#default xo session sitemap login widget state source js"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:param name="session:user_login"/>
	<xsl:param name="session:status"/>
	<xsl:param name="session:connection_id">main</xsl:param>
	<xsl:param name="js:secure"><![CDATA[location.protocol.indexOf('https')!=-1 || location.hostname=='localhost']]></xsl:param>

	<xsl:template mode="widget-attributes" match="@*" priority="-1"/>

	<xsl:template mode="login:attributes" match="@*" priority="-1">
		<xsl:apply-templates mode="widget-attributes" select="."/>
	</xsl:template>

	<xsl:template mode="login:image-attributes" match="@*" priority="-1">
		<xsl:apply-templates mode="widget-attributes" select="."/>
	</xsl:template>

	<xsl:template match="/" priority="-1">
		<section>
			<xsl:apply-templates mode="widget" select="*/@xo:id"/>
		</section>
	</xsl:template>

	<xsl:template mode="widget" match="*|@*">
		<div class="login">
			<style>
				<![CDATA[
.login {
	display: -ms-flexbox;
	display: -webkit-box;
	display: flex;
	-ms-flex-align: center;
	-ms-flex-pack: center;
	-webkit-box-align: center;
	align-items: center;
	-webkit-box-pack: center;
	justify-content: center;
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.form-signin {
	width: 100%;
	max-width: 330px;
	padding: 15px;
	margin: 0 auto;
}

.form-signin .checkbox {
	font-weight: 400;
}

.form-signin .form-control {
	position: relative;
	box-sizing: border-box;
	height: auto;
	padding: 10px;
	font-size: 16px;
}

.form-signin .form-control:focus {
	z-index: 2;
}

.form-signin input[type="email"] {
	margin-bottom: -1px;
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0;
}

.form-signin input[type="password"] {
	margin-bottom: 10px;
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}
			]]>
			</style>
			<form class="form-signin" onsubmit="var username=document.getElementById('username'); var password=document.getElementById('password'); xover.session.login( username.value, password.value, `{$session:connection_id}`);" action="javascript:void(0);">
				<xsl:if test="$session:status='authorized'">
					<xsl:attribute name="onsubmit"></xsl:attribute>
					<xsl:attribute name="action">#</xsl:attribute>
				</xsl:if>
				<img src="./assets/logo.png" alt="" width="90%" class="mx-auto">
					<xsl:apply-templates mode="login:image-attributes" select="."/>
				</img>
				<h1 class="h3 mb-3 font-weight-normal mx-auto">Bienvenido</h1>
				<label for="username" class="sr-only">Username</label>
				<input type="text" id="username" class="form-control" placeholder="Username" autocomplete="username" value="{$session:user_login}" required="" autofocus="" oninvalid="this.setCustomValidity('Escriba su usuario')" oninput="this.setCustomValidity('')"/>
				<label for="password" class="sr-only">Password</label>
				<input type="password" id="password" class="form-control" placeholder="Password" autocomplete="current-password" required="" oninvalid="this.setCustomValidity('Escriba su contraseña')" oninput="this.setCustomValidity('')">
					<xsl:if test="$session:status='authorizing' or $session:status='authorized'">
						<xsl:attribute name="style">visibility:hidden;</xsl:attribute>
						<xsl:attribute name="readonly"></xsl:attribute>
					</xsl:if>
				</input>
				<button class="btn btn-lg btn-primary btn-block color-orange" type="submit">
					<xsl:choose>
						<xsl:when test="$session:status='authorized'">
							<xsl:attribute name="onclick">xo.site.hash='#'</xsl:attribute>
							Continuar
						</xsl:when>
						<xsl:when test="$session:status='authorizing'">
							Autorizando... <i class="fas fa-spinner fa-spin"></i>
						</xsl:when>
						<xsl:otherwise>Ingresar</xsl:otherwise>
					</xsl:choose>
				</button>
				<p class="mt-5 mb-3 text-muted mx-auto">©Panax 2022</p>
			</form>
		</div>
	</xsl:template>

</xsl:stylesheet>
