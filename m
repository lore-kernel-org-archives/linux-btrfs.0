Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031479AbbD2Cb0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:26 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2UABX018336
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:10 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 10/18] btrfs: backref: Add special time_seq == (u64)-1 case for btrfs_find_all_roots().
Date: Wed, 29 Apr 2015 10:29:03 +0800
Message-ID: <1430274551-9277-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow btrfs_find_all_roots() to skip all delayed_ref_head lock and tree
lock to do tree search.

This is important for later qgroup implement which will call
find_all_roots() after fs trees are committed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/backref.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a4c31dc..ab9cc42 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -250,8 +250,12 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	 * the first item to check. But sometimes, we may enter it with
 	 * slot==nritems. In that case, go to the next leaf before we continue.
 	 */
-	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
-		ret = btrfs_next_old_leaf(root, path, time_seq);
+	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+		if (time_seq == (u64)-1)
+			ret = btrfs_next_leaf(root, path);
+		else
+			ret = btrfs_next_old_leaf(root, path, time_seq);
+	}
 
 	while (!ret && count < total_refs) {
 		eb = path->nodes[0];
@@ -291,7 +295,10 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			eie = NULL;
 		}
 next:
-		ret = btrfs_next_old_item(root, path, time_seq);
+		if (time_seq == (u64)-1)
+			ret = btrfs_next_item(root, path);
+		else
+			ret = btrfs_next_old_item(root, path, time_seq);
 	}
 
 	if (ret > 0)
@@ -334,6 +341,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	if (path->search_commit_root)
 		root_level = btrfs_header_level(root->commit_root);
+	else if (time_seq == (u64)-1)
+		root_level = btrfs_header_level(root->node);
 	else
 		root_level = btrfs_old_root_level(root, time_seq);
 
@@ -343,7 +352,12 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	path->lowest_level = level;
-	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
+	if (time_seq == (u64)-1)
+		ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path,
+					0, 0);
+	else
+		ret = btrfs_search_old_slot(root, &ref->key_for_search, path,
+					    time_seq);
 
 	/* root node has been locked, we can release @subvol_srcu safely here */
 	srcu_read_unlock(&fs_info->subvol_srcu, index);
@@ -875,6 +889,11 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  * indirect refs to their parent bytenr.
  * When roots are found, they're added to the roots list
  *
+ * If time_seq is set to (u64)-1, it will not search delayed_refs, and behave
+ * much like trans == NULL case, the difference only lies in it will not
+ * commit root.
+ * The special case is for qgroup to search roots in commit_transaction().
+ *
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
@@ -913,6 +932,9 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		path->skip_locking = 1;
 	}
 
+	if (time_seq == (u64)-1)
+		path->skip_locking = 1;
+
 	/*
 	 * grab both a lock on the path and a lock on the delayed ref head.
 	 * We need both to get a consistent picture of how the refs look
@@ -927,9 +949,10 @@ again:
 	BUG_ON(ret == 0);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (trans && likely(trans->type != __TRANS_DUMMY)) {
+	if (trans && likely(trans->type != __TRANS_DUMMY) &&
+	    time_seq != (u64)-1) {
 #else
-	if (trans) {
+	if (trans && time_seq != (u64)-1) {
 #endif
 		/*
 		 * look if there are updates for this ref queued and lock the
-- 
2.3.6

