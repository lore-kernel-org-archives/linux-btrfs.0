From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 15/18] btrfs: hooks for qgroup to record delayed refs
Date: Thu,  6 Oct 2011 17:54:25 +0200
Message-ID: <4babf3a9c71db71fc08ac5072c8d9f2d8c552709.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hooks into qgroup code to record refs and into transaction commit.
This is the main entry point for qgroup. Basically every change in
extent backrefs got accounted to the appropriate qgroups.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/delayed-ref.c |   24 ++++++++++++++++++------
 fs/btrfs/transaction.c |    7 +++++++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index d6f934f..bd74b7a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -442,11 +442,12 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
  */
 static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 					struct btrfs_trans_handle *trans,
-					struct btrfs_delayed_ref_node *ref,
+					struct btrfs_delayed_ref_node **pref,
 					u64 bytenr, u64 num_bytes,
 					int action, int is_data)
 {
 	struct btrfs_delayed_ref_node *existing;
+	struct btrfs_delayed_ref_node *ref = *pref;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int count_mod = 1;
@@ -503,6 +504,7 @@ static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 
 	if (existing) {
 		update_existing_head_ref(existing, ref);
+		*pref = existing;
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
@@ -654,6 +656,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
 	struct seq_list seq_elem;
@@ -678,7 +681,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	node = &head_ref->node;
+	ret = add_delayed_ref_head(fs_info, trans, &node, bytenr,
 				   num_bytes, action, 0);
 	BUG_ON(ret);
 
@@ -687,8 +691,10 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 				   for_cow, &seq_elem);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
-	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root)) {
+		btrfs_qgroup_record_ref(trans, fs_info, &ref->node, extent_op);
 		put_delayed_seq(delayed_refs, &seq_elem);
+	}
 
 	return 0;
 }
@@ -706,6 +712,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
 	struct seq_list seq_elem;
@@ -730,7 +737,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	node = &head_ref->node;
+	ret = add_delayed_ref_head(fs_info, trans, &node, bytenr,
 				   num_bytes, action, 1);
 	BUG_ON(ret);
 
@@ -739,8 +747,10 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 				   action, for_cow, &seq_elem);
 	BUG_ON(ret);
 	spin_unlock(&delayed_refs->lock);
-	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root))
+	if (fs_info->quota_enabled && !for_cow && is_fstree(ref_root)) {
+		btrfs_qgroup_record_ref(trans, fs_info, &ref->node, extent_op);
 		put_delayed_seq(delayed_refs, &seq_elem);
+	}
 
 	return 0;
 }
@@ -751,6 +761,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_delayed_ref_head *head_ref;
+	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
 
@@ -763,7 +774,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	ret = add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
+	node = &head_ref->node;
+	ret = add_delayed_ref_head(fs_info, trans, &node, bytenr,
 				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
 				   extent_op->is_data);
 	BUG_ON(ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c8642a7..1ae856e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -765,6 +765,13 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
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

