Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54777 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab3KESVj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 13:21:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VdlFw-0006j9-Ge
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 19:21:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 19:21:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 19:21:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: umount waiting for 12 hours and still running
Date: Tue, 5 Nov 2013 18:21:15 +0000 (UTC)
Message-ID: <pan$eb9c$5cdff220$5f3b344b$1690c54d@cox.net>
References: <5278F5AA.60108@complete.org>
	<pan$70ff2$6c271d88$3a2794d1$837be634@cox.net>
	<loom.20131105T170351-783@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Goerzen posted on Tue, 05 Nov 2013 16:11:56 +0000 as excerpted:

> Duncan <1i5t5.duncan <at> cox.net> writes:
> 
> 
>> John Goerzen posted on Tue, 05 Nov 2013 07:42:02 -0600 as excerpted:
>> 
>> > The filesystem in question involves two 2TB USB hard drives.  It is
>> > 49% full.  Data is RAID0, metadata is RAID1.  The files stored on it
>> > are for BackupPC, meaning there are many, many directories and
>> > hardlinks.  I would estimate 30 million inodes in use and many of
>> > them have dozens of hardlinks to them.
>> 
>> That's a bit of a problem for btrfs at this point, as you rightly
>> mention.

> Can you clarify a bit about what sort of problems I might expect to
> encounter with this sort of setup on btrfs?

I'm not a dev nor do I run that sort of setup, so I won't attempt a lot 
of detail.  This is admittedly a bit handwavy, but if you need more just 
use it as a place to start for for your own research.

That out of the way, having followed the list for awhile, I've seen 
several reports of complications related to high hardlink count, mostly 
exactly as yours, related to unresponsive for N seconds warnings and 
inordinately long processing times for unmounts, etc.

Additionally, it's worth noting that until relatively recently (the wiki 
changelog page says 3.7), btrfs had a rather low limit on hardlinks in a 
single directory that people using btrfs for hardlink intensive purposes 
kept hitting.  A developer could give you more details, but IIRC, the 
solution that worked around that, while it /did/ give btrfs the ability 
to handle them, effectively created a setup where the first few hardlinks 
were handled inline and thus were reasonably fast, but beyond that limit, 
an indirect referencing scheme was used that was rather less efficient.

I'd guess btrfs' current problems in that regard are thus two-fold, 
first, above a certain level the implementation /does/ get less 
efficient, and second, given the relatively recent kernel 3.7 
implementation, btrfs' large-numbers-of-hardlinks code hasn't had nearly 
the time to shake out the bugs and get incremental optimizations that the 
more basic code has had.  I doubt btrfs will ever be a speed demon in 
this area, but I expect that given another year or so, the high-numbers 
hardlink code will be somewhat better optimized and tested simply due to 
the incremental effect of bug shakeout and small code changes over time 
as btrfs continues maturing.

Meanwhile, my own interest in btrfs is as a filesystem for SSDs (I still 
use reiserfs on my spinning rust and I've had very good luck with it even 
thru various shoddy hardware experiences since the ordered-by-default 
code went in around 2.6.16, IIRC, but its journaling isn't well suited to 
SSDs), and being able to actually use btrfs' data checksumming and 
integrity features, which means raid1 or raid10 mode (raid1 in my case), 
and the speed of SSDs does mitigate to a large degree a lot of the 
slowness I see others reporting for this and other cases.  Additionally, 
I run several independent smaller partitions so if there /is/ a problem, 
the damage is contained, which means I'm typically dealing with double-
digit gigs per partition at most, thus reducing full partition scrub and 
rebalance times from the hours to days I see people reporting on-list for 
multi-terabyte spinning rust, to typically seconds, perhaps a couple 
minutes, here.  The time is short enough I typically use the don't-
background option, and run the scrub/balance in real-time, waiting for 
the result.  Needless to say, if a full balance is going to take days, 
you don't run it very often, but since it's only a couple minutes here, I 
scrub and balance reasonably frequently, say if I have a bad shutdown (I 
use suspend-to-ram and sometimes on resume the SSDs don't stabilize fast 
enough for the kernel, so a device drops from the btrfs raid1 and the 
whole system goes unstable after that, often leading to a bad shutdown 
and reboot).  Since a full balance involves rewriting everything to new 
chunks that tends to limit bitrot or the chance for any errors to build 
up over time.

My point being that my particular use-case is pretty much diametrically 
opposite yours!  For your backups use-case, I'd probably use something 
less experimental than btrfs, like xfs or ext4 with ordered journaling... 
or the reiserfs I still use on spinning rust, tho people's experience 
with it seems to either be really good or really bad, and while mine is 
definitely good that doesn't mean yours will be.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

