package ex01_FormOverride::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
    my $name   = $c->req->param('name');
    my $credit = $c->req->param('credit');
    return $c->render('index.tx', {
        name   => $name,
        credit => $credit,
    });
};


1;
