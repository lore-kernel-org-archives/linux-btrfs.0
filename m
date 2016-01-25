Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbcAYB2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 20:28:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aNVxW-0007Fp-R7
	for linux-btrfs@vger.kernel.org; Mon, 25 Jan 2016 02:28:46 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 02:28:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 02:28:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1
 rebalancing
Date: Mon, 25 Jan 2016 01:28:41 +0000 (UTC)
Message-ID: <pan$6551c$cfdb8b0$958d7736$2662915a@cox.net>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
	<CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
	<20160124211700.GF908@breitenfeld.lan>
	<CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
	<20160124221614.GH908@breitenfeld.lan>
	<CAJCQCtRtZ+LxwZ8e_5s3AEfJ-a7wU9_DLz=UBNiJyY190i0CXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 24 Jan 2016 15:45:49 -0700 as excerpted:

> Maybe it's an orphaned item. I don't know much about those, whether
> btrfs check finds or removes them. But you can safely use
> btrfs-debug-tree while the fs is mounted.
> 
> btrfs-debug-tree <dev> | grep -A3 -B3 ORPHAN
> 
> That'd find object type ORPHAN and item type ORPHAN_ITEM. Again, no idea
> what to do about it if either are found, and matches inode 515.
> You could also do a search using
> 
> btrfs-debug-tree <dev> | grep -A3 -B3 "(515 "

Orphans, in POSIX filesystem context, are files that are open, but 
deleted.  Think shared object libraries (*.so*) that are loaded by a 
running program at the time they're updated, in which context it's a 
security issue as well since some of those updates might have been 
security related and existing processes continue to use the old, 
vulnerable versions until they are restarted.  These files can be 
logically deleted so nothing else can access them, but the filesystem 
can't remove all references to them until all running programs holding 
them open have closed them.  That's what makes them orphan -- nothing new 
can access them, but existing references mean they can't yet be fully 
removed from the filesystem, either.

Typically such orphans block unmounting or remounting the filesystem 
readonly (unless it's forced read-only by filesystem error or kernel 
emergency-SRQ sequence, etc, which override things and locks orphans in 
their existing state on the filesystem, just as a crash would, except it 
doesn't necessarily immediately crash, tho a livelock often follows 
pretty quickly).

There are various tools available that can find these files and tell you 
which processes are holding them open and/or kill or restart those 
processes in ordered to release the locks and close the files, allowing 
them to be fully deleted.  I routinely use one after updates here called 
lib_users, which simply tells me what processes are holding open these 
deleted files, so I can decide whether I want to restart them, kill them, 
or simply ignore the problem until later.  

In a system reboot (or simple descent to single user or systemd emergency 
mode to stop most services, systemd itself can then be reexecuted using 
systemctl daemon-reexec, if it's holding open deleted files as well, 
before returning to normal mode), normal processes and system services 
are stopped, releasing these files, so the filesystem can clean them up 
before unmount or remount-readonly.

(Here, my root, including /usr, remains mounted read-only by default, 
only being mounted writable for updates.  Thus my routine use of 
lib_users to find services I need to restart, or if there's too many, 
decide I want to temporarily go to systemd emergency mode, before 
returning to normal mode, releasing all these deleted files in the 
process, so I can cleanly remount / read-only once again.  That of course 
is the reason I know a bit more about this than many, since it's part of 
my update routine now.)

Of course in an unclean shutdown situation, the filesystem will not have 
had the chance to clean up the orphans before the umount or remount-
readonly, so these orphans remain around at reboot and must be cleaned up 
then.  Btrfs at least, does this automatically, so btrfs check need not 
be run to do it, as the check has to be done on an unmounted filesystem, 
and at mount, btrfs will handle it, itself.  However, btrfs check may 
still clean them up as well (I'm not sure), simply to avoid other issues 
the orphan files might have that are easiest eliminated by simply 
eliminating the files, since that's what would happen on mount anyway.


If it's orphan files, just quitting X (or logging out and back in if you 
use a *DM graphical login, I don't, preferring to login at the CLI and 
run startx) tends to release a lot of them, no reboot needed.  But 
sometimes quitting X and restarting other services holding open deleted 
files may be necessary as well, and if there's enough such services, 
descending to emergency/single-user mode, and possibly restarting init/
systemd itself, if it is holding open any such files, may be necessary.  
But a full reboot isn't normally needed.

Tho of course restarting X, and descending to emergency/single-user-mode 
even more so, can in practice be as bad as having to reboot.  Going to 
emergency/single-user especially, pretty much all you save in practice is 
your uptime statistics and caches that would be lost on a full reboot.  
But if you're running over a year uptime (yeah, right, on a still not 
fully stable btrfs where the recommendation is to keep to reasonably 
current kernels, hardly the stuff of year-plus uptimes!), or have 
spinning rust and lots of RAM and thus cache that would have to be 
reloaded from the slow spinning rust, going single-user to avoid dropping 
them can be well worth the hassle over simply rebooting.


Meanwhile, if it /is/ an orphan file, it's an interesting situation, 
since that means the checksum was fine and btrfs was able to load the 
file when whatever is holding it open/orphan was started, but that isn't 
the case now.  Which means we have evidence of near-real-time (well, 
depending on how long the file has been open) block decay and checksum 
invalidation, which has serious implications in terms of storage device 
health.  Be sure to run smartctl -AH, or similar, to see what's going on, 
and track it closely for awhile, as you may well have a failing device!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

