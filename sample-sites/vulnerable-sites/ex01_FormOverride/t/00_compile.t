use strict;
use warnings;
use Test::More;


use ex01_FormOverride;
use ex01_FormOverride::Web;
use ex01_FormOverride::Web::View;
use ex01_FormOverride::Web::ViewFunctions;

use ex01_FormOverride::DB::Schema;
use ex01_FormOverride::Web::Dispatcher;


pass "All modules can load.";

done_testing;
