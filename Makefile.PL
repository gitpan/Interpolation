use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME => 'Interpolation',
          'PREREQ_PM' => {'File::DosGlob' => 0},
          'VERSION_FROM' => 'Interpolation.pm', # finds $VERSION
#	      'linkext' => {LINKTYPE => ''},
	      'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
	      AUTHOR => 'Mark-Jason Dominus (mjd@plover.com), Jan Krynicky (Jenda@Krynicky.cz)',
	      ABSTRACT => 'Arbitrary string interpolation semantics',
);
