Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27258 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755083AbbBJK1p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQwEt000954
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:58 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/7] btrfs: qgroup: apply type to the recording and accounting.
Date: Tue, 10 Feb 2015 18:24:15 +0800
Message-ID: <1423563862-9151-5-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So far, we have a type in each qgroup and we can create
a qgroup in different type. But there is no actual differenc
in accounting action in different qgroups.

This patch makes the qgroup ignore the qgroup recording
for other type. It means qgroup in DATA type only care
about the data size in this qgroup and ignore the metadata
size accounting.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c        | 48 ++++++++++++++++++++++++++-----------------
 fs/btrfs/qgroup.c             | 19 ++++++++++++++---
 fs/btrfs/qgroup.h             |  9 ++++++--
 fs/btrfs/tests/qgroup-tests.c | 15 +++++++++-----
 fs/btrfs/transaction.c        | 11 +++++-----
 5 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f59809c..2f8506e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -82,7 +82,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
 				struct btrfs_delayed_extent_op *extra_op,
-				int no_quota);
+				int no_quota, unsigned int quota_type);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -1970,7 +1970,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 parent, u64 root_objectid,
 				  u64 owner, u64 offset, int refs_to_add,
 				  int no_quota,
-				  struct btrfs_delayed_extent_op *extent_op)
+				  struct btrfs_delayed_extent_op *extent_op,
+				  unsigned int quota_type)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
@@ -2012,7 +2013,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+					      bytenr, num_bytes, type,
+					      quota_type, 0);
 		goto out;
 	}
 
@@ -2036,7 +2038,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	if (!no_quota) {
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+					      bytenr, num_bytes, type,
+					      quota_type, 0);
 		if (ret)
 			goto out;
 	}
@@ -2090,13 +2093,15 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 					     node->num_bytes, parent,
 					     ref_root, ref->objectid,
 					     ref->offset, node->ref_mod,
-					     node->no_quota, extent_op);
+					     node->no_quota, extent_op,
+					     BTRFS_QGROUP_TYPE_DATA);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, root, node->bytenr,
 					  node->num_bytes, parent,
 					  ref_root, ref->objectid,
 					  ref->offset, node->ref_mod,
-					  extent_op, node->no_quota);
+					  extent_op, node->no_quota,
+					  BTRFS_QGROUP_TYPE_DATA);
 	} else {
 		BUG();
 	}
@@ -2257,12 +2262,12 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
 					     node->num_bytes, parent, ref_root,
 					     ref->level, 0, 1, node->no_quota,
-					     extent_op);
+					     extent_op, BTRFS_QGROUP_TYPE_METADATA);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
 		ret = __btrfs_free_extent(trans, root, node->bytenr,
 					  node->num_bytes, parent, ref_root,
 					  ref->level, 0, 1, extent_op,
-					  node->no_quota);
+					  node->no_quota, BTRFS_QGROUP_TYPE_METADATA);
 	} else {
 		BUG();
 	}
@@ -3778,7 +3783,7 @@ commit_trans:
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	ret = btrfs_qgroup_reserve(root, write_bytes);
+	ret = btrfs_qgroup_reserve(root, write_bytes, BTRFS_QGROUP_TYPE_DATA);
 	if (ret)
 		goto out;
 	data_sinfo->bytes_may_use += bytes;
