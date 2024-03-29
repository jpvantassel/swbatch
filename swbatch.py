# This file belongs to swbatch: a DesignSafe-CI application
# for performing batch-style surface-wave inversions.
# Copyright (C) 2019 - 2022 Joseph P. Vantassel (joseph.p.vantassel@gmail.com)

import os
import subprocess
import glob
import logging
import warnings

import click

logging.basicConfig(filename="swbatch.log",
                    filemode="w",
                    level=logging.DEBUG)
logger = logging.getLogger('swbatch')

__version__ = "0.4.0"

@click.command()
@click.option("--name", required=True, type=str, help="Analysis name that is brief, memorable, and descriptive. Each output file will begin with this string of characters. No spaces or special characters are permitted.")
@click.option("--ntrial", required=True, type=str, default=3, help="Number (positive integer) of inversion trials to perform per parameterization. (3 is recommended)")
@click.option("--ns0", required=True, type=str, default=10000, help="Number (positive integer) of randomly sampled models to attempt before the first Neighborhood-Algorithm iteration. (10000 is recommended)")
@click.option("--ns", required=True, type=str, default=50000, help="Number (positive integer) of models to consider. In versions of Geopsy prior to v3.0.0 this was equal to `it`*`ns`. (50000 is recommended)")
@click.option("--nr", required=True, type=str, default=100, help="Number (positive integer) of best models to consider when resampling. (100 is recommended)")
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
def swbatch(name, ntrial=3, ns0=10000, ns=50000, nr=100, nmodels=100, nrayleigh=1, nlove=1, dcfmin=0.2, dcfmax=20, dcfnum=30, nellipticity=1, ellfmin=0.2, ellfmax=20, ellfnum=64):
    """SWbatch: a tool for performing batch-style surface wave inversions."""
    logger.info(f"swbatch version v{__version__}")
    logger.info(f"Inputs:")
    logger.info(f"name         = {name}")
    logger.info(f"ntrial       = {ntrial}")
    logger.info(f"ns0          = {ns0}")
    logger.info(f"ns           = {ns}")
    logger.info(f"nr           = {nr}")
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

    # Add warnings, after switching swbatch from geopsy v2.10.1 to v3.4.2. 
    if int(ns) < 10000:
        warnings.warn("The variable `ns` is less than 10000, searching so few models will likely result in low-quality inversion results.")

    # List of .target files in 0_targets directory.
    targets = glob.glob('0_targets/*.target')
    logger.info("targets      = {}".format(targets))

    # List of .param files in 1_parameters directory.
    params = glob.glob('1_parameters/*.param')
    logger.info("params       = {}".format(params))

    # Create output directories if they do not yet exist.
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
                out = f"{name}_{target_suffix[:-len('.target')]}_{param_suffix[:-len('.param')]}_tr{trial}"

                # Perform surface wave inversion.
                subprocess.run(["dinver", "-i", "DispersionCurve", "-optimization",
                                "-ns0", ns0, "-ns", ns, "-nr", nr,
                                "-target", target, "-param", param, "-f",
                                "-o", "2_reports/{}.report".format(out)], check=True)

                # Extract ground models.
                with open(f"3_text/{out}_gm.txt", "w") as f:
                    subprocess.run(["gpdcreport", "-best", nmodels,
                                    "2_reports/{}.report".format(out)],
                                   stdout=f, check=True)

                # Calculate dispersion.
                if str(nrayleigh) == "0" and str(nlove) == "0":
                    pass
                else:                
                    with open(f"3_text/{out}_dc.txt", "w") as f:
                        subprocess.run(["gpdc", "-R", nrayleigh, "-L", nlove,
                                        "-min", dcfmin, "-max", dcfmax, "-n", dcfnum,
                                        f"3_text/{out}_gm.txt"], stdout=f, check=True)

                # Calculate ellipticity.
                if nellipticity != "0":
                    with open(f"3_text/{out}_ell.txt", "w") as f:
                        subprocess.run(["gpell", "-R", nellipticity,
                                        "-min", ellfmin, "-max", ellfmax, "-n", ellfnum,
                                        f"3_text/{out}_gm.txt"], stdout=f, check=True)

if __name__ == "__main__":
    swbatch()
