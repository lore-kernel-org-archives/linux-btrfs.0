Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57704 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726426AbeIDLXp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:23:45 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15 05/13] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date: Tue, 4 Sep 2018 14:59:34 +0800
Message-ID: <20180904065942.3621-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
References: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

For in-band dedupe, btrfs needs to increase data ref with delayed_ref
locked, so add a new function btrfs_add_delayed_data_ref_lock() to
increase extent ref with delayed_refs already locked. Export
init_delayed_ref_head and init_delayed_ref_common for inband dedupe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 53 +++++++++++++++++++++++++++++-------------
 fs/btrfs/delayed-ref.h | 15 ++++++++++++
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 62ff545ba1f7..faca30b334ee 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -526,7 +526,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	spin_unlock(&existing->lock);
 }
 
-static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+void btrfs_init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
 				  struct btrfs_qgroup_extent_record *qrecord,
 				  u64 bytenr, u64 num_bytes, u64 ref_root,
 				  u64 reserved, int action, bool is_data,
@@ -654,7 +654,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 }
 
 /*
- * init_delayed_ref_common - Initialize the structure which represents a
+ * btrfs_init_delayed_ref_common - Initialize the structure which represents a
  *			     modification to a an extent.
  *
  * @fs_info:    Internal to the mounted filesystem mount structure.
@@ -678,7 +678,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
  *		when recording a metadata extent or BTRFS_SHARED_DATA_REF_KEY/
  *		BTRFS_EXTENT_DATA_REF_KEY when recording data extent
  */
-static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+void btrfs_init_delayed_ref_common(struct btrfs_fs_info *fs_info,
 				    struct btrfs_delayed_ref_node *ref,
 				    u64 bytenr, u64 num_bytes, u64 ref_root,
 				    int action, u8 ref_type)
@@ -751,14 +751,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	else
 		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
 
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
-				ref_root, action, ref_type);
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+				      ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
 	ref->level = level;
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
-			      ref_root, 0, action, false, is_system);
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+				    ref_root, 0, action, false, is_system);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -787,6 +787,29 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * Do real delayed data ref insert.
+ * Caller must hold delayed_refs->lock and allocation memory
+ * for dref,head_ref and record.
+ */
+int btrfs_add_delayed_data_ref_locked(struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			struct btrfs_delayed_data_ref *ref, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	head_ref = add_delayed_ref_head(trans, head_ref, qrecord,
+					action, qrecord_inserted_ret,
+					old_ref_mod, new_ref_mod);
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	return insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
+}
+
 /*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
@@ -813,7 +836,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
 	else
 	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
 				ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
@@ -838,8 +861,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes, ref_root,
-			      reserved, action, true, false);
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+			      ref_root, reserved, action, true, false);
 	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -849,11 +872,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(trans, head_ref, record,
-					action, &qrecord_inserted,
-					old_ref_mod, new_ref_mod);
-
-	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
+	ret = btrfs_add_delayed_data_ref_locked(trans, head_ref,
+			record, ref, action, &qrecord_inserted, old_ref_mod,
+			new_ref_mod);
 	spin_unlock(&delayed_refs->lock);
 
 	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
@@ -880,7 +901,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	if (!head_ref)
 		return -ENOMEM;
 
-	init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
+	btrfs_init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
 			      BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data,
 			      false);
 	head_ref->extent_op = extent_op;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d9f2a4ebd5db..45963717143b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -234,11 +234,26 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head);
 }
 
+void btrfs_init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+				  struct btrfs_qgroup_extent_record *qrecord,
+				  u64 bytenr, u64 num_bytes, u64 ref_root,
+				  u64 reserved, int action, bool is_data,
+				  bool is_system);
+void btrfs_init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+				    struct btrfs_delayed_ref_node *ref,
+				    u64 bytenr, u64 num_bytes, u64 ref_root,
+				    int action, u8 ref_type);
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
+int btrfs_add_delayed_data_ref_locked(struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			struct btrfs_delayed_data_ref *ref, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-- 
2.18.0
