package HPC::Runner::Command::execute_job::Plugin::Logger::Sqlite;

use Moose::Role;
use Data::Dumper;
use DateTime;
use JSON;

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

around 'create_json_task' => sub {
    my $orig = shift;
    my $self = shift;

    ##TODO This should go in Build

    $self->deploy_schema_with_lock;
    my $task_obj = $self->$orig(@_);

    my $lock_file = $self->sqlite_set_lock;
    my $res      = $self->schema->resultset('Task')->create(
        {
            submission_fk => $self->sqlite_submission_id,
            pid           => $task_obj->{pid},
            start_time    => $task_obj->{start_time},
            # task_id       => $task_obj->{task_id},
            jobname       => $task_obj->{jobname},
            hostname      => $self->hostname,
        }
    );
    $self->submission_obj($res);

    $self->lock_file->remove;
    $self->lock_file($lock_file);

    return $task_obj;
};

around 'update_json_task' => sub {
    my $orig = shift;
    my $self = shift;

    my $task_obj  = $self->$orig(@_);

    my $lock_file = $self->sqlite_set_lock;
    $self->submission_obj->update(
        {
            exit_time => $task_obj->{exit_time},
            duration  => $task_obj->{duration},
            exit_code => $task_obj->{exit_code},
            task_tags => $task_obj->{task_tags},
        }
    );

    $self->lock_file->remove;
    $self->lock_file($lock_file);

    return $task_obj;
};

1;
