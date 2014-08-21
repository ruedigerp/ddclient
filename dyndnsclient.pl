#!/usr/bin/perl

package dyndns_mod;
use Cwd qw(abs_path);

sub new
{
  my $class = shift;
  my $self = {
		_version => '0.2c',
    _verbose => '',
    _setup => undef,
    _launchagent => undef,
		_help => undef,
		_update => undef,
  };
  bless $self, $class;
  return $self;
}

sub setargs() 
{
  my ($self,$verbose,$setup,$launchagent,$help,$update) = @_;
  $self->{_verbose}=$verbose;
  $self->{_setup}=$setup;
  $self->{_launchagent}=$launchagent;
	$self->{_help}=$help;
	$self->{_update}=$update;
	return $self;
}
sub run() 
{
	my ($self) = @_;
	if ( $self->{_setup} eq 1 ) {
		$self->getuserdata();
	}
	if ( $self->{_launchagent} eq 1 ) {
		$self->createplistfile();
	}
	if ( $self->{_help} eq 1 ) {
		$self->help();
	}
	if ( $self->{_update} eq 1 ) {
		$self->checkupdate();
	}
	return $self;
}
sub getuserdata() 
{
	my ($self) = @_;
		print "Running Setup.\n";
		print "Username: ";
		$self->{user} = <STDIN>;
		print "Password: ";
		$self->{pass} = <STDIN>;
		print "Api-Key: ";
		$self->{apik} = <STDIN>;
		$self->createconfig();
		exit 0;
}

sub checkupdate()
{
	my ($self) = @_;
	my $scriptpath = abs_path(__FILE__);
	my $getversion = `curl -s https://raw.githubusercontent.com/ruedigerp/ddclient/master/VERSION`;
	chomp($getversion); chomp($getversion);
	print "Git-Version: $getversion\n";
	my $version = $self->{_version};
	# open(FH,"<VERSION");
	# my $version = <FH>;
	# close FH;
	# chomp($version);
	print "Installed version: $version\n";
	if ( $getversion eq $version ) {
		print "Current version installed\n";
	}	else {
		print "Update available. Download update ....\n";
		my $update = `curl -s -o DDclient "https://raw.githubusercontent.com/ruedigerp/ddclient/master/DDclient"`;
		print "Script Path: " . $scriptpath . " " . $ARGV[0]. " \n";
	}
	exit;
}

sub help() 
{
	my ($self) = @_;
	print <<EOF;
usage: dyndnsclient.pl -[|setup|launchagent]
Update IP/Domain:
#> dyndnsclient.pl

Running Setup and create configfile:
#> dyndnsclient.pl -setup

Create LaunchAgent File (Apple OS X):
#> dyndnsclient.pl -launchagent

Check update/new client version
#> dyndnsclient.pl -help

EOF

exit 0;
}

sub createplistfile() 
{
	my ($self) = @_;
	print "Create plist File\n";
	my $home = $ENV{'HOME'};
	open(FH,">dyndns.9it.eu.plist");
	print FH <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>dyndns.9it.eu.plist</string>
    <key>Nice</key>
    <integer>20</integer>
    <key>ProgramArguments</key>
    <array>
    <string>$home/bin/dyndnsclient.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>10</integer>
    <key>StandardErrorPath</key>
    <string>$home/bin/dyndnsclient.sh.log</string>
    <key>StandardOutPath</key>
    <string>$home/bin/dyndnsclient.sh.log</string>
    <key>ThrottleInterval</key>
    <integer>60</integer>
    <key>OnDemand</key>
    <true/>
</dict>
</plist>
EOF
	close FH;
	exit;
}

sub createconfig(){
	my ($self) = @_;
	my $user = $self->{user};
	chomp($user);
	my $pass = $self->{pass};
	chomp($pass);
	my $apik = $self->{apik};
	chomp($apik);
	open(FH,">DDclient.pl");
	print FH "
# package DDclientconf;

sub DDconf() 
{
	# Your Data here.
	\$apikey=\"$apik\";
	\$user=\"$user\";
	\$password=\"$pass\";

	# if use self hosted dyndns service and not http://9it.eu/dyndns....
	# Example: 
	# \$UPDURL=\"http://9it.eu/dyndns/update.pl\";
	# \$UPDURL=\"http://www.yourdomain.net/dyndns/update.pl\";
	# \$extipurl=\"http://9it.eu/dyndns/externeip.pl\";
	# \$extip6url=\"http://ip6.9it.eu/dyndns/externeip.pl\";
}
1;
";
	close FH;
	return $self;
}

package main;
use LWP::Simple;
require ("./DDclient.pl");
use warnings; 
use Getopt::Long;
use Pod::Usage;
# use CryptoFS;

my $man = 0;
my $help = 0;
GetOptions (
  'h' => \$h,
  'help|?' => \$help,
  man => \$man,
  'verbose+' => \$verbose,
  'setup' => \$setup,
  'launchagent' => \$launchagent,
  'update' => \$update,
) or pod2usage(2); pod2usage(1) if $help; pod2usage(-exitval => 0, -verbose => 2) if $man;

my $Obj = new dyndns_mod( );
$Obj->setargs($verbose,$setup,$launchagent,$h,$update);
$Obj->run();

DDconf();
if ( ! $UPDURL ) {
	# print "Update URL not set. Set default.\n";
	$UPDURL="http://9it.eu/dyndns/update.pl";
}
if ( ! $extipurl ) {
	# print "ip URL not set. Set default.\n";
	$extipurl="http://9it.eu/dyndns/externeip.pl";
}
if ( ! $extip6url ) {
	# print "ipv6 URL not set. Set default.\n";
	$extip6url="http://ip6.9it.eu/dyndns/externeip.pl";
}
my $extip=`curl -s $extipurl`; # http://9it.eu/dyndns/externeip.pl`;
my $ip6=`curl -s $extip6url`; # http://ip6.9it.eu/dyndns/externeip.pl`;
my $URI= "$UPDURL?apikey=$apikey&ip=$extip&ip6=$ip6&user=$user&password=$password";
my $content = get("$UPDURL?apikey=$apikey&ip=$extip&ip6=$ip6&user=$user&password=$password");
chomp($content);
if ( $content eq "OK" ) 
{
	print $content . "\n";
	exit 0;
} 
else 
{
	print "Error: " . $content . "\n";
	exit 1;
}
 
