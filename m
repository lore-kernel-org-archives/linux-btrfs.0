From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: fix shadowed variable declarations
Date: Thu, 20 Nov 2008 19:42:20 +0100
Message-ID: <20081120184220.GA20917@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/disk-io.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/disk-io.c	2008-11-09 21:25:35.000000000 +0100
+++ btrfs-unstable/fs/btrfs/disk-io.c	2008-11-09 21:25:47.000000000 +0100
@@ -1706,7 +1706,6 @@ struct btrfs_root *open_ctree(struct sup
 		goto fail_cleaner;
 
 	if (btrfs_super_log_root(disk_super) != 0) {
-		u32 blocksize;
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		blocksize =
Index: btrfs-unstable/fs/btrfs/file.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/file.c	2008-11-09 21:25:59.000000000 +0100
+++ btrfs-unstable/fs/btrfs/file.c	2008-11-09 21:26:57.000000000 +0100
@@ -659,18 +659,18 @@ next_slot:
 		}
 
 		if (found_extent && !keep) {
-			u64 disk_bytenr = le64_to_cpu(old.disk_bytenr);
+			u64 old_disk_bytenr = le64_to_cpu(old.disk_bytenr);
 
-			if (disk_bytenr != 0) {
+			if (old_disk_bytenr != 0) {
 				inode_sub_bytes(inode,
 						le64_to_cpu(old.num_bytes));
 				ret = btrfs_free_extent(trans, root,
-						disk_bytenr,
+						old_disk_bytenr,
 						le64_to_cpu(old.disk_num_bytes),
 						leaf_start, root_owner,
 						root_gen, key.objectid, 0);
 				BUG_ON(ret);
-				*hint_byte = disk_bytenr;
+				*hint_byte = old_disk_bytenr;
 			}
 		}
 
