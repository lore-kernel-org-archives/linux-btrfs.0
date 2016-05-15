Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59840 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbcEOUkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 16:40:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b22pt-0000FN-0W
	for linux-btrfs@vger.kernel.org; Sun, 15 May 2016 22:40:25 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 22:40:24 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 22:40:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs RAID-1 vs md RAID-1?
Date: Sun, 15 May 2016 20:40:18 +0000 (UTC)
Message-ID: <pan$2c135$79bf07ae$3f81ff6a$551f3a03@cox.net>
References: <83719f27dd5cdc406fd3fd24e7b82a9f@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Sun, 15 May 2016 19:24:47 +0900 as excerpted:

> I'm trying to read two large files in parallel from a 2-disk RAID-1
> btrfs setup (using kernel 4.5.3).
> 
> According to iostat, one of the disks is 100% saturated, while the other
> disk is around 0% busy.
> 
> Is it expected?

Depends.  Btrfs redundancy-raid, raid1/10 has an unoptimized read 
algorithm at this time (and parity-raid, raid5/6, remains new and 
unstable in terms of parity-recovery and restriping after device loss, so 
isn't recommended except for testing).  See below.

> With two readers from the same disk, each file is being read with ~50
> MB/s from disk (with just one reader from disk, the speed goes up to
> around ~150 MB/s).
> 
> In md RAID, with many readers, it will try to distribute the reads -
> after md manual on http://linux.die.net/man/4/md:
> 
>      Raid1 (...)
>      Data is read from any one device. The driver attempts to distribute
>      read requests across all devices to maximize performance.

Btrfs' current redundancy-raid read-scheduling algorithm is a pretty 
basic unoptimized even/odd PID implementation at this point.  It's 
suitable for basic use and will parallelize over a large enough random 
set of read tasks as the PIDs distribute even/odd, and it's well suited 
to testing as it's simple, and easy enough to ensure use of either just 
one side or the other, or both, by simply arranging for all even/odd or 
mixed PIDs.  But as you discovered, it's not yet anything near as well 
optimized as md redundancy-raid.

Another difference between the two that favors mdraid1 is that the latter 
will make N redundant copies across N devices, while btrfs redundancy 
raid in all forms (raid1/10 and dup on single device) has exactly two 
copies, no matter the number of devices.  More devices simply gives you 
more capacity, not more copies, as there's still only two.

OTOH, for those concerned about data integrity, btrfs has one seriously 
killer feature that mdraid lacks -- btrfs checksums both data and 
metadata and verifies a checksum match on read-back, falling back to the 
second copy on redundancy-raid if the first copy fails checksum 
verification, rewriting the bad copy from the good one.  One of the 
things that distressed me about mdraid is that in all cases, redundancy 
and parity alike, it never actually cross-checks either redundant copies 
or parity in normal operation -- if you get a bad copy and the hardware/
firmware level doesn't detect it, you get a bad copy and mdraid is none 
the wiser.  Only during a scrub or device recovery does mdraid actually 
use the parity or redundant copies, and even then, for redundancy-scrub, 
it simply arbitrarily calls the first copy good and rewrites it to the 
others if they differ.

What I'm actually wanting myself, is this killer data integrity 
verification feature, in combination with N-way mirroring instead of just 
the two-way that current btrfs offers.  For me, N=3, three-way-mirroring, 
would be perfect, as with just two-way-mirroring, if one copy is found 
invalid, you better /hope/ the second one is good, while with three way, 
there's still two fallbacks if one is bad.  4+-way would of course be 
even better in that regard, but of course there's the practical side of 
actually buying and housing the things too, and 3-way simply happens to 
be my sweet-spot.

N-way-mirroring is on the roadmap for after parity-raid (the current 
raid56), as it'll use some of the same code.  However, parity-raid ended 
up being rather more complex to properly implement along with COW and 
other btrfs features than they expected, so it took way more time to 
complete than originally estimated and as mentioned above it's still not 
really stable as there remain a couple known bugs that affect restriping 
and recovery from lost device.  So N-way-mirroring could be awhile, and 
if it follows the pattern of parity-raid, it'll be awhile after that 
before it's reasonably stable.  So we're talking years...  But I'm still 
eagerly anticipating...

Obviously, once N-way-mirroring gets in they'll need to revisit the read-
scheduling algorithm anyway, because even/odd won't cut it when there's 
three-plus-way scheduling.  So that's when I'd expect some optimization 
to occur, effectively as part of N-way-mirroring.

Meanwhile, I've argued before that the unoptimized read-scheduling of 
btrfs raid1 remains a prime example-in-point of btrfs' overall stability 
status, particularly when mdraid has a much better algorithm already 
implemented in the same kernel.  Developers tend to be very aware of 
something called premature optimization, where optimization too early 
will either lock out otherwise viable extensions later, or force throwing 
away major sections of optimization code as the optimization is redone to 
account for the new extensions that don't work with the old optimization 
code.

That such prime examples as raid1 read-scheduling remain so under-
optimized thus well demonstrates the developers' own opinion of the 
stability of btrfs in general at this point.  If they were confident it 
was stable and the redundancy-raid implementation code wouldn't be 
changing out from under them, they could optimize the read-scheduling.  
Of course we already know that N-way mirroring is coming, so the new 
optimized code would either need to take that into account and work with 
it as well, or it would obviously be thrown own once N-way-mirroring gets 
here if it didn't.  And without N-way-mirroring, there's no way to 
actually test anything but two-way, which means implementation without 
testing and a good likelihood that the code would need to be thrown out 
and redone once N-way-mirroring arrives and it could actually be tested, 
anyway.


So what to do for now?

For low-budget, two-device, you have to pick, either live with btrfs 
unoptimized read-scheduling (which actually isn't too bad on ssd, as I 
know since I'm running primarily btrfs raid1 on paired ssds, here) and be 
able to take advantage of btrfs' other major features including integrity 
verification (my own killer feature), subvolumes, snapshotting, etc, or 
choose mdraid instead, losing at least rewriting bad copies from good, 
tho you can of course still run btrfs on top of the mdraid1, and get 
other features such as integrity verification (without rewrite from the 
good copy repair of bad, at least unless you run dup mode btrfs on the 
single-device presented by the mdraid), snapshotting, etc.

For more devices, you can do a hybrid configuration, btrfs raid1 for data 
integrity and repair, on top of a pair of mdraid0s.  I've not tried this 
personally because as I said I went the ssd route and that has been fine 
for me, but at least one regular here says this sort of arrangement works 
quite well, with the mdraid0s underneath to some extent making up for 
btrfs raid1's bad read-scheduling.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

