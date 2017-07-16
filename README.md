# HPC::Runner::Command::Plugin::Logger::Sqlite;

Base class for HPC::Runner::Command::submit\_jobs::Plugin::Logger::Sqlite and HPC::Runner::Command::execute\_job::Plugin::Sqlite

## Attributes

### schema

Sqlite3 Schema Object

### db\_file

Path to sqlite3 db file. If the file doesn't exist sqlite3 will create it.

### submission\_id

This is the ID for the entire hpcrunner.pl submit\_jobs submission, not the individual scheduler IDs

## Subroutines

# NAME

HPC::Runner::Command::Plugin::Sqlite - Log HPC::Runner workflows to a sqlite DB.

# SYNOPSIS

To submit jobs to a cluster

    hpcrunner.pl submit_jobs --hpc_plugins Logger::Sqlite

To execute jobs on a single node

    hpcrunner.pl execute_jobs --job_plugins Logger::Sqlite

Generate a summary report

    hpcrunner.pl stats
    hpcrunner.pl stats --jobname gatk
    hpcrunner.pl stats --project Sequencing1
    hpcrunner.pl stats --project Sequencing1 --jobname gatk_haplotypecaller

Generate a longer report

    hpcrunner.pl stats
    hpcrunner.pl stats --long/-l --jobname gatk
    hpcrunner.pl stats --long/-l --project Sequencing1
    hpcrunner.pl stats --long/-l --project Sequencing1 --jobname gatk_haplotypecaller

# DESCRIPTION

HPC::Runner::Command::Plugin::Sqlite - Log HPC::Runner workflows to a sqlite DB.

This plugin requires sqlite3 in the path.

# AUTHOR

Jillian Rowe <jillian.e.rowe@gmail.com>

# COPYRIGHT

Copyright 2016- Jillian Rowe

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
