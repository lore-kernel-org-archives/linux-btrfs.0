From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 14/18] btrfs: quota tree support and startup
Date: Thu,  6 Oct 2011 17:54:24 +0200
Message-ID: <ad25b2e624425f2468bc585be70d9bb625641bda.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Init the quota tree along with the others on open_ctree
and close_ctree. Add the quota tree to the list of well
known trees in btrfs_read_fs_root_no_name.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cb25017..06576ed 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1391,6 +1391,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
+	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
+		return fs_info->quota_root ? fs_info->quota_root :
+					     ERR_PTR(-ENOENT);
 again:
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
@@ -1676,6 +1679,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 						GFP_NOFS);
 	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
 					      GFP_NOFS);
+	struct btrfs_root *quota_root = kzalloc(sizeof(struct btrfs_root),
+					      GFP_NOFS);
 	struct btrfs_root *log_tree_root;
 
 	int ret;
@@ -1684,7 +1689,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	struct btrfs_super_block *disk_super;
 
 	if (!extent_root || !tree_root || !tree_root->fs_info ||
-	    !chunk_root || !dev_root || !csum_root) {
+	    !chunk_root || !dev_root || !csum_root || !quota_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
@@ -2078,6 +2083,18 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	csum_root->track_dirty = 1;
 
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_QUOTA_TREE_OBJECTID, quota_root);
+	if (ret) {
+		kfree(quota_root);
+		quota_root = NULL;
+	} else {
+		quota_root->track_dirty = 1;
+		fs_info->quota_enabled = 1;
+		fs_info->pending_quota_state = 1;
+	}
+	fs_info->quota_root = quota_root;
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
@@ -2115,6 +2132,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+	ret = btrfs_read_qgroup_config(fs_info);
+	if (ret)
+		goto fail_trans_kthread;
+
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
@@ -2124,7 +2145,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			printk(KERN_WARNING "Btrfs log replay required "
 			       "on RO media\n");
 			err = -EIO;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 		blocksize =
 		     btrfs_level_size(tree_root,
@@ -2133,7 +2154,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		log_tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
 		if (!log_tree_root) {
 			err = -ENOMEM;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
@@ -2163,7 +2184,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			printk(KERN_WARNING
 			       "btrfs: failed to recover relocation\n");
 			err = -EINVAL;
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 	}
 
@@ -2173,10 +2194,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
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
@@ -2193,6 +2214,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	return tree_root;
 
+fail_qgroup:
+	btrfs_free_qgroup_config(fs_info);
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 fail_cleaner:
@@ -2209,6 +2232,10 @@ fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 	free_extent_buffer(csum_root->node);
 	free_extent_buffer(csum_root->commit_root);
+	if (quota_root) {
+		free_extent_buffer(quota_root->node);
+		free_extent_buffer(quota_root->commit_root);
+	}
 fail_dev_root:
 	free_extent_buffer(dev_root->node);
 	free_extent_buffer(dev_root->commit_root);
@@ -2253,6 +2280,7 @@ fail:
 	kfree(chunk_root);
 	kfree(dev_root);
 	kfree(csum_root);
+	kfree(quota_root);
 	return ERR_PTR(err);
 }
 
@@ -2666,6 +2694,8 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 2;
 	smp_mb();
 
+	btrfs_free_qgroup_config(root->fs_info);
+
 	if (fs_info->delalloc_bytes) {
 		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
 		       (unsigned long long)fs_info->delalloc_bytes);
@@ -2685,6 +2715,10 @@ int close_ctree(struct btrfs_root *root)
 	free_extent_buffer(root->fs_info->dev_root->commit_root);
 	free_extent_buffer(root->fs_info->csum_root->node);
 	free_extent_buffer(root->fs_info->csum_root->commit_root);
+	if (root->fs_info->quota_root) {
+		free_extent_buffer(root->fs_info->quota_root->node);
+		free_extent_buffer(root->fs_info->quota_root->commit_root);
+	}
 
 	btrfs_free_block_groups(root->fs_info);
 
@@ -2717,6 +2751,7 @@ int close_ctree(struct btrfs_root *root)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
+	kfree(fs_info->quota_root);
 	kfree(fs_info);
 
 	return 0;
-- 
1.7.3.4

