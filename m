Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855CFC46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D9A120665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D9A120665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbeJWR5U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:20 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18632 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728603AbeJWR5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:20 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602833"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C0B824B3305F
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:38 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:44 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 06/13] btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
Date:   Tue, 23 Oct 2018 17:41:40 +0800
Message-ID: <20181023094147.7906-7-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: C0B824B3305F.AA860
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The function can delete items in trees besides extent tree.
Rename and move it for further use.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 99 +++++++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 48 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index e8a2e825c0f3..3c9ecff7e498 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -537,6 +537,52 @@ static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Delete the item @path point to.
+ * If deleted, path will point to the previous item to the deleted item.
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
@@ -4335,49 +4381,6 @@ static int repair_chunk_item(struct btrfs_root *chunk_root,
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
-		error("fail to start transaction %s", strerror(-ret));
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
@@ -4419,7 +4422,7 @@ again:
 		ret = check_block_group_item(fs_info, eb, slot);
 		if (repair &&
 		    ret & REFERENCER_MISSING)
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -4450,7 +4453,7 @@ again:
 					       key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -4463,7 +4466,7 @@ again:
 				btrfs_extent_data_ref_count(eb, dref));
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
@@ -4471,7 +4474,7 @@ again:
 						 key.objectid, -1);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
@@ -4479,7 +4482,7 @@ again:
 						key.objectid);
 		if (repair &&
 		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
-			ret = delete_extent_tree_item(root, path);
+			ret = delete_item(root, path);
 		err |= ret;
 		break;
 	default:
-- 
2.19.1



