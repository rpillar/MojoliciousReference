# it is common place to use Data::Dumper when attempting to debug code. When using 'plain'
# Data::Dumper the output will look something like :-
#
#   VAR1 = {
#          'robot' => 'Bender',
#          'pilot' => 'Leela'
#        };
#
# Mojo::Utils dumper makes use of a number of Data::Dumper's settings to give us a 'friendlier'
# output :-
# 
#   {
#       "pilot" => "Leela",
#       "robot" => "Bender"
#   }

use feature 'say';

use Data::Dumper;
my $hash_reference = {
    robot => 'Bender',
    pilot => 'Leela',
};
say Dumper( $hash_reference );

use Mojo::Util qw(dumper);
my $hash_reference = {
    robot => 'Bender',
    pilot => 'Leela',
};
say dumper( $hash_reference );