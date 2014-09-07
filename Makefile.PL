use 5.010;
use ExtUtils::MakeMaker;

my %eumm_params = (
    NAME              => 'HeliosX::Job::JSON',
    VERSION_FROM      => 'lib/HeliosX/Job/JSON.pm', # finds $VERSION
    LICENSE           => 'artistic_2',    
    PREREQ_PM         => {
                          Helios     => 2.80,
                          JSON::Tiny => 0.49,    	
                         }, # e.g., Module::Name => 1.1
    EXE_FILES         => ['heliosx_job_json_submit'],
    INST_SCRIPT       => 'bin',
);

if ($] >= 5.005) {
	## Add these keywords supported since 5.005
	$eumm_params{ABSTRACT_FROM} = 'lib/HeliosX/Job/JSON.pm';
    $eumm_params{AUTHOR} = 'Andrew Johnson <lajandy at cpan dot org>';
}

if (ExtUtils::MakeMaker->VERSION >= 6.46 ) {
	$eumm_params{META_MERGE} = {
		'meta-spec' => { version => 1.4 },
		resources => {
			repository => 'git://github.com/logicalhelion/heliosx-job-json.git',
		},
	};
}

WriteMakefile(%eumm_params);
