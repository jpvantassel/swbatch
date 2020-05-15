# Setup
set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingDirectory} 

echo ${Nm}

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
      for Seed in `seq 0 $(( ${Sd} - 1 ))`; do
        parname=${P##*/}
        parroot=${parname%%.*}
        rep=${Nm}_${tarroot}_${parroot}_Sd$Seed
	echo "${rep} Start">>Text/Transfer.log
        dinver -i DispersionCurve -optimization -itmax ${It} -ns0 ${N0} -ns ${Ns} -nr ${Nr} -target $T -param $P -o Reports/${rep}.report 2>> Reports/${rep}.log
        if [ ${Np} -ge 1 ]; then    
          gpdcreport -best ${Np} Reports/${rep}.report | gpdc -R 1 -n ${Fnum} -min ${Fmin} -max ${Fmax} > Text/${rep}_DC.txt 2>>Text/Transfer.log
          gpdcreport -best ${Np} Reports/${rep}.report > Text/${rep}_GM.txt 2>>Text/Transfer.log
        else
          msft=$((${Np}*-1))
          gpdcreport -m $msft Reports/${rep}.report | gpdc -R 1 -n ${Fnum} -min ${Fmin} -max ${Fmax} > Text/${rep}_DC.txt 2>>Text/Transfer.log
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
