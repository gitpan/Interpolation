use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME => 'Interpolation',
	      VERSION => '0.53',
#	      'linkext' => {LINKTYPE => ''},
	      'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
);
