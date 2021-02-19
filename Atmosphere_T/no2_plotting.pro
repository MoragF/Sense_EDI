;NO2_PLOTTOING.PRO

;Written by Richard Pope (University of Leeds), Feb 2021, to plot NO2 stats.

;INPUTS
;filename - info of plot to put in filename
;no2_avg - average NO2 map      
;err_avg - avarage error map
;n_samples - frequency of obs per grid box
;no2_tseries - no2 time series 
;lon_centre - lons for plotting
;lat_centre - lats for plotting
;lon1 - lon boundary west co-ordinate
;lon2 - lon boundary east co-ordinate
;lat1 - lat boudnary south co-ordinate 
;lat2 - lat boundary north co-cordinate
;col_range - data range to scale colour bar

PRO no2_plotting,filename,no2_avg,err_avg,n_samples,no2_tseries,lon_centre,lat_centre,lon1,lon2,lat1,lat2,col_range,start_date 

;initialise variables
lag=13
n_days=N_ELEMENTS(no2_tseries[*,0])

;plot maps
SET_PLOT,'ps'
Device,file='NO2_'+filename+'_maps.ps',/color,/helvetica,bits=24,font_size=10 ;,/landscape

plot_map_code_no2,no2_avg,'Trop Col NO!D2!N (10!U-5!N moles/m!U2!N)',col_range,1E5,[0.05,0.2,0.95,0.95],[0.05,0.05,0.95,0.10],lon_centre,lat_centre,[lat1,lon1,lat2,lon2] 
plot_map_code_no2,err_avg,'Trop Col NO!D2!N Error (10!U-5!N moles/m!U2!N)',col_range,1E5,[0.05,0.2,0.95,0.95],[0.05,0.05,0.95,0.10],lon_centre,lat_centre,[lat1,lon1,lat2,lon2] 
plot_map_code_no2,n_samples,'Sample Size',[0,MAX(n_samples)],1E0,[0.05,0.2,0.95,0.95],[0.05,0.05,0.95,0.10],lon_centre,lat_centre,[lat1,lon1,lat2,lon2] 

Device, /close_file
SET_PLOT,'X'

;now plot time series
SET_PLOT,'ps'
Device,file='NO2_'+filename+'_timeseries.ps',/color,/helvetica,bits=24,font_size=10 ;,/landscape

range=[0,10]
PLOT,INTARR(10),INTARR(10),/NODATA,xstyle=1,ystyle=1,xrange=[0,n_days-lag],yrange=[0,MAX(no2_tseries)], $
position=[0.1,0.1,0.95,0.95],xthick=2,ythick=2,charthick=2,xtitle='Number of days since '+start_date,ytitle='TCNO!D2!N (10!U-5!N moles/m!U2!N)'

LOADCT,4
TEK_COLOR

; Make a vector of 16 points, A[i] = 2pi/16:  
A = FINDGEN(17) * (!PI*2/16.)  
USERSYM, COS(A), SIN(A), /FILL  

;find good data
time=FINDGEN(n_days)
good_data=WHERE(no2_tseries[*,0] GE 0.0,cnt)
IF (cnt GT 0) THEN BEGIN
   OPLOT,time[good_data],no2_tseries[good_data,0],psym=8,color=2,symsize=0.5  
   OPLOT,time[good_data],no2_tseries[good_data,1],psym=3,color=4,symsize=0.5   
   OPLOT,time[good_data],no2_tseries[good_data,2],psym=3,color=4,symsize=0.5   

   FOR i=0,n_days-2-lag DO BEGIN
       IF (no2_tseries[i,0] GE 0.0 AND no2_tseries[i+1,0] GE 0.0) THEN OPLOT,[time[i],time[i+1]],[no2_tseries[i,0],no2_tseries[i+1,0]],thick=2,linestyle=0,color=2
       IF (no2_tseries[i,1] GE 0.0 AND no2_tseries[i+1,1] GE 0.0) THEN OPLOT,[time[i],time[i+1]],[no2_tseries[i,1],no2_tseries[i+1,1]],thick=2,linestyle=2,color=4
       IF (no2_tseries[i,2] GE 0.0 AND no2_tseries[i+1,2] GE 0.0) THEN OPLOT,[time[i],time[i+1]],[no2_tseries[i,2],no2_tseries[i+1,2]],thick=2,linestyle=2,color=4
   ENDFOR
ENDIF

Device, /close_file
SET_PLOT,'X'

;convert to pdfs
SPAWN,"ps2pdf -dPDFSETTINGS=/prepress -dEPSCrop "+"NO2_"+filename+"_maps.ps"
SPAWN,"ps2pdf -dPDFSETTINGS=/prepress -dEPSCrop "+"NO2_"+filename+"_timeseries.ps"
SPAWN,"rm -fr NO2_"+filename+"_maps.ps"
SPAWN,"rm -fr NO2_"+filename+"q.ps"


END

