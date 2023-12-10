# The Mojo::Util modules provides a number of 'tools' that may prove useful in most
# programs.

use feature 'say';

use Mojo::Util qw( b64_decode b64_encode trim );

# Trim
# ====

# trimming text
my $str = "   Hello World            ";
say $str;
say trim($str);

# Base64
# ======

# base64 - there are various use - in a web context where you may encounter a
# username and password in an Authorization header :-
my $user = "Richard";
my $password = "password1";
my $value = b64_encode( join ':', $user, $password);
say $value; # UmljaGFyZDpwYXNzd29yZDE=

# and you can also 'decode'
my $decoded_value = b64_decode( $value );
say $decoded_value; # Richard:password1

# Events
# ======

# Mojo is built around an event module. When something happens in one
# part of the code, other parts of the code can find out about it and react to
# that. Most parts of the Mojo inherit from Mojo::EventEmitter and individual classes 
# provide various events.

package Customer {
    use Mojo::Base 'Mojo::EventEmitter', -signatures;

    sub new ( $class, $name ) { bless { name => $name }, $class };

    sub send_welcome_email ( $self ) {
        $self->emit( send_email => $self->name ) ;
    }

    sub name {
        my $self = shift;
        return $self->{ name };
    }
};

use Mojo::Util qw( dumper );

my $customer = Customer->new( "Richard" );
say dumper( $customer );
# bless( {
#   "name" => "Richard"
# }, 'Customer' )
$customer->on( send_email => sub ( $customer ) {
    say "Hello ", $customer->name;
});

$customer->send_welcome_email(); # Hello Richard

