Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56617 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758367AbeDXOSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:18:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ACF8AF2A
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:18:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 4/8] btrfs: Open-code add_delayed_tree_ref
Date: Tue, 24 Apr 2018 17:18:20 +0300
Message-Id: <1524579504-30304-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1524579504-30304-1-git-send-email-nborisov@suse.com>
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that the initialization part and the critical section code have
been split it's a lot easier to open code add_delayed_tree_ref. Do
so in the following manner:

1. The commin init code is put immediately after memory-to-be-init is
allocate, followed by the ref-specific member initialization.

2. The only piece of code that remains in the critical section is
insert_delayed_ref call.

3. Tracing and memory freeing code is put outside of the critical
section as well.

The only real change here is an overall shorter critical section when
dealing with delayed tree refs. From functional point of view - the
code is unchanged.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 66 ++++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3ab2ba94d6f4..827ca01cf5af 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -696,49 +696,6 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
 }
 
 /*
- * helper to insert a delayed tree ref into the rbtree.
- */
-static noinline void
-add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
-		     struct btrfs_trans_handle *trans,
-		     struct btrfs_delayed_ref_head *head_ref,
-		     struct btrfs_delayed_ref_node *ref, u64 bytenr,
-		     u64 num_bytes, u64 parent, u64 ref_root, int level,
-		     int action)
-{
-	struct btrfs_delayed_tree_ref *full_ref;
-	struct btrfs_delayed_ref_root *delayed_refs;
-	u8 ref_type;
-	int ret;
-
-	delayed_refs = &trans->transaction->delayed_refs;
-	full_ref = btrfs_delayed_node_to_tree_ref(ref);
-	if (parent)
-	        ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
-	else
-	        ref_type = BTRFS_TREE_BLOCK_REF_KEY;
-
-	init_delayed_ref_common(fs_info, ref, bytenr, num_bytes, ref_root,
-				action, ref_type);
-	full_ref->root = ref_root;
-	full_ref->parent = parent;
-	full_ref->level = level;
-
-	trace_add_delayed_tree_ref(fs_info, ref, full_ref,
-				   action == BTRFS_ADD_DELAYED_EXTENT ?
-				   BTRFS_ADD_DELAYED_REF : action);
-
-	ret = insert_delayed_ref(trans, delayed_refs, head_ref, ref);
-
-	/*
-	 * XXX: memory should be freed at the same level allocated.
-	 * But bad practice is anywhere... Follow it now. Need cleanup.
-	 */
-	if (ret > 0)
-		kmem_cache_free(btrfs_delayed_tree_ref_cachep, full_ref);
-}
-
-/*
  * helper to insert a delayed data ref into the rbtree.
  */
 static noinline void
@@ -795,12 +752,25 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_qgroup_extent_record *record = NULL;
 	int qrecord_inserted;
 	int is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
+	int ret;
+	u8 ref_type = parent ? BTRFS_SHARED_BLOCK_REF_KEY :
+		BTRFS_TREE_BLOCK_REF_KEY;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
 	if (!ref)
 		return -ENOMEM;
 
+	if (parent)
+		ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
+	else
+		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
+	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+				ref_root, action, ref_type);
+	ref->root = ref_root;
+	ref->parent = parent;
+	ref->level = level;
+
 	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!head_ref)
 		goto free_ref;
@@ -826,10 +796,16 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 					is_system, &qrecord_inserted,
 					old_ref_mod, new_ref_mod);
 
-	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
-			     num_bytes, parent, ref_root, level, action);
+
+	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
 	spin_unlock(&delayed_refs->lock);
 
+	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
+				   action == BTRFS_ADD_DELAYED_EXTENT ?
+				   BTRFS_ADD_DELAYED_REF : action);
+	if (ret > 0)
+		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+
 	if (qrecord_inserted)
 		btrfs_qgroup_trace_extent_post(fs_info, record);
 
-- 
2.7.4

