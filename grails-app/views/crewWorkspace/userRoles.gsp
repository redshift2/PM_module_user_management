<div class="pm-shell" data-pm-theme="dark"><g:render template="/shared/pmShellStyles"/><g:render template="/shared/pmShellSidebar"/><div class="pm-main"><g:render template="/shared/pmShellHeader" model="[moduleTitle:'User Management']"/><main class="pm-content"><style>
.pm-shell .crew-wrap{padding:18px 12px 32px;color:var(--pm-text)}
.pm-shell .crew-tabs{display:flex;gap:8px;margin-bottom:18px;flex-wrap:wrap}
.pm-shell .crew-btn,.pm-shell .crew-tabs a{display:inline-block;padding:9px 13px;background:var(--pm-surface);color:var(--pm-text);border:1px solid var(--pm-border);border-radius:5px;text-decoration:none}
.pm-shell .crew-tabs a.active{background:var(--pm-blue);color:#fff}
.pm-shell .crew-card{border:1px solid var(--pm-border);background:var(--pm-surface);border-radius:6px;overflow:hidden}
.pm-shell .crew-card h2{padding:15px;margin:0;background:var(--pm-sidebar);font-size:17px}
.pm-shell .crew-table-wrap{overflow-x:auto}
.pm-shell .crew-table{width:100%;border-collapse:collapse}
.pm-shell .crew-table th,.pm-shell .crew-table td{text-align:left;padding:11px 13px;border-bottom:1px solid var(--pm-border);color:var(--pm-text)}
.pm-shell .crew-table th{background:var(--pm-sidebar)}
.pm-shell .crew-table tbody tr:nth-child(even){background:color-mix(in srgb,var(--pm-surface) 70%,var(--pm-sidebar))}
.pm-shell .crew-form{display:flex;gap:9px;padding:14px;align-items:center;flex-wrap:wrap}
.pm-shell .crew-form input{min-width:230px;flex:1;background:var(--pm-bg);border:1px solid var(--pm-border);border-radius:4px;padding:9px;color:var(--pm-text)}
.pm-shell .crew-link{color:#8bc6ff}
.pm-shell[data-pm-theme=light] .crew-link{color:#155a99}
.pm-shell .crew-foot{display:flex;gap:12px;align-items:center;padding:12px}

.pm-shell .crew-edit{padding:20px;max-width:900px}.pm-shell .crew-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:14px}.pm-shell .crew-edit label{display:block;font-weight:600}.pm-shell .crew-edit input:not([type=checkbox]),.pm-shell .crew-edit select{box-sizing:border-box;display:block;width:100%;margin-top:6px;padding:10px;border:1px solid var(--pm-border);background:var(--pm-bg);color:var(--pm-text);border-radius:5px}.pm-shell .crew-check{display:flex!important;align-items:center;gap:9px;margin:12px 0}.pm-shell .crew-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:20px}.pm-shell .crew-notice{padding:12px;margin:12px 0;border:1px solid var(--pm-border);border-radius:5px}
</style><div class="crew-wrap"><nav class="crew-tabs"><g:link controller="crewWorkspace" action="index">Users</g:link><g:link controller="crewWorkspace" action="roles">Roles</g:link><g:link controller="crewWorkspace" action="hierarchy">Organization Hierarchy</g:link></nav><g:if test="${flash.error}"><div class="crew-notice" role="alert">${flash.error.encodeAsHTML()}</div></g:if><g:if test="${flash.message}"><div class="crew-notice">${flash.message.encodeAsHTML()}</div></g:if><section class="crew-card"><h2>Roles for ${user.username?.encodeAsHTML()}</h2><div class="crew-edit"><g:form controller="crewWorkspace" action="saveUserRoles" method="POST"><g:hiddenField name="id" value="${user.id}"/><g:each in="${roles}" var="r"><label class="crew-check"><input type="checkbox" name="roleIds" value="${r.id}" ${assigned.contains(r.id) ? 'checked' : ''}/>${r.authority?.encodeAsHTML()}</label></g:each><div class="crew-actions"><button type="submit" class="crew-btn">Save Roles</button><g:link controller="crewWorkspace" action="editUser" id="${user.id}" class="crew-btn">Back to User</g:link></div></g:form></div></section></div></main></div><g:render template="/shared/pmShellScript"/></div>