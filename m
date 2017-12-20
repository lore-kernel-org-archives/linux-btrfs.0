Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38594 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754461AbdLTExr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:47 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 09/17] btrfs-progs: lowmem check: start to remove parameters @trans in lowmem
Date: Wed, 20 Dec 2017 12:57:23 +0800
Message-ID: <20171220045731.19343-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since extents can be avoid overwrite by excluding or new chunk
allocation. It's unnessesary to do all repairs in one transaction.

This patch removes parameter @trans of repair_extent_data_item().
repair_extent_data_item() calls try_avoid_extents_overwrite()
and starts a transaction by itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index bc405d0f3fc0..20bf3d230946 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12064,18 +12064,19 @@ out:
 	return err;
 }
 
+static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info);
 /*
  * If @err contains BACKREF_MISSING then add extent of the
  * file_extent_data_item.
  *
  * Returns error bits after reapir.
  */
-static int repair_extent_data_item(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
+static int repair_extent_data_item(struct btrfs_root *root,
 				   struct btrfs_path *pathp,
 				   struct node_refs *nrefs,
 				   int err)
 {
+	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key fi_key;
 	struct btrfs_key key;
@@ -12092,6 +12093,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 	u64 file_offset;
 	int generation;
 	int slot;
+	int need_insert = 0;
 	int ret = 0;
 
 	eb = pathp->nodes[0];
@@ -12130,9 +12132,20 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		ret = -EIO;
 		goto out;
 	}
+	need_insert = ret;
 
+	ret = try_avoid_extents_overwrite(root->fs_info);
+	if (ret)
+		goto out;
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		error("fail to start transaction %s", strerror(-ret));
+		goto out;
+	}
 	/* insert an extent item */
-	if (ret > 0) {
+	if (need_insert) {
 		key.objectid = disk_bytenr;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.offset = num_bytes;
@@ -12172,6 +12185,8 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 
 	err &= ~BACKREF_MISSING;
 out:
+	if (trans)
+		btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
@@ -13445,8 +13460,7 @@ again:
 	case BTRFS_EXTENT_DATA_KEY:
 		ret = check_extent_data_item(root, path, nrefs, account_bytes);
 		if (repair && ret)
-			ret = repair_extent_data_item(trans, root, path, nrefs,
-						      ret);
+			ret = repair_extent_data_item(root, path, nrefs, ret);
 		err |= ret;
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-- 
2.15.1



