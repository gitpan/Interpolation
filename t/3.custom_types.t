#!/usr/bin/perl
use warnings;
no warnings 'untie';

#use lib '..';
use Interpolation;

print "Interpolation.pm ver. $Interpolation::VERSION\n1..31\n";

{
  my $TEST = 1;
  sub check {
    print "not " unless $_[0];
    print "ok $TEST\n";
    $TEST++;
  }
}

print "Testing Interpolation::Scalar ('name:->\$' => ...)\n";
{	my $count = 0;
	import Interpolation 'count:->$' => sub {if (@_) {$count = $_[0]} else {$count++}};
}
check("$count" == 0);
check("$count" == 1);
check("$count" == 2);
$count = 50;
check("$count" == 50);
check("$count" == 51);
untie $count;

print "Testing Interpolation ('name:\$->\$' => ...)\n";
{	my %count;
	import Interpolation 'count:$->$' => sub {
		if (@_ == 2) {
			$count{$_[0]} = $_[1]
		} else {
			$count{$_[0]}++
		}
	};
}
check("$count{a}" == 0);
check("$count{a}" == 1);
check("$count{a}" == 2);
check("$count{b}" == 0);
check("$count{b}" == 1);
$count{a} = 50;
check("$count{a}" == 50);
check("$count{a}" == 51);
check("$count{b}" == 2);
untie %count;

print "Testing Interpolation ('name:\$->\@' => ...)\n";
import Interpolation 'list:$->@' => sub { (1..$_[0]) };
check("$list{3}" eq "1 2 3");
check("$list{5}" eq "1 2 3 4 5");
untie %list;

print "Testing Interpolation ('name:\$->\@' => ...) assignment\n";
{	my %List;
	import Interpolation 'list:$->@' => sub {
		if (@_ == 2) {
			$List{$_[0]} = $_[1];
			0 .. $List{$_[0]};
		} else {
			0 .. $List{$_[0]}++;
		}
	};
}
check("$list{a}" eq "0");
check("$list{a}" eq "0 1");
check("$list{a}" eq "0 1 2");
$list{a} = 5;
check("$list{a}" eq "0 1 2 3 4 5");
untie %list;

print "Testing Interpolation ('name:\@->\$' => ...)\n";
import Interpolation 'sum:@->$' => sub {
	my $sum = 0;
	$sum += $_ for @_;
	return $sum;
};
check("$sum{1}" == 1);
check("$sum{2,3}" == 5);
check("$sum{5,1,2,8}" == 16);
untie %sum;

print "Testing Interpolation ('name:\@->\@' => ...)\n";
import Interpolation 'reverse:@->@' => sub {
	return reverse(@_);
};
check("$reverse{2,3}" eq "3 2");
check("$reverse{5,1,2,8}" eq "8 2 1 5");
untie %reverse;

print "Testing Interpolation ('name:\$*->\$' => ...)\n";
import Interpolation 'sum:$*->$' => sub {
	my $sum = 0;
	$sum += $_ for @_;
	return $sum;
};
check("$sum{1}" == 1);
check("$sum{2}{3}" == 5);
check("$sum{5}{1}{2}{8}" == 16);
check("$sum{5}{1}{2}{8}{$;}" == 16);
untie %sum;

print "Testing Interpolation ('name:\\\@*->\$' => ...)\n";
import Interpolation 'reverse:\@*->$' => sub {
	my $result = '';
	for (@_) {
		$result .= '(' . join(',', reverse @$_) . ')';
	}
	return $result;
};
check("$reverse{2,3}" eq "(3,2)");
check("$reverse{5,1}{2,8}" eq "(1,5)(8,2)");
check("$reverse{5,1}{9}{2,8}" eq "(1,5)(9)(8,2)");
untie %reverse;
