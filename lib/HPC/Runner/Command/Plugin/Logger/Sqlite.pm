package HPC::Runner::Command::Plugin::Logger::Sqlite;

use Moose::Role;

use HPC::Runner::Command::Plugin::Logger::Sqlite::Schema;
use Data::Dumper;
use Cwd;
use MooseX::Types::Path::Tiny qw/Path Paths AbsPath AbsFile/;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite::Deploy';

=head1 HPC::Runner::Command::Plugin::Logger::Sqlite;

Base class for HPC::Runner::Command::submit_jobs::Plugin::Logger::Sqlite and HPC::Runner::Command::execute_job::Plugin::Sqlite

=cut

=head2 Attributes

=cut

=head3 schema

Sqlite3 Schema Object

=cut

has 'schema' => (
    is      => 'rw',
    default => sub {
        my $self = shift;
        my $schema
            = HPC::Runner::Command::Plugin::Logger::Sqlite::Schema->connect(
            'dbi:SQLite:' . $self->db_file );
        return $schema;
    },
    lazy => 1,
);

=head3 db_file

Path to sqlite3 db file. If the file doesn't exist sqlite3 will create it.

=cut

has 'db_file' => (
    is      => 'rw',
    default => sub {
        my $cwd = getcwd();
        return $cwd . "/hpc-runner-command-plugin-logger-sqlite.db";
    },
    isa    => AbsFile,
    coerce => 1,
);

=head3 submission_id

This is the ID for the entire hpcrunner.pl submit_jobs submission, not the individual scheduler IDs

=cut

has 'submission_id' => (
    is        => 'rw',
    isa       => 'Str|Int',
    lazy      => 1,
    default   => '',
    predicate => 'has_submission_id',
    clearer   => 'clear_submission_id'
);

=head2 Subroutines

=cut

1;
