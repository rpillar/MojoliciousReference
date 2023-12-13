use Mojolicious::Lite;

get '/hello/#you' => 'groovy';

app->start;
__DATA__

@@ groovy.html.ep
Your name is <%= $you %>.

# you can use Mojolicious::Lite to test bits of functionality before adding it
# it to a 'full' app.
# This is a very simple example - one route - start using 'perl ./mojo_hello.pl daemon'
# - runs on port '3000' by default.