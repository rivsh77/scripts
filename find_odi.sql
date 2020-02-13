SELECT sf.path,
         st.trt_name,
         st.last_date,
         st.last_user
    FROM snp_trt st,
         (    SELECT SYS_CONNECT_BY_PATH (folder_name, '|') AS path, i_folder
                FROM snp_folder
          START WITH par_i_folder IS NULL
          CONNECT BY PRIOR i_folder = par_i_folder) sf
   WHERE     i_trt IN (SELECT i_trt
                         FROM snp_line_trt
                        WHERE def_i_txt IN (SELECT i_txt
                                              FROM snp_txt_header
                                             WHERE UPPER (full_text) LIKE
                                                      '%D_MANAGERS_TAB%'))
         AND sf.i_folder = st.i_folder
ORDER BY 1;

-- Поиск по интерфейсам для сопоставленных столбцов в приемнике
select sf.path,       i.pop_name,
       c.col_name,
       full_text,
       i.last_date,
       i.last_user
  from snp_txt_header t,
       snp_pop_mapping m,
       snp_pop_col c,
       snp_pop i,
       (    select sys_connect_by_path (folder_name, '|') as path, i_folder
              from snp_folder
        start with par_i_folder is null
        connect by prior i_folder = par_i_folder) sf
 where     t.i_txt = m.i_txt_map
       and m.i_pop_col = c.i_pop_col
       and c.i_pop = i.i_pop
       and upper (t.full_text) like '%1.18%'
       and sf.i_folder = i.i_folder ;
       
 -- Поиск по интерфейсам в связах и фильтрах
 
 select sf.path,
       i.pop_name,
       t.full_text,
       i.last_date,
       i.last_user
  from snp_txt_header t,
       snp_pop_clause cl,
       snp_data_set ds,
       snp_pop i,
       (    select sys_connect_by_path (folder_name, '|') as path, i_folder
              from snp_folder
        start with par_i_folder is null
        connect by prior i_folder = par_i_folder) sf
 where     t.i_txt = cl.i_txt_sql
       and cl.i_data_set = ds.i_data_set
       and ds.i_pop = i.i_pop
       and upper (t.full_text) like '%CITY_SERVERS%'
       and sf.i_folder = i.i_folder ;
       
 -- Если требуется определить перечень колонок в результирующей таблице интерфейса:
  select *
    from snp_col
   where     1 = 1
         and i_table in (select i_table
                           from SNP_TABLE
                          where 1 = 1 and TAble_name = 'F_RESPONSES_SERV')
order by i_table desc
