Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-9.server.virginmedia.net ([80.0.253.73]:51713
        "EHLO know-smtprelay-omc-9.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbeITEmj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 00:42:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by phoenix.fire (8.15.2/8.15.2) with ESMTP id w8JMurWr007590
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 23:56:53 +0100
Subject: Re: state of btrfs snapshot limitations?
To: linux-btrfs@vger.kernel.org
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
 <d502c26f-5270-a3f5-53c7-80f7f51bbe20@siedziba.pl>
From: Pete <pete@petezilla.co.uk>
Message-ID: <b256bf67-74a9-cd74-9de5-ce7c56d7373a@petezilla.co.uk>
Date: Wed, 19 Sep 2018 23:56:53 +0100
MIME-Version: 1.0
In-Reply-To: <d502c26f-5270-a3f5-53c7-80f7f51bbe20@siedziba.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2018 03:41 PM, Piotr Pawłow wrote:
> Hello,
>> If the limit is 100 or less I'd need use a more complicated
>> rotation scheme.
> 
> If you just want to thin them out over time without having selected "special" monthly, yearly etc snapshots, then my favorite scheme is to just compare the age of a snapshot to the distance to its neighbours, and if the distance is less than age / constant then delete it. If the constant is, for example, 12, then it will start thinning out hourly snapshots after around 12 hours, monthly after 12 months etc.
> 
> This is how it looks after 2 years with daily snapshots and the constant=6:
> 
> backup-20160328143825
> backup-20161210043001

User not dev here, I thought I'd share my experience.  That scheme looks
really interesting.  Though how you'd achieve that sounds like it might
be a little complex, one piece of script covers it.

My approach is to snapshot on three timeframes, daily, weekly and
monthly.  I store approximately 30 days worth of daily snapshots, 1
years worth of weekly snapshots and 1 years worth of monthly snapshots.
On reflection however, if I retail 1 years worth of weekly then the
monthly snapshots are redundant.  Perhaps a little adjustment is in order.

However, there are pitfalls, which I ironically hit today.  This is not
a btrfs issue, but a simple consequence of snap-shotting a system with a
reasonable amount of changes - the volume of data stored grows owing to
the many changed files and hence free space reduces even if the 'master'
sub volumes are kept tidy.  It does not matter how tidy you keep the
'master', tidying the data, if the old redundant data is hiding in the
snapshots.  You need to delete it out of them as well which defeats the
idea of read only snapshots if you are using them.  For example today I
deleted redundant kernel modules from both the root subvolume and the
snapshots, and similar for /tmp, only then did I free up 55 GB (!) to
give myself some free space.  (I have been frequently updating my kernel
and left some debugging options on resulting in many copies of far
larger kernel modules than intended).

I've since made /tmp a subvolume to prevent snap-shotting to partially
mitigate this.  I'm wondering if I should make /lib/modules one for the
same reason.  In previous posts on this mailing list people have
recommended making various cache and tmp directories separate subvolumes
to reduce loss of available disk space by snapshotting churning files
that have little value for retention.  I'm wondering if some guide to
snapshotting is appropriate to make people aware of the management
actions that might be required?


> I have a horrid perl "one-liner" to do the thinning (caution! it deletes subvolumes without asking!):
> 
> perl -e 'for(@ARGV){open($in,"-|",qw(btrfs subvolume show),$_);$ts{$_}=(map{/: \t+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \+\d{4})$/ or die "error parsing: $_\n";0+`date --date "$1" +%s` or die $!}grep{/Creation time:/}<$in>)[0]}@s=sort{$ts{$b}<=>$ts{$a}}keys%ts;while(@s>2){($s1,$s2,$s3)=@s;if(($ts{$s1}-$ts{$s3})/2<(time-$ts{$s2})/12){system(qw(btrfs subvolume delete),$s2);$s[1]=$s1};shift@s}' [snapshot ...]
> 
> (hey, everything can be a one-liner if you allow unlimited line length!)
> 

Now I've seen it I can't un-see it!
