#!/usr/bin/perl -w
# Author: Rajesh Radhakrishnan
# Team: DevOps
# rename this file to smtpmail.pl and use it with below syntax.
# pre-requisite of smtpmail. pl
# - smtpmail.pl wrapper script should be available in the same script directory or in the path mentioned in PATH variable.
# - subject is mandatory argument to run this script.
# - Recipient also mandatory.
# — support only below 10 MB attachments.
# - HTML mail supported.
# Usage description:
#- . / smtpmail_multi.pl —s "subject" <recipient < msgbody.txt
#        — echo 'Mail body" |./smtpmall.pl -s "subject" <recipient>@domain. com
#        - . / smtpmailmulti . pl -s "subject" -f attachment. txt com
#        - . / smtpmail.pl -s —f attachment. txt com < msgbody.txt
#For HTML mail
#- -h option
#- ./smtpmail.pl -h -s "subject" -f attachment. txt com < msgbody. txt
#customize from address - -r opti on
#- ./smtpmail.pl —h —r from-addr@domain. com —s "subject" -f attachment. txt <recipi com < msgbody.txt
#For CC email/ Add multiple email address with comma seperated for cc.
#. / smtpmaiIV2.p1 —s "Test MaiV'
#—c rajesh@domain. com raj@domain.com < body provide server name
#. /smtpmai 1. pl -h —r from-addr@domain. com -m "mailserver. domain. com" -s "subject
#" -f attachment. txt raj@domain. com
#echo "Mail body" I . / smtpmail.pl -s "subject" raj@domain. corn raj@domain. corn
#. /smtpmail.pl -h -r from-addr@domain.com -m mailserver.domain. com" -s "subject" -f attachment. txt -c raj@domain.com < msgbody.txt
use strict;
use warnings;
use Net::SMTP;
use MIME::Base64;
use sys::Hostname;
use Getopt::Long;

##set defaults
my $host = hostname;
my $frm="Alerts\@domain.com";
my $frml;
my $smtphost "mailhost"; # This can be input from script command line
my $msgbody="Notification messages";
my $subj;
my $html;
my $smtphostopt;
my $cc;

Getopt::Long::Getoptions (
  's=s' => \$subj ,
  'f=s' => \$@file,
  'r=s' => \$frm,
  'm=s' => \$smtphostopt ,
  'c=s' => \$cc.
  'h+'  => \$html
  );

my @to = ( @ARGV ) ;
$frm=$frml if ($frml);
my @msgbody;
if (-t STDIN )
print "NO Msg Body input\n";
@msgbody=Smsgbody;
else
while {
push (@msgbody, $_) ;
}
}

$smtphost = $smtphostopt if ($smtphostopt) ;
my Sboundary = "seperator\n";
print "From Addr: $frn\n" if $frm ne ""; # Reply to address
print 'Subject: $subj if $subj ne "";
print "TO Addr if (@to);
print "cc: $cc\n" if (Scc);
print "Mail server: $smtphost if ($smtphost);
print "Body: @msgbody ' if (@msgbody) ;

my $smtp Net: :sMTP->new($smtphost, Timeout 60);
$smtp->mail($frm) ;
$smtp->to(@to) ;
$smtp->cc ($cc) ;
foreach my $dst ( @to ) {
  $smtp->datasend("$dst\n");
}
  $smtp->datasend("cc; $cc\n");
  $smtp->datasend("Subject: $subj\n");
  $smtp->datasend ("MIME-version:1.0\n");
  $smtp->datasend("content-Type : multipart/mixed");
  $smtp->datasend ("--$boundary") ;
  if ($html)
  {
    $smtp->datasend ("content-Type :text/html\n") ;
  }
  else
  {
    $smtp->datasend ("content-Type : text/plain\n\n" ;
  }
  $smtp->datasend ("")
  $smtp->datasend ("--$boundary");

my $fileToAttach;
my $fsize;
if (@file)
foreach $fileToAttach (@file)
{
if (-e $fileToAttach)
print "File to attach: $fileToAttach" ;
$fsize=-s $fileToAttach;
if ($fsize<10000000)
# opening attachment file
my $fdata;
open(DATA, "<$fileToAttach") ##II not open the file
$fdata=do { local S/};
$fdata s/\n/\r\n/g;
close(DATA);
my $fname = $fileToAttach;
my @flpath = split('\/', $fname);
$fname = $flpath[-l];
print "Filename: $fname\n";
$smtp->datasend("----$boundary") ;
$smtp->datasend("Content-Transfer-Encoding: base64\n"); # (remove the space)
$smtp->datasend("Content-Type:application/ text; name=$fileToAttach\n");
$smtp->datasend("Content-disposition: attachment; filename= $fname\n");
$smtp->datasend("\n");
$smtp->datasend(encode_base64 ($fdata));
}# check file size
else
print "File doesn\'t exist to attach: $fiIeTOAttach\n"•
}#else for check file existence
}# end files attachment for loop
}# end File attachment for message check
else
print "NO File provided/ avai Ible to attach\n";
$smtp->dataend ;
$smtp->quit;
