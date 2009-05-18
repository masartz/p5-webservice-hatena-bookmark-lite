package WebService::Hatena::Bookmark::Lite;

use strict;
use warnings;
our $VERSION = '0.01';

use Carp qw/croak/;
use XML::Atom::Link;
use XML::Atom::Entry;
use XML::Atom::Client;
use base qw/ Class::Accessor::Fast /;

__PACKAGE__->mk_accessors qw/
    username
    password
/;

my $HatenaURI = q{http://b.hatena.ne.jp};
my $PostURI = qq{$HatenaURI/atom/post};
my $FeedURI = qq{$HatenaURI/atom/feed};

sub new{
    my $self = shift;
    my %arg  = @_;

    bless {
        username => $arg{username},
        password => $arg{password},
    },$self;
}

sub add{
    my $self = shift;
    my %arg  = @_;

    my $url      = $arg{url};
    my $tag      = $arg{tag};
    my $comment  = $arg{comment};

    my $client = $self->_set_client();

    my $entry = XML::Atom::Entry->new;
    $entry->add_link( $self->_make_link_element($url) );

    my $summary = $self->_make_tag($tag) if scalar $tag ;
    $summary .= $comment;
    $entry->summary($summary);

    return $client->createEntry($PostURI , $entry) 
        or croak $client->errstr;
}

sub getFeed{
    my $self = shift;

    my $client = $self->_set_client();

    return $client->getFeed( $FeedURI )
        or croak $client->errstr;
}

sub _set_client{
    my $self = shift;
    
    my $client = XML::Atom::Client->new;
    $client->username($self->username);
    $client->password($self->password);

    return $client;
}

sub _make_link_element{
    my $self = shift;
    my $url  = shift;
    my $link = XML::Atom::Link->new;

    $link->rel('related');
    $link->type('text/html');
    $link->href($url);

    return $link;
}

sub _make_tag{
    my $self = shift;
    my $tag_list = shift;

    my $tag_str = '';
    for my $tag ( @{$tag_list} ){
        $tag_str .= sprintf("[%s]" , $tag);
    }

    return $tag_str;
}

1;
__END__

=head1 NAME

WebService::Hatena::Bookmark::Lite - A Perl Interface for Hatena::Bookmark AtomPub API

=head1 SYNOPSIS

    use WebService::Hatena::Bookmark::Lite;

    my $bookmark = WebService::Hatena::Bookmark::Lite->new({
        username => $username,
        password  => $password,
    });

    # Add
    $bookmark->add({
        url     => $url,
        tag     => \@tag_list,
        comment => $comment,
    });

    # Edit
    $bookmark->edit({
        url     => $url,
        tag     => \@tag_list,
        comment => $comment,
    });
    
    # Delete
    $bookmark->delete({
        url     => $url,
    });

    # Get Feed
    $bookmark->getFeed();



=head1 DESCRIPTION

WebService::Hatena::Bookmark::Lite is

=head1 AUTHOR

Masartz E<lt>masartz {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
