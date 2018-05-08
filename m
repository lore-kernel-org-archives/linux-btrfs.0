Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10780 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933158AbeEHIYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:37 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 12/16] btrfs-progs: lowmem: remove parameter @trans of repair_tree_back_ref()
Date: Tue, 8 May 2018 16:30:08 +0800
Message-ID: <20180508083012.12090-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of repair_tree_back_ref().
It calls try_avoid_extents_overwrite() and starts a transaction by
itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
Such error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index ed7b125208a1..8ae9a1027ae5 100644
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
@@ -4365,7 +4377,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 			   btrfs_header_owner(cur), nrefs);
 
 			if (repair && ret)
-				ret = repair_tree_block_ref(trans, root,
+				ret = repair_tree_block_ref(root,
 				    path->nodes[*level], nrefs, *level, ret);
 			err |= ret;
 
-- 
2.17.0



