read_BFILE<-function(filenc_B) {

STATION_PARAMETERS=ncvar_get(filenc_B,"STATION_PARAMETERS")

# define what you are looking for  
DOXY_string="DOXY                                                            "

# Find the profiles that contains 

index_doxy=which(STATION_PARAMETERS == DOXY_string, arr.ind=TRUE)

i_prof_doxy=index_doxy[,2]

i_param_doxy=index_doxy[1,]

# Get the PRESSURE -> this will give an array of Pressure 

PRES=ncvar_get(filenc_B,"PRES")

DOXY=ncvar_get(filenc_B,"DOXY")

# Test Near Surface Data
for ( i in 1:length(i_prof_doxy)) { 

	if(max(PRES[,i_prof_doxy[i]],na.rm=TRUE) >= 5 ) i_prof_doxy = i_prof_doxy[i]
}

PRES_DOXY=PRES[,i_prof_doxy]

}
