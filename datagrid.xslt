<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"
  xmlns:widget="http://panax.io/widget"
  exclude-result-prefixes="xo state xsl datagrid data px meta"
>
	<xsl:import href="../keys.xslt"/>
	<xsl:import href="../values.xslt"/>
	<xsl:import href="../headers.xslt"/>

	<xsl:param name="state:delete"/>

	<xsl:key name="datagrid:widget" match="dummy" use="@xo:id"/>
	<xsl:key name="data:wrapper" match="data:rows" use="generate-id()"/>

	<xsl:template mode="datagrid:widget" match="@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="layout" select="*"/>
		<div class="row">
			<xsl:if test="concat(../@Schema,'.',../@Name)='Reportes.Embarques'">
				<xsl:attribute name="class"/>
			</xsl:if>
			<style>
				<![CDATA[
				tr.deleting, tr.deleting:hover {
				background: red;
				color:white !important;
				}

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
				}]]>
			</style>
			<xo-listener attribute="xsi:nil"/>
			<table class="table table-striped table-hover table-sm">
				<xsl:apply-templates mode="datagrid:header" select="$schema/ancestor-or-self::px:Record[1]/@xo:id">
					<xsl:with-param name="dataset" select="$schema"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="datagrid:body" select="$dataset">
					<xsl:with-param name="dataset" select="$dataset/ancestor-or-self::*[1]/descendant-or-self::*[self::xo:r or self::xo:empty]/@xo:id"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="datagrid:footer" select="$dataset">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
			</table>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid:header" match="@*">
		<xsl:param name="context">header</xsl:param>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<thead class="freeze">
			<xsl:apply-templates mode="datagrid:row" select="current()">
				<xsl:with-param name="dataset" select="$dataset"/>
				<xsl:with-param name="context">header</xsl:with-param>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
		</thead>
	</xsl:template>

	<xsl:template mode="datagrid:body" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<tbody class="table-group-divider">
			<xsl:apply-templates mode="datagrid:row" select="$dataset">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
			<xsl:if test="not($dataset)">
				<tr>
					<td>&#160;</td>
					<xsl:choose>
						<xsl:when test="../@xsi:nil">
							<td colspan="{count($layout)}">
								<label>No hay registros</label>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$layout">
								<td style="text-align:center">
									<div class="skeleton skeleton-text">&#160;</div>
								</td>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<td>&#160;</td>
				</tr>
			</xsl:if>
		</tbody>
	</xsl:template>

	<xsl:template mode="datagrid:footer" match="@*">
		<xsl:param name="context">footer</xsl:param>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:param name="layout" select="ancestor-or-self::*[1]/@xo:id"/>
		<tfoot class="table-group-divider">
			<xsl:apply-templates mode="datagrid:row" select="..">
				<xsl:with-param name="context">footer</xsl:with-param>
				<xsl:with-param name="layout" select="$layout"/>
			</xsl:apply-templates>
			<xsl:if test="ancestor-or-self::*[@meta:type='entity'][2]">
				<tr xo-scope="{ancestor-or-self::*[@meta:type='entity'][1]/@xo:id}">
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
		<xsl:param name="layout" select="node-expected"/>
		<tr xo-scope="{../@xo:id}">
			<xsl:attribute name="style">
				<xsl:apply-templates mode="datagrid:row-style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="datagrid:row-attributes" select="current()"/>
			<xsl:apply-templates mode="datagrid:row-header" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:row-body" select="$layout">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="datagrid:row-footer" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid:row" match="xo:empty/@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="../@*"/>
		<xsl:param name="layout" select="node-expected"/>
		<tr xo-scope="{../@xo:id}">
			<xsl:attribute name="style">
				<xsl:apply-templates mode="datagrid:row-style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates mode="datagrid:row-attributes" select="current()"/>
			<xsl:apply-templates mode="datagrid:row-header" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
			<td colspan="{count($dataset)}">
				<xsl:apply-templates select="current()"/>
			</td>
			<xsl:apply-templates mode="datagrid:row-footer" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template match="xo:empty/@*">
		<label>No hay registros</label>
	</xsl:template>

	<xsl:template mode="datagrid:row" match="xo:r[@state:delete]/@xo:id">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="../@*"/>
		<xsl:param name="layout" select="node-expected"/>
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
		<xsl:param name="dataset" select="node-expected"/>
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
				<xsl:apply-templates mode="datagrid:cell-style" select="current()"/>
			</xsl:attribute>
			<xsl:apply-templates mode="datagrid:cell-attributes" select="current()"/>
			<xsl:apply-templates mode="datagrid:cell-content" select="current()">
				<xsl:with-param name="context" select="$context"/>
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template mode="datagrid:cell-style" match="@*"/>
	<xsl:template mode="datagrid:cell-attributes" match="@*"/>

	<xsl:template mode="datagrid:field-append" match="@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:field-append" match="xo:r/@*">
		<xsl:text>&#160;</xsl:text>
	</xsl:template>


	<xsl:template mode="datagrid:field-prepend" match="@*">
		<xsl:text></xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="."/>
		<xsl:variable name="ref_field" select="$dataset[name()=current()[parent::field:ref]]|$dataset[name()=concat('meta:',current()[parent::association:ref])]"/>
		<span>
			<xsl:choose>
				<xsl:when test="$context='header'">
					<xsl:apply-templates mode="datagrid:header-content" select=".">
						<xsl:with-param name="dataset" select="$dataset"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="count($ref_field|current())=1">
					<xsl:apply-templates mode="datagrid:field-prepend" select="."/>
					<xsl:apply-templates mode="datagrid:field" select="current()"/>
					<xsl:apply-templates mode="datagrid:field-append" select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="datagrid:cell-content" select="$ref_field">
						<xsl:with-param name="dataset" select="current()"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>

	<xsl:template mode="datagrid:header-content" match="@*">
		<xsl:param name="dataset" select="."/>
		<xsl:variable name="ref_field" select="$dataset[name()=current()[parent::field:ref]]|$dataset[name()=concat('meta:',current()[parent::association:ref])]"/>
		<span>
			<xsl:apply-templates mode="headerText" select=".">
				<xsl:with-param name="dataset" select="$dataset"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template mode="datagrid:cell-content" match="container:*/@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:apply-templates mode="datagrid:cell-content" select="../*[$context='header'][1]/@Name|../*[$context!='header']/@Name">
			<xsl:with-param name="context" select="$context"/>
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="dataset" select="$dataset"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--<xsl:template mode="datagrid:cell-content" match="container:*/@Name">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:choose>
			<xsl:when test="$context='header'">
				<xsl:apply-templates mode="headerText" select="."/>
				<xsl:apply-templates mode="datagrid:cell-content" select="../@xo:id">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:apply-templates>
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
	</xsl:template>-->

	<xsl:template mode="datagrid:field" match="@*">
		<span>
			<xsl:attribute name="style">
				<xsl:apply-templates mode="widget:style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>

	<xsl:template mode="datagrid:field" match="association:ref/@*">
		<div class="skeleton skeleton-text">&#160;</div>
	</xsl:template>

	<xsl:template mode="datagrid:field" match="field:ref/@*">
		<div>&#160;</div>
	</xsl:template>

	<xsl:template mode="datagrid:field" match="xo:r[@state:edit='true']/@*">
		<span>
			<xsl:apply-templates mode="widget" select="."/>
		</span>
	</xsl:template>

	<xsl:template mode="widget" match="*[key('datagrid:header-node',@xo:id)]/@*">
		<span>
			<xsl:apply-templates mode="headerText" select="."/>
		</span>
	</xsl:template>

	<xsl:template mode="datagrid:buttons-new" match="@*">
		<xsl:variable name="reference">
			<xsl:choose>
				<xsl:when test="ancestor::px:Association">
					<xsl:value-of select="concat('@',../@xo:id)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<button type="button" class="btn btn-success btn-sm" onclick="px.navigateTo('{concat(ancestor::px:Entity[1]/@Schema,'/',ancestor::px:Entity[1]/@Name,$reference)}~add','{ancestor-or-self::*[@meta:type='entity'][1]/data:rows/@xo:id}')">Agregar registro</button>
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