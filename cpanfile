requires 'perl', '5.008005';

requires 'Cwd',                 '0';
requires 'DBIx::Class::Core',   '0';
requires 'DBIx::Class::Schema', '0';
requires 'Data::Dumper',        '0';
requires 'DateTime',            '0';
requires 'JSON::XS',            '0';
requires 'Moose::Role',         '0';
requires 'HPC::Runner',         '0';

on test => sub {
    requires 'Capture::Tiny',              '0';
    requires 'File::Path',                 '0';
    requires 'File::Slurp',                '0';
    requires 'FindBin',                    '0';
    requires 'HPC::Runner::Command',       '0';
    requires 'IPC::Cmd',                   '0';
    requires 'Slurp',                      '0';
    requires 'Test::Class::Moose',         '0';
    requires 'Test::Class::Moose::Load',   '0';
    requires 'Test::Class::Moose::Runner', '0';
    requires 'Test::More',                 '0';
};
