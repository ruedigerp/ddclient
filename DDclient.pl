# package DDclientconf;

sub DDconf() 
{
	$UPDURL="http://9it.eu/dyndns/update.pl";
	$apikey="YOUTAPIKEYHERE";
	$user="YOURUSERNAME";
	$password="YOURPASSWORD";
	


	$extip=get("http://9it.eu/dyndns/externeip.pl");
	$ip6=get("http://ip6.9it.eu/dyndns/externeip.pl");
}
1;
