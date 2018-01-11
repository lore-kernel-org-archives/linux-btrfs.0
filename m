Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45418 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932107AbeAKHbY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:24 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id ED85948AEA13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:22 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 15/17] btrfs-progs: lowmem check: remove parameter @trans of check_btrfs_root()
Date: Thu, 11 Jan 2018 15:35:09 +0800
Message-ID: <20180111073511.25288-16-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove parameters @trans of delete_extent_item() and
walk_down_tree_v2().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 473d5a13cf3b..1c93b1178b23 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2705,8 +2705,7 @@ static int check_leaf_items(struct btrfs_root *root, struct btrfs_path *path,
  * Returns <0  Fatal error, must exit the whole check
  * Returns 0   No errors found
  */
-static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, struct btrfs_path *path,
+static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 			     int *level, struct node_refs *nrefs, int ext_ref,
 			     int check_all)
 
@@ -6580,8 +6579,7 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
  * Returns 0      represents OK.
  * Returns > 0    represents error bits.
  */
-static int check_btrfs_root(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, unsigned int ext_ref,
+static int check_btrfs_root(struct btrfs_root *root, unsigned int ext_ref,
 			    int check_all)
 
 {
@@ -6627,8 +6625,8 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
-					ext_ref, check_all);
+		ret = walk_down_tree_v2(root, &path, &level, &nrefs, ext_ref,
+					check_all);
 		if (ret > 0)
 			err |= ret;
 
@@ -6663,7 +6661,7 @@ out:
 static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 {
 	reset_cached_block_groups(root->fs_info);
-	return check_btrfs_root(NULL, root, ext_ref, 0);
+	return check_btrfs_root(root, ext_ref, 0);
 }
 
 /*
@@ -13803,11 +13801,11 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
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
@@ -13838,7 +13836,7 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 			goto next;
 		}
 
-		ret = check_btrfs_root(trans, cur_root, 0, 1);
+		ret = check_btrfs_root(cur_root, 0, 1);
 		err |= ret;
 
 		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
-- 
2.15.1



