#!/usr/bin/perl 

use strict;
use warnings;
    
use Test::More tests=>10;

use WebService::Hatena::Bookmark;

my $URL = 'http://www.example.com';


#  _set_client
{
    my $bookmark = WebService::Hatena::Bookmark->new(
        username => 'samplename',
        password => 'samplepass'
    );

    my $client = $bookmark->_set_client();
    isa_ok( $client , 'XML::Atom::Client' , 'XML::Atom::Client object OK');

    is( $client->username() , 'samplename' , 'XML::Atom::Client username OK');
    is( $client->password() , 'samplepass' , 'XML::Atom::Client password OK');
}
#  _make_link_element
{
    my $link = WebService::Hatena::Bookmark->_make_link_element( $URL );
    isa_ok( $link , 'XML::Atom::Link' , 'XML::Atom::Link object OK');

    is( $link->rel() , 'related' , 'link_rel OK');
    is( $link->type() , 'text/html' , 'link type OK');
    is( $link->href() , $URL , 'link_href OK');
}

# _make_tag
{
    is(WebService::Hatena::Bookmark->_make_tag() ,  '' , 'empty _make_tag OK');
    is(WebService::Hatena::Bookmark->_make_tag(['aaa']) ,  '[aaa]' , '1 ary _make_tag OK');
    is(WebService::Hatena::Bookmark->_make_tag(['bbb','ccc']) ,  '[bbb][ccc]' , 'multi ary _make_tag OK');
}

