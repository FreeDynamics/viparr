set -e -x

export PYTHONPATH=external:$PYTHONPATH
export DESRES_MODULE_CXXFLAGS=$CXXFLAGS
export DESRES_MODULE_CFLAGS=$CFLAGS
export DESRES_MODULE_LDFLAGS=$LDFLAGS

nprocs=`getconf _NPROCESSORS_ONLN`
python_version=$(python -c 'import sys; print("".join(map(str, sys.version_info[:2])))')
$BUILD_PREFIX/bin/scons install -j $nprocs PREFIX=$PREFIX PYTHONVER=$python_version

sitepackage_dir=$(python -c 'import os, sys, site; print(os.path.relpath(site.getsitepackages()[0], sys.exec_prefix))')
mv $PREFIX/lib/python/viparr $PREFIX/$sitepackage_dir/viparr

export PYTHONPATH=$PYTHONPATH:$PREFIX/$sitepackage_dir
$BUILD_PREFIX/bin/pytest test/python_tests.py::TestMain::testViparrParametrizeFragment