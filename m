Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58777 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab3LRVHp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:07:45 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBIL6MuR019215
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:44 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1gu8f5su3u-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:42 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: rework qgroup accounting
Date: Wed, 18 Dec 2013 16:07:28 -0500
Message-ID: <1387400849-7274-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1387400849-7274-1-git-send-email-jbacik@fb.com>
References: <1387400849-7274-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently qgroups account for space by intercepting delayed ref updates to fs
trees.  It does this by adding sequence numbers to delayed ref updates so that
it can figure out how the tree looked before the update so we can adjust the
counters properly.  The problem with this is that it does not allow delayed refs
to be merged, so if you say are defragging an extent with 5k snapshots pointing
to it we will thrash the delayed ref lock because we need to go back and
manually merge these things together.  Instead we want to process quota changes
when we know they are going to happen, like when we first allocate an extent, we
free a reference for an extent, we add new references etc.  This patch does this
and removes the reliance on the delayed ref sequence number.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c     |   19 +-
 fs/btrfs/backref.h     |    5 +-
 fs/btrfs/ctree.h       |   51 ++-
 fs/btrfs/delayed-ref.c |   10 -
 fs/btrfs/delayed-ref.h |   19 -
 fs/btrfs/disk-io.c     |    3 +
 fs/btrfs/extent-tree.c |  457 ++++++++++++++++----
 fs/btrfs/qgroup.c      | 1075 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/transaction.c |   51 ++-
 9 files changed, 1312 insertions(+), 378 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6a3f7f5..9ee3030 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -817,7 +817,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 time_seq, struct ulist *refs,
-			     struct ulist *roots, const u64 *extent_item_pos)
+			     struct ulist *roots, const u64 *extent_item_pos,
+			     int search_commit_root)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -842,7 +843,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	if (!trans)
+	if (search_commit_root)
 		path->search_commit_root = 1;
 
 	/*
@@ -1046,7 +1047,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 	}
 
 	ret = find_parent_nodes(trans, fs_info, bytenr,
-				time_seq, *leafs, tmp, extent_item_pos);
+				time_seq, *leafs, tmp, extent_item_pos,
+				(trans == NULL));
 	ulist_free(tmp);
 
 	if (ret < 0 && ret != -ENOENT) {
@@ -1071,8 +1073,9 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  * returns 0 on success, < 0 on error.
  */
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 time_seq, struct ulist **roots)
+			 struct btrfs_fs_info *fs_info, u64 bytenr,
+			 u64 time_seq, struct ulist **roots,
+			 int search_commit_root)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1091,7 +1094,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr,
-					time_seq, tmp, *roots, NULL);
+					time_seq, tmp, *roots, NULL,
+					search_commit_root);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1497,7 +1501,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
-					   tree_mod_seq_elem.seq, &roots);
+					   tree_mod_seq_elem.seq, &roots,
+					   search_commit_root);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index a910b27..0ad87c8 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -55,8 +55,9 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 time_seq, struct ulist **roots);
+			 struct btrfs_fs_info *fs_info, u64 bytenr,
+			 u64 time_seq, struct ulist **roots,
+			 int search_commit_root);
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b3fd61..944c916 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1289,6 +1289,32 @@ enum btrfs_orphan_cleanup_state {
 	ORPHAN_CLEANUP_DONE	= 2,
 };
 
