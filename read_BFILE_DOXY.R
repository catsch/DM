read_BFILE_DOXY<-function(filenc_B) {

STATION_PARAMETERS=ncvar_get(filenc_B,"STATION_PARAMETERS")

# We are looking for DOXY   
DOXY_string="DOXY                                                            "

# Find the profiles that contains DOXY

index_doxy=which(STATION_PARAMETERS == DOXY_string, arr.ind=TRUE)

i_prof_doxy=index_doxy[,2]

i_param_doxy=index_doxy[1,]

# Get the PRESSURE -> this will give an array of Pressure 

PRES=ncvar_get(filenc_B,"PRES")

DOXY=ncvar_get(filenc_B,"DOXY")

# Test Near Surface Data
# Decision of ADMT 2017 Pumped and unpumped data will be stored in the same profile 
for ( i in 1:length(i_prof_doxy)) { 

	if(max(PRES[,i_prof_doxy[i]],na.rm=TRUE) >= 5 ) i_prof = i_prof_doxy[i]
}

PRES_DOXY=PRES[,i_prof]

DOXY_DOXY=DOXY[,i_prof]

##### Return

result=(list(PRES=PRES_DOXY,DOXY=DOXY_DOXY,i_prof=i_prof))


}
