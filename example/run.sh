# This file belongs to SWbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2021 Joseph P. Vantassel (jvantassel@utexas.edu)

# Start
# -----
# print commands as executed
set -x

# Clean up
# --------
rm -r 2_reports
rm -r 3_text

# Set values in lieu of tapis input
# ---------------------------------
workingdirectory=.
name=ex
ntrial=2
ns0=100
nr=100
ns=100
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

# Prepare environment
# -------------------
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingdirectory} 
module load python3
pip3 install --user -r ../requirements.txt

# Set path to geopsy install
# --------------------------
# for geopsy 2.10.1 | swbatch before and including 0.3.0
#PATH=$PATH:/work/01698/rauta/geopsy/install/bin/
#for geopsy 3.4.2  | swbatch including and after 0.4.0
PATH=/work2/04709/vantaj94/frontera/geopsy_3-4-2/geopsy-3.4.2/bin:$PATH

# Launch swbatch
# --------------
python3 ../swbatch.py --name ${name} --ntrial ${ntrial}\
 --ns0 ${ns0} --nr ${nr} --ns ${ns} --nmodels ${nmodels} --nrayleigh ${nrayleigh}\
 --nlove ${nlove} --dcfmin ${dcfmin} --dcfmax ${dcfmax} --dcfnum ${dcfnum}\
 --nellipticity ${nellipticity} --ellfmin ${ellfmin} --ellfmax ${ellfmax}\
 --ellfnum ${ellfnum}

# Callback failure
# ----------------
# if not exit code zero.
# ! is not and $? captures the last exit code.
if [ ! $? ]; then
        echo "swbatch exited with a non-zero exit status. The exit status is: $?" >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit
fi
