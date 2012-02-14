# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::NotifyGrove::Config;
use strict;
use warnings;

use Bugzilla::Config::Common;
use Bugzilla::Extension::NotifyGrove::Util;

our $sortkey = 5000;

sub get_param_list {
	my ($class) = @_;

	my @param_list = (
		{
			name => 'grove_url',
			type => 't',
			default => '',
			checker => \&check_grove_url
		},
		{
			name => 'grove_service_name',
			type => 't',
			default => 'bugbot'
		},
		{
			name => 'grove_service_url',
			type => 't',
			default => ''
		},
		{
			name => 'grove_icon_url',
			type => 't',
			default => ''
		}
	);
    return @param_list;
}

1;
