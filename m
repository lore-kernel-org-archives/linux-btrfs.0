Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17266 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754468AbdLTExr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:47 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 10/17] btrfs-progs: lowmem check: remove parameter @trans of delete_extent_item()
Date: Wed, 20 Dec 2017 12:57:24 +0800
Message-ID: <20171220045731.19343-11-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
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
index 20bf3d230946..f1ab93550bc5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13392,13 +13392,22 @@ out:
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
@@ -13416,6 +13425,7 @@ static int delete_extent_tree_item(struct btrfs_trans_handle *trans,
 	else
 		path->slots[0]--;
 out:
+	btrfs_commit_transaction(trans, root);
 	if (ret)
 		error("failed to delete root %llu item[%llu, %u, %llu]",
 		      root->objectid, key.objectid, key.type, key.offset);
@@ -13467,7 +13477,7 @@ again:
 		ret = check_block_group_item(fs_info, eb, slot);
 		if (repair &&
 		    ret & REFERENCER_MISSING)
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -13498,7 +13508,7 @@ again:
 					       key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -13511,7 +13521,7 @@ again:
 				btrfs_extent_data_ref_count(eb, dref));
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
@@ -13519,7 +13529,7 @@ again:
 						 key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
@@ -13527,7 +13537,7 @@ again:
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



