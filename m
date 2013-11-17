Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57986 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3KQUF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 15:05:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vi8bT-0005c6-2L
	for linux-btrfs@vger.kernel.org; Sun, 17 Nov 2013 21:05:55 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 21:05:55 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 21:05:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs resize partition problem
Date: Sun, 17 Nov 2013 20:05:34 +0000 (UTC)
Message-ID: <pan$cc148$5523c730$89b04fcf$f580ae04@cox.net>
References: <5287D775.1090105@gmail.com>
	<pan$32f6c$5635c224$e9b25768$a7831c50@cox.net>
	<201311172305.04091.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 17 Nov 2013 23:05:04 +1100 as excerpted:

> My home server has / and /home on a SSD and a RAID-1 array of 2*3TB
> disks mounted on /big.  I have had a number of BTRFS related problems
> with that system and BTRFS for / hasn't made it easier to solve them.

Once drive sizes got big enough, the way I solved the how-to-fix-root 
problem here is by keeping two (or three) identically sized root and root-
bak partitions around.  Periodically, when I'm content that the system in 
general is stable-state and working well[1], I'll blow away the backup-
root and snapshot-copy the working root over to it again.  (That's why I 
like having a third copy too, what happens if something goes wrong with 
the working copy at just the moment I've blown away the backup in ordered 
to redo it?)

And with separate partitions for /home, multi-media, packages/update, 
/boot, and /var/log (plus /tmp and /run on tmpfs in memory), the root 
partition, containing basically the entire installed operating system 
including all apps and their system-level configuration and data plus 
installed-package database[2], is /only/ 8 gigs in size, df reporting 25% 
used so there's a nice, comfortable safety margin.  That means I keep (at 
least) three 8-gig root partitions in various places, working-root, 
primary and secondary backup-root.

In addition to functioning as full root backups, each of the three is 
independently bootable by simply changing the root= parameter fed to the 
kernel at boot time, and in fact, my grub2 menu is setup so I can choose 
any of the three direct from it, without even having to drop to the grub 
commandline.  As a result, if root needs a proper fsck or if an after-all 
~arch/testing profile update broke something critical and I can't boot 
the working root, I simply choose the primary or secondary backup root, 
and have a full working system (manpages/documentation, X-desktop and 
browser, even media players!) exactly the same as it was when I took that 
backup.

My actual drive setup is currently two SSDs where I run btrfs partitions 
mostly in raid1 mode, and a larger legacy spinning-rust drive with the 
media partition (and its primary backup) and additional non-btrfs backups 
of the main system, plus another (external) spinning-rust drive with 
further backups.  Since btrfs is still experimental, for the purposes of 
backup policy I worst-case btrfs as totally lost and keep backups as if I 
didn't have the SSDs and btrfs at all.  (Which means in all I actually 
have something like working copy plus six levels of backup for root, the 
working copy and primary backup on btrfs on the ssds that I don't count 
because btrfs is experimental, the fallback working copy and two backups 
on the internal spinning rust reiserfs should the experimental label of 
btrfs live up to its name, and the two external drive last-resort 
backups, tho they're actually rather outdated ATM, but I could fallback 
to them if I had to.)

---
[1] Stable state, working well:  I'm on gentoo, a rolling-release distro, 
running ~arch aka testing, not stable, and in fact I'm often running live-
git pre-release versions of this or that as well, so sometimes I do /not/ 
consider the system in a stable state!

[2] Installed-package database:  Remember, gentoo's rolling-release, so 
keeping track of what's actually installed is important.  One disaster-
recovery experience some years ago taught me the importance of that when 
I had the installed-package database on a partition separate from root 
with all the actual installed-packages it was tracking, and I ended up 
restoring from backups where the installed-package database was from a 
different date and thus out of sync with what was /actually/ installed!  
*NEVER* *AGAIN*!  They're on the same filesystem now, so they stay in 
sync and restore together!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

