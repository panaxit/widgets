<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:source="http://panax.io/fetch/request"
  xmlns:state="http://panax.io/state"
  xmlns:data="http://panax.io/source"
  xmlns:groupTabPanel="http://panax.io/widget/groupTabPanel"
  xmlns:container="http://panax.io/layout/container"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io"
  exclude-result-prefixes="px state xo source data xsi"
  xmlns="http://www.w3.org/1999/xhtml"
>
	<xsl:template match="/" priority="-1">
		<xsl:apply-templates select="*/@xo:id" mode="groupTabPanel:widget"/>
	</xsl:template>

	<xsl:template match="text()" mode="groupTabPanel:widget"/>
	<xsl:template match="text()" mode="groupTabPanel:widget-header"/>
	<xsl:template match="text()" mode="groupTabPanel:widget-header-title-label"/>
	<xsl:template match="text()" mode="groupTabPanel:widget-body"/>
	<xsl:template match="text()" mode="groupTabPanel:widget-footer"/>

	<xsl:key name="active" match="node-expected" use="@xo:id"/>
	<xsl:key name="active" match="*[not(@state:active_child)]/container:groupTabPanel[1]" use="@xo:id"/>
	<xsl:key name="active" match="container:groupTabPanel[@xo:id=../@state:active_child]" use="@xo:id"/>
	<xsl:key name="active" match="*[not(@state:active_child)]/container:subGroupTabPanel[1]" use="@xo:id"/>
	<xsl:key name="active" match="container:subGroupTabPanel[@xo:id=../@state:active_child]" use="@xo:id"/>
	<xsl:key name="show" match="container:groupTabPanel[@state:show]" use="@xo:id"/>

	<xsl:template match="@*" mode="groupTabPanel:widget" priority="-1">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="current_panel" select="../container:groupTabPanel[key('active', @xo:id)]/container:subGroupTabPanel[key('active', @xo:id)]/container:panel/*"/>
		<div class="row group-tab-pane align-top">
			<xo-listener attribute="state:active_child"/>
			<div class="col-4 col-md-3 col-lg-2 col-xl-2 group-tab-nav">
				<div class="accordion" id="accordionExample">
					<xsl:apply-templates mode="groupTabPanel:nav-item" select="../*/@Name|../*[not(@Name)]/@xo:id"/>
				</div>
			</div>
			<div class="col-8 col-md-9 col-lg-10 col-xl-10" style="padding-left: unset;">
				<div class="tab-content" id="v-pills-tabContent">
					<xsl:apply-templates mode="widget" select="$current_panel/@Name|$current_panel[not(@Name)]/@xo:id"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="groupTabPanel:body" match="@*">
		<!--<div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Abreviatura:</label>
				<div class="col-sm-9">
					<style>
						.money::before {{
						content:"$";
						}}
					</style>
					<input id="Abreviatura_id255" type="text" size="15" maxlength="15" class="form-control 
							required " onchange="this.source.setAttribute('@value', this.value);" value="EDEV"/>
					<span class="invalid-feedback" style="margin-left:5pt;">Campo requerido</span>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Fraccionamiento Padre:</label>
				<div class="col-sm-9">
					<div class="input-group">
						<select id="IdFraccionamientoPadre_id256" class="form-select  text-black-50 " onchange="this.source.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}); this.store.selectNodes(`//*[@x:id='Condominio_id257']`).map(node=>node.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}))">
							<option value="" selected="">Selecciona Fraccionamiento Padre</option>
							<option value="48">Ejemplo dev</option>
							<option value="45">Prueba Dev</option>
						</select>
						<div class="input-group-append">
							<div class="w3-dropdown-hover input-group-append" style="color:black;">
								<button class="btn btn-outline-info w3-dropdown-hover" type="button" onclick="" tabindex="-1">
									<i class="fas fa-cog" style="color:black;"></i>
								</button>
								<div class="w3-dropdown-content w3-bar-block w3-card-4 xover-popover" style="font-family: Verdana,sans-serif;     font-size: 9pt;">
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-sync-alt" style="color:blue;"></span>
										<span style="cursor:pointer;" xo-source="IdFraccionamientoPadre_id256" onclick="var src = source.selectSingleNode('.//source:value'); if (!src) {{return}}; store.selectNodes('//source:value[@command=&quot;'+src.getAttribute('command')+'&quot;]'); xover.data.binding.requests[store.tag][`${{src.getAttribute('command')}}`]; src.remove();">
											Actualizar
										</span>
									</a>
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-plus-circle" style="color:green;"></span>
										<span style="cursor:pointer;" onclick="px.request('[Fraccionamientos].[Condominio]','add');">Crear Nuevo</span>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Nombre de Condominio:</label>
				<div class="col-sm-9">
					<style>
						.money::before {{
						content:"$";
						}}
					</style>
					<input id="Fraccionamiento_id258" type="text" size="25" maxlength="100" class="form-control 
							required " onchange="this.source.setAttribute('@value', this.value);" value="Ejemplo dev"/>
					<span class="invalid-feedback" style="margin-left:5pt;">Campo requerido</span>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Nombre Comercial:</label>
				<div class="col-sm-9">
					<style>
						.money::before {{
						content:"$";
						}}
					</style>
					<input id="NombreComercial_id259" type="text" size="25" maxlength="100" class="form-control" onchange="this.source.setAttribute('@value', this.value);" value=""/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Razon Social:</label>
				<div class="col-sm-9">
					<div class="input-group">
						<select id="RazonSocial_id260" class="form-select  text-black " onchange="this.source.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}); this.store.selectNodes(`//*[@x:id='Empresa_id261']`).map(node=>node.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}))">
							<option value="" selected="">Selecciona Razon Social</option>
							<option value="1021" selected="">ACV1902155N0 - ADMINISTRACION CONDOMINIOS VALTUS SC</option>
						</select>
						<div class="input-group-append">
							<div class="w3-dropdown-hover input-group-append" style="color:black;">
								<button class="btn btn-outline-info w3-dropdown-hover" type="button" onclick="" tabindex="-1">
									<i class="fas fa-cog" style="color:black;"></i>
								</button>
								<div class="w3-dropdown-content w3-bar-block w3-card-4 xover-popover" style="font-family: Verdana,sans-serif;     font-size: 9pt;">
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-sync-alt" style="color:blue;"></span>
										<span style="cursor:pointer;" xo-source="RazonSocial_id260" onclick="var src = source.selectSingleNode('.//source:value'); if (!src) {{return}}; store.selectNodes('//source:value[@command=&quot;'+src.getAttribute('command')+'&quot;]'); xover.data.binding.requests[store.tag][`${{src.getAttribute('command')}}`]; src.remove();">
											Actualizar
										</span>
									</a>
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-plus-circle" style="color:green;"></span>
										<span style="cursor:pointer;" onclick="px.request('[Corporativo].[Empresa]','add');">Crear Nuevo</span>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Logotipo:</label>
				<div class="col-sm-9">
					<div class="input-group file_control">
						<img id="Logotipo_id262" src="./images/filesystem/no_photo.png" alt="Sin imagen disponible" style="width:100px;"/>
						<div class="input-group-append">
							<style>

								.datagrid .file_control .custom-file {{display:none;}}
								.datagrid .file_control .input-group-append {{display:none;}}
								.datagrid .file_control .progress {{display:none;}}
								.datagrid .file_control .validar_documento {{background-color: silver;}}
								.datagrid td {{white-space:unset;}}

							</style>
							<div class="input-group mb-2 file_control">
								<div class="custom-file">
									<input type="file" readonly="" class="custom-file-input" id="Logotipo_id262" name="Logotipo_id262" onchange="xover.server.uploadFile(this, 'Logotipo_id262', 'app/custom/images');" xo-attribute="value"/>
									<label for="Logotipo_id262" class="custom-file-label text-black-50">
										Buscar archivo...
									</label>
									<div class="invalid-feedback">Example invalid custom file feedback</div>
								</div>
								<div class="progress" style="height: 5px; width:100%">
									<div id="_progress_bar_Logotipo_id262" class="progress-bar bg-success" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Cantidad Casas:</label>
				<div class="col-sm-9">
					<div class="custom-file">
						<input type="text" readonly="" class="form-control-plaintext" value="10"/>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Supervisor:</label>
				<div class="col-sm-9">
					<div class="input-group">
						<select id="IdSupervisor_id264" class="form-select  text-black-50 " onchange="this.source.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}); this.store.selectNodes(`//*[@x:id='Colaborador_id265']`).map(node=>node.setAttributes({{'@value':this.value,'@text':this[this.selectedIndex].text}}))">
							<option value="" selected="">Selecciona Supervisor</option>
							<option value="4">Sergio Arturo Ortiz Wong</option>
						</select>
						<div class="input-group-append">
							<div class="w3-dropdown-hover input-group-append" style="color:black;">
								<button class="btn btn-outline-info w3-dropdown-hover" type="button" onclick="" tabindex="-1">
									<i class="fas fa-cog" style="color:black;"></i>
								</button>
								<div class="w3-dropdown-content w3-bar-block w3-card-4 xover-popover" style="font-family: Verdana,sans-serif;     font-size: 9pt;">
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-sync-alt" style="color:blue;"></span>
										<span style="cursor:pointer;" xo-source="IdSupervisor_id264" onclick="var src = source.selectSingleNode('.//source:value'); if (!src) {{return}}; store.selectNodes('//source:value[@command=&quot;'+src.getAttribute('command')+'&quot;]'); xover.data.binding.requests[store.tag][`${{src.getAttribute('command')}}`]; src.remove();">
											Actualizar
										</span>
									</a>
									<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
										<span class="fas fa-plus-circle" style="color:green;"></span>
										<span style="cursor:pointer;" onclick="px.request('[Corporativo].[Colaborador]','add');">Crear Nuevo</span>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Genera Factura:</label>
				<div class="col-sm-9">
					<div class="btn-group" role="group" aria-label="Basic example" style="position:relative;">
						<button type="button" class="btn btn-success" xo-source="GeneraFactura_id266" onclick="
						this.source.setAttribute('@value','')
					">Sí</button>
						<button type="button" class="btn btn-outline-danger" xo-source="GeneraFactura_id266" onclick="this.source.setAttribute('@value',0)">No</button>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Activo:</label>
				<div class="col-sm-9">
					<div class="btn-group" role="group" aria-label="Basic example" style="position:relative;">
						<button type="button" class="btn btn-outline-success" xo-source="Activo_id267" onclick="this.source.setAttribute('@value',1)">Sí</button>
						<button type="button" class="btn btn-outline-danger" xo-source="Activo_id267" onclick="this.source.setAttribute('@value',0)">No</button>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Email:</label>
				<div class="col-sm-9">
					<input id="Email_id268" type="email" autocomplete="off" value="ejemplo@edev.com" size="25" maxlength="255" class="form-control " onchange="this.source.setAttribute('@value',this.value)" placeholder="correo@dominio.com"/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Telefono:</label>
				<div class="col-sm-9">
					<style>
						.money::before {{
						content:"$";
						}}
					</style>
					<input id="Telefono_id269" type="text" size="25" maxlength="45" class="form-control" onchange="this.source.setAttribute('@value', this.value);" value="4448965217"/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Dias Liquidar:</label>
				<div class="col-sm-9">
					<style>
						.money::before {{
						content:"$";
						}}
					</style>
					<input id="DiasLiquidar_id270" type="text" size="10" maxlength="10" class="form-control" onchange="this.source.setAttribute('@value', this.value);" value="10"/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Inicio Administracion:</label>
				<div class="col-sm-9">
					<input id="InicioAdministracion_id271" type="date" onchange="if (isValidISODate(this.value)) {{this.source.setAttribute('@value', this.value)}}" value="2022-05-05" class="form-control "/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Fecha Limite Pago:</label>
				<div class="col-sm-9">
					<input id="FechaLimitePago_id272" type="date" onchange="if (isValidISODate(this.value)) {{this.source.setAttribute('@value', this.value)}}" value="2022-05-15" class="form-control "/>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Comentarios:</label>
				<div class="col-sm-9">
					<textarea id="Comentarios_id273" class="form-control " onchange="this.source.setAttribute('@value', this.value)" style="min-height: 29.19px;"></textarea>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Notas:</label>
				<div class="col-sm-9">
					<textarea id="Notas_id274" class="form-control " onchange="this.source.setAttribute('@value', this.value)" style="min-height: 29.19px;"></textarea>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-3 col-form-label">Observaciones:</label>
				<div class="col-sm-9">
					<textarea id="Observaciones_id275" class="form-control " onchange="this.source.setAttribute('@value', this.value)" style="min-height: 29.19px;"></textarea>
				</div>
			</div>
		</div>-->
	</xsl:template>

	<xsl:template mode="groupTabPanel:nav-item" match="container:groupTabPanel/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id)">active</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="show">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id) or key('show', ../@xo:id)">show</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="collapsed">
			<xsl:choose>
				<xsl:when test="not($show='show')">collapsed</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="item_position" select="count(../preceding-sibling::*)"/>
		<div class="accordion-item">
			<h2 class="accordion-header" id="heading_{$item_position}">
				<button class="accordion-button {$collapsed}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse_{$item_position}" aria-controls="collapse_{$item_position}" xo-scope="{../@xo:id}" onclick="scope.parentNode.set('state:active_child','{../@xo:id}')">
					<xsl:attribute name="aria-expanded">
						<xsl:choose>
							<xsl:when test="$show = 'show'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:apply-templates mode="headerText" select="."/>
				</button>
			</h2>
			<div id="collapse_{$item_position}" class="accordion-collapse collapse {$show}" aria-labelledby="heading_{$item_position}" data-bs-parent="#accordionExample">
				<xsl:variable name="children_items" select="../*"/>
				<xsl:if test="count($children_items) &gt; 1">
					<div class="accordion-body">
						<ul class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical" style="width:fit-content;">
							<xsl:apply-templates mode="groupTabPanel:nav-item" select="$children_items/@Name|$children_items[not(@Name)]/@xo:id"/>
						</ul>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="groupTabPanel:nav-item" match="container:subGroupTabPanel/@*">
		<xsl:param name="schema" select="node-expected"/>
		<xsl:param name="dataset" select="node-expected"/>
		<xsl:variable name="active">
			<xsl:choose>
				<xsl:when test="key('active', ../@xo:id)">active</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<li class="nav-item" style="margin-bottom: 10px;" xo-scope="{../../@xo:id}" xo-attribute="state:active_child" onclick="scope.set('{../@xo:id}')">
			<a class="nav-link {$active}" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-home" role="tab" aria-controls="v-pills-home" aria-selected="true">
				<xsl:apply-templates mode="headerText" select="."/>
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>