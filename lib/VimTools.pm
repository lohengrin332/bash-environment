package VimTools;

use strict;


sub loadSourceFile {
  my $line = _getCurrString();
  my @files = &VimTools::_splitOnUse($line);
  if(scalar(@files)) {
    VIM::DoCommand(":TlistAddFiles @files");
  }
  VIM::DoCommand(":TlistOpen");
}

sub openSourceFile {
  my $line = _getCurrString();
  my @files = &VimTools::_splitOnUse($line);
  if(scalar(@files)) {
    for my $file(@files) {
      VIM::DoCommand(":tabe $file");
    }
  }
}

sub _getCurrString {
  my ($row, undef) = $main::curwin->Cursor();
  my $line = $main::curbuf->Get($row);
  #VIM::Msg($line);
  return $line;
}

sub _splitOnUse {
  my ($string) = @_;
  my @matches;
  $string =~ s/(use|require)\s+parent/\1 /g;
  while($string =~ m/(use|require)\s+q*['"({#\[]*([\w_:]+)['")}#\]]*/) {
    my $match = $2;
    my $file = _findFile($match);
    if($file) {
      unshift(@matches, $file);
    }
    $string =~ m/$match(.*$)/;
    $string = $1;
  }
  return @matches;
}

sub _findFile {
  my ($string) = @_;
  unless($string eq '') {
    my @fileNames = _prepFileName($string);
    my @include = _getINC();
    for my $inc(@include) {
      for my $file(@fileNames) {
        if(-f "$inc/$file") {
          return "$inc/$file";
        }
      }
    }
  }
  return undef;
}

sub _prepFileName {
  my ($string) = @_;
  my @str = split(/::/, $string);
  my $fullString = join('/', @str).'.pm';
  pop(@str);
  my $shortString = join('/', @str).'.pm';
  return($fullString, $shortString);
}

sub _getINC {
  if($ENV{MBX_ROOT} && -e "$ENV{MBX_ROOT}/utils/mbxperl") {
    my @MBX_INC = split(',', `\$MBX_ROOT/utils/mbxperl -e 'print join(",", \@INC);'`);
    my $vms_dir = "$ENV{MBX_ROOT}/$ENV{VMS_BRANCH}/lib";
    unshift(@MBX_INC, $vms_dir), if(-e $vms_dir);
    return @MBX_INC;
  } else {
    return @INC;
  }
}


1;
