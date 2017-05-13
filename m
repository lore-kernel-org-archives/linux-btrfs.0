Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41214 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755119AbdEMUyh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 16:54:37 -0400
Date: Sat, 13 May 2017 13:54:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: balancing every night broke balancing so now I can't balance anymore?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 4.11, btrfs-progs v4.7.3

I run scrub and balance every night, been doing this for 1.5 years on this
filesystem.
But it has just started failing:
saruman:~# btrfs balance start -musage=0  /mnt/btrfs_pool1
Done, had to relocate 0 out of 235 chunks
saruman:~# btrfs balance start -dusage=0  /mnt/btrfs_pool1
Done, had to relocate 0 out of 235 chunks

saruman:~# btrfs balance start -musage=1  /mnt/btrfs_pool1
ERROR: error during balancing '/mnt/btrfs_pool1': No space left on device
aruman:~# btrfs balance start -dusage=10  /mnt/btrfs_pool1
Done, had to relocate 0 out of 235 chunks
saruman:~# btrfs balance start -dusage=20  /mnt/btrfs_pool1
ERROR: error during balancing '/mnt/btrfs_pool1': No space left on device
There may be more info in syslog - try dmesg | tail

BTRFS info (device dm-2): 1 enospc errors during balance
BTRFS info (device dm-2): relocating block group 598566305792 flags data
BTRFS info (device dm-2): 1 enospc errors during balance
BTRFS info (device dm-2): 1 enospc errors during balance
BTRFS info (device dm-2): relocating block group 598566305792 flags data
BTRFS info (device dm-2): 1 enospc errors during balance

saruman:~# btrfs fi show /mnt/btrfs_pool1/
Label: 'btrfs_pool1'  uuid: bc115001-a8d1-445c-9ec9-6050620efd0a
	Total devices 1 FS bytes used 169.73GiB
	devid    1 size 228.67GiB used 228.67GiB path /dev/mapper/pool1

saruman:~# btrfs fi usage /mnt/btrfs_pool1/
Overall:
    Device size:		 228.67GiB
    Device allocated:		 228.67GiB
    Device unallocated:		   1.00MiB
    Device missing:		     0.00B
    Used:			 171.25GiB
    Free (estimated):		  55.32GiB	(min: 55.32GiB)
    Data ratio:			      1.00
    Metadata ratio:		      1.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:221.60GiB, Used:166.28GiB
   /dev/mapper/pool1	 221.60GiB

Metadata,single: Size:7.03GiB, Used:4.96GiB
   /dev/mapper/pool1	   7.03GiB

System,single: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/pool1	  32.00MiB

Unallocated:
   /dev/mapper/pool1	   1.00MiB


How did I get into such a misbalanced state when I balance every night?

My filesystem is not full, I can write just fine, but I sure cannot
rebalance now.

Besides adding another device to add space, is there a way around this
and more generally not getting into that state anymore considering that
I already rebalance every night?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
