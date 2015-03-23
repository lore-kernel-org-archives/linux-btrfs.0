Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57975 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbbCWIKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:41 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89bM6012333
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 03/11] btrfs: backref: Add nolock option for btrfs_find_all_roots().
Date: Mon, 23 Mar 2015 16:08:29 +0800
Message-ID: <1427098117-25152-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the "nolock" option for btrfs_find_all_roots().
This will allow btrfs_find_all_roots() to be called in
btrfs_qgroup_record_ref(), which will provide the basis for coming
qgroup patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 28 ++++++++++++++++++----------
 fs/btrfs/backref.h |  2 +-
 fs/btrfs/ioctl.c   |  2 +-
 fs/btrfs/qgroup.c  |  8 ++++----
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f55721f..6ef355e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -880,13 +880,16 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  * indirect refs to their parent bytenr.
  * When roots are found, they're added to the roots list
  *
+ * If nolock is set, it will consider the ref_head already locked and don't
+ * try to lock it.
+ *
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 time_seq, struct ulist *refs,
 			     struct ulist *roots, const u64 *extent_item_pos,
-			     u64 root_objectid, u64 inum)
+			     u64 root_objectid, u64 inum, int nolock)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -944,7 +947,7 @@ again:
 		spin_lock(&delayed_refs->lock);
 		head = btrfs_find_delayed_ref_head(trans, bytenr);
 		if (head) {
-			if (!mutex_trylock(&head->mutex)) {
+			if (!nolock && !mutex_trylock(&head->mutex)) {
 				atomic_inc(&head->node.refs);
 				spin_unlock(&delayed_refs->lock);
 
@@ -963,7 +966,8 @@ again:
 			ret = __add_delayed_refs(head, time_seq,
 						 &prefs_delayed, &total_refs,
 						 inum);
-			mutex_unlock(&head->mutex);
+			if (!nolock)
+				mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
 		} else {
@@ -1124,7 +1128,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = find_parent_nodes(trans, fs_info, bytenr,
-				time_seq, *leafs, NULL, extent_item_pos, 0, 0);
+				time_seq, *leafs, NULL, extent_item_pos,
+				0, 0, 0);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
@@ -1148,7 +1153,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info, u64 bytenr,
-				  u64 time_seq, struct ulist **roots)
+				  u64 time_seq, struct ulist **roots,
+				  int nolock)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1167,7 +1173,8 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr,
-					time_seq, tmp, *roots, NULL, 0, 0);
+					time_seq, tmp, *roots, NULL, 0, 0,
+					nolock);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1186,13 +1193,14 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots)
+			 u64 time_seq, struct ulist **roots, int nolock)
 {
 	int ret;
 
 	if (!trans)
 		down_read(&fs_info->commit_root_sem);
-	ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots);
+	ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots,
+				     nolock);
 	if (!trans)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
@@ -1224,7 +1232,7 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
-					roots, NULL, root_objectid, inum);
+					roots, NULL, root_objectid, inum, 0);
 		if (ret == BACKREF_FOUND_SHARED) {
 			ret = 1;
 			break;
@@ -1635,7 +1643,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = __btrfs_find_all_roots(trans, fs_info, ref_node->val,
-					     tree_mod_seq_elem.seq, &roots);
+					     tree_mod_seq_elem.seq, &roots, 0);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 9c41fba..f8acbd8 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -53,7 +53,7 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots);
+			 u64 time_seq, struct ulist **roots, int nolock);
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 74609b9..d3391df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3050,7 +3050,7 @@ static int check_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	btrfs_get_tree_mod_seq(root->fs_info, &tree_mod_seq_elem);
 	ret = btrfs_find_all_roots(trans, root->fs_info, disko,
-				   tree_mod_seq_elem.seq, &roots);
+				   tree_mod_seq_elem.seq, &roots, 0);
 	if (ret < 0)
 		goto out;
 	ret = 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6e7735d..c01bc6f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1788,7 +1788,7 @@ static int check_existing_refs(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
-				   oper->elem.seq, &roots);
+				   oper->elem.seq, &roots, 0);
 	if (ret < 0)
 		return ret;
 	ret = 0;
@@ -1879,7 +1879,7 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 
 	btrfs_get_tree_mod_seq(fs_info, &elem);
 	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr, elem.seq,
-				   &roots);
+				   &roots, 0);
 	btrfs_put_tree_mod_seq(fs_info, &elem);
 	if (ret < 0) {
 		ulist_free(qgroups);
@@ -1988,7 +1988,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 
 	btrfs_get_tree_mod_seq(fs_info, &elem);
 	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
-				   elem.seq, &roots);
+				   elem.seq, &roots, 0);
 	btrfs_put_tree_mod_seq(fs_info, &elem);
 	if (ret < 0)
 		goto out;
@@ -2590,7 +2590,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 
 		ulist_reinit(qgroups);
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
-					   &roots);
+					   &roots, 0);
 		if (ret < 0)
 			goto out;
 		spin_lock(&fs_info->qgroup_lock);
-- 
2.3.3

