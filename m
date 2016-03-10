Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35525 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbcCJEG5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 23:06:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1adrsE-0003wI-AO
	for linux-btrfs@vger.kernel.org; Thu, 10 Mar 2016 05:06:54 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 05:06:54 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 05:06:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dstat shows unexpected result for two disk RAID1
Date: Thu, 10 Mar 2016 04:06:45 +0000 (UTC)
Message-ID: <pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Thu, 10 Mar 2016 02:36:27 +0500 as excerpted:

> It's a known limitation that the disks are in effect "pinned" to running
> processes, based on their process ID. One process reads from the same
> disk, from the point it started and until it terminates. Other processes
> by luck may read from a different disk, thus achieving load balancing.
> Or they may not, and you will have contention with the other disk
> idling. This is unlike MD RAID1, which knows to distribute read load
> dynamically to the least-utilized array members.
> 
> Now if you want to do some more performance evaluation, check with your
> dstat if both disks happen to *write* data in parallel, when you write
> to the array,
> as ideally they should. Last I checked they mostly didn't, and this
> almost halved write performance on a Btrfs RAID1 compared to a single
> disk.

As stated, at present btrfs mostly handles devices (I've made it a 
personal point to try not to say disks, because SSD, etc, unless it's 
/specific/ /to/ spinning rust, but device remains correct) one at a time 
per task.

And for raid1 read in particular, the read scheduler is a very simple 
even/odd PID based scheduler, implemented early on when simplicity of 
implementation and easy testing of single-task single-device, multi-task 
multi-device, and multi-task-bottlenecked-to-single-device, all three 
scenarios, was of prime consideration, far more so than a speed.  Indeed, 
at that point, optimization would have been a prime example of "premature 
optimization", as it would have almost certainly either restricted 
various later added feature implementation choices later on, or would 
have needed redone later, once those features and their constraints were 
known, thus losing the work done in the first optimization.

And in fact, I've pointed out this very fact as a an easily seen example 
of why btrfs isn't yet fully stable or production ready -- as can be seen 
in the work of the very developers themselves.  Any developer worth the 
name will be very wary of the dangers of "premature optimization" and the 
risk it brings of either severely limiting implementations of further 
features or having to be good work thrown out because it doesn't match 
the new code.

When the devs consider the btrfs code stable enough, they'll optimize 
this.  Until then, it's prime evidence that they do _not_ consider btrfs 
stable and mature enough for this sort of optimization just yet. =:^)


Meanwhile, for quite some time (since at least kernel 3.5 when raid56 was 
expected in kernel 3.6) on the roadmap for implementation after raid56, 
is N-way-mirroring -- basically, raid1 the way mdraid does it, so 5 
devices means 5 mirrors, not the precisely two mirrors of each chunk, 
with new chunks distributed across the other devices until they've all 
been used, that we have now (tho it would continue to be an option).

And FWIW, N-way-mirroring is a primary feature interest of mine so I've 
been following it more closely than much of btrfs development.

Of course the logical raid10 extension of that would be the ability to 
specify N mirrors and M stripes on raid10 as well, so that for a 6-device 
raid10, you could choose between the existing two-way-mirroring, three-
way-striping, and a new three-way-mirroring, two-way-striping, mode, tho 
I don't know if they'll implement both N-way-mirroring raid1 and N-way-
mirroring raid10 at the same time, or wait on the latter.

Either way, my point in bringing up N-way-mirroring, is that it has been 
roadmapped for quite some time, and with it roadmapped, attempting either 
two-way-only-optimization or N-way-optimization, now, arguably _would_ be 
premature optimization, because the first would have to be redone for N-
way once it became available, and there's no way to test that the second 
actually works beyond two-way, until n-way is actually available.

So I'd guess N-way-read-optimization, with N=2 just one of the 
possibilities, will come after N-way-mirroring, which in turn has long 
been roadmapped for after raid56.

Meanwhile, while parity-raid (aka raid56) isn't as bad as it was when 
first nominally completed in 3.19, as of 4.4 (and I think 4.5 as I've not 
seen a full trace yet, let alone a fix), there's still at least one known 
bug remaining to be traced down and exterminated, that's causing at least 
some raid56 reshapes to different numbers of devices or recovery from a 
lost device to take at least 10 times as long as they logically should, 
we're talking times of weeks to months, during which time the array can 
be used, but if it's a bad device replacement and more devices go down in 
that time...  So even if it's not an immediate data-loss bug, it's still 
a blocker in terms of actually using parity-raid for the purposes parity-
raid is normally used.

So raid56, while nominally complete now (after nearing four /years/ of 
work, remember, originally it was intended for kernel 3.5 or 3.6), still 
isn't anything close to stable as the rest of btrfs, and is still 
requiring developer focus, so it could be awhile before we see that N-way-
mirroring that was roadmapped after it, which in turn means it'll likely 
be even longer before we see good raid1 read optimization.

Tho hopefully all the really tough problems they would have hit with N-
way-mirroring were hit and resolved with raid56, and N-way-mirroring will 
thus be relatively simple, so hopefully it's less than the four years 
it's taking raid56.  But I don't expect to see it for another year or 
two, and don't expect to be actually use it as intended (as a more 
failure resistant raid1) for some time after that as the bugs get worked 
out, so realistically, 2-3 years.

If multi-device scheduling optimization is done in say 6 months after 
that... that means we're looking at 2.5-3.5 years, perhaps longer, for 
it.  So it's a known issue, yes, and on the roadmap, yes, but don't 
expect to see anything in the near (-2-year) future, more like 
intermediate (3-5) year future.  In all honesty I don't seriously expect 
it to be long-term future, beyond 5 years, but it's possible.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

