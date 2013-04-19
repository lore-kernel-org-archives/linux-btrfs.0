Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:19635 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030692Ab3DSPlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:41:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp4) (RZmta 31.27 OK)
	with ESMTP id 600dd1p3JEL4tS for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:41:06 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: create UUID tree if required
Date: Fri, 19 Apr 2013 17:41:04 +0200
Message-Id: <5d01d8b14f6a8046f32ec887ab92da4f57a742a1.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This tree is not created by mkfs.btrfs. Therefore when a filesystem
is mounted writable and the UUID tree does not exist, this tree is
created if required. The tree is also added to the fs_info structure
and initialized, but this commit does not yet read or write UUID tree
elements.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/disk-io.c | 38 +++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c | 23 +++++++++++++++++++++++
 fs/btrfs/volumes.h |  2 ++
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0439570..c9baf55 100644
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
index 94d499a..75d196b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1563,6 +1563,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_root ? fs_info->quota_root :
 					     ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
+		return fs_info->uuid_root ? fs_info->uuid_root :
+					    ERR_PTR(-ENOENT);
 again:
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
@@ -2018,6 +2021,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		free_extent_buffer(info->quota_root->node);
 		free_extent_buffer(info->quota_root->commit_root);
 	}
+	if (info->uuid_root) {
+		free_extent_buffer(info->uuid_root->node);
+		free_extent_buffer(info->uuid_root->commit_root);
+	}
 
 	info->tree_root->node = NULL;
 	info->tree_root->commit_root = NULL;
@@ -2031,6 +2038,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		info->quota_root->node = NULL;
 		info->quota_root->commit_root = NULL;
 	}
+	if (info->uuid_root) {
+		info->uuid_root->node = NULL;
+		info->uuid_root->commit_root = NULL;
+	}
 
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
@@ -2062,11 +2073,13 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
 	struct btrfs_root *quota_root;
+	struct btrfs_root *uuid_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
+	bool need_to_create_uuid_tree = false;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
 	extent_root = fs_info->extent_root = btrfs_alloc_root(fs_info);
@@ -2074,9 +2087,10 @@ int open_ctree(struct super_block *sb,
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
 	dev_root = fs_info->dev_root = btrfs_alloc_root(fs_info);
 	quota_root = fs_info->quota_root = btrfs_alloc_root(fs_info);
+	uuid_root = fs_info->uuid_root = btrfs_alloc_root(fs_info);
 
 	if (!tree_root || !extent_root || !csum_root ||
-	    !chunk_root || !dev_root || !quota_root) {
+	    !chunk_root || !dev_root || !quota_root || !uuid_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
@@ -2651,6 +2665,19 @@ retry_root_backup:
 		fs_info->pending_quota_state = 1;
 	}
 
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_UUID_TREE_OBJECTID, uuid_root);
+	if (ret) {
+		if (ret != -ENOENT)
+			goto recovery_tree_root;
+
+		kfree(uuid_root);
+		uuid_root = fs_info->uuid_root = NULL;
+		need_to_create_uuid_tree = true;
+	} else {
+		uuid_root->track_dirty = 1;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
@@ -2830,6 +2857,15 @@ retry_root_backup:
 		return ret;
 	}
 
+	if (need_to_create_uuid_tree) {
+		ret = btrfs_create_uuid_tree(fs_info, tree_root);
+		if (ret) {
+			pr_warn("btrfs: failed to create the UUID tree\n");
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
 	return 0;
 
 fail_qgroup:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 76ded9e..5466aae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3426,6 +3426,29 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info,
+			   struct btrfs_root *tree_root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *uuid_root;
+
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
+	uuid_root->track_dirty = 1;
+
+	return btrfs_commit_transaction(trans, tree_root);
+}
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 062d860..81dade3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -304,6 +304,8 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
+int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info,
+			   struct btrfs_root *tree_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-- 
1.8.2.1

