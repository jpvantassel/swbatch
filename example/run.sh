# This file belongs to SWbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2021 Joseph P. Vantassel (jvantassel@utexas.edu)

# Clean up
rm -r 2_reports
rm -r 3_text

# Useful defaults
workingdirectory=.

# Setup
set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingdirectory} 

# Useful defaults
name=test
ntrial=2
it=10
ns0=1000
nr=100
ns=10
nmodels=10
nrayleigh=1
nlove=1
dcfnum=20
dcfmin=0.2
dcfmax=20
nellipticity=1
ellfmin=0.2
ellfmax=20
ellfnum=30

# Load python3
module load python3

# Install requirements 
pip3 install --user -r ../requirements.txt

# Setpath to Geopsy Install
PATH=$PATH:/work/01698/rauta/geopsy/install/bin/

# Launch swbatch
python3 ../swbatch.py --name ${name} --ntrial ${ntrial} --it ${it}\
 --ns0 ${ns0} --nr ${nr} --ns ${ns} --nmodels ${nmodels} --nrayleigh ${nrayleigh}\
 --nlove ${nlove} --dcfmin ${dcfmin} --dcfmax ${dcfmax} --dcfnum ${dcfnum}\
 --nellipticity ${nellipticity} --ellfmin ${ellfmin} --ellfmax ${ellfmax}\
 --ellfnum ${ellfnum}

# Callback failure
if [ ! $? ]; then
        echo "SWbatch exited with an error status. $?" >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit
fi
