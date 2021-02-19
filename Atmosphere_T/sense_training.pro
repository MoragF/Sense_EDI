;SENSE_TRAINING.PRO
;Written by Richard Pope (University of Leeds), Feb 2020, to plot tropomi gridded data for SENSE training programme.

;subprograms
@/nfs/a320/pr17kw/pr17kw/colorbar.pro
@/nfs/a320/pr17kw/pr17kw/tropomi_no2/col_tab_bwr.pro
@/nfs/a320/pr17kw/pr17kw/tropomi_no2/model_string_list.pro
;@/nfs/a320/pr17kw/pr17kw/tropomi_no2/plot_map_colour_bar.pro
@/nfs/a320/pr17kw/pr17kw/tropomi_no2/plot_map_colour_bar_cities.pro

;initialise variables
mdi=-999.99           ;missing data indicator
logical_data='TRUE'          ;logical to read in data

;set lons and lat domain to select data for -- lon1 = west, lon2 = east, lat1 = south, lat2 = north co-ordinates 
;lons = -180 to 180 and lats = -90 to 90
lon1=-180.0 & lon2=180.0 & lat1=-90.0 & lat2=90.0 
lon_lab1=STRCOMPRESS(STRING(lon1,format='(f6.1)'),/remove_all)
lon_lab2=STRCOMPRESS(STRING(lon2,format='(f6.1)'),/remove_all)
lat_lab1=STRCOMPRESS(STRING(lat1,format='(f6.1)'),/remove_all)
lat_lab2=STRCOMPRESS(STRING(lat2,format='(f6.1)'),/remove_all)

;set dates for data  --- data ranges between 01/02/2018 and 31/05/2020.
start_date='20181201' & end_date='20190228'      ;!!!!!! Needs to be a month long time period at least

;set QA flags ------- 4 options 1) CF=0.5 QA=50, 2) CF=0.5 QA=75, 3) CF=0.2 QA=50 and 4) CF=0.2, QA=75.
cloud_frac='0.2'
qa_flag='75'

;read in selected data
IF (logical_data EQ 'TRUE') THEN BEGIN
   
   ;get data
   data_selector,cloud_frac,qa_flag,lon1,lon2,lat1,lat2,start_date,end_date,data_no2,data_err,lon_centre,lat_centre
   
   ;save data  
   filename='tropomi_no2_data_'+start_date+'_'+end_date+'_'+cloud_frac+'_'+qa_flag+'_'+lon_lab1+'_'+lon_lab2+'_'+lat_lab1+'_'+lat_lab2+'.save'
   SAVE,data_no2,data_err,lon_centre,lat_centre,FILENAME=filename

ENDIF ELSE BEGIN
           filename='tropomi_no2_data_'+start_date+'_'+end_date+'_'+cloud_frac+'_'+qa_flag+'_'+lon_lab1+'_'+lon_lab2+'_'+lat_lab1+'_'+lat_lab2+'.save'	   
	   RESTORE,filename
      ENDELSE

;set logical to process data to calculate stats
logical_stats='TRUE'
IF (logical_stats EQ 'TRUE') THEN BEGIN

   ;now get the satellite stats
   no2_stats,data_no2,data_err,no2_avg,err_avg,n_samples,no2_tseries
   
   ;save data  
   filename='tropomi_no2_stats_'+start_date+'_'+end_date+'_'+cloud_frac+'_'+qa_flag+'_'+lon_lab1+'_'+lon_lab2+'_'+lat_lab1+'_'+lat_lab2+'.save'
   SAVE,no2_avg,err_avg,n_samples,no2_tseries,FILENAME=filename

ENDIF ELSE BEGIN
           filename='tropomi_no2_stats_'+start_date+'_'+end_date+'_'+cloud_frac+'_'+qa_flag+'_'+lon_lab1+'_'+lon_lab2+'_'+lat_lab1+'_'+lat_lab2+'.save'	   
	   RESTORE,filename
      ENDELSE
            
;now plot the data
filename=start_date+'_'+end_date+'_'+cloud_frac+'_'+qa_flag+'_'+lon_lab1+'_'+lon_lab2+'_'+lat_lab1+'_'+lat_lab2   
col_range=[0,10]
no2_plotting,filename,no2_avg,err_avg,n_samples,no2_tseries,lon_centre,lat_centre,lon1,lon2,lat1,lat2,col_range,start_date

STOP

END 


