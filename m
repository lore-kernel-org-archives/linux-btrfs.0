Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38594 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754483AbdLTExu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:50 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 11/17] btrfs-progs: lowmem check: remove parameter @trans of repair_chunk_item()
Date: Wed, 20 Dec 2017 12:57:25 +0800
Message-ID: <20171220045731.19343-12-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of repair_chunk_item().
It calls try_avoid_extents_overwrite() and starts a transaction by
itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index f1ab93550bc5..5a6433623fb6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13250,13 +13250,14 @@ out:
  *
  * Returns error after repair.
  */
-static int repair_chunk_item(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *chunk_root,
+static int repair_chunk_item(struct btrfs_root *chunk_root,
 			     struct btrfs_path *path, int err)
 {
 	struct btrfs_chunk *chunk;
 	struct btrfs_key chunk_key;
 	struct extent_buffer *eb = path->nodes[0];
+	struct btrfs_root *extent_root = chunk_root->fs_info->extent_root;
+	struct btrfs_trans_handle *trans;
 	u64 length;
 	int slot = path->slots[0];
 	u64 type;
@@ -13269,21 +13270,36 @@ static int repair_chunk_item(struct btrfs_trans_handle *trans,
 	type = btrfs_chunk_type(path->nodes[0], chunk);
 	length = btrfs_chunk_length(eb, chunk);
 
-	if (err & REFERENCER_MISSING) {
-		ret = btrfs_make_block_group(trans, chunk_root->fs_info, 0,
-		     type, chunk_key.objectid, chunk_key.offset, length);
-		if (ret) {
-			error("fail to add block group item[%llu %llu]",
-			      chunk_key.offset, length);
-			goto out;
-		} else {
-			err &= ~REFERENCER_MISSING;
-			printf("Added block group item[%llu %llu]\n",
-			       chunk_key.offset, length);
-		}
+	/* now repair only adds block group */
+	if ((err & REFERENCER_MISSING) == 0)
+		return err;
+
+	ret = try_avoid_extents_overwrite(chunk_root->fs_info);
+	if (ret)
+		return ret;
+
+	trans = btrfs_start_transaction(extent_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("fail to start transaction %s", strerror(-ret));
+		return ret;
 	}
 
-out:
+	ret = btrfs_make_block_group(trans, chunk_root->fs_info, 0, type,
+			     chunk_key.objectid, chunk_key.offset, length);
+	if (ret) {
+		error("fail to add block group item[%llu %llu]",
+		      chunk_key.offset, length);
+	} else {
+		err &= ~REFERENCER_MISSING;
+		printf("Added block group item[%llu %llu]\n", chunk_key.offset,
+		       length);
+	}
+
+	btrfs_commit_transaction(trans, extent_root);
+	if (ret)
+		error("fail to repair item(s) related to chunk item[%llu %llu]",
+		      chunk_key.objectid, chunk_key.offset);
 	return err;
 }
 
@@ -13487,7 +13503,7 @@ again:
 	case BTRFS_CHUNK_ITEM_KEY:
 		ret = check_chunk_item(fs_info, eb, slot);
 		if (repair && ret)
-			ret = repair_chunk_item(trans, root, path, ret);
+			ret = repair_chunk_item(root, path, ret);
 		err |= ret;
 		break;
 	case BTRFS_DEV_EXTENT_KEY:
-- 
2.15.1



