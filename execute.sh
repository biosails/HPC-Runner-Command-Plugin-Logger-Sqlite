#!/bin/bash

PWD=`pwd`
TESTDIR='/tmp/hpcrunner-sqlite'

rm -rf $TESTDIR
mkdir -p $TESTDIR
cp t/test001/script/test001.1.sh $TESTDIR

cd $TESTDIR
hpcrunner.pl submit_jobs --infile test001.1.sh --hpc_plugins Dummy,Logger::Sqlite --hpc_plugins_opts cleandb=1
find hpc-runner/scratch/ -name "*.sh" | xargs -I {} bash {}

cd $PWD
