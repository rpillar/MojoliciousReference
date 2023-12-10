# there is a module for 'that' - 'that' being encoding / decoding JSON data

use Mojo::Base -strict;
use Mojo::JSON qw( encode_json );

use Data::Printer;

use feature 'say';

my $data = {
    employees => [
        {
            name => "Richard",
            age => 21,
            gender => "male"
        },
        {
            name => "John",
            age => 55,
            gender => "male"
        },
        {
            name => "Sam",
            age => 18,
            gender => "male"
        }
    ]
};

my $encoded_data = encode_json( $data );
say $encoded_data; # {"employees":[{"age":21,"gender":"male","name":"Richard"},{"age":55,"gender":"male","name":"John"},{"age":18,"gender":"male","name":"Sam"}]}

# All JSON is 'UTF-8' encoded. For much of Mojo you don't need to worry about encoding your data as JSON - A POST request takes a URL
# and a 'stream type' - the 'json' content generator will take your Perl data structure and handle the encoding for you.

use Mojo::UserAgent;
my $ua = Mojo::UserAgent->new;

my $url = "http://www.example.com";
$data = { employees => [ { name => "Richard", age => 21, gender => "male" } ] };
my $tx = $ua->post( $url, json => $data ); # a Mojo::Transaction::HTTP object (parent is Mojo::Transaction)
say $tx->req->to_string;

# something like :- 
#  POST / HTTP/1.1
#  Accept-Encoding: gzip
#  Content-Length: 59
#  Content-Type: application/json
#  Host: www.example.com
#  User-Agent: Mojolicious (Perl)
#
#  {"employees":[{"age":21,"gender":"male","name":"Richard"}]}

my $base = Mojo::URL->new( 'http://httpbin.org/headers' );
$tx = $ua->get( $base );
p $tx->result;
# HTTP/1.1 200 OK
# Access-Control-Allow-Credentials: true
# Access-Control-Allow-Origin: *
# Connection: keep-alive
# Content-Length: 190
# Content-Type: application/json
# Date: Wed, 15 Nov 2023 13:05:12 GMT
# Server: gunicorn/19.9.0
#
# {
#   "headers": {
#     "Accept-Encoding": "gzip", 
#     "Host": "httpbin.org", 
#     "User-Agent": "Mojolicious (Perl)", 
#     "X-Amzn-Trace-Id": "Root=1-6554c208-62462fd92a9937035a467db8"
#   }
# }
#  (Mojo::Message::Response)
p $tx->result->json;
# {
#     headers   {
#         Accept-Encoding   "gzip",
#         Host              "httpbin.org",
#         User-Agent        "Mojolicious (Perl)",
#         X-Amzn-Trace-Id   "Root=1-6554c281-6dcb4215498e6b8b654b5054"
#     }
# }
## we can look at each header by iterating over the 'data' using a 'while / each' loop or using 
## postfix dereferencing.
my $headers = $tx->result->json;
while ( my ($key, $value) = each %{ $headers->{ headers } } ) {
    say $key, " : ", $value;
}
say $headers->{ headers }->%*;
foreach my ( $key, $value ) ( $headers->{ headers }->%* ) {
    say $key, " : ", $value;
}

# It should be noted that the Mojo framework will use an object's 'TO_JSON" method to encode
# the json. For example :-
package TestMe;

use Mojo::Base -base;
use Mojo::JSON qw( encode_json );

sub TO_JSON {
    return {
        name => "Richard",
        age  => 101,
        gender => "male"
    }
}

1;
my $test_me = TestMe->new();
say encode_json( $test_me ); # {"age":101,"gender":"male","name":"Richard"}