Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39848 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaAAJVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 04:21:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VyHzq-0001bq-Fq
	for linux-btrfs@vger.kernel.org; Wed, 01 Jan 2014 10:21:50 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 10:21:50 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 10:21:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs corruption after resuming from suspend to disk
Date: Wed, 1 Jan 2014 09:21:28 +0000 (UTC)
Message-ID: <pan$220e1$19a410f7$7939eff1$2528d292@cox.net>
References: <CAM6NUi5hmX3vwPsG1rOQbCH+KNS=P927Hxbhc8Vt8bu1qCv6pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicolas Boichat posted on Wed, 01 Jan 2014 14:01:16 +0800 as excerpted:

> I've been running btrfs for less than a month now, on my /home
> directory. Not sure if it is relevant, but I had a number of kernel
> panics over that month (unrelated to btrfs). Yesterday, upon resuming
> from suspend to disk, the partition was remounted as read-only, so I
> rebooted, hoping to fix the problem.
> 
> Since then, I'm unable to mount the partition.

Just another btrfs user here so no dev insights, but similar altho less 
serious resume from suspend (to RAM in my case, s2disk didn't work on 
this machine last I tried and I don't even have a swap/suspend partition 
ATM) issues...

In my case (with dual-SSD btrfs in raid1 data/metadata), the root of the 
problem seems to be the supercapacitor on the SSDs taking too long to 
recharge if the system has been in s2ram too long (with the SSDs powered 
down).  For original boot, the kernel has the rootwait commandline 
option, which waits until the drives respond properly before attempting 
to continue.  But apparently that doesn't apply to s2ram, so if the 
system has been in suspend more than about four hours and supercapacitor 
is mostly discharged, it takes too long to charge and that drive drops 
out of the mount.

That forces the mount read-only for safety even tho there's still one 
device left in the raid1, which triggers various I/O stalls, and 
ultimately a system live-lock within a few minutes, from which I have to 
reboot.

After the reboot, the affected filesystems have always mounted, but a 
scrub turns up and fixes errors, as expected when one of the pair of a 
raid1 drops out.

But while the scrub does apparently fix the filesystem state, at least 
once it left a couple corrupt files, files that had been open at 
suspend.  These were my user's .bashrc and .xsession-errors files.  Any 
attempt to recover content, even read-only via cat, etc, would stall the 
accessing process.  (IDR whether I had to reboot or could continue with a 
different process, however.)  Of course that meant that user couldn't 
login AT ALL until .bashrc was removed, and couldn't startx 
until .xsession-errors was removed as well.

Fortunately I run an independent btrfs (not subvolumes) root that's read-
only mounted by default (only read/write remounted for updates), so it's 
never affected and I can always login as root to run the scrub and 
troubleshoot.

Of course that's not really a btrfs error, but a missing kernel feature, 
as a kernel started with rootwait likely has a reason that's there, and 
waiting for the disks to appear and stabilize before giving up on finding 
them when s2ram resuming would seem a wise idea as well.  I've been going 
to file a bug or otherwise report it to the suspend subsystem folks, but 
haven't yet.

> I tried a number of repair commands, see the output there:
> https://gist.github.com/drinkcat/8193276
> 
> I also tried git://repo.or.cz/btrfs-progs-unstable/devel.git, branch
> integration-20131219, without success (./btrfs rescue chunk-recover -v
> /dev/sdb3 does not throw any errors though, but that doesn't fix the
> filesystem).

Your problem may be too serious for this to work, but if you tried it, I 
missed it, and it did work for me with some fail-to-mount issues I had 
quite some time ago.

In that case the corruption was apparently only in the space-cache, and 
mounting with clear_cache was all I needed to do.  After that, the 
filesystem mounted normally, and I could do a scrub to ensure it was fine.

With a bit of luck that'll work for you too, tho I'd guess one things you 
tried would have cleared that too... but I don't know.

I'd also try (and didn't see) btrfs-zero-log, and btrfs restore, possibly 
in combination with btrfs-find-root.

Btrfs-zero-log is covered in the problem FAQ (wrapped link):

https://btrfs.wiki.kernel.org/index.php/
Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21

Be sure to work on a copy with zero-log as it can make the problem worse 
if it doesn't fix it.

Here's the wiki page for restore, covering find-root too.

https://btrfs.wiki.kernel.org/index.php/Restore

That's non-destructive, so shouldn't make the problem worse.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

