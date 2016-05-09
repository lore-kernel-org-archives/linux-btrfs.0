Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbcEIJkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 05:40:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 017B3AB08
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 09:40:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: switch to common message helpers in open_ctree, adjust messages
Date: Mon,  9 May 2016 11:39:58 +0200
Message-Id: <1462786798-15247-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we lack the identification of the filesystem in most if not
all mount messages, done via printk/pr_* functions. We can use the
btrfs_* helpers in open_ctree, as the fs_info <-> sb link is established
at the beginning of the function.

The messages have been updated at the same time to be more consistent:

* dropped sb->s_id, as it's not available via btrfs_*
* added %d for return code where appropriate
* wording changed
* %Lx replaced by %llx

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 102 ++++++++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e47849d7427..cc8aee26d17b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2713,7 +2713,7 @@ int open_ctree(struct super_block *sb,
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
 	if (btrfs_check_super_csum(bh->b_data)) {
-		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
+		btrfs_err(fs_info, "superblock checksum mismatch");
 		err = -EINVAL;
 		brelse(bh);
 		goto fail_alloc;
@@ -2733,7 +2733,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: superblock contains fatal errors\n");
+		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2768,9 +2768,9 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
-		       "unsupported optional features (%Lx).\n",
-		       features);
+		btrfs_err(fs_info,
+		    "cannot mount because of unsupported optional features (%llx)",
+		    features);
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2781,7 +2781,7 @@ int open_ctree(struct super_block *sb,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
-		printk(KERN_INFO "BTRFS: has skinny extents\n");
+		btrfs_info(fs_info, "has skinny extents");
 
 	/*
 	 * flag our filesystem as having big metadata blocks if
@@ -2789,7 +2789,8 @@ int open_ctree(struct super_block *sb,
 	 */
 	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
 		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			printk(KERN_INFO "BTRFS: flagging fs with big metadata feature\n");
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 	}
 
@@ -2805,9 +2806,9 @@ int open_ctree(struct super_block *sb,
 	 */
 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
 	    (sectorsize != nodesize)) {
-		printk(KERN_ERR "BTRFS: unequal leaf/node/sector sizes "
-				"are not allowed for mixed block groups on %s\n",
-				sb->s_id);
+		btrfs_err(fs_info,
+"unequal nodesize/sectorsize (%u != %u) are not allowed for mixed block groups",
+			nodesize, sectorsize);
 		goto fail_alloc;
 	}
 
@@ -2820,8 +2821,8 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
-		       "unsupported option features (%Lx).\n",
+		btrfs_err(fs_info,
+	"cannot mount read-write because of unsupported optional features (%llx)",
 		       features);
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2850,8 +2851,7 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: failed to read the system "
-		       "array on %s\n", sb->s_id);
+		btrfs_err(fs_info, "failed to read the system array: %d", ret);
 		goto fail_sb_buffer;
 	}
 
@@ -2865,8 +2865,7 @@ int open_ctree(struct super_block *sb,
 					   generation);
 	if (IS_ERR(chunk_root->node) ||
 	    !extent_buffer_uptodate(chunk_root->node)) {
-		printk(KERN_ERR "BTRFS: failed to read chunk root on %s\n",
-		       sb->s_id);
+		btrfs_err(fs_info, "failed to read chunk root");
 		if (!IS_ERR(chunk_root->node))
 			free_extent_buffer(chunk_root->node);
 		chunk_root->node = NULL;
@@ -2880,8 +2879,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_read_chunk_tree(chunk_root);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: failed to read chunk tree on %s\n",
-		       sb->s_id);
+		btrfs_err(fs_info, "failed to read chunk tree: %d", ret);
 		goto fail_tree_roots;
 	}
 
@@ -2892,8 +2890,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_close_extra_devices(fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
-		printk(KERN_ERR "BTRFS: failed to read devices on %s\n",
-		       sb->s_id);
+		btrfs_err(fs_info, "failed to read devices");
 		goto fail_tree_roots;
 	}
 
