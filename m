Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33916 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2ETQGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 21/24] Btrfs: hooks for qgroup to record delayed refs
Date: Sun, 20 May 2012 18:06:32 +0200
Message-Id: <5a157ca30d4f87fdb0e575635282dc7189987f8f.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Hooks into qgroup code to record refs and into transaction commit.
This is the main entry point for qgroup. Basically every change in
extent backrefs got accounted to the appropriate qgroups.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/delayed-ref.c |   29 +++++++++++++++++++++++------
 fs/btrfs/transaction.c |    7 +++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 69f22e3..fe07753 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -504,7 +504,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
 					 u64 ref_root, int level, int action,
-					 int for_cow)
+					 int for_cow, struct seq_list *seq_elem)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
@@ -525,8 +525,10 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (need_ref_seq(for_cow, ref_root))
+	if (need_ref_seq(for_cow, ref_root)) {
+		btrfs_get_delayed_seq(delayed_refs, seq_elem);
 		seq = inc_delayed_seq(delayed_refs);
+	}
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
@@ -563,7 +565,8 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 					 struct btrfs_delayed_ref_node *ref,
 					 u64 bytenr, u64 num_bytes, u64 parent,
 					 u64 ref_root, u64 owner, u64 offset,
-					 int action, int for_cow)
+					 int action, int for_cow,
+					 struct seq_list *seq_elem)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_data_ref *full_ref;
@@ -584,8 +587,10 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (need_ref_seq(for_cow, ref_root))
+	if (need_ref_seq(for_cow, ref_root)) {
+		btrfs_get_delayed_seq(delayed_refs, seq_elem);
 		seq = inc_delayed_seq(delayed_refs);
+	}
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
@@ -631,6 +636,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct seq_list seq_elem;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -657,11 +663,16 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 
 	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
-				   for_cow);
+				   for_cow, &seq_elem);
 	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&delayed_refs->seq_wait))
 		wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
+	if (need_ref_seq(for_cow, ref_root)) {
+		btrfs_qgroup_record_ref(trans, fs_info, &ref->node, extent_op);
+		btrfs_put_delayed_seq(delayed_refs, &seq_elem);
+	}
+
 	return 0;
 }
 
@@ -679,6 +690,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct seq_list seq_elem;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -705,11 +717,16 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 
 	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
-				   action, for_cow);
+				   action, for_cow, &seq_elem);
 	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&delayed_refs->seq_wait))
 		wake_up(&delayed_refs->seq_wait);
 	spin_unlock(&delayed_refs->lock);
+	if (need_ref_seq(for_cow, ref_root)) {
+		btrfs_qgroup_record_ref(trans, fs_info, &ref->node, extent_op);
+		btrfs_put_delayed_seq(delayed_refs, &seq_elem);
+	}
+
 	return 0;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cde906f..2a5e75c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -774,6 +774,13 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
+	ret = btrfs_run_qgroups(trans, root->fs_info);
+	BUG_ON(ret);
+
+	/* run_qgroups might have added some more refs */
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	BUG_ON(ret);
+
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
-- 
1.7.3.4

