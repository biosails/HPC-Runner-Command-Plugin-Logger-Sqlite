#!/bin/bash
#
#SBATCH --share
#SBATCH --get-user-env
#SBATCH --job-name=001_hpcjob_001
#SBATCH --output=/home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command-Plugin-Logger-Sqlite/hpc-runner/0.05/logs/2016-09-22-hpcrunner_logs/001_hpcjob_001.log
#SBATCH --cpus-per-task=12
#SBATCH --time=04:00:00

cd /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command-Plugin-Logger-Sqlite
hpcrunner.pl execute_job \
	--procs 4 \
	--infile /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command-Plugin-Logger-Sqlite/hpc-runner/0.05/scratch/001_hpcjob_001.in \
	--outdir /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command-Plugin-Logger-Sqlite/hpc-runner/0.05/scratch \
	--logname 001_hpcjob_001 \
	--process_table /home/jillian/Dropbox/projects/HPC-Runner-Libs/New/HPC-Runner-Command-Plugin-Logger-Sqlite/hpc-runner/0.05/logs/2016-09-22-hpcrunner_logs/001-process_table.md \
	--metastr '{"jobname":"hpcjob_001","batch":"001","total_processes":4,"total_batches":1,"commands":4,"tally_commands":"1-4/4","batch_index":"1/1"}' \
	--job_plugins Logger::Sqlite \
	--job_plugins_opts submission_id=1  \
	--version 0.05