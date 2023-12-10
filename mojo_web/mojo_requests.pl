# A request is the start of the HTTP conversation and there’s quite a bit more
# that Mojo does to make this happen 

# The Request Process
# ===================

# when you perform a 'get' a request is immediately initiated and your program will
# wait until it completes. On completion it returns a Mojo::Transaction::* object :-

use Mojo::UserAgent;

use Data::Printer;

use feature 'say';

my $ua = Mojo::UserAgent->new;
my $tx = $ua->get( 'https://www.httpbin.org' );

# $tx is a Mojo::Transaction::HTTP object (parent is Mojo::Transaction).
# A transaction is 'built' in several steps (internally - you probably wouldn't want / need to do this)
my $t = Mojo::UserAgent::Transactor->new;
my $tx = $t->tx(
    GET => 'https://www.httpbin.org'
); # create your Mojo::Transaction::HTTP object
$tx->req->headers->header( 'X-API-Key' => '076CEE20-879C-11EE-A1C7-EB1C822A0FB9' ); # add a header
my $resp = $ua->start( $tx ); # perform the request

# the request is a Mojo::Message::Request object
# Add a header - the easiest way is with a hash ref after the 'URL'
$tx = $ua->get(
    'https://www.httpbin/headers'
        => {
            'X-API-Key' => '076CEE20-879C-11EE-A1C7-EB1C822A0FB9'
        }
);

# you can add one / many headers - defining them in a hash reg :-
my $headers = {
    'X-Auth-Key' => '56F87BC4-879E-11EE-92A3-ABF261F32582',
    'X-UID' => 'FDB4BBE0-879D-11EE-8754-94A35B90574D',
};
$tx->req->headers->from_hash( $headers );
say $tx->req->to_string;
# GET /headers HTTP/1.1
# Accept-Encoding: gzip
# Host: www.httpbin
# User-Agent: Mojolicious (Perl)
# X-API-Key: 076CEE20-879C-11EE-A1C7-EB1C822A0FB9
# X-UID: FDB4BBE0-879D-11EE-8754-94A35B90574D
# X-Auth-Key: 56F87BC4-879E-11EE-92A3-ABF261F32582

# you can use the 'add' method on the request headers - $tx->req->headers->add( '.......' )->add( '.......' );
# NOTE - when you call 'to_string' on a request object you are 'finalizing' the object (it caches the result) and any further changes
# will not have any effect.

# to remove a header -> $tx->req->headers->remove( 'X-API-Key' );

# The 'default' name for the Mojo UserAgent is 'Mojolicious (Perl)' - because some servers may allow / deny access
# based on the user agent name Mojo has a means by which it can be set
$t = Mojo::UserAgent::Transactor->new;
$t->name( 'UA-Test-Name' );
$tx = $t->tx(
    GET => 'https://www.httpbin.org'
);
say $tx->req->to_string;
# GET / HTTP/1.1
# Accept-Encoding: gzip
# Host: www.httpbin.org
# User-Agent: UA-Test-Name

# Authentication
# ==============

# 'Basic Authentication' is as simple as it sounds - you have a username / password that you
# want to supply to the server - Mojo allows you to add this data to the URL so you don't have
# to worry about constructing the headers 
use Mojo::URL;
my $username = "JohnDoe";
my $password = "password";
my $url = Mojo::URL->new(
    "http://$username:$password\@www.example.com"
);
$ua = Mojo::UserAgent->new;
$tx = $ua->build_tx( GET => $url);
say $tx->req->to_string;
# GET / HTTP/1.1
# Accept-Encoding: gzip
# Authorization: Basic Sm9obkRvZTpwYXNzd29yZA==
# Host: www.example.com
# User-Agent: Mojolicious (Perl)

# other means of authentication exist and Mojo will help - check the documentation.

# Adding Message Bodies
# =====================

# JSON
# ----
$ua = Mojo::UserAgent->new;
my %data = (
    name => "Richard",
    age  => 21,
    gender => "male"
);
$url = "http://ww.httpbin.org/post";
$tx = $ua->build_tx( POST => $url, json => \%data );
say $tx->req->to_string;
# POST /post HTTP/1.1
# Accept-Encoding: gzip
# Content-Length: 43
# Content-Type: application/json
# Host: ww.httpbin.org
# User-Agent: Mojolicious (Perl)
#
# {"age":21,"gender":"male","name":"Richard"}

# ^^ - note the correct 'Content-Type' header and 'Content-Length'.
say $tx->result->body;