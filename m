Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100AbbCWIKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89dTU012343
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 05/11] btrfs: backref: Allow btrfs_find_all_roots() to skip given ref_node.
Date: Mon, 23 Mar 2015 16:08:31 +0800
Message-ID: <1427098117-25152-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This feature is used in incoming qgroup patches to resolve whether a
given root has reference to a extent before the delayed_ref operation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 21 +++++++++++++--------
 fs/btrfs/backref.h |  6 ++++--
 fs/btrfs/ioctl.c   |  2 +-
 fs/btrfs/qgroup.c  | 10 +++++-----
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7db848c..e33a003 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1156,8 +1156,10 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  * returns 0 on success, < 0 on error.
  */
 static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info, u64 bytenr,
-				  u64 time_seq, struct ulist **roots,
+				  struct btrfs_fs_info *fs_info,
+				  struct btrfs_delayed_ref_node *node_to_skip,
+				  u64 bytenr, u64 time_seq,
+				  struct ulist **roots,
 				  int nolock)
 {
 	struct ulist *tmp;
@@ -1176,7 +1178,7 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, NULL, bytenr,
+		ret = find_parent_nodes(trans, fs_info, node_to_skip, bytenr,
 					time_seq, tmp, *roots, NULL, 0, 0,
 					nolock);
 		if (ret < 0 && ret != -ENOENT) {
@@ -1196,15 +1198,17 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots, int nolock)
+			 struct btrfs_fs_info *fs_info,
+			 struct btrfs_delayed_ref_node *node_to_skip,
+			 u64 bytenr, u64 time_seq,
+			 struct ulist **roots, int nolock)
 {
 	int ret;
 
 	if (!trans)
 		down_read(&fs_info->commit_root_sem);
-	ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots,
-				     nolock);
+	ret = __btrfs_find_all_roots(trans, fs_info, node_to_skip, bytenr,
+				     time_seq, roots, nolock);
 	if (!trans)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
@@ -1647,7 +1651,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
-		ret = __btrfs_find_all_roots(trans, fs_info, ref_node->val,
+		ret = __btrfs_find_all_roots(trans, fs_info, NULL,
+					     ref_node->val,
 					     tree_mod_seq_elem.seq, &roots, 0);
 		if (ret)
 			break;
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index f8acbd8..0b33483 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -52,8 +52,10 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots, int nolock);
+			 struct btrfs_fs_info *fs_info,
+			 struct btrfs_delayed_ref_node *node_to_skip,
+			 u64 bytenr, u64 time_seq, struct ulist **roots,
+			 int nolock);
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d3391df..fc8cee3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3049,7 +3049,7 @@ static int check_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		return 1;
 
 	btrfs_get_tree_mod_seq(root->fs_info, &tree_mod_seq_elem);
-	ret = btrfs_find_all_roots(trans, root->fs_info, disko,
+	ret = btrfs_find_all_roots(trans, root->fs_info, NULL, disko,
 				   tree_mod_seq_elem.seq, &roots, 0);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c01bc6f..9a94494 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1787,7 +1787,7 @@ static int check_existing_refs(struct btrfs_trans_handle *trans,
 	struct ulist_iterator uiter;
 	int ret = 0;
 
-	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
+	ret = btrfs_find_all_roots(trans, fs_info, NULL, oper->bytenr,
 				   oper->elem.seq, &roots, 0);
 	if (ret < 0)
 		return ret;
@@ -1878,7 +1878,7 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_get_tree_mod_seq(fs_info, &elem);
-	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr, elem.seq,
+	ret = btrfs_find_all_roots(trans, fs_info, NULL, oper->bytenr, elem.seq,
 				   &roots, 0);
 	btrfs_put_tree_mod_seq(fs_info, &elem);
 	if (ret < 0) {
@@ -1987,7 +1987,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	btrfs_get_tree_mod_seq(fs_info, &elem);
-	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
+	ret = btrfs_find_all_roots(trans, fs_info, NULL, oper->bytenr,
 				   elem.seq, &roots, 0);
 	btrfs_put_tree_mod_seq(fs_info, &elem);
 	if (ret < 0)
@@ -2589,8 +2589,8 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			num_bytes = found.offset;
 
 		ulist_reinit(qgroups);
-		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
-					   &roots, 0);
+		ret = btrfs_find_all_roots(NULL, fs_info, NULL, found.objectid,
+					   0, &roots, 0);
 		if (ret < 0)
 			goto out;
 		spin_lock(&fs_info->qgroup_lock);
-- 
2.3.3

