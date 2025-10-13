#!/usr/bin/env bash
topdir=$1
platform=$2
compiler=$3

export VIND_BUILD=$topdir/vind-bundle/build
modules_setup_script=$topdir/modulefiles/setup_${platform}_${compiler}.sh

if [ -f $modules_setup_script ]; then
    echo "Load modules with $modules_setup_script"
    source $modules_setup_script
else
    echo "$modules_setup_script is not available for $platform and $compiler"
fi

module load jedi-fv3-env
module load ewok-env
module load metplus
module load nco

[ $(declare -f -F jedi-host-post-load) ] && jedi-host-post-load; unset -f jedi-host-post-load || echo "No post-load procedures"

if [ -s $topdir/venv/bin/activate ]; then
    source $topdir/venv/bin/activate
else
    echo "Create $topdir/venv"
    python3 -m venv $topdir/venv
    source $topdir/venv/bin/activate
fi

# Add ioda python bindings to PYTHONPATH
PYTHON_VERSION=`python3 -c 'import sys; version=sys.version_info[:2]; print("{0}.{1}".format(*version))'`
export PYTHONPATH="${VIND_BUILD}/lib/python${PYTHON_VERSION}:${PYTHONPATH}"
