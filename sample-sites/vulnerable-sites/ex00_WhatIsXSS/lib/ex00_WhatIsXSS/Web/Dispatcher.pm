package ex00_WhatIsXSS::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my $c = shift;
    return $c->render('index.tx', {
    });
};

get '/status' => sub {
    my $c = shift;
    my $uid  = $c->req->param('uid');
    return $c->render('status.tx', {
        uid => $uid,
    });
};


1;
