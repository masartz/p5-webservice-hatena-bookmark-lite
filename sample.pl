#!/usr/bin/perl 

use strict;
use warnings;

use lib "./lib";
use WebService::Hatena::Bookmark::Lite;

my $user  = shift;
my $pass  = shift;
my $url1  = 'http://www.google.co.jp';
my $url2  = 'http://www.yahoo.co.jp';
my @tag   = ( qw/ hoge moge /);
my $com   = 'tetetetetst';

if( ! $user || ! $pass ){
    print "please set argment. UserID and Password of Hatena \n";
    exit;
}

my $bookmark = WebService::Hatena::Bookmark::Lite->new(
    username => $user,
    password => $pass,
);

### Add
my $edit_ep1 = $bookmark->add(
    url      => $url1 ,
    tag      => \@tag ,
    comment  => $com  ,
);

my $edit_ep2 = $bookmark->add(
    url      => $url2 ,
    tag      => \@tag ,
    comment  => $com  ,
);


### edit
@tag = ( qw/ kaka tete /);
$com = 'edit comment';

$bookmark->edit(
    edit_ep  => $edit_ep1,
    tag      => \@tag ,
    comment  => $com  ,
);

my $entry = $bookmark->getEntry( edit_ep  => $edit_ep1 );
my $select_ep = $bookmark->entry2edit_ep( $entry );
print __LINE__. $select_ep . "\n";
print __LINE__. $edit_ep1 . "\n";


### delete
$bookmark->delete(
    edit_ep  => $edit_ep2,
);

my $feed = $bookmark->getFeed();
print $feed->as_xml;

exit;
