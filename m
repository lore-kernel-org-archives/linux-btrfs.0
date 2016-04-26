Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbcDZDTc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:19:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1autX7-00048U-Ux
	for linux-btrfs@vger.kernel.org; Tue, 26 Apr 2016 05:19:30 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 05:19:29 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 05:19:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Possible Double Freeing of dentry in check_parent_dirs_for_sync
Date: Tue, 26 Apr 2016 03:19:24 +0000 (UTC)
Message-ID: <pan$dfdfa$d05561a3$fc02314e$1982198d@cox.net>
References: <5704868C.9000702@gmail.com>
	<CAL3q7H5mcO8QWTsXjb0jT6nwe3SN3G5T1xZd3bBfG5faX=1xxg@mail.gmail.com>
	<CADJPUQ8=WVZH6WQuL_WLQqgbJWCwRKNJYtT1vZf308mZTAy+Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Paulo Dias posted on Mon, 25 Apr 2016 22:40:59 -0300 as excerpted:

> hi/2 all..
> 
> we are in 4.6 rc5 and im still seeing a LOT of this with my SSD:
> 
> Abr 25 22:38:01 hydra kernel: ------------[ cut here ]------------
> Abr 25 22:38:01 hydra kernel: WARNING: CPU: 1 PID: 6236 at
> /home/kernel/COD/linux/fs/btrfs/inode.c:9261
> btrfs_destroy_inode+0x247/0x2c0 [btrfs]

I, OTOH, am not seeing any of them here, also SSD, after upgrading to 
pre-4.6-git shortly after 4.6-rc4. <shrug>

But my use-case is apparently less stress on the filesystem than many.  
Multiple small (largest is 24 GiB usable) btrfs raid1 on a pair of 
parallel-partitioned ssds, save for /boot, which is tiny (256 MiB)
mixed-bg dup mode, with the first backup on the other device and the grub 
install for each device pointing at its /boot, so I can bios-select the 
backup when needed.  The only serious problems I had were when one of the 
two ssds was going bad, forcing a replacement, after which I've not had 
major problems of any sort.

Also, as I'm using multiple independent btrfs, including identically 
sized fallbacks as first backup on the same pair of physical devices, I 
don't use subvolumes and don't do snapshots.  Also, no active quotas and 
I mount with autodefrag, ssd is automatically detected, and I don't use 
the discard mount option.

So with your ssd showing the problem and mine not, it's not directly ssd 
related, but if you do snapshotting and/or subvolumes, it could be 
related to that, or quotas, or trim/discard, or filesystem size.


Meanwhile, see the "btrfs_destroy_inode WARN_ON" thread, which 
interestingly enough, had a followup posted apparently the exact same 
minute as yours was, to this thread.

Based on that, it's not just you, but by that reply anyway, despite 
seeing lots of the warn-ons and getting scared back to an earlier kernel 
as a result, no dataloss was observed.  So without a pin-down it's tough 
to say it /can't/ happen, but at least based on the reply there, with the 
warn-ons apparently happening about every 10 minutes even with light use, 
no data loss from it to date, so while data loss /might/ still be 
possible, if it is, thankfully it doesn't seem to actually trigger very 
often, even under heavy destroy-inode warn-on triggering.

So they're obviously aware of the problem and presumably working on it, 
but it's equally obviously not fixed yet.

Were I seeing the problem frequently (again, I've not seen it at all), 
I'd likely drop back to 4.5 until there's a fix, tho if it takes long 
enough 4.5 might be going out of support, 4.4-LTS is of course another 
option.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

