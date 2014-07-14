Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39883 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbaGNRwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 13:52:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X6kPq-0006OE-Gc
	for linux-btrfs@vger.kernel.org; Mon, 14 Jul 2014 19:51:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 19:51:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 19:51:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS hang with 3.16-rc5
Date: Mon, 14 Jul 2014 17:51:37 +0000 (UTC)
Message-ID: <pan$10815$10a07b04$fff89252$8ecbdf83@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba> <3226395.MP6iD3ZiSL@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Mon, 14 Jul 2014 17:10:30 +0200 as excerpted:

> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>> Hi!
>> 
>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days
>> of usage, with 3-16-rc5 I had a hang again. Less than a hour since
>> booting it.
>> 
>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
>> didn´t happen that quickly after boot and since backtrace looks a bit
>> different from what I have in memory, I post this in a new thread.
>> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
>> issues.
> 
> Probably good to add some basic information on the filesystem: [...]

> I think I switched it to skinny extents, but I am not completely sure.
> 
> 
> Dual SSD BTRFS RAID 1
> 
> No snapshots at the moment. And plenty of space free.

FWIW, I've been updating every few days, running two different snapshots 
between 3.16-rc4 and rc5, and now rc5 itself, and haven't noticed this 
issue.  Dual SSDs btrfs raid1, but partitioned up so the biggest 
partition is under 50 GB.

I've been doing some very heavy (gentoo) package building and shuffling 
around the last few days trying out the kde-frameworks/workspaces-5 
stuff, then deciding it's not yet ready for me, too, so I've been working 
it a bit, too.

But certainly YMMV, and I did have some nasty trouble a few weeks ago, 
which triggered a btrfs restore and then a mkfs on a couple of the 
filesystems.  But nothing at all strange with btrfs since then, or 
really, for awhile before that either.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

