Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34741 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab2HGT44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Aug 2012 15:56:56 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id L0ysTri4Er3R1HZC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 07 Aug 2012 13:56:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: allow delayed refs to be merged V3
Date: Tue, 7 Aug 2012 16:01:59 -0400
Message-ID: <1344369719-32739-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Blueman reported a bug with fio+balance on a ramdisk setup.
Basically what happens is the balance relocates a tree block which will drop
the implicit refs for all of its children and adds a full backref.  Once the
block is relocated we have to add the implicit refs back, so when we cow the
block again we add the implicit refs for its children back.  The problem
comes when the original drop ref doesn't get run before we add the implicit
refs back.  The delayed ref stuff will specifically prefer ADD operations
over DROP to keep us from freeing up an extent that will have references to
it, so we try to add the implicit ref before it is actually removed and we
panic.  This worked fine before because the add would have just canceled the
drop out and we would have been fine.  But the backref walking work needs to
be able to freeze the delayed ref stuff in time so we have this ever
increasing sequence number that gets attached to all new delayed ref updates
which makes us not merge refs and we run into this issue.

So to fix this we need to merge delayed refs.  So everytime we run a
clustered ref we need to try and merge all of its delayed refs.  The backref
walking stuff locks the delayed ref head before processing, so if we have it
locked we are safe to merge any refs inside of the sequence number.  If
there is no sequence number we can merge all refs.  Doing this not only
fixes our bug but keeps the delayed ref code from adding and removing
useless refs and batching together multiple refs into one search instead of
one search per delayed ref, which will really help our commit times.  I ran
this with Daniels test and 276 and I haven't seen any problems.  Thanks,

Reported-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V2->V3: update it to work with the new tree mod stuff
 fs/btrfs/delayed-ref.c |  155 +++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/delayed-ref.h |    4 +
 fs/btrfs/extent-tree.c |   10 +++
 3 files changed, 142 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7561431..ae94117 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -38,17 +38,14 @@
 static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
 			  struct btrfs_delayed_tree_ref *ref1)
 {
-	if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
-		if (ref1->root < ref2->root)
-			return -1;
-		if (ref1->root > ref2->root)
-			return 1;
-	} else {
-		if (ref1->parent < ref2->parent)
-			return -1;
-		if (ref1->parent > ref2->parent)
-			return 1;
-	}
+	if (ref1->root < ref2->root)
+		return -1;
+	if (ref1->root > ref2->root)
+		return 1;
+	if (ref1->parent < ref2->parent)
+		return -1;
+	if (ref1->parent > ref2->parent)
+		return 1;
 	return 0;
 }
 
