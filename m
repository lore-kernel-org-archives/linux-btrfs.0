Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13458 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882Ab3LRVHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:07:48 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBIL5nPF001374
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:48 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0b-00082601.pphosted.com with ESMTP id 1gu017k9p8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:48 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: introduce lock_ref/unlock_ref
Date: Wed, 18 Dec 2013 16:07:27 -0500
Message-ID: <1387400849-7274-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1387400849-7274-1-git-send-email-jbacik@fb.com>
References: <1387400849-7274-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

qgroups need to have a consistent view of the references for a particular extent
record.  Currently they do this through sequence numbers on delayed refs, but
this is no longer acceptable.  So instead introduce lock_ref/unlock_ref.  This
will provide the qgroup code with a consistent view of the reference while it
does its accounting calculations without interfering with the delayed ref code.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h       |  11 ++++++
 fs/btrfs/delayed-ref.c |   2 +
 fs/btrfs/delayed-ref.h |   1 +
 fs/btrfs/extent-tree.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a924274..8b3fd61 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1273,6 +1273,9 @@ struct btrfs_block_group_cache {
 
 	/* For delayed block group creation */
 	struct list_head new_bg_list;
+
+	/* For locking reference modifications */
+	struct extent_io_tree ref_lock;
 };
 
 /* delayed seq elem */
@@ -3319,6 +3322,14 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 int __get_raid_index(u64 flags);
+int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
+	     u64 num_bytes, int for_cow,
+	     struct btrfs_block_group_cache **block_group,
+	     struct extent_state **cached_state);
+int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
+	       u64 num_bytes, int for_cow,
+	       struct btrfs_block_group_cache *block_group,
+	       struct extent_state **cached_state);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index fab60c1..ee1c29d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -680,6 +680,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->action = action;
 	ref->is_head = 0;
 	ref->in_tree = 1;
+	ref->for_cow = for_cow;
 
 	if (need_ref_seq(for_cow, ref_root))
 		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
@@ -739,6 +740,7 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->action = action;
 	ref->is_head = 0;
 	ref->in_tree = 1;
+	ref->for_cow = for_cow;
 
 	if (need_ref_seq(for_cow, ref_root))
 		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a54c9d4..db71a37 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -52,6 +52,7 @@ struct btrfs_delayed_ref_node {
 
 	unsigned int action:8;
 	unsigned int type:8;
+	unsigned int for_cow:1;
 	/* is this node still in the rbtree? */
 	unsigned int is_head:1;
 	unsigned int in_tree:1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cd4d9ca..03b536c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -672,6 +672,79 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 	return cache;
 }
 
