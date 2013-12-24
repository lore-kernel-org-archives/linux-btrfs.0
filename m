Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9604 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab3LXDtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 22:49:05 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBO3n3MK026363
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 11:49:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Move some super block check to btrfs_check_super_valid
Date: Tue, 24 Dec 2013 11:49:56 +0800
Message-Id: <1387856996-24504-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move some early check to btrfs_check_super_valid:
- sectorsize check
- leafsize == nodesize check
- leafsize > BTRFS_MAX_METADATA_BLOCKSIZE check
- incompat_flags check

and remove the duplicant magic check of btrfs_super_block,
since btrfs_read_dev_super already checked the magic number.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 76 ++++++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..04ad1d3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2388,33 +2388,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	features = btrfs_super_incompat_flags(disk_super) &
-		~BTRFS_FEATURE_INCOMPAT_SUPP;
-	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
-		       "unsupported optional features (%Lx).\n",
-		       features);
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
-	if (btrfs_super_leafsize(disk_super) !=
-	    btrfs_super_nodesize(disk_super)) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksizes don't match.  node %d leaf %d\n",
-		       btrfs_super_nodesize(disk_super),
-		       btrfs_super_leafsize(disk_super));
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksize (%d) was too large\n",
-		       btrfs_super_leafsize(disk_super));
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
 	features = btrfs_super_incompat_flags(disk_super);
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
@@ -2582,17 +2555,6 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
-		goto fail_sb_buffer;
-	}
-
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
@@ -3706,11 +3668,41 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 }
 
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
-			      int read_only)
+				   int read_only)
 {
-	/*
-	 * Placeholder for checks
-	 */
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	u32 sectorsize = btrfs_super_sectorsize(disk_super);
+	u64 features;
+
+	if (sectorsize != PAGE_SIZE) {
+		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
+		       "found on %s\n", (unsigned long)sectorsize,
+		       fs_info->sb->s_id);
+		return -EINVAL;
+	}
+	if (btrfs_super_leafsize(disk_super) !=
+	    btrfs_super_nodesize(disk_super)) {
+		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		       "blocksizes don't match.  node %d leaf %d\n",
+		       btrfs_super_nodesize(disk_super),
+		       btrfs_super_leafsize(disk_super));
+		return -EINVAL;
+	}
+	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		       "blocksize (%d) was too large\n",
+		       btrfs_super_leafsize(disk_super));
+		return -EINVAL;
+	}
+
+	features = btrfs_super_incompat_flags(disk_super) &
+		~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		       "unsupported optional features (%Lx).\n",
+		       features);
+		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
1.8.5.2

