Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33255 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab2GLJnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 12/15] Btrfs: hooks for qgroup to record delayed refs
Date: Thu, 12 Jul 2012 11:43:44 +0200
Message-Id: <546adb0d817c34dc2be3a7cb5bba8771f837a562.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hooks into qgroup code to record refs and into transaction commit.
This is the main entry point for qgroup. Basically every change in
extent backrefs got accounted to the appropriate qgroups.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/delayed-ref.c |   16 ++++++++++------
 fs/btrfs/delayed-ref.h |   19 +++++++++++++++++++
 fs/btrfs/transaction.c |    7 +++++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 21a7577..da7419e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -529,8 +529,8 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (is_fstree(ref_root))
-		seq = btrfs_inc_tree_mod_seq(fs_info);
+	if (need_ref_seq(for_cow, ref_root))
+		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
@@ -588,8 +588,8 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->is_head = 0;
 	ref->in_tree = 1;
 
-	if (is_fstree(ref_root))
-		seq = btrfs_inc_tree_mod_seq(fs_info);
+	if (need_ref_seq(for_cow, ref_root))
+		seq = btrfs_get_tree_mod_seq(fs_info, &trans->delayed_ref_elem);
 	ref->seq = seq;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
@@ -662,10 +662,12 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, level, action,
 				   for_cow);
-	if (!is_fstree(ref_root) &&
+	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&fs_info->tree_mod_seq_wait))
 		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
+	if (need_ref_seq(for_cow, ref_root))
+		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
 
 	return 0;
 }
@@ -711,10 +713,12 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, for_cow);
-	if (!is_fstree(ref_root) &&
+	if (!need_ref_seq(for_cow, ref_root) &&
 	    waitqueue_active(&fs_info->tree_mod_seq_wait))
 		wake_up(&fs_info->tree_mod_seq_wait);
 	spin_unlock(&delayed_refs->lock);
+	if (need_ref_seq(for_cow, ref_root))
+		btrfs_qgroup_record_ref(trans, &ref->node, extent_op);
 
 	return 0;
 }
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 2b5cb27..0d7c90c 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -180,6 +180,25 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 			    u64 seq);
 
 /*
+ * delayed refs with a ref_seq > 0 must be held back during backref walking.
+ * this only applies to items in one of the fs-trees. for_cow items never need
+ * to be held back, so they won't get a ref_seq number.
+ */
+static inline int need_ref_seq(int for_cow, u64 rootid)
+{
+	if (for_cow)
+		return 0;
+
+	if (rootid == BTRFS_FS_TREE_OBJECTID)
+		return 1;
+
+	if ((s64)rootid >= (s64)BTRFS_FIRST_FREE_OBJECTID)
+		return 1;
+
+	return 0;
+}
+
+/*
  * a node might live in a head or a regular ref, this lets you
  * test for the proper type to use.
  */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d20d2e2..21c768c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -795,6 +795,13 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_dev_stats(trans, root->fs_info);
 	BUG_ON(ret);
 
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

