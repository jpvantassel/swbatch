# SWbatch - A DesignSafe-CI application for batch-style surface wave inversions using the Dinver module of the open-source software Geopsy

> Joseph P. Vantassel, The University of Texas at Austin

[![DOI](https://zenodo.org/badge/240935736.svg)](https://zenodo.org/badge/latestdoi/240935736)

## Summary

`SWbatch` is a user-friendly, web-based application hosted on the
DesignSafe-CyberInfrastructure for performing batch-style surface wave
inversions using the Dinver module of the open-source software
[Geopsy](http://geopsy.org/). `SWbatch` allows the user to rapidly and
conveniently invert
experimental dispersion data considering multiple inversion parameterizations
to address the problem’s non-uniqueness and multiple trials per parameterization
to address the problem’s nonlinearity. To facilitate the potentially large
amounts of pre- and post-processing required when performing batch surface-wave
inversions a Python package, `SWprepost`, has been released
open-source. More information about `SWprepost` can be found on its
[GitHub](https://github.com/jpvantassel/swprepost) page.

If you use `SWbatch` in your research we ask that you please cite the following:

>Joseph Vantassel, Harika Gurram, and Brady Cox. (2020). jpvantassel/swbatch:
latest (Concept). Zenodo. https://doi.org/10.5281/zenodo.3840546

_Note: For software, version specific citations should be preferred to general
concept citations, such as that listed above. To generate a version specific
citation for `SWbatch`, please use the citation tool for that specific version
on the `SWbatch` [archive](https://zenodo.org/badge/latestdoi/240935736)._

## Getting Started

There are two ways of using `SWbatch`:

1. As part of a developed Jupyter workflow called SWinvert. (Recommended)
2. Or directly through the DesignSafe-CI Research Workbench. (Not Recommended for reasons provided below).

### Instructions for using the Jupyter Workflow

1. Visit the `SWprepost` [GitHub](https://github.com/jpvantassel/swprepost) and
follow the `Getting Started` instructions. The advanced example
walks you through using the `SWinvert` surface wave inversion workflow.
 __(30 minutes)__
2. Login to [DesignSafe](https://www.designsafe-ci.org/). Transfer the advanced
example and follow the instructions provided therein to repeat the
tutorial. This time using the computational power of `SWbatch` to perform
the inversion rather than using the results provided. Be sure to remove
the previous inputs and results before running your inversion with `SWbatch`.
__(20 minutes, excludes inversion runtime)__
3. Upload your own experimental dispersion data and repeat the workflow. Be sure
to remove the previous inputs and results before running your inversion with
`SWbatch`.
__(20 minutes, excludes inversion runtime)__
4. Enjoy!

### Instructions for using the DesignSafe-CI Research Workbench

_Note: This approach is not recommended as it is more involved than the previous
approach, however for those so inclined instructions are provided below._

1. Visit the `SWprepost` [GitHub](https://github.com/jpvantassel/swprepost) and
follow the `Getting Started` instructions. This will introduce you to
`SWprepost` and the `SWinvert` workflow, which is required for step 2.
__(30 minutes)__
2. Login to [DesignSafe](https://www.designsafe-ci.org/). Create a directory for
your inversion, inside of which mimic the directory structure of the advanced
example from step 1. Place your `.target` and `.param` files in the appropriate
directories. __(45 minutes)__
3. Launch `SWbatch`, by going to
`Research Workbench>Workspace>Simulation>SWbatch` on DesignSafe and following
the instructions provided there. __(30 minutes, excludes inversion runtime)__
4. To see the status of your simulation refer to the `Job Status` bar. When your
job is complete use the `View` button to view your inversion results.
__(5 minutes)__
5. Enjoy!
