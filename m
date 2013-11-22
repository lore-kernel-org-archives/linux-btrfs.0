Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3KVTvy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 14:51:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vjwlb-00023L-Rk
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 20:51:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 20:51:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 20:51:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 19:51:30 +0000 (UTC)
Message-ID: <pan$981a5$77343fc2$a30152fe$29639c9b@cox.net>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no>
	<528F122C.2040202@hardwarefreak.com>
	<CAK2H+efFuzvOaQe3NMOeBzujvvrrcKcZCmmMXzjTSUpLdJMvHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-raid@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Knecht posted on Fri, 22 Nov 2013 08:50:32 -0800 as excerpted:

> On Fri, Nov 22, 2013 at 12:13 AM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
>> Now that you mention it, yes, RAID 15 would fit much better with
>> convention.  Not sure why I thought 51.  So it's RAID 15 from here.
> <SNIP>
> 
> For us casual readers & RAID users could you clarify RAID15? Would that
> be a bunch of RAID1's grouped together in what appears to be a RAID5 to
> the system?

Simplest definition, yes.

Admittedly part of this discussion is beyond me (as another casual reader 
with some raid experience, reading here via the btrfs list as that's my 
current interest), but I'm following enough of it to find it interesting, 
for SURE! =:^)

And perhaps my explanation of the basics will let the real experts 
continue the debate at their higher level...

At a concept level, because md/raid, etc (I'll use mdraid as my example 
from here, but but there's dm-raid, hardware raid, etc; additionally, 
I'll omit the ALL CAPS RAID convention and use lowercase), devices are 
presented as normal block devices, RAID levels (among other things, LVM2, 
etc) are stackable.  So it's possible to, for instance, create a raid0 on 
top of a bunch of raid1s, or the reverse, a raid1 on top of a bunch of 
raid0s, either with the base level being hardware based and the software 
creating a raid level direct on the hardware raid, or with both/all 
levels in software.

Then we get into naming.  AFAIK the earliest convention was using the 
plus syntax, raid1+0, raid0+1, with the left-most number being the 
lowest, closest to hardware level, either the hardware level or closest 
to the individual hardware devices, so raid1+0 is implemented as striped 
raid (raid0) over top of mirrored raid (raid1), with raid0+1 the reverse, 
a mirror over stripes.

That quickly evolved into omitting the +, thus raid10 and raid01. (Tho 01 
has the leading zero problem with some people trying to omit it, and 
raid1 isn't the same thing AT ALL as raid01!  Between that and the fact 
that raid01 is less common than raid10 for technical reasons as noted 
below, you seldom see raid01 specified; it usually keeps the + and 
appears as raid0+1).

Also, less commonly seen but as more levels were stacked (raid105, etc), 
sometimes the + is still used to separate the hardware raid levels from 
software.  In this usage, raid105 would probably be an all software 
implementation, while raid1+05 would be raid1 in hardware, with software 
raid0 and raid5 stacked on top, in that order, and raid10+5 would be 
hardware raid10, with software raid5 on top.

Note that while raid10, aka raid1+0, should have similar non-degraded 
performance to raid0+1, there's a BIG difference when recovering from 
degraded.  A smart raid10 implementation (or a raid1+0 with hardware 
raid1) can rebuild a failed drive "locally", that is, purely at the raid1 
level, using just the data on its raid1 mirror(s).  That means only a 
single device has to be read from in ordered to write the data to the 
rebuilding device.  Raid0+1, by contrast, fails the entire raid0 level at 
once, thus requiring reading from an unfailed entire raid1 (higher) level 
mirror set while writing out an entire new raid0 set!!  So while normal 
operation state is similar between raid10/raid1+0 and raid0+1, the 
recovery characteristics are **MUCH** different, with raid10 being 
markedly better than raid0+1.  As a result, raid0+1 doesn't tend to be 
used that often in practice, while raid10 (aka raid1+0) has become quite 
common, particularly so as its performance is quite high, only exceeded 
by raid0, but with redundancy and recovery characteristics that are good 
to very good, as well.  Its biggest negative at the low end is the number 
of devices required, normally a minimum of four (but see the Linux 
mdraid10 discussion below), a striped pair of mirrored pairs.

This 1+0/0+1 distinction confused me as an early raid user for quite some 
time even after I knew the technical difference, as I kept trying to 
reverse them in my head, and I guess it confuses a lot of people.  For 
some reason, my intuitive read of raid10 was the reverse of convention -- 
intuitively I /wanted/ to interpret it as a raid1 on top of raid0 instead 
of the raid0 on top of raid1 it is by convention, and even after I 
understood that there WAS a difference and in principle knew why and how, 
for years I actually had to look up the difference each time it came up, 
if it made a difference to the discussion, because I /wanted/ to read it 
backward, or more accurately, I thought the convention had it backward to 
the interpretation that made most sense to me.  It is only recently that 
I came to see it the other way, and even still, I have to pause and think 
every time I see it, to ensure I'm not again reversing things.

Which is the distinction that came up in the above discussion as well, 
only with raid5 and raid1 instead of raid0 and raid1.  Apparently I'm not 
the only one to get things reversed!

But yes, conceptually, raid15 is a raid5 layer on top of raid1, aka raid1
+5, while raid51 would be a raid1 layer on top of raid5, aka raid5+1.  
For the same recovery-time reasons noted above with raid0+1 vs. raid1+0/
raid10, having raid1 at the local/hardware layer should be preferable.

With the basic concepts covered, the next level up is understanding that 
the Linux md/raid10 implementation, while BASED on the raid10 concept 
above, has some quite interesting extensions.  Implementing it as a 
single software raid10 level instead of separate raid0 over raid1 allows 
some interesting optimizations and additional flexibility.  Among other 
things, it no longer requires a minimum four devices (a raid0 pair of 
raid1 pairs) as separate raid0 over raid1 would.  There's quite a bit of 
additional flexibility in layout.  A detailed discussion is out of scope 
here, but googling raid10 on wikipedia is a good start, and the page it 
gives you actually discusses various other nested raid levels as well.  
>From there, follow the links to non-standard raid levels, and to the 
Linux mdraid implementation discussion, including the concepts of "near", 
"far", and "offset" layouts.

https://en.wikipedia.org/wiki/Raid10

https://en.wikipedia.org/wiki/Non-standard_RAID_levels

https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

But the discussion here is well beyond that, out toward further 
implementation detail and optimization.

One of the problems that has been creeping up on us is the fact that as 
shear drive sizes increase, the possibility of undetected/uncorrected 
physical device errors goes up faster than the technology gets better at 
reducing them.  For "simple" parity RAID solutions such as raid5, this is 
a rather big problem, because at some point, the chances of error during 
recovery scuttling the recovery entirely simply get too large to 
practically deal with, with recovery time (and thus time to recovery 
failure and try again) similarly increasing toward the days and weeks 
point.  If recovery's going to take days, only for it to fail due to 
physical device error forcing another try...

So the discussion is how to mitigate the problem.  Multi-way-parity is of 
course the primary discussion in this thread, allowing detection and 
recovery of single-sector physical device errors via N-way-parity. 

But an integrated raid15 solution similar to mdraid's current raid10, is 
another possibility, effectively using the raid1 mirror level to mitigate 
sector-level physical device errors, while using the higher raid5 level 
to detect them and trigger a re-mirror at the raid1 level below it.  But 
the only way that can work is if the two conceptually separate raid 
levels are integrated at the implementation level, so the raid5 level 
parity error detection can tell the raid1 level which of its mirrors is 
bad and force a remirroring from the good one(s) to the bad one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

