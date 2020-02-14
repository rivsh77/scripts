cd /d C:\Specsoft\l_f\

set mm1_c=%mm%
set /A mm1=1%mm% - 100
set /A mm1=%mm% - 1

if %mm1%==1 set mm1=01
if %mm1%==2 set mm1=02
if %mm1%==3 set mm1=03
if %mm1%==4 set mm1=04
if %mm1%==5 set mm1=05
if %mm1%==6 set mm1=06
if %mm1%==7 set mm1=07
if %mm1%==8 set mm1=08
if %mm1%==9 set mm1=09
if %mm1%==0 set mm1=12
echo %mm1%
echo %mm1_c%
fab -f fab_tst_003.py exp_from_city:date_from='01.%mm1%.2020',date_to='01.%mm1_c%.2020' > C:\Specsoft\l_f\lic_fee.log
fab -f fab_tst_003.py imp_to_sa  >> C:\Specsoft\l_f\lic_fee.log
fab -f fab_tst_003.py del_tmp_files_city  >> C:\Specsoft\l_f\lic_fee.log