@@ -85,7 +82,8 @@ static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
  * type of the delayed backrefs and content of delayed backrefs.
  */
 static int comp_entry(struct btrfs_delayed_ref_node *ref2,
-		      struct btrfs_delayed_ref_node *ref1)
+		      struct btrfs_delayed_ref_node *ref1,
+		      bool compare_seq)
 {
 	if (ref1->bytenr < ref2->bytenr)
 		return -1;
@@ -102,10 +100,12 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 	if (ref1->type > ref2->type)
 		return 1;
 	/* merging of sequenced refs is not allowed */
-	if (ref1->seq < ref2->seq)
-		return -1;
-	if (ref1->seq > ref2->seq)
-		return 1;
+	if (compare_seq) {
+		if (ref1->seq < ref2->seq)
+			return -1;
+		if (ref1->seq > ref2->seq)
+			return 1;
+	}
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
@@ -139,7 +139,7 @@ static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
 		entry = rb_entry(parent_node, struct btrfs_delayed_ref_node,
 				 rb_node);
 
-		cmp = comp_entry(entry, ins);
+		cmp = comp_entry(entry, ins, 1);
 		if (cmp < 0)
 			p = &(*p)->rb_left;
 		else if (cmp > 0)
@@ -233,6 +233,114 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void inline drop_delayed_ref(struct btrfs_trans_handle *trans,
+				    struct btrfs_delayed_ref_root *delayed_refs,
+				    struct btrfs_delayed_ref_node *ref)
+{
+	rb_erase(&ref->rb_node, &delayed_refs->root);
+	ref->in_tree = 0;
+	btrfs_put_delayed_ref(ref);
+	delayed_refs->num_entries--;
+	if (trans->delayed_ref_updates)
+		trans->delayed_ref_updates--;
+}
+
+static int merge_ref(struct btrfs_trans_handle *trans,
+		     struct btrfs_delayed_ref_root *delayed_refs,
+		     struct btrfs_delayed_ref_node *ref, u64 seq)
+{
+	struct rb_node *node;
+	int merged = 0;
+	int mod = 0;
+	int done = 0;
+
+	node = rb_prev(&ref->rb_node);
+	while (node) {
+		struct btrfs_delayed_ref_node *next;
+
+		next = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
+		node = rb_prev(node);
+		if (next->bytenr != ref->bytenr)
+			break;
+		if (seq && next->seq >= seq)
+			break;
+		if (comp_entry(ref, next, 0))
+			continue;
+
+		if (ref->action == next->action) {
+			mod = next->ref_mod;
+		} else {
+			if (ref->ref_mod < next->ref_mod) {
+				struct btrfs_delayed_ref_node *tmp;
+
+				tmp = ref;
+				ref = next;
+				next = tmp;
+				done = 1;
+			}
+			mod = -next->ref_mod;
+		}
+
+		merged++;
+		drop_delayed_ref(trans, delayed_refs, next);
+		ref->ref_mod += mod;
+		if (ref->ref_mod == 0) {
+			drop_delayed_ref(trans, delayed_refs, ref);
+			break;
+		} else {
+			/*
+			 * You can't have multiples of the same ref on a tree
+			 * block.
+			 */
+			WARN_ON(ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
+				ref->type == BTRFS_SHARED_BLOCK_REF_KEY);
+		}
+
+		if (done)
+			break;
+		node = rb_prev(&ref->rb_node);
+	}
+
+	return merged;
+}
+
+void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info,
+			      struct btrfs_delayed_ref_root *delayed_refs,
+			      struct btrfs_delayed_ref_head *head)
+{
+	struct rb_node *node;
+	u64 seq = 0;
+
+	spin_lock(&fs_info->tree_mod_seq_lock);
+	if (!list_empty(&fs_info->tree_mod_seq_list)) {
+		struct seq_list *elem;
+
+		elem = list_first_entry(&fs_info->tree_mod_seq_list,
+					struct seq_list, list);
+		seq = elem->seq;
+	}
+	spin_unlock(&fs_info->tree_mod_seq_lock);
+
+	node = rb_prev(&head->node.rb_node);
+	while (node) {
+		struct btrfs_delayed_ref_node *ref;
+
+		ref = rb_entry(node, struct btrfs_delayed_ref_node,
+			       rb_node);
+		if (ref->bytenr != head->node.bytenr)
+			break;
+
+		/* We can't merge refs that are outside of our seq count */
+		if (seq && ref->seq >= seq)
+			break;
+		if (merge_ref(trans, delayed_refs, ref, seq))
+			node = rb_prev(&head->node.rb_node);
+		else
+			node = rb_prev(node);
+	}
+}
+
 int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 seq)
@@ -336,18 +444,11 @@ update_existing_ref(struct btrfs_trans_handle *trans,
 		 * every changing the extent allocation tree.
 		 */
 		existing->ref_mod--;
-		if (existing->ref_mod == 0) {
-			rb_erase(&existing->rb_node,
-				 &delayed_refs->root);
-			existing->in_tree = 0;
-			btrfs_put_delayed_ref(existing);
-			delayed_refs->num_entries--;
-			if (trans->delayed_ref_updates)
-				trans->delayed_ref_updates--;
-		} else {
+		if (existing->ref_mod == 0)
+			drop_delayed_ref(trans, delayed_refs, existing);
+		else
 			WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
 				existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
-		}
 	} else {
 		WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
 			existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 0d7c90c..ab53005 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -167,6 +167,10 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
 				struct btrfs_delayed_extent_op *extent_op);
+void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info,
+			      struct btrfs_delayed_ref_root *delayed_refs,
+			      struct btrfs_delayed_ref_head *head);
 
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1bb408f..ce494b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2252,6 +2252,16 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		}
 
 		/*
+		 * We need to try and merge add/drops of the same ref since we
+		 * can run into issues with relocate dropping the implicit ref
+		 * and then it being added back again before the drop can
+		 * finish.  If we merged anything we need to re-loop so we can
+		 * get a good ref.
+		 */
+		btrfs_merge_delayed_refs(trans, fs_info, delayed_refs,
+					 locked_ref);
+
+		/*
 		 * locked_ref is the head node, so we have to go one
 		 * node back for any delayed ref updates
 		 */
-- 
1.7.7.6

