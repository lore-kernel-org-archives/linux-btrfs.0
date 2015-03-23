Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57975 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbbCWIKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89dAs012347
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 06/11] btrfs: qgroup: Add needed parameter and member for qgroup.
Date: Mon, 23 Mar 2015 16:08:32 +0800
Message-ID: <1427098117-25152-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the following member for struct btrfs_qgroup_operation:
  'old_roots' ulist
    Records rootfs found before the delayed ref operation.

  'new_roots' ulist
    Records rootfs found after the delayed ref operation.

Add the following parameters for btrfs_qgroup_record_ref():
  'old_roots' ulist
    Records rootfs found before the delayed ref operation.
    Caller of btrfs_qgroup_record_ref() should get the old_roots ulist
    before writing extent tree and pass it to qgroup_record_ref() if it
    may cause a shared extent accounting operation.

  'node_seq' u64
    Sequence number of the correspoding delayed ref node.
    Used to search delayed refs to find correct reference roots.

This patch just adds the member and parameters, no real behavior changes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c        | 33 ++++++++++++++++++---------------
 fs/btrfs/qgroup.c             | 13 +++++++++++--
 fs/btrfs/qgroup.h             |  7 +++++--
 fs/btrfs/tests/qgroup-tests.c | 10 +++++-----
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 89cb363..e73c1fa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2013,8 +2013,9 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			type = BTRFS_QGROUP_OPER_ADD_SHARED;
 		btrfs_release_path(path);
 
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+		ret = btrfs_qgroup_record_ref(trans, fs_info, NULL,
+					      root_objectid, bytenr, num_bytes,
+					      node->seq, type, 0);
 		goto out;
 	}
 
@@ -2037,8 +2038,9 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (!no_quota) {
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      bytenr, num_bytes, type, 0);
+		ret = btrfs_qgroup_record_ref(trans, fs_info, NULL,
+					      root_objectid, bytenr, num_bytes,
+					      node->seq, type, 0);
 		if (ret)
 			goto out;
 	}
@@ -6057,9 +6059,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		    type == BTRFS_QGROUP_OPER_SUB_SHARED)
 			mod_seq = 1;
 
-		ret = btrfs_qgroup_record_ref(trans, info, root_objectid,
-					      bytenr, num_bytes, type,
-					      mod_seq);
+		ret = btrfs_qgroup_record_ref(trans, info, NULL, root_objectid,
+					      bytenr, num_bytes, node->seq,
+					      type, mod_seq);
 	}
 out:
 	btrfs_free_path(path);
@@ -6997,8 +6999,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_free_path(path);
 
 	/* Always set parent to 0 here since its exclusive anyway. */
-	ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-				      ins->objectid, ins->offset,
+	ret = btrfs_qgroup_record_ref(trans, fs_info, NULL, root_objectid,
+				      ins->objectid, ins->offset, 0,
 				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
 	if (ret)
 		return ret;
@@ -7085,8 +7087,9 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_free_path(path);
 
 	if (!no_quota) {
-		ret = btrfs_qgroup_record_ref(trans, fs_info, root_objectid,
-					      ins->objectid, num_bytes,
+		ret = btrfs_qgroup_record_ref(trans, fs_info, NULL,
+					      root_objectid, ins->objectid,
+					      num_bytes, 0,
 					      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
 		if (ret)
 			return ret;
@@ -7463,8 +7466,8 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 
 		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-					      root->objectid,
-					      bytenr, num_bytes,
+					      NULL, root->objectid,
+					      bytenr, num_bytes, 0,
 					      BTRFS_QGROUP_OPER_SUB_SUBTREE, 0);
 		if (ret)
 			return ret;
@@ -7611,9 +7614,9 @@ walk_down:
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
 
 			ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-						root->objectid,
+						NULL, root->objectid,
 						child_bytenr,
-						root->nodesize,
+						root->nodesize, 0,
 						BTRFS_QGROUP_OPER_SUB_SUBTREE,
 						0);
 			if (ret)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9a94494..b82c43c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1335,9 +1335,13 @@ static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
  * Record a quota operation for processing later on.
  * @trans: the transaction we are adding the delayed op to.
  * @fs_info: the fs_info for this fs.
+ * @old_roots: roots referring the extent before the delayed_ref operation.
+ *	       Only used for shared extents accounting.
  * @ref_root: the root of the reference we are acting on,
  * @bytenr: the bytenr we are acting on.
  * @num_bytes: the number of bytes in the reference.
+ * @node_seq: sequence number of corresponding ref_node.
+ *	      Only used for shared extents accounting.
  * @type: the type of operation this is.
  * @mod_seq: do we need to get a sequence number for looking up roots.
  *
@@ -1348,8 +1352,9 @@ static int insert_qgroup_oper(struct btrfs_fs_info *fs_info,
  * MUST BE HOLDING THE REF LOCK.
  */
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 ref_root,
-			    u64 bytenr, u64 num_bytes,
+			    struct btrfs_fs_info *fs_info,
+			    struct ulist *old_roots, u64 ref_root,
+			    u64 bytenr, u64 num_bytes, u64 node_seq,
 			    enum btrfs_qgroup_operation_type type, int mod_seq)
 {
 	struct btrfs_qgroup_operation *oper;
@@ -1366,6 +1371,8 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->bytenr = bytenr;
 	oper->num_bytes = num_bytes;
 	oper->type = type;
+	oper->new_roots = NULL;
+	oper->old_roots = old_roots;
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
@@ -2135,6 +2142,8 @@ int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
 		rb_erase(&oper->n, &fs_info->qgroup_op_tree);
 		spin_unlock(&fs_info->qgroup_op_lock);
 		btrfs_put_tree_mod_seq(fs_info, &oper->elem);
+		ulist_free(oper->old_roots);
+		ulist_free(oper->new_roots);
 		kfree(oper);
 	}
 	return ret;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..264b498 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -56,6 +56,8 @@ struct btrfs_qgroup_operation {
 	struct seq_list elem;
 	struct rb_node n;
 	struct list_head list;
+	struct ulist *old_roots;
+	struct ulist *new_roots;
 };
 
 int btrfs_quota_enable(struct btrfs_trans_handle *trans,
@@ -81,8 +83,9 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info);
 void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
 struct btrfs_delayed_extent_op;
 int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 ref_root,
-			    u64 bytenr, u64 num_bytes,
+			    struct btrfs_fs_info *fs_info,
+			    struct ulist *old_roots, u64 ref_root,
+			    u64 bytenr, u64 num_bytes, u64 node_seq,
 			    enum btrfs_qgroup_operation_type type,
 			    int mod_seq);
 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 73f299e..c97c5f8 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -238,7 +238,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 5, 4096, 4096, 0,
 				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
@@ -264,7 +264,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	if (ret)
 		return -EINVAL;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 5, 4096, 4096, 0,
 				      BTRFS_QGROUP_OPER_SUB_EXCL, 0);
 	if (ret) {
 		test_msg("Couldn't remove space from the qgroup %d\n", ret);
@@ -311,7 +311,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 5, 4096, 4096, 0,
 				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
 	if (ret) {
 		test_msg("Couldn't add space to a qgroup %d\n", ret);
@@ -333,7 +333,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 256, 4096, 4096, 0,
 				      BTRFS_QGROUP_OPER_ADD_SHARED, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
@@ -360,7 +360,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 256, 4096, 4096, 0,
 				      BTRFS_QGROUP_OPER_SUB_SHARED, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
-- 
2.3.3

