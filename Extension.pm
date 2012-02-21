# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::NotifyGrove;
use strict;
use base qw(Bugzilla::Extension);

use Bugzilla::Field;
use Bugzilla::User;
use Bugzilla::Extension::NotifyGrove::Util;

our $VERSION = '0.1';

sub bug_end_of_create {
	my ($self, $args) = @_;

	my $bug = $args->{'bug'};
	my $msg = sprintf( 'New %s :: %s bug %d filed by %s.', 
		$bug->product, 
		$bug->component, 
		$bug->id, 
		Bugzilla->user->name );
	post_grove_msg( $msg );
}

sub bug_end_of_update {
	my ($self, $args) = @_;

	my ($bug, $old_bug, $timestamp, $changes) = @$args{qw(bug old_bug timestamp changes)};

	# report specific field field changes
	foreach my $field_name (keys %$changes) {
		my $changed_field = new Bugzilla::Field({name => $field_name});
		# only look for certain fields
		if ( $changed_field->name eq 'bug_status' 
			or $changed_field->name eq 'priority' 
			or $changed_field->name eq 'bug_severity' 
			or $changed_field->name eq 'target_milestone' )
		{
			my $used_to_be = $changes->{$field_name}->[0];
			my $now_it_is  = $changes->{$field_name}->[1];
			my $msg = sprintf( '%s changed %s on bug %d from %s to %s.', 
				Bugzilla->user->name, 
				$changed_field->description, 
				$bug->id, 
				$used_to_be, 
				$now_it_is ); 
			post_grove_msg( $msg );
		}
	}

	# report  bug changes
	my $bug_url = sprintf( '%s/show_bug.cgi?id=%d', Bugzilla->params->{ 'urlbase' }, $bug->id  );
	my $qa_contact = defined($bug->qa_contact) ? $bug->qa_contact->name : '';
	my $msg = sprintf( 'Bug %s %s, %s, %s, %s, %s, %s, %s', 
		$bug_url, 
		$bug->bug_status, 
		$bug->target_milestone, 
		$qa_contact, 
		$bug->bug_severity, 
		$bug->priority, 
		$bug->version, 
		$bug->short_desc );
	post_grove_msg( $msg );
}

sub config_add_panels {
    my ($self, $args) = @_;
    
    my $modules = $args->{panel_modules};
    $modules->{NotifyGrove} = "Bugzilla::Extension::NotifyGrove::Config";
}

# This must be the last line of your extension.
__PACKAGE__->NAME;
