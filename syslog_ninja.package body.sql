create or replace package body syslog_ninja

as

begin

  dbms_application_info.set_client_info('syslog_ninja');
  dbms_session.set_identifier('syslog_ninja');

end syslog_ninja;
/
