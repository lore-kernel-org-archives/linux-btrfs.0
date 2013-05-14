Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:24295 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab3ENJhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 05:37:04 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.27 OK)
	with ESMTP id g01efep4E2rVzS for <linux-btrfs@vger.kernel.org>;
	Tue, 14 May 2013 11:37:01 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/8] Btrfs: create UUID tree if required
Date: Tue, 14 May 2013 11:36:55 +0200
Message-Id: <d2451984515c20274ceb953c95a6964589912f47.1368523154.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368523154.git.sbehrens@giantdisaster.de>
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368523154.git.sbehrens@giantdisaster.de>
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
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
 fs/btrfs/disk-io.c | 40 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 4 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ca9149a..6f9d760 100644
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
index 4904d7f..3c2bf74 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1499,6 +1499,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_root ? fs_info->quota_root :
 					     ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
+		return fs_info->uuid_root ? fs_info->uuid_root :
+					    ERR_PTR(-ENOENT);
 again:
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	root = radix_tree_lookup(&fs_info->fs_roots_radix,
@@ -1955,6 +1958,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		free_extent_buffer(info->quota_root->node);
 		free_extent_buffer(info->quota_root->commit_root);
 	}
+	if (info->uuid_root) {
+		free_extent_buffer(info->uuid_root->node);
+		free_extent_buffer(info->uuid_root->commit_root);
+	}
 
 	info->tree_root->node = NULL;
 	info->tree_root->commit_root = NULL;
@@ -1968,6 +1975,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		info->quota_root->node = NULL;
 		info->quota_root->commit_root = NULL;
 	}
+	if (info->uuid_root) {
+		info->uuid_root->node = NULL;
+		info->uuid_root->commit_root = NULL;
+	}
 
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
@@ -2029,11 +2040,13 @@ int open_ctree(struct super_block *sb,
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
 	extent_root = fs_info->extent_root = btrfs_alloc_root(fs_info);
@@ -2041,9 +2054,10 @@ int open_ctree(struct super_block *sb,
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
@@ -2604,6 +2618,19 @@ retry_root_backup:
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
+		create_uuid_tree = true;
+	} else {
+		uuid_root->track_dirty = 1;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
@@ -2788,6 +2815,17 @@ retry_root_backup:
 		return ret;
 	}
 
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
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a191bac..e6f5b88 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3427,6 +3427,33 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
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
+	uuid_root->track_dirty = 1;
+
+	return btrfs_commit_transaction(trans, tree_root);
+}
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 845ccbb..3479532 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -295,6 +295,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
+int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-- 
1.8.2.2

