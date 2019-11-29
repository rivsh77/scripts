from fabric.api import *
from fabric.context_managers import hide, show
from fabric.operations import local, abort, put, sudo
import array
import string
import re
import os
import fabric

env.roledefs = {  
        'billing': [
                'sh@blecom.ru'                 
                 ],
       
        'sa': ['shanshurova_mv@sa.ertelecom.ru'
                ]
}

env.abort_on_prompts = True
env.key_filename = 'k.ppk'
#env.warn_only = True  #exp_from_city:date_from='01.01.2016',date_to='01.02.2016'  fab -f fab_tst_003.py exp_from_city:date_from='01.01.2016',date_to='01.02.2016'

@roles('billing')
def exp_from_city(date_from,date_to):
  print(run('hostname -f'))
  current_host = run('hostname -f')
  print(run('date'))
  inp=open("hosts_list.txt") 
  hosts_list_file = inp.readlines()
  global host_list
  host_list=[]
  for txt in hosts_list_file:
      temp={}
      if txt.split('.')[1] == current_host.split('.')[1]:
          temp['id_billing']=txt.split(':')[1]
          temp['schema_num']=txt.split(':')[2]
          temp['sa_dir']=txt.split(':')[3].replace("\n","").replace("\r","")
          print temp
          sudo('echo query=excellent' + temp['schema_num'] + '.LICENSE_FEE:' + '"' + '*WHERE TIME_STAMP >= TO_DATE(' + '%s'%date_from  +", " + "\'" + "DD.MM.YYYY" + "\'" + ') AND TIME_STAMP < TO_DATE(' +'%s'%date_to +", " + "\'" + "DD.MM.YYYY" + "\'" + ')*' + '"' + ' > /mnt/sa/query_for_license_fee2.par', user = 'gg-user')
          sudo('cat /mnt/sa/query_for_license_fee2.par | sed '+"\'s/*/\"/g\'" + '> /mnt/sa/query_for_license_fee3.par ', user = 'gg-user')
          sudo('$ORACLE_HOME/bin/expdp ggs_owner/`/usr/sbin/opr -r local ggs_owner`  tables=excellent' + temp['schema_num'] + '.LICENSE_FEE DIRECTORY=DMP_DIR DUMPFILE=TST_ALL_LICENSE_FEE_EXP_' + temp['id_billing'] + '.dmp  parfile=/mnt/sa/query_for_license_fee3.par', user = 'gg-user')
          host_list.append(temp)
  
@roles('sa')
def imp_to_sa():
  print(run('hostname -f'))
  current_host = run('hostname -f')
  print(run('date'))
  sudo('echo \" declare \n high_v varchar2(4000) := null; \n begin \n high_v := get_partition_by_highvalue(\'LICENSE_FEE_ALL\', trunc (current_date, \'mm\')); \n if ( high_v is not null ) \n then \n execute immediate \'ALTER TABLE LICENSE_FEE_ALL TRUNCATE PARTITION \'||high_v ||\' update global indexes\';\nend if;\nend;\n/\nexit \" > /tmp/trunc_LICENSE_FEE_ALL.sql ', user = 'oracle')
  sudo('$ORACLE_HOME/bin/sqlplus -s excellent/`opr -r local excellent` @/tmp/trunc_LICENSE_FEE_ALL.sql; ',  user = 'oracle')
  inp=open("hosts_list.txt")
  hosts_list_file = inp.readlines()
  global host_list
  host_list=[]
  for txt in hosts_list_file:
      temp={}
      if txt[0]!='#':
          temp['id_billing']=txt.split(':')[1]
          temp['schema_num']=txt.split(':')[2]
          temp['sa_dir']=txt.split(':')[3].replace("\n","").replace("\r","")
          print temp
          sudo('echo \'ALTER TABLE LICENSE_FEE_ALL MODIFY BILLING_ID DEFAULT ' + temp['id_billing'] + ' ; \r\n exit \' > /tmp/LICENSE_FEE_ALL.sql ', user = 'oracle')
          sudo('$ORACLE_HOME/bin/sqlplus -s excellent/`opr -r local excellent` @/tmp/LICENSE_FEE_ALL.sql; ',  user = 'oracle')
          sudo('$ORACLE_HOME/bin/impdp userid=' + "\\'/ as sysdba\\' " + ' tables=excellent' + temp['schema_num'] + '.LICENSE_FEE REMAP_TABLE=excellent' + temp['schema_num'] + '.LICENSE_FEE:LICENSE_FEE_ALL remap_tablespace=EXCELLENT' + temp['schema_num'] + ':DATA_SLOW remap_schema=EXCELLENT' + temp['schema_num'] + ':EXCELLENT DIRECTORY=' + temp['sa_dir'] + ' DUMPFILE=TST_ALL_LICENSE_FEE_EXP_' + temp['id_billing'] + '.dmp CONTENT=DATA_ONLY TABLE_EXISTS_ACTION=APPEND ', user = 'oracle')
          host_list.append(temp)
          
  print(run('date'))
  sudo('rm /tmp/LICENSE_FEE_ALL.sql ', user = 'oracle')
  sudo('rm /tmp/trunc_LICENSE_FEE_ALL.sql', user = 'oracle')
  
  
@roles('billing')
def del_tmp_files_city():
  print(run('hostname -f'))
  current_host = run('hostname -f')
  print(run('date'))
  sudo('cd /mnt/sa/ ; find -name "TST_ALL_LICENSE_FEE_EXP_*" -delete ', user = 'gg-user') 
  sudo('cd /mnt/sa/ ; find -name "TMP_TABLE_CLIENT_SEGMENT*" -delete ', user = 'gg-user') 
  sudo('rm /mnt/sa/query_for_license_fee2.par', user = 'gg-user')
  sudo('rm /mnt/sa/query_for_license_fee3.par', user = 'gg-user')
 
