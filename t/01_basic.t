use strict;
use warnings;
use utf8;
use Test::More;
use Encode qw/encode_utf8/;

use Acme::EverythingBecomes;

{
    my $src = 'print 1;';
    my $w = Acme::EverythingBecomes->F(
        chars => ['w', 'W'],
    );
    my $encoded = $w->encode($src);
    $ENV{AUTHOR_TEST} and note $encoded;
    my $decoded = $w->decode($encoded);
    $ENV{AUTHOR_TEST} and note $decoded;
    is $src, $decoded;
}

{
    my $src = 'warn 1;';
    my $beersushi = Acme::EverythingBecomes->F(
        chars => [chr 0x1F37A, chr 0x1F363],
    );
    my $encoded = $beersushi->encode($src);
    $ENV{AUTHOR_TEST} and note encode_utf8($encoded);
    my $decoded = $beersushi->decode($encoded);
    $ENV{AUTHOR_TEST} and note $decoded;
    is $src, $decoded;
}

{
    my $src = 'say 1;';
    my $kenshiro = Acme::EverythingBecomes->F(
        chars => ['た', 'あ'],
    );
    my $encoded = $kenshiro->encode($src);
    $ENV{AUTHOR_TEST} and note $encoded;
    my $decoded = $kenshiro->decode($encoded);
    $ENV{AUTHOR_TEST} and note encode_utf8($decoded);
    is $src, $decoded;
}

{
    my $src = 'die 1;';
    my $f = Acme::EverythingBecomes->F;
    my $encoded = $f->encode($src);
    $ENV{AUTHOR_TEST} and note $encoded;
    my $decoded = $f->decode($encoded);
    $ENV{AUTHOR_TEST} and note $decoded;
    is $src, $decoded;
}

{
    my $src = <<'_CODE_';
use strict;
use warnings;

print "Hello, World★";
_CODE_
    chomp $src;
    my $f = Acme::EverythingBecomes->F;
    my $encoded = $f->encode($src);
    $ENV{AUTHOR_TEST} and note $encoded;
    my $decoded = $f->decode($encoded);
    $ENV{AUTHOR_TEST} and note encode_utf8($decoded);
    is $src, $decoded;
}

done_testing;
