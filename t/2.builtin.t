#!/usr/bin/perl
use warnings;
no warnings 'untie';

#use lib '..';
use Interpolation;

print "Interpolation.pm ver. $Interpolation::VERSION\n1..48\n";

{
  my $TEST = 1;
  sub check {
    print "not " unless $_[0];
    print "ok $TEST\n";
    $TEST++;
  }
}

print "Testing 'null'\n";
import Interpolation N1 => 'null';
check("$N1{1+2}" == 3);
check("$N1{01+2.0}" == 3);
check("$N1{substr('this', 1, 2)}" eq 'hi');
untie %N1;

print "\nTesting 'eval'\n";
import Interpolation N2 => 'eval';
check("$N2{1+2}" == 3);
check("$N2{01+2.0}" == 3);
check("$N2{substr('this', 1, 2)}" eq 'hi');
untie %N2;

print "\nTesting 'identity'\n";
import Interpolation N3 => 'identity';
check("$N3{1+2}" == 3);
check("$N3{01+2.0}" == 3);
check("$N3{substr('this', 1, 2)}" eq 'hi');
untie %N3;

print "\nTesting 'ucwords'\n";
import Interpolation U1 => 'ucwords';
check("$U1{'the quick brown fox'}" eq 'The Quick Brown Fox');
check("$U1{'i LiVe In CaLgArY, aLbErTa.'}" eq 'I Live In Calgary, Alberta.');
check("$U1{'12 22 33'}" eq '12 22 33');
check("$U1{substr('this', 1, 2)}" eq 'Hi');
untie %U1;

print "\nTesting 'commify'\n";
import Interpolation C1 => 'commify';

$SIG{__WARN__} = sub { # catch the warning
	print STDERR $_[0]
		if ($_[0] !~ m/^Argument "the quick brown fox" isn't numeric in sprintf/);
};
check("$C1{'the quick brown fox'}" == 0);
delete $SIG{__WARN__}; # stop catching warnings

check("$C1{123}" eq '123.00');
check("$C1{1234}" eq '1,234.00');
check("$C1{12345}" eq '12,345.00');
check("$C1{123456}" eq '123,456.00');
check("$C1{1234567}" eq '1,234,567.00');
check("$C1{10000/7}" eq '1,428.57');
check("$C1{2/3}" eq '0.67'); # Round off correctly?
check("$C1{1_000_000_000 / 3}" eq '333,333,333.33');
untie %C1;

print "\nTesting 'reverse'\n";
import Interpolation R1 => 'reverse';
check("$R1{'the quick brown fox'}" eq 'xof nworb kciuq eht');
check("$R1{''}" eq '');
untie %R1;

print "\nTesting 'sprintf'\n";
import Interpolation S1 => 'sprintf';
check("$S1{'%.2f'}{7/3}" eq '2.33');
check("$S1{'%04d'}{1}" eq '0001');
check("$S1{'%s'}{'snonk'}" eq 'snonk');
check("$S1{'%d-%d'}{3,4}" eq '3-4');
check("$S1{'%d:%02d:%02d'}{1,7,0}" eq '1:07:00');
untie %S1;

print "\nTesting 'sprintf1'\n";
import Interpolation S2 => 'sprintf1';
check("$S2{'%.2f', 7/3}" eq '2.33');
check("$S2{'%04d', 1}" eq '0001');
check("$S2{'%s','snonk'}" eq 'snonk');
check("$S2{'%d-%d',3,4}" eq '3-4');
check("$S2{'%d:%02d:%02d',1,7,0}" eq '1:07:00');
untie %S2;

print "\nTesting 'sprintfx'\n";
import Interpolation 'S3:$$*->$' => 'sprintfx';
check("$S3{'%.2f'}{7/3}" eq '2.33');
check("$S3{'%04d'}{1}" eq '0001');
check("$S3{'%s'}{'snonk'}" eq 'snonk');
check("$S3{'%d-%d'}{3}{4}" eq '3-4');
check("$S3{'%d:%02d:%02d'}{1}{7}{0}" eq '1:07:00');
untie %S3;

print "\nTesting 'sqlescape'\n";
import Interpolation Q1 => 'sqlescape';
check("$Q1{'hello'}" eq "'hello"); # keep in mind that the sqlescape adds a quote in front of the text, but not at the end!
check(qq{$Q1{"d'Artagnan"}} eq "'d''Artagnan");
untie %Q1;

print "\nTesting 'htmlescape'\n";
import Interpolation H1 => 'htmlescape';
check("$H1{'hello'}" eq 'hello');
check("$H1{'1 < 2'}" eq '1 &lt; 2');
check("$H1{'you & me'}" eq 'you &amp; me');
check(qq{$H1{'I said: "Hello".'}} eq 'I said: "Hello".');
untie %H1;

print "\nTesting 'tagescape'\n";
import Interpolation H2 => 'tagescape';
check("$H2{'hello'}" eq 'hello');
check("$H2{'1 < 2'}" eq '1 &lt; 2');
check("$H2{'you & me'}" eq 'you &amp; me');
check(qq{$H2{'I said: "Hello".'}} eq 'I said: &quot;Hello&quot;.');
untie %H2;

print "\nTesting 'jsescape'\n";
import Interpolation H3 => 'JSescape';
check("$H3{'hello'}" eq 'hello');
check("$H3{'1 < 2'}" eq '1 &lt; 2');
check("$H3{'you & me'}" eq 'you &amp; me');
check(qq{$H3{'I said: "Hello".'}} eq 'I said: \&quot;Hello\&quot;.');
untie %H3;

