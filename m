Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34999 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbbFFBW2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jun 2015 21:22:28 -0400
Received: by qkhq76 with SMTP id q76so49120324qkh.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 18:22:27 -0700 (PDT)
From: jmaggard10@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Btrfs: Clean up quota reservations from delayed refs
Date: Fri,  5 Jun 2015 18:22:18 -0700
Message-Id: <1433553738-31763-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Justin Maggard <jmaggard10@gmail.com>

Currently it's easy to throw off quota reservations by creating and deleting
files before delayed refs get run.  This would be a common problem with temp
files.  To illustrate, here's a quick reproducer:

$ for i in $(seq 1 100); do fallocate -l1G tmp; rm tmp; done

This will cause 100GB to get tallied for quota reservations, but it will never
be freed.

This is because quotas are not considered when we drop delayed refs.  So let's
call btrfs_qgroup_free() when deleting delayed refs.  Some churn is necessary
in order to give btrfs_qgroup_free() enough information to do his job.
---
 fs/btrfs/delayed-ref.c | 34 ++++++++++++++++++++++++----------
 fs/btrfs/delayed-ref.h |  3 ++-
 fs/btrfs/extent-tree.c | 10 +++++++---
 fs/btrfs/qgroup.c      |  5 ++---
 fs/btrfs/qgroup.h      |  3 ++-
 fs/btrfs/transaction.c | 14 ++++++++++----
 6 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8f8ed7d..d9543d6 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -22,6 +22,7 @@
 #include "ctree.h"
 #include "delayed-ref.h"
 #include "transaction.h"
+#include "qgroup.h"
 
 struct kmem_cache *btrfs_delayed_ref_head_cachep;
 struct kmem_cache *btrfs_delayed_tree_ref_cachep;
@@ -261,7 +262,9 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 				    struct btrfs_delayed_ref_root *delayed_refs,
 				    struct btrfs_delayed_ref_head *head,
