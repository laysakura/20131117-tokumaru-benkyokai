package ex00_WhatIsXSS::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
    my $cookie  = $c->req->param('cookie');
    return $c->render('index.tx', {
        cookie => $cookie,
    });
};

1;
