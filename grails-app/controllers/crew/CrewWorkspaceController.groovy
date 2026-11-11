package crew

import grails.plugin.springsecurity.annotation.Secured

/** Read-only shared-shell pages; existing Crew actions remain authoritative for edits. */
@Secured(['isAuthenticated()'])
class CrewWorkspaceController {
    def index() {
        String q = params.q?.toString()?.trim()
        int max = Math.min(Math.max(params.int('max') ?: 30, 1), 100)
        int offset = Math.max(params.int('offset') ?: 0, 0)
        List<User> users
        long total
        if (q) {
            String term = '%' + q.toLowerCase() + '%'
            users = User.executeQuery("""select u from User u where lower(u.username) like :term
                or lower(coalesce(u.firstName, '')) like :term
                or lower(coalesce(u.lastName, '')) like :term
                or lower(coalesce(u.mail, '')) like :term order by u.username""",
                [term:term], [max:max, offset:offset])
            total = (User.executeQuery("""select count(u.id) from User u where lower(u.username) like :term
                or lower(coalesce(u.firstName, '')) like :term
                or lower(coalesce(u.lastName, '')) like :term
                or lower(coalesce(u.mail, '')) like :term""", [term:term])[0] as Number).longValue()
        } else {
            users = User.list(max:max, offset:offset, sort:'username', order:'asc')
            total = User.count()
        }
        [users:users, total:total, q:q ?: '', max:max, offset:offset]
    }

    def roles() {
        [roles:Role.list(sort:'authority', order:'asc')]
    }

    def hierarchy() {
        // Flat, sorted roster with each user's manager; avoids recursive cycles.
        [users:User.list(sort:'username', order:'asc')]
    }

    def springSecurityService

    @Secured(['ROLE_ADMIN'])
    def editUser() {
        User user = params.long('id') ? User.get(params.long('id')) : null
        if (params.long('id') && !user) { response.sendError(404); return }
        [user:user, managers:User.list(sort:'username',order:'asc'),
         businessUnits:crew.config.BusinessUnit.values(),
         subsidiaries:crew.config.Subsidiary.values(),
         languages:crew.config.SupportedLanguage.values()]
    }

    @Secured(['ROLE_ADMIN'])
    @grails.gorm.transactions.Transactional
    def saveUser() {
        if (request.method != 'POST') { response.sendError(405); return }
        User user = params.long('id') ? User.get(params.long('id')) : new User()
        if (!user) { response.sendError(404); return }
        String username = params.username?.toString()?.trim()
        String password = params.password?.toString()
        if (!username || !(username ==~ /[A-Za-z0-9]+/)) {
            flash.error = 'Username must contain only letters and numbers.'
            redirect(action:'editUser', params:params.long('id') ? [id:params.long('id')] : [:]); return
        }
        if (!user.id && !password) {
            flash.error = 'A password is required for new users.'
            redirect(action:'editUser'); return
        }
        if (User.findByUsername(username)?.id && User.findByUsername(username)?.id != user.id) {
            flash.error = 'That username is already in use.'
            redirect(action:'editUser', params:user.id ? [id:user.id] : [:]); return
        }
        user.username = username
        user.firstName = params.firstName?.toString()?.trim()
        user.lastName = params.lastName?.toString()?.trim()
        user.mail = params.mail?.toString()?.trim() ?: null
        user.enabled = params.enabled == 'on'
        user.accountLocked = params.accountLocked == 'on'
        user.accountExpired = params.accountExpired == 'on'
        user.passwordExpired = params.passwordExpired == 'on'
        user.businessUnit = params.businessUnit ? crew.config.BusinessUnit.valueOf(params.businessUnit.toString()) : null
        user.subsidiary = params.subsidiary ? crew.config.Subsidiary.valueOf(params.subsidiary.toString()) : null
        user.language = params.language ? crew.config.SupportedLanguage.valueOf(params.language.toString()) : null
        User manager = params.long('managerId') ? User.get(params.long('managerId')) : null
        if (manager && (manager.id == user.id || manager.allManagers*.id.contains(user.id))) {
            flash.error = 'Manager assignment would create a cycle.'
            redirect(action:'editUser',params:user.id ? [id:user.id] : [:]); return
        }
        user.manager = manager
        if (password) user.password = springSecurityService.encodePassword(password)
        if (!user.save(flush:true)) {
            flash.error = user.errors.allErrors.collect { it.defaultMessage }.join('; ')
            redirect(action:'editUser',params:user.id ? [id:user.id] : [:]); return
        }
        flash.message = 'User saved.'
        redirect(action:'editUser',id:user.id)
    }

    @Secured(['ROLE_ADMIN'])
    def userRoles() {
        User user = User.get(params.long('id'))
        if (!user) { response.sendError(404); return }
        [user:user, roles:Role.list(sort:'authority',order:'asc'),
         assigned:UserRole.findAllByUser(user)*.role*.id as Set]
    }

    @Secured(['ROLE_ADMIN'])
    @grails.gorm.transactions.Transactional
    def saveUserRoles() {
        if (request.method != 'POST') { response.sendError(405); return }
        User user = User.get(params.long('id'))
        if (!user) { response.sendError(404); return }
        Set<Long> requested = (params.list('roleIds') ?: []).collect { it.toString().toLong() } as Set<Long>
        Set<Long> valid = Role.list()*.id as Set<Long>
        if (!valid.containsAll(requested)) { response.sendError(400); return }
        Set<Long> existing = UserRole.findAllByUser(user)*.role*.id as Set<Long>
        // Do not allow an administrator to remove their own administrator role.
        if (springSecurityService.currentUser?.id == user.id) {
            Role adminRole = Role.findByAuthority('ROLE_ADMIN')
            if (adminRole && existing.contains(adminRole.id) && !requested.contains(adminRole.id)) {
                flash.error = 'You cannot remove your own administrator role.'
                redirect(action:'userRoles',id:user.id); return
            }
        }
        (existing - requested).each { rid -> UserRole.remove(user,Role.get(rid)) }
        (requested - existing).each { rid -> UserRole.create(user,Role.get(rid),true) }
        flash.message = 'User roles updated.'
        redirect(action:'userRoles',id:user.id)
    }

    @Secured(['ROLE_ADMIN', 'ROLE_CREW_ADMIN'])
    def editRole() {
        Role role = params.long('id') ? Role.get(params.long('id')) : null
        if (params.long('id') && !role) { response.sendError(404); return }
        [role:role]
    }

    @Secured(['ROLE_ADMIN', 'ROLE_CREW_ADMIN'])
    @grails.gorm.transactions.Transactional
    def saveRole() {
        if (request.method != 'POST') { response.sendError(405); return }
        Role role = params.long('id') ? Role.get(params.long('id')) : new Role()
        if (!role) { response.sendError(404); return }
        role.authority = params.authority?.toString()?.trim()
        if (!role.save(flush:true)) {
            flash.error = role.errors.allErrors.collect { it.defaultMessage }.join('; ')
            redirect(action:'editRole',params:role.id ? [id:role.id] : [:]); return
        }
        flash.message = 'Role saved.'
        redirect(action:'roles')
    }

}
