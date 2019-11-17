select to_date('01.02.2012', 'dd.mm.yyyy') date_from ,
to_date('07.02.2012', 'dd.mm.yyyy') date_to ,
user_name,
abs(minutes),
  case when 
    minutes < 0 then 'недоработал'
    else 'переработал'
  end
  from (
select 
  --max(trunc(event_date) ) date_to ,
  u.user_name ,
--  trunc(st.LOGON_DATE) event_date,
  sum(540 - 24 * 60 * (st.logoff_date - st.logon_date)) minutes
from tmp_stat st, tmp_users u, tmp_schedule sch
where 1=1
and trunc(logon_date) >= to_date('01.02.2012', 'dd.mm.yyyy')
and trunc(logon_date) <= to_date('07.02.2012', 'dd.mm.yyyy')
and u.user_id = st.user_id
and u.schedule_id = sch.schedule_id
and (sch.schedule_start <> to_char(st.logon_date, 'hh24:mi')
 or sch.schedule_end <> to_char(st.logoff_date, 'hh24:mi'))
 group by  u.user_name )
