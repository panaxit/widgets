﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:confirmation = "http://panax.io/state/confirmation"
  xmlns:px="http://panax.io/entity"
  xmlns:readonly="http://panax.io/state/readonly"
  xmlns:file="http://panax.io/widget/file"
  xmlns:dropzone="http://panax.io/widget/dropzone"
  xmlns:fileExplorer="http://panax.io/widget/fileExplorer"
  xmlns:calendar="http://panax.io/widget/calendar"
  xmlns:percentage="http://panax.io/widget/percentage"
  xmlns:picture="http://panax.io/widget/picture"
  xmlns:modal="http://panax.io/widget/modal"
  xmlns:tabPanel="http://panax.io/widget/tabPanel"
  xmlns:route="http://panax.io/routes"
  xmlns:groupTabPanel="http://panax.io/widget/groupTabPanel"

  xmlns:form="http://panax.io/widget/form"
  xmlns:widget="http://panax.io/widget"
  xmlns:wizard="http://panax.io/widget/wizard"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:comboboxButton="http://panax.io/widget/combobox-button"
  xmlns:autocompleteBox="http://panax.io/widget/autocompleteBox"
  xmlns:autocompleteBoxButton="http://panax.io/widget/autocompleteBox-button"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"
  xmlns:cardview="http://panax.io/widget/cardview"
  exclude-result-prefixes="xo state xsi control layout meta data height width confirmation px readonly file dropzone fileExplorer calendar percentage picture form widget datagrid combobox comboboxButton autocompleteBox autocompleteBoxButton field container association cardview modal tabPanel groupTabPanel"
