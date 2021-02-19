;PLOT_MAP_CODE_NO2.PRO

;Written by Richard Pope (University of Leeds), Feb 2021, to plot NO2 data onto a map.

PRO plot_map_code_no2,data_matrix,cbartitle,range,power,map_pos,cbar_pos,lon_centre,lat_centre,limits

;initialise variabbles
mdi=-999.99   
min_v=range[0]
max_v=range[1]

;scale data by power variable
good_data=WHERE(data_matrix NE mdi,cnt)
IF (cnt GT 0) THEN data_matrix[good_data]=data_matrix[good_data]*power

;set lon lat grid
n_lons=N_ELEMENTS(lon_centre)
n_lats=N_ELEMENTS(lat_centre)
lon_edge=[lon_centre[0]-0.125,(lon_centre[0:n_lons-2]+lon_centre[1:n_lons-1])/2.0,lon_centre[n_lons-1]+0.125]
lat_edge=[lat_centre[0]-0.125,(lat_centre[0:n_lats-2]+lat_centre[1:n_lats-1])/2.0,lat_centre[n_lats-1]+0.125]

;plot data
loadct,33                                        ;load the colour table
!p.color=0
!p.background=255
tek_color

map_set,/continents,/grid,limit=limits,/noborder,xmargin=3,ymargin=3,position=map_pos         ;set the map outline first
map_continents,/countries,/oceans
map_grid,/box_axes  

colour_matrix=bytscl(data_matrix,/nan,top=254-32,min=min_v,max=max_v)+32                       ;colour scale the data with values from the col table
bad_data=WHERE(data_matrix EQ mdi,cnt)
IF (cnt GT 0) THEN data_matrix[bad_data]=1

for i=0,n_elements(lon_centre)-1 do for j=0,n_elements(lat_centre)-1 do $                                                ;polyfill the matrix with the lon,lat boundaries set
polyfill,[lon_edge(i+1),lon_edge(i+1),lon_edge(i),lon_edge(i)],[lat_edge(j+1),lat_edge(j),lat_edge(j),lat_edge(j+1)],color=colour_matrix(i,j)

map_set,/continents,/grid,/noborder,xmargin=3,ymargin=3,limit=limits,/noerase,position=map_pos
map_continents,/countries,/oceans                                                                        ;replot the maps
map_grid,/box_axes  

colorbar,bottom=32,ncolors=254-32,range=[min_v,max_v],position=cbar_pos,format='(f5.1)',title=cbartitle,charsize=0.85                     ;plot the colour bar with range and 
                                                                                                                                            ;title of the colour bar
END
