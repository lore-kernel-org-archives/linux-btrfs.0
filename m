Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37248 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaIXNXt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 09:23:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XWmXp-0001af-2e
	for linux-btrfs@vger.kernel.org; Wed, 24 Sep 2014 15:23:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 15:23:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 15:23:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount problem
Date: Wed, 24 Sep 2014 13:23:32 +0000 (UTC)
Message-ID: <pan$b29db$c1fc8f39$f1e6e06c$d6b3042c@cox.net>
References: <20140923120641.GA27624@galliera.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simone Ferretti posted on Tue, 23 Sep 2014 14:06:41 +0200 as excerpted:

> we're testing BTRFS on our Debian server.  After a lot of operations
> simulating a RAID1 failure, every time I mount my BTRFS RAID1 volume the
> kernel logs these messages:
> 
> [73894.436173] BTRFS: bdev /dev/etherd/e30.20 errs:
> wr 33036, rd 0, flush 0, corrupt 2806, gen 0
> [73894.436181] BTRFS: bdev /dev/etherd/e60.28 errs:
> wr 244165, rd 0, flush 0, corrupt 1, gen 4
> 
> Everything seems to work nice but I'm courious to know what these
> messages mean (in particular what do "gen" and "corrupt" mean?).

Gen=generation.  The generation or transaction-ID (different names for 
the exact same thing) is a monotonically increasing integer that gets 
updated every time a tree update reaches all the way to the superblock.  
In the error context, it means the superblock had one generation number 
but N other blocks had a different (presumably older) generation number.

Corrupt is simply the number of blocks where the calculated checksum 
didn't match the recorded checksum, thus indicating an error.

Of course rd=read, wr=write...

In raid1 mode scrub can typically find and fix many of these errors.  My 
brtfs are mostly raid1 mode, and when I crash and reboot, scrub nearly 
always finds and fixes errors on the two btrfs (independent btrfs full-
filesystems, not subvolumes, /var/log and /home) I normally have mounted 
rw.

But do note that this is the HISTORIC count, counting all errors since 
the counts were reset.  Thus, they'll still be reported after scrub or 
whatever has fixed them.  As long as the numbers don't increase, you're 
good.  Any increase indicates additional problems.

See btrfs device stats -z to reset the numbers to zero (after printing 
them one last time).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

