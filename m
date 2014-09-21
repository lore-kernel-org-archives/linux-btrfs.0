Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52136 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbaIUHBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 03:01:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XVb97-00086E-IM
	for linux-btrfs@vger.kernel.org; Sun, 21 Sep 2014 09:01:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 09:01:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 09:01:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: deleting a dead device
Date: Sun, 21 Sep 2014 07:01:09 +0000 (UTC)
Message-ID: <pan$e422f$7bb05c96$557446c8$a9f98e73@cox.net>
References: <201409211139.17295.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 21 Sep 2014 11:39:17 +1000 as excerpted:

> On a system running the Debian 3.14.15-2 kernel I added a new drive to a
> RAID-1 array.  My aim was to add a device and remove one of the old
> devices.

That's an old kernel and presumably an old btrfs-progs.  Quite a number 
of device management fixes have gone in recently, and you'd likely not be 
in quite that predicament were you running a current kernel (make sure 
it's 3.16.2+ or 3.17-rc2+ to get the fix for the workqueues bug that 
affected 3.15 and thru 3.16.1 and 3.17-rc1).

And the recommended way to handle a device replace now would be btrfs 
replace, doing the add and delete in a single (albeit possibly long) step 
instead of separately.

[snip most of the problem description]

> The drive is attached by USB so I turned off the USB device and then got
> the above result.  So it still seems impossible to remove the device
> even though it's physically not present.  I've connected a new USB disk
> which is now /dev/sdd, so it seems that BTRFS is keeping the name
> /dev/sdc locked.
> 
> Should there be a way to fix this without rebooting or anything?

Did you try btrfs device delete missing?  It's documented on the wiki but 
apparently not yet on the manpage.  According to the wiki that deletes 
the first device that was in the metadata but not found when booting, so 
you may have to reboot to do it, but it should work.  Tho with the recent 
stale-devices fixes, were that a current kernel you may not actually have 
to reboot to have delete missing work.  But you probably will on 3.14, 
and of course to upgrade kernels you'd have to reboot anyway, so...

> Also as an aside, while the stats about write errors are useful, in this
> case it would be really good if there was a count of successful writes,
> it would be useful to know if the successful write count was close to 0.
>  My understanding of the BTRFS design is that there would be no
> performance penalty for adding counts of the number of successful reads
> and writes to the superblock.  Could this be done?

Not necessarily for reads, consider the case when the filesystem is read-
only as my btrfs root filesystem is by default -- lots of reads but 
likely no writes and no super-block updates for the entire uptime.  But I 
believe you're correct for writes, since they'd ultimately update the 
superblocks anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