+/*
+ * A description of the operations, all of these operations only happen when we
+ * are adding the 1st reference for that subvolume in the case of adding space
+ * or on the last reference delete in the case of subtraction.
+ *
+ * BTRFS_QGROUP_OPER_ADD_EXCL: adding bytes where this subvolume is the only
+ * one pointing at the bytes we are adding.  This is called on the first
+ * allocation.
+ *
+ * BTRFS_QGROUP_OPER_ADD_SHARED: adding bytes where this bytenr is going to be
+ * shared between subvols.  This is called on the creation of a ref that already
+ * has refs from a different subvolume, so basically reflink.
+ *
+ * BTRFS_QGROUP_OPER_SUB_EXCL: removing bytes where this subvolume is the only
+ * one referencing the range.
+ *
+ * BTRFS_QGROUP_OPER_SUB_SHARED: removing bytes where this subvolume shares with
+ * refs with other subvolumes.
+ */
+enum btrfs_qgroup_operation_type {
+	BTRFS_QGROUP_OPER_ADD_EXCL,
+	BTRFS_QGROUP_OPER_ADD_SHARED,
+	BTRFS_QGROUP_OPER_SUB_EXCL,
+	BTRFS_QGROUP_OPER_SUB_SHARED,
+};
+
 /* used by the raid56 code to lock stripes for read/modify/write */
 struct btrfs_stripe_hash {
 	struct list_head hash_list;
@@ -1629,7 +1655,10 @@ struct btrfs_fs_info {
 
 	/* holds configuration and tracking. Protected by qgroup_lock */
 	struct rb_root qgroup_tree;
+	struct rb_root qgroup_op_tree;
 	spinlock_t qgroup_lock;
+	spinlock_t qgroup_op_lock;
+	atomic_t qgroup_op_seq;
 
 	/*
 	 * used to avoid frequently calling ulist_alloc()/ulist_free()
@@ -3323,12 +3352,10 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 int __get_raid_index(u64 flags);
 int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
-	     u64 num_bytes, int for_cow,
-	     struct btrfs_block_group_cache **block_group,
+	     u64 num_bytes, struct btrfs_block_group_cache **block_group,
 	     struct extent_state **cached_state);
 int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
-	       u64 num_bytes, int for_cow,
-	       struct btrfs_block_group_cache *block_group,
+	       u64 num_bytes, struct btrfs_block_group_cache *block_group,
 	       struct extent_state **cached_state);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
@@ -4031,12 +4058,16 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info);
 void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
 struct btrfs_delayed_extent_op;
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_delayed_ref_node *node,
-			    struct btrfs_delayed_extent_op *extent_op);
-int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
-			     struct btrfs_delayed_ref_node *node,
-			     struct btrfs_delayed_extent_op *extent_op);
+			    struct btrfs_fs_info *fs_info, u64 ref_root,
+			    u64 bytenr, u64 num_bytes, u64 parent,
+			    enum btrfs_qgroup_operation_type type);
+int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
+				    struct btrfs_fs_info *fs_info);
+void btrfs_remove_last_qgroup_operation(struct btrfs_trans_handle *trans,
+					struct btrfs_fs_info *fs_info,
+					u64 ref_root);
+int btrfs_qgroup_add_shared_ref(struct btrfs_trans_handle *trans, u64 ref_root,
+				u64 parent);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ee1c29d..d5a601e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -681,9 +681,6 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 	ref->for_cow = for_cow;
-
-	if (need_ref_seq(for_cow, ref_root))
-		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
@@ -741,9 +738,6 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 	ref->for_cow = for_cow;
-
-	if (need_ref_seq(for_cow, ref_root))
-		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
@@ -817,8 +811,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
 	spin_unlock(&delayed_refs->lock);
-	if (need_ref_seq(for_cow, ref_root))
-		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
 
 	return 0;
 }
@@ -865,8 +857,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
 	spin_unlock(&delayed_refs->lock);
-	if (need_ref_seq(for_cow, ref_root))
-		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
 
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index db71a37..b747180 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -241,25 +241,6 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 			    u64 seq);
 
 /*
- * delayed refs with a ref_seq > 0 must be held back during backref walking.
- * this only applies to items in one of the fs-trees. for_cow items never need
- * to be held back, so they won't get a ref_seq number.
- */
-static inline int need_ref_seq(int for_cow, u64 rootid)
-{
-	if (for_cow)
-		return 0;
-
-	if (rootid == BTRFS_FS_TREE_OBJECTID)
-		return 1;
-
-	if ((s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
-		return 1;
-
-	return 0;
-}
-
-/*
  * a node might live in a head or a regular ref, this lets you
  * test for the proper type to use.
  */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4a1871c..3eb27b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2151,6 +2151,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->free_chunk_lock);
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
+	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->buffer_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
@@ -2175,6 +2176,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
+	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
@@ -2282,6 +2284,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->qgroup_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
 	fs_info->qgroup_tree = RB_ROOT;
+	fs_info->qgroup_op_tree = RB_ROOT;
 	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
 	fs_info->qgroup_seq = 1;
 	fs_info->quota_enabled = 0;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 03b536c..71673d6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -680,7 +680,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
  * @root_objectid: the root objectid that we are modifying for this extent.
  * @bytenr: the byte we are modifying the reference for
  * @num_bytes: the number of bytes we are locking.
- * @for_cow: if this operation is for cow then we don't need to lock
  * @block_group: we will store the block group we looked up so that the unlock
  * doesn't have to do another search.
  * @cached_state: this is for caching our location so when we unlock we don't
@@ -689,14 +688,13 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
  * This can return -ENOMEM if we cannot allocate our extent state.
  */
 int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
-	     u64 num_bytes, int for_cow,
-	     struct btrfs_block_group_cache **block_group,
+	     u64 num_bytes, struct btrfs_block_group_cache **block_group,
 	     struct extent_state **cached_state)
 {
 	struct btrfs_block_group_cache *cache;
 	int ret;
 
-	if (!fs_info->quota_enabled || !need_ref_seq(for_cow, root_objectid))
+	if (!fs_info->quota_enabled || !is_fstree(root_objectid))
 		return 0;
 
 	cache = btrfs_lookup_block_group(fs_info, bytenr);
@@ -721,7 +719,6 @@ int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
  * @root_objectid: the root objectid that we are modifying for this extent.
  * @bytenr: the byte we are modifying the reference for
  * @num_bytes: the number of bytes we are locking.
- * @for_cow: if this ref update is for cow we didn't take the lock.
  * @block_group: the block_group we got from lock_ref.
  * @cached_state: this is for caching our location so when we unlock we don't
  * have to do a tree search.
@@ -729,13 +726,12 @@ int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
  * This can return -ENOMEM if we fail to allocate an extent state.
  */
 int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
-	       u64 num_bytes, int for_cow,
-	       struct btrfs_block_group_cache *block_group,
+	       u64 num_bytes, struct btrfs_block_group_cache *block_group,
 	       struct extent_state **cached_state)
 {
 	int ret;
 
-	if (!fs_info->quota_enabled || !need_ref_seq(for_cow, root_objectid))
+	if (!fs_info->quota_enabled || !is_fstree(root_objectid))
 		return 0;
 
 	ret = unlock_extent_cached(&block_group->ref_lock, bytenr,
@@ -1342,7 +1338,7 @@ fail:
 static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 					   struct btrfs_root *root,
 					   struct btrfs_path *path,
-					   int refs_to_drop)
+					   int refs_to_drop, int *last_ref)
 {
 	struct btrfs_key key;
 	struct btrfs_extent_data_ref *ref1 = NULL;
@@ -1378,6 +1374,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 
 	if (num_refs == 0) {
 		ret = btrfs_del_item(trans, root, path);
+		*last_ref = 1;
 	} else {
 		if (key.type == BTRFS_EXTENT_DATA_REF_KEY)
 			btrfs_set_extent_data_ref_count(leaf, ref1, num_refs);
@@ -1533,6 +1530,193 @@ static int find_next_key(struct btrfs_path *path, int level,
 }
 
 /*
+ * Look at an inline extent backref to see if one of the references matches the
+ * root we are looking for.
+ */
+static int find_root_in_inline_backref(struct btrfs_trans_handle *trans,
+				       struct btrfs_path *path, u64 ref_root,
+				       int slot, int add_shared,
+				       int *refs_to_add, int *shared_refs)
+{
+	struct extent_buffer *leaf = path->nodes[0];
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_data_ref *dref;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_key key;
+	u64 item_size;
+	u64 flags;
+	u64 root;
+	u64 refs;
+	u64 parent;
+	unsigned long ptr;
+	unsigned long end;
+	int type;
+	int ret = 0;
+	bool found = false;
+
+	item_size = btrfs_item_size_nr(leaf, slot);
+#ifdef BTRFS_COMPAT_EXTENT_TREE_V0
+	/* We really shouldn't have V0 references with an fs that has quotas. */
+	if (item_size < sizeof(*ei))
+		return -EINVAL;
+#endif
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(leaf, ei);
+
+	ptr = (unsigned long)(ei + 1);
+	end = (unsigned long)ei + item_size;
+
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK &&
+	    key.type == BTRFS_EXTENT_ITEM_KEY) {
+		ptr += sizeof(struct btrfs_tree_block_info);
+		ASSERT(ptr <= end);
+	}
+
+	while (!found && ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+
+		switch (type) {
+		case BTRFS_EXTENT_DATA_REF_KEY:
+			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root != ref_root)
+				break;
+			refs = btrfs_extent_data_ref_count(leaf, dref);
+			if (refs > (u64)(*refs_to_add))
+				found = true;
+			else
+				*refs_to_add -= (int)refs;
+			break;
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			if (btrfs_extent_inline_ref_offset(leaf, iref) !=
+			    ref_root)
+				break;
+			if (*refs_to_add == 0)
+				found = true;
+			(*refs_to_add)--;
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY:
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			(*shared_refs)++;
+			if (!add_shared)
+				break;
+			parent = btrfs_extent_inline_ref_offset(leaf, iref);
+			ret = btrfs_qgroup_add_shared_ref(trans, ref_root,
+							  parent);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		if (ret || found)
+			break;
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+	if (found)
+		ret = 1;
+	return ret;
+}
+
+/*
+ * This will look for the given root ref from path.  This assumes that path is
+ * pointing at the extent item for the extent you want to check.
+ */
+static int root_has_ref(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, struct btrfs_path *path,
+			u64 bytenr, u64 ref_root, int can_search_forward,
+			int add_shared, int refs_to_add, int *shared_refs)
+{
+	struct extent_buffer *leaf = path->nodes[0];
+	struct btrfs_extent_data_ref *ref;
+	struct btrfs_key key;
+	u64 refs;
+	u64 found_root;
+	int slot = path->slots[0];
+	int ret = 0;
+	bool found = false;
+
+	root = root->fs_info->extent_root;
+
+	/* Return 1 so we don't do any of the accounting */
+	if (!root->fs_info->quota_enabled || !is_fstree(ref_root))
+		return 1;
+
+	while (!found) {
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid != bytenr)
+			break;
+		if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY)
+			goto next;
+		switch (key.type) {
+		case BTRFS_EXTENT_ITEM_KEY:
+		case BTRFS_METADATA_ITEM_KEY:
+			ret = find_root_in_inline_backref(trans, path,
+							  ref_root, slot,
+							  add_shared,
+							  &refs_to_add,
+							  shared_refs);
+			if (ret > 0)
+				found = true;
+			break;
+		case BTRFS_EXTENT_DATA_REF_KEY:
+			ref = btrfs_item_ptr(leaf, slot,
+					     struct btrfs_extent_data_ref);
+			found_root = btrfs_extent_data_ref_root(leaf, ref);
+			if (found_root != ref_root)
+				break;
+			refs = btrfs_extent_data_ref_count(leaf, ref);
+			if (refs > (u64)refs_to_add)
+				found = true;
+			else
+				refs_to_add -= (int)refs;
+			break;
+		case BTRFS_TREE_BLOCK_REF_KEY:
+			if (key.offset != ref_root)
+				break;
+			if (!refs_to_add)
+				found = true;
+			refs_to_add--;
+			break;
+		case BTRFS_SHARED_DATA_REF_KEY:
+		case BTRFS_SHARED_BLOCK_REF_KEY:
+			(*shared_refs)++;
+			if (!add_shared)
+				break;
+			ret = btrfs_qgroup_add_shared_ref(trans, ref_root,
+							  key.offset);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		if (ret || found)
+			break;
+next:
+		slot++;
+		if (slot >= btrfs_header_nritems(leaf)) {
+			if (!can_search_forward) {
+				ret = -EAGAIN;
+				break;
+			}
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				break;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			leaf = path->nodes[0];
+			slot = 0;
+		}
+	}
+	if (found)
+		ret = 1;
+	return ret;
+}
+
+/*
  * look for inline back ref. if back ref is found, *ref_ret is set
  * to the address of inline back ref, and 0 is returned.
  *
@@ -1834,7 +2018,8 @@ void update_inline_extent_backref(struct btrfs_root *root,
 				  struct btrfs_path *path,
 				  struct btrfs_extent_inline_ref *iref,
 				  int refs_to_mod,
-				  struct btrfs_delayed_extent_op *extent_op)
+				  struct btrfs_delayed_extent_op *extent_op,
+				  int *last_ref)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -1878,6 +2063,7 @@ void update_inline_extent_backref(struct btrfs_root *root,
 		else
 			btrfs_set_shared_data_ref_count(leaf, sref, refs);
 	} else {
+		*last_ref = 1;
 		size =  btrfs_extent_inline_ref_size(type);
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
 		ptr = (unsigned long)iref;
@@ -1898,9 +2084,11 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 				 u64 bytenr, u64 num_bytes, u64 parent,
 				 u64 root_objectid, u64 owner,
 				 u64 offset, int refs_to_add,
-				 struct btrfs_delayed_extent_op *extent_op)
+				 struct btrfs_delayed_extent_op *extent_op,
+				 int *new_ref)
 {
 	struct btrfs_extent_inline_ref *iref;
+	int shared_refs = 0;
 	int ret;
 
 	ret = lookup_inline_extent_backref(trans, root, path, &iref,
@@ -1909,8 +2097,33 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
 		update_inline_extent_backref(root, path, iref,
-					     refs_to_add, extent_op);
+					     refs_to_add, extent_op, NULL);
 	} else if (ret == -ENOENT) {
+		/*
+		 * We want to quickly see if we are adding a ref for a root that
+		 * already holds a ref on this backref, so we'll search forward
+		 * as much as we can to see if that's the case.  This is to keep
+		 * us from searching again if we don't have to, otherwise we'll
+		 * have to do this whole search over again to make sure we
+		 * really don't have another guy.  Keep in mind this does
+		 * nothing if quotas aren't enabled.
+		 */
+		ret = root_has_ref(trans, root, path, bytenr, root_objectid, 0,
+				   0, 0, &shared_refs);
+		if (ret <= 0) {
+			/*
+			 * If we got an error back from root_has_ref or we
+			 * tripped over a shared ref then we need to make sure
+			 * the caller re-calls root_has_ref to either verify
+			 * this root is not already pointing at this bytenr or
+			 * in the case of shared_refs we add the shared refs we
+			 * find.
+			 */
+			if (shared_refs || ret < 0)
+				*new_ref = 2;
+			else
+				*new_ref = 1;
+		}
 		setup_inline_extent_backref(root, path, iref, parent,
 					    root_objectid, owner, offset,
 					    refs_to_add, extent_op);
@@ -1942,17 +2155,19 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
-				 int refs_to_drop, int is_data)
+				 int refs_to_drop, int is_data, int *last_ref)
 {
 	int ret = 0;
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
 		update_inline_extent_backref(root, path, iref,
-					     -refs_to_drop, NULL);
+					     -refs_to_drop, NULL, last_ref);
 	} else if (is_data) {
-		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
+		ret = remove_extent_data_ref(trans, root, path, refs_to_drop,
+					     last_ref);
 	} else {
+		*last_ref = 1;
 		ret = btrfs_del_item(trans, root, path);
 	}
 	return ret;
