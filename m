Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933155AbeEHIYg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:36 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 13/16] btrfs-progs: lowmem: remove parameter @trans of check_btrfs_root()
Date: Tue, 8 May 2018 16:30:09 +0800
Message-ID: <20180508083012.12090-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove parameters @trans of delete_extent_item() and walk_down_tree_v2().

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
Such error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 8ae9a1027ae5..babbe60fd92c 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4332,8 +4332,7 @@ out:
  * Returns <0  Fatal error, must exit the whole check
  * Returns 0   No errors found
  */
-static int walk_down_tree(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
+static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			  int *level, struct node_refs *nrefs, int ext_ref,
 			  int check_all)
 {
@@ -4646,8 +4645,7 @@ out:
  * Returns 0      represents OK.
  * Returns >0     represents error bits.
  */
-static int check_btrfs_root(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, unsigned int ext_ref,
+static int check_btrfs_root(struct btrfs_root *root, unsigned int ext_ref,
 			    int check_all)
 {
 	struct btrfs_path path;
@@ -4692,7 +4690,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		ret = walk_down_tree(trans, root, &path, &level, &nrefs,
+		ret = walk_down_tree(root, &path, &level, &nrefs,
 				     ext_ref, check_all);
 
 		if (ret > 0)
@@ -4728,7 +4726,7 @@ out:
 static int check_fs_root(struct btrfs_root *root, unsigned int ext_ref)
 {
 	reset_cached_block_groups(root->fs_info);
-	return check_btrfs_root(NULL, root, ext_ref, 0);
+	return check_btrfs_root(root, ext_ref, 0);
 }
 
 /*
@@ -4932,11 +4930,11 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 	}
 
 	root1 = root->fs_info->chunk_root;
-	ret = check_btrfs_root(trans, root1, 0, 1);
+	ret = check_btrfs_root(root1, 0, 1);
 	err |= ret;
 
 	root1 = root->fs_info->tree_root;
-	ret = check_btrfs_root(trans, root1, 0, 1);
+	ret = check_btrfs_root(root1, 0, 1);
 	err |= ret;
 
 	btrfs_init_path(&path);
@@ -4967,7 +4965,7 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 			goto next;
 		}
 
-		ret = check_btrfs_root(trans, cur_root, 0, 1);
+		ret = check_btrfs_root(cur_root, 0, 1);
 		err |= ret;
 
 		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
-- 
2.17.0