>
	<xsl:import href="values.xslt"/>
	<xsl:import href="panax/keys.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="panax/modal.xslt"/>
	<xsl:import href="panax/tabPanel.xslt"/>
	<xsl:import href="panax/groupTabPanel.xslt"/>
	<xsl:import href="panax/picture.xslt"/>
	<xsl:import href="panax/cardview.xslt"/>
	<xsl:import href="panax/file.xslt"/>
	<xsl:import href="panax/dropzone.xslt"/>
	<xsl:import href="panax/fileExplorer.xslt"/>
	<xsl:import href="panax/calendar.xslt"/>
	<xsl:import href="panax/percentage.xslt"/>
	<xsl:import href="panax/combobox.xslt"/>
	<xsl:import href="panax/autocompleteBox.xslt"/>
	<xsl:import href="panax/wizard.xslt"/>
	<xsl:import href="form.xslt"/>
	<xsl:import href="datagrid.xslt"/>

	<xsl:key name="styles" match="@height:*" use="concat(../@xo:id,'::',local-name())"/>
	<xsl:key name="styles" match="@width:*" use="concat(../@xo:id,'::',local-name())"/>

	<xsl:template mode="style" match="@width:*|@height:*">
		<xsl:value-of select="concat(substring-before(name(),':'),':',current(),'px;')"/>
	</xsl:template>

	<xsl:template mode="widget:attributes" match="@*" priority="-1">
		<xsl:apply-templates mode="widget-attributes" select="."/>
	</xsl:template>

	<xsl:template mode="widget:attributes" match="@*[key('widget',concat('date:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]" priority="-1">
		<xsl:attribute name="pattern">yyyy-mm-dd</xsl:attribute>
	</xsl:template>

	<xsl:template match="/">
		<div class="container-fluid p-3" style="margin-top:0px;">
			<xsl:apply-templates mode="widget" select="px:Entity/@xo:id"/>
			<xsl:comment>debug:info</xsl:comment>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="current" select="."/>
		<xsl:variable name="schema" select="key('reference',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::header::field:ref::',name()))/.."/>
		<input type="text" name="{name()}" class="form-control {$class}" id="{$schema/@xo:id}" placeholder="" required="" xo-scope="{ancestor-or-self::*[1]/@xo:id}" xo-slot="{name()}" onfocus="this.value=(scope &amp;&amp; scope.value || this.value)" autocomplete="off" aria-autocomplete="none">
			<xsl:attribute name="maxlength">
				<xsl:value-of select="$schema/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="size">
				<xsl:value-of select="$schema/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="key('color',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">color</xsl:when>
					<xsl:when test="key('number',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">number</xsl:when>
					<xsl:when test="key('year',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">number</xsl:when>
					<xsl:when test="key('datetime',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">datetime-local</xsl:when>
					<xsl:when test="key('date',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">date</xsl:when>
					<xsl:when test="key('time',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">time</xsl:when>
					<xsl:when test="key('password',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',local-name()))">password</xsl:when>
					<xsl:otherwise>text</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="key('year',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))">
					<xsl:attribute name="minValue">1900</xsl:attribute>
					<xsl:attribute name="maxValue">2099</xsl:attribute>
					<xsl:attribute name="step">1</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!--<xsl:attribute name="pattern">
				<xsl:choose>
					<xsl:when test="key('money',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))">\${\d}{1,3}.00</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>-->
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="widget:attributes" select="."/>
		</input>
		<xsl:if test="namespace-uri()!='http://panax.io/state/confirmation'">
			<xsl:apply-templates mode="widget" select="../@confirmation:*[local-name()=local-name(current())]"/>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('textarea:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="current" select="."/>
		<textarea class="form-control" id="{$schema/@xo:id}" rows="3" placeholder="" required="" xo-scope="{$current/../@xo:id}" xo-slot="{name()}">
			<xsl:attribute name="style">
				<xsl:apply-templates mode="style" select="key('styles',concat(../@xo:id,'::',local-name()))"/>
			</xsl:attribute>
			<xsl:apply-templates mode="widget:attributes" select="."/>
			<xsl:apply-templates select="."/>
		</textarea>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('yesNo:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<div class="btn-group" role="group" style="position:relative;">
			<button type="button" class="btn btn-outline-success" xo-scope="{../@xo:id}" xo-slot="{name()}" onclick="scope.toggle('1','')">
				<xsl:if test=".='1'">
					<xsl:attribute name="class">btn btn-success</xsl:attribute>
				</xsl:if>
				<xsl:text>Sí</xsl:text>
			</button>
			<button type="button" class="btn btn-outline-danger" xo-scope="{../@xo:id}" xo-slot="{name()}" onclick="scope.toggle(0,'')">
				<xsl:if test=".='0'">
					<xsl:attribute name="class">btn btn-danger</xsl:attribute>
				</xsl:if>
				<xsl:text>No</xsl:text>
			</button>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('radiogroup:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="data_set" select="$schema/px:Entity/data:rows"/>
		<xsl:variable name="current" select="."/>

		<xsl:for-each select="$data_set/xo:r">
			<xsl:variable name="option" select="."/>
			<xsl:variable name="checked">
				<xsl:if test="$current = @value">checked</xsl:if>
			</xsl:variable>
			<div class="form-check form-check-inline" xo-scope="{$current/../@xo:id}">
				<input class="form-check-input" type="radio" value="{@value}" id="{../@xo:id}_{position()}" xo-slot="{name($current)}">
					<xsl:for-each select="$schema/px:Mappings/px:Mapping">
						<xsl:attribute name="onclick">
							<xsl:text/>scope.parentNode.set('<xsl:value-of select="@Referencer"/>','<xsl:value-of select="$option/@*[name()=current()/@Referencee]"/>');<xsl:text/>
						</xsl:attribute>
					</xsl:for-each>
					<xsl:if test="$current = @value">
						<xsl:attribute name="checked"/>
					</xsl:if>
				</input>
				<label class="form-check-label" for="{../@xo:id}_{position()}">
					<xsl:value-of select="@meta:text"/>
				</label>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('combobox:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="combobox:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Entity/px:Routes/px:Route/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:apply-templates mode="route:widget" select=".">
			<xsl:with-param name="dataset" select="$dataset"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="px:Entity[not(ancestor::px:Association[@DataType='junctionTable'])][@control:type='combobox:control']/px:Routes/px:Route/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<li>
			<a class="dropdown-item" href="javascript:void(0)" xo-scope="{$dataset/ancestor-or-self::*[1]/@xo:id}" xo-slot="{name($dataset)}">
				<xsl:apply-templates mode="widget-attributes" select="."/>
				<xsl:apply-templates select=".">
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</a>
		</li>
	</xsl:template>

	<xsl:template mode="widget-routes" match="@*"/>

	<xsl:template mode="widget-routes" match="@*[key('widget',concat('combobox:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="comboboxButton:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('autocompleteBox:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="autocompleteBox:widget" select=".">
			<xsl:with-param name="dataset" select="key('dataset',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('file:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="file:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('dropzone:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="dropzone:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('percentage:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="percentage:widget" select="."/>
	</xsl:template>

	<xsl:key name="editable" match="node-expected" use="generate-id()"/>
	<xsl:template mode="widget" match="@*[key('widget',concat('readonly:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))][not(key('editable',generate-id()))]">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="current" select="."/>
		<input name="{name()}" class="form-control" type="text" aria-label="Disabled input" disabled="" readonly="">
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</input>
	</xsl:template>

	<!--<xsl:template mode="widget" match="@*[key('widget',concat('datagrid:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:param name="schema" select="ancestor::*[key('entity',@xo:id)][1]/px:Record/*[not(@AssociationName)]/@Name|ancestor::*[key('entity',@xo:id)][1]/px:Record/*/@AssociationName"/>
		<xsl:param name="dataset" select="ancestor::*[key('entity',@xo:id)][1]/data:rows/@xsi:nil|ancestor::*[key('entity',@xo:id)][1]/data:rows/xo:r/@*|ancestor::*[key('entity',@xo:id)][1]/data:rows/xo:r/xo:f/@Name"/>
		<xsl:param name="layout" select="ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/@xo:id"/>
		<xsl:param name="selection" select="node-expected"/>
		<div class="g-3" style="margin-top:0px;">
			<div class="col-md-9 col-lg-12">
				<xsl:apply-templates mode="datagrid:widget" select="current()">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
					<xsl:with-param name="selection" select="$selection"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>-->

	<xsl:template mode="widget" match="px:Entity/@*">
		<xsl:param name="schema" select="ancestor::*[key('entity',@xo:id)][1]/px:Record/*[not(@AssociationName)]/@Name|ancestor::*[key('entity',@xo:id)][1]/px:Record/*/@AssociationName"/>
		<xsl:param name="dataset" select="ancestor::*[key('entity',@xo:id)][1]/data:rows/@xsi:nil|ancestor::*[key('entity',@xo:id)][1]/data:rows[not(@xsi:nil)][not(xo:r)]/@xo:id|ancestor::*[key('entity',@xo:id)][1]/data:rows/xo:r"/>
		<xsl:param name="layout" select="ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*/@Name|ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*[not(@Name)]/@xo:id"/>
		<xsl:param name="selection" select="node-expected"/>
		<xsl:variable name="current" select="."/>
		<div class="row g-3" style="margin-top:0px;">
			<style>
				<![CDATA[
.form-floating > label.floating-label { display: none }
.form-floating > .form-select~label.floating-label { display: revert }
.form-floating > .form-control~label.floating-label { display: revert }
			]]>
			</style>
			<div class="col-md-9 col-lg-12">
				<xsl:apply-templates mode="widget" select="../*[local-name()='layout']/@xo:id">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('form:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',parent::px:Entity/@Schema,'/',parent::px:Entity/@Name))]">
		<xsl:param name="dataset" select="key('dataset',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:param name="layout" select="key('layout',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:apply-templates mode="form:widget" select="current()">
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="$layout"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('datagrid:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',parent::px:Entity/@Schema,'/',parent::px:Entity/@Name))]">
		<xsl:param name="dataset" select="key('dataset',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:param name="layout" select="key('layout',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:apply-templates mode="datagrid:widget" select="current()">
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="$layout"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('wizard:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',parent::px:Entity/@Schema,'/',parent::px:Entity/@Name))]">
		<xsl:param name="dataset" select="key('dataset',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:param name="layout" select="key('layout',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:apply-templates mode="wizard:widget" select="current()">
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="$layout"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('fileExplorer:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',parent::px:Entity/@Schema,'/',parent::px:Entity/@Name))]">
		<xsl:param name="schema" select="ancestor::*[key('entity',@xo:id)][1]/px:Record/*[not(@AssociationName)]/@Name|ancestor::*[key('entity',@xo:id)][1]/px:Record/*/@AssociationName"/>
		<xsl:param name="dataset" select="ancestor::*[key('entity',@xo:id)][1]/data:rows/@xsi:nil|ancestor::*[key('entity',@xo:id)][1]/data:rows[not(@xsi:nil)][not(xo:r)]/@xo:id|ancestor::*[key('entity',@xo:id)][1]/data:rows/xo:r"/>
		<xsl:param name="layout" select="ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*/@Name|ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*[not(@Name)]/@xo:id"/>
		<xsl:comment>debug:info</xsl:comment>
		<xsl:apply-templates mode="fileExplorer:widget" select="current()">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="$layout"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('calendar:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',parent::px:Entity/@Schema,'/',parent::px:Entity/@Name))]">
		<xsl:param name="schema" select="ancestor::*[key('entity',@xo:id)][1]/px:Record/*[not(@AssociationName)]/@Name|ancestor::*[key('entity',@xo:id)][1]/px:Record/*/@AssociationName"/>
		<xsl:param name="dataset" select="ancestor::*[key('entity',@xo:id)][1]/data:rows/@xsi:nil|ancestor::*[key('entity',@xo:id)][1]/data:rows[not(@xsi:nil)][not(xo:r)]/@xo:id|ancestor::*[key('entity',@xo:id)][1]/data:rows/xo:r"/>
		<xsl:param name="layout" select="ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*/@Name|ancestor::*[key('entity',@xo:id)][1]/*[local-name()='layout']/*[not(@Name)]/@xo:id"/>
		<xsl:comment>debug:info</xsl:comment>
		<xsl:apply-templates mode="calendar:widget" select="current()">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="$layout"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="*[local-name()='layout'][not(field:ref or association:ref)]/@*">
		<xsl:apply-templates mode="widget" select="../*/@xo:id"/>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('form:item',@xo:id)]/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="value" select="key('reference',concat($dataset,'::body::',name(..),'::',../@Name))"/>
		<div>
			<xsl:attribute name="class">
				<xsl:if test="position()&gt;1"> input-group-append</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates mode="widget" select="../@Name">
				<xsl:with-param name="dataset" select="$dataset"/>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="class" select="$class"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('form:item',@xo:id)]/@Name">
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="class"></xsl:param>
		<xsl:variable name="value" select="key('reference',concat($dataset,'::body::',name(..),'::',current()))"/>

		<xsl:variable name="container_position">
			<xsl:value-of select="position()"/>
		</xsl:variable>
		<xsl:for-each select="$value">
			<xsl:variable name="label">
				<xsl:apply-templates mode="headerText" select="."/>
			</xsl:variable>
			<div>
				<xsl:attribute name="style">
					<xsl:text/>min-width: calc(<xsl:value-of select="concat(string-length($label)+1,'ch')"/> + 6rem);<xsl:text/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:text>form-floating input-group</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="widget" select="current()">
					<xsl:with-param name="schema" select="$schema[@Id=current()/@Id]|current()/self::container:*"/>
					<xsl:with-param name="class">
						<xsl:value-of select="$class"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<label for="{../@xo:id}" class="floating-label">
					<xsl:value-of select="$label"/>
				</label>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="widget" match="container:*[key('form:item',@xo:id)]/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<div class="input-group">
			<xsl:apply-templates mode="widget" select="../*/@xo:id">
				<xsl:with-param name="schema" select="$schema[@Id=current()/@Id]|current()/self::container:*"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>
	<xsl:key name="datagrid:editable" match="xo:r[@state:edit='true']" use="@xo:id"/>
	<xsl:key name="datagrid:editable" match="xo:r[@state:checked='true'][ancestor::px:Association[1]/@DataType='junctionTable']" use="@xo:id"/>
	<xsl:template mode="widget" match="key('entity','datagrid:widget')/data:rows/xo:r[not(key('datagrid:editable',@xo:id))]/@*">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Association[@DataType='junctionTable']/px:Entity/data:rows/xo:r[@state:checked='true']/@meta:*">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Association[@DataType='junctionTable']/px:Entity/px:Record/px:Association/px:Entity/data:rows/xo:r/@*">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:widget')/data:rows/xo:r/@*[key('widget',concat('files:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="file:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:widget')/data:rows/xo:r/@*[key('widget',concat('file:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="file:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:widget')/data:rows/xo:r/xo:f/@*">
		<xsl:apply-templates mode="widget" select="../*"/>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('widget',concat('picture:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))]">
		<xsl:apply-templates mode="file:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="px:Association/@*">
		<xsl:param name="dataset" select="node-expected"/>
		<span>
			<xsl:apply-templates mode="widget" select="../px:Entity/@xo:id">
				<!--<xsl:with-param name="dataset" select="$dataset"/>-->
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<!--<xsl:template mode="widget" match="@xsi:nil">
		<span>
			<xsl:value-of select="."/>
		</span>
	</xsl:template>-->

	<xsl:template mode="widget" match="field:ref/@*|association:ref/@*">
		<div class="skeleton skeleton-text skeleton-text__body">&#160;</div>
	</xsl:template>

	<xsl:template mode="widget" match="field:ref/@*[key('widget',concat('textarea:',ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',../@Name))]">
		<div class="skeleton skeleton-textarea skeleton-text__body">&#160;</div>
	</xsl:template>

	<xsl:template mode="combobox:following-siblings" match="*[key('form:widget',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::','xo:id'))]/data:rows/*/@*">
		<xsl:apply-templates mode="comboboxButton:widget" select="key('entity',concat(ancestor::*[key('entity',@xo:id)][1]/@xo:id,'::',name()))/@xo:id">
			<xsl:with-param name="selection" select="."/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="modal:header-title-label" match="@*">
		<xsl:value-of select="../@headerText"/>
	</xsl:template>

	<xsl:template mode="modal:footer" match="@*">
		<xsl:for-each select="../data:rows[not(xo:r[2])]/xo:r">
			<a class="text-muted" href="#" xo-scope="{@xo:id}" onclick="px.submit(scope)">
				<button class="btn btn-success">Guardar</button>
			</a>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="modal:body" match="@*">
		<xsl:param name="dataset" select="key('dataset',ancestor::px:Entity[1]/@xo:id)"/>
		<div class="input-group d-flex justify-content-between col-8" xo-scope="{../@xo:id}">
			<xsl:apply-templates mode="form:widget" select="current()">
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="container:modal/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<a class="text-muted" href="#" xo-scope="{../@xo:id}" xo-slot="state:active" onclick="scope.toggle('true',null)">
			<button class="btn btn-secondary">
				<xsl:apply-templates mode="headerText" select="."/>
			</button>
		</a>
		<xsl:apply-templates mode="widget" select="../@state:active">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="dataset" select="$dataset"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="container:modal/@state:active"/>

	<xsl:template mode="widget" match="container:modal/@state:active[.='true']">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:apply-templates mode="modal:widget" select="../@state:active">
			<xsl:with-param name="layout" select="../*/@Name"/>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="dataset" select="$dataset"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="*[container:groupTabPanel]/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:apply-templates mode="groupTabPanel:widget" select="."/>
	</xsl:template>

	<xsl:key name="active" match="node-expected" use="@xo:id"/>
	<xsl:template mode="widget" match="container:groupTabPanel/@*">
		<xsl:apply-templates mode="groupTabPanel:widget" select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="container:tab/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id)">active</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<li class="nav-item" style="margin-bottom: 10px;" xo-scope="{../../@xo:id}" xo-slot="state:active" onclick="scope.set('{../@xo:id}')">
			<a class="nav-link {$active}" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home" role="tab" aria-controls="v-pills-home" aria-selected="true">
				<xsl:apply-templates mode="headerText" select="."/>
			</a>
		</li>
	</xsl:template>

	<xsl:template mode="widget" match="container:panel/@*">
		<xsl:comment>panel goes here!</xsl:comment>
	</xsl:template>

	<xsl:template mode="widget" match="container:panel[key('form:item', @xo:id)]/@*">
		<xsl:param name="dataset" select="key('dataset',ancestor::px:Entity[1]/@xo:id)"/>
		<xsl:apply-templates mode="form:widget" select=".">
			<xsl:with-param name="dataset" select="$dataset"/>
			<xsl:with-param name="layout" select="../*/@Name|../*[not(@Name)]/@xo:id"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="container:panel[key('datagrid:item', @xo:id)]/@*">
		<xsl:apply-templates mode="datagrid:widget" select=".">
			<xsl:with-param name="layout" select="../*/@Name|../*[not(@Name)]/@xo:id"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="container:tabPanel[not(container:groupTabPanel)]/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id)">active</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="tabPanel:widget" select="."></xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="container:tab[not(parent::container:tabPanel)]/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id)">active</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="tabPanel:widget" select=".">
			<xsl:with-param name="items" select="."/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('hidden',@xo:id)]/@*|*[key('hidden',concat(ancestor::px:Entity[1]/@xo:id,'::',@Name))]/@*">
		<xsl:comment>
			hidden <xsl:value-of select="../@xo:id"/>: <xsl:value-of select="."/>
		</xsl:comment>
	</xsl:template>
</xsl:stylesheet>