@@ -5013,7 +5018,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (root->fs_info->quota_enabled) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * root->nodesize;
-		ret = btrfs_qgroup_reserve(root, num_bytes);
+		ret = btrfs_qgroup_reserve(root, num_bytes, BTRFS_QGROUP_TYPE_METADATA);
 		if (ret)
 			return ret;
 	} else {
@@ -5033,7 +5038,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	if (ret) {
 		if (*qgroup_reserved)
-			btrfs_qgroup_free(root, *qgroup_reserved);
+			btrfs_qgroup_free(root, *qgroup_reserved, BTRFS_QGROUP_TYPE_METADATA);
 	}
 
 	return ret;
@@ -5197,7 +5202,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_unlock(&BTRFS_I(inode)->lock);
 
 	if (root->fs_info->quota_enabled) {
-		ret = btrfs_qgroup_reserve(root, nr_extents * root->nodesize);
+		ret = btrfs_qgroup_reserve(root, nr_extents * root->nodesize,
+					   BTRFS_QGROUP_TYPE_METADATA);
 		if (ret)
 			goto out_fail;
 	}
@@ -5205,7 +5211,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
 	if (unlikely(ret)) {
 		if (root->fs_info->quota_enabled)
-			btrfs_qgroup_free(root, nr_extents * root->nodesize);
+			btrfs_qgroup_free(root, nr_extents * root->nodesize,
+					  BTRFS_QGROUP_TYPE_METADATA);
 		goto out_fail;
 	}
 
@@ -5851,7 +5858,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
 				struct btrfs_delayed_extent_op *extent_op,
-				int no_quota)
+				int no_quota, unsigned int quota_type)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -6121,7 +6128,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_qgroup_record_ref(trans, info, root_objectid,
 					      bytenr, num_bytes, type,
-					      mod_seq);
+					      quota_type, mod_seq);
 	}
 out:
 	btrfs_free_path(path);
@@ -7060,7 +7067,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	/* Always set parent to 0 here since its exclusive anyway. */
 	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
 				      ins->objectid, ins->offset,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_TYPE_DATA, 0);
 	if (ret)
 		return ret;
 
@@ -7148,7 +7156,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	if (!no_quota) {
 		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
 					      ins->objectid, num_bytes,
-					      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+					      BTRFS_QGROUP_OPER_ADD_EXCL,
+					      BTRFS_QGROUP_TYPE_METADATA, 0);
 		if (ret)
 			return ret;
 	}
@@ -7526,7 +7535,8 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
 					      root->objectid,
 					      bytenr, num_bytes,
-					      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
+					      BTRFS_QGROUP_OPER_SUB_SUBTREE,
+					      BTRFS_QGROUP_TYPE_METADATA, 0);
 		if (ret)
 			return ret;
 	}
@@ -7676,7 +7686,7 @@ walk_down:
 						child_bytenr,
 						root->nodesize,
 						BTRFS_QGROUP_OPER_SUB_SUBTREE,
-						0);
+						BTRFS_QGROUP_TYPE_METADATA, 0);
 			if (ret)
 				goto out;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8ac785a..2fa8497 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1376,7 +1376,8 @@ static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 ref_root,
 			    u64 bytenr, u64 num_bytes,
