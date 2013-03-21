#!/bin/sh

# Returns ISC Bind stats (old version) 

# success
# referral
# nxrrset
# nxdomain
# recursion
# failure

stats_file="/var/named/data/named_stats.txt"
rndc_stats="rndc stats"

[ -f $stats_file ] && rm -f $stats_file

$rndc_stats
sleep 0.2 # ...

awk '/---/{f=0} f { print $2 }; /+++/{f=1}' $stats_file
