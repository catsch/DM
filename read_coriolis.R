############################################################################################
# Routine developpee par C. Schmechtig 
#
# January 2018 : Use this routine to perform delayed mode  
#############################################################################################

library(ncdf4)
require(oce)

source("./read_CTD.R")
source("./read_BFILE_DOXY.R")
source("./DOXY_to_PPOX.R")

#############################################################################################
# 1. OPEN the files
#############################################################################################
###### to change to read all files on order to perform DM in it 
# File B
file_in_B="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/6901032/BR6901032_002.nc"

# File C (could be D or R)
file_in_C="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/6901032/D6901032_002.nc"

# Open the file 
filenc_B=nc_open(file_in_B,readunlim=FALSE,write=FALSE)

##################################################
#### 1. Get CTD Data from the Netcdf C File 
##################################################

CTD=read_CTD(file_in_C)

# we get	: CTD$PRES 
#  		: CTD$PSAL 
#		: CTD$TEMP

##################################################
#### 2. Get BGC data from the B File
##################################################

DOXY=read_BFILE_DOXY(filenc_B)

# we get	: DOXY$PRES 
#  		: DOXY$DOXY microg/kg

###################################################
#### 3. Work on DOXY data
################################################### 

# We interpolate CTD DATA to get TEMP and PSAL a DOXY$PRES LEVEL
TEMP_DOXY <- approx(CTD$PRES, CTD$TEMP, DOXY$PRES, rule=2)$y

PSAL_DOXY  <- approx(CTD$PRES, CTD$PSAL, DOXY$PRES, rule=2)$y

# calculate PPOX_DOXY in mbar from DOXY in micromol/kg
PPOX_DOXY=DOXY_to_PPOX(DOXY$PRES, TEMP_DOXY, PSAL_DOXY, DOXY$DOXY)

#Correct PPOX_DOXY in mbar
PPOX_ADJUSTED=PPOX_ADJ()

# Calculate DOXY in micromol/kg from PPOX_ADJUSTED in mbar 
DOXY_ADJUSTED=PPOX_to_DOXY(DOXY$PRES, TEMP_DOXY, PSAL_DOXY, PPOX_ADJUSTED)

#####################################################
#### 4. Fill the nc file 
#####################################################