@@ -2045,11 +2260,16 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 owner, u64 offset, int refs_to_add,
 				  struct btrfs_delayed_extent_op *extent_op)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *item;
+	struct btrfs_key key;
 	u64 refs;
+	int new_ref = 0;
+	int shared_refs = 0;
 	int ret;
+	enum btrfs_qgroup_operation_type type = BTRFS_QGROUP_OPER_ADD_EXCL;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2058,16 +2278,75 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	path->reada = 1;
 	path->leave_spinning = 1;
 	/* this will setup the path even if it fails to insert the back ref */
-	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
-					   path, bytenr, num_bytes, parent,
+	ret = insert_inline_extent_backref(trans, fs_info->extent_root, path,
+					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset,
-					   refs_to_add, extent_op);
-	if (ret != -EAGAIN)
+					   refs_to_add, extent_op, &new_ref);
+	if ((ret < 0 && ret != -EAGAIN) || (!ret && !new_ref))
+		goto out;
+	/*
+	 * Ok we were able to insert an inline extent and it appears to be a new
+	 * reference, deal with the qgroup accounting.
+	 */
+	if (!ret && new_ref) {
+		int shared_refs = 0;
+
+		ASSERT(root->fs_info->quota_enabled);
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		item = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_item);
+		if (btrfs_extent_refs(leaf, item) > (u64)refs_to_add)
+			type = BTRFS_QGROUP_OPER_ADD_SHARED;
+
+		/* Parent doesn't matter for add operations */
+		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
+					      bytenr, num_bytes, 0, type);
+		if (ret < 0)
+			goto out;
+
+		/* There are no shared refs, so we can just exit now. */
+		if (new_ref == 1)
+			goto out;
+		btrfs_release_path(path);
+		path->leave_spinning = 0;
+		ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key,
+					path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ASSERT(ret == 0);
+
+		/*
+		 * Have to pass the refs we added since we will have added this
+		 * backref already so we needto make sure there wasn't any other
+		 * refs for this root.
+		 */
+		ret = root_has_ref(trans, root, path, bytenr, root_objectid,
+				   1, 1, refs_to_add, &shared_refs);
+		if (ret < 0)
+			goto out;
+		/*
+		 * Upon a second search we found our root referencing this
+		 * bytenr already.
+		 */
+		if (ret > 0)
+			btrfs_remove_last_qgroup_operation(trans, fs_info,
+							   root_objectid);
+		ret = 0;
 		goto out;
+	}
 
+	/*
+	 * Ok we had -EAGAIN which means we didn't have space to insert and
+	 * inline extent ref, so just update the reference count and add a
+	 * normal backref.
+	 */
 	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, item);
+	if (refs)
+		type = BTRFS_QGROUP_OPER_ADD_SHARED;
 	btrfs_set_extent_refs(leaf, item, refs + refs_to_add);
 	if (extent_op)
 		__run_delayed_extent_op(extent_op, leaf, item);
@@ -2075,9 +2354,37 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
+	/*
+	 * Do qgroup accounting.  We go ahead and add the ref first in case
+	 * there are no matches, since in the other case we'd have to run
+	 * root_has_ref twice, once without add_shared set and then again with
+	 * add_shared set if there were any shared refs.
+	 */
+	if (is_fstree(root_objectid) && fs_info->quota_enabled) {
+		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
+					      bytenr, num_bytes, 0, type);
+		if (ret)
+			goto out;
+		path->leave_spinning = 0;
+		ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key,
+					path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ASSERT(ret == 0);
+
+		ret = root_has_ref(trans, root, path, bytenr, root_objectid,
+				   1, 1, 0, &shared_refs);
+		if (ret < 0)
+			goto out;
+		if (ret > 0)
+			btrfs_remove_last_qgroup_operation(trans, fs_info,
+							   root_objectid);
+		btrfs_release_path(path);
+		ret = 0;
+	}
+
 	path->reada = 1;
 	path->leave_spinning = 1;
-
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
 				    path, bytenr, parent, root_objectid,
@@ -2114,11 +2421,10 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 
 	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
 		parent = ref->parent;
-	else
-		ref_root = ref->root;
+	ref_root = ref->root;
 
 	ret = lock_ref(root->fs_info, ref->root, node->bytenr, node->num_bytes,
-		       node->for_cow, &block_group, &cached_state);
+		       &block_group, &cached_state);
 	if (ret)
 		return ret;
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
@@ -2144,8 +2450,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 	err = unlock_ref(root->fs_info, ref->root, node->bytenr,
-			 node->num_bytes, node->for_cow, block_group,
-			 &cached_state);
+			 node->num_bytes, block_group, &cached_state);
 	return ret ? ret : err;
 }
 
@@ -2282,8 +2587,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 
 	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
 		parent = ref->parent;
-	else
-		ref_root = ref->root;
+	ref_root = ref->root;
 
 	ins.objectid = node->bytenr;
 	if (skinny_metadata) {
@@ -2295,7 +2599,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	ret = lock_ref(root->fs_info, ref->root, node->bytenr, node->num_bytes,
-		       node->for_cow, &block_group, &cached_state);
+		       &block_group, &cached_state);
 	if (ret)
 		return ret;
 	BUG_ON(node->ref_mod != 1);
@@ -2318,8 +2622,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 	err = unlock_ref(root->fs_info, ref->root, node->bytenr,
-			 node->num_bytes, node->for_cow, block_group,
-			 &cached_state);
+			 node->num_bytes, block_group, &cached_state);
 	return ret ? ret : err;
 }
 
@@ -2633,42 +2936,6 @@ static u64 find_middle(struct rb_root *root)
 }
 #endif
 
-int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info)
-{
-	struct qgroup_update *qgroup_update;
-	int ret = 0;
-
-	if (list_empty(&trans->qgroup_ref_list) !=
-	    !trans->delayed_ref_elem.seq) {
-		/* list without seq or seq without list */
-		btrfs_err(fs_info,
-			"qgroup accounting update error, list is%s empty, seq is %#x.%x",
-			list_empty(&trans->qgroup_ref_list) ? "" : " not",
-			(u32)(trans->delayed_ref_elem.seq >> 32),
-			(u32)trans->delayed_ref_elem.seq);
-		BUG();
-	}
-
-	if (!trans->delayed_ref_elem.seq)
-		return 0;
-
-	while (!list_empty(&trans->qgroup_ref_list)) {
-		qgroup_update = list_first_entry(&trans->qgroup_ref_list,
-						 struct qgroup_update, list);
-		list_del(&qgroup_update->list);
-		if (!ret)
-			ret = btrfs_qgroup_account_ref(
-					trans, fs_info, qgroup_update->node,
-					qgroup_update->extent_op);
-		kfree(qgroup_update);
-	}
-
-	btrfs_put_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
-
-	return ret;
-}
-
 static int refs_newer(struct btrfs_delayed_ref_root *delayed_refs, int seq,
 		      int count)
 {
@@ -2754,8 +3021,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	if (root == root->fs_info->extent_root)
 		root = root->fs_info->tree_root;
 
-	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
-
 	delayed_refs = &trans->transaction->delayed_refs;
 	INIT_LIST_HEAD(&cluster);
 	if (count == 0) {
@@ -2829,6 +3094,7 @@ again:
 			btrfs_abort_transaction(trans, root, ret);
 			atomic_dec(&delayed_refs->procs_running_refs);
 			wake_up(&delayed_refs->wait);
+			btrfs_delayed_qgroup_accounting(trans, root->fs_info);
 			return ret;
 		}
 
@@ -2910,6 +3176,9 @@ out:
 		wake_up(&delayed_refs->wait);
 
 	spin_unlock(&delayed_refs->lock);
+	ret = btrfs_delayed_qgroup_accounting(trans, root->fs_info);
+	if (ret)
+		return ret;
 	assert_qgroups_uptodate(trans);
 	return 0;
 }
@@ -5796,6 +6065,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	int num_to_del = 1;
 	u32 item_size;
 	u64 refs;
