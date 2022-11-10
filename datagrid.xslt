<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl datagrid data px meta"
>
	<xsl:import href="../keys.xslt"/>
	<xsl:import href="../values.xslt"/>
	<xsl:import href="../headers.xslt"/>

	<xsl:param name="state:delete"/>

	<xsl:key name="datagrid:widget" match="dummy" use="@xo:id"/>
	<xsl:template match="/">
		<div class="container-fluid" style="margin-top:0px;">
			<xsl:apply-templates mode="widget" select="px:Entity/@xo:id"/>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('datagrid:widget',concat(ancestor::*[@meta:type='entity'][1]/@xo:id,'.',name()))]">
		<xsl:param name="dataset" select="../data:rows/@xo:id"/>
		<xsl:param name="layout" select="$dataset/ancestor-or-self::*[1]/*[1]/@xo:id"/>
		<xsl:param name="selection" select="dummy"/>
		<div class="row g-5" style="margin-top:0px;">
			<div class="col-md-9 col-lg-11">
				<xsl:apply-templates mode="datagrid:widget" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
					<xsl:with-param name="selection" select="$selection"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid:widget" match="@*">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="layout" select="*"/>
		<div class="row">
			<xsl:if test="concat(../@Schema,'.',../@Name)='Reportes.Embarques'">
				<xsl:attribute name="class"/>
			</xsl:if>
			<style>
				tr.deleting, tr.deleting:hover {
				background: red;
				color:white !important;
				}

				/*
				tr.deleting:after {
				background: red;
				content: '';
				left: 50%;
				position: absolute;
				transform: translateX(-50%) translateY(50%);
				width: 70%;
				height: 25px;
				vertical-align: middle;
				opacity: .5;
				}*/
			</style>
			<table class="table table-striped table-hover table-sm">
				<xsl:apply-templates mode="datagrid:header" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="datagrid:body" select="current()">
					<xsl:with-param name="dataset" select="$dataset/ancestor-or-self::*[1]/descendant-or-self::xo:r/@xo:id"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="datagrid:footer" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
			</table>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid:header" match="@*">
		<xsl:param name="context">header</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<thead class="freeze">
			<xsl:apply-templates mode="datagrid:row" select="current()">
				<xsl:with-param name="context">header</xsl:with-param>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
		</thead>
	</xsl:template>

	<xsl:template mode="datagrid:body" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<tbody class="table-group-divider">
			<!--<tr>
				<td>
					<xsl:value-of select="count($dataset/ancestor-or-self::*[1]/descendant-or-self::xo:r/@xo:id)"/>
				</td>
			</tr>-->
			<xsl:apply-templates mode="datagrid:row" select="$dataset">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
			<xsl:if test="not($dataset)">
				<tr>
					<td colspan="{count($layout)+3}" style="text-align:center">
						Sin elementos
					</td>
				</tr>
			</xsl:if>
		</tbody>
	</xsl:template>

	<xsl:template mode="datagrid:footer" match="@*">
		<xsl:param name="context">footer</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<tfoot class="table-group-divider">
			<xsl:apply-templates mode="datagrid:row" select="..">
				<xsl:with-param name="context">footer</xsl:with-param>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
			<xsl:if test="ancestor::*[@meta:type='entity'][2]">
				<tr xo-scope="{ancestor::*[@meta:type='entity'][1]/@xo:id}">
					<td colspan="{count($layout)+3}" style="text-align:center">
						<xsl:apply-templates mode="datagrid:buttons-new" select="."/>
					</td>
				</tr>
			</xsl:if>
		</tfoot>
	</xsl:template>

	<xsl:template mode="datagrid:row-attributes" match="@*">
		<xsl:comment>No more attributes</xsl:comment>
	</xsl:template>

	<xsl:template mode="datagrid:row-attributes" match="xo:r[@state:delete]/@xo:id">
		<xsl:attribute name="style">height:15px !important; background-color: #dc3545 !important;</xsl:attribute>
	</xsl:template>

	<xsl:template mode="datagrid:row-style" match="@*" priority="-1"/>

	<xsl:template mode="datagrid:row" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="../@*"/>
		<xsl:param name="layout" select="dummy"/>
		<tr xo-scope="{../@xo:id}">
			<xsl:attribute name="style">
				<xsl:apply-templates mode="datagrid:row-style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="datagrid:row-attributes" select="current()"/>
			<xsl:apply-templates mode="datagrid:row-header" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="current()"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:row-body" select="$layout">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="current()"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:row-footer" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="current()"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:row" match="xo:r[@state:delete]/@xo:id">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="../@*"/>
		<xsl:param name="layout" select="dummy"/>
		<tr xo-scope="{../@xo:id}" style="height:15px !important; background-color: #dc3545 !important;">
			<td colspan="{count($layout)+3}" style="text-align:center;">
				<div xo-attribute="state:delete">
					<span class="badge-delete p-1 badge-danger-light" onclick="scope.remove()">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-counterclockwise" viewBox="0 0 16 16">
							<path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"></path>
							<path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"></path>
						</svg>&#160;Cancelar borrar
					</span>
				</div>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:row-header" match="@*">
		<xsl:param name="dataset" select="../@*"/>
		<xsl:param name="reference" select="xo:dummy"/>
		<xsl:comment>No row-header</xsl:comment>
	</xsl:template>

	<xsl:template mode="datagrid:row-footer" match="@*">
		<xsl:param name="dataset" select="../@*"/>
		<xsl:comment>No row-footer</xsl:comment>
	</xsl:template>

	<xsl:template mode="datagrid:row-body" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="current" select="current()"/>
		<xsl:variable name="cell_type">
			<xsl:choose>
				<xsl:when test="$context='header'">th</xsl:when>
				<xsl:otherwise>td</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$cell_type}">
			<xsl:if test="$context='header'">
				<xsl:attribute name="scope">col</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="style">
				<xsl:apply-templates mode="datagrid:cell-style" select="current()"/></xsl:attribute>
			<xsl:apply-templates mode="datagrid:cell-attributes" select="current()"/>
			<xsl:apply-templates mode="datagrid:cell-content" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
			<xsl:comment>
				<xsl:value-of select="concat($dataset,'::',$context,'::',name(..),'::',../@Name)"/>
			</xsl:comment>
		</xsl:element>
	</xsl:template>

	<xsl:template mode="datagrid:cell-style" match="@*"/>
	<xsl:template mode="datagrid:cell-attributes" match="@*"/>

	<xsl:template mode="datagrid:cell-content-append" match="@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content-prepend" match="@*">
		<xsl:text>&#160;</xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="ref_field" select="key('reference',concat($dataset,'::',$context,'::',name(..),'::',../@Name))"/>
		<xsl:comment>
		<xsl:value-of select="../@Name"/>
		</xsl:comment>
		<xsl:choose>
			<xsl:when test="$ref_field">
				<xsl:apply-templates mode="datagrid:cell-content-append" select="$ref_field"/>
				<xsl:apply-templates mode="widget" select="$ref_field"/>
				<xsl:apply-templates mode="datagrid:cell-content-prepend" select="$ref_field"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>No se pudo encontrar una referencia para <xsl:value-of select="../@xo:id"/> (<xsl:value-of select="name(..)"/>)
			</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="container:*/@Name">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:choose>
			<xsl:when test="$context='header'">
				<xsl:apply-templates mode="headerText" select="."/>
				<!--<xsl:apply-templates mode="datagrid:cell-content" select="../@xo:id">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>-->
			</xsl:when>
			<xsl:otherwise>
		<xsl:comment>
			<xsl:value-of select="$context"/>: <xsl:value-of select="name()"/>
		</xsl:comment>
				<xsl:apply-templates mode="datagrid:cell-content" select="../*/@xo:id">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('datagrid:nodeType',concat(@xo:id,'::header'))]/@*">
		<xsl:apply-templates mode="headerText" select="."/>
	</xsl:template>

	<xsl:template mode="datagrid:buttons-new" match="@*">
		<button type="button" class="btn btn-success btn-sm" onclick="px.navigateTo('{concat(../@Schema,'/',../@Name)}~add','{ancestor::*[@meta:type='entity'][1]/data:rows/@xo:id}')">Agregar registro</button>
	</xsl:template>

	<xsl:key name="selected" match="*[@state:selected]" use="@xo:id"/>

	<xsl:template mode="datagrid:list" match="*|text()"/>

	<xsl:template mode="datagrid:list" match="data:rows/*">
		<li class="list-group-item d-flex justify-content-between lh-sm">
			<div>
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

</xsl:stylesheet>