<div class="pm-shell" data-pm-theme="dark">
<g:render template="/shared/pmShellStyles"/>
<g:render template="/shared/pmShellSidebar"/>
<div class="pm-main">
<g:render template="/shared/pmShellHeader" model="[moduleTitle:'User Management']"/>
<main class="pm-content">
<div style="
    position:relative !important;
    z-index:100 !important;
    margin:20px 0 !important;
    padding:20px !important;
    background:#ffcc00 !important;
    color:#000 !important;
    border:3px solid red !important;
    font-size:18px !important;
">
    TEST - UPDATED USER MANAGEMENT PAGE

    <br/>

    Logged in as: <sec:username/>

    <br/>

    ROLE_ADMIN:
    <sec:ifAllGranted roles="ROLE_ADMIN">YES</sec:ifAllGranted>
    <sec:ifNotGranted roles="ROLE_ADMIN">NO</sec:ifNotGranted>
</div>
<!-- Temporary role diagnostics; remove after testing -->
<div style="padding:12px;color:#ffcc00">
Logged in as: <sec:username/><br/>
ROLE_ADMIN: <sec:ifAllGranted roles="ROLE_ADMIN">YES</sec:ifAllGranted><sec:ifNotGranted roles="ROLE_ADMIN">NO</sec:ifNotGranted>
</div>

<style>
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
</style>
<div class="crew-wrap">
<nav class="crew-tabs" aria-label="User Management pages">
<g:link controller="crewWorkspace" action="index" class="active">Users</g:link>
<g:link controller="crewWorkspace" action="roles" class="${tab == 'roles' ? 'active' : ''}">Roles</g:link>
<g:link controller="crewWorkspace" action="hierarchy" class="${tab == 'hierarchy' ? 'active' : ''}">Organization Hierarchy</g:link>
</nav>
<sec:ifAllGranted roles="ROLE_ADMIN"><div class="crew-actions" style="margin-bottom:14px"><g:link controller="crewWorkspace" action="editUser" class="crew-btn">+ Create User</g:link></div></sec:ifAllGranted><section class="crew-card"><h2>Users (${total}) — STAGE 2 TEST</h2>
<g:form controller="crewWorkspace" action="index" method="GET" class="crew-form"><input type="search" name="q" value="${q?.encodeAsHTML()}" placeholder="Search users, names or email"/><button type="submit" class="crew-btn">Search</button><g:link controller="crewWorkspace" action="index" class="crew-btn">Clear</g:link><g:link controller="crew" action="index" class="crew-btn">Legacy User Editor</g:link></g:form>
<div class="crew-table-wrap"><table class="crew-table"><thead><tr><th>Username</th><th>Name</th><th>Email</th><th>Manager</th><th>Status</th><th>Actions</th></tr></thead><tbody>
<g:each in="${users}" var="u"><tr><td>${u.username?.encodeAsHTML()}</td><td>${((u.firstName ?: '') + ' ' + (u.lastName ?: '')).trim().encodeAsHTML()}</td><td>${u.mail?.encodeAsHTML()}</td><td>${u.manager?.username?.encodeAsHTML()}</td><td>${u.enabled ? 'Enabled' : 'Disabled'}</td><td><sec:ifAllGranted roles="ROLE_ADMIN"><g:link controller="crewWorkspace" action="editUser" id="${u.id}" class="crew-link">Edit</g:link> · <g:link controller="crewWorkspace" action="userRoles" id="${u.id}" class="crew-link">Roles</g:link></sec:ifAllGranted><sec:ifNotGranted roles="ROLE_ADMIN"><g:link controller="crew" action="showUserFromSearch" id="${u.id}" class="crew-link">Details</g:link></sec:ifNotGranted></td></tr></g:each>
<g:if test="${!users}"><tr><td colspan="6">No users found.</td></tr></g:if>
</tbody></table></div><div class="crew-foot"><span>${offset + 1}–${Math.min(offset + users.size(), total)} of ${total}</span><g:if test="${offset > 0}"><g:link controller="crewWorkspace" action="index" params="[q:q,max:max,offset:Math.max(0,offset-max)]" class="crew-btn">Previous</g:link></g:if><g:if test="${offset + users.size() < total}"><g:link controller="crewWorkspace" action="index" params="[q:q,max:max,offset:offset+max]" class="crew-btn">Next</g:link></g:if></div></section>
</div></main></div><g:render template="/shared/pmShellScript"/></div>