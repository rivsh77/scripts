declare
rwcnt$i integer := 100000;
begin
while rwcnt$i=100000
loop
update MA_NAPA_DPI_STAT
set LIBER_VISITS_CNT_MNTH = 0
   ,LIBER_VISITS_SHARE_MNTH =0
   ,LIBER_VISITS_CNT_WORKD_MNTH = 0
   ,LIBER_VISITS_SHARE_WORKD_MNTH = 0
,LIBER_VISITS_CNT_WKND_MNTH = 0
,LIBER_VISITS_SHARE_WKND_MNTH = 0
,LIBER_VISITS_DAYS_MNTH = 0
,LIBER_VISITS_DAYS_WORKD_MNTH = 0
,LIBER_VISITS_DAYS_WKND_MNTH = 0
,MAX_LIBER_VISITS_DAY_CNT = 0

where LIBER_VISITS_CNT_MNTH (поле, по которому есть индекс) is null and rownum <= 100000;
rwcnt$i := sql%rowcount;
commit;
end loop;
commit;
end;
