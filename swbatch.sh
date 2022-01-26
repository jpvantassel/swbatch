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
module load gcc/9.1.0
module load impi
module load mkl
module load fftw3
module load qt5/5.14.2
module load python3
pip3 install --user -r requirements.txt

# Set path to geopsy install
# --------------------------
# for geopsy v2.10.1 | swbatch before and including v0.2.1
#PATH=/work/01698/rauta/geopsy/install/bin:${PATH} 
# for geopsy v2.10.1 | swbatch v0.3.0
#PATH=/work/projects/wma_apps/stampede2/swbatch/geopsy/install/bin:${PATH}
# for geopsy v3.4.2  | swbatch including and after v0.4.0
PATH=/scratch1/04709/vantaj94/geopsy/geopsy-3.4.2/bin:${PATH}

# Launch swbatch
# --------------
python3 swbatch.py --name ${name}\
 --ntrial ${ntrial} --ns0 ${ns0} --nr ${nr} --ns ${ns} --nmodels ${nmodels}\
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
