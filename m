Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50000 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaEZNiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 09:38:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wov6d-0002Qw-Jd
	for linux-btrfs@vger.kernel.org; Mon, 26 May 2014 15:38:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 15:38:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 15:38:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unregular BTRFS hangs on SSD based BTRFS RAID 1
Date: Mon, 26 May 2014 13:38:12 +0000 (UTC)
Message-ID: <pan$c25c3$718f91c6$6535ad8d$a794a539@cox.net>
References: <3949539.723lBlDIbC@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Mon, 26 May 2014 14:13:28 +0200 as excerpted:

> I donÂŽt know where this unknown, single chunk came from:
> 
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=145.97GiB, used=125.69GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.65GiB
> unknown, single: total=512.00MiB, used=0.00
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: [âŠ]
>         Total devices 2 FS bytes used 128.34GiB
>         devid    1 size 150.00GiB used 150.00GiB path /dev/dm-0
>         devid    2 size 150.00GiB used 150.00GiB path /dev/dm-4
> 
> Btrfs v3.14.1
> 
> 
> Last scrub from last week was okay, but I will rescrub after installing
> 3.15-rc7.

Answering this aspect (not much help on the larger question, tho)...

Kernel 3.15 splits out a subtype of (I think) metadata into a separate
type that btrfs-progs 3.14.1 and earlier doesn't know anything about,
so it simply lists it as "unknown".  Presumably there will be a btrfs
3.15 userspace release shortly after kernel 3.15.0 releases, that will
identify this new category properly.

It should be harmless, tho.  In btrfs-progs 3.14.1, balance, etc, should
work with "unknown" as part of metadata.

This came up on the list previously, but I've a personal project going
on ATM that I've been focusing on and thus didn't do my usual rc2 or so
switch, and am still on 3.14 ATM, and I don't remember the exact details.

But FWIW, on SSD-backed btrfs raid1 here (still on 3.14 as mentioned),
and haven't seen any of these hangs.  However, I'm not using LVM or
device-mapper at all here, and indeed, don't have it installed.  A
further difference is that I have the SSDs partitioned and am running
multiple independent btrfs, one per partition pair (one on each device),
with my largest btrfs being only 24 gig (per device).  So if the problem
is either LVM or larger size related, I'd not see it.

The SSDs are Corsair Neutron 256-gig BTW (not Neutron GTX), only about
half partitioned so plenty of unallocated space for the firmware to do
its thing.  The firmware has as a bullet point feature that it doesn't
do anything funny with compression or the like, so if it's some btrfs
interaction with compressing firmware or something, I'd not see it either.

---
[1] Personal project: Catching up 8 or 9 months of LWN weekly editions,
as it happens.  I'm on January 30's edition now, so about half done and
progressing a month or two per week, so should be caught up in 2-3 weeks
at the current rate.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

