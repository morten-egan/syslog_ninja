create or replace package syslog_ninja

as

  /** This package implements a syslog client in plsql
  * @author Morten Egan
  * @version 0.0.1
  * @project SYSLOG_NINJA
  */
  npg_version       varchar2(250) := '0.0.1';

  -- deamon settings
	d_syslog_host                      varchar2(250) := '127.0.0.1';
	d_syslog_port                      pls_integer := 601;
	d_syslog_secure                    number := 0;
	d_secure_wallet_path               varchar2(1024) := null;
	d_secure_wallet_passwd             varchar2(1024) := null;

  -- Facility codes
	f_kernel                           constant		pls_integer := 0;
	f_user_level                       constant		pls_integer := 1;
	f_mail_system                      constant		pls_integer := 2;
	f_system_deamon                    constant		pls_integer := 3;
	f_security_authorization           constant		pls_integer := 4;
	f_line_printer                     constant		pls_integer := 6;
	f_network_subsystem                constant		pls_integer := 7;
	f_uucp_subsystem                   constant		pls_integer := 8;
	f_clock_deamon                     constant		pls_integer := 9;
	f_ftp_deamon                       constant		pls_integer := 11;
	f_ntp_subsystem                    constant		pls_integer := 12;
	f_log_audit                        constant		pls_integer := 13;
	f_log_alert                        constant		pls_integer := 14;
	f_local_use_0                      constant		pls_integer := 16;
	f_local_use_1                      constant		pls_integer := 17;
	f_local_use_2                      constant		pls_integer := 18;
	f_local_use_3                      constant		pls_integer := 19;
	f_local_use_4                      constant		pls_integer := 20;
	f_local_use_5                      constant		pls_integer := 21;
	f_local_use_6                      constant		pls_integer := 22;
	f_local_use_7                      constant		pls_integer := 23;

  -- Severity codes
	s_emergency                        constant		pls_integer := 0;
	s_alert                            constant		pls_integer := 1;
	s_critical                         constant		pls_integer := 2;
	s_error                            constant		pls_integer := 3;
	s_warning                          constant		pls_integer := 4;
	s_notice                           constant		pls_integer := 5;
	s_informational                    constant		pls_integer := 6;
	s_debug                            constant		pls_integer := 7;

  -- Tag values
	t_client_identifier                varchar2(32) := substr(sys_context('USERENV', 'CLIENT_IDENTIFIER'), 1, 32);
  t_client_info                      varchar2(32) := substr(sys_context('USERENV', 'CLIENT_INFO'), 1, 32);
  t_current_schema			             varchar2(32) := substr(sys_context('USERENV', 'CURRENT_SCHEMA'), 1, 32);
  t_db_name					                 varchar2(32) := substr(sys_context('USERENV', 'DB_NAME'), 1, 32);
  t_default					                 varchar2(32) := t_db_name;

  /** Send a message to the syslog
  * @author Morten Egan
  * @return number 0 if success, -1 if fail
  */
  function l (
    message                 varchar2
    , severity              pls_integer         default s_warning
    , facility              pls_integer         default f_user_level
    , tag                   varchar2            default t_default
  )
  return number;

end syslog_ninja;
/
