read_deployment_bottle <- function (file_in_WINKLER,station,cruise) {

if (cruise == "bioargomed") {

print(file_in_WINKLER)

# Read the Winkler file of the bioargomed cruise
WINKLER=read.table(file_in_WINKLER,header=TRUE,comment="#",sep=",")

#################################################################################################
# Transformation between Winkler doxy to Winkler PPOX DOXY With WINKLER_TEMP and WINKLER_PSAL 
#################################################################################################

WINKLER_DOXY=WINKLER$OXYGEN[which(WINKLER$CASTNO == station)]

WINKLER_PRES=WINKLER$CTDPRS[which(WINKLER$CASTNO == station)]

WINKLER_PSAL=WINKLER$CTDSAL[which(WINKLER$CASTNO == station)]

WINKLER_TEMP=WINKLER$CTDTMP[which(WINKLER$CASTNO == station)]

}

if (cruise == "soclim") {

# Read the Winkler file of the soclim cruise  
WINKLER=read.table(file_in_WINKLER,header=TRUE,comment="#",sep="\t")

#################################################################################################
# Transformation between Winkler doxy to Winkler PPOX DOXY With WINKLER_TEMP and WINKLER_PSAL 
#################################################################################################

WINKLER_DOXY=WINKLER$O2winkler[which(WINKLER$Station == station)]

WINKLER_PRES=WINKLER$Pressure[which(WINKLER$Station == station)]

WINKLER_PSAL=WINKLER$Salinity[which(WINKLER$Station == station)]

WINKLER_TEMP=WINKLER$Temperature[which(WINKLER$Station == station)]

# in soclim DOXY is given in micromol/l let's convert it in umol/kg 

swRho_DOXY=swRho(WINKLER_PSAL,WINKLER_TEMP , WINKLER_PRES)

WINKLER_DOXY=WINKLER_DOXY*1000/swRho_DOXY # en micromol / kg 

}

return(list(PRES=WINKLER_PRES,DOXY=WINKLER_DOXY,PSAL=WINKLER_PSAL,TEMP=WINKLER_TEMP))


}
