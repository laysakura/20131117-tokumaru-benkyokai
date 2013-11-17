package ex01_FormOverride::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'ex01_FormOverride::DB::Row';

table {
    name 'member';
    pk 'id';
    columns qw(id name);
};

1;
