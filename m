From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: [PATCH] Btrfs: don't allocate more than max_available bytes when looped
Date: Mon, 03 Aug 2009 00:24:47 +0200
Message-ID: <87fxc9yhu8.fsf@master.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a problem running this simple test case that I was writing to test
the GNU coreutils cp tool:

truncate --size=256M btrfs.img
mkfs.btrfs btrfs.img
mkdir btrfs
mount -t btrfs -o loop btrfs.img btrfs
dd bs=1M count=200 if=/dev/zero of=btrfs/alloc.test

with the current git version I get an ENOSPC error on dd, even if the
available space is 256M.
The simple patch that I have attached seems to fix it.

Am I missing someting?  If there is something wrong please let me know
and I'll try to fix it.

Regards,
Giuseppe


>From d6345f720f9fa5e60edd904d90d56bf9e96fb118 Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Sun, 2 Aug 2009 23:29:21 +0200
Subject: [PATCH] Btrfs: don't allocate more than max_available bytes when looped

avoid that __btrfs_alloc_chunk can try to allocate more than
max_available bytes if it wasn't possible on the first attempt.
---
 fs/btrfs/volumes.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5dbefd1..38d93f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2180,8 +2180,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-again:
 	max_avail = 0;
+again:
 	if (!map || map->num_stripes != num_stripes) {
 		kfree(map);
 		map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
@@ -2196,11 +2196,12 @@ again:
 		do_div(calc_size, stripe_len);
 		calc_size *= stripe_len;
 	}
-	/* we don't want tiny stripes */
-	calc_size = max_t(u64, min_stripe_size, calc_size);
 
-	do_div(calc_size, stripe_len);
-	calc_size *= stripe_len;
+  /* we don't want tiny stripes */
+  calc_size = max_t(u64, min_stripe_size, calc_size);
+
+  do_div(calc_size, stripe_len);
+  calc_size *= stripe_len;
 
 	cur = fs_devices->alloc_list.next;
 	index = 0;
@@ -2217,6 +2218,8 @@ again:
 	 */
 	if (!looped)
 		min_free += 1024 * 1024;
+  else
+    min_free = min_t(u64, max_avail, min_free);
 
 	INIT_LIST_HEAD(&private_devs);
 	while (index < num_stripes) {
-- 
1.6.3.3
