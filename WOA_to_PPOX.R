WOA_to_PPOX <- function ( LATITUDE, LONGITUDE ){

# This routine is dedicated to estimate PPOX at surface from the World Ocean Atlas Database
#
# Based on Henry Bittig work 
# prendre l’équation pour le water vapour pressure pH2O=f(TEMP_WOA,PSAL_WOA) 
# et 
# après PPOX_WOA = 0.20946 * (1013.25 hPa - pH2O) * O2sat_WOA

require(fields) # to calculate rdist  

#######################################################
# Read WOA file  
#######################################################

# WOA 2013 file 
#file_in_WOA="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/CLIMATOLOGY/WOA_all_data.nc"
file_in_WOA_satO2="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/CLIMATOLOGY/woa13_all_O00_01.nc"
file_in_WOA_temp="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/CLIMATOLOGY/woa13_decav_t00_01v2.nc"
file_in_WOA_psal="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/CLIMATOLOGY/woa13_decav_s00_01v2.nc"

# Open the WOA file 
filenc_WOA_satO2=nc_open(file_in_WOA_satO2,readunlim=FALSE,write=FALSE)

# expand the map 
ylat=ncvar_get(filenc_WOA_satO2,"lat")
xlon=ncvar_get(filenc_WOA_satO2,"lon")

# stupid grid 
#ind_xlon=which(xlon >= 180.)
#xlon[ind_xlon]=xlon[ind_xlon]- 360.

# WOA grid
lats=expand.grid(xlon,ylat)

# Duplicated grid 
lats1=expand.grid(LONGITUDE,LATITUDE)

# Calculate all the distances between the WOA grid and the duplicated grid
distance=rdist.earth(lats1,lats)

# and Choose the closest one
imin=which.min(distance)

# Read the O2 saturation at the surface 
# float o2sat(Z, Y, X) ;

o2sat_WOA=ncvar_get(filenc_WOA_satO2,"O_an")

o2sat_WOA_surf=o2sat_WOA[,,1]

o2sat_WOA_surf_extract=o2sat_WOA_surf[imin]

nc_close(filenc_WOA_satO2)

# read the Temperature at the surface
filenc_WOA_temp=nc_open(file_in_WOA_temp,readunlim=FALSE,write=FALSE)

TEMP_WOA=ncvar_get(filenc_WOA_temp,"t_an")

TEMP_WOA_surf=TEMP_WOA[,,1]

TEMP_WOA_surf_extract=TEMP_WOA_surf[imin]

nc_close(filenc_WOA_temp)

# read the Salinity at the surface
filenc_WOA_psal=nc_open(file_in_WOA_psal,readunlim=FALSE,write=FALSE)

PSAL_WOA=ncvar_get(filenc_WOA_psal,"s_an")

PSAL_WOA_surf=PSAL_WOA[,,1]

PSAL_WOA_surf_extract=PSAL_WOA_surf[imin]

nc_close(filenc_WOA_psal)

########################################################
# Calculate the PPOX
######################################################## 

pH2Osatsal =   exp(24.4543-(67.4509*(100/(TEMP_WOA_surf_extract+273.15)))-(4.8489*log(((273.15+TEMP_WOA_surf_extract)/100)))-0.000544*PSAL_WOA_surf_extract) # in atm

PPOX_WOA_surf = 0.20946 * 1013.25*(1 - pH2Osatsal) * o2sat_WOA_surf_extract / 100. # en mbar

return(PPOX_WOA_surf)

}
