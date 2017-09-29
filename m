Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34200 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752548AbdI2To0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:26 -0400
Received: by mail-qk0-f196.google.com with SMTP id d70so411987qkc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:26 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 12/21] btrfs: move all ref head cleanup to the helper function
Date: Fri, 29 Sep 2017 15:43:56 -0400
Message-Id: <1506714245-23072-13-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We do a couple different cleanup operations on the ref head.  We adjust
counters, we'll free any reserved space if we didn't end up using the
ref, and we clear the pending csum bytes.  Move all these disparate
things into cleanup_ref_head and clean up the logic in
__btrfs_run_delayed_refs so that it handles the !ref case a lot cleaner,
as well as making run_one_delayed_ref() only deal with real refs and not
the ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 144 ++++++++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 80 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ac1196af6b7e..260414bd86e7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2501,44 +2501,6 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	if (btrfs_delayed_ref_is_head(node)) {
-		struct btrfs_delayed_ref_head *head;
-		/*
-		 * we've hit the end of the chain and we were supposed
-		 * to insert this extent into the tree.  But, it got
-		 * deleted before we ever needed to insert it, so all
-		 * we have to do is clean up the accounting
-		 */
-		BUG_ON(extent_op);
-		head = btrfs_delayed_node_to_head(node);
-		trace_run_delayed_ref_head(fs_info, node, head, node->action);
-
-		if (head->total_ref_mod < 0) {
-			struct btrfs_block_group_cache *cache;
-
-			cache = btrfs_lookup_block_group(fs_info, node->bytenr);
-			ASSERT(cache);
-			percpu_counter_add(&cache->space_info->total_bytes_pinned,
-					   -node->num_bytes);
-			btrfs_put_block_group(cache);
-		}
-
-		if (insert_reserved) {
-			btrfs_pin_extent(fs_info, node->bytenr,
-					 node->num_bytes, 1);
-			if (head->is_data) {
-				ret = btrfs_del_csums(trans, fs_info,
-						      node->bytenr,
-						      node->num_bytes);
-			}
-		}
-
-		/* Also free its reserved qgroup space */
-		btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
-					      head->qgroup_reserved);
-		return ret;
-	}
-
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
 		ret = run_delayed_tree_ref(trans, fs_info, node, extent_op,
@@ -2641,6 +2603,43 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 	delayed_refs->num_heads--;
 	rb_erase(&head->href_node, &delayed_refs->href_root);
 	spin_unlock(&delayed_refs->lock);
+	spin_unlock(&head->lock);
+	atomic_dec(&delayed_refs->num_entries);
+
+	trace_run_delayed_ref_head(fs_info, &head->node, head,
+				   head->node.action);
+
+	if (head->total_ref_mod < 0) {
+		struct btrfs_block_group_cache *cache;
+
+		cache = btrfs_lookup_block_group(fs_info, head->node.bytenr);
+		ASSERT(cache);
+		percpu_counter_add(&cache->space_info->total_bytes_pinned,
+				   -head->node.num_bytes);
+		btrfs_put_block_group(cache);
+
+		if (head->is_data) {
+			spin_lock(&delayed_refs->lock);
+			delayed_refs->pending_csums -= head->node.num_bytes;
+			spin_unlock(&delayed_refs->lock);
+		}
+	}
+
+	if (head->must_insert_reserved) {
+		btrfs_pin_extent(fs_info, head->node.bytenr,
+				 head->node.num_bytes, 1);
+		if (head->is_data) {
+			ret = btrfs_del_csums(trans, fs_info,
+					      head->node.bytenr,
+					      head->node.num_bytes);
+		}
+	}
+
+	/* Also free its reserved qgroup space */
+	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
+				      head->qgroup_reserved);
+	btrfs_delayed_ref_unlock(head);
+	btrfs_put_delayed_ref(&head->node);
 	return 0;
 }
 
@@ -2724,6 +2723,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
+		/*
+		 * We're done processing refs in this ref_head, clean everything
+		 * up and move on to the next ref_head.
+		 */
 		if (!ref) {
 			ret = cleanup_ref_head(trans, fs_info, locked_ref);
 			if (ret > 0 ) {
@@ -2733,33 +2736,30 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			} else if (ret) {
 				return ret;
 			}
+			locked_ref = NULL;
+			count++;
+			continue;
+		}
 
-			/* All delayed refs have been processed, Go ahead
-			 * and send the head node to run_one_delayed_ref,
-			 * so that any accounting fixes can happen
-			 */
-			ref = &locked_ref->node;
-		} else {
-			actual_count++;
-			ref->in_tree = 0;
-			list_del(&ref->list);
-			if (!list_empty(&ref->add_list))
-				list_del(&ref->add_list);
-			/*
-			 * when we play the delayed ref, also correct the
-			 * ref_mod on head
-			 */
-			switch (ref->action) {
-			case BTRFS_ADD_DELAYED_REF:
-			case BTRFS_ADD_DELAYED_EXTENT:
-				locked_ref->node.ref_mod -= ref->ref_mod;
-				break;
-			case BTRFS_DROP_DELAYED_REF:
-				locked_ref->node.ref_mod += ref->ref_mod;
-				break;
-			default:
-				WARN_ON(1);
-			}
+		actual_count++;
+		ref->in_tree = 0;
+		list_del(&ref->list);
+		if (!list_empty(&ref->add_list))
+			list_del(&ref->add_list);
+		/*
+		 * when we play the delayed ref, also correct the
+		 * ref_mod on head
+		 */
+		switch (ref->action) {
+		case BTRFS_ADD_DELAYED_REF:
+		case BTRFS_ADD_DELAYED_EXTENT:
+			locked_ref->node.ref_mod -= ref->ref_mod;
+			break;
+		case BTRFS_DROP_DELAYED_REF:
+			locked_ref->node.ref_mod += ref->ref_mod;
+			break;
+		default:
+			WARN_ON(1);
 		}
 		atomic_dec(&delayed_refs->num_entries);
 
@@ -2786,22 +2786,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			return ret;
 		}
 
-		/*
-		 * If this node is a head, that means all the refs in this head
-		 * have been dealt with, and we will pick the next head to deal
-		 * with, so we must unlock the head and drop it from the cluster
-		 * list before we release it.
-		 */
-		if (btrfs_delayed_ref_is_head(ref)) {
-			if (locked_ref->is_data &&
-			    locked_ref->total_ref_mod < 0) {
-				spin_lock(&delayed_refs->lock);
-				delayed_refs->pending_csums -= ref->num_bytes;
-				spin_unlock(&delayed_refs->lock);
-			}
-			btrfs_delayed_ref_unlock(locked_ref);
-			locked_ref = NULL;
-		}
 		btrfs_put_delayed_ref(ref);
 		count++;
 		cond_resched();
-- 
2.7.4

