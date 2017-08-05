package HPC::Runner::Command::stats::Logger::Sqlite::Summary::TableOutput;

use Moose::Role;
use namespace::autoclean;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite';
with 'HPC::Runner::Command::stats::Logger::Sqlite::TableOutput';
with 'HPC::Runner::Command::stats::Logger::JSON::TableOutput';

use JSON;
use Try::Tiny;

sub iter_submissions {
    my $self = shift;

    my $results_pass = $self->build_query;

    while ( my $res = $results_pass->next ) {

        my $table = $self->build_table( $res, $res->{submission_pi} );
        my $submission_meta;
        $submission_meta = $res->{submission_meta};
        if ($submission_meta) {
            $submission_meta = decode_json($submission_meta);
        }
        else {
            $submission_meta = {};
        }

        my $schedule;
        $schedule = $submission_meta->{schedule}
          if exists $submission_meta->{schedule};

        $self->set_task_data($submission_meta) if $submission_meta;

        $table->setCols(
            [ 'JobName', 'Complete', 'Running', 'Success', 'Fail', 'Total' ] );

        map { $self->iter_tasks_summary($_) } @{ $res->{tasks} };

        $table = $self->add_table_no_schedule($table) unless $schedule;
        $table = $self->add_table_with_schedule( $table, $schedule )
          if $schedule;

        $self->task_data( {} );
        print $table;
        print "\n";
    }
}

sub add_table_no_schedule {
    my $self  = shift;
    my $table = shift;

    while ( my ( $k, $v ) = each %{ $self->task_data } ) {
        $table->addRow(
            [
                $k,
                $self->task_data->{$k}->{complete},
                $self->task_data->{$k}->{running},
                $self->task_data->{$k}->{success},
                $self->task_data->{$k}->{fail},
                $self->task_data->{$k}->{total},
            ]
        );
    }

    return $table;
}

sub set_task_data {
    my $self            = shift;
    my $submission_meta = shift;

    my $jobs = $submission_meta->{jobs};
    return unless $jobs;

    foreach my $job ( @{$jobs} ) {
        next if exists $self->task_data->{ $job->{job} };
        my $total_tasks = $job->{total_tasks};
        $self->task_data->{ $job->{job} } = {
            complete => 0,
            success  => 0,
            fail     => 0,
            total    => $total_tasks,
            running  => 0
        };
    }
}

sub add_table_with_schedule {
    my $self     = shift;
    my $table    = shift;
    my $schedule = shift;

    foreach my $k ( @{$schedule} ) {
        $table->addRow(
            [
                $k,
                $self->task_data->{$k}->{complete},
                $self->task_data->{$k}->{running},
                $self->task_data->{$k}->{success},
                $self->task_data->{$k}->{fail},
                $self->task_data->{$k}->{total},
            ]
        );
    }

    return $table;
}

sub iter_tasks_summary {
    my $self     = shift;
    my $task     = shift;

    my $job_name = $task->{jobname};

    if ( $self->task_is_running($task) ) {
        $self->task_data->{$job_name}->{running} += 1;
    }
    else {
        $self->task_data->{$job_name}->{complete} += 1;
        if ( $self->task_is_success($task) ) {
            $self->task_data->{$job_name}->{success} += 1;
        }
        else {
            $self->task_data->{$job_name}->{fail} += 1;
        }
    }
}

sub task_is_running {
    my $self = shift;
    my $task = shift;

    if ( !defined $task->{exit_code} ) {
        return 1;
    }
    else {
        return 0;
    }
}

sub task_is_success {
    my $self = shift;
    my $task = shift;

    if ( $task->{exit_code} == 0 ) {
        return 1;
    }
    else {
        return 0;
    }
}

1;
