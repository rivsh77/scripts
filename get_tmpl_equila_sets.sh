#!/bin/bash
. $HOME/.bashrc
cd /usr/sbin/
name=cmdm
pawd=$(/usr/sbin/opr -r DWH $name)

#export ORACLE_HOME=/opt/oracle/product/11.2.0_ee
source /etc/profile.d/ora_env.sh
#sd=$(sqlplus -s "$name/$pawd" <<END > /tmp/get_tmpl_eql_new.csv
#set pagesize 0 feedback off verify off heading off echo off;
#select distinct templ as name from tmpl_equila_blck_from_csv;
#exit;
#END
#)
file_in='/tmp/get_tmpl_eql.csv'
file_out='/tmp/get_tmpl_eql_sets.json'

export IFS=";"
rm /tmp/eql_block_sets.csv
touch /tmp/eql_block_sets.csv

cat $file_in |  while read datedif name_tlp; do url_sets_eql="https://info.ertelecom.ru/templates/${name_tlp//'"'/}/default/blocks.sets.json"; echo $url_sets_eql ;
curl  -XGET $url_sets_eql --compressed > $file_out;
python -c "execfile('/usr/local/scripts/channel_scripts/template/cm_get_tpl_eql/pars_tmpl_eql.py');parse_json_blcks_sets('$name_tlp','/tmp/get_tmpl_eql_sets.json', '/tmp/eql_block_sets.csv')" ; done

echo "Script ends at" `date +%d.%m.%Y%t%H:%M:%S`
