create or replace package body syslog_ninja

as

  function construct_syslog_packet (
    message                 varchar2
    , severity              pls_integer
    , facility              pls_integer
    , tag                   varchar2
  )
  return varchar2

  as

    l_ret_var               varchar2(1024);
    l_pri                   pls_integer := (facility*8)+severity;
    l_hostname              varchar2(100) := sys_context('USERENV' , 'SERVER_HOST');

  begin

    dbms_application_info.set_action('construct_syslog_packet');

    l_ret_var := '<' || to_char(pri) || '>' || to_char(sysdate, 'Mon dd hh24:mi:ss') || ' ' || hostname || ' ' || substr(tag, 1, 32) || ': ';
    l_ret_var := l_ret_var || substr(message, 1, 1024 - length(l_ret_var));

    dbms_application_info.set_action(null);

    return l_ret_var;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end construct_syslog_packet;

  function l (
    message                 varchar2
    , severity              pls_integer         default s_warning
    , facility              pls_integer         default f_user_level
    , tag                   varchar2            default t_default
  )
  return number

  as

    l_ret_var               number;

  begin

    dbms_application_info.set_action('l');

    dbms_application_info.set_action(null);

    return l_ret_var;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end l;

begin

  dbms_application_info.set_client_info('syslog_ninja');
  dbms_session.set_identifier('syslog_ninja');

end syslog_ninja;
/
