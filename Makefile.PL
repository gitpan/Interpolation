use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME => 'Interpolation',
	      VERSION => '0.50',
#	      'linkext' => {LINKTYPE => ''},
	      'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
);
