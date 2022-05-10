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
workingdirectory=$PWD
name=example
ntrial=2
ns0=10000
nr=100
ns=500
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

# Run wrapper
# -----------
if [ -z "$SCRATCH" ];
then
  source ../swbatch_local.sh
else
  source ../swbatch.sh
fi
