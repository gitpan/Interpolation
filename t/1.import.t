#!/usr/bin/perl

# Test use, import, unimport, tie, untie


#use lib '..';
use Interpolation N1 => 'null';

print "Interpolation.pm ver. $Interpolation::VERSION\n1..10\n";

{
  my $TEST = 1;
  sub check {
    print "not " unless $_[0];
    print "ok $TEST\n";
    $TEST++;
  }
}

# Use
check("$N1{1+2}" eq "3");
check("$N1{substr('this', 1, 2)}" eq "hi");

# `no' doesn't work and can't be made to work;
# at present its effects can't be made to have lexical
# scope, and they always occur at compile time.  So
# `no' is useless.
# {
#   no Interpolation N1;
#   check("$N1{1+2}" eq "");
#   check("$N1{substr('this', 1, 2)}" eq "");
# }

# import
import Interpolation N2 => 'eval';
check("$N2{1+2}" eq "3");
check("$N2{substr('this', 1, 2)}" eq "hi");

# unimport
{
  local $^W = 0;		# Suppress `undefined value' warnings
  unimport Interpolation N2;
  check("$N2{1+2}" eq "");
  check("$N2{substr('this', 1, 2)}" eq "");
}

# tie
tie %N3, Interpolation, sub {$_[0]} or die;
check("$N3{1+2}" eq "3");
check("$N3{substr('this', 1, 2)}" eq "hi");

# untie
{
  local($^W) = 0;   # Suppress `undefined value' warnings
  untie %N3;
  check("$N3{1+2}" eq "");
  check("$N3{substr('this', 1, 2)}" eq "");
}
