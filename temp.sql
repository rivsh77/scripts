select sess.machine
       , sess.status
       , sess.terminal
       , gg.username
       , sess.osuser
       , gg.sql_id
       , gg.tablespace
       , gg.segtype
       , sess.sid
       , pr.spid
       , trunc (gg.blocks*32/1024/1024, 2) TEMP_Gb
       , gg.blocks
       , sess.client_info
       , 'kill -9 '||pr.spid kill_process
       , sum (trunc (gg.blocks*32/1024/1024, 2)) over (partition by gg.tablespace) TEMP_Gb_used_by_TS
       , (select sum (decode (t.maxbytes, 0, t.bytes, t.maxbytes))/1024/1024/1024
          from dba_temp_files t
          where 1 = 1
          and t.tablespace_name = gg.tablespace
         ) max_TS_total_size_Gb
from V$TEMPSEG_USAGE gg,
     v$session sess,
     v$process pr
where 1 = 1
and gg.session_addr = sess.saddr
and sess.paddr = pr.addr
order by gg.blocks desc;
