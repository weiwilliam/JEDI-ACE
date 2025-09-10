#!/bin/bash

echo "Loading EWOK-SKYLAB Environment Using Spack-Stack 1.9.2"

# load modules
module purge
# ignore that the sticky module ncarenv/... is not unloaded
export LMOD_TMOD_FIND_FIRST=yes
module load ncarenv/24.12
module use /glade/work/epicufsrt/contrib/spack-stack/derecho/modulefiles

module use /glade/work/epicufsrt/contrib/spack-stack/derecho/spack-stack-1.9.2/envs/ue-gcc-12.2.0/install/modulefiles/Core
module load stack-gcc/12.2.0
module load stack-cray-mpich/8.1.27
module load stack-python/3.11.7

module load jedi-fv3-env
module load ewok-env
module load metplus

module load nco

# See README.md
export LD_LIBRARY_PATH="${VIND_BUILD}/lib:${LD_LIBRARY_PATH}"

