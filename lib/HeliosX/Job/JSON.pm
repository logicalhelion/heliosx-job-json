package HeliosX::Job::JSON;

use 5.008;
use strict;
use warnings;
use base 'Helios::Job';

use JSON::Tiny qw(decode_json);
$JSON::Tiny::TRUE  = 1;
$JSON::Tiny::FALSE = 0;

use HeliosX::Job::JSON::Error;

our $VERSION = '0.01_3460';

=head1 NAME

HeliosX::Job::JSON - Helios::Job subclass using JSON to specify job arguments

=head1 SYNOPSIS

 # in your Helios::Service class
 package MyService;
 use parent 'Helios::Service';
 use HeliosX::Job::JSON;
 
 sub JobClass { 'HeliosX::Job::JSON' }
 
 sub run {
 	... run code here ... 
 }
 
 1;
 
 # in your job submission code, use HeliosX::Job::JSON just like Helios::Job
 my $config = Helios::Config->parseConfig();
 my $arg_json = qq/{ "args" : { "arg1": "value1", "arg2": "string2" } }/; 
 my $job = HeliosX::Job::JSON->new();
 $job->setConfig($config);
 $job->setJobType('MyService');
 $job->setArgString($arg_json);
 my $jobid = $job->submit();
 
 # or use the included helios_job_submit_json command 
 helios_job_submit_json MyService '{ "args" : { "arg1": "value1", "arg2": "string2" } }'


=head1 DESCRIPTION

HeliosX::Job::JSON is a Helios::Job subclass allowing you to specify Helios 
job arguments in JSON format instead of Helios's default XML format.  If parts 
of your application or system use the JSON data format, or your Helios job 
arguments are difficult to express in XML, you can change your Helios service 
to use HeliosX::Job::JSON to specify your job arguments in JSON.  

=head1 JSON JOB ARGUMENT FORMAT

To specify a Helios job's arguments in JSON, use the following JSON object 
as an example: 

 {
     "jobtype" : "Helios::TestService",
     "args": {
         "arg1"          : "value1",
         "arg2"          : "value2",
         "original_file" : "photo.jpg",
         "size"          : "125x125"
     }
 }

Your JSON object will define a "jobtype" string and an "args" object.  The 
name and value pairs of the args object will become the job's argument hash.

The jobtype value is optional if you specify a jobtype another way i.e. using 
the --jobtype option with helios_job_submit_json or using HeliosX::Job::JSON's 
setJobType() method.

=head1 NOTE ABOUT METAJOBS

HeliosX::Job::JSON does not yet support Helios metajobs.  Specifying metajob 
arguments in JSON may be supported in a future release.

=head1 METHODS

=head2 parseArgs()

HeliosX::Job::JSON's parseArgs() method is much simpler than Helios::Job's 
because JSON's object format is very close to Perl's concept of a hash.  
 
=cut

sub parseArgs {
	my $self = shift;
	my $arg_string = $self->job()->arg()->[0];

	my $args_hash = $self->parseArgString($arg_string);

	unless ( defined($args_hash->{args}) ) {
		HeliosX::Job::JSON::Error->throw("HeliosX::Job::JSON->parseArgs(): args object is missing!");
	}

	my $args = $args_hash->{args};
	
	$self->setArgs( $args );
	return $args;
}


=head2 parseArgString($json_string)

The parseArgString() method does the actual parsing of the JSON object string 
into the Perl hash using JSON::Tiny.  

=cut

sub parseArgString {
	my $self = shift;
	my $arg_string = shift;
	
	my $arg_hash;
	eval {
		$arg_hash = decode_json($arg_string);
		1;		
	} or do {
		my $E = $@;
		HeliosX::Job::JSON::Error->throw("HeliosX::Job::JSON->parseArgString(): $E");
	};
	return $arg_hash;		
}


=head2 submit() 

HeliosX::Job::JSON's submit() method is actually a shell around Helios::Job's 
submit() to allow specifying the jobtype via the JSON object instead of 
requiring a separate call to setJobType().  If the jobtype wasn't explicitly 
specified and submit() cannot determine the jobtype from the JSON object, 
it will throw a HeliosX::Job::JSON::Error exception.

=cut

sub submit {
	my $self = shift;
	
	# if setJobType() wasn't used to specify the jobtype
	# try to get it from the JSON object
	# ugh: we're exposing some of Helios::Job's guts here :(
	unless ( $self->job()->{__funcname} ) {
		my $args = $self->parseArgString( $self->getArgString() );
		if ( defined($args->{jobtype}) ){
			$self->setJobType( $args->{jobtype} );
		} else {
			# uhoh, if the JSON object didn't have the jobtype,
			# and the user didn't use setJobType(),
			# we can't submit!!
			HeliosX::Job::JSON::Error->throw("HeliosX::Job::JSON::Error->throw(): No jobtype specified!");
		}
	}
	
	return $self->SUPER::submit();
}


1;
__END__

=head1 SEE ALSO

L<Helios>, L<Helios::Job>, L<JSON::Tiny>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dot orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify it under 
the terms of the Artistic License 2.0.  See the included LICENSE file for 
details.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

