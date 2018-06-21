############################################################################################
# Routine developpee par C. Schmechtig 
#
# February 2018 : Use this routine to ADJUST the NITRATE at DEPTH with CANYON based on a DOXY
# Adjusted at surface with WOA 
#############################################################################################

library(ncdf4)
require(oce)

source("./read_CTD.R")
source("./read_BFILE_DOXY.R")
source("./DOXY_to_PPOX.R")
source("./WOA_to_PPOX.R")
source("./WOA_to_PPOX_MONTH.R")
source("./PPOX_to_DOXY.R")

#############################################################################################
# 1. OPEN the files
#############################################################################################
###### to change to read all files on order to perform DM in it 

uf=commandArgs()

file_in_B <- uf[2]

file_in_C <- uf[3]

# File B
# file_in_B="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/6902701/BR6902701_003.nc"

# File C (could be D or R)
# file_in_C="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/6902701/R6902701_003.nc"

# Open the file 
filenc_B=nc_open(file_in_B,readunlim=FALSE,write=FALSE)

##################################################
#### 1. Get CTD Data from the Netcdf C File 
##################################################

CTD=read_CTD(file_in_C)

# we get	: CTD$PRES 
#  		: CTD$PSAL 
#		: CTD$TEMP

##########################################################
#### 2. Get Latitude and LONGITUDE from the Netcdf B file
##########################################################

LATITUDE=ncvar_get(filenc_B,"LATITUDE")

LATITUDE=LATITUDE[!duplicated(LATITUDE)]

LONGITUDE=ncvar_get(filenc_B,"LONGITUDE")

LONGITUDE=LONGITUDE[!duplicated(LONGITUDE)]

JULD=ncvar_get(filenc_B,"JULD")

JULD=JULD[!duplicated(JULD)]

MONTH=format(as.Date(JULD, origin=as.Date("1950-01-01")),format="%m")

print(MONTH)

##################################################
#### 3. Get BGC data from the B File
##################################################

DOXY=read_BFILE_DOXY(filenc_B)

# we get	: DOXY$PRES 
#  		: DOXY$DOXY microg/kg

###################################################
#### 4. Work on DOXY data
################################################### 

#### 4.a Estimate PPOX from DOXY

# We interpolate CTD DATA to get TEMP and PSAL a DOXY$PRES LEVEL
TEMP_DOXY <- approx(DOXY$PRES, CTD$TEMP, CTD$PRES, rule=2)$y

PSAL_DOXY  <- approx(DOXY$PRES, CTD$PSAL, CTD$PRES, rule=2)$y

# calculate PPOX_DOXY in mbar from DOXY in micromol/kg
PPOX_DOXY=DOXY_to_PPOX(DOXY$PRES, TEMP_DOXY, PSAL_DOXY, DOXY$DOXY)

#### 4.b Get PPOX on WOA at surface 

PPOX_WOA_surf=WOA_to_PPOX(LATITUDE,LONGITUDE)

# and with month from climatology

PPOX_WOA_surf_month=WOA_to_PPOX_MONTH(LATITUDE,LONGITUDE, MONTH)

#### 4.c Calculate the correction factor

PPOX_CORR=PPOX_WOA_surf/PPOX_DOXY[1]

PPOX_CORR_MONTH=PPOX_WOA_surf_month/PPOX_DOXY[1]

#### 4.d Apply the factor to the whole PPOX_DOXY profile

PPOX_ADJUSTED=PPOX_DOXY*PPOX_CORR
 
DOXY_ADJUSTED=PPOX_to_DOXY(DOXY$PRES, TEMP_DOXY, PSAL_DOXY, PPOX_ADJUSTED)

#####################################################
#### 4. Fill the nc file 
#####################################################
sink('resultats_fact_107c.txt',append=TRUE)
print(c(JULD,PPOX_CORR,PPOX_CORR_MONTH))
sink()

