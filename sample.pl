#!/usr/bin/perl 

use strict;
use warnings;

use lib "./lib";
use WebService::Hatena::Bookmark::Lite;

use Data::Dumper;

my $user  = shift;
my $pass  = shift;
my $url1  = 'http://www.google.co.jp';
my $url2  = 'http://www.yahoo.co.jp';
my @tag   = ( qw/ hoge moge /);
my $com   = 'tetetetetst';

my $bookmark = WebService::Hatena::Bookmark::Lite->new(
    username => $user,
    password => $pass,
);

$bookmark->add(
    url      => $url1 ,
    tag      => \@tag ,
    comment  => $com  ,
);

$bookmark->add(
    url      => $url2 ,
    tag      => \@tag ,
    comment  => $com  ,
);

@tag = ( qw/ kaka tete /);
$com = 'edit comment';

$bookmark->delete(
    eid      => 12345 ,
);

my $feed = $bookmark->getFeed();
print $feed->as_xml;

exit;
