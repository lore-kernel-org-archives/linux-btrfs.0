Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:33848 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731654AbeISUcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 16:32:02 -0400
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>
Subject: state of btrfs snapshot limitations?
To: "James A. Robinson" <jim.robinson@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Message-ID: <d502c26f-5270-a3f5-53c7-80f7f51bbe20@siedziba.pl>
Date: Wed, 19 Sep 2018 16:41:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> If the limit is 100 or less I'd need use a more complicated
> rotation scheme.

If you just want to thin them out over time without having selected "special" monthly, yearly etc snapshots, then my favorite scheme is to just compare the age of a snapshot to the distance to its neighbours, and if the distance is less than age / constant then delete it. If the constant is, for example, 12, then it will start thinning out hourly snapshots after around 12 hours, monthly after 12 months etc.

This is how it looks after 2 years with daily snapshots and the constant=6:

backup-20160328143825
backup-20161210043001
backup-20170424033001
backup-20170830033001
backup-20171102043001
backup-20180105043001
backup-20180310043001
backup-20180411033001
backup-20180513033001
backup-20180614033001
backup-20180630033001
backup-20180716033001
backup-20180801033001
backup-20180809033001
backup-20180817033001
backup-20180825033001
backup-20180829033001
backup-20180902033001
backup-20180906033001
backup-20180908033001
backup-20180910033001
backup-20180912033001
backup-20180914033001
backup-20180915033001
backup-20180916033001
backup-20180917033001
backup-20180918033001
backup-20180919033001

Notice how I have 6 daily snapshots (from 09-14 to 09-19), then I have at least 1 snapshot from each month 6 months back (04 to 09) and I would have at least 1 snapshot from each year for 6 years if I kept them longer. I delete the oldest snapshot when free space gets too low.

I have a horrid perl "one-liner" to do the thinning (caution! it deletes subvolumes without asking!):

perl -e 'for(@ARGV){open($in,"-|",qw(btrfs subvolume show),$_);$ts{$_}=(map{/: \t+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \+\d{4})$/ or die "error parsing: $_\n";0+`date --date "$1" +%s` or die $!}grep{/Creation time:/}<$in>)[0]}@s=sort{$ts{$b}<=>$ts{$a}}keys%ts;while(@s>2){($s1,$s2,$s3)=@s;if(($ts{$s1}-$ts{$s3})/2<(time-$ts{$s2})/12){system(qw(btrfs subvolume delete),$s2);$s[1]=$s1};shift@s}' [snapshot ...]

(hey, everything can be a one-liner if you allow unlimited line length!)

I will take this opportunity to tidy it up a bit (below). Maybe someone else will find it useful or have some ideas for improvements. I would really like to avoid parsing "btrfs subvolume show" output (maybe python-btrfs can read subvolume creation time?)

#!/usr/bin/perl
use strict;
use warnings;

# map snapshot names to timestamps
my %ts;
for (@ARGV) {
    # run "btrfs subvolume show" for each snapshot
    open( my $in, "-|", qw(btrfs subvolume show), $_ );
    # convert "Creation time" from btrfs output to timestamp
    $ts{$_} = (
        map {
            /: \t+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \+\d{4})$/
              or die "error parsing: $_\n";
            # using "date" command to parse "Creation time"
            # who needs modules from CPAN right? ;)
            0 + `date --date "$1" +%s` or die $!
        } grep { /Creation time:/ } <$in>
    )[0];
}
# sort snapshot names by timestamps
my @s = sort { $ts{$b} <=> $ts{$a} } keys %ts;
while ( @s > 2 ) {
    my ( $s1, $s2, $s3 ) = @s;
    # compare average distance to age / 12
    # change 12 to some other value to keep more or less snapshots
    # higher value = more snapshots
    if ( ( $ts{$s1} - $ts{$s3} ) / 2 < ( time - $ts{$s2} ) / 12 ) {
        # caution! this runs "btrfs subvolume delete"
        # you can put "echo" before "btrfs" for a "dry run"
        system( qw(btrfs subvolume delete), $s2 );
        # we deleted $s2 snapshot, so replace $s2 with $s1
        $s[1] = $s1;
    }
    shift @s;
}
