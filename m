Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3275 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753528AbcIUDQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:34 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 03/14] btrfs-progs: check: introduce function to check inode_ref
Date: Wed, 21 Sep 2016 11:15:53 +0800
Message-Id: <20160921031604.23334-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_inode_ref() to check INODE_REF,
and call find_dir_item() to find the related DIR_ITEM/DIR_INDEX.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 4e25804..90d5fbc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -41,6 +41,7 @@
 #include "rbtree-utils.h"
 #include "backref.h"
 #include "ulist.h"
+#include "hash.h"
 
 enum task_position {
 	TASK_EXTENTS,
@@ -3988,6 +3989,81 @@ out:
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
+		warning("root %llu INODE_REF[%llu %llu] name too long",
+			root->objectid, ref_key->objectid, ref_key->offset);
+	}
+
+	read_extent_buffer(node, namebuf, (unsigned long)(ref + 1), len);
+
+	/* Check root dir ref name */
+	if (index == 0 && strncmp(namebuf, "..", name_len)) {
+		error("root %llu INODE_REF[%llu %llu] ROOT_DIR name shouldn't be %s",
+		      root->objectid, ref_key->objectid, ref_key->offset,
+		      namebuf);
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
 	struct list_head *cur = rec->backrefs.next;
-- 
2.10.0



