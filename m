Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:47651 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826Ab3GCROn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 13:14:43 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 31.28 OK)
	with ESMTP id 6031fep63DYoW0 for <linux-btrfs@vger.kernel.org>;
	Wed, 3 Jul 2013 19:14:40 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 3/8] Btrfs: create UUID tree if required
Date: Wed,  3 Jul 2013 19:14:34 +0200
Message-Id: <db40305a2c9c1c24f1b757cf534fb1a07f7e37ec.1372866277.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372866277.git.sbehrens@giantdisaster.de>
References: <cover.1372866277.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372866277.git.sbehrens@giantdisaster.de>
References: <cover.1372866277.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This tree is not created by mkfs.btrfs. Therefore when a filesystem
is mounted writable and the UUID tree does not exist, this tree is
created if required. The tree is also added to the fs_info structure
and initialized, but this commit does not yet read or write UUID tree
elements.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     | 34 ++++++++++++++++++++++++++++++++++
 fs/btrfs/extent-tree.c |  3 +++
 fs/btrfs/volumes.c     | 26 ++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |  1 +
 5 files changed, 65 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2ba8e3f..56f1c59 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1305,6 +1305,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
 	struct btrfs_root *quota_root;
+	struct btrfs_root *uuid_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c2886c..1db446a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1580,6 +1580,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_root ? fs_info->quota_root :
 					     ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
+		return fs_info->uuid_root ? fs_info->uuid_root :
+					    ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root)
@@ -2037,6 +2040,12 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		info->quota_root->node = NULL;
 		info->quota_root->commit_root = NULL;
 	}
+	if (info->uuid_root) {
+		free_extent_buffer(info->uuid_root->node);
+		free_extent_buffer(info->uuid_root->commit_root);
+		info->uuid_root->node = NULL;
+		info->uuid_root->commit_root = NULL;
+	}
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
 		free_extent_buffer(info->chunk_root->commit_root);
@@ -2097,11 +2106,13 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
 	struct btrfs_root *quota_root;
+	struct btrfs_root *uuid_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
+	bool create_uuid_tree = false;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
@@ -2695,6 +2706,18 @@ retry_root_backup:
 		fs_info->quota_root = quota_root;
 	}
 
+	location.objectid = BTRFS_UUID_TREE_OBJECTID;
+	uuid_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(uuid_root)) {
+		ret = PTR_ERR(uuid_root);
+		if (ret != -ENOENT)
+			goto recovery_tree_root;
+		create_uuid_tree = true;
+	} else {
+		uuid_root->track_dirty = 1;
+		fs_info->uuid_root = uuid_root;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
@@ -2881,6 +2904,17 @@ retry_root_backup:
 
 	btrfs_qgroup_rescan_resume(fs_info);
 
+	if (create_uuid_tree) {
+		pr_info("btrfs: creating UUID tree\n");
+		ret = btrfs_create_uuid_tree(fs_info);
+		if (ret) {
+			pr_warn("btrfs: failed to create the UUID tree %d\n",
+				ret);
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
 	return 0;
 
 fail_qgroup:
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..2e271aa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4320,6 +4320,9 @@ static struct btrfs_block_rsv *get_block_rsv(
 	if (root == root->fs_info->csum_root && trans->adding_csums)
 		block_rsv = trans->block_rsv;
 
+	if (root == root->fs_info->uuid_root)
+		block_rsv = trans->block_rsv;
+
 	if (!block_rsv)
 		block_rsv = root->block_rsv;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b2d1eac..08c4e11 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3430,6 +3430,32 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *uuid_root;
+
+	/*
+	 * 1 - root node
+	 * 1 - root item
+	 */
+	trans = btrfs_start_transaction(tree_root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	uuid_root = btrfs_create_tree(trans, fs_info,
+				      BTRFS_UUID_TREE_OBJECTID);
+	if (IS_ERR(uuid_root)) {
+		btrfs_abort_transaction(trans, tree_root,
+					PTR_ERR(uuid_root));
+		return PTR_ERR(uuid_root);
+	}
+
+	fs_info->uuid_root = uuid_root;
+
+	return btrfs_commit_transaction(trans, tree_root);
+}
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8670558..e642cc0 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -315,6 +315,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
+int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.8.3.2

