Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17266 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754487AbdLTExv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:51 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 12/17] btrfs-progs: lowmem check: remove parameter @trans of repair_extent_item()
Date: Wed, 20 Dec 2017 12:57:26 +0800
Message-ID: <20171220045731.19343-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of repair_extent_item().
It calls try_avoid_extents_overwrite() and starts a transaction by
itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 54 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5a6433623fb6..2c77afe25edc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12788,40 +12788,55 @@ out:
  *               means error after repair
  * Returns  0   nothing happened
  */
-static int repair_extent_item(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
+static int repair_extent_item(struct btrfs_root *root, struct btrfs_path *path,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset, int err)
 {
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_key old_key;
 	int freed = 0;
 	int ret;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &old_key, path->slots[0]);
 
-	if (err & (REFERENCER_MISSING | REFERENCER_MISMATCH)) {
-		/* delete the backref */
-		ret = btrfs_free_extent(trans, root->fs_info->fs_root, bytenr,
-			  num_bytes, parent, root_objectid, owner, offset);
-		if (!ret) {
-			freed = 1;
-			err &= ~REFERENCER_MISSING;
-			printf("Delete backref in extent [%llu %llu]\n",
-			       bytenr, num_bytes);
-		} else {
-			error("fail to delete backref in extent [%llu %llu]",
-			       bytenr, num_bytes);
-		}
+	if ((err & (REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)
+		return err;
+
+	ret = try_avoid_extents_overwrite(root->fs_info);
+	if (ret)
+		return err;
+
+	trans = btrfs_start_transaction(extent_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("fail to start transaction %s", strerror(-ret));
+		/* nothing happened */
+		ret = 0;
+		goto out;
 	}
+	/* delete the backref */
+	ret = btrfs_free_extent(trans, root->fs_info->fs_root, bytenr,
+			num_bytes, parent, root_objectid, owner, offset);
+	if (!ret) {
+		freed = 1;
+		err &= ~REFERENCER_MISSING;
+		printf("Delete backref in extent [%llu %llu]\n",
+		       bytenr, num_bytes);
+	} else {
+		error("fail to delete backref in extent [%llu %llu]",
+		      bytenr, num_bytes);
+	}
+	btrfs_commit_transaction(trans, extent_root);
 
 	/* btrfs_free_extent may delete the extent */
 	btrfs_release_path(path);
 	ret = btrfs_search_slot(NULL, root, &old_key, path, 0, 0);
-
 	if (ret)
 		ret = -ENOENT;
 	else if (freed)
 		ret = err;
+out:
 	return ret;
 }
 
@@ -12831,8 +12846,7 @@ static int repair_extent_item(struct btrfs_trans_handle *trans,
  *
  * Since we don't use extent_record anymore, introduce new error bit
  */
-static int check_extent_item(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
+static int check_extent_item(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path)
 {
 	struct btrfs_extent_item *ei;
@@ -12963,7 +12977,7 @@ next:
 	}
 
 	if (err && repair) {
-		ret = repair_extent_item(trans, fs_info->extent_root, path,
+		ret = repair_extent_item(fs_info->extent_root, path,
 			 key.objectid, num_bytes, parent, root_objectid,
 			 owner, owner_offset, ret);
 		if (ret < 0)
@@ -13512,7 +13526,7 @@ again:
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
-		ret = check_extent_item(trans, fs_info, path);
+		ret = check_extent_item(fs_info, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-- 
2.15.1



