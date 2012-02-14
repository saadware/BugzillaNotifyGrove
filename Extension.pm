# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::NotifyGrove;
use strict;
use base qw(Bugzilla::Extension);

use Bugzilla::Constants;
use Bugzilla::Error;
use Bugzilla::Group;
use Bugzilla::User;
use Bugzilla::User::Setting;
use Bugzilla::Util qw(diff_arrays html_quote);
use Bugzilla::Status qw(is_open_state);
use Bugzilla::Install::Filesystem;
use Bugzilla::Extension::NotifyGrove::Util;

#use Data::Dumper;

our $VERSION = '0.1';

sub bug_end_of_create {
	my ($self, $args) = @_;

	my $bug = $args->{'bug'};

	my $url = sprintf( '%s/show_bug.cgi?id=%d', Bugzilla->params->{ 'urlbase' }, $bug->id  );
	my $user = Bugzilla->user;
	my $msg = sprintf( 'New %s :: %s bug %d filed by %s.', $bug->product, $bug->component, $bug->id, $user->name );
	post_grove_msg( $msg );
}

sub bug_end_of_update {
	my ($self, $args) = @_;

	my ($bug, $old_bug, $timestamp, $changes) = 
	@$args{qw(bug old_bug timestamp changes)};

	foreach my $field (keys %$changes) {
		my $used_to_be = $changes->{$field}->[0];
		my $now_it_is  = $changes->{$field}->[1];
	}

	my $old_summary = $old_bug->short_desc;
	my $status_message = 'updated';
	if (my $status_change = $changes->{'bug_status'}) {
		my $old_status = new Bugzilla::Status({ name => $status_change->[0] });
		my $new_status = new Bugzilla::Status({ name => $status_change->[1] });
		if ($new_status->is_open && !$old_status->is_open) {
			$status_message = "re-opened";
		}
		if (!$new_status->is_open && $old_status->is_open) {
			$status_message = "closed";
		}
	}

	my $qa_contact = defined($bug->qa_contact) ? $bug->qa_contact->name : '';
	my $url = sprintf( '%s/show_bug.cgi?id=%d', Bugzilla->params->{ 'urlbase' }, $bug->id  );
	my $msg = sprintf( 'Bug %s %s, %s, %s, %s, %s, %s', $url, $qa_contact, $bug->bug_severity, $bug->priority, $bug->version, $bug->bug_status, $bug->short_desc );
	post_grove_msg( $msg );
}

sub config_add_panels {
    my ($self, $args) = @_;
    
    my $modules = $args->{panel_modules};
    $modules->{NotifyGrove} = "Bugzilla::Extension::NotifyGrove::Config";
}

# This must be the last line of your extension.
__PACKAGE__->NAME;