@@ -2905,8 +2902,7 @@ int open_ctree(struct super_block *sb,
 					  generation);
 	if (IS_ERR(tree_root->node) ||
 	    !extent_buffer_uptodate(tree_root->node)) {
-		printk(KERN_WARNING "BTRFS: failed to read tree root on %s\n",
-		       sb->s_id);
+		btrfs_warn(fs_info, "failed to read tree root");
 		if (!IS_ERR(tree_root->node))
 			free_extent_buffer(tree_root->node);
 		tree_root->node = NULL;
@@ -2938,20 +2934,19 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: failed to recover balance\n");
+		btrfs_err(fs_info, "failed to recover balance: %d", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_stats(fs_info);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: failed to init dev_stats: %d\n",
-		       ret);
+		btrfs_err(fs_info, "failed to init dev_stats: %d", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_replace(fs_info);
 	if (ret) {
-		pr_err("BTRFS: failed to init dev_replace: %d\n", ret);
+		btrfs_err(fs_info, "failed to init dev_replace: %d", ret);
 		goto fail_block_groups;
 	}
 
@@ -2959,31 +2954,33 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
 	if (ret) {
-		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
+		btrfs_err(fs_info, "failed to init sysfs fsid interface: %d",
+				ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_sysfs_add_device(fs_devices);
 	if (ret) {
-		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
+		btrfs_err(fs_info, "failed to init sysfs device interface: %d",
+				ret);
 		goto fail_fsdev_sysfs;
 	}
 
 	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
-		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
+		btrfs_err(fs_info, "failed to init sysfs interface: %d", ret);
 		goto fail_fsdev_sysfs;
 	}
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: Failed to initial space info: %d\n", ret);
+		btrfs_err(fs_info, "failed to initialize space info: %d", ret);
 		goto fail_sysfs;
 	}
 
 	ret = btrfs_read_block_groups(fs_info->extent_root);
 	if (ret) {
-		printk(KERN_ERR "BTRFS: Failed to read block groups: %d\n", ret);
+		btrfs_err(fs_info, "failed to read block groups: %d", ret);
 		goto fail_sysfs;
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
@@ -2991,7 +2988,8 @@ int open_ctree(struct super_block *sb,
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
-		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
+		btrfs_warn(fs_info,
+"missing devices (%llu) exceeds the limit (%d), writeable mount is not allowed",
 			fs_info->fs_devices->missing_devices,
 			fs_info->num_tolerated_disk_barrier_failures);
 		goto fail_sysfs;
@@ -3011,8 +3009,7 @@ int open_ctree(struct super_block *sb,
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
-		printk(KERN_INFO "BTRFS: detected SSD devices, enabling SSD "
-		       "mode\n");
+		btrfs_info(fs_info, "detected SSD devices, enabling SSD mode");
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
@@ -3030,8 +3027,9 @@ int open_ctree(struct super_block *sb,
 				    1 : 0,
 				    fs_info->check_integrity_print_mask);
 		if (ret)
-			printk(KERN_WARNING "BTRFS: failed to initialize"
-			       " integrity check module %s\n", sb->s_id);
+			btrfs_warn(fs_info,
+				"failed to initialize integrity check module: %d",
+				ret);
 	}
 #endif
 	ret = btrfs_read_qgroup_config(fs_info);
@@ -3061,8 +3059,8 @@ int open_ctree(struct super_block *sb,
 		ret = btrfs_recover_relocation(tree_root);
 		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
-			printk(KERN_WARNING
-			       "BTRFS: failed to recover relocation\n");
+			btrfs_warn(fs_info, "failed to recover relocation: %d",
+					ret);
 			err = -EINVAL;
 			goto fail_qgroup;
 		}
@@ -3083,11 +3081,11 @@ int open_ctree(struct super_block *sb,
 
 	if (btrfs_test_opt(tree_root, FREE_SPACE_TREE) &&
 	    !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
-		pr_info("BTRFS: creating free space tree\n");
+		btrfs_info(fs_info, "creating free space tree");
 		ret = btrfs_create_free_space_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to create free space tree %d\n",
-				ret);
+			btrfs_warn(fs_info,
+				"failed to create free space tree: %d", ret);
 			close_ctree(tree_root);
 			return ret;
 		}
@@ -3104,14 +3102,14 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_resume_balance_async(fs_info);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to resume balance\n");
+		btrfs_warn(fs_info, "failed to resume balance: %d", ret);
 		close_ctree(tree_root);
 		return ret;
 	}
 
 	ret = btrfs_resume_dev_replace_async(fs_info);
 	if (ret) {
-		pr_warn("BTRFS: failed to resume dev_replace\n");
+		btrfs_warn(fs_info, "failed to resume device replace: %d", ret);
 		close_ctree(tree_root);
 		return ret;
 	}
@@ -3120,33 +3118,33 @@ int open_ctree(struct super_block *sb,
 
 	if (btrfs_test_opt(tree_root, CLEAR_CACHE) &&
 	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
-		pr_info("BTRFS: clearing free space tree\n");
+		btrfs_info(fs_info, "clearing free space tree");
 		ret = btrfs_clear_free_space_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to clear free space tree %d\n",
-				ret);
+			btrfs_warn(fs_info,
+				"failed to clear free space tree: %d", ret);
 			close_ctree(tree_root);
 			return ret;
 		}
 	}
 
 	if (!fs_info->uuid_root) {
-		pr_info("BTRFS: creating UUID tree\n");
+		btrfs_info(fs_info, "creating UUID tree");
 		ret = btrfs_create_uuid_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to create the UUID tree %d\n",
-				ret);
+			btrfs_warn(fs_info,
+				"failed to create the UUID tree: %d", ret);
 			close_ctree(tree_root);
 			return ret;
 		}
 	} else if (btrfs_test_opt(tree_root, RESCAN_UUID_TREE) ||
 		   fs_info->generation !=
 				btrfs_super_uuid_tree_generation(disk_super)) {
-		pr_info("BTRFS: checking UUID tree\n");
+		btrfs_info(fs_info, "checking UUID tree");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-			pr_warn("BTRFS: failed to check the UUID tree %d\n",
-				ret);
+			btrfs_warn(fs_info,
+				"failed to check the UUID tree: %d", ret);
 			close_ctree(tree_root);
 			return ret;
 		}
-- 
2.7.1

