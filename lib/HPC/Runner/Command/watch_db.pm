package HPC::Runner::Command::watch_db;

use MooseX::App::Command;
use Data::Dumper;
use Log::Log4perl qw(:easy);

extends 'HPC::Runner::Command';

command_short_description 'Watch the sqlitedb';
command_long_description 'Watch the sqlitedb for one or more submission ids';

has 'total_processes' => (
    traits  => ['Number'],
    is      => 'rw',
    isa     => 'Num',
    default => 0,
    handles => {
        set_total_processes => 'set',
        add_total_processes => 'add',
    },
);

option 'exit_on_fail' => (
    traits  => ['Bool'],
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
    documentation => 'Fail if any jobs have an exit code besides 0 - whether all tasks have completed or not',
);

has 'log' => (
    is      => 'rw',
    default => sub {
        my $self = shift;

        Log::Log4perl->init( \ <<'EOT');
  log4perl.category = DEBUG, Screen
  log4perl.appender.Screen = \
      Log::Log4perl::Appender::ScreenColoredLevels
  log4perl.appender.Screen.layout = \
      Log::Log4perl::Layout::PatternLayout
  log4perl.appender.Screen.layout.ConversionPattern = \
      [%d] %m %n
EOT
        return get_logger();
        }

);

sub BUILD {
    my $self = shift;

    $self->gen_load_plugins;
    $self->job_load_plugins;
}

sub execute {
    my $self = shift;

    if($self->submission_id){
        $self->log->info("Watching Submission Id : " . $self->submission_id);
    }
    else{
        $self->log->info("No submission id specified. We will watch the whole database");
    }

    $self->query_submissions;

}

sub query_task {
    my $self    = shift;
    my $task_rs = shift;


    #If exit on fail we don't care if we have completed the number of processes - just fail
    if ($self->exit_on_fail){
        $self->check_exit_code($task_rs);
    }

    if ($task_rs->count != $self->total_processes){
        #We have
        return;
    }
    elsif($task_rs->count == $self->total_processes){
        $self->log->info("We have completed ".$self->total_processes." tasks. Exiting successfully");
        exit 0;
    }

}

sub check_exit_code {
    my $self = shift;
    my $task_rs = shift;

    my $exit_codes = $task_rs->get_column('exit_code');

    while ( my $res = $task_rs->next ) {
        if ($res->exit_code != 0){
            $self->log->error("A task has failed! ".$res->task_pi);
            exit 1;
        }
    }
}

sub query_job {
    my $self   = shift;
    my $job_rs = shift;

    #$job_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    #while ( my $res = $job_rs->next ) {
        #print Dumper($res);
    #}
}

#TODO Add many submissions

sub query_submissions {
    my $self = shift;

    my $results;

    if ($self->submission_id){
        $results = $self->schema->resultset('Submission')
            ->search( { 'submission_pi' => 1 } );
    }
    else{
        $results = $self->schema->resultset('Submission')
            ->search();
    }

    my $jobs  = $results->search_related('jobs');
    my $tasks = $jobs->search_related('tasks');

    while ( my $res = $results->next ) {
        $self->add_total_processes( $res->total_processes );
    }

    $self->query_job($jobs);

    $self->query_task($tasks);

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
