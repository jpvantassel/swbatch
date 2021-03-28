# This file belongs to SWbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2021 Joseph P. Vantassel (jvantassel@utexas.edu)

import os
import subprocess
import glob
import logging

import click

logging.basicConfig(filename="swbatch.log",
                    filemode="w",
                    level=logging.DEBUG)
logger = logging.getLogger('swbatch')


@click.command()
@click.option("--name", required=True, type=str, help="Analysis name that is brief, memorable, and descriptive. Each output file will begin with this string of characters. No spaces or special characters are permitted.")
@click.option("--ntrial", required=True, type=int, default=3, help="Number (positive integer) of inversion trials to perform per parameterization. (3 is recommended)")
@click.option("--it", required=True, type=int, default=250, help="Number of Neighborhood-Algorithm iterations to perform per inversion. (250 is recommended)")
@click.option("--ns0", required=True, type=int, default=10000, help="Number (positive integer) of randomly sampled profiles to attempt before the first Neighborhood-Algorithm iteration. (10000 is recommended)")
@click.option("--nr", required=True, type=int, default=100, help="Number (positive integer) of best profiles to consider when resampling. (100 is recommended)")
@click.option("--ns", required=True, type=int, default=200, help="Number (positive integer) of new profiles to consider per Neighborhood-Algorithm iteration. (200 is recommended)")
@click.option("--ngroundmodel", required=True, type=int, default=100, help="")
@click.option("--nrayleigh", required=True, type=int, help="")
@click.option("--nlove", required=True, type=int, help="")
@click.option("--dcfnum", required=True, type=int,help="")
@click.option("--dcfmin", required=True, type=float, help="")
@click.option("--dcfmax", required=True, type=float, help="")
@click.option("--nellipticity", required=True, type=int, default=0, help="")
@click.option("--ellfnum", required=True, type=int, default=64, help="")
@click.option("--ellfmin", required=True, type=float, default=0.2, help="")
@click.option("--ellfmax", required=True, type=float, default=20, help="")
def swbatch(name, ntrial=3, it=250, ns0, nr, ns, ngroundmodel, nrayleigh, nlove, nell, dcfnum, dcfmin, dcfmax, nellipticity=0, ellfnum=64, ellfmin=0.2, ellfmax=20):
    """Perform batch-style surface wave inversion.

    Parameters
    ----------
    name : str
      Analysis name that is brief, memorable, and descriptive. Each
      output file will begin with this string of characters. No spaces
      or special characters are permitted.
    ntrial : int, optional
      Number of inversion trials to perform per parameterization,
      default is 3.
    it : int, optional
      Number of Neighborhood-Algorithm iterations to perform per
      inversion, default is 250.

    """
    logger.info(f"name = {name}")

    # echo "name              = ${name}"
    # echo "ntrial            = ${ntrial}"
    # echo "It                = ${It}"
    # echo "Ns0               = ${Ns0}"
    # echo "Nr                = ${Nr}"
    # echo "Ns                = ${Ns}"
    # echo "nprofile          = ${nprofile}"
    # echo "fnum              = ${fnum}"
    # echo "fmin              = ${fmin}"
    # echo "fmax              = ${fmax}"

    # # Setpath to Geopsy Install
    # PATH=$PATH:/work/01698/rauta/geopsy/install/bin/

    # List of .target files in 0_targets directory
    targets = glob.glob('0_targets/*.target')

    # List of .param files in 1_parameters directory
    params = glob.glob('1_parameters/*.param')

    # Create directories if they do not yet exist.
    dirs = ["2_reports", "3_text"]
    for _dir in dirs:
        if not os.path.isdir(_dir):
            os.mkdir(_dir)

    # # Setup the meta-inversion loop
    # for target in targets:
    #   for param in params:

    #     tarname=${ctar##*/}
    #     tarroot=${tarname%%.*}
    #     for cpar in $plist ; do
    #       for trial in $(seq 0 $((${ntrial}-1))); do
    #         parname=${cpar##*/}
    #         parroot=${parname%%.*}
    #         rep=${name}_${tarroot}_${parroot}_Tr${trial}
    # 	      echo "${rep} Start">>3_text/transfer.log
    #         dinver -i DispersionCurve -optimization -itmax ${It} -ns0 ${Ns0} -ns ${Ns} -nr ${Nr} -target ${ctar} -param ${cpar} -o 2_reports/${rep}.report 2>> 2_reports/${rep}.log
    #         gpdcreport -best ${nprofile} 2_reports/${rep}.report | gpdc -R 1 -n ${fnum} -min ${fmin} -max ${fmax} > 3_text/${rep}_DC.txt 2>>3_text/transfer.log
    #         gpdcreport -best ${nprofile} 2_reports/${rep}.report > 3_text/${rep}_GM.txt 2>>3_text/transfer.log
    # 	      echo "${rep} Complete">>3_text/transfer.log
    #       done
    #     done
    #   fi
    #   tarcount=$((tarcount+1))
    # done
    # echo "Job Complete">>3_text/transfer.log


if __name__ == "__main__":
    swbatch()
