Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35105 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdFFXpq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:45:46 -0400
Received: by mail-pf0-f174.google.com with SMTP id l89so28749893pfi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:45:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
Subject: [PATCH 5/7] Btrfs: return old and new total ref mods when adding delayed refs
Date: Tue,  6 Jun 2017 16:45:30 -0700
Message-Id: <df7f046965c84749f0cdb026a55c1a33c9d348c0.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We need this to decide when to account pinned bytes.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/delayed-ref.c | 29 ++++++++++++++++++++--------
 fs/btrfs/delayed-ref.h |  6 ++++--
 fs/btrfs/extent-tree.c | 51 ++++++++++++++++++++++++++------------------------
 3 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index be70d90dfee5..93ffa898df6d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -470,7 +470,8 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 static noinline void
 update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 			 struct btrfs_delayed_ref_node *existing,
-			 struct btrfs_delayed_ref_node *update)
+			 struct btrfs_delayed_ref_node *update,
+			 int *old_ref_mod_ret)
 {
 	struct btrfs_delayed_ref_head *existing_ref;
 	struct btrfs_delayed_ref_head *ref;
@@ -523,6 +524,8 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	 * currently, for refs we just added we know we're a-ok.
 	 */
 	old_ref_mod = existing_ref->total_ref_mod;
+	if (old_ref_mod_ret)
+		*old_ref_mod_ret = old_ref_mod;
 	existing->ref_mod += update->ref_mod;
 	existing_ref->total_ref_mod += update->ref_mod;
 
@@ -550,7 +553,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		     struct btrfs_delayed_ref_node *ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
 		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
-		     int action, int is_data, int *qrecord_inserted_ret)
+		     int action, int is_data, int *qrecord_inserted_ret,
+		     int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
@@ -638,7 +642,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	if (existing) {
 		WARN_ON(ref_root && reserved && existing->qgroup_ref_root
 			&& existing->qgroup_reserved);
-		update_existing_head_ref(delayed_refs, &existing->node, ref);
+		update_existing_head_ref(delayed_refs, &existing->node, ref,
+					 old_ref_mod);
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
@@ -646,6 +651,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
 		head_ref = existing;
 	} else {
+		if (old_ref_mod)
+			*old_ref_mod = 0;
 		if (is_data && count_mod < 0)
 			delayed_refs->pending_csums += num_bytes;
 		delayed_refs->num_heads++;
@@ -655,6 +662,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	}
 	if (qrecord_inserted_ret)
 		*qrecord_inserted_ret = qrecord_inserted;
+	if (new_ref_mod)
+		*new_ref_mod = head_ref->total_ref_mod;
 	return head_ref;
 }
 
@@ -778,7 +787,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root,  int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -813,7 +823,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, 0, 0, action, 0,
-					&qrecord_inserted);
+					&qrecord_inserted, old_ref_mod,
+					new_ref_mod);
 
 	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 			     num_bytes, parent, ref_root, level, action);
@@ -838,7 +849,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action)
+			       u64 owner, u64 offset, u64 reserved, int action,
+			       int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -878,7 +890,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, ref_root, reserved,
-					action, 1, &qrecord_inserted);
+					action, 1, &qrecord_inserted,
+					old_ref_mod, new_ref_mod);
 
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
@@ -909,7 +922,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 
 	add_delayed_ref_head(fs_info, trans, &head_ref->node, NULL, bytenr,
 			     num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
-			     extent_op->is_data, NULL);
+			     extent_op->is_data, NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index c0264ff01b53..ce88e4ac5276 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -247,12 +247,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action);
+			       u64 owner, u64 offset, u64 reserved, int action,
+			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 52f3a0486e64..6dce7abafe84 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2119,14 +2119,16 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
-					num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_ADD_DELAYED_REF, NULL);
+						 num_bytes, parent,
+						 root_objectid, (int)owner,
+						 BTRFS_ADD_DELAYED_REF, NULL,
+						 NULL, NULL);
 	} else {
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
-					num_bytes, parent, root_objectid,
-					owner, offset, 0,
-					BTRFS_ADD_DELAYED_REF);
+						 num_bytes, parent,
+						 root_objectid, owner, offset,
+						 0, BTRFS_ADD_DELAYED_REF, NULL,
+						 NULL);
 	}
 	return ret;
 }
@@ -7169,12 +7171,12 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans,
-						 buf->start, buf->len,
-						 parent,
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, buf->start,
+						 buf->len, parent,
 						 root->root_key.objectid,
 						 btrfs_header_level(buf),
-						 BTRFS_DROP_DELAYED_REF, NULL);
+						 BTRFS_DROP_DELAYED_REF, NULL,
+						 NULL, NULL);
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
@@ -7242,15 +7244,16 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
-					num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_DROP_DELAYED_REF, NULL);
+						 num_bytes, parent,
+						 root_objectid, (int)owner,
+						 BTRFS_DROP_DELAYED_REF, NULL,
+						 NULL, NULL);
 	} else {
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
-						num_bytes,
-						parent, root_objectid, owner,
-						offset, 0,
-						BTRFS_DROP_DELAYED_REF);
+						 num_bytes, parent,
+						 root_objectid, owner, offset,
+						 0, BTRFS_DROP_DELAYED_REF,
+						 NULL, NULL);
 	}
 	return ret;
 }
@@ -8198,9 +8201,9 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
 	ret = btrfs_add_delayed_data_ref(fs_info, trans, ins->objectid,
-					 ins->offset, 0,
-					 root_objectid, owner, offset,
-					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT);
+					 ins->offset, 0, root_objectid, owner,
+					 offset, ram_bytes,
+					 BTRFS_ADD_DELAYED_EXTENT, NULL, NULL);
 	return ret;
 }
 
@@ -8420,11 +8423,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		extent_op->is_data = false;
 		extent_op->level = level;
 
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans,
-						 ins.objectid, ins.offset,
-						 parent, root_objectid, level,
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, ins.objectid,
+						 ins.offset, parent,
+						 root_objectid, level,
 						 BTRFS_ADD_DELAYED_EXTENT,
-						 extent_op);
+						 extent_op, NULL, NULL);
 		if (ret)
 			goto out_free_delayed;
 	}
-- 
2.13.0

