#!/usr/bin/perl
$^W = 0;

use lib '..';
use Interpolation;

print "1..34\n";

{
  my $TEST = 1;
  sub check {
    print "not " unless $_[0];
    print "ok $TEST\n";
    $TEST++;
  }
}

import Interpolation N1 => 'null';
check("$N1{1+2}" == 3);
check("$N1{01+2.0}" == 3);
check("$N1{substr('this', 1, 2)}" eq 'hi');
untie %N1;

import Interpolation N2 => 'eval';
check("$N2{1+2}" == 3);
check("$N2{01+2.0}" == 3);
check("$N2{substr('this', 1, 2)}" eq 'hi');
untie %N2;

import Interpolation N3 => 'identity';
check("$N3{1+2}" == 3);
check("$N3{01+2.0}" == 3);
check("$N3{substr('this', 1, 2)}" eq 'hi');
untie %N3;

import Interpolation U1 => 'ucwords';
check("$U1{'the quick brown fox'}" eq 'The Quick Brown Fox');
check("$U1{'i LiVe In CaLgArY, aLbErTa.'}" eq 'I Live In Calgary, Alberta.');
check("$U1{'12 22 33'}" eq '12 22 33');
check("$U1{substr('this', 1, 2)}" eq 'Hi');
untie %U1;

import Interpolation C1 => 'commify';
check("$C1{'the quick brown fox'}" == 0);
check("$C1{123}" eq '123.00'); 
check("$C1{1234}" eq '1,234.00');
check("$C1{12345}" eq '12,345.00');
check("$C1{123456}" eq '123,456.00');
check("$C1{1234567}" eq '1,234,567.00');
check("$C1{10000/7}" eq '1,428.57');
check("$C1{2/3}" eq '0.67'); # Round off correctly?
check("$C1{1_000_000_000 / 3}" eq '333,333,333.33');
untie %C1;

import Interpolation R1 => 'reverse';
check("$R1{'the quick brown fox'}" eq 'xof nworb kciuq eht');
check("$R1{''}" eq '');
untie %R1;

import Interpolation S1 => 'sprintf';
check("$S1{'%.2f'}{7/3}" eq '2.33');
check("$S1{'%04d'}{1}" eq '0001');
check("$S1{'%s'}{'snonk'}" eq 'snonk');
check("$S1{'%d-%d'}{3,4}" eq '3-4');
check("$S1{'%d:%02d:%02d'}{1,7,0}" eq '1:07:00');
untie %S1;

import Interpolation S2 => 'sprintf1';
check("$S2{'%.2f', 7/3}" eq '2.33');
check("$S2{'%04d', 1}" eq '0001');
check("$S2{'%s','snonk'}" eq 'snonk');
check("$S2{'%d-%d',3,4}" eq '3-4');
check("$S2{'%d:%02d:%02d',1,7,0}" eq '1:07:00');
untie %S2;
