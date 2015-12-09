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

    l_ret_var := '<' || to_char(l_pri) || '>' || to_char(sysdate, 'Mon dd hh24:mi:ss') || ' ' || l_hostname || ' ' || substr(tag, 1, 32) || ': ';
    l_ret_var := l_ret_var || substr(message, 1, 1024 - length(l_ret_var));

    dbms_application_info.set_action(null);

    return l_ret_var;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end construct_syslog_packet;

  function lf (
    message                 varchar2
    , severity              pls_integer         default s_warning
    , facility              pls_integer         default f_user_level
    , tag                   varchar2            default t_default
  )
  return number

  as

    l_ret_var               number := 0;
    l_packet                varchar2(1024) := construct_syslog_packet(message, facility, severity, tag);
    l_conn                  utl_tcp.connection;
    l_conn_ret              pls_integer;

  begin

    dbms_application_info.set_action('lf');

    l_conn := utl_tcp.open_connection(
      remote_host         =>      d_syslog_host
      , remote_port       =>      d_syslog_port
      , charset           =>      'US7ASCII'
    );

    l_conn_ret := utl_tcp.write_line(l_conn, l_packet);

    utl_tcp.close_connection(l_conn);

    dbms_application_info.set_action(null);

    return l_ret_var;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end lf;

  procedure lp (
    message                 varchar2
    , severity              pls_integer         default s_warning
    , facility              pls_integer         default f_user_level
    , tag                   varchar2            default t_default
  )

  as

    f_ret                   number;

  begin

    dbms_application_info.set_action('lf');

    f_ret := lf(message, severity, facility, tag);

    dbms_application_info.set_action(null);

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end lp;

begin

  dbms_application_info.set_client_info('syslog_ninja');
  dbms_session.set_identifier('syslog_ninja');

end syslog_ninja;
/
