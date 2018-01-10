Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57981 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbeAJGSU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 10 Jan 2018 01:18:20 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/2] btrfs-progs: fi-usage: Fix wrong RAID10 used and unallocated space
Date: Wed, 10 Jan 2018 14:18:08 +0800
Message-Id: <20180110061809.28123-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For a very basic RAID10 with 4 disks, "fi usage" and "fi show" are
outputting conflicting result:
------
 # btrfs fi show /mnt/btrfs/
Label: none  uuid: 6d0229db-28d1-4696-ac20-e828cc45dc40
	Total devices 4 FS bytes used 1.12MiB
	devid    1 size 5.00GiB used 2.01GiB path /dev/mapper/data-disk1
	devid    2 size 5.00GiB used 2.01GiB path /dev/mapper/data-disk2
	devid    3 size 5.00GiB used 2.01GiB path /dev/mapper/data-disk3
	devid    4 size 5.00GiB used 2.01GiB path /dev/mapper/data-disk4

Here the unallocated space for disk4 should be a little less than 3G.
(5.00 Gib - 2.01GiB)

 # btrfs fi usage  /mnt/btrfs/
Overall:
    Device size:		  20.00GiB
    Device allocated:		   8.03GiB
    Device unallocated:		  11.97GiB
    Device missing:		     0.00B
    Used:			   2.25MiB
    Free (estimated):		   7.98GiB	(min: 7.98GiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,RAID10: Size:2.00GiB, Used:1.00MiB
   ...
   /dev/mapper/data-disk4	 512.00MiB

Metadata,RAID10: Size:2.00GiB, Used:112.00KiB
   ...
   /dev/mapper/data-disk4	 512.00MiB

System,RAID10: Size:16.00MiB, Used:16.00KiB
   ...
   /dev/mapper/data-disk4	   4.00MiB

Unallocated:
   ...
   /dev/mapper/data-disk4	   4.00GiB

While fi usage shows we still have 4.00GiB unallocated space.
------

[CAUSE]
calc_chunk_size() is used to convert chunk size to device extent size,
which is used to get the per-device data/meta/sys used space.

However, for RAID10 we just divide the chunk size with num_stripes,
without taking sub stripes into account.

Resulting data/meta/sys usage in RAID10 halved.

[FIX]
Take the missing sub stripes into consideration.

Reported-by: Adam Bahe <adambahe@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Nothing
---
 cmds-fi-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 0b0e47fee194..0af4bdbc9370 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -664,7 +664,7 @@ static u64 calc_chunk_size(struct chunk_info *ci)
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID6)
 		return ci->size / (ci->num_stripes -2);
 	else if (ci->type & BTRFS_BLOCK_GROUP_RAID10)
-		return ci->size / ci->num_stripes;
+		return ci->size / (ci->num_stripes / 2);
 	return ci->size;
 }
 
-- 
2.15.1

