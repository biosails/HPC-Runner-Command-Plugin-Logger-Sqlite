use utf8;
package HPC::Runner::Command::Plugin::Logger::Sqlite::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HPC::Runner::Command::Plugin::Logger::Sqlite::Schema::Result::Task

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tasks>

=cut

__PACKAGE__->table("tasks");

=head1 ACCESSORS

=head2 task_pi

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 submission_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 job_scheduler_id

  data_type: 'text'
  is_nullable: 1

=head2 hostname

  data_type: 'text'
  is_nullable: 1

=head2 jobname

  data_type: 'text'
  is_nullable: 1

=head2 pid

  data_type: 'integer'
  is_nullable: 0

=head2 start_time

  data_type: 'text'
  is_nullable: 0

=head2 exit_time

  data_type: 'text'
  is_nullable: 1

=head2 duration

  data_type: 'text'
  is_nullable: 1

=head2 exit_code

  data_type: 'integer'
  is_nullable: 1

=head2 tasks_meta

  data_type: 'text'
  is_nullable: 1

=head2 task_tags

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "task_pi",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "submission_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "job_scheduler_id",
  { data_type => "text", is_nullable => 1 },
  "hostname",
  { data_type => "text", is_nullable => 1 },
  "jobname",
  { data_type => "text", is_nullable => 1 },
  "pid",
  { data_type => "integer", is_nullable => 0 },
  "start_time",
  { data_type => "text", is_nullable => 0 },
  "exit_time",
  { data_type => "text", is_nullable => 1 },
  "duration",
  { data_type => "text", is_nullable => 1 },
  "exit_code",
  { data_type => "integer", is_nullable => 1 },
  "tasks_meta",
  { data_type => "text", is_nullable => 1 },
  "task_tags",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</task_pi>

=back

=cut

__PACKAGE__->set_primary_key("task_pi");

=head1 RELATIONS

=head2 submission_fk

Type: belongs_to

Related object: L<HPC::Runner::Command::Plugin::Logger::Sqlite::Schema::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission_fk",
  "HPC::Runner::Command::Plugin::Logger::Sqlite::Schema::Result::Submission",
  { submission_pi => "submission_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2017-08-03 23:05:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lUpi9P9BiFtkcxeG9Lmc/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
