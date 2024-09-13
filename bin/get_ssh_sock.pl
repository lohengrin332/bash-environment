#!/usr/bin/perl

use strict;
use Data::Dumper;

&isAgentRunning() || &startAgent();

my $current_auth_sock_file = $ENV{SSH_AUTH_SOCK};
my $agent_file = (-e $current_auth_sock_file) ? $current_auth_sock_file : &getSSHSock();

print "$agent_file";


sub isAgentRunning {
  my $agent_pid = `/usr/bin/pidof ssh-agent`;
  return $agent_pid ? 1 : 0;
}

sub startAgent {
  `/usr/bin/ssh-agent`;
}

sub getSSHSock {
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
    last if(-e $first_ssh_agent_file && -d $first_ssh_agent_file);
  }

  return $first_ssh_agent_file;
}

