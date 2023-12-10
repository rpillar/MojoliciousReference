# JSON has the values 'true' and 'false' - not strings. This is a problem for Perl where truth is
# understood a different way. 
# To get around this Mojo::JSON uses references to '0' and '1' to represent these

use Mojo::JSON qw( decode_json encode_json );

use Data::Printer;

use feature 'say';

my $data = [
    {
        name => "Richard",
        manager => \1 # note the use of references
    },
    {
        name => "John",
        manager => \0 # note the use of references
    }
];
my $encoded_data = encode_json( $data );
say $encoded_data; # [{"manager":true,"name":"Richard"},{"manager":false,"name":"John"}]

my $json_data = '{ "name": "Richard", "manager": true }';
my $decoded_data = decode_json( $json_data );
p $decoded_data;
# {
#     manager   1 (JSON::PP::Boolean) (read-only),
#     name      "Richard"
# }