+	int last_ref = 0;
+	enum btrfs_qgroup_operation_type type = BTRFS_QGROUP_OPER_SUB_EXCL;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
@@ -5846,7 +6117,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(iref);
 			ret = remove_extent_backref(trans, extent_root, path,
 						    NULL, refs_to_drop,
-						    is_data);
+						    is_data, &last_ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
 				goto out;
@@ -5970,6 +6241,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	refs -= refs_to_drop;
 
 	if (refs > 0) {
+		type = BTRFS_QGROUP_OPER_SUB_SHARED;
 		if (extent_op)
 			__run_delayed_extent_op(extent_op, leaf, ei);
 		/*
@@ -5985,7 +6257,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		if (found_extent) {
 			ret = remove_extent_backref(trans, extent_root, path,
 						    iref, refs_to_drop,
-						    is_data);
+						    is_data, &last_ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
 				goto out;
@@ -6006,6 +6278,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
+		last_ref = 1;
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		if (ret) {
@@ -6028,6 +6301,35 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 	}
+	btrfs_release_path(path);
+
+	/* Deal with the quota accounting */
+	if (!ret && last_ref && info->quota_enabled &&
+	    is_fstree(root_objectid)) {
+		int shared_refs = 0;
+
+		ret = btrfs_qgroup_record_ref(trans, info, root_objectid,
+					      bytenr, num_bytes, parent, type);
+		/*
+		 * If we deleted the extent item then we can just bail without
+		 * having to look for more extents.
+		 */
+		if (ret < 0 || type == BTRFS_QGROUP_OPER_SUB_EXCL)
+			goto out;
+		path->leave_spinning = 0;
+		ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ASSERT(ret == 0);
+		ret = root_has_ref(trans, root, path, bytenr, root_objectid, 1,
+				   0, 0, &shared_refs);
+		if (ret < 0)
+			goto out;
+		if (ret > 0)
+			btrfs_remove_last_qgroup_operation(trans, info,
+							   root_objectid);
+		ret = 0;
+	}
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -6899,6 +7201,13 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
+	/* Always set parent to 0 here since its exclusive anyway. */
+	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
+				      ins->objectid, ins->offset, 0,
+				      BTRFS_QGROUP_OPER_ADD_EXCL);
+	if (ret)
+		return ret;
+
 	ret = update_block_group(root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
@@ -6923,6 +7232,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
+	u64 num_bytes = ins->offset;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
@@ -6956,6 +7266,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	if (skinny_metadata) {
 		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+		num_bytes = root->leafsize;
 	} else {
 		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 		btrfs_set_tree_block_key(leaf, block_info, key);
@@ -6977,6 +7288,12 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
+	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
+				      ins->objectid, num_bytes, 0,
+				      BTRFS_QGROUP_OPER_ADD_EXCL);
+	if (ret)
+		return ret;
+
 	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bd0b058..1ecc528 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -84,8 +84,8 @@ struct btrfs_qgroup {
 	/*
 	 * temp variables for accounting operations
 	 */
-	u64 tag;
-	u64 refcnt;
+	u64 old_refcnt;
+	u64 new_refcnt;
 };
 
 /*
@@ -98,6 +98,23 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
+struct qgroup_shared_ref {
+	u64 parent;
+	u64 ref_root;
+	struct list_head list;
+};
+
+struct btrfs_qgroup_operation {
+	u64 ref_root;
+	u64 bytenr;
+	u64 num_bytes;
+	u64 seq;
+	enum btrfs_qgroup_operation_type type;
+	struct rb_node n;
+	struct list_head list;
+	struct list_head shared_refs;
+};
+
 static int
 qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 		   int init_flags);
@@ -1174,33 +1191,322 @@ out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
+static int comp_oper(struct btrfs_qgroup_operation *oper1,
+		     struct btrfs_qgroup_operation *oper2)
+{
+	if (oper1->bytenr < oper2->bytenr)
+		return -1;
+	if (oper1->bytenr > oper2->bytenr)
+		return 1;
+	if (oper1->seq < oper2->seq)
+		return -1;
+	if (oper1->seq > oper2->seq)
+		return -1;
+	if (oper1->ref_root < oper2->ref_root)
+		return -1;
+	if (oper1->ref_root > oper2->ref_root)
+		return 1;
+	if (oper1->type < oper2->type)
+		return -1;
+	if (oper1->type > oper2->type)
+		return 1;
+	return 0;
+}
+
+/* Looks up the first operation for the given bytenr. */
+static struct btrfs_qgroup_operation *
+lookup_first_oper(struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct rb_node *n;
+	struct btrfs_qgroup_operation *oper, *prev = NULL;
+
+	spin_lock(&fs_info->qgroup_op_lock);
+	n = fs_info->qgroup_op_tree.rb_node;
+	while (n) {
+		oper = rb_entry(n, struct btrfs_qgroup_operation, n);
+		if (oper->bytenr < bytenr) {
+			n = n->rb_right;
+		} else if (oper->bytenr > bytenr) {
+			n = n->rb_left;
+		} else {
+			prev = oper;
+			n = n->rb_left;
+		}
+	}
+	spin_unlock(&fs_info->qgroup_op_lock);
+	return prev;
+}
+
+static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
+			      struct btrfs_qgroup_operation *oper)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct btrfs_qgroup_operation *cur;
+	int cmp;
+
+	spin_lock(&fs_info->qgroup_op_lock);
+	p = &fs_info->qgroup_op_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		cur = rb_entry(parent, struct btrfs_qgroup_operation, n);
+		cmp = comp_oper(cur, oper);
+		if (cmp < 0) {
+			p = &(*p)->rb_right;
+		} else if (cmp) {
+			p = &(*p)->rb_left;
+		} else {
+			spin_unlock(&fs_info->qgroup_op_lock);
+			return -EEXIST;
+		}
+	}
+	rb_link_node(&oper->n, parent, p);
+	rb_insert_color(&oper->n, &fs_info->qgroup_op_tree);
+	spin_unlock(&fs_info->qgroup_op_lock);
+	return 0;
+}
 
 /*
- * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
- * the modification into a list that's later used by btrfs_end_transaction to
- * pass the recorded modifications on to btrfs_qgroup_account_ref.
+ * Record a quota operation for processing later on.
+ * @trans: the transaction we are adding the delayed op to.
+ * @fs_info: the fs_info for this fs.
+ * @ref_root: the root of the reference we are acting on,
+ * @num_bytes: the number of bytes in the reference.
+ * @parent: if we are removing a shared ref then this will be set.
+ * @type: the type of operation this is.
+ *
+ * We just add it to our trans qgroup_ref_list and carry on and process these
+ * operations in order at some later point.  If the reference root isn't a fs
+ * root then we don't bother with doing anything.
+ *
+ * MUST BE HOLDING THE REF LOCK.
  */
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_delayed_ref_node *node,
-			    struct btrfs_delayed_extent_op *extent_op)
+			    struct btrfs_fs_info *fs_info, u64 ref_root,
+			    u64 bytenr, u64 num_bytes, u64 parent,
+			    enum btrfs_qgroup_operation_type type)
 {
-	struct qgroup_update *u;
+	struct btrfs_qgroup_operation *oper;
+	int ret;
 
-	BUG_ON(!trans->delayed_ref_elem.seq);
-	u = kmalloc(sizeof(*u), GFP_NOFS);
-	if (!u)
+	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
+		return 0;
+
+	oper = kmalloc(sizeof(*oper), GFP_NOFS);
+	if (!oper)
 		return -ENOMEM;
 
-	u->node = node;
-	u->extent_op = extent_op;
-	list_add_tail(&u->list, &trans->qgroup_ref_list);
+	oper->ref_root = ref_root;
+	oper->bytenr = bytenr;
+	oper->num_bytes = num_bytes;
+	oper->type = type;
+	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
+	INIT_LIST_HEAD(&oper->shared_refs);
+	ret = insert_qgroup_oper(fs_info, oper);
+	if (ret) {
+		/* Shouldn't happen so have an assert for developers */
+		ASSERT(0);
+		kfree(oper);
+		return ret;
+	}
+	list_add_tail(&oper->list, &trans->qgroup_ref_list);
 
+	/*
+	 * If we are removing a shared extent ref we could possibly have another
+	 * operation outstanding that needs to lookup this shared ref, so we
+	 * need to go and look if there exists such a person and update their
+	 * shared ref dependancy with the root ref so it knows if it needs to do
+	 * anything.  We are relying on the ref lock to protect the actual
+	 * operation here.
+	 */
+	if (unlikely(parent) && (type == BTRFS_QGROUP_OPER_SUB_EXCL ||
+				 type == BTRFS_QGROUP_OPER_SUB_SHARED)) {
+		u64 seq = oper->seq;
+		struct qgroup_shared_ref *ref;
+		struct rb_node *n;
+
+		oper = lookup_first_oper(fs_info, bytenr);
+		if (!oper)
+			return 0;
+		do {
+			list_for_each_entry(ref, &oper->shared_refs, list) {
+				if (ref->parent == parent)
+					ref->ref_root = ref_root;
+			}
+			spin_lock(&fs_info->qgroup_op_lock);
+			n = rb_next(&oper->n);
+			if (n) {
+				oper = rb_entry(n,
+						struct btrfs_qgroup_operation,
+						n);
+				if (oper->bytenr != bytenr || oper->seq >= seq)
+					n = NULL;
+			}
+			spin_unlock(&fs_info->qgroup_op_lock);
+		} while (n);
+	}
 	return 0;
 }
 
