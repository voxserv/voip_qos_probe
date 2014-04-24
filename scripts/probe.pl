use strict;
use warnings;

my $dest = $ARGV[0];
die("Usage: $0 SIPURL\n") unless defined($dest);

my $s = new freeswitch::Session
    ('{origination_caller_id_number=probe}' .
     'sofia/external/' . $dest);

die("Could not create session") unless defined($s);

my $started = time();    
while( not $s->answered() )
{
    if( time() > $started + 10 )
    {
        die("Timed out waiting for answer");
    }
    freeswitch::msleep(500);
}

my $api = new freeswitch::API;
my $uuid = $s->get_uuid();
$api->executeString('sched_api +30 none uuid_kill ' . $uuid);

$s->execute('playback', 'local_stream://moh');





1;
