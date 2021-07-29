# This file belongs to SWbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2021 Joseph P. Vantassel (jvantassel@utexas.edu)

# Setup
set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingdirectory} 

# Load python3
module load python3

# Install requirements 
pip3 install --user -r requirements.txt

# Setpath to Geopsy install
# PATH=$PATH:/work/01698/rauta/geopsy/install/bin/
PATH=$PATH:/work/projects/wma_apps/stampede2/swbatch/

# Launch swbatch
python3 swbatch.py --name ${name} --ntrial ${ntrial} --it ${it}\
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
