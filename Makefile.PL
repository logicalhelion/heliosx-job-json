use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'HeliosX::Job::JSON',
    VERSION_FROM      => 'lib/HeliosX/Job/JSON.pm', # finds $VERSION
    LICENSE           => 'artistic_2',    
    PREREQ_PM         => {
                          Helios     => 2.80,
                          JSON::Tiny => 0.49,    	
                         }, # e.g., Module::Name => 1.1
    EXE_FILES         => ['helios_job_submit_json'],
    INST_SCRIPT       => 'bin',
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/HeliosX/Job/JSON.pm', # retrieve abstract from module
       AUTHOR         => 'Andrew Johnson <lajandy at cpan dot org>') : ()),

	(ExtUtils::MakeMaker->VERSION >= 6.46 ? 
		(
			META_MERGE => 
			{
				'meta-spec' => { version => 1.4 },
				resources => 
				{
					repository => 'git://github.com/logicalhelion/heliosx-job-json.git',
				},
			},    	
    	) 
    	: ()
    ),

);
