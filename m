Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163421AbcG1HJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:08 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id E5E0742BA381
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:48 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 07/13] btrfs-progs: check: introduce function to check file extent
Date: Thu, 28 Jul 2016 15:08:19 +0800
Message-ID: <1469689705-26836-8-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function check_file_extent() to check file extent,
such as datasum, hole, size.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index ad261f2..28ee8b6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3885,6 +3885,9 @@ out:
 #define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
 #define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
 #define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
+#define FILE_EXTENT_ERROR	(1<<7)	/* bad file extent */
+#define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM ERROR */
+#define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
 
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
@@ -4461,6 +4464,97 @@ next:
 	return err;
 }
 
+/*
+ * Check file extent datasum/hole, update the size of the file extents,
+ * check and update the last offset of the file extent.
+ *
+ * @root:	the root of fs/file tree.
+ * @fkey:	the key of the file extent.
+ * @nodatasum:	INODE_NODATASUM feature.
+ * @size:	the sum of all EXTENT_DATA items size for this inode.
+ * @end:	the offset of the last extent.
+ *
+ * Return 0 if no error occurred.
+ */
+static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
+			     struct extent_buffer *node, int slot,
+			     unsigned int nodatasum, u64 *size, u64 *end)
+{
+	struct btrfs_file_extent_item *fi;
+	u64 disk_bytenr;
+	u64 disk_num_bytes;
+	u64 extent_num_bytes;
+	u64 found;
+	unsigned int extent_type;
+	unsigned int is_hole;
+	int ret;
+	int err = 0;
+
+	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+
+	extent_type = btrfs_file_extent_type(node, fi);
+	/* Skip if file extent is inline */
+	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+		extent_num_bytes = btrfs_file_extent_inline_len(node, slot, fi);
+		if (extent_num_bytes == 0)
+			err |= FILE_EXTENT_ERROR;
+		*size += extent_num_bytes;
+		return err;
+	}
+
+	/* Check extent type */
+	if (extent_type != BTRFS_FILE_EXTENT_REG &&
+			extent_type != BTRFS_FILE_EXTENT_PREALLOC) {
+		err |= FILE_EXTENT_ERROR;
+		error("root %llu EXTENT_DATA[%llu %llu] type bad",
+		      root->objectid, fkey->objectid, fkey->offset);
+		return err;
+	}
+
+	/* Check REG_EXTENT/PREALLOC_EXTENT */
+	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
+	disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
+	extent_num_bytes = btrfs_file_extent_num_bytes(node, fi);
+	is_hole = (disk_bytenr == 0) && (disk_num_bytes == 0);
+
+	/* Check EXTENT_DATA datasum */
+	ret = count_csum_range(root, disk_bytenr, disk_num_bytes, &found);
+	if (found > 0 && nodatasum) {
+		err |= ODD_CSUM_ITEM;
+		error(
+		"root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
+		root->objectid, fkey->objectid, fkey->offset);
+	} else if (extent_type == BTRFS_FILE_EXTENT_REG && !nodatasum &&
+		   !is_hole &&
+		   (ret < 0 || found == 0 || found < disk_num_bytes)) {
+		err |= CSUM_ITEM_MISSING;
+		error("root %llu EXTENT_DATA[%llu %llu] datasum missing",
+		      root->objectid, fkey->objectid, fkey->offset);
+	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC && found > 0) {
+		err |= ODD_CSUM_ITEM;
+		error(
+		"root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have datasum",
+		root->objectid, fkey->objectid, fkey->offset);
+	}
+
+	/* Check EXTENT_DATA hole */
+	if (no_holes && is_hole) {
+		err |= FILE_EXTENT_ERROR;
+		error("root %llu EXTENT_DATA[%llu %llu] shouldn't be hole",
+				root->objectid, fkey->objectid, fkey->offset);
+	} else if (!no_holes && *end != fkey->offset) {
+		err |= FILE_EXTENT_ERROR;
+		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
+				root->objectid, fkey->objectid, fkey->offset);
+	}
+
+	*end += extent_num_bytes;
+	if (!is_hole)
+		*size += extent_num_bytes;
+
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



