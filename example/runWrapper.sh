#!/bin/bash
#SBATCH -J MyTest0         
#SBATCH -o MyTest0.o%j
#SBATCH -e MyTest0.e%j
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 1 
#SBATCH -t 00:30:00
#SBATCH -A DesignSafe-BCox-UTAu
#SBATCH --mail-user=jvantassel@utexas.edu
#SBATCH --mail-type=all
./wrapper.sh
