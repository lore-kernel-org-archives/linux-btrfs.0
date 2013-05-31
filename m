Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab3EaOYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 10:24:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UiQG1-000623-LK
	for linux-btrfs@vger.kernel.org; Fri, 31 May 2013 16:24:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 16:24:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 16:24:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: degraded two-device btrfs raid1 (data/metadata) questions
Date: Fri, 31 May 2013 14:24:25 +0000 (UTC)
Message-ID: <pan$8e5ed$b63791f$8b3cc2f5$8c662141@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) Suppose I mount a 2-device raid1 (data/metadata both) degraded, or 
suppose one device drops out.

2) Now, I umount (or mount -o,ro, still degraded) and mount again, not 
degraded.

Questions:

a) How can I be sure that the btrfs mounted the second time with all 
devices?

b) How do I make sure all devices are again in sync? (IOW, that dropping 
a device won't lose data/metadata.)

b1) How do I check that?

b2) What command to I run to get it that way?


The reason I'm asking is that when I tested mounting a raid1 (both data/
metadata) btrfs root filesystem from the kernel commandline, I couldn't 
get it to actually mount with rootflags=device=, until I tried degraded.

With degraded it mounted, so I looked around, running btrfs fi df, btrfs 
fi show, btrfs dev stat, etc, and from all I could see it was active with 
both devices.

So I changed a file, shutdown (mounting ro in the process, since it was 
root and thus couldn't be umounted), and restarted, this time using 
degraded on the other device in the filesystem.

Unfortunately, despite all indications I could find displaying that (I 
guessed with the remount rw), it had found the second device and it was 
no longer degraded, the change made didn't carry over to the other 
filesystem -- it still had the old file.

Reboot back to the first one and it again had the changed file.

Reboot to an alternate (reiserfs) root, mount the btrfs, and TO MY 
SURPRISE IT DIDN"T REQUIRE DEGRADED TO MOUNT, EVEN THO THE TWO DEVICES 
HAD BEEN SEPARATELY BOOTED AND THUS HAD DIFFERING DATA!!

The combined fs had the changed file, but again I shut down and mounted 
the second device (with the old file, direct from the kernel command line 
so I had to use degraded again), and again, it showed the unchanged old 
file!!

kernel/md raid works FAR more dependably than this!  I can see exactly 
which devices are there and whether they're synced from /proc/mdstat.  
Further, if I re-add a device that had fallen out of the raid, md 
automatically syncs it, no back and forth between stale and new depending 
on how I mount.

Not to mention, mounting by listing the devices on the kernel command 
line for md to assemble actually WORKS.

Meanwhile, one final thing I tried, figuring it'd detect the bad data and 
update it, a btrfs scrub.  (I think I should have used a balance, and I'm 
not sure how it would have resolved the fact that I booted each one 
separately, but I EXPECTED btrfs to refuse to mount the combined devices 
filesystem once I'd done that, and to have to do the equivalent of re-
add.)

BTW, what *IS* the equivalent of md's re-add command, if it differs from 
the above (b2)?

Unfortunately, the scrub command locked up (just the command, not the 
whole kernel).  Btrfs scrub status locked up to, as did btrfs scrub 
cancel, tho one of them I was ultimately able to kill (the other one and 
the original scrub not).

I left it that way, no visible disk activity (except that from whatever 
else I did while I was waiting), for several hours.  Finally I had to 
shutdown.

Luckily I'm still running tests and wasn't really switched to that 
filesystem yet (and I know to keep backups even when I do, since btrfs is 
still development/testing), only testing to see if I could boot it 
properly.  So not trusting that filesystem any more I did a clean 
mkfs.btrfs (on an ssd so the full discard should have cleaned up any 
loose bits) and started over.

Now, I'm setting up a minimal initramfs just to user-space mount the 
btrfs root properly so I don't have to mount it degraded.

But I'm still left wondering how I'm supposed to tell whether it's 
actually running degraded or not, and how to sync everything back up if 
so.  And I'm also wondering why btrfs even LET me mount the combined both 
devices filesystem (without using degraded) once the two devices had 
diverged, each being separately booted to rw mode so a simple resync 
shouldn't be able to work, and how it is /expected/ to handle that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

