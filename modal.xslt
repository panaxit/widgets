<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:source="http://panax.io/fetch/request"
  xmlns:state="http://panax.io/state"
  xmlns:modal="http://panax.io/widget/modal"
  xmlns:px="http://panax.io"
  exclude-result-prefixes="px state xo source"
  xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:template match="/" priority="-1">
		<xsl:apply-templates select="*/@xo:id" mode="modal:widget"/>
	</xsl:template>

	<xsl:template match="text()" mode="modal:widget"/>
	<xsl:template match="text()" mode="modal:widget-header"/>
	<xsl:template match="text()" mode="modal:widget-header-title-label"/>
	<xsl:template match="text()" mode="modal:widget-body"/>
	<xsl:template match="text()" mode="modal:widget-footer"/>

	<xsl:template match="*" mode="modal:widget-attributes-class" priority="-1">
		<xsl:text/>modal-dialog-centered<xsl:text/>
	</xsl:template>

	<xsl:template match="@*" mode="modal:widget" priority="-1">
		<div role="alertdialog">
			<div class="modal fade" id="modal_{@xo:id}" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel_{@xo:id}" aria-hidden="true">
				<!--data-bs-backdrop="static" data-bs-keyboard="false" -->
				<xsl:attribute name="class">modal fade show</xsl:attribute>
				<xsl:attribute name="style">display: block;</xsl:attribute>
				<xsl:attribute name="aria-modal">true</xsl:attribute>
				<xsl:variable name="class">
					<xsl:apply-templates mode="modal:widget-attributes-class" select="."/>
				</xsl:variable>
				<div class="modal-dialog {$class}">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="staticBackdropLabel_{@xo:id}">
								<xsl:apply-templates mode="modal:widget-header-title-label" select="."/>
							</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" data-bs-target="#modal_{@xo:id}">
								<xsl:apply-templates mode="modal:widget-buttons-close-attributes" select="."/>
								<span aria-hidden="true">&#215;</span>
							</button>
						</div>
						<div class="modal-body">
							<xsl:apply-templates mode="modal:widget-body" select="."/>
						</div>
						<div class="modal-footer">
							<xsl:apply-templates mode="modal:widget-footer" select="."/>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-backdrop fade show"></div>
		</div>
	</xsl:template>

	<xsl:template match="@*" mode="modal:widget-buttons-close-attributes-onclick" priority="-10">
		<xsl:text/>closest(`[role='alertdialog']`).remove()<xsl:text/>
	</xsl:template>

	<xsl:template match="@*" mode="modal:widget-buttons-close-attributes" priority="-10">
		<xsl:attribute name="onclick">
			<xsl:apply-templates mode="modal:widget-buttons-close-attributes-onclick" select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="@*|*[not(descendant::*)]" mode="modal:widget-header-title-label" priority="-10">modal:widget-header-title-label</xsl:template>
	<xsl:template match="@*|*[not(descendant::*)]" mode="modal:widget-body" priority="-10">modal:widget-body</xsl:template>
	<xsl:template match="@*|*[not(descendant::*)]" mode="modal:widget-footer" priority="-10">modal:widget-footer</xsl:template>

</xsl:stylesheet>