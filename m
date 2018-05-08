Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2328 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933099AbeEHIYb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:31 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 08/16] btrfs-progs: lowmem: remove parameter @trans of delete_extent_item()
Date: Tue, 8 May 2018 16:30:04 +0800
Message-ID: <20180508083012.12090-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the parameter @trans of delete_extent_item().
It calls try_avoid_extents_overwrite() and starts a transaction
by itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
Such error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index cad131495c6f..55e06ebf2268 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4124,13 +4124,22 @@ out:
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
 
+	ret = avoid_extents_overwrite(root->fs_info);
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
@@ -4148,6 +4157,7 @@ static int delete_extent_tree_item(struct btrfs_trans_handle *trans,
 	else
 		path->slots[0]--;
 out:
+	btrfs_commit_transaction(trans, root);
 	if (ret)
 		error("failed to delete root %llu item[%llu, %u, %llu]",
 		      root->objectid, key.objectid, key.type, key.offset);
@@ -4199,7 +4209,7 @@ again:
 		ret = check_block_group_item(fs_info, eb, slot);
 		if (repair &&
 		    ret & REFERENCER_MISSING)
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -4230,7 +4240,7 @@ again:
 					       key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -4243,7 +4253,7 @@ again:
 				btrfs_extent_data_ref_count(eb, dref));
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
@@ -4251,7 +4261,7 @@ again:
 						 key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
@@ -4259,7 +4269,7 @@ again:
 						key.objectid);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(trans, root, path);
+			ret = delete_extent_tree_item(root, path);
 		err |= ret;
 		break;
 	default:
-- 
2.17.0



