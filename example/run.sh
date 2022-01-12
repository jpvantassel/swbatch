#!/bin/bash
# This file belongs to swbatch: A DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2022 Joseph P. Vantassel (jvantassel@utexas.edu)

#SBATCH -J swbatch_example       # Job name
#SBATCH -o swbatch_example.o%j   # Name of stdout output file
#SBATCH -e swbatch_example.e%j   # Name of stderr error file
#SBATCH -p small                 # Queue (partition) name
#SBATCH -N 1                     # Total # of nodes (must be 1 for serial)
#SBATCH -n 1                     # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 03:00:00              # Run time (hh:mm:ss)

# Start
# -----
# print commands as executed
set -x

# Clean up prior run if necessary
# -------------------------------
rm -r 2_reports
rm -r 3_text

# Set values in lieu of tapis input
# ---------------------------------
workingdirectory=.
name=example
ntrial=3
ns0=10000
nr=100
ns=50000
nmodels=10
nrayleigh=0
nlove=0
dcfnum=20
dcfmin=0.2
dcfmax=20
nellipticity=0
ellfmin=0.2
ellfmax=20
ellfnum=30

# Run wrapper in  another directory
# ---------------------------------
other_dir=${SCRATCH}/swbatch/example
mkdir -p ${other_dir}
cp -r 0_targets ${other_dir}/
cp -r 1_parameters ${other_dir}/
cp ../swbatch.py ${other_dir}/
cp ../swbatch.sh ${other_dir}/
cp ../requirements.txt ${other_dir}/
cd ${other_dir}
source swbatch.sh

