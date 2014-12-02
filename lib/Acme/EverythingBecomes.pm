package Acme::EverythingBecomes;
use strict;
use warnings;
use utf8;
use Encode qw//;
use File::Slurp;

use Class::Accessor::Lite (
    ro  => [qw/ chars split_line /],
);

our $VERSION = '0.01';

sub F {
    my $class = shift;
    my %args  = @_;

    bless {
        chars      => $args{chars} || ['f', 'F'],
        split_line => $args{split_line} || "\n",
        _encode_cache => {},
        _decode_cache => {},
    }, $class;
}

sub encode {
    my ($self, $str) = @_;

    my @encoded_lines;
    for my $line (split /$self->{split_line}/, Encode::encode_utf8($str)) {
        my @words;
        for my $word (split //, $line) {
            push @words, $self->_encode_word($word);
        }
        push @encoded_lines, join(' ', @words);
    }
    join $self->{split_line}, @encoded_lines;
}

sub _encode_word {
    my ($self, $word) = @_;

    if (exists $self->{_encode_cache}{$word}) {
        return $self->{_encode_cache}{$word};
    }

    my $encoded = sprintf "%b", ord $word;
    $encoded =~ s/^0+//g;
    $encoded = '0' if $encoded eq '';
    $encoded =~ s/0/$self->chars->[0]/eg;
    $encoded =~ s/1/$self->chars->[1]/eg;
    $self->{_encode_cache}{$word} = $encoded;
    return $encoded;
}

sub decode {
    my ($self, $str) = @_;

    my @decoded_lines;
    for my $line (split /$self->{split_line}/, $str) {
        my @words;
        for my $word (split / /, $line) {
            push @words, $self->_decode_word($word);
        }
        push @decoded_lines, join('', @words);
    }
    Encode::decode_utf8(join $self->{split_line}, @decoded_lines);
}

sub _decode_word {
    my ($self, $word) = @_;

    if (exists $self->{_decode_cache}{$word}) {
        return $self->{_decode_cache}{$word};
    }

    my ($zero, $one) = @{$self->chars};
    my $decoded = $word;
    $decoded =~ s/$zero/0/eg;
    $decoded =~ s/$one/1/eg;
    if ($decoded eq '0') {
        $self->{_decode_cache}{$word} = chr 0;
    }
    else {
        $self->{_decode_cache}{$word} = chr(oct "0b$decoded");
    }
    return $self->{_decode_cache}{$word};
}

sub run {
    my ($self, $file) = @_;

    my $encoded_str = read_file($file, binmode => ':utf8') ;
    my $code = $self->decode($encoded_str);
    eval $code; ## no critic
    die $@ if $@;
}

1;

__END__

=encoding utf-8

=head1 NAME

Acme::EverythingBecomes - Everything becomes F


=head1 SYNOPSIS

    use Acme::EverythingBecomes;

    my $f = Acme::EverythingBecomes->F;
    print $f->encode('print 1;');
    # FFFffff FFFffFf FFfFffF FFfFFFf FFFfFff Ffffff FFfffF FFFfFF


=head1 DESCRIPTION

Acme::EverythingBecomes provides the encode/decode filter.


=head1 METHODS

=head2 F

constractor

=head2 encode($str)

encode strings

=head2 decode($str)

decode strings

=head2 run($encoded_str)

execute C<$encoded_str>


=head1 REPOSITORY

Acme::EverythingBecomes is hosted on github: L<http://github.com/bayashi/Acme-EverythingBecomes>

Welcome your patches and issues :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

すべてがFになる  L<http://ja.wikipedia.org/wiki/%E3%81%99%E3%81%B9%E3%81%A6%E3%81%8CF%E3%81%AB%E3%81%AA%E3%82%8B>

This module is inspired by L<Acme::W> and L<Acme::BeerSushi>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
