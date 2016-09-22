#!/bin/bash

hpcrunner.pl submit_jobs --infile t/test001/script/test001.1.sh --hpc_plugins Dummy,Logger::Sqlite --hpc_plugins_opts cleandb=1
hpcrunner.pl execute_job --infile t/test001/script/test001.1.sh --job_plugins Logger::Sqlite --job_plugins_opts submission_id=1
