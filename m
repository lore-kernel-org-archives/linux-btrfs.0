Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40618 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752175AbeBHDXQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:16 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 5609D48AE769
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:14 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 12/18] btrfs-progs: lowmem check: remove parameter @trans of repair_extent_item()
Date: Thu, 8 Feb 2018 11:27:31 +0800
Message-ID: <20180208032737.31561-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
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
 check/mode-lowmem.c | 54 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 53377848f361..443fa513a13e 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3588,40 +3588,55 @@ out:
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
+	ret = avoid_extents_overwrite(root->fs_info);
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
 
@@ -3631,8 +3646,7 @@ static int repair_extent_item(struct btrfs_trans_handle *trans,
  *
  * Since we don't use extent_record anymore, introduce new error bit
  */
-static int check_extent_item(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
+static int check_extent_item(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path)
 {
 	struct btrfs_extent_item *ei;
@@ -3763,7 +3777,7 @@ next:
 	}
 
 	if (err && repair) {
-		ret = repair_extent_item(trans, fs_info->extent_root, path,
+		ret = repair_extent_item(fs_info->extent_root, path,
 			 key.objectid, num_bytes, parent, root_objectid,
 			 owner, owner_offset, ret);
 		if (ret < 0)
@@ -4183,7 +4197,7 @@ again:
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
-		ret = check_extent_item(trans, fs_info, path);
+		ret = check_extent_item(fs_info, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-- 
2.16.1



