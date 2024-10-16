#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Shlomif::Screenplays::EPUB ();

my $obj = Shlomif::Screenplays::EPUB->new;
$obj->run;

my $gfx      = $obj->gfx;
my $filename = $obj->filename;

foreach my $part ( $filename =~ /hebrew/i ? 1 : 0 )
{
    my $epub_basename = ( $filename =~ s/\.screenplay-text.xhtml\z//r );
    $obj->epub_basename($epub_basename);

    $obj->output_json(
        {
            data => {
                filename => $epub_basename,
                title    => "Humanity - The Movie"
                    . ( $part ? " - Hebrew Translation" : "" ),
                authors => [
                    {
                        name => "Shlomi Fish",
                        sort => "Fish, Shlomi",
                    },
                ],
                contributors => [
                    {
                        name => "Shlomi Fish",
                        role => "oth",
                    },
                ],
                cover  => "images/$gfx",
                rights =>
"Creative Commons Attribution ShareAlike Unported (CC-by-sa-3.0)",
                publisher => 'http://www.shlomifish.org/',
                language  => 'en-GB',
                subjects  => [
                    'FICTION/Horror', 'FICTION/Humorous', 'FICTION/Mashups',
                ],
                identifier => {
                    scheme => 'URL',
                    value  => 'http://www.shlomifish.org/humour/humanity/',
                },
            },
        },
    );
}
