package HPC::Runner::Command::Plugin::Logger::Sqlite;

use Moose::Role;

=head1 HPC::Runner::Command::Plugin::Logger::Sqlite;

This is just a dummy to use for testing

=cut

=head2 Subroutines

=cut

after 'job_load_plugins' => sub {
    my $self = shift;
    print "WHEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe!";
};

=head2 Variables

=cut



1;
