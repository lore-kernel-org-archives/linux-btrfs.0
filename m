Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3B1KDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 05:03:44 -0500
Message-ID: <512F2BB1.4000000@cn.fujitsu.com>
Date: Thu, 28 Feb 2013 18:04:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 2/3] Btrfs: fix wrong reserved space in qgroup during snap/subv
 creation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two problems in the space reservation of the snapshot/
subvolume creation.
- don't reserve the space for the root item insertion
- the space which is reserved in the qgroup is different with
  the free space reservation. we need reserve free space for
  7 items, but in qgroup reservation, we need reserve space only
  for 3 items.

So we implement new metadata reservation functions for the
snapshot/subvolume creation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    9 +++++-
 fs/btrfs/extent-tree.c |   65 +++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.c       |   62 +++++++++++++++++++++++++++++++--------------
 fs/btrfs/transaction.c |    4 +--
 fs/btrfs/transaction.h |    1 +
 5 files changed, 105 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b355bb4..b98c451 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3068,8 +3068,13 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 				  struct inode *inode);
 void btrfs_orphan_release_metadata(struct inode *inode);
-int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
-				struct btrfs_pending_snapshot *pending);
+int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
+				     struct btrfs_block_rsv *rsv,
+				     int nitems,
+				     u64 *qgroup_reserved);
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
+				      struct btrfs_block_rsv *rsv,
+				      u64 qgroup_reserved);
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 88831fa..b795ed9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4496,19 +4496,60 @@ void btrfs_orphan_release_metadata(struct inode *inode)
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
 }
 
-int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
-				struct btrfs_pending_snapshot *pending)
+/*
+ * btrfs_subvolume_reserve_metadata() - reserve space for subvolume operation
+ * root: the root of the parent directory
+ * rsv: block reservation
+ * items: the number of items that we need do reservation
+ * qgroup_reserved: used to return the reserved size in qgroup
+ *
+ * This function is used to reserve the space for snapshot/subvolume
+ * creation and deletion. Those operations are different with the
+ * common file/directory operations, they change two fs/file trees
+ * and root tree, the number of items that the qgroup reserves is
+ * different with the free space reservation. So we can not use
+ * the space reseravtion mechanism in start_transaction().
+ */
+int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
+				     struct btrfs_block_rsv *rsv,
+				     int items,
+				     u64 *qgroup_reserved)
 {
-	struct btrfs_root *root = pending->root;
-	struct btrfs_block_rsv *src_rsv = get_block_rsv(trans, root);
-	struct btrfs_block_rsv *dst_rsv = &pending->block_rsv;
-	/*
-	 * two for root back/forward refs, two for directory entries,
-	 * one for root of the snapshot and one for parent inode.
-	 */
-	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 6);
-	dst_rsv->space_info = src_rsv->space_info;
-	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
+	u64 num_bytes;
+	int ret;
+
+	if (root->fs_info->quota_enabled) {
+		/* One for parent inode, two for dir entries */
+		num_bytes = 3 * root->leafsize;
+		ret = btrfs_qgroup_reserve(root, num_bytes);
+		if (ret)
+			return ret;
+	} else {
+		num_bytes = 0;
+	}
+
+	*qgroup_reserved = num_bytes;
+
+	num_bytes = btrfs_calc_trans_metadata_size(root, items);
+	rsv->space_info = __find_space_info(root->fs_info,
+					    BTRFS_BLOCK_GROUP_METADATA);
+	ret = btrfs_block_rsv_add(root, rsv, num_bytes,
+				  BTRFS_RESERVE_FLUSH_ALL);
+	if (ret) {
+		if (*qgroup_reserved)
+			btrfs_qgroup_free(root, *qgroup_reserved);
+	}
+
+	return ret;
+}
+
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
+				      struct btrfs_block_rsv *rsv,
+				      u64 qgroup_reserved)
+{
+	btrfs_block_rsv_release(root, rsv, (u64)-1);
+	if (qgroup_reserved)
+		btrfs_qgroup_free(root, qgroup_reserved);
 }
 
 /**
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 75c551d..8046cfc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -363,7 +363,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	return 0;
 }
 
-static noinline int create_subvol(struct btrfs_root *root,
+static noinline int create_subvol(struct inode *dir,
 				  struct dentry *dentry,
 				  char *name, int namelen,
 				  u64 *async_transid,
@@ -374,32 +374,39 @@ static noinline int create_subvol(struct btrfs_root *root,
 	struct btrfs_root_item root_item;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *new_root;
-	struct dentry *parent = dentry->d_parent;
-	struct inode *dir;
+	struct btrfs_block_rsv block_rsv;
 	struct timespec cur_time = CURRENT_TIME;
 	int ret;
 	int err;
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
+	u64 qgroup_reserved;
 	uuid_le new_uuid;
 
 	ret = btrfs_find_free_objectid(root->fs_info->tree_root, &objectid);
 	if (ret)
 		return ret;
 
-	dir = parent->d_inode;
-
+	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
 	/*
-	 * 1 - inode item
-	 * 2 - refs
-	 * 1 - root item
-	 * 2 - dir items
+	 * The same as the snapshot creation, please see the comment
+	 * of create_snapshot().
 	 */
