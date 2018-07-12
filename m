Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47533 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403835AbeGLBdS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 21:33:18 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v14.8 07/14] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date: Thu, 12 Jul 2018 09:25:46 +0800
Message-ID: <20180712012553.29431-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
References: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
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
 fs/btrfs/delayed-ref.c | 49 ++++++++++++++++++++++++++++++------------
 fs/btrfs/delayed-ref.h | 16 ++++++++++++++
 2 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 03dec673d12a..10de8011ada7 100644
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
@@ -734,7 +734,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
 	else
 		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
 				ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
@@ -751,7 +751,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			goto free_head_ref;
 	}
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
 			      ref_root, 0, action, false, is_system);
 	head_ref->extent_op = extent_op;
 
@@ -788,6 +788,29 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	return -ENOMEM;
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
@@ -814,7 +837,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
 	else
 	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
 				ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
@@ -839,8 +862,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes, ref_root,
-			      reserved, action, true, false);
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+			      ref_root, reserved, action, true, false);
 	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -850,11 +873,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
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
@@ -881,7 +902,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	if (!head_ref)
 		return -ENOMEM;
 
-	init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
+	btrfs_init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
 			      BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data,
 			      false);
 	head_ref->extent_op = extent_op;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ea1aecb6a50d..3e1abcbc3956 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -234,12 +234,28 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head);
 }
 
+struct btrfs_qgroup_extent_record;
+void btrfs_init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+				  struct btrfs_qgroup_extent_record *qrecord,
+				  u64 bytenr, u64 num_bytes, u64 ref_root,
+				  u64 reserved, int action, bool is_data,
+				  bool is_system);
+void btrfs_init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+				    struct btrfs_delayed_ref_node *ref,
+				    u64 bytenr, u64 num_bytes, u64 ref_root,
+				    int action, u8 ref_type);
 int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
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
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
-- 
2.18.0



