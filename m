Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40618 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752197AbeBHDXW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:22 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C036948AE765
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:17 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 14/18] btrfs-progs: lowmem check: remove parameter @trans of repair_tree_back_ref()
Date: Thu, 8 Feb 2018 11:27:33 +0800
Message-ID: <20180208032737.31561-15-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
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
 check/mode-lowmem.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index a7660a25b844..d4c8de4e69af 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -544,11 +544,11 @@ static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
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
@@ -598,6 +598,16 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 	if (nrefs->full_backref[level] != 0)
 		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
+	ret = avoid_extents_overwrite(root->fs_info);
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
@@ -663,6 +673,8 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 
 	nrefs->refs[level]++;
 out:
+	if (trans)
+		btrfs_commit_transaction(trans, extent_root);
 	btrfs_release_path(&path);
 	if (ret) {
 		error(
@@ -4304,7 +4316,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 			   btrfs_header_owner(cur), nrefs);
 
 			if (repair && ret)
-				ret = repair_tree_block_ref(trans, root,
+				ret = repair_tree_block_ref(root,
 				    path->nodes[*level], nrefs, *level, ret);
 			err |= ret;
 
-- 
2.16.1



