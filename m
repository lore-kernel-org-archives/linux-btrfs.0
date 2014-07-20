Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36131 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGTNxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 09:53:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8rYg-0006eu-He
	for linux-btrfs@vger.kernel.org; Sun, 20 Jul 2014 15:53:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 15:53:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 15:53:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Sun, 20 Jul 2014 13:53:34 +0000 (UTC)
Message-ID: <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net>
References: <loom.20140720T102642-239@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TM posted on Sun, 20 Jul 2014 08:45:51 +0000 as excerpted:

> One week for a raid10 rebuild 4x3TB drives is a very long time.
> Any thoughts?
> Can you share any statistics from your RAID10 rebuilds?

Well, 3 TB is big and spinning rust is slow.  Even using the smaller 
power-of-10 (1000) figures for TB that the device manufacturers use 
instead of the power-of-2 (1024, TiB) figures that are common in 
computing...

TB GB   MB   KB   B    KiB  MiB s/hr day wk
3*1000*1000*1000*1000/1024/1024/3600/24/7=4.73+ MiB/sec

At a week, that's nearly 5 MiB per second, which isn't great, but isn't 
entirely out of the realm of reason either, given all the processing it's 
doing.  A day would be 33.11+, reasonable thruput for a straight copy, 
and a raid rebuild is rather more complex than a straight copy, so...

Which is one reason a lot of people are using partitioning to break down 
those huge numbers into something a bit more manageable in reasonable 
time, these days, or switching to much faster if also much more expensive 
per GiB (USD 50 cents to $1 per gig vs 5-10 cents per gig) SSDs.

And btrfs is still under development so hasn't been really optimized yet 
and is thus slower than necessary -- in particular, it often serializes 
multi-device processing where given that the bottleneck is normally 
device IO, an optimized algorithm would parallel-process all devices at 
once.  Just parallelizing the algorithm could give it a 2-4X speed 
increase on a 4-device raid10.

So you're right, it /is/ slow.

> If I shut down the system, before the rebuild, what is the proper
> procedure to remount it? Again degraded? Or normally? Can the process of
> rebuilding the raid continue after a reboot? Will it survive, and
> continue rebuilding?

Raid10 requires four devices for undegraded layout, but I /think/ once it 
has a forth device added back in, you should be able to mount it 
undegraded, as it can write changes to four devices at that point.  Tho 
I'm not positive about that.  I'd try mounting it undegraded here and if 
it worked, great, if not I'd mount it degraded again.

Regardless of that, however, barring bugs, provided you shut down 
properly (umounting the filesystem, etc), a shutdown and reboot should be 
fine, and it should continue where it left off after the reboot, as 
internally it's simply doing a rebalance of existing data to include the 
new device, and btrfs is designed to gracefully shutdown in the middle of 
a rebalance and restart it on reboot, when necessary.

Tho don't expect umount and shutdown to be instantaneous.  After you 
issue the umount command, it shouldn't start any new chunk balances, but 
it could require a bit to finish the balances in-flight at the time you 
issued the shutdown.  If it takes more than a few minutes, however, 
there's a bug.  FWIW, data chunks are a GiB in size, which at the 
calculated rate of a bit under 5 MiB/sec, should be ~205 seconds or 
roughly 3.5 minutes.  Doubling that and a bit more to be safe, I'd say 
wait 10 minutes or so.  If it hasn't properly umounted after 10 minutes, 
you likely have a bug and may have to recover after a reboot.  With btrfs 
still under heavy development backups are STRONGLY recommended so I hope 
you have them, but at this point anyway, while it's slow going there's no 
indication that you'll actually need to use those backups.  Just expect 
the umount to take a bit.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

