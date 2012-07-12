Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33256 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595Ab2GLJnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 11/15] Btrfs: quota tree support and startup
Date: Thu, 12 Jul 2012 11:43:43 +0200
Message-Id: <bcef60f249034f69e89e544461cbfecb68975595.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Init the quota tree along with the others on open_ctree
and close_ctree. Add the quota tree to the list of well
known trees in btrfs_read_fs_root_no_name.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ccba9b6..2ba03b9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2967,6 +2967,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
+	kfree(fs_info->quota_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	kfree(fs_info);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eca0549..87d9391 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1472,6 +1472,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
+	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
+		return fs_info->quota_root ? fs_info->quota_root :
+					     ERR_PTR(-ENOENT);
 again:
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
@@ -1899,6 +1902,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_extent_buffer(info->extent_root->commit_root);
 	free_extent_buffer(info->csum_root->node);
 	free_extent_buffer(info->csum_root->commit_root);
+	if (info->quota_root) {
+		free_extent_buffer(info->quota_root->node);
+		free_extent_buffer(info->quota_root->commit_root);
+	}
 
 	info->tree_root->node = NULL;
 	info->tree_root->commit_root = NULL;
@@ -1908,6 +1915,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	info->extent_root->commit_root = NULL;
 	info->csum_root->node = NULL;
 	info->csum_root->commit_root = NULL;
+	if (info->quota_root) {
+		info->quota_root->node = NULL;
+		info->quota_root->commit_root = NULL;
+	}
 
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
@@ -1938,6 +1949,7 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *csum_root;
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
+	struct btrfs_root *quota_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
@@ -1949,9 +1961,10 @@ int open_ctree(struct super_block *sb,
 	csum_root = fs_info->csum_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
 	dev_root = fs_info->dev_root = btrfs_alloc_root(fs_info);
+	quota_root = fs_info->quota_root = btrfs_alloc_root(fs_info);
 
 	if (!tree_root || !extent_root || !csum_root ||
-	    !chunk_root || !dev_root) {
+	    !chunk_root || !dev_root || !quota_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
@@ -2441,6 +2454,17 @@ retry_root_backup:
 		goto recovery_tree_root;
 	csum_root->track_dirty = 1;
 
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_QUOTA_TREE_OBJECTID, quota_root);
+	if (ret) {
+		kfree(quota_root);
+		quota_root = fs_info->quota_root = NULL;
+	} else {
+		quota_root->track_dirty = 1;
+		fs_info->quota_enabled = 1;
+		fs_info->pending_quota_state = 1;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
@@ -2500,6 +2524,9 @@ retry_root_backup:
 			       " integrity check module %s\n", sb->s_id);
 	}
 #endif
+	ret = btrfs_read_qgroup_config(fs_info);
+	if (ret)
+		goto fail_trans_kthread;
 
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0 &&
@@ -2510,7 +2537,7 @@ retry_root_backup:
 			printk(KERN_WARNING "Btrfs log replay required "
 			       "on RO media\n");
 			err = -EIO;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 		blocksize =
 		     btrfs_level_size(tree_root,
@@ -2519,7 +2546,7 @@ retry_root_backup:
 		log_tree_root = btrfs_alloc_root(fs_info);
 		if (!log_tree_root) {
 			err = -ENOMEM;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
@@ -2559,7 +2586,7 @@ retry_root_backup:
 			printk(KERN_WARNING
 			       "btrfs: failed to recover relocation\n");
 			err = -EINVAL;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 	}
 
@@ -2569,10 +2596,10 @@ retry_root_backup:
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
 	if (!fs_info->fs_root)
-		goto fail_trans_kthread;
+		goto fail_qgroup;
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
-		goto fail_trans_kthread;
+		goto fail_qgroup;
 	}
 
 	if (sb->s_flags & MS_RDONLY)
@@ -2596,6 +2623,8 @@ retry_root_backup:
 
 	return 0;
 
+fail_qgroup:
+	btrfs_free_qgroup_config(fs_info);
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 fail_cleaner:
@@ -3194,6 +3223,8 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 2;
 	smp_mb();
 
+	btrfs_free_qgroup_config(root->fs_info);
+
 	if (fs_info->delalloc_bytes) {
 		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
 		       (unsigned long long)fs_info->delalloc_bytes);
@@ -3213,6 +3244,10 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(fs_info->dev_root->commit_root);
 	free_extent_buffer(fs_info->csum_root->node);
 	free_extent_buffer(fs_info->csum_root->commit_root);
+	if (fs_info->quota_root) {
+		free_extent_buffer(fs_info->quota_root->node);
+		free_extent_buffer(fs_info->quota_root->commit_root);
+	}
 
 	btrfs_free_block_groups(fs_info);
 
-- 
1.7.3.4

