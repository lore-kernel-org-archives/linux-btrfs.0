Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3275 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752098AbcIUDQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 09/14] btrfs-progs: check: introduce function to check fs root
Date: Wed, 21 Sep 2016 11:15:59 +0800
Message-Id: <20160921031604.23334-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_fs_root_v2() to check fs root,
and call check_inode_item to check the items in the tree.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5e3ecac..6d3c6a8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3862,6 +3862,7 @@ out:
 #define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
 #define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
 #define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
+#define NO_INODE_ITEM		(1<<14) /* no inode_item */
 #define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
 
 /*
@@ -4681,6 +4682,81 @@ out:
 	return err;
 }
 
+/*
+ * Iterate all item on the tree and call check_inode_item() to check.
+ *
+ * @root:	the root of the tree to be checked.
+ * @ext_ref:	the EXTENDED_IREF feature
+ *
+ * Return 0 if no error found.
+ * Return <0 for error.
+ * All internal error bitmap will be converted to -EIO, to avoid
+ * mixing negative and postive return value.
+ */
+static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 inode_id;
+	int ret, err = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		/*
+		 * All check must start with inode item, skip if not
+		 */
+		if (key.type == BTRFS_INODE_ITEM_KEY) {
+			ret = check_inode_item(root, path, ext_ref);
+			err |= ret;
+			if (err & LAST_ITEM)
+				goto out;
+			continue;
+		}
+		error("root %llu ITEM[%llu %u %llu] isn't INODE_ITEM, skip to next inode",
+		      root->objectid, key.objectid, key.type,
+		      key.offset);
+
+		err |= NO_INODE_ITEM;
+		inode_id = key.objectid;
+
+		/*
+		 * skip to next inode
+		 * TODO: Maybe search_slot() will be faster?
+		 */
+		do {
+			ret = btrfs_next_item(root, path);
+			if (ret > 0) {
+				goto out;
+			} else if (ret < 0) {
+				err = ret;
+				goto out;
+			}
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+		} while (inode_id == key.objectid);
+	}
+
+out:
+	err &= ~LAST_ITEM;
+	if (err && !ret)
+		ret = -EIO;
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct list_head *cur = rec->backrefs.next;
-- 
2.10.0



