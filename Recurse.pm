# ----------------------------------------------------------------------------
# Name: File::Recurse.pm
# Auth: Dion Almaer (dion)
# Desc: Module for Recursing directories and returning a datastructure
# Date Created: Sun Nov 15 17:50:29 1998
# Version: 0.11
# $Modified: Wed Nov 18 16:55:46 CST 1998 by dion $
# ----------------------------------------------------------------------------
package File::Recurse;
require 5.002;
require Exporter;
use     strict;
use     File::Find;

# ----------------------------------------------------------------------------
#              Package Variables
# ----------------------------------------------------------------------------
@File::Recurse::ISA       = qw(Exporter);
@File::Recurse::EXPORT    = qw(Recurse);
$File::Recurse::VERSION   = '0.11';

my %files; # The has that stores the dir => files

# ----------------------------------------------------------------------------
#              Module Subroutines
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# Subroutine : Recurse - given the directory aref and rulesref go for it
# ----------------------------------------------------------------------------
sub Recurse {
  my $dirsref  = shift || die 'Recurse: Need an array reference of dirs';
  my $rulesref = shift;
  %files       = (); # -- reset the global variable

  # -- Set the rules to a hash that &wanted can access
  %File::Recurse::RULES = %{ $rulesref };

  # -- Process it all
  finddepth(\&File::Recurse::wanted, @{ $dirsref });

  return %files;
}

# ----------------------------------------------------------------------------
# Subroutine: wanted - used by File::Find
# ----------------------------------------------------------------------------
sub wanted {
  return if -d $File::Find::name;
  return 
      if $File::Recurse::RULES{ignore} && -e '.ignore_index';

  # -- If there is a rule to 'match' a regex then look for it in the file
  if (exists $File::Recurse::RULES{match}) {
      return unless $File::Find::name =~ /$File::Recurse::RULES{match}/;
  }

  # -- If there is a rule to 'not match' a regex then look for it in the file
  if (exists $File::Recurse::RULES{nomatch}) {
      return if $File::Find::name =~ /$File::Recurse::RULES{nomatch}/;
  }
  
  push(@{ $files{$File::Find::dir} }, $_);
}

# ----------------------------------------------------------------------------
1; # End of File::Recurse.pm
# ----------------------------------------------------------------------------

__END__

=pod

=head1 NAME

File::Recurse.pm - Module for Recursing directories

=head1 DESCRIPTION

This module is used to recurse directory structures and saving the data
into a hash of array references.
You can give it certain rules (e.g. '.gif' will match only *.gif files)
and you can make it check for a '.ignore_index' file in that directory
to make it ignore.

=head1 SYNOPSIS

o %hash = B<Recurse>(\@dirs, \%rules)

  Go through the @dirs and apply any rules from %rules. It will return
  a %hash where the keys are directories, and the values are the files
  in that directory in an array.

  e.g. $hash{'/usr/local/bin'} = [ 'ls', 'irc', ... ];

=head1 RULES

 In the rules hash you can have

 match => regex file pattern,    [e.g. match => '\.gif']
 nomatch => regex file pattern,  [e.g. nomatch => 's\.txt']
 ignore => 1|0                   [e.g. ignore => 1]

 note: if you send '.gif' that will look for any token next to gif and
       '\.gif' is probably what you are looking for

=head1 EXAMPLE

Here is an example program that would output all the files in directories
starting from /tmp that have a period somewhere in the name,
and isn't a .gif file

use File::Recurse;

my %files = Recurse(['/tmp'], {match => '\.', nomatch => '\.html$'});

foreach (sort keys %files) {
   print "Dir: $_\n";
   foreach (@{ $files{$_} }) {
    print " File: $_\n";
   }
}

=head1 AUTHOR

Dion Almaer (dion@member.com)

=cut

