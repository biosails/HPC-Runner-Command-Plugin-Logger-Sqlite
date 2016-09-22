package HPC::Runner::Command::execute_job::Plugin::Logger::Sqlite;

use Moose::Role;
use Data::Dumper;
use DateTime;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite';

=head1 HPC::Runner::Command::execute_job::Plugin::Logger::Sqlite;

=cut

=head2 Attributes

=cut

=head3 job_id

This is the ID for the hpcrunner.pl execute_job

=cut

has 'job_id' => (
    is        => 'rw',
    isa       => 'Str|Int',
    lazy      => 1,
    default   => '',
    predicate => 'has_job_id',
    clearer   => 'clear_job_id'
);

=head2 Subroutines

=cut

=head3 after log_table

Log the table data to the sqlite DB

Each start, stop time for the whole batch gets logged

Each start, stop time for each task gets logged

=cut

#$sql =<<EOF;
#CREATE TABLE IF NOT EXISTS jobs (
#jobs_pi INTEGER PRIMARY KEY NOT NULL,
#submission_id integer NOT NULL,
#start_time varchar(20) NOT NULL,
#exit_time varchar(20) NOT NULL,
#jobs_meta text,

##TODO Add Moose object with starttime, endtime, duration

around 'run_mce' => sub {
    my $orig = shift;
    my $self = shift;

    $self->deploy_schema;

    my $dt1        = DateTime->now( time_zone => 'local' );
    my $ymd        = $dt1->ymd();
    my $hms        = $dt1->hms();
    my $start_time = "$ymd $hms";

    my $res = $self->schema->resultset('Job')->create(
        {   submission_fk    => $self->submission_id,
            start_time       => $start_time,
            exit_time        => $start_time,
            job_scheduler_id => $self->job_scheduler_id,
            jobs_meta => $self->metastr,
        }
    );

    my $id = $res->job_pi;
    $self->job_id( $id );

    $self->$orig(@_);

    my $dt2 = DateTime->now( time_zone => 'local' );
    $ymd = $dt2->ymd();
    $hms = $dt2->hms();
    my $end_time = "$ymd $hms";
    my $duration = $dt2 - $dt1;
    my $format
        = DateTime::Format::Duration->new( pattern =>
            '%Y years, %m months, %e days, %H hours, %M minutes, %S seconds'
        );

    $duration = $format->format_duration($duration);

    $res->update( { exit_time => $end_time, duration => $duration } );
};

#tasks_pi INTEGER PRIMARY KEY NOT NULL,
#job_pi integer NOT NULL,
#pid integer NOT NULL,
#start_time text NOT NULL,
#exit_time text NOT NULL,
#duration text NOT NULL,
#exit_code integer NOT NULL,
#tasks_meta text,
#job_tags text,

#$VAR1 = {
#'job_tags' => 'hello, world',
#'duration' => '0 years, 00 months, 0 days, 00 hours, 00 minutes, 05 seconds',
#'schedulerid' => '1234',
#'jobname' => 'job',
#'exitcode' => 0,
#'cmdpid' => 15228,
#'exit_time' => '2016-08-09 12:06:57'
#};

#after 'log_table' => sub {
    #my $self = shift;
#};

around 'log_table' => sub {
    my $orig = shift;
    my $self = shift;

    $self->$orig(@_);

    #job_tags => $self->table_data->{job_tags}

    my $res = $self->schema->resultset('Task')->create({
        job_fk => $self->job_id,
        pid => $self->table_data->{cmdpid},
        start_time => $self->table_data->{start_time},
        exit_time => $self->table_data->{exit_time},
        duration => $self->table_data->{duration},
        exit_code => $self->table_data->{exitcode},
    });
};

1;
