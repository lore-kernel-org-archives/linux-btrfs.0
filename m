Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaBTKHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7YYL011826
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] Btrfs: use bitfield instead of integer data type for the some variants in btrfs_root
Date: Thu, 20 Feb 2014 18:08:54 +0800
Message-Id: <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c       | 25 ++++++++++++++-----------
 fs/btrfs/ctree.h       | 39 +++++++++++++++++++++------------------
 fs/btrfs/disk-io.c     | 33 +++++++++++++++------------------
 fs/btrfs/extent-tree.c |  6 +++---
 fs/btrfs/file.c        |  4 +++-
 fs/btrfs/inode.c       | 29 ++++++++++++++++++-----------
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/relocation.c  | 17 +++++++++--------
 fs/btrfs/root-tree.c   |  2 +-
 fs/btrfs/transaction.c | 33 +++++++++++++++++----------------
 fs/btrfs/tree-defrag.c |  2 +-
 fs/btrfs/tree-log.c    |  9 +++++----
 12 files changed, 109 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cbd3a7d..9067d79 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -224,7 +224,8 @@ static struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)
 static void add_root_to_dirty_list(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
-	if (root->track_dirty && list_empty(&root->dirty_list)) {
+	if (test_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state) &&
+	    list_empty(&root->dirty_list)) {
 		list_add(&root->dirty_list,
 			 &root->fs_info->dirty_cowonly_roots);
 	}
@@ -246,9 +247,10 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	int level;
 	struct btrfs_disk_key disk_key;
 
-	WARN_ON(root->ref_cows && trans->transid !=
-		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+		trans->transid != root->fs_info->running_transaction->transid);
+	WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+		trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
 	if (level == 0)
@@ -997,14 +999,14 @@ int btrfs_block_can_be_shared(struct btrfs_root *root,
 	 * snapshot and the block was not allocated by tree relocation,
 	 * we know the block is not shared.
 	 */
-	if (root->ref_cows &&
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
 	    buf != root->node && buf != root->commit_root &&
 	    (btrfs_header_generation(buf) <=
 	     btrfs_root_last_snapshot(&root->root_item) ||
 	     btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
 		return 1;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
-	if (root->ref_cows &&
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
 	    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
 		return 1;
 #endif
@@ -1146,9 +1148,10 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	btrfs_assert_tree_locked(buf);
 
-	WARN_ON(root->ref_cows && trans->transid !=
-		root->fs_info->running_transaction->transid);
-	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
+	WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+		trans->transid != root->fs_info->running_transaction->transid);
+	WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+		trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
 
@@ -1193,7 +1196,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	if (root->ref_cows) {
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state)) {
 		ret = btrfs_reloc_cow_block(trans, root, buf, cow);
 		if (ret)
 			return ret;
@@ -1556,7 +1559,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
 	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
 	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)) &&
-	    !root->force_cow)
+	    !test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return 0;
 	return 1;
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 277f627..c45a10a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1683,6 +1683,26 @@ struct btrfs_fs_info {
 };
 
 /*
+ * The state of btrfs root
+ */
+/*
+ * btrfs_record_root_in_trans is a multi-step process,
+ * and it can race with the balancing code.   But the
+ * race is very small, and only the first time the root
+ * is added to each transaction.  So IN_TRANS_SETUP
+ * is used to tell us when more checks are required
+ */
+#define BTRFS_ROOT_IN_TRANS_SETUP	0
+#define BTRFS_ROOT_REF_COWS		1
+#define BTRFS_ROOT_TRACK_DIRTY		2
+#define BTRFS_ROOT_IN_RADIX		3
+#define BTRFS_ROOT_DUMMY_ROOT		4
+#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	5
+#define BTRFS_ROOT_DEFRAG_RUNNING	6
+#define BTRFS_ROOT_FORCE_COW		7
+#define BTRFS_ROOT_MULTI_LOG_TASKS	8
+
+/*
  * in ram representation of the tree.  extent_root is used for all allocations
  * and for the extent tree extent_root root.
  */
@@ -1693,6 +1713,7 @@ struct btrfs_root {
 	struct btrfs_root *log_root;
 	struct btrfs_root *reloc_root;
 
+	unsigned long state;
 	struct btrfs_root_item root_item;
 	struct btrfs_key root_key;
 	struct btrfs_fs_info *fs_info;
@@ -1724,7 +1745,6 @@ struct btrfs_root {
 	unsigned long log_transid;
 	unsigned long last_log_commit;
 	pid_t log_start_pid;
-	bool log_multiple_pids;
 
 	u64 objectid;
 	u64 last_trans;
@@ -1744,23 +1764,9 @@ struct btrfs_root {
 
 	u64 highest_objectid;
 
-	/* btrfs_record_root_in_trans is a multi-step process,
-	 * and it can race with the balancing code.   But the
-	 * race is very small, and only the first time the root
-	 * is added to each transaction.  So in_trans_setup
-	 * is used to tell us when more checks are required
-	 */
-	unsigned long in_trans_setup;
-	int ref_cows;
-	int track_dirty;
-	int in_radix;
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	int dummy_root;
-#endif
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
 	struct btrfs_key defrag_max;
-	int defrag_running;
 	char *name;
 
 	/* the dirty list is only used by non-reference counted roots */
@@ -1774,7 +1780,6 @@ struct btrfs_root {
 	spinlock_t orphan_lock;
 	atomic_t orphan_inodes;
 	struct btrfs_block_rsv *orphan_block_rsv;
-	int orphan_item_inserted;
 	int orphan_cleanup_state;
 
 	spinlock_t inode_lock;
@@ -1792,8 +1797,6 @@ struct btrfs_root {
 	 */
 	dev_t anon_dev;
 
-	int force_cow;
-
 	spinlock_t root_item_lock;
 	atomic_t refs;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de6a48f..cc0af87 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1163,10 +1163,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->nodesize = nodesize;
 	root->leafsize = leafsize;
 	root->stripesize = stripesize;
-	root->ref_cows = 0;
-	root->track_dirty = 0;
-	root->in_radix = 0;
-	root->orphan_item_inserted = 0;
+	root->state = 0;
 	root->orphan_cleanup_state = 0;
 
 	root->objectid = objectid;
@@ -1221,7 +1218,6 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	else
 		root->defrag_trans_start = 0;
 	init_completion(&root->kobj_unregister);
-	root->defrag_running = 0;
 	root->root_key.objectid = objectid;
 	root->anon_dev = 0;
 
@@ -1246,7 +1242,7 @@ struct btrfs_root *btrfs_alloc_dummy_root(void)
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 	__setup_root(4096, 4096, 4096, 4096, root, NULL, 1);
-	root->dummy_root = 1;
+	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 
 	return root;
 }
@@ -1297,8 +1293,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 
 	root->commit_root = btrfs_root_node(root);
-	root->track_dirty = 1;
-
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
 
 	root->root_item.flags = 0;
 	root->root_item.byte_limit = 0;
@@ -1352,13 +1347,15 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root->root_key.offset = BTRFS_TREE_LOG_OBJECTID;
+
 	/*
+	 * DON'T set REF_COWS for log trees
+	 *
 	 * log trees do not get reference counted because they go away
 	 * before a real commit is actually done.  They do store pointers
 	 * to file data extents, and those reference counts still get
 	 * updated (along with back refs to the log tree).
 	 */
-	root->ref_cows = 0;
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 				      BTRFS_TREE_LOG_OBJECTID, NULL,
@@ -1491,7 +1488,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 		return root;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-		root->ref_cows = 1;
+		set_bit(BTRFS_ROOT_REF_COWS, &root->state);
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
 
@@ -1551,7 +1548,7 @@ int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 				(unsigned long)root->root_key.objectid,
 				root);
 	if (ret == 0)
-		root->in_radix = 1;
+		set_bit(BTRFS_ROOT_IN_RADIX, &root->state);
 	spin_unlock(&fs_info->fs_roots_radix_lock);
 	radix_tree_preload_end();
 
@@ -1607,7 +1604,7 @@ again:
 	if (ret < 0)
 		goto fail;
 	if (ret == 0)
-		root->orphan_item_inserted = 1;
+		set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state);
 
 	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
@@ -2047,7 +2044,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 				     struct btrfs_root, root_list);
 		list_del(&gang[0]->root_list);
 
-		if (gang[0]->in_radix) {
+		if (test_bit(BTRFS_ROOT_IN_RADIX, &gang[0]->state)) {
 			btrfs_drop_and_free_fs_root(fs_info, gang[0]);
 		} else {
 			free_extent_buffer(gang[0]->node);
@@ -2673,7 +2670,7 @@ retry_root_backup:
 		ret = PTR_ERR(extent_root);
 		goto recovery_tree_root;
 	}
-	extent_root->track_dirty = 1;
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &extent_root->state);
 	fs_info->extent_root = extent_root;
 
 	location.objectid = BTRFS_DEV_TREE_OBJECTID;
@@ -2682,7 +2679,7 @@ retry_root_backup:
 		ret = PTR_ERR(dev_root);
 		goto recovery_tree_root;
 	}
-	dev_root->track_dirty = 1;
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &dev_root->state);
 	fs_info->dev_root = dev_root;
 	btrfs_init_devices_late(fs_info);
 
