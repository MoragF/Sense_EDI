PRO model_string_list,year_val,n_day_val,leap_year,date_array

;This program generates a string list a files in the model run for 1 year

;INPUT
;year_val - string element of year e.g. 2006
;n_day_val - number of days in the year ... will depend on leap year etc
;leap_year - sting logical TRUE/FALSE

;OUTPUT
;date_array - string list of days YYYYMMDD in the time period of interest

;as model may be missing some days of data, code generates a list of dates to compare with days of model data (one AQUM file a day as it is sampled at 1300 LT).
years=year_val                     
n_tperiod_days=n_day_val
date_array=STRARR(n_tperiod_days)
date_array(0:n_tperiod_days-1)=years[0]                                                 ;set up string with the year in
month_arr=['01','02','03','04','05','06','07','08','09','10','11','12']         ;set up months and days in the period we are looking at
IF (leap_year EQ 'TRUE') THEN n_month_days=[31,29,31,30,31,30,31,31,30,31,30,31]
IF (leap_year EQ 'FALSE') THEN n_month_days=[31,28,31,30,31,30,31,31,30,31,30,31]
day_arr=['01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
cnt=0
;loop over the number of months being looked at
FOR i_months=0,N_ELEMENTS(n_month_days)-1 DO BEGIN
    months=STRARR(n_month_days[i_months])                ;initialise months for the number of days in it
    months=months+month_arr[i_months]                    ;now add the month number e.g. March =03 to the string which is month days long    
    date_array[cnt:cnt+n_month_days[i_months]-1]=date_array[cnt:cnt+n_month_days[i_months]-1]+months+day_arr[0:n_month_days[i_months]-1]       ;now merge year, months, days
    cnt=cnt+n_month_days[i_months]                                    ;cnt so the code knows which month it is on
ENDFOR

END
