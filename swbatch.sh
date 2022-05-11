# This file belongs to swbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2022 Joseph P. Vantassel (joseph.p.vantassel@gmail.com)

# Prepare environment
# -------------------
# print commands as executed
set -x
# get current file's (i.e., the wrapper's) directory
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )
cd ${workingdirectory}
module purge
module load tacc-singularity

# Quick check of help
# -------------------
singularity exec \
--cleanenv --containall \
--bind $PWD:/home/user/analysis/ \
docker://jpvantassel/swbatch:geopsy-v3.4.2 \
/home/user/venv/bin/python3 /home/user/swbatch.py --help

# Launch swbatch
# --------------
singularity exec \
--cleanenv --containall \
--bind $PWD:/home/user/analysis/ \
docker://jpvantassel/swbatch:geopsy-v3.4.2 \
/home/user/venv/bin/python3 /home/user/swbatch.py --name ${name} \
--ntrial ${ntrial} --ns0 ${ns0} --ns ${ns} --nr ${nr} --nmodels ${nmodels} \
--nrayleigh ${nrayleigh} --nlove ${nlove} --dcfmin ${dcfmin} --dcfmax ${dcfmax} --dcfnum ${dcfnum} \
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
