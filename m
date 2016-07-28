Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44034 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163457AbcG1HJC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:02 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 278C542AB37C
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:46 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 03/13] btrfs-progs: check: introduce function to check inode_ref
Date: Thu, 28 Jul 2016 15:08:15 +0800
Message-ID: <1469689705-26836-4-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function check_inode_ref() to check INODE_REF,
and call find_dir_item() to find the related DIR_ITEM/DIR_INDEX.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 7e6f2a9..be35240 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -41,6 +41,7 @@
 #include "rbtree-utils.h"
 #include "backref.h"
 #include "ulist.h"
+#include "hash.h"
 
 enum task_position {
 	TASK_EXTENTS,
@@ -4016,6 +4017,82 @@ out:
 	return ret;
 }
 
+/*
+ * Traverse the given INODE_REF and call find_dir_item() to find related
+ * DIR_ITEM/DIR_INDEX.
+ *
+ * @root:	the root of the fs/file tree
+ * @ref_key:	the key of the INODE_REF
+ * @refs:	the count of INODE_REF
+ * @mode:	the st_mode of INODE_ITEM
+ *
+ * Return 0 if no error occurred.
+ */
+static int check_inode_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
+			   struct extent_buffer *node, int slot, u64 *refs,
+			   int mode)
+{
+	struct btrfs_key key;
+	struct btrfs_inode_ref *ref;
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len;
+	u64 index;
+	int ret, err = 0;
+
+	ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
+	total = btrfs_item_size_nr(node, slot);
+
+next:
+	/* Update inode ref count */
+	(*refs)++;
+
+	index = btrfs_inode_ref_index(node, ref);
+	name_len = btrfs_inode_ref_name_len(node, ref);
+	if (name_len <= BTRFS_NAME_LEN) {
+		len = name_len;
+	} else {
+		len = BTRFS_NAME_LEN;
+		fprintf(stderr,
+		"Warning: root %llu INODE_REF[%llu %llu] name too long\n",
+		root->objectid, ref_key->objectid, ref_key->offset);
+	}
+
+	read_extent_buffer(node, namebuf, (unsigned long)(ref + 1), len);
+
+	/* Check root dir ref name */
+	if (index == 0 && strncmp(namebuf, "..", name_len)) {
+		error(
+		"root %llu INODE_REF[%llu %llu] ROOT_DIR name shouldn't be %s",
+		root->objectid, ref_key->objectid, ref_key->offset, namebuf);
+		err |= ROOT_DIR_ERROR;
+	}
+
+	/* Find related dir_index */
+	key.objectid = ref_key->offset;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = index;
+	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	err |= ret;
+
+	/* Find related dir_item */
+	key.objectid = ref_key->offset;
+	key.type = BTRFS_DIR_ITEM_KEY;
+	key.offset = btrfs_name_hash(namebuf, len);
+	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	err |= ret;
+
+	len = sizeof(*ref) + name_len;
+	ref = (struct btrfs_inode_ref *)((char *)ref + len);
+	cur += len;
+	if (cur < total)
+		goto next;
+
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



