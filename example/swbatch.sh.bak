# GeopsyInvert v0.2.0
# Written by: Joseph Vantassel (jvantassel@utexas.edu)
# Written on: 5 March 2019
# Last edit: 4 April 2019
# This code performs batch inversions that consider mutliple paramaterizations
# Last edit: 24 June 2019
# Update to loop over 2 targets, allow for more than 9 seeds, move extraction inside the loop.
# Last edit: 14 February 2020
# Bug fix with Np

workingDirectory="."
Nm=Test
Sd=2
It=2
N0=2
Nr=5
Ns=5
Np=2
Fnum=5
Fmin=1
Fmax=10

# Setup
set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingDirectory} 

echo "Working Directory = ${workingDirectory}"
echo "Sd                = ${Sd}"
echo "It                = ${It}"
echo "N0                = ${N0}"
echo "Nr                = ${Nr}"
echo "Ns                = ${Ns}"
echo "Np                = ${Np}"
echo "Fnum              = ${Fnum}"
echo "Fmin              = ${Fmin}"
echo "Fmax              = ${Fmax}"

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
        gpdcreport -best $Np Reports/${rep}.report | gpdc -R 1 -n $Fnum -min $Fmin -max $Fmax > Text/${rep}_DC.txt 2>>Text/Transfer.log
        gpdcreport -best $Np Reports/${rep}.report > Text/${rep}_GM.txt 2>>Text/Transfer.log
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
