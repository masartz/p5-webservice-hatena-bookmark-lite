package WebService::Hatena::Bookmark::Lite;

use strict;
use warnings;
our $VERSION = '0.01';

use Carp qw/croak/;
use XML::Atom::Link;
use XML::Atom::Entry;
use XML::Atom::Client;
use base qw/ Class::Accessor::Fast /;

use Data::Dumper;

__PACKAGE__->mk_accessors qw/
    client
/;

my $HatenaURI      = q{http://b.hatena.ne.jp};
my $PostURI        = qq{$HatenaURI/atom/post};
my $EditURI_PREFIX = qq{$HatenaURI/atom/edit/};
my $FeedURI        = qq{$HatenaURI/atom/feed};

sub new{
    my $class = shift;
    my %arg  = @_;

    my $client = XML::Atom::Client->new;
    $client->username($arg{username});
    $client->password($arg{password});

    bless {
        client   => $client
    },$class;
}

sub add{
    my $self = shift;
    my %arg  = @_;

    my $url      = $arg{url};
    my $tag      = $arg{tag};
    my $comment  = $arg{comment};

    my $entry = XML::Atom::Entry->new;
    $entry->add_link( $self->_make_link_element($url) );

    my $summary = $self->_make_tag($tag);
    $summary .= $comment;
    $entry->summary($summary);

    return $self->client->createEntry($PostURI , $entry)
        or croak $self->client->errstr;
}

sub getEntry{
    my $self = shift;
    my %arg  = @_;

    my $eid  = $arg{eid};

    my $EditURI = qq{$EditURI_PREFIX$eid};

    return $self->client->getEntry( $EditURI )
        or croak $self->client->errstr;
}

sub edit{
    my $self = shift;
    my %arg  = @_;

    my $eid      = $arg{eid};
    my $tag      = $arg{tag};
    my $comment  = $arg{comment};

    my $EditURI = qq{$EditURI_PREFIX$eid};

    my $entry = XML::Atom::Entry->new;

    my $summary = $self->_make_tag($tag);
    $summary .= $comment;
    $entry->summary($summary);

    return $self->client->updateEntry($EditURI , $entry)
        or croak $self->client->errstr;
}

sub delete{
    my $self = shift;
    my %arg  = @_;

    my $eid  = $arg{eid};

    my $EditURI = qq{$EditURI_PREFIX$eid};

    return $self->client->deleteEntry($EditURI )
        or croak $self->client->errstr;
}

sub getFeed{
    my $self = shift;

    return $self->client->getFeed( $FeedURI )
        or croak $self->client->errstr;
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
    my $self     = shift;
    my $tag_list = shift;

    my $tag_str = '';
    for my $tag ( @{$tag_list} ){
        $tag_str .= sprintf("[%s]" , $tag);
    }

    return $tag_str;
}

sub _entry2eid{
    my $self  = shift;
    my $entry = shift;

    my $edit = '';
    for my $link ( $entry->link() ){
        if( $link->rel() eq 'service.edit'){
            $edit = $link->href();
            last;
        }
        else{
            next;
        }
    }

    my $eid = substr($edit , length("$EditURI_PREFIX") );

    return $eid;
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
        eid     => 12345,
        tag     => \@tag_list,
        comment => $comment,
    });
    
    # Delete
    $bookmark->delete({
        eid     => 567,
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
