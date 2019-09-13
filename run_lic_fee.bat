cd /d C:\Users\shanshurova.mv\Desktop\
fab -f fab_tst_003.py exp_from_city:date_from='01.09.2019',date_to='01.10.2019' > C:\Users\shanshurova.mv\Desktop\lic_fee.log
fab -f fab_tst_003.py imp_to_sa  >> C:\Users\shanshurova.mv\Desktop\lic_fee.log
fab -f fab_tst_003.py del_tmp_files_city  >> C:\Users\shanshurova.mv\Desktop\lic_fee.log
