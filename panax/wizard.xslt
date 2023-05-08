﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:source="http://panax.io/xdom/binding/source"
  xmlns:wizard="http://panax.io/widget/wizard"
  xmlns:px="http://panax.io/entity"
  exclude-result-prefixes="px state xo source"
  xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:key name="wizard:section" match="xo:dummy" use="concat(1,'::',ancestor::px:Entity[1]/@xo:id)"/>
	<xsl:key name="optional" match="xo:dummy" use="generate-id()"/>
	<xsl:key name="invalid" match="xo:dummy" use="generate-id()"/>

	<xsl:template match="@*" mode="wizard:styles" priority="-10"/>

	<!--<xsl:template match="@*" mode="wizard:step-title-legend" priority="-10">
    <xsl:value-of select="@shortTitle|self::*[not(@shortTitle)]/@title"/>
  </xsl:template>-->

	<xsl:template match="@*" mode="wizard:step-title-legend" priority="-10"/>

	<xsl:template match="@*" mode="wizard:step-panel-legend" priority="-10">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:apply-templates mode="wizard:step-title-legend" select=".">
			<xsl:with-param name="step" select="$step"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--<xsl:template match="@*" mode="wizard:step-title-legend" priority="-10">
    <xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
    <xsl:text/>Paso <xsl:value-of select="$step"/><xsl:text/>
  </xsl:template>-->

	<xsl:template match="@*" mode="wizard:widget" priority="-1">
		<xsl:variable name="current" select="current()"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[1]/@state:active">
					<xsl:value-of select="ancestor-or-self::*[1]/@state:active"/>
				</xsl:when>
				<xsl:when test="string(ancestor-or-self::*[1]/@first_name)=''">1</xsl:when>
				<xsl:when test="string(ancestor-or-self::*[1]/@last_name)=''">2</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="fluid-container">
			<xsl:apply-templates mode="wizard:styles" select="."/>
			<div id="wizard" class="aiia-wizard" style="display: block;">
				<hr style="border-width: 4px; border-color: silver;"/>
				<div class="aiia-wizard-progress-buttons-wrapper row" style="display: block;">
					<div class="col-md-12">
						<ul class="nav nav-pills nav-justified aiia-wizard-progress-buttons-placeholder">
							<xsl:for-each select="(//*/@*)[position()&lt;20]">
								<xsl:variable name="current-step" select="position()"/>
								<xsl:variable name="items" select="key('wizard:section',concat($current-step,'::',ancestor::px:Entity[1]/@xo:id))"/>
								<xsl:apply-templates mode="wizard:step-title" select="$items[1]">
									<xsl:with-param name="active" select="$active"/>
									<xsl:with-param name="step" select="position()"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</ul>
					</div>
				</div>
				<hr style="border-width: 4px; border-color: silver;"/>
				<div class="aiia-wizard-steps-wrapper row" style="position: relative; width: 100%; min-height: 500px; height: 500px;">
					<xsl:apply-templates mode="wizard:step-panel" select="key('wizard:section',concat($active,'::',ancestor::px:Entity[1]/@xo:id))[1]">
						<xsl:with-param name="active" select="$active"/>
						<xsl:with-param name="step" select="$active"/>
						<xsl:with-param name="layout" select="key('wizard:section',concat($active,'::',ancestor::px:Entity[1]/@xo:id))"/>
					</xsl:apply-templates>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:step-title" priority="-1">
		<xsl:param name="active">1</xsl:param>
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<li data-position="{$step}" class="inactive" style="padding: 0px 43px;" xo-attribute="state:active" onclick="scope.set('{$step}')">
			<xsl:variable name="completed" select="not(key('wizard:section',concat(number($step),'::',ancestor::px:Entity[1]/@xo:id))[not(key('optional',concat(ancestor::px:Entity[1]/@xo:id,'::',.))) and key('invalid',concat(ancestor::px:Entity[1]/@xo:id,'::',.))])"/>
			<xsl:choose>
				<xsl:when test="$active=$step">
					<xsl:attribute name="class">active</xsl:attribute>
				</xsl:when>
				<xsl:when test="$active&gt;$step">
					<xsl:attribute name="class">completed</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<a href="#">
				<h1>
					<xsl:value-of select="concat($step,'.')"/>
				</h1>
				<xsl:apply-templates mode="wizard:step-title-legend" select=".">
					<xsl:with-param name="step" select="$step"/>
				</xsl:apply-templates>
				<xsl:if test="$completed">
					<span class="fas fa-check-circle aiia-wizard-icon-step-completed"></span>
				</xsl:if>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-back-attributes" priority="-1">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-back-attributes-onclick" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>scope.set('<xsl:value-of select="number($step)-1"/>');
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-back-label" priority="-1">
		<xsl:text>Atrás</xsl:text>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-start-label" priority="-1">
		<xsl:text>Inicio</xsl:text>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-start" name="wizard:buttons-start" priority="-1">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-back" name="wizard:buttons-back" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:if test="//*[key('wizard:section',concat(number($step)-1,'::',ancestor::px:Entity[1]/@xo:id))]">
			<button class="btn btn-primary pull-left aiia-wizard-button-previous" xo-attribute="state:active">
				<xsl:attribute name="onclick">
					<xsl:apply-templates mode="wizard:buttons-back-attributes-onclick" select=".">
						<xsl:with-param name="step" select="$step"/>
					</xsl:apply-templates>
				</xsl:attribute>
				<xsl:apply-templates mode="wizard:buttons-back-attributes" select="."/>
				<span>
					<xsl:apply-templates mode="wizard:buttons-back-label" select="."/>
				</span>
			</button>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-next-attributes" priority="-1">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-finish-attributes" priority="-1">
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-next-attributes-onclick" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>scope.set('<xsl:value-of select="number($step)-(-1)"/>');
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-finish-attributes.onclick" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:text/>alert('Terminado')
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-next-label" priority="-1">
		<xsl:text>Siguiente</xsl:text>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-finish-label" priority="-1">
		<xsl:text>Guardar</xsl:text>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-next" name="wizard:buttons-next" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:param name="label">Siguiente</xsl:param>
		<button class="btn btn-primary pull-right aiia-wizard-button-next" xo-attribute="state:active">
			<xsl:attribute name="onclick">
				<xsl:apply-templates mode="wizard:buttons-next-attributes-onclick" select=".">
					<xsl:with-param name="step" select="$step"/>
				</xsl:apply-templates>
			</xsl:attribute>
			<xsl:apply-templates mode="wizard:buttons-next-attributes" select="."/>
			<span>
				<xsl:apply-templates mode="wizard:buttons-next-label" select="."/>
			</span>
		</button>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:buttons-finish" name="wizard:buttons-finish" priority="-1">
		<xsl:param name="step" select="count(preceding-sibling::*|self::*)"/>
		<xsl:param name="label">Siguiente</xsl:param>
		<button class="btn btn-success pull-right aiia-wizard-button-finish" xo-attribute="state:active">
			<xsl:attribute name="onclick">
				<xsl:apply-templates mode="wizard:buttons-finish-attributes.onclick" select=".">
					<xsl:with-param name="step" select="$step"/>
				</xsl:apply-templates>
			</xsl:attribute>
			<xsl:apply-templates mode="wizard:buttons-finish-attributes" select="."/>
			<span>
				<xsl:apply-templates mode="wizard:buttons-finish-label" select="."/>
			</span>
		</button>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:step-panel-content" priority="-1">
		<p>No hay nada que hacer aún en este paso.</p>
	</xsl:template>

	<xsl:template match="@*" mode="wizard:step-panel" priority="-1">
		<xsl:param name="step">1</xsl:param>
		<xsl:param name="layout" select="key('wizard:section',concat($step,'::',ancestor::px:Entity[1]/@xo:id))"/>
		<xsl:variable name="step-class">aiia-wizard-step</xsl:variable>
		<div id="container_{@xo:id}" class="{$step-class}" data-position="{count(preceding-sibling::*|self::*)}" style="min-height: 400px; width: 100%; margin-left: 0px;" xo-scope="inherit">
			<xsl:choose>
				<xsl:when test="$step=1">
					<xsl:attribute name="class">
						<xsl:value-of select="$step-class"/><xsl:text/> active<xsl:text/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="$step&gt;1">
					<xsl:attribute name="class">
						<xsl:value-of select="$step-class"/><xsl:text/> completed<xsl:text/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<div class="row aiia-wizard-step-title">
				<div class="col-md-12">
					<h2 class="aiia-wizard-step-title-text">
						<xsl:apply-templates mode="wizard:step-panel-legend" select=".">
							<xsl:with-param name="step" select="$step"/>
						</xsl:apply-templates>
					</h2>
				</div>
			</div>
			<div class="step-content">
				<xsl:apply-templates mode="wizard:step-panel-content" select=".">
					<xsl:with-param name="step" select="$step"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
			</div>
			<div class="aiia-wizard-buttons-wrapper row" style="display: block;">
				<div class="col-md-12">
					<xsl:choose>
						<xsl:when test="//*[key('wizard:section',concat(number($step)-1,'::',ancestor::px:Entity[1]/@xo:id))]">
							<xsl:apply-templates select="." mode="wizard:buttons-back">
								<xsl:with-param name="step" select="$step"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="wizard:buttons-start">
								<xsl:with-param name="step" select="$step"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="//*[key('wizard:section',concat(number($step)+1,'::',ancestor::px:Entity[1]/@xo:id))]">
							<xsl:apply-templates select="." mode="wizard:buttons-next">
								<xsl:with-param name="step" select="$step"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="wizard:buttons-finish">
								<xsl:with-param name="step" select="$step"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="/*" priority="-1">
		<xsl:apply-templates mode="wizard:widget" select="."/>
	</xsl:template>

</xsl:stylesheet>