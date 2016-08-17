#!/bin/bash
#
#SBATCH --share
#SBATCH --get-user-env
#SBATCH --job-name=001_hpcjob_001
#SBATCH --output=/home/jillian/Dropbox/projects/perl/HPC-Runner-Command-Plugin-Logger-Sqlite/t/test001/hpc-runner/logs/2016-08-17-slurm_logs/001_hpcjob_001.log
#SBATCH --cpus-per-task=12

cd /home/jillian/Dropbox/projects/perl/HPC-Runner-Command-Plugin-Logger-Sqlite/t/test001
hpcrunner.pl execute_job \
	--procs 4 \
	--infile /home/jillian/Dropbox/projects/perl/HPC-Runner-Command-Plugin-Logger-Sqlite/t/test001/hpc-runner/scratch/001_hpcjob_001.in \
	--outdir /home/jillian/Dropbox/projects/perl/HPC-Runner-Command-Plugin-Logger-Sqlite/t/test001/hpc-runner/scratch \
	--logname 001_hpcjob_001 \
	--process_table /home/jillian/Dropbox/projects/perl/HPC-Runner-Command-Plugin-Logger-Sqlite/t/test001/hpc-runner/logs/2016-08-17-slurm_logs/001-process_table.md \
	--metastr '{"total_batches":1,"tally_commands":"1-4/4","batch_index":"1/1","commands":4,"jobname":"hpcjob_001","total_processes":4,"batch":"001"}' \
	--job_plugins HPC::Runner::Command::execute_job::Plugin::Logger::Sqlite \
	--job_plugins_opts submission_id=1