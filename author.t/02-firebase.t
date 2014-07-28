use lib '../lib';
use Firebase;
use Test::More;
use Ouch;

my $firebase = Firebase->new(auth => { secret => $ENV{FIREBASE_TOKEN}, admin => \1 }, firebase => $ENV{FIREBASE});

isa_ok($firebase, 'Firebase');

is $firebase->firebase, $ENV{FIREBASE}, 'set the firebase';
isa_ok $firebase->authobj, 'Firebase::Auth';
is $firebase->authobj->secret, $ENV{FIREBASE_TOKEN}, 'set the secret token';

my $result = $firebase->put('test', { foo => 'bar' });
is $result->{foo}, 'bar', 'created object';

$result = $firebase->get('test');
is $result->{foo}, 'bar', 'authenticate read object';

$result = Firebase->new(firebase => $ENV{FIREBASE})->get('test');
is $result->{foo}, 'bar', 'anonymous read object';

$result = $firebase->delete('test');
is $result, undef, 'delete object';


my $firebase2 = Firebase->new(auth => { secret => $ENV{FIREBASE_TOKEN}, data => { id => 'abc' } }, firebase => $ENV{FIREBASE});
my $data = $firebase2->put('status/abc/xxx', { type => 'info', message => 'this is a test' });
is $data->{type}, 'info', 'can write to authorized location';
my $data = $firebase2->put('status/abc/yyy', { type => 'info2', message => 'brother test' });
is $data->{type}, 'info2', 'Wrote additional data';

eval { $firebase2->delete('status/abc/yyy'); };
ok !hug(), 'No exception thrown for deleting something';

my $data = $firebase2->get('status/abc/yyy');
is $data, undef, 'Nothing at the location we just deleted';

my $data = $firebase2->post('status/abc', { fire => 'base', });
ok exists $data->{name}, "PUSHed to status with name: ". $data->{name};

$firebase2->delete('status/abc/'.$data->{name});

eval { $firebase2->put('somewhere', { foo => 'bar' }); };

is $@->message, '403 Forbidden', 'Cannot just write willy nilly.';

done_testing();

1;
