Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46309 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab2ETQGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:42 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 20/24] Btrfs: quota tree support and startup
Date: Sun, 20 May 2012 18:06:31 +0200
Message-Id: <7745c111bd4b042abfc74f75ce6a7785c7f4c8b8.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
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
 fs/btrfs/qgroup.c  |    4 ++--
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0630412..f70ddb8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2908,6 +2908,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
+	kfree(fs_info->quota_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	kfree(fs_info);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d42ad71..df0fde8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1471,6 +1471,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
+	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
+		return fs_info->quota_root ? fs_info->quota_root :
+					     ERR_PTR(-ENOENT);
 again:
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
@@ -1898,6 +1901,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_extent_buffer(info->extent_root->commit_root);
 	free_extent_buffer(info->csum_root->node);
 	free_extent_buffer(info->csum_root->commit_root);
+	if (info->quota_root) {
+		free_extent_buffer(info->quota_root->node);
+		free_extent_buffer(info->quota_root->commit_root);
+	}
 
 	info->tree_root->node = NULL;
 	info->tree_root->commit_root = NULL;
@@ -1907,6 +1914,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	info->extent_root->commit_root = NULL;
 	info->csum_root->node = NULL;
 	info->csum_root->commit_root = NULL;
+	if (info->quota_root) {
+		info->quota_root->node = NULL;
+		info->quota_root->commit_root = NULL;
+	}
 
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
@@ -1937,6 +1948,7 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *csum_root;
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
+	struct btrfs_root *quota_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
@@ -1948,9 +1960,10 @@ int open_ctree(struct super_block *sb,
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
@@ -2438,6 +2451,17 @@ retry_root_backup:
 
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
 
@@ -2484,6 +2508,9 @@ retry_root_backup:
 			       " integrity check module %s\n", sb->s_id);
 	}
 #endif
+	ret = btrfs_read_qgroup_config(fs_info);
+	if (ret)
+		goto fail_trans_kthread;
 
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0 &&
@@ -2494,7 +2521,7 @@ retry_root_backup:
 			printk(KERN_WARNING "Btrfs log replay required "
 			       "on RO media\n");
 			err = -EIO;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 		blocksize =
 		     btrfs_level_size(tree_root,
@@ -2503,7 +2530,7 @@ retry_root_backup:
 		log_tree_root = btrfs_alloc_root(fs_info);
 		if (!log_tree_root) {
 			err = -ENOMEM;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
@@ -2543,7 +2570,7 @@ retry_root_backup:
 			printk(KERN_WARNING
 			       "btrfs: failed to recover relocation\n");
 			err = -EINVAL;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 	}
 
@@ -2553,10 +2580,10 @@ retry_root_backup:
 
 	fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
 	if (!fs_info->fs_root)
-		goto fail_trans_kthread;
+		goto fail_qgroup;
 	if (IS_ERR(fs_info->fs_root)) {
 		err = PTR_ERR(fs_info->fs_root);
-		goto fail_trans_kthread;
+		goto fail_qgroup;
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -2577,6 +2604,8 @@ retry_root_backup:
 
 	return 0;
 
+fail_qgroup:
+	btrfs_free_qgroup_config(fs_info);
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 fail_cleaner:
@@ -3182,6 +3211,8 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 2;
 	smp_mb();
 
+	btrfs_free_qgroup_config(root->fs_info);
+
 	if (fs_info->delalloc_bytes) {
 		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
 		       (unsigned long long)fs_info->delalloc_bytes);
@@ -3201,6 +3232,10 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(fs_info->dev_root->commit_root);
 	free_extent_buffer(fs_info->csum_root->node);
 	free_extent_buffer(fs_info->csum_root->commit_root);
+	if (fs_info->quota_root) {
+		free_extent_buffer(fs_info->quota_root->node);
+		free_extent_buffer(fs_info->quota_root->commit_root);
+	}
 
 	btrfs_free_block_groups(fs_info);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 678fe45..014ee8a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1076,8 +1076,8 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr,
-				   node->num_bytes,
-				   sgn > 0 ? node->seq - 1 : node->seq, &roots);
+				   sgn > 0 ? node->seq - 1 : node->seq, 0,
+				   &roots);
 	if (IS_ERR(roots)) {
 		ret = PTR_ERR(roots);
 		goto out;
-- 
1.7.3.4

