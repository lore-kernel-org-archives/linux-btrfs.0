Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752377AbeAZIbB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:31:01 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id BE61949F19B9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:52 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 14/15] btrfs-progs: check: handle mismatched filetype in repair_inode_backref
Date: Fri, 26 Jan 2018 16:35:18 +0800
Message-ID: <20180126083519.28373-15-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original can't handle mismatched well.
Since it only records inode mode and one filetype of dir_item or
dir_index. If backref has mismatched filetype, the one filetype
is untrusted. The only trusted thing is inode mode.

So, if we found mismatched filetype in a backref, just delete
dir_index and dir_item. Then next round of repair will add new
dir_index and dir_item whose filetype bases on the inode mode.

Transform delete_dir_index() to __delete_dir_item() for code reuse.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6091c7ef3442..156b4063bf40 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3059,27 +3059,41 @@ static int add_missing_dir_index(struct btrfs_root *root,
 	return 0;
 }
 
-static int delete_dir_index(struct btrfs_root *root,
-			    struct inode_backref *backref)
+static int __delete_dir_item(struct btrfs_root *root,
+			     struct inode_backref *backref, bool is_index)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dir_item *di;
 	struct btrfs_path path;
 	int ret = 0;
+	u64 offset;
+	u8 type;
+
+	if (is_index) {
+		type = BTRFS_DIR_INDEX_KEY;
+		offset = backref->index;
+	} else {
+		type = BTRFS_DIR_ITEM_KEY;
+		offset = btrfs_name_hash(backref->name, backref->namelen);
+	}
 
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	fprintf(stderr, "Deleting bad dir index [%llu,%u,%llu] root %llu\n",
-		(unsigned long long)backref->dir,
-		BTRFS_DIR_INDEX_KEY, (unsigned long long)backref->index,
-		(unsigned long long)root->objectid);
+	fprintf(stderr, "Deleting bad dir %s [%llu,%u,%llu] root %llu\n",
+		is_index ? "index" : "item", (unsigned long long)backref->dir,
+		type, offset, (unsigned long long)root->objectid);
 
 	btrfs_init_path(&path);
-	di = btrfs_lookup_dir_index(trans, root, &path, backref->dir,
-				    backref->name, backref->namelen,
-				    backref->index, -1);
+	if (is_index)
+		di = btrfs_lookup_dir_index(trans, root, &path, backref->dir,
+					    backref->name, backref->namelen,
+					    backref->index, -1);
+	else
+		di = btrfs_lookup_dir_item(trans, root, &path, backref->dir,
+					   backref->name, backref->namelen,
+					   -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
 		btrfs_release_path(&path);
@@ -3099,6 +3113,18 @@ static int delete_dir_index(struct btrfs_root *root,
 	return ret;
 }
 
+static int delete_dir_index(struct btrfs_root *root,
+			    struct inode_backref *backref)
+{
+	return __delete_dir_item(root, backref, true);
+}
+
+static int delete_dir_item(struct btrfs_root *root,
+			   struct inode_backref *backref)
+{
+	return __delete_dir_item(root, backref, false);
+}
+
 static int __create_inode_item(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, u64 ino, u64 size,
 			       u64 nbytes, u64 nlink, u32 mode)
@@ -3228,6 +3254,22 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			continue;
 		}
 
+		if (delete &&
+		    (backref->errors & REF_ERR_FILETYPE_UNMATCH)) {
+			if (backref->found_dir_index)
+				ret = delete_dir_index(root, backref);
+			if (ret)
+				break;
+			if (backref->found_dir_item)
+				ret = delete_dir_item(root, backref);
+			if (ret)
+				break;
+			backref->found_dir_index = 0;
+			backref->found_dir_item = 0;
+			repaired++;
+			continue;
+		}
+
 		if (!delete && !backref->found_dir_index &&
 		    backref->found_dir_item && backref->found_inode_ref) {
 			ret = add_missing_dir_index(root, inode_cache, rec,
@@ -3285,6 +3327,12 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			btrfs_commit_transaction(trans, root);
 			backref->found_dir_index = 1;
 			backref->found_dir_item = 1;
+			/*
+			 * We can't judge backre->filetype is right or not.
+			 * Just rely on the inode mode.
+			 */
+			if (rec->found_inode_item)
+				backref->errors &= ~REF_ERR_FILETYPE_UNMATCH;
 			repaired++;
 		}
 
-- 
2.16.1



