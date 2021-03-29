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
@click.option("--nmodels", required=True, type=int, default=100, help="Number (positive integer) of ground models/dispersion curves/ellipticity curves to export. (100 is recommended)")
@click.option("--nrayleigh", required=True, type=int, default=1, help="Number (positive integer) of Rayleigh wave modes to export. (1 is recommended)")
@click.option("--nlove", required=True, type=int, default=1, help="Number (positive integer) of Love wave modes to export. (1 is recommended)")
@click.option("--dcfmin", required=True, type=float, default=0.2, help="Number (positive float) for minimum frequency of exported dispersion curve(s) in Hz. Selecting a value slightly less than the minimum frequency of your experimental dispersion data is recommended.")
@click.option("--dcfmax", required=True, type=float, default=20, help="Number (positive float) for maximum frequency of exported dispersion curve(s) in Hz. Selecting a value slightly larger than the maximum frequency of your experimental dispersion data is recommended.")
@click.option("--dcfnum", required=True, type=int, default=30, help="Number (positive integer) of frequency points in the exported dispersion curve(s). (30 is recommended)")
@click.option("--nellipticity", required=True, type=int, default=1, help="Number (positive integer) of Rayleigh modes to include in exported ellipticity. (1 is recommended)")
@click.option("--ellfmin", required=True, type=float, default=0.2, help="Number (positive float) for minimum frequency of exported Rayleigh wave ellipticity curve(s) in Hz. Selecting a value less than the site's resonant frequency is recommended.")
@click.option("--ellfmax", required=True, type=float, default=20, help="Number (positive float) for maximum frequency of exported Rayleigh wave ellipticity curve(s) in Hz. Selecting a value greater than the site's resonant frequency is recommended.")
@click.option("--ellfnum", required=True, type=int, default=30, help="Number of frequency points in exported Rayleigh wave ellipticity curve(s). (30 is recommended)")
def swbatch(name, ntrial=3, it=250, ns0=10000, nr=100, ns=200, nmodels=100, nrayleigh=1, nlove=1, dcfmin=0.2, dcfmax=20, dcfnum=30, nellipticity=1, ellfmin=0.2, ellfmax=20, ellfnum=30):
    """SWbatch: a tool for performing batch-style surface wave inversions.

    """
    logger.info(f"Inputs:")
    logger.info(f"name         = {name}")
    logger.info(f"ntrial       = {ntrial}")
    logger.info(f"it           = {it}")
    logger.info(f"ns0          = {ns0}")
    logger.info(f"nr           = {nr}")
    logger.info(f"ns           = {ns}")
    logger.info(f"nmodels      = {nmodels}")
    logger.info(f"nrayleigh    = {nrayleigh}")
    logger.info(f"nlove        = {nlove}")
    logger.info(f"dcfmin       = {dcfmin}")
    logger.info(f"dcfmax       = {dcfmax}")
    logger.info(f"dcfnum       = {dcfnum}")
    logger.info(f"nellipticity = {nellipticity}")
    logger.info(f"ellfmin      = {ellfmin}")
    logger.info(f"ellfmax      = {ellfmax}")
    logger.info(f"ellfnum      = {ellfnum}")

    # List of .target files in 0_targets directory.
    targets = glob.glob('0_targets/*.target')

    # List of .param files in 1_parameters directory.
    params = glob.glob('1_parameters/*.param')

    # Create directories if they do not yet exist.
    dirs = ["2_reports", "3_text"]
    for _dir in dirs:
        if not os.path.isdir(_dir):
            os.mkdir(_dir)

    # Setup the meta-inversion loop.
    for target in targets:
        for param in params:
            for trial in range(ntrial):
                logging.info(
                    f"Starting: target={target}, param={param}, trial={trial}")

                # Create default file name.
                out = f"{name}_{target[:-7]}_{param[:-6]}_TR{trial}"

                # Perform surface wave inversion.
                # dinver -i DispersionCurve -optimization -itmax ${It} -ns0 ${Ns0} -ns ${Ns} -nr ${Nr} -target ${ctar} -param ${cpar} -o 2_reports/${rep}.report 2>> 2_reports/${rep}.log
                subprocess.run(["dinver", "-i", "DispersionCurve", "-optimization", "-itmax", it, "-ns0", ns0, "-ns",
                                ns, "-nr", nr, "-target", target, "-param", param, "-o", f"2_reports/{out}.report"], check=True)

                # Extract ground models.
                # gpdcreport -best ${nprofile} 2_reports/${rep}.report > 3_text/${rep}_GM.txt 2>>3_text/transfer.log
                with open(f"3_text/{out}_GM.txt", "w") as f:
                    subprocess.run(["gpdcreport", "-best", nmodels,
                                    f"2_report/{out}.report"], stdout=f, check=True)

                # Calculate dispersion.
                # gpdc -R 1 -n ${fnum} -min ${fmin} -max ${fmax} > 3_text/${rep}_DC.txt 2>>3_text/transfer.log
                with open(f"3_text/{out}_DC.txt", "w") as f:
                    subprocess.run(["gpdc", "-R", nrayleigh, "-L", nlove, "-min", dcfmin, "-max",
                                    dcfmax, "-n", dcfnum, f"3_text/{out}_GM.txt"], stdout=f, check=True)

                # Calculate ellipticity.
                # gpell -R 1 -n ${fnum} -min ${fmin} -max ${fmax} > 3_text/${rep}_DC.txt 2>>3_text/transfer.log
                with open(f"3_text/{out}_ELL.txt", "w") as f:
                    subprocess.run(["gpell", "-R", nellipticity, "-min", ellfmin, "-max",
                                    ellfmax, "-n", ellfnum, f"3_text/{out}_GM.txt"], stdout=f, check=True)


if __name__ == "__main__":
    swbatch()
