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

### Add
my $entry1 = $bookmark->add(
    url      => $url1 ,
    tag      => \@tag ,
    comment  => $com  ,
);

my $entry2 = $bookmark->add(
    url      => $url2 ,
    tag      => \@tag ,
    comment  => $com  ,
);


### edit
@tag = ( qw/ kaka tete /);
$com = 'edit comment';

my $eid1 = $bookmark->entry2eid($entry1);
$bookmark->edit({
    eid      => $eid,
    tag      => \@tag ,
    comment  => $com  ,
);

### delete
my $eid2 = $bookmark->entry2eid($entry2);
$bookmark->delete(
    eid      => $eid2 ,
);

my $feed = $bookmark->getFeed();
print $feed->as_xml;

exit;
