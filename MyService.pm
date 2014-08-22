use 5.016;
use strict;
use warnings;
use HeliosX::Job::JSON;

package MyService {
	use parent 'Helios::TestService';
	sub JobClass { 'HeliosX::Job::JSON' }

}

1;
__END__
