# This file belongs to swbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2022 Joseph P. Vantassel (jvantassel@utexas.edu)

# Prepare environmenti
# -------------------
# print commands as executed
set -x
# get current file's (i.e., the wrapper's) directory
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingdirectory}
module purge
module load tacc-singularity

singularity pull docker://jpvantassel/geopsy-docker:3.4.2-qt5.14

singularity run geopsy-docker_3.4.2-qt5.14.sif \
pip3 install --user -r ./requirements.txt

# Launch swbatch
# --------------
singularity run geopsy-docker_3.4.2-qt5.14.sif \
python3 ./swbatch.py --name ${name}\
 --ntrial ${ntrial} --ns0 ${ns0} --ns ${ns} --nr ${nr} --nmodels ${nmodels}\
 --nrayleigh ${nrayleigh} --nlove ${nlove} --dcfmin ${dcfmin} --dcfmax ${dcfmax} --dcfnum ${dcfnum}\
 --nellipticity ${nellipticity} --ellfmin ${ellfmin} --ellfmax ${ellfmax} --ellfnum ${ellfnum}

# Callback failure
# ----------------
# if not exit code zero.
# "!" is logical not and "#?" captures the last exit code.
if [ ! $? ]; then
        echo "swbatch exited with a non-zero exit status. The exit status was: $?" >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit
fi
