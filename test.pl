#!/usr/local/bin/perl5.004

use File::Recurse;
BEGIN { print "1..2\n"; }

my %files = Recurse(['test'],{match=> '\.', nomatch=> '\.html$', ignore => 1});
my $r1 = (scalar keys %files == 2) ? "ok 1\n" : "not ok 1\n";
print $r1;

%files = Recurse(['test'],{match=> '\.', nomatch=> '\.html$', ignore => 0});
my $r2 = (scalar keys %files == 3) ? "ok 2\n" : "not ok 2\n";
print $r2;
