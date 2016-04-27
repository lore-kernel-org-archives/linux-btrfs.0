Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46980 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbcD0KhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 06:37:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1avMqI-0002Pq-G9
	for linux-btrfs@vger.kernel.org; Wed, 27 Apr 2016 12:37:14 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 12:37:14 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 12:37:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Add device while rebalancing
Date: Wed, 27 Apr 2016 10:37:07 +0000 (UTC)
Message-ID: <pan$772c4$5b3a4a6c$9da37d84$6d5b7ad3@cox.net>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
	<CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
	<CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 26 Apr 2016 18:58:06 -0600 as excerpted:

> On Tue, Apr 26, 2016 at 5:44 AM, Juan Alberto Cirez
> <jacirez@rdcsafety.com> wrote:

>> RAID10 configuration, on the other hand, requires a minimum of four
>> HDD, but it stripes data across mirrored pairs. As long as one disk in
>> each mirrored pair is functional, data can be retrieved.
> 
> Not Btrfs raid10. It's not the devices that are mirrored pairs, but
> rather the chunks. There's no way to control or determine on what
> devices the pairs are on. It's certain you get at least a partial
> failure (data for sure and likely metadata if it's also using raid10
> profile) of the volume if you lose more than 1 device, planning wise you
> have to assume you lose the entire array.

Primarily quoting and restating the above (and below) to emphasize it.

Remember:

* btrfs raid is chunk-level, *NOT* device-level.  That has important 
implications in terms of recovery from degraded.

* btrfs parity-raid (raid56 mode) isn't yet mature and definitely nothing 
I'd trust in production.

* btrfs redundancy-raid (raid1 and raid10 modes, as well as dup-mode on a 
single device) are precisely pair-copy -- two copies, with the raid modes 
forcing each copy to a different device or set of devices.  More devices 
simply means more space, *NOT* more redundancy/copies.

Again, these copies are at the chunk level.  The chunks can and will be 
distributed across devices based on most space available, meaning loss of 
more than one device will in most cases kill the array.  Because mirror-
pairs happen at the chunk, not the device level, there is no such thing 
as loss of only one mirror in the mirror pair allowing more than a single 
device to fail, because statistically, the chances of both copies of some 
chunks being on those two now failed/missing devices is pretty high.

* btrfs raid10 stripes N/2-way, while only duplicating exactly two-way.  
So a six-device raid10 will stripe three devices per mirror, while a 5-
device raid10 will stripe 2 devices per mirror, with the odd device out 
being on a different device for each new chunk, due to the most-space-
left allocation algorithm.

>> With GlusterFS as a distributed volume, the files are already spread
>> among the servers causing file I/O to be spread fairly evenly among
>> them as well, thus probably providing the benefit one might expect with
>> stripe (RAID10).
> 
> Yes, the raid1 of Btrfs is just so you don't have to rebuild volumes if
> you lose a drive. But since raid1 is not n-way copies, and only means
> two copies, you don't really want the file systems getting that big or
> you increase the chances of a double failure.

Again emphasizing.  Since you're running a distributed filesystem on top, 
keep the lower level btrfs raids small and do more of them, multiple 
btrfs raid bricks per machine even, as long as your distributed level is 
specced to be able to lose the bricks of at least one entire machine, of 
course.

OTOH, unlike traditional raid, btrfs does actual checksumming and data/
metadata integrity at the block level, and can and will detect integrity 
issues and correct from the second copy when the raid level supplies one, 
assuming it's good of course.  That should fix problems at the lower 
level that other filesystems wouldn't, meaning less problems ever reach 
the distributed level in the first place.

Thus, also emphasizing something Austin suggested.  You may wish to 
consider btrfs raid1 on top of a pair of mdraid or dmraid raid0s.

As you are likely well aware, normally, raid1 on top of raid0 is called 
raid01 and is discouraged in favor of raid10 (raid0 on top of raid1) for 
rebuild from lost device state efficiency reasons (with raid1 underneath, 
the rebuild of a lost device is localized to the presumably two-device 
raid1, with raid1 on top, the whole raid0 stripe must be rebuilt, and 
that's normally at the whole-device level)

Of course putting the btrfs raid1 on top reverses this and would 
*normally* be discouraged as raid01, but btrfs raid1's operational data 
integrity handling, while not getting away from having to rebuild the 
whole raid0 stripe from the other one, does mean that gets done for an 
individual bad block -- no whole device failure necessary.

And of course you can't get that putting btrfs raid0 on top and get that, 
since then the underneath raid1 layer won't be doing that integrity 
verification, and if that bad block happens to be returned by the 
underlying raid1 layer, the btrfs raid0 will simply fail the verification 
and error out that read, despite another good copy on the underlying 
raid1, because btrfs won't know anything about it.

Meanwhile, as Austin says, btrfs' A/B copy read scheduling is... 
unoptimized.  Basically, it's simple even/odd PID based, so a single read 
thread will always hit the same copy, leaving the other one idle.  I've 
argued before that precisely that is a very good indication of where the 
btrfs devs themselves think btrfs is at, as it's clearly suboptimal, 
while there are much better scheduling examples, including the mdraid 
read-scheduling code, praised for its efficiency, in the kernel, and 
failure to optimize must then be considered either simply lacking the 
time due to higher priority development and bugfixing tasks, or an 
avoidance of the dangers of "premature optimization".  In either case, 
that such unoptimized code remains in such a highly visible and 
performance critical place is an extremely strong indicator that btrfs 
devs themselves don't consider btrfs a stable and mature filesystem yet.

And putting a pair of md/dm raid0s below that btrfs raid1, both helps to 
make up a bit for the btrfs raid1 braindead read-scheduling, and lets you 
exploit btrfs raid1's data integrity features.  Of course it also forces 
btrfs to a more deterministic distribution of those chunk copies, so you 
can loose up to all the devices in one of those raid0s, as long as the 
other one remains functional, but that's nothing to really count on, so 
you still plan for single device failure redundancy only at the 
individual brick level, and use the distributed filesystem layer to deal 
with whole brick failure above that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