-			    enum btrfs_qgroup_operation_type type, int mod_seq)
+			    enum btrfs_qgroup_operation_type type,
+			    unsigned int quota_type, int mod_seq)
 {
 	struct btrfs_qgroup_operation *oper;
 	int ret;
@@ -1392,6 +1393,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->bytenr = bytenr;
 	oper->num_bytes = num_bytes;
 	oper->type = type;
+	oper->quota_type = quota_type;
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
@@ -1455,6 +1457,8 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
 		goto out;
+	if (!(qgroup->type & oper->quota_type))
+		goto out;
 	switch (oper->type) {
 	case BTRFS_QGROUP_OPER_ADD_EXCL:
 		sign = 1;
@@ -1943,6 +1947,8 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	qgroup = find_qgroup_rb(fs_info, oper->ref_root);
 	if (!qgroup)
 		goto out;
+	if (!(qgroup->type & oper->quota_type))
+		goto out;
 	seq = fs_info->qgroup_seq;
 
 	/*
@@ -2069,6 +2075,8 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	qg = find_qgroup_rb(fs_info, root_obj);
 	if (!qg)
 		goto out_unlock;
+	if (!(qg->type & oper->quota_type))
+		goto out_unlock;
 
 	qg->excl += oper->num_bytes;
 	qg->excl_cmpr += oper->num_bytes;
@@ -2442,7 +2450,7 @@ out:
 	return ret;
 }
 
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
+int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2467,6 +2475,8 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	if (!qgroup)
 		goto out;
 
+	if (!(qgroup->type & type))
+		goto out;
 	/*
 	 * in a first step, we check all affected qgroups if any limits would
 	 * be exceeded
@@ -2523,7 +2533,7 @@ out:
 	return ret;
 }
 
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2549,6 +2559,9 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 	if (!qgroup)
 		goto out;
 
+	if (!(qgroup->type & type))
+		goto out;
+
 	ulist_reinit(fs_info->qgroup_ulist);
 	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
 			(uintptr_t)qgroup, GFP_ATOMIC);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 7bd3a90..75d0bb6 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -63,6 +63,10 @@ struct btrfs_qgroup_operation {
 	u64 num_bytes;
 	u64 seq;
 	enum btrfs_qgroup_operation_type type;
+	/*
+	 * DATA or METADATA;
+	 **/
+	unsigned int quota_type;
 	struct seq_list elem;
 	struct rb_node n;
 	struct list_head list;
@@ -96,6 +100,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 ref_root,
 			    u64 bytenr, u64 num_bytes,
 			    enum btrfs_qgroup_operation_type type,
+			    unsigned int quota_type,
 			    int mod_seq);
 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
 				    struct btrfs_fs_info *fs_info);
@@ -107,8 +112,8 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
-int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
+int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes, u8 type);
+void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes, u8 type);
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 4ae3b5d..9c2f884 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -239,7 +239,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	}
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
 		return ret;
@@ -265,7 +266,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return -EINVAL;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_EXCL, 0);
+				      BTRFS_QGROUP_OPER_SUB_EXCL,
+				      BTRFS_QGROUP_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't remove space from the qgroup %d\n", ret);
 		return -EINVAL;
@@ -312,7 +314,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+				      BTRFS_QGROUP_OPER_ADD_EXCL,
+				      BTRFS_QGROUP_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
 		return ret;
@@ -334,7 +337,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_SHARED, 0);
+				      BTRFS_QGROUP_OPER_ADD_SHARED,
+				      BTRFS_QGROUP_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
 		return ret;
@@ -361,7 +365,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 
 	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_SHARED, 0);
+				      BTRFS_QGROUP_OPER_SUB_SHARED,
+				      BTRFS_QGROUP_TYPE_DEFAULT, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
 		return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a605d4e..358f3ab 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -437,7 +437,8 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		if (root->fs_info->quota_enabled &&
 		    is_fstree(root->root_key.objectid)) {
 			qgroup_reserved = num_items * root->nodesize;
-			ret = btrfs_qgroup_reserve(root, qgroup_reserved);
+			ret = btrfs_qgroup_reserve(root, qgroup_reserved,
+						   BTRFS_QGROUP_TYPE_METADATA);
 			if (ret)
 				return ERR_PTR(ret);
 		}
@@ -552,7 +553,7 @@ alloc_fail:
 					num_bytes);
 reserve_fail:
 	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
+		btrfs_qgroup_free(root, qgroup_reserved, BTRFS_QGROUP_TYPE_METADATA);
 	return ERR_PTR(ret);
 }
 
@@ -774,7 +775,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		 * the same root has to be passed here between start_transaction
 		 * and end_transaction. Subvolume quota depends on this.
 		 */
-		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
+		btrfs_qgroup_free(trans->root, trans->qgroup_reserved, BTRFS_QGROUP_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -1772,7 +1773,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root, trans->qgroup_reserved, BTRFS_QGROUP_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -2064,7 +2065,7 @@ cleanup_transaction:
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root, trans->qgroup_reserved, BTRFS_QGROUP_TYPE_METADATA);
 		trans->qgroup_reserved = 0;
 	}
 	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
-- 
1.8.4.2

