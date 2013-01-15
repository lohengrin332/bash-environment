#!/usr/bin/perl

use strict;
use Getopt::Long;
use File::Basename;

my @revisions;
my $change;
my $file;
my $revision_string;

my $result = GetOptions(
  "r|revision:i{,}"   =>  \@revisions,
  "c|change:s"        =>  \$change,
);

my $file=$ARGV[0];

#system returns 0 on success, other on failure, so reverse the normal logic here
my $file_exists = (-e $file || !system("svn ls $file > /dev/null 2>&1"));

unless($file_exists) {
  print STDERR "File $file does not exist!\n";
  usage();
  exit;
}

my $file_basename = getpwuid($>).'.'.basename($file);

if(scalar(@revisions) && $change) {
  print STDERR "Cannot include both -r and -c\n";
  usage();
  exit;
}

if($change =~ m/^\d+$/) {
  push(@revisions, $change-1, $change);
}

if($revisions[0] =~ m/^\d+:\d+$/) {
  @revisions = split(/:/, $revisions[0]);
}

my @files_to_compare;
my @tmp_files;
if(!scalar(@revisions)) {
  my $file_to_compare = "/tmp/rev.$$.$file_basename";
  system("/usr/bin/svn cat $file > $file_to_compare");
  push(@files_to_compare, $file_to_compare);
  push(@tmp_files, $file_to_compare);
} elsif($#revisions <= 2) {
  for my $revision(@revisions) {
    if($revision =~ m/^\d+$/) {
      my $file_to_compare = "/tmp/rev.$revision.$file_basename";
      system("/usr/bin/svn cat -r $revision $file > $file_to_compare");
      push(@files_to_compare, $file_to_compare);
      push(@tmp_files, $file_to_compare);
    }
  }
} else {
  print STDERR "Cannot compare more than three revisions.\n";
  usage();
  exit;
}

if(scalar(@files_to_compare) < 2) {
  if(-e $file) {
    push(@files_to_compare, $file);
  } else {
    my $tmp_file = "/tmp/rev.REPO.$file_basename";
    system("/usr/bin/svn cat $file > $tmp_file");
    push(@files_to_compare, $tmp_file);
    push(@tmp_files, $tmp_file);
  }
}

my @cmd = ('vimdiff', @files_to_compare);
#print join(' ', @cmd), "\n\n";
system('vimdiff', @files_to_compare);

for my $tmp_file(@tmp_files) {
  unlink($tmp_file);
}




sub usage {
print STDERR qq{
  Usage: $0 [-r <REVISION_NUMBER>] [-c <REVISION_NUMBER>] <FILE_NAME>
      <REVISION_NUMBER>:  Single revision number to pull for diff against current file, or multiple revision numbers in x:y format.
      <FILE_NAME>:        File to perform the diff on.
      Examples:
          $0 -r 100 my_file.pl:       Compare revision 100 of file my_file.pl with HEAD.
          $0 -r 100 101 my_file.pl:   Compare revision 100 of file my_file.pl with revision 101.
          $0 -c 101 my_file.pl:       Effectively the same as $0 -r 100:101 my_file.pl.
};
}
