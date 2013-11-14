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
        my @row = @{$c->dbh->selectall_arrayref(
            "select sid from users where uid='$uid' and pass='$pass'"  # SQLインジェクション...
        )};
        $#row + 1 == 1 or die;
        $sid = $row[0][0];
    };
    if ($@) {
        # login failed
        print "Login request from $uid failed: $@\n";
        return $c->redirect("/");
    }
    return $c->redirect("/login?sid=$sid");
};

get '/login' => sub {
    my $c = shift;
    my $sid = $c->req->param('sid');
    my $uid = "";
    eval {
        my @row = @{$c->dbh->selectall_arrayref(
            "select uid from users where sid='$sid'"  # SQLインジェクション...
        )};
        $#row + 1 == 1 or die;
        $uid = $row[0][0];
    };
    if ($@) {
        # login failed
        print "Login request with $sid failed: $@\n";
        return $c->redirect("/");
    }
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
