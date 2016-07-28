Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163430AbcG1HJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:03 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 3E61042BA386
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:48 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 06/13] btrfs-progs: check: introduce a function to check dir_item
Date: Thu, 28 Jul 2016 15:08:18 +0800
Message-ID: <1469689705-26836-7-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function check_dir_item() to check DIR_ITEM/DIR_INDEX,
and call find_inode_ref() to find the related INODE_REF/INODE_EXTREF.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 501c5e0..ad261f2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3883,6 +3883,8 @@ out:
 #define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
 #define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
 #define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
+#define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
+#define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
 
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
@@ -4324,6 +4326,141 @@ out:
 	return ret;
 }
 
+/*
+ * Traverse the given DIR_ITEM/DIR_INDEX and check related INODE_ITEM and
+ * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.
+ *
+ * @root:	the root of the fs/file tree
+ * @key:	the key of the INODE_REF/INODE_EXTREF
+ * @size:	the st_size of the INODE_ITEM
+ * @ext_ref:	the EXTENDED_IREF feature
+ *
+ * Return 0 if no error occurred.
+ */
+static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
+			  struct extent_buffer *node, int slot, u64 *size,
+			  unsigned int ext_ref)
+{
+	struct btrfs_dir_item *di;
+	struct btrfs_inode_item *ii;
+	struct btrfs_path path;
+	struct btrfs_key location;
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len;
+	u32 data_len;
+	u8 filetype;
+	u32 mode;
+	u64 index;
+	int ret;
+	int err = 0;
+
+	/*
+	 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
+	 * ignore index check.
+	 */
+	index = (key->type == BTRFS_DIR_INDEX_KEY) ? key->offset : (u64)-1;
+
+	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
+	total = btrfs_item_size_nr(node, slot);
+
+	while (cur < total) {
+		data_len = btrfs_dir_data_len(node, di);
+		if (data_len)
+			error(
+			"root %llu %s[%llu %llu] data_len shouldn't be %u",
+			root->objectid,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, data_len);
+
+		name_len = btrfs_dir_name_len(node, di);
+		if (name_len <= BTRFS_NAME_LEN) {
+			len = name_len;
+		} else {
+			len = BTRFS_NAME_LEN;
+			fprintf(stderr,
+				"Warning: root %llu %s[%llu %llu] name too long\n",
+				root->objectid,
+				key->type == BTRFS_DIR_ITEM_KEY ?
+				"DIR_ITEM" : "DIR_INDEX",
+				key->objectid, key->offset);
+		}
+		(*size) += name_len;
+
+		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
+		filetype = btrfs_dir_type(node, di);
+
+		btrfs_init_path(&path);
+		btrfs_dir_item_key_to_cpu(node, di, &location);
+
+		/* Ignore related ROOT_ITEM check */
+		if (location.type == BTRFS_ROOT_ITEM_KEY)
+			goto next;
+
+		/* Check relative INODE_ITEM(existence/filetype) */
+		ret = btrfs_search_slot(NULL, root, &location, &path, 0, 0);
+		if (ret) {
+			err |= INODE_ITEM_MISSING;
+			error(
+			"root %llu %s[%llu %llu] couldn't find relative INODE_ITEM[%llu] namelen %u filename %s filetype %x",
+			root->objectid,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, location.objectid,
+			name_len, namebuf, filetype);
+			goto next;
+		}
+
+		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_inode_item);
+		mode = btrfs_inode_mode(path.nodes[0], ii);
+
+		if (imode_to_type(mode) != filetype) {
+			err |= INODE_ITEM_MISMATCH;
+			error(
+			"root %llu %s[%llu %llu] relative INODE_ITEM filetype mismatch namelen %u filename %s filetype %d",
+			root->objectid,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, name_len, namebuf,
+			filetype);
+		}
+
+		/* Check relative INODE_REF/INODE_EXTREF */
+		location.type = BTRFS_INODE_REF_KEY;
+		location.offset = key->objectid;
+		ret = find_inode_ref(root, &location, namebuf, len,
+				       index, ext_ref);
+		err |= ret;
+		if (ret & INODE_REF_MISSING)
+			error(
+			"root %llu %s[%llu %llu] relative INODE_REF missing namelen %u filename %s filetype %d",
+			root->objectid,
+			key->type == BTRFS_DIR_ITEM_KEY ?
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, name_len, namebuf,
+			filetype);
+
+next:
+		btrfs_release_path(&path);
+		len = sizeof(*di) + name_len + data_len;
+		di = (struct btrfs_dir_item *)((char *)di + len);
+		cur += len;
+
+		if (key->type == BTRFS_DIR_INDEX_KEY && cur < total) {
+			error(
+			"root %llu DIR_INDEX[%llu %llu] should contain only one entry",
+			root->objectid, key->objectid, key->offset);
+			break;
+		}
+	}
+
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



