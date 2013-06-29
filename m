Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45631 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab3F2PUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 11:20:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UswwU-0007lL-CO
	for linux-btrfs@vger.kernel.org; Sat, 29 Jun 2013 17:20:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 17:20:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 17:20:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck output: What does it all mean?
Date: Sat, 29 Jun 2013 15:19:44 +0000 (UTC)
Message-ID: <pan$681ed$c263160$bc6fd9da$7b1eb060@cox.net>
References: <kqmoji$hv5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Sat, 29 Jun 2013 14:48:40 +0100 as excerpted:

> This is the btrfsck output for a real-world rsync backup onto a btrfs
> raid1 mirror across 4 drives (yes, I know at the moment for btrfs raid1
> there's only ever two copies of the data...)

Being just a btrfs user I don't have a detailed answer, but perhaps this 
helps.

First of all, a btrfs-tools update is available, v0.20-rc1.  Given that 
btrfs is still experimental and the rate of development, even using the 
live-git version (as I do), is probably the best idea, but certainly, I'd 
encourage you to get the 0.20-rc1 version at least.  FWIW, v0.20-rc1-335-
gf00dd83 is what I'm running, that's 335 commits after rc1, on git-commit 
f00dd83.

(Of course similarly with the kernel.  You may not want to run the
live-git mainline kernel during the commit window or even the first 
couple of rcs, but starting with rc3 or so, a new mainline pre-release 
kernel should be /reasonably/ safe to run in general, and the new kernel 
will have enough fixes to btrfs that you really should be running it.  Of 
course if you've experienced and filed a bug with it and are back on the 
latest full stable release until it's fixed, or if there's a known btrfs 
regression in the new version that you're waiting on a fix for, then the 
latest version without that fix is good, but otherwise, if you're not 
running the latest kernel and btrfs-tools, you really might be taking 
chances with your data that you don't need to take, due to already 
existing fixes you're not yet running.)

> checking extents
> checking fs roots
> root 5 inode 18446744073709551604 errors 2000
> root 5 inode 18446744073709551605 errors 1
> root 256 inode 18446744073709551604 errors 2000
> root 256 inode 18446744073709551605 errors 1

Based on the root numbers, I'd guess those are subvolume IDs.  The 
original "root" volume has ID 5, and the first subvolume created under it 
has ID 256, based on my own experience.

What the error numbers refer to I don't know.  However, based on the 
identical inode and error numbers seen in both subvolumes, I'd guess that 
#256 is a snapshot of #5, and that whatever is triggering the errors 
hadn't been written after the snapshot (thus copying the data to a new 
location), so when the errors happened in the one, it happened in the 
other as well, since they're both the same location.

The good news of that is that in reality that's only the one set of 
errors duplicated twice.  The bad news is that it affects both snapshots, 
so if you don't have different snapshot with a newer/older copy of 
whatever's damaged in those two, you may simply lose it.

> found 3183604633600 bytes used err is 1
> total csum bytes: 3080472924

csum would be checksum...  The rest, above and below, says in the output 
pretty much what I'd be able to make of it, so I've nothing really to add 
about that.

> total tree bytes: 28427821056
> total fs tree bytes: 23409475584
> btree space waste bytes: 4698218231
> file data blocks allocated: 3155176812544
>  referenced 3155176812544

> Btrfs Btrfs v0.19

Meanwhile, you didn't mention anything about the --repair option.  If you 
didn't use it just because you want to know a bit more about what it's 
doing first, OK, but while btrfsck lacked a repair option for quite some 
time, it has had a --repair option for over year now, so it /is/ possible 
to try to repair the detected damage, these days.

Of course you might be running a really old 0.19+ snapshot without that 
ability (distros packaged 0.19+ snapshots for some time during which 
there was no upstream release, tho hopefully the distro package has 
something about the snapshot it was, but we know your version is old in 
any case since it's not 0.20-rc1 or newer, but still 0.19 something).

I'd suggest ensuring that you're running the latest almost-release 3.10-
rc7+ kernel and the latest btrfs-tools, then both trying a mount and 
running the btrfsck again.  You can both watch the output and check the 
kernel log for output as it runs, and as you try to mount the 
filesystem.  It may be that a newer kernel (presuming your kernel is as 
old as your btrfs-tools appear to be) might fix whatever's damaged on-
mount, so btrfsck won't have anything left to do.  If not, since you have 
backups of the data (well, this was the backup, you have the originals) 
if anything goes wrong, you can try the --repair option and see what 
happens.  If that doesn't fix it, post the logs and output from the 
updated kernel and btrfs-tools btrfsck, and ask the experts about it once 
they have that to look at too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