+
+/* This is used to lock the modification to an extent ref.  This only does
+ * something if the reference is a fs tree.
+ *
+ * @fs_info: the fs_info for this filesystem.
+ * @root_objectid: the root objectid that we are modifying for this extent.
+ * @bytenr: the byte we are modifying the reference for
+ * @num_bytes: the number of bytes we are locking.
+ * @for_cow: if this operation is for cow then we don't need to lock
+ * @block_group: we will store the block group we looked up so that the unlock
+ * doesn't have to do another search.
+ * @cached_state: this is for caching our location so when we unlock we don't
+ * have to do a tree search.
+ *
+ * This can return -ENOMEM if we cannot allocate our extent state.
+ */
+int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
+	     u64 num_bytes, int for_cow,
+	     struct btrfs_block_group_cache **block_group,
+	     struct extent_state **cached_state)
+{
+	struct btrfs_block_group_cache *cache;
+	int ret;
+
+	if (!fs_info->quota_enabled || !need_ref_seq(for_cow, root_objectid))
+		return 0;
+
+	cache = btrfs_lookup_block_group(fs_info, bytenr);
+	ASSERT(cache);
+	ASSERT(cache->key.objectid <= bytenr &&
+	       (cache->key.objectid + cache->key.offset >=
+		bytenr + num_bytes));
+	ret = lock_extent_bits(&cache->ref_lock, bytenr,
+			       bytenr + num_bytes - 1, 0, cached_state);
+	if (!ret)
+		*block_group = cache;
+	else
+		btrfs_put_block_group(cache);
+	return ret;
+}
+
+/*
+ * Unlock the extent ref, this only does something if the reference is for an fs
+ * tree.
+ *
+ * @fs_info: the fs_info for this filesystem.
+ * @root_objectid: the root objectid that we are modifying for this extent.
+ * @bytenr: the byte we are modifying the reference for
+ * @num_bytes: the number of bytes we are locking.
+ * @for_cow: if this ref update is for cow we didn't take the lock.
+ * @block_group: the block_group we got from lock_ref.
+ * @cached_state: this is for caching our location so when we unlock we don't
+ * have to do a tree search.
+ *
+ * This can return -ENOMEM if we fail to allocate an extent state.
+ */
+int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
+	       u64 num_bytes, int for_cow,
+	       struct btrfs_block_group_cache *block_group,
+	       struct extent_state **cached_state)
+{
+	int ret;
+
+	if (!fs_info->quota_enabled || !need_ref_seq(for_cow, root_objectid))
+		return 0;
+
+	ret = unlock_extent_cached(&block_group->ref_lock, bytenr,
+				   bytenr + num_bytes - 1, cached_state,
+				   GFP_NOFS);
+	btrfs_put_block_group(block_group);
+	return ret;
+}
+
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
@@ -2024,10 +2097,13 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_delayed_data_ref *ref;
+	struct btrfs_block_group_cache *block_group;
+	struct extent_state *cached_state = NULL;
 	struct btrfs_key ins;
 	u64 parent = 0;
 	u64 ref_root = 0;
 	u64 flags = 0;
+	int err;
 
 	ins.objectid = node->bytenr;
 	ins.offset = node->num_bytes;
@@ -2041,6 +2117,10 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	else
 		ref_root = ref->root;
 
+	ret = lock_ref(root->fs_info, ref->root, node->bytenr, node->num_bytes,
+		       node->for_cow, &block_group, &cached_state);
+	if (ret)
+		return ret;
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		if (extent_op)
 			flags |= extent_op->flags_to_set;
@@ -2063,7 +2143,10 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	} else {
 		BUG();
 	}
-	return ret;
+	err = unlock_ref(root->fs_info, ref->root, node->bytenr,
+			 node->num_bytes, node->for_cow, block_group,
+			 &cached_state);
+	return ret ? ret : err;
 }
 
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
@@ -2185,9 +2268,12 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_delayed_tree_ref *ref;
+	struct btrfs_block_group_cache *block_group;
+	struct extent_state *cached_state = NULL;
 	struct btrfs_key ins;
 	u64 parent = 0;
 	u64 ref_root = 0;
+	int err;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
@@ -2208,6 +2294,10 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_ITEM_KEY;
 	}
 
+	ret = lock_ref(root->fs_info, ref->root, node->bytenr, node->num_bytes,
+		       node->for_cow, &block_group, &cached_state);
+	if (ret)
+		return ret;
 	BUG_ON(node->ref_mod != 1);
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
@@ -2227,7 +2317,10 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	} else {
 		BUG();
 	}
-	return ret;
+	err = unlock_ref(root->fs_info, ref->root, node->bytenr,
+			 node->num_bytes, node->for_cow, block_group,
+			 &cached_state);
+	return ret ? ret : err;
 }
 
 /* helper function to actually process a single delayed ref entry */
@@ -8490,7 +8583,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->fs_info = info;
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
-
+		extent_io_tree_init(&cache->ref_lock,
+				    info->btree_inode->i_mapping);
 		if (need_clear) {
 			/*
 			 * When we mount with old space cache, we need to
@@ -8689,6 +8783,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->new_bg_list);
+	extent_io_tree_init(&cache->ref_lock,
+			    root->fs_info->btree_inode->i_mapping);
 
 	btrfs_init_free_space_ctl(cache);
 
-- 
1.8.3.1

