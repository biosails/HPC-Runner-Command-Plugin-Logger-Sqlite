package HPC::Runner::Command::submit_jobs::Plugin::Logger::Sqlite;

use Moose::Role;
use JSON::XS;
use File::Spec;
use Cwd;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite';
with 'HPC::Runner::Command::Logger::Loggers';

=head1 HPC::Runner::Command::submit_jobs::Plugin::Logger::Sqlite;

=cut

=head2 Attributes

=cut

=head2 Subroutines

=cut

around 'create_json_submission' => sub {
    my $orig = shift;
    my $self = shift;

    my $hpc_meta  = $self->$orig(@_);

    $self->deploy_schema_with_lock;
    my $lock_file = $self->sqlite_set_lock;

    my $submission_obj = {
        submission_time => $hpc_meta->{submission_time},
        total_processes => 0,
        total_batches   => 0,
    };

    $submission_obj->{project} = $self->project if $self->has_project;
    my $res = $self->schema->resultset('Submission')->create($submission_obj);
    $self->submission_obj($res);
    my $id = $res->submission_pi;

    $self->screen_log->info( 'Saving to sqlite db as submission id : ' . $id );

    ##TODO This should be sqlite_submission_id
    $self->sqlite_submission_id($id);

    $self->lock_file->remove;
    $self->lock_file($lock_file);

    return $hpc_meta;
};

around 'update_json_submission' => sub {
    my $orig = shift;
    my $self = shift;

    my $lock_file = $self->sqlite_set_lock;

    my $hpc_meta  = $self->$orig(@_);
    my $json_text = encode_json $hpc_meta;

    $self->submission_obj->update(
        {
            submission_meta => $json_text,
            total_processes => $self->job_stats->total_processes,
            total_batches   => $self->job_stats->total_batches,
        }
    );

    $self->lock_file->remove;
    $self->lock_file($lock_file);
};

around 'create_plugin_str' => sub {
    my $orig = shift;
    my $self = shift;

    $self->job_plugins( [] ) unless $self->job_plugins;
    $self->job_plugins_opts( {} ) unless $self->job_plugins_opts;

    push( @{ $self->job_plugins }, 'Logger::Sqlite' );
    $self->job_plugins_opts->{sqlite_submission_id} =
      $self->sqlite_submission_id;
    my $val = $self->$orig(@_);

    return $val;
};


1;
