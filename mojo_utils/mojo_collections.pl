# A collection is mostly a fixed list - once it is created it doesn't change (in terms of the number of elements) but
# individual elements cn be updated as appropriate.
# Mojo has the Mojo::Collection class to help us with these sort of operations

use Mojo::Collection qw( c );

use Data::Printer;

use feature 'say';
use feature 'signatures';

my $coll1 = Mojo::Collection->new( (1..10));
say "The size of the collection is : ", $coll1->size;
say "The first element of this collection is : ", $coll1->first;
say "The last element of this collection is : ", $coll1->last;

# when creating a collection there is a shortcut -> 'c'
# use Mojo::Collection qw( c );
# my $collection = c( (1..10) );

# to iterate over a collection - returns an 'list' :-
my @array = $coll1->each;

my $coll2 = Mojo::Collection->new( (11,2,4,3,5,4,6,7,1,10));
# You can provide a coderef (callback) that will be evaluated for each element:-
$coll2->each(sub ($e, $num) { # $e is the element and $num is its 'index' (non-zero).
  say "$e : $num";
});

# if you want to change the number of elements then you will have to create a new 'container'
# one way to do that is to use the 'grep' method and provide a 'regex' or a 'coderef'
my $coll3 = $coll1->grep( sub { $_ > 5 } );
say "The size of the new collection is : ", $coll3->size;
say "The first element of the new collection is : ", $coll3->first;
say "The last element of the new collection is : ", $coll3->last;

# map - create a new collection based on applying a function (coderef) to a collection.
my $coll4 = Mojo::Collection->new( (1..10) );
my $coll5 = $coll4->map( sub { $_ * 2; } ); # [2,4,6,8,10,12,14,16,18,20]
@array = $coll5->each;
p @array;

# an interesting feature of 'map' is that a 'string' argument is the method to call on '$_'
# and any extra arguments in map become arguments to the method.