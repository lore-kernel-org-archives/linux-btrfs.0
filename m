Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3LZFLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 00:11:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBQ5BZ71004287
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Dec 2013 13:11:36 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 3/3] Btrfs: improve balance relocation with ENOSPC case
Date: Thu, 26 Dec 2013 13:10:51 +0800
Message-Id: <1388034651-2778-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1388034651-2778-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1388034651-2778-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previouly, we will try to merge reloc roots even if enospc
error happens, and this make merging process very slowly.

We improve ENOSPC case by two ways.

If we fail to reserve metadata space, we will skip merging relocation
roots, just do the cleanup work that drops relocation tree.

If error happens, @rc->merge_error will be set which will avoid
unnecessary relocation tree creation while we are still dropping relocation
tree.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 147 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 111 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9189f9e..b530ed9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -187,6 +187,7 @@ struct reloc_control {
 	unsigned int create_reloc_tree:1;
 	unsigned int merge_reloc_tree:1;
 	unsigned int found_file_extent:1;
+	unsigned int merge_error:1;
 };
 
 /* stages of data relocation */
@@ -2271,6 +2272,8 @@ again:
 	}
 
 	rc->merge_reloc_tree = 1;
+	if (err)
+		rc->merge_error = 1;
 
 	while (!list_empty(&rc->reloc_roots)) {
 		reloc_root = list_entry(rc->reloc_roots.next,
@@ -2288,6 +2291,8 @@ again:
 		 */
 		if (!err)
 			btrfs_set_root_refs(&reloc_root->root_item, 1);
+		else
+			btrfs_set_root_refs(&reloc_root->root_item, 0);
 		btrfs_update_reloc_root(trans, root);
 
 		list_add(&reloc_root->root_list, &reloc_roots);
@@ -2314,15 +2319,104 @@ void free_reloc_roots(struct list_head *list)
 	}
 }
 
+static int drop_relocation_tree(struct reloc_control *rc,
+			       struct btrfs_root *reloc_root)
+{
+	u64 last_snap;
+	u64 otransid;
+	u64 objectid;
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	/*
+	 * we keep the old last snapshod transid in rtranid when we
+	 * created the relocation tree.
+	 */
+	last_snap = btrfs_root_rtransid(&reloc_root->root_item);
+	otransid = btrfs_root_otransid(&reloc_root->root_item);
+	objectid = reloc_root->root_key.offset;
+
+	ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
+	if (ret)
+		return ret;
+	/*
+	 * recover the last snapshot tranid to avoid
+	 * the space balance break NOCOW.
+	 */
+	root = read_fs_root(rc->extent_root->fs_info,
+			    objectid);
+	if (IS_ERR(root))
+		return 0;
+
+	trans = btrfs_join_transaction(root);
+	ASSERT(!IS_ERR(trans));
+
+	/* Check if the fs/file tree was snapshoted or not. */
+	if (btrfs_root_last_snapshot(&root->root_item) ==
+	    otransid - 1)
+		btrfs_set_root_last_snapshot(&root->root_item,
+					     last_snap);
+	btrfs_end_transaction(trans, root);
+	return 0;
+}
+
+static noinline_for_stack
+int clean_reloc_roots(struct reloc_control *rc)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *reloc_root;
+	LIST_HEAD(reloc_roots);
+	int ret = 0;
+	root = rc->extent_root;
+
+	mutex_lock(&root->fs_info->reloc_mutex);
+	list_splice_init(&rc->reloc_roots, &reloc_roots);
+	mutex_unlock(&root->fs_info->reloc_mutex);
+
+	while (!list_empty(&reloc_roots)) {
+		reloc_root = list_entry(reloc_roots.next,
+					struct btrfs_root, root_list);
+		if (btrfs_root_refs(&reloc_root->root_item) > 0) {
+			root = read_fs_root(reloc_root->fs_info,
+					    reloc_root->root_key.offset);
+			ASSERT(!IS_ERR(root));
+			ASSERT(root->reloc_root == reloc_root);
+
+			mutex_lock(&root->fs_info->reloc_mutex);
+			root->reloc_root = NULL;
+			mutex_unlock(&root->fs_info->reloc_mutex);
+
+			__del_reloc_root(reloc_root);
+		} else {
+			list_del_init(&reloc_root->root_list);
+		}
+		ret = drop_relocation_tree(rc, reloc_root);
+		if (ret) {
+			if (list_empty(&reloc_root->root_list))
+				list_add_tail(&reloc_root->root_list,
+					      &reloc_roots);
+			goto out;
+		}
+	}
+
+out:
+	if (ret) {
+		btrfs_std_error(root->fs_info, ret);
+		if (!list_empty(&reloc_roots))
+			free_reloc_roots(&reloc_roots);
+	}
+
+	BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
+	return ret;
+}
+
+
 static noinline_for_stack
 int merge_reloc_roots(struct reloc_control *rc)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
