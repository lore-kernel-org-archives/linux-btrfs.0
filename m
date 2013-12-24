Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3LXIoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Dec 2013 03:44:09 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBO8i69b014864
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Dec 2013 16:44:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Move some super block check to btrfs_check_super_valid
Date: Tue, 24 Dec 2013 16:44:58 +0800
Message-Id: <1387874698-29652-1-git-send-email-quwenruo@cn.fujitsu.com>
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
Changelog:
v2:
  - Rebased to btrfs-next repo
  - Use pr_err instead of printk
  - Use one line string to make grep easier(also emit the checkpatch warning)
---
 fs/btrfs/disk-io.c | 72 +++++++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9417b73..defe2a4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2384,33 +2384,6 @@ int open_ctree(struct super_block *sb,
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
@@ -2578,17 +2551,6 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-		printk(KERN_INFO "BTRFS: valid FS not found on %s\n", sb->s_id);
-		goto fail_sb_buffer;
-	}
-
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
@@ -3712,11 +3674,37 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
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
+		pr_err("BTRFS: Incompatible sector size(%lu) found on %s\n",
+		       (unsigned long)sectorsize, fs_info->sb->s_id);
+		return -EINVAL;
+	}
+	if (btrfs_super_leafsize(disk_super) !=
+	    btrfs_super_nodesize(disk_super)) {
+		pr_err("BTRFS: couldn't mount because metadata blocksizes don't match.  node %d leaf %d\n",
+		       btrfs_super_nodesize(disk_super),
+		       btrfs_super_leafsize(disk_super));
+		return -EINVAL;
+	}
+	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		pr_err("BTRFS: couldn't mount because metadata blocksize (%d) was too large\n",
+		       btrfs_super_leafsize(disk_super));
+		return -EINVAL;
+	}
+
+	features = btrfs_super_incompat_flags(disk_super) &
+		~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		pr_err("BTRFS: couldn't mount because of unsupported optional features (%Lx).\n",
+		       features);
+		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
1.8.5.2

