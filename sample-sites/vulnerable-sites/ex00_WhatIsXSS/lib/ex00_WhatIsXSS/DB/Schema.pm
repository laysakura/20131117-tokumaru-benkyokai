package ex00_WhatIsXSS::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'ex00_WhatIsXSS::DB::Row';

table {
    name 'member';
    pk 'id';
    columns qw(id name);
};

1;
