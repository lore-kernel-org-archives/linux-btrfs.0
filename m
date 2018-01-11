Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45418 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932163AbeAKHb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:26 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id B947548AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:20 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 14/17] btrfs-progs: lowmem check: remove parameter @trans of repair_tree_back_ref()
Date: Thu, 11 Jan 2018 15:35:08 +0800
Message-ID: <20180111073511.25288-15-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of repair_tree_back_ref().
It calls try_avoid_extents_overwrite() and starts a transaction by
itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a45bb7c61deb..473d5a13cf3b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2534,6 +2534,7 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
 	}
 }
 
+static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info);
 /*
  * This function only handles BACKREF_MISSING,
  * If corresponding extent item exists, increase the ref, else insert an extent
@@ -2541,11 +2542,11 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
  *
  * Returns error bits after repair.
  */
-static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+static int repair_tree_block_ref(struct btrfs_root *root,
 				 struct extent_buffer *node,
 				 struct node_refs *nrefs, int level, int err)
 {
+	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_path path;
@@ -2595,6 +2596,16 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 	if (nrefs->full_backref[level] != 0)
 		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
+	ret = try_avoid_extents_overwrite(root->fs_info);
+	if (ret)
+		goto out;
+	trans = btrfs_start_transaction(extent_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		error("fail to start transaction %s", strerror(-ret));
+		goto out;
+	}
 	/* insert an extent item */
 	if (insert_extent) {
 		struct btrfs_disk_key copy_key;
@@ -2660,6 +2671,8 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 
 	nrefs->refs[level]++;
 out:
+	if (trans)
+		btrfs_commit_transaction(trans, extent_root);
 	btrfs_release_path(&path);
 	if (ret) {
 		error(
@@ -2738,7 +2751,7 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 			   btrfs_header_owner(cur), nrefs);
 
 			if (repair && ret)
-				ret = repair_tree_block_ref(trans, root,
+				ret = repair_tree_block_ref(root,
 				    path->nodes[*level], nrefs, *level, ret);
 			err |= ret;
 
-- 
2.15.1



