package HPC::Runner::Command::Plugin::Logger::Sqlite;

our $VERSION = '0.0.4';

use Moose::Role;

use HPC::Runner::Command::Plugin::Logger::Sqlite::Schema;
use Data::Dumper;
use Cwd;
use Log::Log4perl qw(:easy);
use File::Spec;

with 'HPC::Runner::Command::Plugin::Logger::Sqlite::Deploy';
with 'HPC::Runner::Command::Logger::JSON';
with 'HPC::Runner::Command::execute_job::Logger::Lock';

=head1 HPC::Runner::Command::Plugin::Logger::Sqlite;

Base class for HPC::Runner::Command::submit_jobs::Plugin::Logger::Sqlite and
HPC::Runner::Command::execute_job::Plugin::Sqlite

=cut

=head2 Attributes

=cut

has 'submission_obj' => ( is => 'rw', );

=head3 schema

Sqlite3 Schema Object

=cut

has 'schema' => (
    is      => 'rw',
    default => sub {
        my $self = shift;
        my $schema =
          HPC::Runner::Command::Plugin::Logger::Sqlite::Schema->connect(
            'dbi:SQLite:' . $self->db_file );
        return $schema;
    },
    lazy => 1,
);

=head3 db_file

Path to sqlite3 db file. If the file doesn't exist sqlite3 will create it.

=cut

has 'db_file' => (
    is       => 'rw',
    lazy     => 1,
    required => 0,
    default  => sub {
        my $cwd = getcwd();
        return File::Spec->catdir( $cwd,
            "hpc-runner-command-plugin-logger-sqlite.db" );
    },
);

=head3 submission_id

This is the ID for the entire hpcrunner.pl submit_jobs submission, not the individual scheduler IDs

=cut

has 'sqlite_submission_id' => (
    is        => 'rw',
    isa       => 'Str|Int',
    lazy      => 1,
    default   => '',
    predicate => 'has_sqlite_submission_id',
    clearer   => 'clear_sqlite_submission_id'
);

=head2 Subroutines

=cut

sub sqlite_set_lock {
    my $self      = shift;

    my $lock_file = $self->lock_file;
    my $cwd       = getcwd();
    my $new_lock =
      File::Spec->catdir( $cwd, '.hpcrunner-data', '.sqlite-lock' );

    $self->lock_file($new_lock);

    $self->check_lock;
    $self->write_lock;

    return $lock_file;
}

1;

__END__

=encoding utf-8

=head1 NAME

HPC::Runner::Command::Plugin::Sqlite - Log HPC::Runner workflows to a sqlite DB.

=head1 SYNOPSIS

To submit jobs to a cluster

    hpcrunner.pl submit_jobs --hpc_plugins Logger::Sqlite

To execute jobs on a single node

    hpcrunner.pl execute_jobs --job_plugins Logger::Sqlite

Generate a summary report

  hpcrunner.pl stats
  hpcrunner.pl stats sqlite --jobname gatk
  hpcrunner.pl stats sqlite --project Sequencing1
  hpcrunner.pl stats sqlite --project Sequencing1 --jobname gatk_haplotypecaller

Generate a longer report

  hpcrunner.pl stats sqlite
  hpcrunner.pl stats sqlite --long/-l --jobname gatk
  hpcrunner.pl stats sqlite --long/-l --project Sequencing1
  hpcrunner.pl stats sqlite --long/-l --project Sequencing1 --jobname gatk_haplotypecaller


=head1 DESCRIPTION

HPC::Runner::Command::Plugin::Sqlite - Log HPC::Runner workflows to a sqlite DB.

This plugin requires sqlite3 in the path.

=head1 AUTHOR

Jillian Rowe E<lt>jillian.e.rowe@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2016- Jillian Rowe

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
