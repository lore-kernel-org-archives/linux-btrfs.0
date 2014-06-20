Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966834AbaFTNEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 09:04:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 265D3ABB9
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 13:04:46 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: adjust message levels in open_ctree
Date: Fri, 20 Jun 2014 15:04:45 +0200
Message-Id: <1403269485-13605-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The level should express the severity, so anything that leads to a
failed mount gets ERROR level, if it's possible continue then WARNING,
and informative messages are INFO.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa19898f..b29804467847 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -616,21 +616,21 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "BTRFS: bad tree block start "
+		printk_ratelimited(KERN_ERR "BTRFS: bad tree block start "
 			       "%llu %llu\n",
 			       found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "BTRFS: bad fsid on block %llu\n",
+		printk_ratelimited(KERN_ERR "BTRFS: bad fsid on block %llu\n",
 			       eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	found_level = btrfs_header_level(eb);
 	if (found_level >= BTRFS_MAX_LEVEL) {
-		btrfs_info(root->fs_info, "bad tree block level %d",
+		btrfs_error(root->fs_info, "bad tree block level %d",
 			   (int)btrfs_header_level(eb));
 		ret = -EIO;
 		goto err;
@@ -2488,7 +2488,7 @@ int open_ctree(struct super_block *sb,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
-		printk(KERN_ERR "BTRFS: has skinny extents\n");
+		printk(KERN_INFO "BTRFS: has skinny extents\n");
 
 	/*
 	 * flag our filesystem as having big metadata blocks if
@@ -2513,7 +2513,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
 	    (sectorsize != leafsize)) {
-		printk(KERN_WARNING "BTRFS: unequal leaf/node/sector sizes "
+		printk(KERN_ERR "BTRFS: unequal leaf/node/sector sizes "
 				"are not allowed for mixed block groups on %s\n",
 				sb->s_id);
 		goto fail_alloc;
@@ -2619,12 +2619,12 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
 	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-		printk(KERN_INFO "BTRFS: valid FS not found on %s\n", sb->s_id);
+		printk(KERN_ERR "BTRFS: valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
 
 	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
+		printk(KERN_ERR "BTRFS: Incompatible sector size(%lu) "
 		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2633,7 +2633,7 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to read the system "
+		printk(KERN_ERR "BTRFS: failed to read the system "
 		       "array on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2650,7 +2650,7 @@ int open_ctree(struct super_block *sb,
 					   blocksize, generation);
 	if (!chunk_root->node ||
 	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
-		printk(KERN_WARNING "BTRFS: failed to read chunk root on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read chunk root on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2662,7 +2662,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_read_chunk_tree(chunk_root);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to read chunk tree on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read chunk tree on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2674,7 +2674,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_close_extra_devices(fs_info, fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
-		printk(KERN_CRIT "BTRFS: failed to read devices on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read devices on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2850,7 +2850,7 @@ retry_root_backup:
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
-			printk(KERN_WARNING "BTRFS: log replay required "
+			printk(KERN_ERR "BTRFS: log replay required "
 			       "on RO media\n");
 			err = -EIO;
 			goto fail_qgroup;
@@ -2906,7 +2906,7 @@ retry_root_backup:
 
 		ret = btrfs_recover_relocation(tree_root);
 		if (ret < 0) {
-			printk(KERN_WARNING
+			printk(KERN_ERR
 			       "BTRFS: failed to recover relocation\n");
 			err = -EINVAL;
 			goto fail_qgroup;
@@ -2944,7 +2944,7 @@ retry_root_backup:
 
 	ret = btrfs_resume_dev_replace_async(fs_info);
 	if (ret) {
-		pr_warn("BTRFS: failed to resume dev_replace\n");
+		pr_err("BTRFS: failed to resume dev_replace\n");
 		close_ctree(tree_root);
 		return ret;
 	}
@@ -2955,7 +2955,7 @@ retry_root_backup:
 		pr_info("BTRFS: creating UUID tree\n");
 		ret = btrfs_create_uuid_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to create the UUID tree %d\n",
+			pr_err("BTRFS: failed to create the UUID tree %d\n",
 				ret);
 			close_ctree(tree_root);
 			return ret;
@@ -2965,7 +2965,7 @@ retry_root_backup:
 		pr_info("BTRFS: checking UUID tree\n");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to check the UUID tree %d\n",
+			pr_err("BTRFS: failed to check the UUID tree %d\n",
 				ret);
 			close_ctree(tree_root);
 			return ret;
-- 
1.8.4.5