-static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
-				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq)
+/*
+ * Remove the last qgroup operation that was added.
+ * @trans: the trans handle.
+ * @fs_info: the fs_info for this file system.
+ * @ref_root: the root for the reference.
+ *
+ * Sometimes we may pre-emptively add an operation only to find after further
+ * investigation that we no longer need it, so this will pop the last guy off
+ * the list and free him up.
+ */
+void btrfs_remove_last_qgroup_operation(struct btrfs_trans_handle *trans,
+					struct btrfs_fs_info *fs_info,
+					u64 ref_root)
+{
+	struct btrfs_qgroup_operation *oper;
+
+	if (!is_fstree(ref_root))
+		return;
+
+	oper = list_entry(trans->qgroup_ref_list.prev,
+			  struct btrfs_qgroup_operation, list);
+	ASSERT(oper->ref_root == ref_root);
+	list_del_init(&oper->list);
+	while (!list_empty(&oper->shared_refs)) {
+		struct qgroup_shared_ref *ref;
+		ref = list_first_entry(&oper->shared_refs,
+				       struct qgroup_shared_ref, list);
+		list_del_init(&ref->list);
+		kfree(ref);
+	}
+	spin_lock(&fs_info->qgroup_op_lock);
+	rb_erase(&oper->n, &fs_info->qgroup_op_tree);
+	spin_unlock(&fs_info->qgroup_op_lock);
+	kfree(oper);
+}
+
+/*
+ * Record a shared ref in the most recent qgroup operation added.
+ * @trans: the trans handle for this operation.
+ * @ref_root: the ref_root this operation was for, this is to make sure we
+ * actually need to do anything at all.  Use the same ref_root we called
+ * btrfs_qgroup_record_ref with.
+ * @parent: the parent of the shared ref.
+ *
+ * This is meant to be called directly after calling btrfs_qgroup_record_ref
+ * for the ref we care about, it does no searching to make sure we're on the
+ * right qgroup operation.
+ *
+ * MUST BE HOLDING THE REF LOCK.
+ */
+int btrfs_qgroup_add_shared_ref(struct btrfs_trans_handle *trans, u64 ref_root,
+				u64 parent)
+{
+	struct qgroup_shared_ref *ref;
+	struct btrfs_qgroup_operation *oper;
+	int ret = 0;
+
+	if (!is_fstree(ref_root))
+		return 0;
+	ref = kmalloc(sizeof(*ref), GFP_NOFS);
+	if (!ref)
+		return -ENOMEM;
+	ref->parent = parent;
+	ref->ref_root = 0;
+	ASSERT(!list_empty(&trans->qgroup_ref_list));
+	oper = list_entry(trans->qgroup_ref_list.prev,
+			  struct btrfs_qgroup_operation, list);
+	list_add_tail(&ref->list, &oper->shared_refs);
+	return ret;
+}
+
+/*
+ * The easy accounting, if we are adding/removing the only ref for an extent
+ * then this qgroup and all of the parent qgroups get their refrence and
+ * exclusive counts adjusted.
+ */
+static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
+				  struct btrfs_qgroup_operation *oper)
+{
+	struct btrfs_qgroup *qgroup;
+	struct ulist *tmp;
+	struct btrfs_qgroup_list *glist;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	int sign = 0;
+	int ret = 0;
+
+	tmp = ulist_alloc(GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
+
+	spin_lock(&fs_info->qgroup_lock);
+	if (!fs_info->quota_root)
+		goto out;
+	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
+	if (!qgroup)
+		goto out;
+	switch (oper->type) {
+	case BTRFS_QGROUP_OPER_ADD_EXCL:
+		sign = 1;
+		break;
+	case BTRFS_QGROUP_OPER_SUB_EXCL:
+		sign = -1;
+		break;
+	default:
+		ASSERT(0);
+	}
+	qgroup->rfer += sign * oper->num_bytes;
+	qgroup->rfer_cmpr += sign * oper->num_bytes;
+
+	WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);
+	qgroup->excl += sign * oper->num_bytes;
+	qgroup->excl_cmpr += sign * oper->num_bytes;
+
+	qgroup_dirty(fs_info, qgroup);
+
+	/* Get all of the parent groups that contain this qgroup */
+	list_for_each_entry(glist, &qgroup->groups, next_group) {
+		ret = ulist_add(tmp, glist->group->qgroupid, (u64)glist->group,
+				GFP_ATOMIC);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Iterate all of the parents and adjust their reference counts */
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(tmp, &uiter))) {
+		qgroup = (struct btrfs_qgroup *)unode->aux;
+		qgroup->rfer += sign * oper->num_bytes;
+		qgroup->rfer_cmpr += sign * oper->num_bytes;
+		qgroup->excl += sign * oper->num_bytes;
+		if (sign < 0)
+			WARN_ON(qgroup->excl < oper->num_bytes);
+		qgroup->excl_cmpr += sign * oper->num_bytes;
+		qgroup_dirty(fs_info, qgroup);
+
+		/* Add any parents of the parents */
+		list_for_each_entry(glist, &qgroup->groups, next_group) {
+			ret = ulist_add(tmp, glist->group->qgroupid,
+					(u64)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto out;
+		}
+	}
+	ret = 0;
+out:
+	spin_unlock(&fs_info->qgroup_lock);
+	ulist_free(tmp);
+	return ret;
+}
+
+/*
+ * Walk all of the roots that pointed to our bytenr and adjust their refcnts as
+ * properly.
+ */
+static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
+				  u64 root_to_skip, struct ulist *roots,
+				  struct ulist *qgroups, u64 seq,
+				  int *old_roots, int rescan)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -1211,256 +1517,557 @@ static int qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(roots, &uiter))) {
+		/* We don't count our current root here */
+		if (unode->val == root_to_skip)
+			continue;
 		qg = find_qgroup_rb(fs_info, unode->val);
 		if (!qg)
 			continue;
+		/*
+		 * We could have a pending removal of this same ref so we may
+		 * not have actually found our ref root when doing
+		 * btrfs_find_all_roots, so we need to keep track of how many
+		 * old roots we find in case we removed ours and added a
+		 * different one at the same time.  I don't think this could
+		 * happen in practice but that sort of thinking leads to pain
+		 * and suffering and to the dark side.
+		 */
+		(*old_roots)++;
 
-		ulist_reinit(tmp);
-						/* XXX id not needed */
-		ret = ulist_add(tmp, qg->qgroupid,
-				(u64)(uintptr_t)qg, GFP_ATOMIC);
+		ulist_reinit(qgroups);
+		ret = ulist_add(qgroups, qg->qgroupid, (u64)qg, GFP_ATOMIC);
 		if (ret < 0)
 			return ret;
 		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+		while ((tmp_unode = ulist_next(qgroups, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
 
-			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->refcnt < seq)
-				qg->refcnt = seq + 1;
+			qg = (struct btrfs_qgroup *)tmp_unode->aux;
+			/*
+			 * We use this sequence number to keep from having to
+			 * run the whole list and 0 out the refcnt every time.
+			 * We basically use sequnce as the known 0 count and
+			 * then add 1 everytime we see a qgroup.  This is how we
+			 * get how many of the roots actually point up to the
+			 * upper level qgroups in order to determine exclusive
+			 * counts.
+			 *
+			 * For rescan we want to set old_refcnt to seq so our
+			 * exclusive calculations end up correct.
+			 */
+			if (rescan)
+				qg->old_refcnt = seq;
+			else if (qg->old_refcnt < seq)
+				qg->old_refcnt = seq + 1;
 			else
-				++qg->refcnt;
+				qg->old_refcnt++;
 
+			if (qg->new_refcnt < seq)
+				qg->new_refcnt = seq + 1;
+			else
+				qg->new_refcnt++;
 			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(u64)(uintptr_t)glist->group,
-						GFP_ATOMIC);
+				ret = ulist_add(qgroups, glist->group->qgroupid,
+						(u64)glist->group, GFP_ATOMIC);
 				if (ret < 0)
 					return ret;
 			}
 		}
 	}
