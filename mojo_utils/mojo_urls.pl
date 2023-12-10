# the module Mojo::URL knows how to put together and take apart addresses.
use Data::Printer;

use Mojo::Base -strict;
use Mojo::URL;

use feature 'say';

my $url = Mojo::URL->new("http://www.example.com:8080/?name=John#Foo");

say join "\n",
    ' Scheme : ' . $url->scheme,
    ' Host : ' . $url->host,
    ' Port : ' . $url->port,
    ' Path : ' . $url->path,
    ' Query : ', $url->query,
    ' Fragment : ', $url->fragment;

# 'parts' can be set ....
$url = Mojo::URL->new("http://example.com");
$url->path('employee/john');
say $url; # http://example.com/employee/john

# base a URL on an existing one and have a 'variable' part ...
my $base = Mojo::URL->new( 'https://api.github.com' );

my $username = "johndoe";
my $path = '/users/:username/repos';
$path =~ s/:username/$username/; # substitute in the supplied username ...

my $url = $base->clone->path( $path );
say $url;

# start with a piece and turn it into a full URL with 'to_abs' ....
$path = Mojo::URL->new( '/employee/johndoe' );
$base = Mojo::URL->new( 'http://example.com' );
$url = $path->to_abs( $base );
say $url;

# note that a stringified version of a URI object (non Mojo) can feed into Mojo::URL
use URI;
$base = URI->new('http://www.example.com');
say Mojo::URL->new( $base->as_string );

# a Mojo::URL object also automatically stringifies when interpolated in a string 
$base = Mojo::URL->new( 'http://www.example.com' );
say "My URL is : $base";

# It is also easy to build a url / path in 'bits'
$url = Mojo::URL->new( 'http://www.example.com' );
push $url->path->@*, qw( some path);
say "My URL is : $url";

# the reverse is also possible
$url = Mojo::URL->new( 'http://www.example.com/some/path' );
my @bits = $url->path->@*;
p @bits; # [ "some", "path" ]