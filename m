Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933115AbeEHIYa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:30 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 07/16] btrfs-progs: lowmem: start to remove parameters @trans in lowmem
Date: Tue, 8 May 2018 16:30:03 +0800
Message-ID: <20180508083012.12090-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since extents can be avoid to be overwrited by excluding or chunk
allocation. It's unnessesary to do all repairs in one transaction.

This patch removes parameter @trans of repair_extent_data_item().
repair_extent_data_item() calls try_avoid_extents_overwrite()
and starts a transaction by itself.

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
Such error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index c4e76113fa8a..cad131495c6f 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2799,12 +2799,12 @@ out:
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
@@ -2821,6 +2821,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 	u64 file_offset;
 	int generation;
 	int slot;
+	int need_insert = 0;
 	int ret = 0;
 
 	eb = pathp->nodes[0];
@@ -2859,9 +2860,20 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		ret = -EIO;
 		goto out;
 	}
+	need_insert = ret;
 
+	ret = avoid_extents_overwrite(root->fs_info);
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
@@ -2901,6 +2913,8 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 
 	err &= ~BACKREF_MISSING;
 out:
+	if (trans)
+		btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
@@ -4178,8 +4192,7 @@ again:
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
2.17.0



