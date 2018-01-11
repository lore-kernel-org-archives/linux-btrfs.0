Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:53400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753959AbeAKHbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:13 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 99E2649F0F85
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:12 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 10/17] btrfs-progs: lowmem check: remove parameter @trans of delete_extent_item()
Date: Thu, 11 Jan 2018 15:35:04 +0800
Message-ID: <20180111073511.25288-11-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the parameter @trans of delete_extent_item().
It calls try_avoid_extents_overwrite() and starts a transaction by itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index cd8b6ed3898f..aebae43c1fa7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13492,13 +13492,22 @@ out:
 	return err;
 }
 
-static int delete_extent_tree_item(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
+static int delete_extent_tree_item(struct btrfs_root *root,
 				   struct btrfs_path *path)
 {
 	struct btrfs_key key;
+	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
+	ret = try_avoid_extents_overwrite(root->fs_info);
+	if (ret)
+		return ret;
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("fail to start transaction %s", strerror(-ret));
+		goto out;
+	}
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
@@ -13516,6 +13525,7 @@ static int delete_extent_tree_item(struct btrfs_trans_handle *trans,
 	else
 		path->slots[0]--;
 out:
+	btrfs_commit_transaction(trans, root);
 	if (ret)
 		error("failed to delete root %llu item[%llu, %u, %llu]",
 		      root->objectid, key.objectid, key.type, key.offset);
@@ -13567,7 +13577,7 @@ again:
 		ret = check_block_group_item(fs_info, eb, slot);
 		if (repair &&
 		    ret & REFERENCER_MISSING)
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -13598,7 +13608,7 @@ again:
 					       key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -13611,7 +13621,7 @@ again:
 				btrfs_extent_data_ref_count(eb, dref));
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
@@ -13619,7 +13629,7 @@ again:
 						 key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
@@ -13627,7 +13637,7 @@ again:
 						key.objectid);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	default:
-- 
2.15.1



