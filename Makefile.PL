use ExtUtils::MakeMaker;

print "Checking for File::Find..";
eval {
    require File::Find;
};
if ($@) {
    print " failed\n";
    print <<EOT;
$@
File::Recurse uses File::Find. Find it, install it.
EOT
    sleep(2);  # Don't hurry too much
} else {
    print " ok\n";
}

WriteMakefile(NAME => 'File::Recurse',
              dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
              VERSION_FROM => 'Recurse.pm');
