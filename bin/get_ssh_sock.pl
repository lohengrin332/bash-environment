#!/usr/bin/perl

use strict;
use Data::Dumper;

my $current_auth_sock_file = $ENV{SSH_AUTH_SOCK};
my $agent_file = (-e $current_auth_sock_file) ? $current_auth_sock_file : &getSSHSock();

print "$agent_file";



sub getSSHSock {
  my $pid = shift;
  $pid = $pid ? $pid : $$;
  #print STDERR "getSSHSock ($pid)\n";
  my $user = getpwuid($<);
  my $find_command = "/usr/bin/find /tmp/ -maxdepth 1 -type d -name ssh-\\* -user $user";
  my @dirs = `$find_command`;
  chomp(@dirs);
  my $first_ssh_agent_file = '';
  for my $dir(@dirs) {
    next unless(-d $dir);
    unless(-e $first_ssh_agent_file) {
      my @ls = `ls $dir/agent.*`;
      chomp(@ls);
      $first_ssh_agent_file = $ls[0];
    }
  }
  #none exists for given PID, pull first off list
  return $first_ssh_agent_file;
}
