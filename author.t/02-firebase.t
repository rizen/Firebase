use lib '../lib';
use Firebase;
use Test::More;

my $firebase = Firebase->new(secret => $ENV{FIREBASE_TOKEN}, firebase => $ENV{FIREBASE});

isa_ok($firebase, 'Firebase');

is $firebase->firebase, $ENV{FIREBASE}, 'set the firebase';
is $firebase->secret, $ENV{FIREBASE_TOKEN}, 'set the secret token';

my $result = $firebase->put('test', { foo => 'bar' });
is $result->{foo}, 'bar', 'created object';

$result = $firebase->get('test');
is $result->{foo}, 'bar', 'authenticate read object';

$result = Firebase->new(firebase => $ENV{FIREBASE})->get('test');
is $result->{foo}, 'bar', 'anonymous read object';

$result = $firebase->delete('test');
is $result, undef, 'delete object';




done_testing();

1;
