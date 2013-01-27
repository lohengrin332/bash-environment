#!/usr/bin/perl -I /home/davidl/code/

use strict;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use Utils::Conf;
use Carp qw{cluck};
#&Getopt::Long::Configure("bundling");

my $help=0;
my $check;
my $scan;
my $config;
my $movie_title;
my $encoding;
my $longest;
my @rip_titles;
my @rip_chapters;
our $target_dir = '/opt/storage/movies/';
my $tmp_dir = '/home/davidl/rips/';
my $hb_command = '/usr/bin/sudo /home/davidl/bin/HandBrakeCLI';
#my $hb_command = '/home/davidl/bin/HandBrakeCLI';
my $debug=0;

&GetOptions (
  "h|help"          =>  \$help,
  "c|check"         =>  \$check,
  "s|scan"          =>  \$scan,
  "f|config=s"      =>  \$config,
  "n|name=s"        =>  \$movie_title,
  "e|encoding=s"    =>  \$encoding,
  "l|longest"       =>  \$longest,
  "t|titles=s{,}"   =>  \@rip_titles,
  "p|chapters=s{,}" =>  \@rip_chapters,
  "d|debug"         =>  \$debug,
) || pod2usage(2);

pod2usage(1) if $help;

my $disc_title = &get_title();
if($check) {
  print "Disc Title: '$disc_title'\n";
  exit;
}

if($scan) {
  my @scan_data = `$hb_command -i /dev/dvd --title 0 2>&1`;
  chomp(@scan_data);
  open(SCAN_DATA, '>/var/tmp/scan_output.txt');
  print SCAN_DATA join("\n", @scan_data), "\n";
  close SCAN_DATA;
  my @print_data = grep(/\+ title|\+ duration|\+ chapters|: cells/, @scan_data);
  print join("\n", @print_data), "\n";
  exit;
}

unless($movie_title || $disc_title || -r $config) {
  pod2usage(1);
}

{
  $movie_title = $disc_title unless($movie_title);
  #$movie_title =~ s/\s\+/\\ /g;
  #print "|$movie_title|\n";

  @rip_titles   = &get_ranges(@rip_titles);
  @rip_chapters = &get_ranges(@rip_chapters);

  my $chapter_options;
  if($#rip_chapters != -1) {
    $chapter_options = '--chapter '.join(',', @rip_chapters);
  }

  if($config && -r $config) {
    my $err = Utils::Conf::read_conf($config, 'CFG');
    our @rips = @CFG::rips;
    #todo: Loop through process w/ rips as config values.  Default to CL specified values.
    my %defaults;
    $defaults{encoding} = $encoding;
    $defaults{title} = join(',', @rip_titles) if $#rip_titles;
    $defaults{longest} = $longest;
    $defaults{chapter_options} = join(',', @rip_chapters) if $#rip_chapters;
    $defaults{name} = $movie_title;
    for my $rip(@rips) {
      for my $k(keys %defaults) {
        unless($defaults{$k} eq '' || defined($$rip{$k})) {
          $$rip{$k} = $defaults{$k};
        }
      }
      &rip_data($rip);
    }
  } else {
    my %settings;
    $settings{encoding} = $encoding;
    $settings{title} = join(',', @rip_titles) if $#rip_titles;
    $settings{longest} = $longest;
    $settings{chapter_options} = join(',', @rip_chapters) if $#rip_chapters;
    $settings{name} = $movie_title;
    &rip_data(\%settings);
  }
}

sub get_title {
  if(-e '/mnt/dvd/disc.id') {
    open(DISC_ID, '</mnt/dvd/disc.id');
    my @disc_id = <DISC_ID>;
    chomp(@disc_id);
    my $line = (grep(/name/, @disc_id))[0];
    $line =~ s/^name=(.*)$/\1/;
    $line =~ s/\s+$//;
    $line =~ s/[^M,]//g;
    $line =~ s/\s+/_/g;
    return $line;
  } else {
    return undef;
  }
}

