# GeopsyInvert v1.0.0
# Written by: Joseph Vantassel (jvantassel@utexas.edu)
# Written on: 5 March 2019
# Last edit: 4 April 2019
# This code performs batch inversions that consider mutliple paramaterizations

# Inputs 
#workingDirectory 	# Location of current working directory

# Parameters
Nm=Test		#Trial name (string)
Sd=2 		#Number (positive integer) of starting seeds to attempt
It=2 		#Number (positive integer) of iterations to perform
N0=1000 	#Number (positive integer) of randomly sampled profiles to attempt before first iteration
Nr=50 		#Number (positive integer) of best profiles to consider when resampling
Ns=10 		#Number (positive integer) of new profiles to consider after resampling
Np=10		#Number (positve integer) of profiles to export
Fnum=128	#Number (positve integer) for number of frequency points in dispersion curve
Fmin=1 		#Number (positive float) for minimum frequency of dispersion curve in Hz
Fmax=100	#Number (positve float) for maximum frequency of dispsersion curve in Hz

# Setup
#set -x
#WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
#cd ${workingDirectory} 


# Setpath to Geopsy Install
PATH=$PATH:/work/01698/rauta/geopsy/install/bin/

# Make Reports and Text directories if they do not exist
if [ ! -d "Reports" ]; then
    mkdir Reports
fi

if [ ! -d "Text" ]; then
    mkdir Text
fi

# List of .param files in Params directory
Plist='Params/*.param'
echo $Plist

# List of .target files in Targets directory
Tlist='Targets/*.target'
echo $Tlist

# Setup the meta-inversion loop
on=1
for T in $Tlist ; do 				# Loop through target list
    if [ $on==1 ]; then				# Only allow one target for now
        on=0
        for P in $Plist ; do			# Loop through parameter list
            echo $P
	    for Seed in $(seq 1 $Sd); do 	# New inverison for each seed
                trim=${P:7}
                trim=${trim%%.*}
                rep=${Nm}_${trim}_Sd${Seed}
                dinver -i DispersionCurve -optimization -itmax $It -ns0 $N0 -ns $Ns -nr $Nr -target $T -param $P -o Reports/${rep}.report 2>> Reports/${rep}.log
	    done
        done     
    fi    
done

# Write Np lowest misfit profiles to .txt files
Replist=Reports/*.report
for Rep in ${Replist}; do
    flong=${Rep##*/}
    fname=${flong%%.*}
    gpdcreport -best $Np ${Rep} | gpdc -R 1 -n $Fnum -min $Fmin -max $Fmax > Text/${fname}_DC.txt 2>>Text/Transfer.log
    gpdcreport -best $Np ${Rep} > Text/${fname}_GM.txt 2>>Text/Transfer.log
done

# Callback failure
#if [ ! $? ]; then
#        echo "UTinvert exited with an error status. $?" >&2
#        ${AGAVE_JOB_CALLBACK_FAILURE}
#        exit
#fi
