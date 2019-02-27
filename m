Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C99CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696E021852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfB0GG1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:34050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfB0GG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 01:06:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C366AC5F;
        Wed, 27 Feb 2019 06:06:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v1.1 06/14] btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
Date:   Wed, 27 Feb 2019 14:05:44 +0800
Message-Id: <20190227060552.3841-7-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
References: <20190227060552.3841-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

The function can delete items in trees besides extent tree.
Rename and move it for further use.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
[Update comment, solve merge conflicts]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 102 +++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 746835654d82..7bd18902e106 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -543,6 +543,54 @@ static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Delete the item @path point to. A wrapper of btrfs_del_item().
+ *
+ * If deleted successfully, @path will point to the previous item of the
+ * deleted item.
+ */
+static int delete_item(struct btrfs_root *root, struct btrfs_path *path)
+{
+	struct btrfs_key key;
+	struct btrfs_trans_handle *trans;
+	int ret = 0;
+
+	ret = avoid_extents_overwrite(root->fs_info);
+	if (ret)
+		return ret;
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("fail to start transaction %s", strerror(-ret));
+		goto out;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+
+	if (path->slots[0] == 0)
+		btrfs_prev_leaf(root, path);
+	else
+		path->slots[0]--;
+out:
+	btrfs_commit_transaction(trans, root);
+	if (ret)
+		error("failed to delete root %llu item[%llu, %u, %llu]",
+		      root->objectid, key.objectid, key.type, key.offset);
+	else
+		printf("Deleted root %llu item[%llu, %u, %llu]\n",
+		       root->objectid, key.objectid, key.type, key.offset);
+	return ret;
+}
+
 /*
  * Wrapper function for btrfs_fix_block_accounting().
  *
@@ -4433,50 +4481,6 @@ static int repair_chunk_item(struct btrfs_root *chunk_root,
 	return err;
 }
 
-static int delete_extent_tree_item(struct btrfs_root *root,
-				   struct btrfs_path *path)
-{
-	struct btrfs_key key;
-	struct btrfs_trans_handle *trans;
-	int ret = 0;
-
-	ret = avoid_extents_overwrite(root->fs_info);
-	if (ret)
-		return ret;
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		errno = -ret;
-		error("fail to start transaction: %m");
-		goto out;
-	}
-	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-	btrfs_release_path(path);
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret) {
-		ret = -ENOENT;
-		goto out;
-	}
-
-	ret = btrfs_del_item(trans, root, path);
-	if (ret)
-		goto out;
-
-	if (path->slots[0] == 0)
-		btrfs_prev_leaf(root, path);
-	else
-		path->slots[0]--;
-out:
-	btrfs_commit_transaction(trans, root);
-	if (ret)
-		error("failed to delete root %llu item[%llu, %u, %llu]",
-		      root->objectid, key.objectid, key.type, key.offset);
-	else
-		printf("Deleted root %llu item[%llu, %u, %llu]\n",
-		       root->objectid, key.objectid, key.type, key.offset);
-	return ret;
-}
-
 /*
  * Main entry function to check known items and update related accounting info
  */
@@ -4518,7 +4522,7 @@ again:
 		ret = check_block_group_item(fs_info, eb, slot);
 		if (repair &&
 		    ret & REFERENCER_MISSING)
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -4549,7 +4553,7 @@ again:
 					       key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -4562,7 +4566,7 @@ again:
 				btrfs_extent_data_ref_count(eb, dref));
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
@@ -4570,7 +4574,7 @@ again:
 						 key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
@@ -4578,7 +4582,7 @@ again:
 						key.objectid);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	default:
-- 
2.21.0

