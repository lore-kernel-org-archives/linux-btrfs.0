From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix a bug of balance on full multi-disk partitions
Date: Tue, 2 Aug 2011 10:39:03 +0800
Message-ID: <1312252743-11511-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>,
	<miaox@cn.fujitsu.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When balancing, we'll first try to shrink devices for some space,
but if it is working on a full multi-disk partition with raid protection,
we may encounter a bug, that is, while shrinking, total_bytes may be less
than bytes_used, and btrfs may allocate a dev extent that accesses out of
device's bounds.

Then we will not be able to write or read the data which stores at the end
of the device, and get the followings:

device fsid 0939f071-7ea3-46c8-95df-f176d773bfb6 devid 1 transid 10 /dev/sdb5
Btrfs detected SSD devices, enabling SSD mode
btrfs: relocating block group 476315648 flags 9
btrfs: found 4 extents
attempt to access beyond end of device
sdb5: rw=145, want=546176, limit=546147
attempt to access beyond end of device
sdb5: rw=145, want=546304, limit=546147
attempt to access beyond end of device
sdb5: rw=145, want=546432, limit=546147
attempt to access beyond end of device
sdb5: rw=145, want=546560, limit=546147
attempt to access beyond end of device

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..e5d57af 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -835,6 +835,7 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 
 	max_hole_start = search_start;
 	max_hole_size = 0;
+	hole_size = 0;
 
 	if (search_start >= search_end) {
 		ret = -ENOSPC;
@@ -917,7 +918,14 @@ next:
 		cond_resched();
 	}
 
-	hole_size = search_end- search_start;
+	/*
+	 * At this point, search_start should be the end of
+	 * allocated dev extents, and when shrinking the device,
+	 * search_end may be smaller than search_start.
+	 */
+	if (search_end > search_start)
+		hole_size = search_end - search_start;
+
 	if (hole_size > max_hole_size) {
 		max_hole_start = search_start;
 		max_hole_size = hole_size;
@@ -2410,9 +2418,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			total_avail = device->total_bytes - device->bytes_used;
 		else
 			total_avail = 0;
-		/* avail is off by max(alloc_start, 1MB), but that is the same
-		 * for all devices, so it doesn't hurt the sorting later on
-		 */
+
+		/* If there is no space on this device, skip it. */
+		if (total_avail == 0)
+			continue;
 
 		ret = find_free_dev_extent(trans, device,
 					   max_stripe_size * dev_stripes,
-- 
1.6.5.2