+	return 0;
+}
+
+/*
+ * We need to walk forward in our operation tree and account for any roots that
+ * were deleted after we made this operation.
+ */
+static int qgroup_account_deleted_refs(struct btrfs_fs_info *fs_info,
+				       struct btrfs_qgroup_operation *oper,
+				       struct ulist *qgroups, u64 seq,
+				       int *old_roots)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct btrfs_qgroup *qg;
+	struct btrfs_qgroup_operation *tmp;
+	struct rb_node *n;
+	int ret;
+
+	ulist_reinit(qgroups);
+
+	/*
+	 * We only walk forward in the tree since we're only interested in
+	 * removals that happened _after_  our operation.
+	 */
+	spin_lock(&fs_info->qgroup_op_lock);
+	n = rb_next(&oper->n);
+	spin_unlock(&fs_info->qgroup_op_lock);
+	if (!n)
+		return 0;
+	tmp = rb_entry(n, struct btrfs_qgroup_operation, n);
+	while (tmp->bytenr == oper->bytenr) {
+		/*
+		 * If it's not a removal we don't care, additions work out
+		 * properly with our refcnt tracking.
+		 */
+		if (tmp->type != BTRFS_QGROUP_OPER_SUB_SHARED &&
+		    tmp->type != BTRFS_QGROUP_OPER_SUB_EXCL)
+			goto next;
+		qg = find_qgroup_rb(fs_info, oper->ref_root);
+		if (!qg)
+			goto next;
+		ret = ulist_add(qgroups, qg->qgroupid, (u64)qg, GFP_ATOMIC);
+		if (ret)
+			return ret;
+		(*old_roots)++;
+next:
+		spin_lock(&fs_info->qgroup_op_lock);
+		n = rb_next(&tmp->n);
+		spin_unlock(&fs_info->qgroup_op_lock);
+		if (!n)
+			break;
+		tmp = rb_entry(n, struct btrfs_qgroup_operation, n);
+	}
+
+	/* Ok now process the qgroups we found */
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(qgroups, &uiter))) {
+		struct btrfs_qgroup_list *glist;
 
+		qg = (struct btrfs_qgroup *)unode->aux;
+		if (qg->old_refcnt < seq)
+			qg->old_refcnt = seq + 1;
+		else
+			qg->old_refcnt++;
+		if (qg->new_refcnt < seq)
+			qg->new_refcnt = seq + 1;
+		else
+			qg->new_refcnt++;
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(qgroups, glist->group->qgroupid,
+					(u64)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				return ret;
+		}
+	}
 	return 0;
 }
 
-static int qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
-				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq, int sgn, u64 num_bytes,
-				    struct btrfs_qgroup *qgroup)
+/* Add refcnt for the newly added reference. */
+static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
+				  struct btrfs_qgroup_operation *oper,
+				  struct btrfs_qgroup *qgroup,
+				  struct ulist *roots, struct ulist *qgroups,
+				  u64 seq)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup *qg;
-	struct btrfs_qgroup_list *glist;
 	int ret;
 
-	ulist_reinit(tmp);
-	ret = ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
+	ulist_reinit(qgroups);
+	ret = ulist_add(qgroups, qgroup->qgroupid, (u64)qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		return ret;
-
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(tmp, &uiter))) {
-		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
-		if (qg->refcnt < seq) {
-			/* not visited by step 1 */
-			qg->rfer += sgn * num_bytes;
-			qg->rfer_cmpr += sgn * num_bytes;
-			if (roots->nnodes == 0) {
-				qg->excl += sgn * num_bytes;
-				qg->excl_cmpr += sgn * num_bytes;
-			}
-			qgroup_dirty(fs_info, qg);
-		}
-		WARN_ON(qg->tag >= seq);
-		qg->tag = seq;
+	while ((unode = ulist_next(qgroups, &uiter))) {
+		struct btrfs_qgroup_list *glist;
 
+		qg = (struct btrfs_qgroup *)unode->aux;
+		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
+			if (qg->new_refcnt < seq)
+				qg->new_refcnt = seq + 1;
+			else
+				qg->new_refcnt++;
+		} else {
+			if (qg->old_refcnt < seq)
+				qg->old_refcnt = seq + 1;
+			else
+				qg->old_refcnt++;
+		}
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(tmp, glist->group->qgroupid,
-					(uintptr_t)glist->group, GFP_ATOMIC);
+			ret = ulist_add(qgroups, glist->group->qgroupid,
+					(u64)glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				return ret;
 		}
 	}
-
 	return 0;
 }
 
-static int qgroup_account_ref_step3(struct btrfs_fs_info *fs_info,
-				    struct ulist *roots, struct ulist *tmp,
-				    u64 seq, int sgn, u64 num_bytes)
+/*
+ * This adjusts the counters for all referenced qgroups if need be.
+ */
+static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
+				  u64 root_to_skip, u64 num_bytes,
+				  struct ulist *roots, struct ulist *qgroups,
+				  u64 seq, int old_roots, int new_roots, int rescan)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct btrfs_qgroup *qg;
-	struct ulist_node *tmp_unode;
-	struct ulist_iterator tmp_uiter;
+	u64 cur_new_count, cur_old_count;
 	int ret;
 
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(roots, &uiter))) {
+		struct btrfs_qgroup_list *glist;
+
+		if (unode->val == root_to_skip)
+			continue;
 		qg = find_qgroup_rb(fs_info, unode->val);
 		if (!qg)
 			continue;
 
-		ulist_reinit(tmp);
-		ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
+		ret = ulist_add(qgroups, qg->qgroupid, (u64)qg, GFP_ATOMIC);
 		if (ret < 0)
 			return ret;
+		list_for_each_entry(glist, &qg->groups, next_group) {
+			ret = ulist_add(qgroups, glist->group->qgroupid,
+					(u64)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				return ret;
+		}
+	}
 
-		ULIST_ITER_INIT(&tmp_uiter);
-		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
-			struct btrfs_qgroup_list *glist;
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(qgroups, &uiter))) {
+		bool dirty = false;
 
-			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
-			if (qg->tag == seq)
-				continue;
+		qg = (struct btrfs_qgroup *)unode->aux;
+		/*
+		 * Wasn't referenced before but is now, add to the reference
+		 * counters.
+		 */
+		if (qg->old_refcnt <= seq && qg->new_refcnt > seq) {
+			qg->rfer += num_bytes;
+			qg->rfer_cmpr += num_bytes;
+			dirty = true;
+		}
 
-			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl -= sgn * num_bytes;
-				qg->excl_cmpr -= sgn * num_bytes;
-				qgroup_dirty(fs_info, qg);
-			}
+		/*
+		 * Was referenced before but isn't now, subtract from the
+		 * reference counters.
+		 */
+		if (qg->old_refcnt > seq && qg->new_refcnt <= seq) {
+			qg->rfer -= num_bytes;
+			qg->rfer_cmpr -= num_bytes;
+			dirty = true;
+		}
 
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0)
-					return ret;
-			}
+		cur_old_count = qg->old_refcnt - seq;
+		cur_new_count = qg->new_refcnt - seq;
+
+		/*
+		 * If our refcount was the same as the roots previously but our
+		 * new count isn't the same as the number of roots now then we
+		 * went from having a exclusive reference on this range to not.
+		 */
+		if (old_roots && cur_old_count == old_roots &&
+		    cur_new_count != new_roots) {
+			qg->excl -= num_bytes;
+			qg->excl_cmpr -= num_bytes;
+			dirty = true;
 		}
-	}
 
+		/*
+		 * If we didn't reference all the roots before but now we do we
+		 * have an exclusive reference to this range.
+		 */
+		if ((!old_roots || (old_roots && cur_old_count != old_roots))
+		    && cur_new_count == new_roots) {
+			qg->excl += num_bytes;
+			qg->excl_cmpr += num_bytes;
+			dirty = true;
+		}
+
+		if (dirty)
+			qgroup_dirty(fs_info, qg);
+	}
 	return 0;
 }
 
 /*
- * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
- * from the fs. First, all roots referencing the extent are searched, and
- * then the space is accounted accordingly to the different roots. The
- * accounting algorithm works in 3 steps documented inline.
+ * If we added or removed a reference for a root and there were shared refs
+ * remaining then we need to go through and see if any of those refs lead back
+ * to our same root and if so we don't need to do anything with this operation.
  */
-int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
-			     struct btrfs_delayed_ref_node *node,
-			     struct btrfs_delayed_extent_op *extent_op)
+static int check_shared_refs(struct btrfs_fs_info *fs_info,
+			     struct btrfs_qgroup_operation *oper)
 {
-	struct btrfs_root *quota_root;
-	u64 ref_root;
-	struct btrfs_qgroup *qgroup;
 	struct ulist *roots = NULL;
-	u64 seq;
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct qgroup_shared_ref *ref;
 	int ret = 0;
-	int sgn;
 
-	if (!fs_info->quota_enabled)
-		return 0;
+	/* Now process all of our shared ref dependancies */
+	while (!list_empty(&oper->shared_refs)) {
+		ref = list_first_entry(&oper->shared_refs,
+				       struct qgroup_shared_ref, list);
+		if (ret) {
+			list_del_init(&ref->list);
+			kfree(ref);
+			continue;
+		}
+		if (ref->ref_root) {
+			if (ref->ref_root == oper->ref_root)
+				ret = 1;
+			goto next;
+		}
 
-	BUG_ON(!fs_info->quota_root);
+		ret = btrfs_find_all_roots(NULL, fs_info, ref->parent, 0,
+					   &roots, 0);
+		if (ret < 0)
+			goto next;
 
-	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
-		struct btrfs_delayed_tree_ref *ref;
-		ref = btrfs_delayed_node_to_tree_ref(node);
-		ref_root = ref->root;
-	} else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		   node->type == BTRFS_SHARED_DATA_REF_KEY) {
-		struct btrfs_delayed_data_ref *ref;
-		ref = btrfs_delayed_node_to_data_ref(node);
-		ref_root = ref->root;
-	} else {
-		BUG();
+		ULIST_ITER_INIT(&uiter);
+		while ((unode = ulist_next(roots, &uiter))) {
+			if (unode->val == oper->ref_root) {
+				ret = 1;
+				break;
+			}
+		}
+		ulist_free(roots);
+		roots = NULL;
+next:
+		list_del_init(&ref->list);
+		kfree(ref);
 	}
 
