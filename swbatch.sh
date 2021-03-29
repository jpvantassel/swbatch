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
pip3 --user install -r requirements.txt

# Setpath to Geopsy Install
PATH=$PATH:/work/01698/rauta/geopsy/install/bin/

# Launch swbatch
python3 swbatch.py --name ${name} --ntrial ${ntrial} --it ${it}\
--ns0 ${ns0} --nr ${nr} --ns ${ns} --nrayleigh ${nrayleigh}\
--nlove ${nlove} --dcfnum ${dcfnum} --dcfmin ${dcfmin} --dcfmax ${dcfmax}\
--nellipticity ${nellipticity} --ellfnum ${ellfnum} --ellfmin ${ellfmin}\
--ellfmax ${ellfmax}

# Callback failure
if [ ! $? ]; then
        echo "SWbatch exited with an error status. $?" >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit
fi
