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

__version__ = "0.3.1"

@click.command()
@click.option("--name", required=True, type=str, help="Analysis name that is brief, memorable, and descriptive. Each output file will begin with this string of characters. No spaces or special characters are permitted.")
@click.option("--ntrial", required=True, type=str, default=3, help="Number (positive integer) of inversion trials to perform per parameterization. (3 is recommended)")
@click.option("--it", required=True, type=str, default=250, help="Number of Neighborhood-Algorithm iterations to perform per inversion. (250 is recommended)")
@click.option("--ns0", required=True, type=str, default=10000, help="Number (positive integer) of randomly sampled profiles to attempt before the first Neighborhood-Algorithm iteration. (10000 is recommended)")
@click.option("--nr", required=True, type=str, default=100, help="Number (positive integer) of best profiles to consider when resampling. (100 is recommended)")
@click.option("--ns", required=True, type=str, default=200, help="Number (positive integer) of new profiles to consider per Neighborhood-Algorithm iteration. (200 is recommended)")
@click.option("--nmodels", required=True, type=str, default=100, help="Number (positive integer) of ground models/dispersion curves/ellipticity curves to export. (100 is recommended)")
@click.option("--nrayleigh", required=True, type=str, default=1, help="Number (positive integer) of Rayleigh wave modes to export. (1 is recommended)")
@click.option("--nlove", required=True, type=str, default=1, help="Number (positive integer) of Love wave modes to export. (1 is recommended)")
@click.option("--dcfmin", required=True, type=str, default=0.2, help="Number (positive float) for minimum frequency of exported dispersion curve(s) in Hz. Selecting a value slightly less than the minimum frequency of your experimental dispersion data is recommended.")
@click.option("--dcfmax", required=True, type=str, default=20, help="Number (positive float) for maximum frequency of exported dispersion curve(s) in Hz. Selecting a value slightly larger than the maximum frequency of your experimental dispersion data is recommended.")
@click.option("--dcfnum", required=True, type=str, default=30, help="Number (positive integer) of frequency points in the exported dispersion curve(s). (30 is recommended)")
@click.option("--nellipticity", required=True, type=str, default=1, help="Number (positive integer) of Rayleigh modes to include in exported ellipticity. (1 is recommended)")
@click.option("--ellfmin", required=True, type=str, default=0.2, help="Number (positive float) for minimum frequency of exported Rayleigh wave ellipticity curve(s) in Hz. Selecting a value less than the site's resonant frequency is recommended.")
@click.option("--ellfmax", required=True, type=str, default=20, help="Number (positive float) for maximum frequency of exported Rayleigh wave ellipticity curve(s) in Hz. Selecting a value greater than the site's resonant frequency is recommended.")
@click.option("--ellfnum", required=True, type=str, default=64, help="Number of frequency points in exported Rayleigh wave ellipticity curve(s). (30 is recommended)")
def swbatch(name, ntrial=3, it=250, ns0=10000, nr=100, ns=200, nmodels=100, nrayleigh=1, nlove=1, dcfmin=0.2, dcfmax=20, dcfnum=30, nellipticity=1, ellfmin=0.2, ellfmax=20, ellfnum=64):
    """SWbatch: a tool for performing batch-style surface wave inversions.

    """
    logger.info("Inputs:")
    logger.info("name         = {}".format(name))
    logger.info("ntrial       = {}".format(ntrial))
    logger.info("it           = {}".format(it))
    logger.info("ns0          = {}".format(ns0))
    logger.info("nr           = {}".format(nr))
    logger.info("ns           = {}".format(ns))
    logger.info("nmodels      = {}".format(nmodels))
    logger.info("nrayleigh    = {}".format(nrayleigh))
    logger.info("nlove        = {}".format(nlove))
    logger.info("dcfmin       = {}".format(dcfmin))
    logger.info("dcfmax       = {}".format(dcfmax))
    logger.info("dcfnum       = {}".format(dcfnum))
    logger.info("nellipticity = {}".format(nellipticity))
    logger.info("ellfmin      = {}".format(ellfmin))
    logger.info("ellfmax      = {}".format(ellfmax))
    logger.info("ellfnum      = {}".format(ellfnum))

    # List of .target files in 0_targets directory.
    targets = glob.glob('0_targets/*.target')
    logger.info("targets      = {}".format(targets))

    # List of .param files in 1_parameters directory.
    params = glob.glob('1_parameters/*.param')
    logger.info("params       = {}".format(params))

    # Create directories if they do not yet exist.
    dirs = ["2_reports", "3_text"]
    for _dir in dirs:
        if not os.path.isdir(_dir):
            os.mkdir(_dir)

    # Setup the meta-inversion loop.
    for target in targets:
        for param in params:
            for trial in range(int(ntrial)):
                logger.info("Starting: {}, {}, {}".format(target, param, trial))

                # Create default file name.
                _, target_suffix = target.split("/")
                _, param_suffix = param.split("/")
                out = "{}_{}_{}_TR{}".format(name, target_suffix[:-7], param_suffix[:-6], trial)

                # Perform surface wave inversion.
                subprocess.run(["dinver", "-i", "DispersionCurve", "-optimization",
                                "-itmax", str(it), "-ns0", str(ns0), "-ns", str(ns), "-nr", str(nr),
                                "-target", target, "-param", param, "-f",
                                "-o", "2_reports/{}.report".format(out)], check=True)

                # Extract ground models.
                with open("3_text/{}_GM.txt".format(out), "w") as f:
                    subprocess.run(["gpdcreport", "-best", nmodels,
                                    "2_reports/{}.report".format(out)],
                                   stdout=f, check=True)

                # Calculate dispersion.
                if str(nrayleigh) == "0" and str(nlove) == "0":
                    pass
                else:                
                    with open("3_text/{}_DC.txt".format(out), "w") as f:
                        subprocess.run(["gpdc", "-R", str(nrayleigh), "-L", str(nlove),
                                        "-min", str(dcfmin), "-max", str(dcfmax), "-n", str(dcfnum),
                                        "3_text/{}_GM.txt".format(out)], stdout=f, check=True)

                # Calculate ellipticity.
                if str(nellipticity) != "0":
                    with open("3_text/{}_ELL.txt".format(out), "w") as f:
                        subprocess.run(["gpell", "-R", str(nellipticity),
                                        "-min", str(ellfmin), "-max", str(ellfmax), "-n", str(ellfnum),
                                        "3_text/{}_GM.txt".format(out)], stdout=f, check=True)


if __name__ == "__main__":
    swbatch()
