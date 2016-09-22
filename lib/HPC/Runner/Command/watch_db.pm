package HPC::Runner::Command::watch_db;

use MooseX::App::Command;
use Data::Dumper;

extends 'HPC::Runner::Command';

#with 'HPC::Runner::Command::Utils::Base';
#with 'HPC::Runner::Command::Utils::Log';

command_short_description 'Watch the sqlitedb';
command_long_description 'Watch the sqlitedb for one or more submission ids';

sub BUILD {
    my $self = shift;

    $self->gen_load_plugins;
    $self->job_load_plugins;
}

sub execute {
    my $self = shift;

    print  "Here we are!\n";
    print "Submission Id : ".$self->submission_id."\n";

    $self->query_job;
    #$self->query_related;

}

sub query_task {
    my $self = shift;

    my $results = $self->schema->resultset('Task')->search();

    while ( my $res = $results->next ) {
        #print "tasks_pi " . $res->task_pi . "\n";
        ##print "job_fk " . $res->job_fk . "\n";
        #print "cmdpid " . $res->pid . "\n";
        #print "start_time " . $res->start_time . "\n";
        #print "exit_time " . $res->exit_time. "\n";
        #print "exit_code " . $res->exit_code. "\n";
    }

}

sub query_job {
    my $self = shift;

    my $results = $self->schema->resultset('Job')->search();

    my $related = $results->search_related('submission_fk', {'submission_pi' => 1});

    $related->result_class('DBIx::Class::ResultClass::HashRefInflator');

    while ( my $res = $related->next ) {
        print "Here is a result!\n";
        print Dumper($res);
    }
    return $related;

    #while ( my $res = $results->next ) {
        #print "jobs_pi " . $res->job_pi . "\n";
        #print "start_time " . $res->start_time . "\n";
        #print "end_time " . $res->exit_time. "\n";
    #}

}
sub query_submissions{
    my $self = shift;

    my $results = $self->schema->resultset('Submission')->search();

    #while ( my $res = $results->next ) {
        #print "submitted " . $res->submission_pi . "\n";
        #print "total_processes " . $res->total_processes . "\n";
        #print "job_stats " . $res->submission_meta . "\n";
    #}
    #
}

sub query_related {
    my $self = shift;

    #$ENV{DBIC_TRACE} = 1;

    $self->schema->storage->debug(1);

    my $results = $self->schema->resultset('Submission')
        ->search( {}, { 'prefetch' => { jobs => 'tasks' } } );

    $results->result_class('DBIx::Class::ResultClass::HashRefInflator');

    while ( my $res = $results->next ) {
        print "Here is a result!\n";
        print Dumper($res);
    }

}

1;
