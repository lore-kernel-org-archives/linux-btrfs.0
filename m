Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbaLRDkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 22:40:09 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBI3dePC002171
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 11:39:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: Add repair function for discount file extent hole.
Date: Thu, 18 Dec 2014 11:38:00 +0800
Message-ID: <1418873880-7916-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since orphan extents are handled in previous patches, now just punch
holes to fill the file extents hole.

Also since now btrfsck is aware of whether the inode has orphan file
extent, allow repair_inode_no_item() to determine filetype according to
orphan file extent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1e9bc56..6c43b62 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2460,12 +2460,6 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 	int type_recovered = 0;
 	int ret = 0;
 
-	/*
-	 * TODO:
-	 * 1. salvage data from existing file extent and
-	 *    punch hole to keep fi ext consistent.
-	 * 2. salvage data from extent tree
-	 */
 	printf("Trying to rebuild inode:%llu\n", rec->ino);
 
 	type_recovered = !find_file_type(rec, &filetype);
@@ -2479,9 +2473,7 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 	 * For undetermined one, use FILE as fallback.
 	 *
 	 * TODO:
-	 * 1. If found extent belong to it in extent tree, it must be FILE
-	 *    Need extra hook in extent tree scan.
-	 * 2. If found backref(inode_index/item is already handled) to it,
+	 * 1. If found backref(inode_index/item is already handled) to it,
 	 *    it must be DIR.
 	 *    Need new inode-inode ref structure to allow search for that.
 	 */
@@ -2493,7 +2485,10 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 		} else if (rec->found_dir_item) {
 			type_recovered = 1;
 			filetype = BTRFS_FT_DIR;
-		} else {
+		} else if (!list_empty(&rec->orphan_extents)) {
+			type_recovered = 1;
+			filetype = BTRFS_FT_REG_FILE;
+		} else{
 			printf("Can't determint the filetype for inode %llu, assume it is a normal file\n",
 			       rec->ino);
 			type_recovered = 1;
@@ -2584,6 +2579,37 @@ out:
 	return ret;
 }
 
+static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct btrfs_path *path,
+					struct inode_record *rec)
+{
+	struct rb_node *node;
+	struct file_extent_hole *hole;
+	int ret = 0;
+
+	node = rb_first(&rec->holes);
+
+	while (node) {
+		hole = rb_entry(node, struct file_extent_hole, node);
+		ret = btrfs_punch_hole(trans, root, rec->ino,
+				       hole->start, hole->len);
+		if (ret < 0)
+			goto out;
+		ret = del_file_extent_hole(&rec->holes, hole->start,
+					   hole->len);
+		if (ret < 0)
+			goto out;
+		if (RB_EMPTY_ROOT(&rec->holes))
+			rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
+		node = rb_first(&rec->holes);
+	}
+	printf("Fixed discount file extents for inode: %llu in root: %llu\n",
+	       rec->ino, root->objectid);
+out:
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
@@ -2594,7 +2620,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
 			     I_ERR_NO_INODE_ITEM |
-			     I_ERR_FILE_EXTENT_ORPHAN)))
+			     I_ERR_FILE_EXTENT_ORPHAN |
+			     I_ERR_FILE_EXTENT_DISCOUNT)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
@@ -2618,6 +2645,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_no_item(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
 		ret = repair_inode_orphan_extent(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_FILE_EXTENT_DISCOUNT)
+		ret = repair_inode_discount_extent(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
-- 
2.1.3

