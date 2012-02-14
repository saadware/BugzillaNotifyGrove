# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::NotifyGrove::Util;
use strict;
use base qw(Exporter);
our @EXPORT = qw(
	check_grove_url 
	post_grove_msg 
);

use REST::Client;

sub check_grove_url {
	my ($url) = (@_);
	if ($url && $url !~ m:^http.*/$:) {
		return "must be a legal URL, that starts with http and ends with a slash.";
	}
	return "";
}

sub post_grove_msg {
	my ($msg) = (@_);
	my $url = Bugzilla->params->{ 'grove_url' };
	my $service_name = Bugzilla->params->{ 'grove_service_name' };
	my $service_url = Bugzilla->params->{ 'grove_service_url' };
	my $icon_url = Bugzilla->params->{ 'grove_icon_url' };
	if ( $url ne '' )
	{
		my $client = REST::Client->new();
		my $params = $client->buildQuery( [ 
				service => $service_name, 
				message => $msg, 
				url => $service_url, 
				icon_url => $icon_url ] );
		$client->POST( $url, substr( $params, 1 ), {'Content-type' => 'application/x-www-form-urlencoded'} );
	}
}

1;