@@ -2692,13 +2689,13 @@ retry_root_backup:
 		ret = PTR_ERR(csum_root);
 		goto recovery_tree_root;
 	}
-	csum_root->track_dirty = 1;
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &csum_root->state);
 	fs_info->csum_root = csum_root;
 
 	location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
 	quota_root = btrfs_read_tree_root(tree_root, &location);
 	if (!IS_ERR(quota_root)) {
-		quota_root->track_dirty = 1;
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &quota_root->state);
 		fs_info->quota_enabled = 1;
 		fs_info->pending_quota_state = 1;
 		fs_info->quota_root = quota_root;
@@ -2713,7 +2710,7 @@ retry_root_backup:
 		create_uuid_tree = true;
 		check_uuid_tree = false;
 	} else {
-		uuid_root->track_dirty = 1;
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &uuid_root->state);
 		fs_info->uuid_root = uuid_root;
 		create_uuid_tree = false;
 		check_uuid_tree =
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32312e0..a8155c9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2981,7 +2981,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
 
-	if (!root->ref_cows && level == 0)
+	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state) && level == 0)
 		return 0;
 
 	if (inc)
@@ -4372,7 +4372,7 @@ static struct btrfs_block_rsv *get_block_rsv(
 {
 	struct btrfs_block_rsv *block_rsv = NULL;
 
-	if (root->ref_cows)
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		block_rsv = trans->block_rsv;
 
 	if (root == root->fs_info->csum_root && trans->adding_csums)
@@ -7735,7 +7735,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		}
 	}
 
