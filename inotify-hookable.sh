#!/usr/bin/env bash

RSYNC="rsync -avz ../HPC-Runner-Command-Plugin-Logger-Sqlite gencore@dalma.abudhabi.nyu.edu:/home/gencore/hpcrunner-test/"

inotify-hookable \
    --watch-directories /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command/lib/  \
    --watch-directories /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command/t/lib/TestsFor/  \
    --watch-directories lib \
    --watch-directories t/lib/TestsFor/ \
    --on-modify-command "${RSYNC}; prove -l -v t/test_class_tests.t"
