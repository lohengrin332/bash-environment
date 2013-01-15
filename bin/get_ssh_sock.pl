#!/usr/bin/perl

use strict;
use Data::Dumper;

my $current_agent_file = $ENV{SSH_AUTH_SOCK};
my $agent_file = (-e $current_agent_file) ? $current_agent_file : &getAgentForPID();

print "$agent_file";



sub getAgentForPID {
  my $pid = shift;
  $pid = $pid ? $pid : $$;
  #print STDERR "getAgentForPID ($pid)\n";
  my $ssh_process_pid = &getTopParentForPID($pid);
  my $user = getpwuid($<);
  my $find_command = "/usr/bin/find /tmp/ -maxdepth 1 -type d -name ssh-\\* -user $user";
  my @dirs = `$find_command`;
  chomp(@dirs);
  my $first_ssh_agent_file = '';
  for my $dir(@dirs) {
    next unless(-d $dir);
    my $ssh_agent_file = "$dir/agent.$ssh_process_pid";
    return $ssh_agent_file if(-e $ssh_agent_file);
    unless(-e $first_ssh_agent_file) {
      my @ls = `ls $dir/agent.*`;
      chomp(@ls);
      my ($dir, $pid) = split('agent.', $ls[0]);
      $first_ssh_agent_file = $ls[0] if(&psForPID($pid));
    }
  }
  #none exists for given PID, pull first off list
  return $first_ssh_agent_file;
}

sub getTopParentForPID {
  my $pid = shift;
  $pid = $pid ? $pid : $$;
  #print STDERR "getTopParentForPID ($pid)\n";
  return 0 unless(-e "/proc/$pid/stat");
  my $UID = $<;
  my $user = getpwuid($<);
  my $parent_pid = &getParentForPID($pid);
  my @ps = &psForPID($parent_pid);
  for my $p(@ps) {
    my ($p_user, $p_parent_pid, $p_gparent_pid) = split(/\s+/, $p);
    next unless($p_parent_pid == $parent_pid);
    return $pid unless($p_user eq $user);
    return &getTopParentForPID($p_parent_pid);
  }
}

sub getParentForPID {
  my $pid = shift;
  $pid = $pid ? $pid : $$;
  #print STDERR "getParentForPID ($pid)\n";
  return 0 unless(-e "/proc/$pid/stat");
  my @ps = &psForPID($pid);
  for my $p(@ps) {
    my ($p_user, $p_pid, $p_parent_pid) = split(/\s+/, $p);
    next unless($p_pid == $pid);
    return $p_parent_pid;
  }
}

sub psForPID {
  my $pid = shift;
  $pid = $pid ? $pid : $$;
  #print STDERR "psForPID ($pid)\n";
  return () unless(-e "/proc/$pid/stat");
  return `ps -ef | grep $pid | grep -ve 'ps\|grep\|tail'`;
}
