#!/usr/bin/perl 

use strict;
use warnings;

use lib "./lib";
use WebService::Hatena::Bookmark;

use Data::Dumper;

my $user = shift;
my $pass = shift;
my $url  = 'http://www.google.co.jp';
my @tag  = ('hoge','moge');
my $com  = 'tetetetetst';

my $bookmark = WebService::Hatena::Bookmark->new(
    username => $user,
    password => $pass,
);

$bookmark->add(
    url      => $url ,
    tag      => \@tag,
    comment  => $com,
);

#$bookmark->edit(
#    url      => $url ,
#    tag      => \@tag,
#    comment  => $com,
#);



exit;
