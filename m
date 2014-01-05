Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41763 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbaAEANS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 19:13:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzbLB-0005gj-2W
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 01:13:17 +0100
Received: from 91-115-176-221.adsl.highway.telekom.at ([91.115.176.221])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 01:13:17 +0100
Received: from sulla by 91-115-176-221.adsl.highway.telekom.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 01:13:17 +0100
To: linux-btrfs@vger.kernel.org
From: Sulla <sulla@gmx.at>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Sun, 5 Jan 2014 00:12:55 +0000 (UTC)
Message-ID: <loom.20140105T005514-795@post.gmane.org>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <loom.20140101T204832-543@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh gosh, I don't know what went wrong with my btrfs root filesystem, and I
probably will never know, too:

The "sudo balance start /" was running fine for about 4 or 5 hours, running
at a system load of ~3 when "balance status /" told me the balancing was on
its way and had completed 19 out of 23 extents.

At this moment the system load started to increase and increase an increase
and when it reached 147 (!!) (while top was showing me NOTHING was going on)
I resetted the computer. TTY1 showed some kernel panics and btrfs-bug
messages, but those files were lost because they've never made it to disk.

Fortunately my RAID5 stayed in sync and everything was fine. System also
booted, but with the same 120+ secs hangs as before. System was unusable, as
e.g. all IMAP logins time-out-ed.

So
* I booted into a live-CD
* mounted a backup disk
* cp-ed all files of the root fs to the backup disk (it could read them
flawlessly)
* formatted the root-partition to ext4 (yes, I feel sad about it)
* cp-ed all root-files from the backupdisk to the ext4 root system
* stroke the subvol=@ boot argument from /boot/grub/grub.cfg
* and rebooted my server.

How I love linux! Wouldn't be possible with M$!!

Now its running fine again, system is responsive as it should be. No clue
'bout what went wrong, though.

I still have /home and the huge data partitions on btrfs and plan to leave
it so. While it would not be difficult to put /home on ext4 it would be a
major effort to cp the ~3TB data off and on the disks...

Thanx for your support,
Sulla

