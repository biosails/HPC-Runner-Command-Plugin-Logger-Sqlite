package HPC::Runner::Command::stats::Logger::Sqlite::Long::TableOutput;

use Moose::Role;
use namespace::autoclean;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite';
with 'HPC::Runner::Command::stats::Logger::Sqlite::TableOutput';
with 'HPC::Runner::Command::stats::Logger::JSON::TableOutput';

use JSON;
use Text::ASCIITable;

sub iter_submissions {
    my $self = shift;

    my $results_pass = $self->build_query;

    while ( my $res = $results_pass->next ) {

        my $table = $self->build_table($res);
        $table->setCols(
            [
                'JobName',
                'Task Tags',
                'Start Time',
                'End Time',
                'Duration',
                'Exit Code'
            ]
        );

        map { $self->iter_tasks_long($_) } @{ $res->{tasks} };
        while ( my ( $k, $v ) = each %{ $self->task_data } ) {
            foreach my $h ( @{$v} ) {
                $table->addRow(
                    [
                        $k,             $h->{task_tags}, $h->{start_time},
                        $h->{end_time}, $h->{duration},  $h->{exit_code}
                    ]
                );
            }
            $table->addRowLine;
        }
        $self->task_data( {} );
        print $table;
        print "\n";
    }
}

sub iter_tasks_long {
    my $self    = shift;
    my $task    = shift;

    my $jobname = $task->{jobname};
    if ( !exists $self->task_data->{ $jobname } ) {
        $self->task_data->{ $jobname } = [];
    }

    my $exit_code = $task->{exit_code};
    $exit_code = "" if !defined $exit_code;

    push(
        @{ $self->task_data->{$jobname} },
        {
            'start_time' => $task->{start_time} || "",
            'end_time'   => $task->{exit_time}  || "",
            'task_tags'  => $task->{task_tags}  || "",
            'duration'   => $task->{duration}   || "",
            'exit_code'  => $exit_code,
        }
    );
}

1;
