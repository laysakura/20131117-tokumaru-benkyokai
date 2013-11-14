package ex00_WhatIsXSS;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.008001;
use DBI;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();

sub dbh {
    my $c = shift;
    if (!exists $c->{dbh}) {
        my $conf = $c->config->{DBI}
            or die "Missing configuration about DBI";
        $c->{dbh} = DBI->connect(@{$conf});
    }
    $c->{dbh};
}


1;
__END__

=head1 NAME

ex00_WhatIsXSS - ex00_WhatIsXSS

=head1 DESCRIPTION

This is a main context class for ex00_WhatIsXSS

=head1 AUTHOR

ex00_WhatIsXSS authors.

