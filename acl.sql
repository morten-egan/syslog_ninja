begin
   dbms_network_acl_admin.create_acl (
    acl          => 'syslog_ninja.xml',
    description  => 'permissions for syslog_ninja',
    principal    => 'SYSLOG_NINJA',
    is_grant     => true,
    privilege    => 'connect');
   commit;
end;
/

begin
   dbms_network_acl_admin.add_privilege (
    acl          => 'syslog_ninja.xml',
    principal    => 'SYSLOG_NINJA',
    is_grant     => true,
    privilege    => 'resolve',
    position     => null);
   commit;
end;
/

begin
   dbms_network_acl_admin.assign_acl (
    acl          => 'syslog_ninja.xml',
    host         => '127.0.0.1');
   commit;
end;
/
