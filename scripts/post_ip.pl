#!/usr/bin/perl -w

print "To post IP and the MAC\n";

use strict;
my @nums;
my $ip_info;
my $mac_info;
my $curl;

open( DIR, "ifconfig eth0|" ) || die "No ls";
    while( <DIR> ){
        #print $_;
        if($_=~/\s+addr\:(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})/){
                $ip_info = $1;
                print "IP $1\n";
        }
        if($_=~/HWaddr\s+([A-Fa-f0-9]{2}\:[A-Fa-f0-9]{2}\:[A-Fa-f0-9]{2}\:[A-Fa-f0-9]{2}\:[A-Fa-f0-9]{2}\:[A-Fa-f0-9]{2})/){
                $mac_info = $1;
                print "MAC $1";
        }
     }
close DIR;

#system("curl -v \"https://mashup.stratoslive.wso2.com/services/t/jayasoma.org/admin/ReportIP/report?ip=$ip_info&mac=$mac_info\"");
system("curl -v \"http://appserver.stratoslive.wso2.com/t/azeez.org/webapps/rpi/addme.jsp?mymac=$mac_info&myip=$ip_info\"");
print $curl;
