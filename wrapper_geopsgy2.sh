# GeopsyInvert v2.0.0
# Written by: Joseph Vantassel (jvantassel@utexas.edu)
# Written on: 5 March 2019
# Last edit: 4 April 2019
# This code performs batch inversions that consider mutliple paramaterizations
# Last edit: 24 June 2019
# Update to loop over 2 targets, allow for more than 9 seeds, move extraction inside the loop.

# Inputs 
#workingDirectory 	# Location of current working directory

# Parameters
#Nm=Test	#Trial name (string)
#Sd=2 		#Number (positive integer) of starting seeds to attempt
#It=2 		#Number (positive integer) of iterations to perform
#N0=10	 	#Number (positive integer) of randomly sampled profiles to attempt before first iteration
#Nr=5 		#Number (positive integer) of best profiles to consider when resampling
#Ns=5 		#Number (positive integer) of new profiles to consider after resampling
#Np=10		#Number (positve integer) of profiles to export
#Np=-1		#Number (positve integer) of profiles to export
#Fnum=20 	#Number (positve integer) for number of frequency points in dispersion curve
#Fmin=1 	#Number (positive float) for minimum frequency of dispersion curve in Hz
#Fmax=100	#Number (positve float) for maximum frequency of dispsersion curve in Hz

# Setup
set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingDirectory} 


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

# List of .target files in Targets directory
Tlist='Targets/*.target'

# Setup the meta-inversion loop
tarcount=0
for T in $Tlist ; do
  if [ $tarcount -lt 2 ]; then
    tarname=${T##*/}
    tarroot=${tarname%%.*}
    for P in $Plist ; do
      for Seed in $(seq 0 $((Sd-1))); do
        parname=${P##*/}
        parroot=${parname%%.*}
        rep=${Nm}_${tarroot}_${parroot}_Sd${Seed}
	echo "${rep} Start">>Text/Transfer.log
        dinver -i DispersionCurve -optimization -itmax $It -ns0 $N0 -ns $Ns -nr $Nr -target $T -param $P -o Reports/${rep}.report 2>> Reports/${rep}.log
        if [ $Np -ge 1 ]; then    
          gpdcreport -best $Np Reports/${rep}.report | gpdc -R 1 -n $Fnum -min $Fmin -max $Fmax > Text/${rep}_DC.txt 2>>Text/Transfer.log
          gpdcreport -best $Np Reports/${rep}.report > Text/${rep}_GM.txt 2>>Text/Transfer.log
        else
          msft=$((Np*-1))
          gpdcreport -m $msft Reports/${rep}.report | gpdc -R 1 -n $Fnum -min $Fmin -max $Fmax > Text/${rep}_DC.txt 2>>Text/Transfer.log
          gpdcreport -m $msft Reports/${rep}.report > Text/${rep}_GM.txt 2>>Text/Transfer.log
        fi
	echo "${rep} Complete">>Text/Transfer.log
      done
    done     
  fi
  tarcount=$((tarcount+1))   
done
echo "Job Successful">>Text/Transfer.log

# Callback failure
if [ ! $? ]; then
        echo "UTinvert exited with an error status. $?" >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit
fi
