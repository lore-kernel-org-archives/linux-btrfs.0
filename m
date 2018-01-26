Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2977 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752314AbeAZIay (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:54 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 14DDB49F19B9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:47 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 04/15] btrfs-progs: lowmem check: repair complex cases in repair_dir_item()
Date: Fri, 26 Jan 2018 16:35:08 +0800
Message-ID: <20180126083519.28373-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If inode item is missing or filetype is corrupted maybe, and filetypes
of dir_item and dir_index are corrupted too, lowmem repair may insert
wrong inode item and dir_item/index.

First, find and guess filetype of inode item, if failed, use
BTRFS_REG_FILE as fallback for insertion.
If filetype is not available, just delete current dir_item/index.

And repair_dir_item also calls repair_inode_item_mismatch() now.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 17 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 08a2662e603c..e33dd7db0048 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2811,7 +2811,7 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 
 		ret = check_child_node(cur, path->slots[*level], next);
 		err |= ret;
-		if (ret < 0) 
+		if (ret < 0)
 			break;
 
 		if (btrfs_is_leaf(next))
@@ -5697,29 +5697,91 @@ static void print_dir_item_err(struct btrfs_root *root, struct btrfs_key *key,
 /*
  * Call repair_inode_item_missing and repair_ternary_lowmem to repair
  *
+ * @filetype:	filetype of the dir_item/index
+ *
  * Returns error after repair
  */
-static int repair_dir_item(struct btrfs_root *root, u64 dirid, u64 ino,
-			   u64 index, u8 filetype, char *namebuf, u32 name_len,
-			   int err)
+static int repair_dir_item(struct btrfs_root *root, struct btrfs_key *key,
+			   u64 ino, u64 index, u8 filetype, char *namebuf,
+			   u32 name_len, int err)
 {
 	int ret;
+	u64 dirid = key->objectid;
+	u8 true_filetype;
 
-	if (err & INODE_ITEM_MISSING) {
-		ret = repair_inode_item_missing(root, ino, filetype);
-		if (!ret)
-			err &= ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING);
+	if (err & (INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
+		ret = find_file_type_lowmem(root, ino, &true_filetype);
+		if (ret) {
+			ret = guess_file_type_lowmem(root, ino,
+						     &true_filetype);
+			if (ret) {
+				true_filetype = BTRFS_FT_REG_FILE;
+				error(
+		"can't get file type for inode %llu, using FILE as fallback",
+				      ino);
+			}
+		}
 	}
 
-	if (err & ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
-		ret = repair_ternary_lowmem(root, dirid, ino, index, namebuf,
-					    name_len, filetype, err);
+	/*
+	 * Case: the dir_item has corresponding inode_ref but
+	 * mismatch/missed inode_item and mismatch/missed another
+	 * dir_item/index.
+	 * repair_ternary_lowmem prefer to change another dir_item/index with
+	 * wrong filetype. So delete the item here.
+	 */
+	if (filetype != true_filetype &&
+	    (err & (DIR_ITEM_MISMATCH | DIR_ITEM_MISSING) ||
+	     err & (DIR_INDEX_MISMATCH | DIR_INDEX_MISSING))) {
+		struct btrfs_trans_handle *trans;
+		struct btrfs_path *path;
+
+		path = btrfs_alloc_path();
+		if (!path)
+			goto out;
+		trans = btrfs_start_transaction(root, 0);
+		ret = btrfs_search_slot(trans, root, key, path, -1, 1);
+		if (ret) {
+			btrfs_commit_transaction(trans, root);
+			btrfs_release_path(path);
+			goto out;
+		}
+		ret = btrfs_del_item(trans, root, path);
 		if (!ret) {
-			err &= ~(DIR_INDEX_MISMATCH | DIR_INDEX_MISSING);
-			err &= ~(DIR_ITEM_MISMATCH | DIR_ITEM_MISSING);
-			err &= ~(INODE_REF_MISSING);
+			err = 0;
+			printf(
+		"Deleted dir_item[%llu %u %llu]root %llu name %s filetype %u\n",
+			       key->objectid, key->type, key->offset,
+			       root->objectid, namebuf, filetype);
 		}
+		btrfs_commit_transaction(trans, root);
+		btrfs_release_path(path);
+		/*
+		 * Leave remains to check_inode_item() and check_inode_ref().
+		 */
+		goto out;
+	}
+
+	ret = repair_ternary_lowmem(root, dirid, ino, index, namebuf,
+				    name_len, true_filetype, err);
+	if (!ret) {
+		err &= ~(DIR_INDEX_MISMATCH | DIR_INDEX_MISSING);
+		err &= ~(DIR_ITEM_MISMATCH | DIR_ITEM_MISSING);
+		err &= ~(INODE_REF_MISSING);
+	}
+
+	if (err & INODE_ITEM_MISSING) {
+		ret = repair_inode_item_missing(root, ino, true_filetype);
+		if (!ret || ret == -EEXIST)
+			err &= ~INODE_ITEM_MISSING;
 	}
+
+	if (err & INODE_ITEM_MISMATCH) {
+		ret = repair_inode_item_mismatch(root, ino, true_filetype);
+		if (!ret)
+			err &= ~INODE_ITEM_MISMATCH;
+	}
+out:
 	return err;
 }
 
@@ -5958,9 +6020,8 @@ begin:
 next:
 
 		if (tmp_err && repair) {
-			ret = repair_dir_item(root, di_key->objectid,
-					      location.objectid, index,
-					      imode_to_type(mode), namebuf,
+			ret = repair_dir_item(root, di_key, location.objectid,
+					      index, filetype, namebuf,
 					      name_len, tmp_err);
 			if (ret != tmp_err) {
 				need_research = 1;
-- 
2.16.1



