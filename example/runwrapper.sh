#!/bin/bash
#SBATCH -J test_swbatch         
#SBATCH -o test_swbatch_%j.o
#SBATCH -e test_swbatch_%j.e
#SBATCH -p normal
#SBATCH -N 1
#SBATCH -n 68 
#SBATCH -t 00:30:00
#SBATCH -A DesignSafe-BCox-UTAu
#SBATCH --mail-user=jvantassel@utexas.edu
#SBATCH --mail-type=all
./swbatch.sh
