Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3171 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbeBHDXU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:20 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id B787C48AE761
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:10 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 09/18] btrfs-progs: lowmem check: start to remove parameters @trans in lowmem
Date: Thu, 8 Feb 2018 11:27:28 +0800
Message-ID: <20180208032737.31561-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
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
 check/mode-lowmem.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1e0545e6249d..446ea4a21bfa 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2739,12 +2739,12 @@ out:
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
@@ -2761,6 +2761,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 	u64 file_offset;
 	int generation;
 	int slot;
+	int need_insert = 0;
 	int ret = 0;
 
 	eb = pathp->nodes[0];
@@ -2799,9 +2800,20 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
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
@@ -2841,6 +2853,8 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 
 	err &= ~BACKREF_MISSING;
 out:
+	if (trans)
+		btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
@@ -4117,8 +4131,7 @@ again:
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
2.16.1



