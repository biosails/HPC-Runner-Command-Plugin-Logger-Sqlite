#!/bin/bash

hpcrunner.pl execute_job --infile t/test001/script/test001.1.sh --job_plugins Logger::Sqlite --job_plugins_opts submission_id=1
