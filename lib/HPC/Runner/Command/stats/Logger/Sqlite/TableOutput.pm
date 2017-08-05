package HPC::Runner::Command::stats::Logger::Sqlite::TableOutput;

use Moose::Role;
use namespace::autoclean;

sub build_query {
    my $self = shift;

    # $self->schema->storage->debug(1);
    my $where = {};
    if ( $self->has_project ) {
        $where->{project} = $self->project;
    }
    if ( $self->has_jobname ) {
        $where->{'jobs.job_name'} = $self->jobname;
    }

    my $results_pass = $self->schema->resultset('Submission')->search(
        $where,
        {
            join     => 'tasks',
            prefetch => 'tasks',
            group_by => [ 'project', ],
            order_by => { '-desc' => 'submission_pi', },
        }
    );

    $results_pass->result_class('DBIx::Class::ResultClass::HashRefInflator');
    return $results_pass;
}

1;