-	if (!is_fstree(ref_root)) {
-		/*
-		 * non-fs-trees are not being accounted
-		 */
-		return 0;
-	}
+	return ret;
+}
 
-	switch (node->action) {
-	case BTRFS_ADD_DELAYED_REF:
-	case BTRFS_ADD_DELAYED_EXTENT:
-		sgn = 1;
-		seq = btrfs_tree_mod_seq_prev(node->seq);
-		break;
-	case BTRFS_DROP_DELAYED_REF:
-		sgn = -1;
-		seq = node->seq;
-		break;
-	case BTRFS_UPDATE_DELAYED_HEAD:
-		return 0;
-	default:
-		BUG();
-	}
+/*
+ * If we share a reference across multiple roots then we may need to adjust
+ * various qgroups referenced and exclusive counters.  The basic premise is this
+ *
+ * 1) We have seq to represent a 0 count.  Instead of looping through all of the
+ * qgroups and resetting their refcount to 0 we just constantly bump this
+ * sequence number to act as the base reference count.  This means that if
+ * anybody is equal to or below this sequence they were never referenced.  We
+ * jack this sequence up by the number of roots we found each time in order to
+ * make sure we don't have any overlap.
+ *
+ * 2) We first search all the roots that reference the area _except_ the root
+ * we're acting on currently.  This makes up the old_refcnt of all the qgroups
+ * before.
+ *
+ * 3) We walk all of the qgroups referenced by the root we are currently acting
+ * on, and will either adjust old_refcnt in the case of a removal or the
+ * new_refcnt in the case of an addition.
+ *
+ * 4) Finally we walk all the qgroups that are referenced by this range
+ * including the root we are acting on currently.  We will adjust the counters
+ * based on the number of roots we had and will have after this operation.
+ *
+ * Take this example as an illustration
+ *
+ *			[qgroup 1/0]
+ *		     /         |          \
+ *		[qg 0/0]   [qg 0/1]	[qg 0/2]
+ *		   \          |            /
+ *		  [	   extent	    ]
+ *
+ * Say we are adding a reference that is covered by qg 0/0.  The first step
+ * would give a refcnt of 1 to qg 0/1 and 0/2 and a refcnt of 2 to qg 1/0 with
+ * old_roots being 2.  Because it is adding new_roots will be 1.  We then go
+ * through qg 0/0 which will get the new_refcnt set to 1 and add 1 to qg 1/0's
+ * new_refcnt, bringing it to 3.  We then walk through all of the qgroups, we
+ * notice that the old refcnt for qg 0/0 < the new refcnt, so we added a
+ * reference and thus must add the size to the referenced bytes.  Everything
+ * else is the same so nothing else changes.
+ */
+static int qgroup_shared_accounting(struct btrfs_fs_info *fs_info,
+				    struct btrfs_qgroup_operation *oper)
+{
+	struct ulist *roots = NULL;
+	struct ulist *qgroups;
+	struct btrfs_qgroup *qgroup;
+	u64 seq;
+	int old_roots = 0;
+	int new_roots = 0;
+	int ret = 0;
 
-	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
-		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
-			mutex_unlock(&fs_info->qgroup_rescan_lock);
+	if (unlikely(!list_empty(&oper->shared_refs))) {
+		ret = check_shared_refs(fs_info, oper);
+		if (ret < 0)
+			return ret;
+		if (ret)
 			return 0;
-		}
 	}
-	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	/*
-	 * the delayed ref sequence number we pass depends on the direction of
-	 * the operation. for add operations, we pass
-	 * tree_mod_log_prev_seq(node->seq) to skip
-	 * the delayed ref's current sequence number, because we need the state
-	 * of the tree before the add operation. for delete operations, we pass
-	 * (node->seq) to include the delayed ref's current sequence number,
-	 * because we need the state of the tree after the delete operation.
-	 */
-	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr, seq, &roots);
-	if (ret < 0)
-		return ret;
+	qgroups = ulist_alloc(GFP_NOFS);
+	if (!qgroups)
+		return -ENOMEM;
 
+	ret = btrfs_find_all_roots(NULL, fs_info, oper->bytenr, 0, &roots, 0);
+	if (ret < 0) {
+		ulist_free(qgroups);
+		return ret;
+	}
 	spin_lock(&fs_info->qgroup_lock);
-
-	quota_root = fs_info->quota_root;
-	if (!quota_root)
-		goto unlock;
-
-	qgroup = find_qgroup_rb(fs_info, ref_root);
+	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
-		goto unlock;
+		goto out;
+	seq = fs_info->qgroup_seq;
 
 	/*
-	 * step 1: for each old ref, visit all nodes once and inc refcnt
+	 * So roots is the list of all the roots currently pointing at the
+	 * bytenr, including the ref we are adding if we are adding, or not if
+	 * we are removing a ref.  So we pass in the ref_root to skip that root
+	 * in our calculations.  We set old_refnct and new_refcnt cause who the
+	 * hell knows what everything looked like before, and it doesn't matter
+	 * except...
 	 */
-	ulist_reinit(fs_info->qgroup_ulist);
-	seq = fs_info->qgroup_seq;
-	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
+	ret = qgroup_calc_old_refcnt(fs_info, oper->ref_root, roots, qgroups,
+				     seq, &old_roots, 0);
+	if (ret < 0)
+		goto out;
 
-	ret = qgroup_account_ref_step1(fs_info, roots, fs_info->qgroup_ulist,
-				       seq);
-	if (ret)
-		goto unlock;
+	/*
+	 * ...in the case of removals.  If we had a removal before we got around
+	 * to processing this operation then we need to find that guy and count
+	 * his references as if they really existed so we don't end up screwing
+	 * up the exclusive counts.  Then whenever we go to process the delete
+	 * everything will be grand and we can account for whatever exclusive
+	 * changes need to be made there.  We also have to pass in old_roots so
+	 * we have an accurate count of the roots as it pertains to this
+	 * operations view of the world.
+	 */
+	ret = qgroup_account_deleted_refs(fs_info, oper, qgroups, seq,
+					  &old_roots);
+	if (ret < 0)
+		goto out;
 
 	/*
-	 * step 2: walk from the new root
+	 * We are adding our root, need to adjust up the number of roots,
+	 * otherwise old_roots is the number of roots we want.
 	 */
-	ret = qgroup_account_ref_step2(fs_info, roots, fs_info->qgroup_ulist,
-				       seq, sgn, node->num_bytes, qgroup);
-	if (ret)
-		goto unlock;
+	if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
+		new_roots = old_roots + 1;
+	} else {
+		new_roots = old_roots;
+		old_roots++;
+	}
+	fs_info->qgroup_seq += old_roots + 1;
 
 	/*
-	 * step 3: walk again from old refs
+	 * Now adjust the refcounts of the qgroups that care about this
+	 * reference, either the old_count in the case of removal or new_count
+	 * in the case of an addition.
 	 */
-	ret = qgroup_account_ref_step3(fs_info, roots, fs_info->qgroup_ulist,
-				       seq, sgn, node->num_bytes);
-	if (ret)
-		goto unlock;
+	ret = qgroup_calc_new_refcnt(fs_info, oper, qgroup, roots, qgroups,
+				     seq);
+	if (ret < 0)
+		goto out;
 
-unlock:
+	/* We are doing this in case we have a pending delete */
+	ulist_reinit(qgroups);
+	ret = ulist_add(qgroups, qgroup->qgroupid, (u64)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+
+	/*
+	 * And now the magic happens, bless Arne for having a pretty elegant
+	 * solution for this.
+	 */
+	qgroup_adjust_counters(fs_info, oper->ref_root, oper->num_bytes,
+			       roots, qgroups, seq, old_roots, new_roots, 0);
+out:
 	spin_unlock(&fs_info->qgroup_lock);
+	ulist_free(qgroups);
 	ulist_free(roots);
+	return ret;
+}
+
+/*
+ * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
+ * from the fs. First, all roots referencing the extent are searched, and
+ * then the space is accounted accordingly to the different roots. The
+ * accounting algorithm works in 3 steps documented inline.
+ */
+static int btrfs_qgroup_account(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info,
+				struct btrfs_qgroup_operation *oper)
+{
+	struct btrfs_block_group_cache *cache;
+	struct extent_state *cached_state = NULL;
+	int ret = 0;
+	int err;
+
+	if (!fs_info->quota_enabled)
+		return 0;
+
+	BUG_ON(!fs_info->quota_root);
+
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
+		if (fs_info->qgroup_rescan_progress.objectid <= oper->bytenr) {
+			mutex_unlock(&fs_info->qgroup_rescan_lock);
+			return 0;
+		}
+	}
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
+	ASSERT(is_fstree(oper->ref_root));
+
+	ret = lock_ref(fs_info, oper->ref_root, oper->bytenr, oper->num_bytes,
+		       &cache, &cached_state);
+	if (ret)
+		return ret;
+
+	switch (oper->type) {
+	case BTRFS_QGROUP_OPER_ADD_EXCL:
+	case BTRFS_QGROUP_OPER_SUB_EXCL:
+		ret = qgroup_excl_accounting(fs_info, oper);
+		break;
+	case BTRFS_QGROUP_OPER_ADD_SHARED:
+	case BTRFS_QGROUP_OPER_SUB_SHARED:
+		ret = qgroup_shared_accounting(fs_info, oper);
+		break;
+	default:
+		ASSERT(0);
+	}
+	err = unlock_ref(fs_info, oper->ref_root, oper->bytenr,
+			 oper->num_bytes, cache, &cached_state);
+	return ret ? ret : err;
+}
+
+/*
+ * Needs to be called everytime we run delayed refs, even if there is an error
+ * in order to cleanup outstanding operations.
+ */
+int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
+				    struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_qgroup_operation *oper;
+	struct qgroup_shared_ref *ref;
+	int ret = 0;
 
