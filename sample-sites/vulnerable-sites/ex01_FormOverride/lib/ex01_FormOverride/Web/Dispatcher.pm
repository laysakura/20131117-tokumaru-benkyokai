package ex01_FormOverride::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
    my $name  = $c->req->param('name');
    my $email = $c->req->param('email');
    return $c->render('index.tx', {
        name  => $name,
        email => $email,
    });
};

post '/register' => sub {
    my ($c) = @_;
    return $c->render('register.tx', {
    });
};

1;