-	trans = btrfs_start_transaction(root, 6);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
+					       7, &qgroup_reserved);
+	if (ret)
+		return ret;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	trans->block_rsv = &block_rsv;
+	trans->bytes_reserved = block_rsv.size;
 
 	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid, inherit);
 	if (ret)
@@ -515,6 +522,8 @@ static noinline int create_subvol(struct btrfs_root *root,
 	BUG_ON(ret);
 
 fail:
+	trans->block_rsv = NULL;
+	trans->bytes_reserved = 0;
 	if (async_transid) {
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
@@ -526,7 +535,8 @@ fail:
 
 	if (!ret)
 		d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
-
+out:
+	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
 	return ret;
 }
 
@@ -549,21 +559,31 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 
 	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
 			     BTRFS_BLOCK_RSV_TEMP);
+	/*
+	 * 1 - parent dir inode
+	 * 2 - dir entries
+	 * 1 - root item
+	 * 2 - root ref/backref
+	 * 1 - root of snapshot
+	 */
+	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
+					&pending_snapshot->block_rsv, 7,
+					&pending_snapshot->qgroup_reserved);
+	if (ret)
+		goto out;
+
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
 	pending_snapshot->readonly = readonly;
 	pending_snapshot->dir = dir;
 	pending_snapshot->inherit = inherit;
 
-	trans = btrfs_start_transaction(root->fs_info->extent_root, 6);
+	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto fail;
 	}
 
-	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
-	BUG_ON(ret);
-
 	spin_lock(&root->fs_info->trans_lock);
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
@@ -600,6 +620,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	d_instantiate(dentry, inode);
 	ret = 0;
 fail:
+	btrfs_subvolume_release_metadata(BTRFS_I(dir)->root,
+					 &pending_snapshot->block_rsv,
+					 pending_snapshot->qgroup_reserved);
+out:
 	kfree(pending_snapshot);
 	return ret;
 }
@@ -733,8 +757,8 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
 	} else {
-		error = create_subvol(BTRFS_I(dir)->root, dentry,
-				      name, namelen, async_transid, inherit);
+		error = create_subvol(dir, dentry, name, namelen,
+				      async_transid, inherit);
 	}
 	if (!error)
 		fsnotify_mkdir(dir, dentry);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 63390a3..61e34d8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1075,7 +1075,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = pending->error = -ENOMEM;
-		goto path_alloc_fail;
+		return ret;
 	}
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
@@ -1270,8 +1270,6 @@ no_free_objectid:
 	kfree(new_root_item);
 root_item_alloc_fail:
 	btrfs_free_path(path);
-path_alloc_fail:
-	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5f67fba..3c8e0d2 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -90,6 +90,7 @@ struct btrfs_pending_snapshot {
 	struct btrfs_qgroup_inherit *inherit;
 	/* block reservation for the operation */
 	struct btrfs_block_rsv block_rsv;
+	u64 qgroup_reserved;
 	/* extra metadata reseration for relocation */
 	int error;
 	bool readonly;
-- 
1.6.5.2
