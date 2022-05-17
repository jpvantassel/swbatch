# _swbatch_ - A DesignSafe-CI application for batch-style surface wave inversions using the _dinver_ module of the open-source software _geopsy_

> Joseph P. Vantassel, The University of Texas at Austin

[![DOI](https://zenodo.org/badge/240935736.svg)](https://zenodo.org/badge/latestdoi/240935736)

## Summary

_swbatch_ is a user-friendly, web-based application hosted on the
DesignSafe-CyberInfrastructure for performing batch-style surface wave
inversions using the _dinver_ module of the open-source software
_[geopsy](http://geopsy.org/)_. _swbatch_ allows the user to rapidly and
conveniently invert experimental dispersion data considering multiple inversion
parameterizations to address the problem’s non-uniqueness and multiple trials
per parameterization to address the problem’s nonlinearity as detailed in the
SWinvert workflow (Vantassel and Cox, 2021). To facilitate the potentially large
amounts of pre- and post-processing required when performing batch surface-wave
inversions a Python package, _swprepost_, (Vantassel, 2020) has been released
open-source. More information about _swprepost_ can be found on its
[GitHub](https://github.com/jpvantassel/swprepost) page.

If you use _swbatch_ in your research we ask that you please cite the following:

> Vantassel, J.P., Gurram, H., and Cox, B.R., (2020). jpvantassel/swbatch:
> latest (Concept). Zenodo. https://doi.org/10.5281/zenodo.3840546

> Vantassel, J.P. and Cox, B.R. (2021). SWinvert: a workflow for performing
> rigorous 1-D surface wave inversions. Geophysical Journal International
> 224, 1141-1156. https://doi.org/10.1093/gji/ggaa426

_Note: For software, version specific citations should be preferred to general
concept citations, such as that listed above. To generate a version specific
citation for `swbatch`, please use the citation tool for that specific version
on the `swbatch` [archive](https://zenodo.org/badge/latestdoi/240935736)._

## Getting Started

There are two ways of using _swbatch_:

1. As part of a developed Jupyter workflow called SWinvert. (Recommended)
2. Or directly through the DesignSafe-CI Research Workbench. (Not Recommended for reasons provided below).

### Instructions for using the Jupyter Workflow

1. Visit the _swprepost_ [GitHub](https://github.com/jpvantassel/swprepost) and
follow the `Getting Started` instructions. The advanced example
walks you through using the `SWinvert` surface wave inversion Jupyter workflow.
 __(30 minutes)__
2. Login to [DesignSafe](https://www.designsafe-ci.org/). Transfer the advanced
example and follow the instructions provided therein to repeat the
tutorial. This time be sure to use the computational power of _swbatch_ to
perform the inversion rather than only viewing the results provided. Be sure to
remove the previous inputs and results before running your inversion with
 _swbatch_. Note more detailed instructions for completing this step are
provided in the Jupyter notebook.
__(20 minutes, excludes inversion runtime)__
3. Upload your own experimental dispersion data and repeat the workflow. Be sure
to remove the previous inputs and results before running your inversion with
 _swbatch_.
__(20 minutes, excludes inversion runtime)__
4. Enjoy!

### Instructions for using the DesignSafe-CI Research Workbench

_Note: This approach is not recommended as it is more involved than the previous
approach, however for those so inclined instructions are provided below._

1. Visit the _swprepost_ [GitHub](https://github.com/jpvantassel/swprepost) and
follow the `Getting Started` instructions. This will introduce you to
_swprepost_ and the `SWinvert` workflow, which is required before proceeding to
step 2 in these instructions.
__(30 minutes)__
2. Login to [DesignSafe](https://www.designsafe-ci.org/). Create a directory for
your inversion, inside of which mimic the directory structure of the advanced
example you completed as part of the previous step. Place your `.target` and
`.param` files in the appropriate directories. __(45 minutes)__
3. Launch  _swbatch_, by going to
`Workspace > Tools & Applications > Hazard Apps > SWbatch` on DesignSafe and following
the instructions provided there. __(30 minutes, excludes inversion runtime)__
4. To see the status of your simulation refer to the `Job Status` bar. When your
job is complete go to `Job Status > More info > View` to view your inversion results.
__(5 minutes)__
5. Enjoy!
