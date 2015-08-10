Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38269 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbbHJDoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Aug 2015 23:44:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZOe0b-0004dJ-B1
	for linux-btrfs@vger.kernel.org; Mon, 10 Aug 2015 05:44:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 05:44:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 05:44:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1 on uneven-sized disks
Date: Mon, 10 Aug 2015 03:44:16 +0000 (UTC)
Message-ID: <pan$e2cc6$643f5894$c0cbb9c9$c1b6a393@cox.net>
References: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
	<20150809124725.GA5486@carfax.org.uk>
	<CAGfcS_kZmWY8PkG8YH_Wp5nFuFygK=VWi7fcimPCubHwwm6M9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sun, 09 Aug 2015 22:25:35 -0400 as excerpted:

> The key is that btrfs manages "raid" at the chunk level, not the
> device level.  When btrfs needs more disk space it allocates a new
> chunk from unallocated space on a device.  If it is in raid1 mode it
> will allocate a pair of chunks from two different drives, storing the
> same data in each.  The allocation algorithm is reasonably smart so if
> you have 2x1TB drives and 1x3TB drive you'll end up with about 2TB of
> data stored and not 1TB on each of the two 1TB drives and an empty
> unusable 3TB drive.
> 
> This is also why you can switch between raid modes "on the fly"[. ...]

Very good explanation, Rich. =:^)

> This also lets you do things like add a disk to a raid5.  If you have
> 5 disks and add one more, existing chunks will be striped across 5
> drives, and new chunks will be striped across 6, unless you balance
> them.

I'm actually posting to add a caveat to this.

While btrfs itself is "getting stable", that is, good enough for daily 
work, but not as mature and well tested as some of the other filesystems 
so do keep things you don't want to lose backed up, btrfs raid56 mode 
(that's raid5 and raid6, the same module, raid56, deals with both) was 
only code-complete with kernel/progs 3.19, and is still quite immature 
and not well tested compared to the rest of btrfs.  With 4.2 it should be 
out of its most critical phase, but I've been warning people to give it a 
year (after 3.19) before considering its stability to be close to the 
rest of btrfs.  Since there's normally ~5 kernel cycles per year, that 
would be 4.4.  Until then, if you're willing to be a guinea pig on it, 
reporting any bugs and working with the devs to test fixes, THANKS, it's 
people like you who help make it dependable for others.  Otherwise, stick 
with the more stable raid1 or raid10 modes until 4.4 or so, and at that 
point if you're still interested in raid56 mode, check the list to see 
how it's doing, and assuming nothing exceptional is going on, /then/ do 
the raid56 thing.

Of course, since the OP question was about raid1, this is probably just 
extra info for him, and mostly to cover anyone else that /might/ be 
looking at raid56 mode at this time, and happens onto this thread.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

