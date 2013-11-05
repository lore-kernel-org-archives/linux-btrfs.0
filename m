Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48379 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab3KEOVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 09:21:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VdhV6-0000Zu-VH
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 15:21:00 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 15:21:00 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 15:21:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: umount waiting for 12 hours and still running
Date: Tue, 5 Nov 2013 14:20:41 +0000 (UTC)
Message-ID: <pan$70ff2$6c271d88$3a2794d1$837be634@cox.net>
References: <5278F5AA.60108@complete.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Goerzen posted on Tue, 05 Nov 2013 07:42:02 -0600 as excerpted:

> Hello,
> 
> More than 12 hours ago, I tried to umount a btrfs filesystem. Something
> involving btrfs-cleaner and btrfs-transacti is still running, but I
> don't know what.
> 
> I have noticed excessively long umount times before, and it is a
> significant concern for me.
> 
> A bit of background:
> 
> The filesystem in question involves two 2TB USB hard drives.  It is 49%
> full.  Data is RAID0, metadata is RAID1.  The files stored on it are for
> BackupPC, meaning there are many, many directories and hardlinks.  I
> would estimate 30 million inodes in use and many of them have dozens of
> hardlinks to them.

That's a bit of a problem for btrfs at this point, as you rightly mention.

> I thought perhaps converting metadata to raid0 would help.  So I
> started a btrfs balance start -mconver=raid0 on it.

> Kernel 3.10 from Debian wheezy backports on i386.

There's a known bug with balance on current kernels related to pre-
allocated space (as with the systemd journal or torrent files with some 
clients).

A patch is available and queued for 3.13 and then for stable (which 
doesn't take patches unless they're in current mainline already), but 
while 3.12 is out and the 3.13 commit window would normally be open, 
Linus is taking a week off for travel without a good internet connection, 
so the 3.13 kernel commit window is delayed a week.  Which means this 
patch is likely to be delayed a couple weeks before it reaches stable.
=:^(

Here's a link to the post with the patch:

[PATCH] Btrfs: relocate csums properly with prealloc extents

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/28733

I'd suggest applying that to the latest 3.12 kernel and trying the 
balance again.  Unfortunately that means an unsafe reboot without a 
remount read-only or unmount, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

