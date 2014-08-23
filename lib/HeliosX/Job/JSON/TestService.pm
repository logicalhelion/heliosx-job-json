package HeliosX::Job::JSON::TestService;

use 5.010;
use strict;
use warnings;
use parent 'Helios::Service';

use Helios::Config;
use Helios::LogEntry::Levels qw(:all);
use HeliosX::Job::JSON;

our $VERSION = '0.01_3460';

sub JobClass { 'HeliosX::Job::JSON' }

sub run {
	my $self = shift;
	my $job = shift;
	my $config = $self->getConfig();
	my $args = $self->getJobArgs($job);
	
	eval {
		$self->logMsg($job, LOG_INFO, __PACKAGE__." says 'Hello World!'");
		foreach (keys %$args) {
			$self->logMsg($job, LOG_INFO, 'ARG: '.$_.' VALUE: '.$args->{$_});
		}
		
		$self->completedJob($job);
		1;
	} or do {
		my $E = $@;
		$self->logMsg($job, LOG_ERR, "ERROR: $E");
		$self->failedJob($job, $E);
	};
	
}



1;
__END__
