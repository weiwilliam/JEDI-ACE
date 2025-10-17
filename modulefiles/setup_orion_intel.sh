#!/bin/bash

echo "Loading EWOK-SKYLAB Environment Using Spack-Stack 1.9.3"

SPACK_STACK_INTEL_ENV=/apps/contrib/spack-stack/spack-stack-1.9.3/envs/ue-oneapi-2024.2.1

# load modules
module purge
module use $SPACK_STACK_INTEL_ENV/install/modulefiles/Core
module load stack-oneapi/2024.2.1
module load stack-intel-oneapi-mpi/2021.13
module load stack-python/3.11.7

module load singularity

# This is a fix for the issue where a handful of spack-stack-1.9.1
# oneapi modules (eg, py-scipy) were not being found because
# these modules were being built with the gcc compilers instead
# of the oneapi compilers.
export LMOD_TMOD_FIND_FIRST=yes
module use $SPACK_STACK_INTEL_ENV/install/modulefiles/gcc/12.2.0
