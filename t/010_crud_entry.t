use strict;
use warnings;
use Test::More;
use WebService::Hatena::Bookmark::Lite;

my $username = $ENV{WEBSERVICE_HATENA_BOOKMARK_TEST_USERNAME};
my $password = $ENV{WEBSERVICE_HATENA_BOOKMARK_TEST_PASSWORD};

if ($username && $password) {
    plan tests => 8 ;
}
else {
    plan skip_all => "Set ENV:WEBSERVICE_HATENA_BOOKMARK_TEST_USERNAME/PASSWORD";
}

my $url1  = 'http://www.google.co.jp';
my $url2  = 'http://www.yahoo.co.jp';
my @tag   = ( qw/ hoge moge /);
my $com   = 'tetetetetst';
my $bookmark = '';
my $edit_ep1 = '';
my $edit_ep2 = '';

# new
{
    $bookmark = WebService::Hatena::Bookmark::Lite->new(
        username => $username,
        password => $password,
    );
    isa_ok( $bookmark , 'WebService::Hatena::Bookmark::Lite' , 'WebService::Hatena::Bookmark::Lite Object new OK');
}

### Add
{
    $edit_ep1 = $bookmark->add(
        url      => $url1 ,
        tag      => \@tag ,
        comment  => $com  ,
    );

    $edit_ep2 = $bookmark->add(
        url      => $url2 ,
        tag      => \@tag ,
        comment  => $com  ,
    );

    like( $edit_ep1 , qr{^atom/edit/[0-9]} , 'entry1 add OK' );
    like( $edit_ep2 , qr{^atom/edit/[0-9]} , 'entry2 add OK' );
}

### edit
{
    @tag = ( qw/ kaka tete /);
    $com = 'edit comment';

    my $edit_ret = $bookmark->edit(
        edit_ep  => $edit_ep1,
        tag      => \@tag ,
        comment  => $com  ,
    );
    is( $edit_ret , 1 , 'entry1 edit OK');
}

### getEntry
{
    my $entry = $bookmark->getEntry( edit_ep  => $edit_ep1 );
    isa_ok( $entry , 'XML::Atom::Entry' , 'getEntry return XML::Atom::Entry Object OK');

    my $select_ep = $bookmark->entry2edit_ep( $entry );
    is( $select_ep , $edit_ep1 , 'entry2edit_ep OK');
}

### delete
{
    my $del_ret = $bookmark->delete(
       edit_ep  => $edit_ep2,    
    );
    is( $del_ret , 1 , 'entry2 delete OK');
}

### getFeed
{
    my $feed = $bookmark->getFeed();
    isa_ok( $feed , 'XML::Atom::Feed' , 'getFeed return XML::Atom::Feed Object OK');
}
