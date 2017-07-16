#!/bin/bash

PWD=`pwd`
TESTDIR='/tmp/hpcrunner-sqlite'

rm -rf $TESTDIR
mkdir -p $TESTDIR
cp t/test001/script/test001.1.sh $TESTDIR
cp t/test001/.hpcrunner.yml $TESTDIR

cd $TESTDIR
perl  `which hpcrunner.pl` submit_jobs --infile test001.1.sh --use_batches --hpc_plugins Dummy,Logger::Sqlite --hpc_plugins_opts cleandb=1 --project 'MYPROJECT'
#find /tmp/hpcrunner-sqlite/hpc-runner/MYPROJECT/scratch/ -name "*.sh" | xargs -I {} bash {}
tree hpc-runner

#cd $TESTDIR
#perl  `which hpcrunner.pl` submit_jobs --infile test001.1.sh --use_batches --hpc_plugins Dummy,Logger::Sqlite  --project 'MY_NEW_PROJECT'
#tree hpc-runner/MY_NEW_PROJECT
##find /tmp/hpcrunner-sqlite/hpc-runner/MY_NEW_PROJECT/scratch/ -name "*.sh" | xargs -I {} bash {}
#
#cd $PWD
