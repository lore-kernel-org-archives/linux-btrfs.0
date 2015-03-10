Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbbCJEh4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 00:37:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YVBvV-0004dq-Q7
	for linux-btrfs@vger.kernel.org; Tue, 10 Mar 2015 05:37:53 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 05:37:53 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 05:37:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid10 performance issues during copy and balance, only half
 the spindles used for reading data
Date: Tue, 10 Mar 2015 04:37:46 +0000 (UTC)
Message-ID: <pan$f286d$674de9b9$44f18402$f6b4f970@cox.net>
References: <54FE3093.3020902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sven Witterstein posted on Tue, 10 Mar 2015 00:45:23 +0100 as excerpted:

> During balance or copies, the second image of the stripeset A + B | A' +
> B' is never used, thus throwing away about 40% of performance, e.g. it
> NEVER used A' + B' to read from even if 50% of the needed assembled data
> could have been read from there..., so 2 disks were maxed out, the other
> writing at about 40% their I/O capacity.
> 
> Also when rsyncing to ssd raid0 zpool (just for testing, the ssd-pool is
> the working pool, the zfs and btrfs disk pools are for backup) - only 3
> disks of 6 are read from.
> 
> As opposed, a properly set up mdadm "far or offset" + xfs and zfs itself
> use all spindles (devices) to read from and net data is delivered twice
> as fast.
> 
> I would love to see btrfs trying harder to deliver data - it slips my
> mind whether it is a missing feature in btrfs raid10 right now or a bug
> in the 3.16 lines of kernel I am using (mint rebecca on my workstation).
> 
> If anybody knows about it, or I am missing something (-m=raid10
> -d=raid10 was OK I hope when rebalancing?)
> I'd like to be enlightened (when I googled it was always stated that
> btrfs would read from all spindles, but it's not the case for me...)

Known issue, explained below...

The btrfs raid1 (and thus raid10, since it's inherited) read-scheduling 
algorithm remains a rather simplistic one, suitable for btrfs development 
and testing, but not yet optimized.

The existing algorithm is a very simple even/odd PID-based algorithm.  
Thus, single-thread testing will indeed always read from the same side of 
the pair-mirror (since btrfs raid1 and raid10 are pair-mirrored, no N-way-
mirroring available yet, tho it's the next new feature on the raid roadmap 
now that raid56 is essentially code-complete altho not yet well bug-
flushed, with 3.19).  With a reasonably balanced mix of even/odd-PID 
readers, however, you should indeed get reasonable balanced read activity.

The obvious worst-case, of course, is an alternate read/write PID 
spawning script or other arrangement such that all the readers tend to be 
on the same side of the even/odd.

Meanwhile, as stated above, this sort of extremely simplistic algorithm 
is reasonably suited to testing, as it's very easy to force multi-PID-
read scenarios with either good balance, or worst-case-stress-test where 
all activity should be from one side or the other.  However, it's 
obviously not production-grade optimization yet, one of the clearest 
indicators remaining (other than flat-out bugs) that btrfs really is /
not/ fully stable yet, even for raid-types that have been around long 
enough to be effectively as stable as btrfs itself is (unlike the newly 
completed in 3.19 raid56 code).


OK, but when /can/ we expect optimization?

Good question.  With the caveat that I'm only an admin and list regular 
myself, not a dev, and that I've seen no specifics on this particular 
matter, reasonable speculation at better raid1/10 read optimization 
timing would put its introduction either as part of N-way-mirroring, or 
shortly thereafter, since that's a definitely planned and long roadmapped 
feature that was waiting for raid56 as the N-way-mirroring code is 
planned to build on the raid56 code, and arguably, optimization before 
that would be premature optimization of the pair-mirror special-case.

So when can N-way-mirroring be expected?

Another good question.  A /very/ good one for me, personally, since 
that's the feature I really /really/ want to see for my own use case.

Given that various btrfs features have repeatedly taken longer to 
implement than planned, and just raid56 took about three years years 
(original introduction was delayed from 3.5 or so to 3.9, where it was 
introduced but in a code-incomplete state, undegraded runtime worked, 
recovery, not so much, and only with 3.19 is the code essentially 
complete, altho I'd consider it bug-testing until 3.21 aka 4.1 at least), 
I'm really not expecting N-way-mirroring until maybe this time next 
year... and even that's potentially wildly optimistic, given the three 
years raid56 took.

So again, a best-guess for raid1 read-optimization, still keeping in mind 
that I'm simply a btrfs user and list regular myself, and I've not seen 
any specific discussion on the timing here, only the explanation of the 
current algorithm I repeated above...

Some time in 2016... if we're lucky.  I'd frankly be surprised to see it 
this year.  I do expect we'll see it before 2020, and I'd /hope/ by 2018, 
but 2016-2018, 1-3 years out... really is about my best guess, given 
btrfs history.

(FWIW, I've seen people compare zfs to btrfs in terms of feature 
development timing.  ZFS moved faster, wikipedia says 2001-2006 so half a 
decade, but I believe they had a rather larger dedicated/paid team 
working on it, and it /still/ took them half a decade.  Btrfs has fewer 
dedicated engineers working on it but /does/ have the advantages of free 
and open source, tho AFAIK that shows up mostly in the bug testing/
reporting and to some extent fixing department, not so much main feature 
development.  Person-hour-wise, from the comparison I read, it's 
reasonably equivalent; btrfs is simply doing it with fewer devs, 
resulting in it being spread out rather longer.  I think some folks are 
on record as predicting btrfs would take about a decade to reach a 
comparable level, and looking back and forward, that's quite a good 
prediction, a decade out on a software project, where software 
development happens at internet speed.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

