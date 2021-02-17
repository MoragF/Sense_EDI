;NO2_STATS.PRO

;Written by Richard Pope (University of Leeds), Feb 2021, to process TROPOMI NO2 data.

PRO no2_stats,data_no2,data_err,no2_avg,err_avg,n_samples,no2_tseries

;INPUTS
;data_no2 - selected NO2 data 
;data_err - selected NO2 error 

;OUTPUT
;no2_avg - average NO2 map      
;err_avg - avarage error map
;n_samples - frequency of obs per grid box
;no2_tseries - no2 time series 

;calculate stats
cnt_lon=N_ELEMENTS(data_no2[*,0,0]) & cnt_lat=N_ELEMENTS(data_no2[0,*,0]) & cnt_days=N_ELEMENTS(data_no2[0,0,*])
mdi=-999.99           ;missing data indicator

;now get the satellite spatial average
no2_avg=FLTARR(cnt_lon,cnt_lat)+mdi & err_avg=FLTARR(cnt_lon,cnt_lat)+mdi & n_samples=FLTARR(cnt_lon,cnt_lat)+mdi
FOR i_lon=0,cnt_lon-1 DO BEGIN
    FOR i_lat=0,cnt_lat-1 DO BEGIN
	
	;get tmp vars
	tmp_no2=REFORM(data_no2[i_lon,i_lat,*])
	tmp_err=REFORM(data_err[i_lon,i_lat,*])
	
	;find good data
	good_data=WHERE(tmp_no2 GE 0.0 AND tmp_err GE 0.0,cnt)
	IF (cnt GT 0) THEN BEGIN
	   no2_avg[i_lon,i_lat]=MEAN(tmp_no2[good_data])
	   err_avg[i_lon,i_lat]=MEAN(tmp_err[good_data])
	   n_samples[i_lon,i_lat]=cnt
	ENDIF
    
    ENDFOR    
ENDFOR

;now get domain average time series
n_stats=3 & lag=13         ;two weekly running aveage
no2_tseries=FLTARR(cnt_days,n_stats)+mdi
FOR i_day=0,cnt_days-1 DO BEGIN
    
    ;get tmp data
    IF (i_day LE cnt_days-1-lag) THEN BEGIN 
    
       tmp_no2=REFORM(data_no2[*,*,i_day:i_day+lag])
       tmp_err=REFORM(data_err[*,*,i_day:i_day+lag])       
       
       ;find good data
       good_data=WHERE(tmp_no2 GE 0.0 AND tmp_err GE 0.0,cnt)
       IF (cnt GT 50) THEN BEGIN
     	  tmp_no2=tmp_no2[good_data]
     	  tmp_err=tmp_err[good_data]

     	  ;now get stats
     	  no2_tseries[i_day,0]=MEAN(tmp_no2)*1.0E5
     	  no2_tseries[i_day,1]=MEAN(tmp_no2)*1.0E5-MEAN(tmp_err)*1.0E5
     	  no2_tseries[i_day,2]=MEAN(tmp_no2)*1.0E5+MEAN(tmp_err)*1.0E5
     	  
       ENDIF
	  
    ENDIF
ENDFOR 

END
