use Mojolicious::Lite -signatures;

get '/hello/' => sub ($c) {
    my $data = {name => "Richard", age => 21, gender => "male"};
    $c->render(json => $data)
};

app->start;

# return a json string ....
# invoke using - 'perl ./mojo_hello_json.pl daemon'