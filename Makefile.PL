use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME => 'Interpolation',
          'PREREQ_PM' => {},
          'VERSION_FROM' => 'Interpolation.pm', # finds $VERSION
#	      'linkext' => {LINKTYPE => ''},
	      'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
	      AUTHOR => 'Jan Krynicky (Jenda@Krynicky.cz), Mark-Jason Dominus (mjd@plover.com)',
	      ABSTRACT => 'Arbitrary string interpolation semantics (using tie())',
);