sub rip_data {
  my ($rc) = @_;
  my %rip_data = %{$rc};
  #my $encoding_options = '-d fast -O -I -T -Z PS3 -2';
  my $encoding_options = '-d fast -O -T -2 -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
  my $longest_option;
  my $chapter_options;
  my $title_option;
  my $name;
  if(exists($rip_data{encoding}) && $rip_data{encoding} ne '') {
         if($rip_data{encoding} eq 'medium') {
      $encoding_options='-d fast -O -T -e x264 -f mp4 -x level=41:subme=5:me=umh -2';
    } elsif($rip_data{encoding} eq 'fast') {
      $encoding_options='-d fast -O';
    } elsif($rip_data{encoding} eq 'iPhone') {
      $encoding_options='-d fast -O -I -T -Z iPhone -2';
      $target_dir .= 'iPhone/';
    } elsif($rip_data{encoding} eq 'normal') {
      $encoding_options='-d fast -O -I -Z Normal';
    } elsif($rip_data{encoding} eq 'PS3') {
      $encoding_options = '-d fast -O -I -T -Z PS3 -2';
    } elsif($rip_data{encoding} eq 'slow-minusO') {
      $encoding_options='-d fast -T -2 -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
    } elsif($rip_data{encoding} eq 'slow-minusT') {
      $encoding_options='-d fast -O -2 -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
    } elsif($rip_data{encoding} eq 'slow-minusBoth') {
      $encoding_options='-d fast -2 -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
    } elsif($rip_data{encoding} eq 'slow-minus2T') {
      $encoding_options='-d fast -O -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
    } elsif($rip_data{encoding} eq 'slow-minusAll') {
      $encoding_options='-d fast -e x264 -b 2500 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 --crop 0:0:0:0 -x level=41:me=umh';
    }
  }
  if(exists($rip_data{title}) && $rip_data{title} ne '') {
    $title_option = "--title $rip_data{title}";
  }
  if(exists($rip_data{longest}) && $rip_data{longest}) {
    $longest_option = '-L';
  }
  if(exists($rip_data{chapter_options}) && $rip_data{chapter_options}) {
    $chapter_options = "--chapter $rip_data{chapter_options}";
  }
  if(exists($rip_data{name}) && $rip_data{name} ne '') {
    $name = $rip_data{name};
  } else {
    print "Missing title information, skipping\n";
    return 0;
  }
  my @cmd = (split(/ /, "$hb_command $encoding_options $longest_option $chapter_options $title_option -i /dev/dvd 2>&1 -o"), "$tmp_dir/$name.mp4");
  #print join("|", @cmd)."\n\n";
  system(@cmd);
  @cmd = (split(/ /, "/usr/bin/sudo /bin/chown davidl.users"), "$tmp_dir/$name.mp4");
  system(@cmd);
  rename("$tmp_dir/$name.mp4", "$target_dir/$name.mp4") || cluck(qq{rename("$tmp_dir/$name.mp4", "$target_dir/$name.mp4"): ($!)});
}

sub get_ranges {
  my @ranges = @_;
  my @new_ranges;
  @ranges = split(/,\s*/, join(',', @ranges));
  for my $r(@ranges) {
    if($r =~ m/^\d+-\d+$/) {
      my ($b, $e) = split(/-/, $r);
      if($b<$e) {
        push(@new_ranges, ($b..$e));
      } else {
        push(@new_ranges, reverse($e..$b));
      }
    } else {
      push(@new_ranges, $r);
    }
  }
  return @new_ranges;
}


__END__

=head1 NAME

ripdvd.pl - Rip movie data from /dev/dvd to files specified according to options provided

=head1 SYNOPSIS

ripdvd.pl [options]

=head1 OPTIONS

=over 4

=item B<-h|--help>

Print this help and exit

=item B<-c|--check>

Check DVD for movie title information

=item B<-s|--scan>

Scan DVD for DVD title/chapter information

=item B<-f|--config>

Read in specified config file

=item B<-n|--name> = <string>

Manually specify a file name for the ripped movie. This is required for unsupported media types

=item B<-e|--encoding> = [iPhone|fast|medium|slow]

Specify encoding type

=over 4

=item [iPhone]

Good picture quality, pre-configured for export to iPhone

=item [fast]

Low picture quality, fast encoding time, small file

=item [medium]

Better picture quality, slower encoding time, small file

=item [slow] (default)

Best picture quality, slowest encoding time, large file

=back

=item B<-l|--longest>

Rip longest title

=item B<-t|--titles> = <VALUES>

Comma separated list of titles to rip. Example: 1,2,5-7,10-8

=item B<-p|--chapters> = <VALUES>

Comma separated list of chapters to rip. Example: 1,2,5-7,10-8

=item B<-d|--debug>

Unimplemented

=back

=head1 DESCRIPTION

B<This program> is awesome.

=cut
