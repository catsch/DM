WINKLER_to_PPOX_ADJ <- function ( PRES_DOXY, PPOX_DOXY, WMO ){
################################################################
# This routine is dedicated to estimate the PPOX_ADJ 
#
# COMPARING PPOX estimated form the float to 
# PPOX with a winkler titration at the deployment 
# C. Schmechtig January 2018
#################################################################

###############################################################
# Read the Deployment file
###############################################################

file_in_deployment="/home/schmechtig/TRAITEMENT_FLOTTEUR/ANTOINE/DATA_MANAGEMENT/DEPLOYMENT/deployment.txt"

deployment=read.table(file_in_deployment,header=TRUE,comment="#",sep="\t",colClasses = "character")

file_in_bottle <- deployment$FILE[which(deployment$WMO==WMO)]

cruise <- deployment$CRUISE[which(deployment$WMO==WMO)]

station <- deployment$STATION[which(deployment$WMO==WMO)]

#######################################################
# Read Bottle File
#######################################################

WINKLER=read_deployment_bottle(file_in_bottle,station,cruise)

#### Transform Winkler in PPOX 

PPOX_WINKLER=DOXY_to_PPOX( WINKLER$PRES , WINKLER$TEMP , WINKLER$PSAL, WINKLER$DOXY)

###################################################################################################
# Interpolation of PPOX FLOAT profiles on Winkler Pressure
###################################################################################################

# We interpolate PPOX FLOAT profile to estimate PPOX at Winkler level
FLOAT_PPOX <- approx(PRES_DOXY, PPOX_DOXY, WINKLER$PRES, rule=2)$y

########################################################################################
# Linear Regression between FLOAT_PPOX and WINKLER_PPOX avec Intercept = 0 
########################################################################################

fit<-lm(PPOX_WINKLER~0 +FLOAT_PPOX)

SLOPE_PPOX=fit[1]

return(SLOPE_PPOX)

}
