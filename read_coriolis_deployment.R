############################################################################################
# Routine developpee par C. Schmechtig 
#
# January 2018 : Use this routine to estimate coefficient for adjustment to compare 
# Float data to data at deployment  
#############################################################################################

library(ncdf4)
require(oce)

source("./read_CTD.R")
source("./read_BFILE_DOXY.R")
source("./WINKLER_to_PPOX_ADJ.R")
source("./DOXY_to_PPOX.R")
source("./read_deployment_bottle.R")

##########################################################################
# 0. Get the WMO for the command line	
##########################################################################

uf=commandArgs()

WMO  <- uf[2]

PROFILE <- uf[3]

#############################################################################################
# 1. OPEN the files
#############################################################################################
###### to change
# File B
file_in_B=paste("/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/",WMO,"/BR",WMO,"_",PROFILE,".nc",sep="")

# File C (could be D or R)
file_in_C=paste("/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/RT/DATA/",WMO,"/R",WMO,"_",PROFILE,".nc",sep="")

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
TEMP_DOXY <- approx(DOXY$PRES, CTD$TEMP, CTD$PRES, rule=2)$y

PSAL_DOXY  <- approx(DOXY$PRES, CTD$PSAL, CTD$PRES, rule=2)$y

# calculate PPOX_DOXY in mbar from DOXY in micromol/kg
PPOX_DOXY=DOXY_to_PPOX(DOXY$PRES, TEMP_DOXY, PSAL_DOXY, DOXY$DOXY)

#####################################################
#### 4. COMPARE to WINKLER DATA 
#####################################################

SLOPE_PPOX=WINKLER_to_PPOX_ADJ(DOXY$PRES,PPOX_DOXY,WMO)

print(SLOPE_PPOX)