-				    struct btrfs_delayed_ref_node *ref)
+				    struct btrfs_delayed_ref_node *ref,
+				    struct btrfs_fs_info *fs_info,
+				    u64 ref_root)
 {
 	if (btrfs_delayed_ref_is_head(ref)) {
 		head = btrfs_delayed_node_to_head(ref);
@@ -275,12 +278,16 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	atomic_dec(&delayed_refs->num_entries);
 	if (trans->delayed_ref_updates)
 		trans->delayed_ref_updates--;
+	if (!ref->no_quota)
+		btrfs_qgroup_free(fs_info, ref_root, ref->num_bytes);
 }
 
 static int merge_ref(struct btrfs_trans_handle *trans,
 		     struct btrfs_delayed_ref_root *delayed_refs,
 		     struct btrfs_delayed_ref_head *head,
-		     struct btrfs_delayed_ref_node *ref, u64 seq)
+		     struct btrfs_delayed_ref_node *ref,
+		     struct btrfs_fs_info *fs_info,
+		     u64 seq, u64 ref_root)
 {
 	struct rb_node *node;
 	int mod = 0;
@@ -311,10 +318,12 @@ static int merge_ref(struct btrfs_trans_handle *trans,
 			mod = -next->ref_mod;
 		}
 
-		drop_delayed_ref(trans, delayed_refs, head, next);
+		drop_delayed_ref(trans, delayed_refs, head, next, fs_info,
+				 ref_root);
 		ref->ref_mod += mod;
 		if (ref->ref_mod == 0) {
-			drop_delayed_ref(trans, delayed_refs, head, ref);
+			drop_delayed_ref(trans, delayed_refs, head, ref,
+					 fs_info, ref_root);
 			done = 1;
 		} else {
 			/*
@@ -331,7 +340,8 @@ static int merge_ref(struct btrfs_trans_handle *trans,
 void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info,
 			      struct btrfs_delayed_ref_root *delayed_refs,
-			      struct btrfs_delayed_ref_head *head)
+			      struct btrfs_delayed_ref_head *head,
+			      u64 ref_root)
 {
 	struct rb_node *node;
 	u64 seq = 0;
@@ -363,7 +373,8 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 		/* We can't merge refs that are outside of our seq count */
 		if (seq && ref->seq >= seq)
 			break;
-		if (merge_ref(trans, delayed_refs, head, ref, seq))
+		if (merge_ref(trans, delayed_refs, head, ref, fs_info, seq,
+			      ref_root))
 			node = rb_first(&head->ref_root);
 		else
 			node = rb_next(&ref->rb_node);
@@ -455,7 +466,9 @@ update_existing_ref(struct btrfs_trans_handle *trans,
 		    struct btrfs_delayed_ref_root *delayed_refs,
 		    struct btrfs_delayed_ref_head *head,
 		    struct btrfs_delayed_ref_node *existing,
-		    struct btrfs_delayed_ref_node *update)
+		    struct btrfs_delayed_ref_node *update,
+		    struct btrfs_fs_info *fs_info,
+		    u64 ref_root)
 {
 	if (update->action != existing->action) {
 		/*
@@ -466,7 +479,8 @@ update_existing_ref(struct btrfs_trans_handle *trans,
 		 */
 		existing->ref_mod--;
 		if (existing->ref_mod == 0)
-			drop_delayed_ref(trans, delayed_refs, head, existing);
+			drop_delayed_ref(trans, delayed_refs, head, existing,
+					 fs_info, ref_root);
 		else
 			WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
 				existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
@@ -697,7 +711,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
 	if (existing) {
 		update_existing_ref(trans, delayed_refs, head_ref, existing,
-				    ref);
+				    ref, fs_info, ref_root);
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
@@ -762,7 +776,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	existing = tree_insert(&head_ref->ref_root, &ref->rb_node);
 	if (existing) {
 		update_existing_ref(trans, delayed_refs, head_ref, existing,
-				    ref);
+				    ref, fs_info, ref_root);
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 5eb0892..c6898be 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -222,7 +222,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info,
 			      struct btrfs_delayed_ref_root *delayed_refs,
-			      struct btrfs_delayed_ref_head *head);
+			      struct btrfs_delayed_ref_head *head,
+			      u64 ref_root);
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ec3acd..8a29b54 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2405,7 +2405,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 */
 		spin_lock(&locked_ref->lock);
 		btrfs_merge_delayed_refs(trans, fs_info, delayed_refs,
-					 locked_ref);
+					 locked_ref, root->root_key.objectid);
 
 		/*
 		 * locked_ref is the head node, so we have to go one
@@ -5263,7 +5263,9 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	if (ret) {
 		if (*qgroup_reserved)
-			btrfs_qgroup_free(root, *qgroup_reserved);
+			btrfs_qgroup_free(root->fs_info,
+					  root->root_key.objectid,
+					  *qgroup_reserved);
 	}
 
 	return ret;
@@ -5433,7 +5435,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
 	if (unlikely(ret)) {
 		if (root->fs_info->quota_enabled)
-			btrfs_qgroup_free(root, nr_extents * root->nodesize);
+			btrfs_qgroup_free(root->fs_info,
+					  root->root_key.objectid,
+					  nr_extents * root->nodesize);
 		goto out_fail;
 	}
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3d65465..922584b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2565,14 +2565,13 @@ out:
 	return ret;
 }
 
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+void btrfs_qgroup_free(struct btrfs_fs_info *fs_info, u64 ref_root,
+		       u64 num_bytes)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
-	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
 
 	if (!is_fstree(ref_root))
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c5242aa..32c3192 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -95,7 +95,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
+void btrfs_qgroup_free(struct btrfs_fs_info *fs_info, u64 ref_root,
+		       u64 num_bytes);
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5628e25..0d2575f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -560,7 +560,8 @@ alloc_fail:
 					num_bytes);
 reserve_fail:
 	if (qgroup_reserved)
-		btrfs_qgroup_free(root, qgroup_reserved);
+		btrfs_qgroup_free(root->fs_info, root->root_key.objectid,
+				  qgroup_reserved);
 	return ERR_PTR(ret);
 }
 
@@ -782,7 +783,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		 * the same root has to be passed here between start_transaction
 		 * and end_transaction. Subvolume quota depends on this.
 		 */
-		btrfs_qgroup_free(trans->root, trans->qgroup_reserved);
+		btrfs_qgroup_free(trans->root->fs_info,
+				  trans->root->root_key.objectid,
+				  trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -1794,7 +1797,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root->fs_info,
+				  root->root_key.objectid,
+				  trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
 
@@ -2125,7 +2130,8 @@ cleanup_transaction:
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	if (trans->qgroup_reserved) {
-		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		btrfs_qgroup_free(root->fs_info, root->root_key.objectid,
+				  trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
 	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
-- 
2.4.2

