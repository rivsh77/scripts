#!/bin/sh
PATH="$ORACLE_HOME/bin:$PATH"
export TNS_ADMIN="/etc/oracle"

export ORACLE_HOME="/opt/oracle/product/11.2.0_ee"
[ -x '/usr/sbin/opr' ] || `echo 'AAAAchtung!!!' && exit`
passwd=`/usr/sbin/opr -r LOCAL excellent`

rm /db/u13/export/hq/eql_xml/vk_groups.log

rm /db/u13/export/hq/eql_xml/vk_groups.bad

/opt/oracle/product/11.2.0_ee/bin/sqlldr userid="excellent/\"${passwd}\"@LOCAL" control=/db/u13/export/hq/eql_xml/vk_groups.ctl rows=10000000 direct=true


LOAD DATA
CHARACTERSET CL8MSWIN1251
INFILE '/db/u13/export/hq/eql_xml/vk_groups.csv'
APPEND
INTO TABLE EXCELLENT.SA_EQL_VK_GROUP_FROM_TSV
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
FOR_MONTH date "dd.mm.yyyy",
CITY,
LOGIN,
GROUPS_ID
)
