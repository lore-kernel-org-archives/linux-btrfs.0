Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbbIZMKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 08:10:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZfoIm-0007Fd-Ei
	for linux-btrfs@vger.kernel.org; Sat, 26 Sep 2015 14:10:04 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 14:10:04 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 14:10:04 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Excessive slab use deteriorates performance
Date: Sat, 26 Sep 2015 13:59:13 +0200
Message-ID: <mu61ah$iaa$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have 2 almost identical servers, with the following difference:
1 16GB RAM, 4 disks in RAID10
2 8GB RAM, 2 disks in RAID1, but tried also in RAID0

The 2nd machine actually started life as a restore of a snapshot of the 
first, so running much the same services except the one we intentionally 
disabled.

We have noticed on both machines that after a day of up-time logging into 
KDE (as well as other file intensive tasks, like apt) are extremely slow 
(especially compared to the desktop/laptop machines with slower CPU, single 
disk).

It seems that actually the machine with the most memory suffers the most. 
Looking at the memory use of user space, that is very low (< 1GB), but the 
total memory consumed is actually almost 100%. That would be fine if it went 
to file buffers, but it doesn't. It goes to slab, specifically to 
btrfs_inode, dentry, radix_tree_node, btrfs_extent_buffer, leaving almost no 
memory available for buffers, or user space.

As far I we know these slabs should be freeed when needed, and there should 
be no reason to tinker with it. However, we found that:
sync ; echo 2 > /proc/sys/vm/drop_caches  # free dentries and inodes
restores performance for another day.

Looking into the jobs that run at night, it appears to be caused by the cron 
script that runs updatedb (to create the database for locate).

In the past (when using ext4) we never saw this problem, but then (in the 
old days) the server didn't have so much memory.

Could there be any relation to btrfs causing the mentioned slabs to not be 
automatically freeed?

In the mean time we put:
vfs_cache_pressure = 10000 

And this seems to be keeping slabs total at 2.5GB (with btrfs_inode at 
1.7GB).

Still, manually doing drop_caches, will reduce slabs total to 0.4GB, with 
btrfs_inode at 0.01GB.

I'm not sure, but just having a RO operation scanning all files on the disk 
causing kernel memory to be used to cache things that are almost not used 12 
hours later, while keeping more useful file caches from growing, seems not 
really optimal.

Has anybody else seen this behavior?

---
Ferry Toth


