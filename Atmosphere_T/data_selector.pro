;DATA_SELECTOR.PRO

;subprograms
@/nfs/a320/pr17kw/pr17kw/tropomi_no2/model_string_list.pro

PRO data_selector,cf,qa,lon1,lon2,lat1,lat2,date1,date2,data_no2,data_err,lon_centre,lat_centre

;Written by Richard Pope (University of Leeds), Feb 2021, to in TROPOMI data.

;INPUTS
;cf - cloud fraction
;qa - quality flag
;lon1 - lon boundary west co-ordinate
;lon2 - lon boundary east co-ordinate
;lat1 - lat boudnary south co-ordinate 
;lat2 - lat boundary north co-cordinate

;OUTPUT
;data_no2 - selected NO2 data based on criteria above
;data_err - selected NO2 error data based on criteria above
;lon_centre - lons for plotting
;lat_centre - lats for plotting

;define grid
mdi=-999.99           ;missing data indicator
n_lons=1440
n_lats=720
lon_centre=FINDGEN(n_lons)*0.25-180.0+0.125
lat_centre=FINDGEN(n_lats)*0.25-90.0+0.125

;get list of dates
model_string_list,'2018',365,'FALSE',date_array_2018
model_string_list,'2019',365,'FALSE',date_array_2019
model_string_list,'2020',366,'TRUE',date_array_2020
date_array=[date_array_2018[31:*],date_array_2019,date_array_2020[0:151]]

;select the time period to analyse ---- data between 01.02.2018 and 31.05.2020
start_loc=WHERE(date_array EQ date1)     
end_loc=WHERE(date_array EQ date2)       
date_array=date_array[start_loc:end_loc] & n_days=N_ELEMENTS(date_array)

;now find region to investigate
lon_loc=WHERE(lon_centre GE lon1 AND lon_centre LE lon2,cnt_lon)
lat_loc=WHERE(lat_centre GE lat1 AND lat_centre LE lat2,cnt_lat)
lon_centre=lon_centre[lon_loc] & lat_centre=lat_centre[lat_loc]
IF (cnt_lon EQ 0 OR cnt_lat EQ 0) THEN BEGIN & PRINT,'Lon or Lat options are incorrect' & STOP & ENDIF

;now read in data
SPAWN,"ls /nfs/a216/earrjpo/S5P/temis/code/sense_practical/data/s5p_temis_no2_grid*_"+cf+"_"+qa+".save",files
;stop
files=files[start_loc:end_loc]
data_no2=FLTARR(cnt_lon,cnt_lat,n_days)+mdi & data_err=FLTARR(cnt_lon,cnt_lat,n_days)+mdi
FOR i_day=0,n_days-1 DO BEGIN
    ;PRINT,date_array[i_day]
    
    ;restore file 
    RESTORE,files[i_day]
    
    ;extract lons and lats
    no2_grid_daily=REFORM(no2_grid_daily[lon_loc,*]) & no2_grid_daily=REFORM(no2_grid_daily[*,lat_loc])
    err_grid_daily=REFORM(err_grid_daily[lon_loc,*]) & err_grid_daily=REFORM(err_grid_daily[*,lat_loc])   
    
    ;store data in array
    data_no2[*,*,i_day]=no2_grid_daily
    data_err[*,*,i_day]=err_grid_daily
   
ENDFOR

END



