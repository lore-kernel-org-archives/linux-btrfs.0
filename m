Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49004 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbcD1CaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 22:30:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1avbiK-0006xq-SF
	for linux-btrfs@vger.kernel.org; Thu, 28 Apr 2016 04:30:01 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 04:30:00 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 04:30:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ...in the matter of partition size
Date: Thu, 28 Apr 2016 02:29:52 +0000 (UTC)
Message-ID: <pan$5d30f$a856a2c2$54d2e64f$aaf39f@cox.net>
References: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Alberto Cirez posted on Wed, 27 Apr 2016 14:18:27 -0600 as excerpted:

> Quick question: Supposed I have n-number of storage pods (physical
> servers with n-number of physical hhds). The end deployment will be
> btrfs at the brick/block level with a distributed file system on top.
> Keeping in mind that my overriding goal is to have high availability and
> the mechanism whereby the lost of a drive or multiple drives in a single
> pod will not jeopardize data.
>>>>>>Question<<<<<
> Does partitioning the physical drives and creating btrfs filesystem on
> each partition, then configuring each partition as individual
> bricks/blocks offer ANY added benefits over grouping the entire pod into
> a drive pool and using that pool as a single block/brick to expose to
> the distributed filesystem?

I would say ... you're overlooking a level between the two options you 
suggested, which I'd consider to have some benefits under certain 
configurations.

You described a deployment with M number of individual physical server 
pods having N number of physical hdds each.  You then wondered about 
partitioning the individual hdds.  With a suitably high number for N (N=10
+ say, double digits, more than N=3, again, N being the number of 
physical hdds per physical server), I see no value in partitioning 
individual hdds, but there may well be reason to split N into multiple 
individual btrfs on the same physical server, as opposed to grouping them 
into a larger single btrfs with all hdds.

The problem is that btrfs raid1 and raid10 modes only do two-way-
mirroring, but that's two-way-mirroring at the individual chunk level, so 
unlike N-way mirroring raid1 or 2-way-mirroring device-level raid10, loss 
of more than one device is very likely to take out the whole filesystem.  
Thus, it can make sense to configure higher numbers of say 2-3 device 
raid1 btrfs or 4-6 device raid10 btrfs (or 4-9 device total hybrid btrfs 
raid1 on top of mdraid0, 2-3 hdds per mdraid0 device, 2-3 mdraid0 devices 
per btrfs raid1), as opposed to a single filesystem double-digit device 
btrfs raid1 or raid10.  Because 10+ devices btrfs raid1 or raid10 pools, 
risking a second device going out on the pool, is high risk, compared to 
multiple lower number of devices raid1 or raid10, where the risk of 
multiple devices going out on the individual btrfs is much smaller.

But at that level, I'd see no reason to actually partition individual 
hdds.  (Tho if you're limiting N to 2-4 hdds, there's a possible narrow 
case for it.)

Now what this effectively does is add another level to your distributed 
stack.  Instead of having the distributed level and the machine/brick 
level only, with the distributed level composed of multiple machine-
bricks and each machine-brick having a single filesystem pool, you now 
have the distributed level, the machine level, and the individual 
filesystem level, multiple but smaller pools on each machine.

That does change your global/distributed level strategy to some degree, 
because now loss of individual machines can take out multiple filesystem 
pools.  Basically, you need to configure your global level to tolerate 
loss of machine-multiples of the individual filesystems.  So if you're 
doing say three filesystems per physical machine, you will want to 
configure tolerance for at least three, and better six, of the individual 
filesystems, which will handle loss of one and two machines, respectively.

If you're looking at a massive enough number of hdds, say 20+ per 
machine, I'd configure them as mentioned in parenthesis above, btrfs 
raid1 (or raid10) over mdraid0 (or dmraid0 if you prefer), 2-3 physical 
hdds per mdraid0, 2-3 mdraid0s per btrfs raid1 or 4-6 mdraid0s per btrfs 
raid10, 2-3 btrfs per machine.  At the low end per machine that's two hdds 
per mdraid0, two mdraid0s per btrfs raid1, two btrfs raid1 per machine, 
2*2*2=8 hdds per machine, tho at only 8 I'd probably go 9 and do 3 hdd 
mdraid0, 3 mdraid0 btrfs, single btrfs per machine.  At the top end, 
that's 3 hdds per mdraid0, 6 mdraid0s per btrfs raid10, 3 btrfs per 
machine, 3*6*3=54 hdds per physical machine.

If you then configure the global level to tolerate a loss of 6 btrfs, 2 
full machines, with a 20 machine network, that's 54*20=1080 hdds, with a 
minimum loss tolerance of 10%, 108 hdds, 6 btrfs or two full machines.

Sounds like the sort of storage a supercollider might require.  We had a 
guy in here that works for one, for a few months, don't know if he's 
still around.

It is worth noting in all this, however, and I've not seen this brought 
up directly to you yet, that btrfs isn't particularly stable and mature 
yet, tho it is stabilizing (with emphasis on the ING).  With enough 
redundancy and care, you may be fine, but the typical if it's not backed 
up, you don't value it enough to be worth the backup, rule, certainly 
applies, even more to btrfs than to fully mature and stable filesystems, 
and when you're looking at that sort of massive amounts of data, backups 
have a whole new set of problems, the biggest being simply moving that 
amount of data around in a timely enough manner that the backup isn't 
history before it's completed.  Redundancy can help, here, but it's still 
an issue, and the fact of the matter is, btrfs may simply not be at a 
suitable stability point for your usage requirements.

That's actually what the supercollider guy concluded, for his 
requirements, for the time being, btrfs may get there in some years, but 
the massive data rate requirements he had were simply too high to allow 
for timely backups, and he concluded that the risk without them due to 
btrfs' present stability level was simply too high for his needs.

zfs is a more mature filesystem with similar features, tho it has higher 
hardware requirements, in particular, massive amounts of ecc ram is 
strongly recommended on linux, tho less on solaris and I'm not sure on 
the bsds, and there's licensing issues with it on linux that may or may 
not be a problem, depending on how strict your work and legal environment 
is.

Alternatively, xfs is considered stable and mature on linux and is often 
used for huge storage needs, tho without the features of btrfs or zfs, 
and of course there's the standard ext4, again without the features.  
Personally, if I was working on a large project that needed the features 
and could handle the legal situation, but didn't consider btrfs suitably 
stable and mature, I'd go zfs.  If I didn't need the features, probably 
xfs, of course on top of mdraid or possibly hardware raid and mdraid 
hybrid, to get the multi-hdd coverage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