-	if (root->in_radix) {
+	if (test_bit(BTRFS_ROOT_IN_RADIX, &root->state)) {
 		btrfs_drop_and_free_fs_root(tree_root->fs_info, root);
 	} else {
 		free_extent_buffer(root->node);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0165b86..76ff550 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -713,7 +713,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int recow;
 	int ret;
 	int modify_tree = -1;
-	int update_refs = (root->ref_cows || root == root->fs_info->tree_root);
+	int update_refs;
 	int found = 0;
 	int leafs_visited = 0;
 
@@ -723,6 +723,8 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	if (start >= BTRFS_I(inode)->disk_i_size)
 		modify_tree = 0;
 
+	update_refs = (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
+		       root == root->fs_info->tree_root);
 	while (1) {
 		recow = 0;
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..558c2e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2917,14 +2917,15 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	root->orphan_block_rsv = NULL;
 	spin_unlock(&root->orphan_lock);
 
-	if (root->orphan_item_inserted &&
+	if (test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state) &&
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
 					    root->root_key.objectid);
 		if (ret)
 			btrfs_abort_transaction(trans, root, ret);
 		else
-			root->orphan_item_inserted = 0;
+			clear_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
+				  &root->state);
 	}
 
 	if (block_rsv) {
@@ -3241,7 +3242,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		btrfs_block_rsv_release(root, root->orphan_block_rsv,
 					(u64)-1);
 
-	if (root->orphan_block_rsv || root->orphan_item_inserted) {
+	if (root->orphan_block_rsv ||
+	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
 		trans = btrfs_join_transaction(root);
 		if (!IS_ERR(trans))
 			btrfs_end_transaction(trans, root);
@@ -3968,7 +3970,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 * not block aligned since we will be keeping the last block of the
 	 * extent just the way it is.
 	 */
-	if (root->ref_cows || root == root->fs_info->tree_root)
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
+	    root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, ALIGN(new_size,
 					root->sectorsize), (u64)-1, 0);
 
@@ -4061,7 +4064,9 @@ search_again:
 							 extent_num_bytes);
 				num_dec = (orig_num_bytes -
 					   extent_num_bytes);
-				if (root->ref_cows && extent_start != 0)
+				if (test_bit(BTRFS_ROOT_REF_COWS,
+					     &root->state) &&
+				    extent_start != 0)
 					inode_sub_bytes(inode, num_dec);
 				btrfs_mark_buffer_dirty(leaf);
 			} else {
@@ -4075,7 +4080,8 @@ search_again:
 				num_dec = btrfs_file_extent_num_bytes(leaf, fi);
 				if (extent_start != 0) {
 					found_extent = 1;
-					if (root->ref_cows)
+					if (test_bit(BTRFS_ROOT_REF_COWS,
+						     &root->state))
 						inode_sub_bytes(inode, num_dec);
 				}
 			}
@@ -4090,10 +4096,9 @@ search_again:
 			    btrfs_file_extent_other_encoding(leaf, fi) == 0) {
 				u32 size = new_size - found_key.offset;
 
-				if (root->ref_cows) {
+				if (test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 					inode_sub_bytes(inode, item_end + 1 -
 							new_size);
-				}
 
 				/*
 				 * update the ram bytes to properly reflect
@@ -4103,7 +4108,8 @@ search_again:
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
 				btrfs_truncate_item(root, path, size, 1);
-			} else if (root->ref_cows) {
+			} else if (test_bit(BTRFS_ROOT_REF_COWS,
+					    &root->state)) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);
 			}
@@ -4125,8 +4131,9 @@ delete:
 		} else {
 			break;
 		}
-		if (found_extent && (root->ref_cows ||
-				     root == root->fs_info->tree_root)) {
+		if (found_extent &&
+		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
+		     root == root->fs_info->tree_root)) {
 			btrfs_set_path_blocking(path);
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b7dc0f7..b061124 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -621,7 +621,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (!root->ref_cows)
+	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return -EINVAL;
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
@@ -2300,7 +2300,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	dest->root_item.drop_level = 0;
 	btrfs_set_root_refs(&dest->root_item, 0);
 
-	if (!xchg(&dest->orphan_item_inserted, 1)) {
+	if (!test_and_set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &dest->state)) {
 		ret = btrfs_insert_orphan_item(trans,
 					root->fs_info->tree_root,
 					dest->root_key.objectid);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 07b3b36..6425c5b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -528,7 +528,7 @@ static int should_ignore_root(struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
 
-	if (!root->ref_cows)
+	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return 0;
 
 	reloc_root = root->reloc_root;
@@ -610,7 +610,7 @@ struct btrfs_root *find_tree_root(struct reloc_control *rc,
 	root = read_fs_root(rc->extent_root->fs_info, root_objectid);
 	BUG_ON(IS_ERR(root));
 
-	if (root->ref_cows &&
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
 	    generation != btrfs_root_generation(&root->root_item))
 		return NULL;
 
@@ -887,7 +887,7 @@ again:
 			goto out;
 		}
 
-		if (!root->ref_cows)
+		if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 			cur->cowonly = 1;
 
 		if (btrfs_root_level(&root->root_item) == cur->level) {
@@ -954,7 +954,8 @@ again:
 				upper->bytenr = eb->start;
 				upper->owner = btrfs_header_owner(eb);
 				upper->level = lower->level + 1;
-				if (!root->ref_cows)
+				if (!test_bit(BTRFS_ROOT_REF_COWS,
+					      &root->state))
 					upper->cowonly = 1;
 
 				/*
@@ -2462,7 +2463,7 @@ struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
 		next = walk_up_backref(next, edges, &index);
 		root = next->root;
 		BUG_ON(!root);
-		BUG_ON(!root->ref_cows);
+		BUG_ON(!test_bit(BTRFS_ROOT_REF_COWS, &root->state));
 
 		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
 			record_reloc_root_in_trans(trans, root);
@@ -2527,7 +2528,7 @@ struct btrfs_root *select_one_root(struct btrfs_trans_handle *trans,
 		BUG_ON(!root);
 
 		/* no other choice for non-references counted tree */
-		if (!root->ref_cows)
+		if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 			return root;
 
 		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID)
@@ -2914,14 +2915,14 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (!root || root->ref_cows) {
+	if (!root || test_bit(BTRFS_ROOT_REF_COWS, &root->state)) {
 		ret = reserve_metadata_space(trans, rc, node);
 		if (ret)
 			goto out;
 	}
 
 	if (root) {
-		if (root->ref_cows) {
+		if (test_bit(BTRFS_ROOT_REF_COWS, &root->state)) {
 			BUG_ON(node->new_bytenr);
 			BUG_ON(!list_empty(&node->list));
 			btrfs_record_root_in_trans(trans, root);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 1389b69..a1a3fbf 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -305,7 +305,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 			break;
 		}
 
-		root->orphan_item_inserted = 1;
+		set_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state);
 
 		err = btrfs_insert_fs_root(root->fs_info, root);
 		if (err) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d888f26..9f32566 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -229,18 +229,19 @@ loop:
 static int record_root_in_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
-	if (root->ref_cows && root->last_trans < trans->transid) {
+	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
+	    root->last_trans < trans->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
 		WARN_ON(root->commit_root != root->node);
 
 		/*
-		 * see below for in_trans_setup usage rules
+		 * see below for IN_TRANS_SETUP usage rules
 		 * we have the reloc mutex held now, so there
 		 * is only one writer in this function
 		 */
-		root->in_trans_setup = 1;
+		set_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
 
-		/* make sure readers find in_trans_setup before
+		/* make sure readers find IN_TRANS_SETUP before
 		 * they find our root->last_trans update
 		 */
 		smp_wmb();
@@ -267,7 +268,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		 * But, we have to set root->last_trans before we
 		 * init the relocation root, otherwise, we trip over warnings
 		 * in ctree.c.  The solution used here is to flag ourselves
-		 * with root->in_trans_setup.  When this is 1, we're still
+		 * with root IN_TRANS_SETUP.  When this is 1, we're still
 		 * fixing up the reloc trees and everyone must wait.
 		 *
 		 * When this is zero, they can trust root->last_trans and fly
@@ -276,8 +277,8 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 		 * done before we pop in the zero below
 		 */
 		btrfs_init_reloc_root(trans, root);
-		smp_wmb();
-		root->in_trans_setup = 0;
+		smp_mb__before_clear_bit();
+		clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
 	}
 	return 0;
 }
@@ -286,16 +287,16 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
-	if (!root->ref_cows)
+	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return 0;
 
 	/*
-	 * see record_root_in_trans for comments about in_trans_setup usage
+	 * see record_root_in_trans for comments about IN_TRANS_SETUP usage
 	 * and barriers
 	 */
 	smp_rmb();
 	if (root->last_trans == trans->transid &&
-	    !root->in_trans_setup)
+	    !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
 		return 0;
 
 	mutex_lock(&root->fs_info->reloc_mutex);
@@ -353,7 +354,7 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 static inline bool need_reserve_reloc_root(struct btrfs_root *root)
 {
 	if (!root->fs_info->reloc_ctl ||
-	    !root->ref_cows ||
+	    !test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	    root->reloc_root)
 		return false;
@@ -1044,8 +1045,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_save_ino_cache(root, trans);
 
 			/* see comments in should_cow_block() */
-			root->force_cow = 0;
-			smp_wmb();
+			clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
+			smp_mb__after_clear_bit();
 
 			if (root->commit_root != root->node) {
 				mutex_lock(&root->fs_commit_mutex);
@@ -1079,7 +1080,7 @@ int btrfs_defrag_root(struct btrfs_root *root)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (xchg(&root->defrag_running, 1))
+	if (test_and_set_bit(BTRFS_ROOT_DEFRAG_RUNNING, &root->state))
 		return 0;
 
 	while (1) {
@@ -1102,7 +1103,7 @@ int btrfs_defrag_root(struct btrfs_root *root)
 			break;
 		}
 	}
-	root->defrag_running = 0;
+	clear_bit(BTRFS_ROOT_DEFRAG_RUNNING, &root->state);
 	return ret;
 }
 
@@ -1269,7 +1270,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	}
 
 	/* see comments in should_cow_block() */
-	root->force_cow = 1;
+	set_bit(BTRFS_ROOT_FORCE_COW, &root->state);
 	smp_wmb();
 
 	btrfs_set_root_node(new_root_item, tmp);
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 76928ca..a63719c 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -49,7 +49,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (root->ref_cows == 0)
+	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		goto out;
 
 	if (btrfs_test_opt(root, SSD))
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ca960ad..51d1bd9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -144,9 +144,9 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 	if (root->log_root) {
 		if (!root->log_start_pid) {
 			root->log_start_pid = current->pid;
-			root->log_multiple_pids = false;
+			clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
 		} else if (root->log_start_pid != current->pid) {
-			root->log_multiple_pids = true;
+			set_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
 		}
 
 		atomic_inc(&root->log_batch);
@@ -168,7 +168,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 	}
-	root->log_multiple_pids = false;
+	clear_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state);
 	root->log_start_pid = current->pid;
 	atomic_inc(&root->log_batch);
 	atomic_inc(&root->log_writers);
@@ -2454,7 +2454,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	while (1) {
 		int batch = atomic_read(&root->log_batch);
 		/* when we're on an ssd, just kick the log commit out */
-		if (!btrfs_test_opt(root, SSD) && root->log_multiple_pids) {
+		if (!btrfs_test_opt(root, SSD) &&
+		    test_bit(BTRFS_ROOT_MULTI_LOG_TASKS, &root->state)) {
 			mutex_unlock(&root->log_mutex);
 			schedule_timeout_uninterruptible(1);
 			mutex_lock(&root->log_mutex);
-- 
1.8.1.4