-	u64 last_snap;
-	u64 otransid;
-	u64 objectid;
 	LIST_HEAD(reloc_roots);
 	int found = 0;
 	int ret = 0;
@@ -2360,41 +2454,12 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-
-		/*
-		 * we keep the old last snapshod transid in rtranid when we
-		 * created the relocation tree.
-		 */
-		last_snap = btrfs_root_rtransid(&reloc_root->root_item);
-		otransid = btrfs_root_otransid(&reloc_root->root_item);
-		objectid = reloc_root->root_key.offset;
-
-		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
-		if (ret < 0) {
+		ret = drop_relocation_tree(rc, reloc_root);
+		if (ret) {
 			if (list_empty(&reloc_root->root_list))
 				list_add_tail(&reloc_root->root_list,
 					      &reloc_roots);
 			goto out;
-		} else if (!ret) {
-			/*
-			 * recover the last snapshot tranid to avoid
-			 * the space balance break NOCOW.
-			 */
-			root = read_fs_root(rc->extent_root->fs_info,
-					    objectid);
-			if (IS_ERR(root))
-				continue;
-
-			trans = btrfs_join_transaction(root);
-			BUG_ON(IS_ERR(trans));
-
-			/* Check if the fs/file tree was snapshoted or not. */
-			if (btrfs_root_last_snapshot(&root->root_item) ==
-			    otransid - 1)
-				btrfs_set_root_last_snapshot(&root->root_item,
-							     last_snap);
-				
-			btrfs_end_transaction(trans, root);
 		}
 	}
 
@@ -3882,6 +3947,7 @@ int prepare_to_relocate(struct reloc_control *rc)
 			      RELOCATION_RESERVED_NODES;
 
 	rc->create_reloc_tree = 1;
+	rc->merge_error = 0;
 	set_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root);
@@ -4067,7 +4133,10 @@ restart:
 
 	err = prepare_to_merge(rc, err);
 
-	merge_reloc_roots(rc);
+	if (err)
+		clean_reloc_roots(rc);
+	else
+		merge_reloc_roots(rc);
 
 	rc->merge_reloc_tree = 0;
 	unset_reloc_control(rc);
@@ -4597,6 +4666,9 @@ void btrfs_reloc_pre_snapshot(struct btrfs_trans_handle *trans,
 	if (!rc->merge_reloc_tree)
 		return;
 
+	if (rc->merge_error)
+		return;
+
 	root = root->reloc_root;
 	BUG_ON(btrfs_root_refs(&root->root_item) == 0);
 	/*
@@ -4629,6 +4701,9 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 		return 0;
 
 	rc = root->fs_info->reloc_ctl;
+	if (rc->merge_error)
+		return 0;
+
 	rc->merging_rsv_size += rc->nodes_relocated;
 
 	if (rc->merge_reloc_tree) {
-- 
1.8.3.1

