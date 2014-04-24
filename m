Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40943 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaDXKca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 06:32:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WdGx2-0004dw-Ej
	for linux-btrfs@vger.kernel.org; Thu, 24 Apr 2014 12:32:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 12:32:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 12:32:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: inode cache rebuild problem
Date: Thu, 24 Apr 2014 10:32:02 +0000 (UTC)
Message-ID: <pan$d038e$7f5b1007$d20628fc$207de29f@cox.net>
References: <2497757.A2A0fxBM0J@bheem>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shridhar Daithankar posted on Wed, 23 Apr 2014 23:07:13 +0630 as
excerpted:

> I have a desktop system with 2 disks, all btrfs, single partition. All
> of these partitions had space_cache,inode_cache enabled.

> But even on clean reboot, inode_cache was constantly being rebuilt on
> each boot. While the disk was constantly grinding in the boot process,
> I ssh'ed into it from another machine and observed the inode cache
> overhead.
> 
> Hence I disabled both the caches on all the partition(yes, I know,
> space_cache will stick around), and the machine is lot more snappier and
> responsive than ever before.
> 
> I am running archlinux with 3.14.1 kernel.

The recommendation on this list has always (well, for as long as I've 
been around anyway) been to disable the inode cache, unless you know what 
you're doing and am sure you need it.  I've not seen a lot of detail on 
why, but apparently it simply isn't appropriate for normal users.

You've basically proved the point...

Actually, I wouldn't mind a bit more information on exactly what the 
option does and under what circumstances one might wish to enable it, 
myself.

But based on the few hints I've seen, an example of where it may be 
useful is for relatively high volume mail servers with a large churn of 
relatively small files, writing and deleting them pretty much constantly 
as new mail comes in and then is forwarded and deleted.  In that context, 
an inode cache might make some sense even if it's reinitialized at every 
reboot, because such machines are seldom rebooted.

OTOH, space_cache *IS* supposed to be useful for ordinary users, the 
reason it's enabled by default, these days.  And if it's having to be 
reinitialized at every boot, you have a bug.  (There has been at least 
one report of such happening, but IIRC it was fixed tho I don't recall 
the details.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