+	while (!list_empty(&trans->qgroup_ref_list)) {
+		oper = list_first_entry(&trans->qgroup_ref_list,
+					struct btrfs_qgroup_operation, list);
+		list_del_init(&oper->list);
+		if (!ret || !trans->aborted)
+			ret = btrfs_qgroup_account(trans, fs_info, oper);
+		/*
+		 * If there was an error we could have things still on our
+		 * shared refs list.
+		 */
+		while (!list_empty(&oper->shared_refs)) {
+			ASSERT(ret || trans->aborted);
+			ref = list_first_entry(&oper->shared_refs,
+					       struct qgroup_shared_ref, list);
+			list_del_init(&ref->list);
+			kfree(ref);
+		}
+		spin_lock(&fs_info->qgroup_op_lock);
+		rb_erase(&oper->n, &fs_info->qgroup_op_tree);
+		spin_unlock(&fs_info->qgroup_op_lock);
+		kfree(oper);
+	}
 	return ret;
 }
 
@@ -1629,8 +2236,16 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		srcgroup = find_qgroup_rb(fs_info, srcid);
 		if (!srcgroup)
 			goto unlock;
-		dstgroup->rfer = srcgroup->rfer - level_size;
-		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr - level_size;
+
+		/*
+		 * We call inherit after we clone the root in order to make sure
+		 * our counts don't go crazy, so at this point the only
+		 * difference between the two roots should be the root node.
+		 */
+		dstgroup->rfer = srcgroup->rfer;
+		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr;
+		dstgroup->excl = level_size;
+		dstgroup->excl_cmpr = level_size;
 		srcgroup->excl = level_size;
 		srcgroup->excl_cmpr = level_size;
 		qgroup_dirty(fs_info, dstgroup);
@@ -1850,11 +2465,13 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		   struct extent_buffer *scratch_leaf)
 {
 	struct btrfs_key found;
+	struct btrfs_block_group_cache *cache;
+	struct extent_state *cached_state = NULL;
 	struct ulist *roots = NULL;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
 	struct seq_list tree_mod_seq_elem = {};
+	u64 num_bytes;
 	u64 seq;
+	int new_roots;
 	int slot;
 	int ret;
 
@@ -1896,78 +2513,68 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 
 	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
 		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
-		if (found.type != BTRFS_EXTENT_ITEM_KEY)
+		if (found.type != BTRFS_EXTENT_ITEM_KEY &&
+		    found.type != BTRFS_METADATA_ITEM_KEY)
 			continue;
-		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
-					   tree_mod_seq_elem.seq, &roots);
-		if (ret < 0)
+
+		if (found.type == BTRFS_METADATA_ITEM_KEY)
+			num_bytes = fs_info->extent_root->leafsize;
+		else
+			num_bytes = found.offset;
+
+		/*
+		 * lock_ref checks to make sure we really need to lock by
+		 * checking the ref root root we are modifying the ref for, so
+		 * just use the fs tree objectid.
+		 */
+		ret = lock_ref(fs_info, BTRFS_FS_TREE_OBJECTID, found.objectid,
+			       num_bytes, &cache, &cached_state);
+		if (ret)
 			goto out;
+		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
+					   &roots, 0);
+		if (ret < 0) {
+			unlock_ref(fs_info, BTRFS_FS_TREE_OBJECTID,
+				   found.objectid, num_bytes, cache,
+				   &cached_state);
+			goto out;
+		}
 		spin_lock(&fs_info->qgroup_lock);
 		seq = fs_info->qgroup_seq;
-		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
+		fs_info->qgroup_seq += roots->nnodes + 1;
 
-		ret = qgroup_account_ref_step1(fs_info, roots, tmp, seq);
-		if (ret) {
+		ulist_reinit(tmp);
+		new_roots = 0;
+		ret = qgroup_calc_old_refcnt(fs_info, 0, roots, tmp, seq,
+					     &new_roots, 1);
+		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
 			ulist_free(roots);
+			unlock_ref(fs_info, BTRFS_FS_TREE_OBJECTID,
+				   found.objectid, num_bytes, cache,
+				   &cached_state);
 			goto out;
 		}
 
-		/*
-		 * step2 of btrfs_qgroup_account_ref works from a single root,
-		 * we're doing all at once here.
-		 */
 		ulist_reinit(tmp);
-		ULIST_ITER_INIT(&uiter);
-		while ((unode = ulist_next(roots, &uiter))) {
-			struct btrfs_qgroup *qg;
-
-			qg = find_qgroup_rb(fs_info, unode->val);
-			if (!qg)
-				continue;
-
-			ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg,
-					GFP_ATOMIC);
-			if (ret < 0) {
-				spin_unlock(&fs_info->qgroup_lock);
-				ulist_free(roots);
-				goto out;
-			}
-		}
-
-		/* this loop is similar to step 2 of btrfs_qgroup_account_ref */
-		ULIST_ITER_INIT(&uiter);
-		while ((unode = ulist_next(tmp, &uiter))) {
-			struct btrfs_qgroup *qg;
-			struct btrfs_qgroup_list *glist;
-
-			qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
-			qg->rfer += found.offset;
-			qg->rfer_cmpr += found.offset;
-			WARN_ON(qg->tag >= seq);
-			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl += found.offset;
-				qg->excl_cmpr += found.offset;
-			}
-			qgroup_dirty(fs_info, qg);
-
-			list_for_each_entry(glist, &qg->groups, next_group) {
-				ret = ulist_add(tmp, glist->group->qgroupid,
-						(uintptr_t)glist->group,
-						GFP_ATOMIC);
-				if (ret < 0) {
-					spin_unlock(&fs_info->qgroup_lock);
-					ulist_free(roots);
-					goto out;
-				}
-			}
+		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, roots, tmp,
+					     seq, 0, new_roots, 1);
+		if (ret < 0) {
+			spin_unlock(&fs_info->qgroup_lock);
+			ulist_free(roots);
+			unlock_ref(fs_info, BTRFS_FS_TREE_OBJECTID,
+				   found.objectid, num_bytes, cache,
+				   &cached_state);
+			goto out;
 		}
-
 		spin_unlock(&fs_info->qgroup_lock);
 		ulist_free(roots);
-		ret = 0;
+		ret = unlock_ref(fs_info, BTRFS_FS_TREE_OBJECTID,
+				 found.objectid, num_bytes, cache,
+				 &cached_state);
+		if (ret)
+			break;
 	}
-
 out:
 	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 026f1fe..503cb46 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -692,23 +692,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	/*
-	 * do the qgroup accounting as early as possible
-	 */
-	err = btrfs_delayed_refs_qgroup_accounting(trans, info);
-
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
-	if (trans->qgroup_reserved) {
-		/*
-		 * the same root has to be passed here between start_transaction
-		 * and end_transaction. Subvolume quota depends on this.
-		 */
-		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
-		trans->qgroup_reserved = 0;
-	}
-
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans, root);
 
@@ -719,6 +705,15 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		btrfs_run_delayed_refs(trans, root, cur);
 	}
 
+	if (trans->qgroup_reserved) {
+		/*
+		 * the same root has to be passed here between start_transaction
+		 * and end_transaction. Subvolume quota depends on this.
+		 */
+		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
+		trans->qgroup_reserved = 0;
+	}
+
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
@@ -1176,12 +1171,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 			goto no_free_objectid;
 	}
 
-	pending->error = btrfs_qgroup_inherit(trans, fs_info,
-					      root->root_key.objectid,
-					      objectid, pending->inherit);
-	if (pending->error)
-		goto no_free_objectid;
-
 	key.objectid = objectid;
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1278,6 +1267,22 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
+	/*
+	 * We need to flush delayed refs in order to make sure all of our quota
+	 * operations have been done before we call btrfs_qgroup_inherit.
+	 */
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
+
+	pending->error = btrfs_qgroup_inherit(trans, fs_info,
+					      root->root_key.objectid,
+					      objectid, pending->inherit);
+	if (pending->error)
+		goto no_free_objectid;
+
 	/* see comments in should_cow_block() */
 	root->force_cow = 1;
 	smp_wmb();
@@ -1607,12 +1612,6 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	 * them now so that they hinder processing of more delayed refs
 	 * as little as possible.
 	 */
-	if (ret) {
-		btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
-		return ret;
-	}
-
-	ret = btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
 	if (ret)
 		return ret;
 
-- 
1.8.3.1

