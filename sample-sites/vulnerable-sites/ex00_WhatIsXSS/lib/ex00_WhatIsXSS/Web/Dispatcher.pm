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

post '/confirm' => sub {
    my $c = shift;
    my $uid  = $c->req->param('uid');
    my $pass = $c->req->param('pass');
    
    my $sid = "";
    eval {
        # my $sid = uid, pass をDBから引いて，OKならcurrent_sidカラムを設定しつつそのsidを返す
        $sid = "atode_nantoka_uid_${uid}_kara";
    };
    if($@) {
        # login failed
        return $c->redirect("/");
    }
    return $c->redirect("/login?sid=$sid");
};

get '/login' => sub {
    my $c = shift;
    my $sid = $c->req->param('sid');
    # my $uid = sidからuidをDBでひく
    my $uid = "sid_${sid}_kara_db_hiku";
    return $c->render('login.tx', {
        uid => $uid,
    });
};

get '/status' => sub {
    my $c = shift;
    my $uid  = $c->req->param('uid');
    print "uid = $uid\n";
    return $c->render('status.tx', {
        uid => $uid,
    });
};


1;
