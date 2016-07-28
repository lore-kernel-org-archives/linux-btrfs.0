Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163421AbcG1HJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:00 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 733E242AB376
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:45 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 02/13] btrfs-progs: check: introduce function to find dir_item
Date: Thu, 28 Jul 2016 15:08:14 +0800
Message-ID: <1469689705-26836-3-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function find_dir_item() to find DIR_ITEM for the given
key, and check it with the specified INODE_REF/INODE_EXTREF match.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index dd1b708..7e6f2a9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3878,6 +3878,144 @@ out:
 	return err;
 }
 
+#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
+#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
+#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
+
+/*
+ * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
+ * INODE_REF/INODE_EXTREF match.
+ *
+ * @root:	the root of the fs/file tree
+ * @ref_key:	the key of the INODE_REF/INODE_EXTREF
+ * @key:	the key of the DIR_ITEM/DIR_INDEX
+ * @index:	the index in the INODE_REF/INODE_EXTREF, be used to
+ *		distinguish root_dir between normal dir/file
+ * @name:	the name in the INODE_REF/INODE_EXTREF
+ * @namelen:	the length of name in the INODE_REF/INODE_EXTREF
+ * @mode:	the st_mode of INODE_ITEM
+ *
+ * Return 0 if no error occurred.
+ * Return ROOT_DIR_ERROR if found DIR_ITEM/DIR_INDEX for root_dir.
+ * Return DIR_ITEM_MISSING if couldn't find DIR_ITEM/DIR_INDEX for normal
+ * dir/file.
+ * Return DIR_ITEM_MISMATCH if INODE_REF/INODE_EXTREF and DIR_ITEM/DIR_INDEX
+ * not match for normal dir/file.
+ */
+static int find_dir_item(struct btrfs_root *root, struct btrfs_key *ref_key,
+			 struct btrfs_key *key, u64 index, char *name,
+			 u32 namelen, u32 mode)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *node;
+	struct btrfs_dir_item *di;
+	struct btrfs_key location;
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len;
+	u32 data_len;
+	u8 filetype;
+	int slot;
+	int ret;
+
+	path = btrfs_alloc_path();
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	/* Process root dir and goto out*/
+	if (index == 0) {
+		if (ret == 0) {
+			ret = ROOT_DIR_ERROR;
+			error(
+			"root %llu INODE %s[%llu %llu] ROOT_DIR shouldn't have %s",
+				root->objectid,
+				ref_key->type == BTRFS_INODE_REF_KEY ?
+					"REF" : "EXTREF",
+				ref_key->objectid, ref_key->offset,
+				key->type == BTRFS_DIR_ITEM_KEY ?
+					"DIR_ITEM" : "DIR_INDEX");
+		} else {
+			ret = 0;
+		}
+
+		goto out;
+	}
+
+	/* Process normal file/dir */
+	if (ret > 0) {
+		ret = DIR_ITEM_MISSING;
+		error(
+		"root %llu INODE %s[%llu %llu] doesn't have related %s[%llu %llu] namelen %u filename %s filetype %d",
+			root->objectid,
+			ref_key->type == BTRFS_INODE_REF_KEY ? "REF" : "EXTREF",
+			ref_key->objectid, ref_key->offset,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+				"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, namelen, name,
+			imode_to_type(mode));
+		goto out;
+	}
+
+	/* Check whether inode_id/filetype/name match */
+	node = path->nodes[0];
+	slot = path->slots[0];
+	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
+	total = btrfs_item_size_nr(node, slot);
+	while (cur < total) {
+		ret = DIR_ITEM_MISMATCH;
+		name_len = btrfs_dir_name_len(node, di);
+		data_len = btrfs_dir_data_len(node, di);
+
+		btrfs_dir_item_key_to_cpu(node, di, &location);
+		if (location.objectid != ref_key->objectid ||
+		    location.type !=  BTRFS_INODE_ITEM_KEY ||
+		    location.offset != 0)
+			goto next;
+
+		filetype = btrfs_dir_type(node, di);
+		if (imode_to_type(mode) != filetype)
+			goto next;
+
+		if (name_len <= BTRFS_NAME_LEN) {
+			len = name_len;
+		} else {
+			len = BTRFS_NAME_LEN;
+			fprintf(stderr,
+			"Warning: root %llu %s[%llu %llu] name too long\n",
+			root->objectid,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset);
+		}
+		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
+		if (len != namelen || strncmp(namebuf, name, len))
+			goto next;
+
+		ret = 0;
+		goto out;
+next:
+		len = sizeof(*di) + name_len + data_len;
+		di = (struct btrfs_dir_item *)((char *)di + len);
+		cur += len;
+	}
+	if (ret == DIR_ITEM_MISMATCH)
+		error(
+		"root %llu INODE %s[%llu %llu] and %s[%llu %llu] mismatch namelen %u filename %s filetype %d",
+			root->objectid,
+			ref_key->type == BTRFS_INODE_REF_KEY ? "REF" : "EXTREF",
+			ref_key->objectid, ref_key->offset,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+				"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, namelen, name,
+			imode_to_type(mode));
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



