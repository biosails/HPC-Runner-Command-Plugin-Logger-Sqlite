package TestsFor::HPC::Runner::Command::Plugin::Test001;

use Test::Class::Moose;
use HPC::Runner::Command;
use Cwd;
use FindBin qw($Bin);
use File::Path qw(make_path remove_tree);
use IPC::Cmd qw[can_run];
use Data::Dumper;
use Capture::Tiny ':all';
use Slurp;
use File::Slurp;

sub construct_001 {

    chdir("$Bin/test001");
    my $t = "$Bin/test001/script/test001.1.sh";
    MooseX::App::ParsedArgv->new(
        argv => [
            "execute_job",       "--infile",
            $t,                  "--job_plugins",
            "Logger::Sqlite",    "--job_plugins_opts",
            "submission_id=1"
        ]
    );

    my $test = HPC::Runner::Command->new_with_command();
    $test->logname('slurm_logs');
    #$test->log( $test->init_log );
    return $test;
}

sub construct_002 {

    chdir("$Bin/test001");
    my $t = "$Bin/test001/script/test001.1.sh";
    MooseX::App::ParsedArgv->new(
        argv => [
            "submit_jobs",          "--infile",
            $t,                     "--hpc_plugins",
            "Dummy,Logger::Sqlite", "--hpc_plugins_opts",
            "clean_db=1"
        ]
    );

    my $test = HPC::Runner::Command->new_with_command();
    $test->logname('slurm_logs');
    #$test->log( $test->init_log );
    return $test;
}

sub test_001 : Tags(prep) {
    my $test = shift;

    remove_tree("$Bin/test001");
    make_path("$Bin/test001/script");
    #make_path("$Bin/test001/scratch");
    my $p =<<EOF;
#!/bin/bash
#
#SBATCH --share
#SBATCH --get-user-env
#SBATCH --job-name=001_job01
#SBATCH --output=$Bin/logs/2016-08-14-slurm_logs/001_job01.log
#SBATCH --cpus-per-task=12

cd $Bin/test001
hpcrunner.pl execute_job \
	--procs 4 \
	--infile $Bin/test001/scratch/001_job01.in \
	--outdir $Bin/test001/scratch \
	--logname 001_job01 \
	--process_table $Bin/test001/logs/2016-08-14-slurm_logs/001-process_table.md \
	--metastr '{"total_batches":3,"tally_commands":"1-1/3","batch_index":"1/3","jobname":"job01","batch":"001","total_processes":3,"commands":1}'
EOF
    ok(1);
}



sub test_002 : Tags(prep) {
    my $test = shift;

    open( my $fh, ">$Bin/test001/script/test001.1.sh" );
    print $fh <<EOF;
echo "hello world from job 1" && sleep 5

echo "hello again from job 2" && sleep 5

echo "goodbye from job 3"

#NOTE job_tags=hello,world
echo "hello again from job 3" && sleep 5

EOF

    close($fh);

    ok(1);
}

sub test_003 : Tags(submit_jobs) {
    my $test = construct_002();

    $test->gen_load_plugins();

    $test->execute();

    try_submission_ids($test);
    try_plugin_strings($test);
}

sub try_submission_ids {
    my $test = shift;

    my $results = $test->schema->resultset('Submission')->search();

    #while ( my $res = $results->next ) {
        #print "submitted " . $res->submission_pi . "\n";
        #print "total_processes " . $res->total_processes . "\n";
        #print "job_stats " . $res->submission_meta . "\n";
    #}

    is( $test->submission_id, 1, "Submit jobs submission id matches" );
}

sub try_plugin_strings {
    my $test = shift;

    my $plugin_str = $test->create_plugin_str;

    my $expect1
        = "--job_plugins HPC::Runner::Command::execute_job::Plugin::Logger::Sqlite";
    my $expect2 = "--job_plugins_opts submission_id=1";

    like( $plugin_str, qr/$expect1/, 'Plugin string matches' );
    like( $plugin_str, qr/$expect2/, 'Plugin opts matches' );
}

sub test_005 : Tags(execute_jobs) {

    $ENV{SBATCH_JOB_ID} = '1234';

    my $test = construct_001();

    $test->gen_load_plugins();

    $test->execute();

    populate_jobs($test);
    populate_tasks($test);
    #I don't do any actual tests here - just want to make sure it all works
    #query_related($test);
}

sub populate_jobs {
    my $test = shift;

    is( $test->submission_id, 1, 'Execute jobs submission id matches' );

    my $results = $test->schema->resultset('Job')->search();

    #while ( my $res = $results->next ) {
        #print "jobs_pi " . $res->job_pi . "\n";
        #print "start_time " . $res->start_time . "\n";
        #print "end_time " . $res->exit_time. "\n";
    #}

    is( $results->count, 1, "Correct number of jobs" );
    ok(1);
}

sub populate_tasks {
    my $test = shift;

    my $results = $test->schema->resultset('Task')->search();

    #while ( my $res = $results->next ) {
        #print "tasks_pi " . $res->task_pi . "\n";
        #print "job_fk " . $res->job_fk . "\n";
        #print "cmdpid " . $res->pid . "\n";
        #print "start_time " . $res->start_time . "\n";
        #print "exit_time " . $res->exit_time. "\n";
        #print "exit_code " . $res->exit_code. "\n";
    #}

    is( $results->count, 4, "Correct number of tasks" );
    ok(1);
}

sub query_related {
    my $test = shift;

    $ENV{DBIC_TRACE} = 1;

    $test->schema->storage->debug(1);

    my $results = $test->schema->resultset('Submission')
        ->search( {}, { 'prefetch' => { jobs => 'tasks' } } );

    $results->result_class('DBIx::Class::ResultClass::HashRefInflator');

    while ( my $res = $results->next ) {
        #print Dumper($res);
    }

    ok(1);
}

1;
