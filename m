Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44034 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163652AbcG1HJM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:12 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 4CC1742BA383
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:50 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 09/13] btrfs-progs: check: introduce function to check fs root
Date: Thu, 28 Jul 2016 15:08:21 +0800
Message-ID: <1469689705-26836-10-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function check_fs_root_v2() to check fs root,
and call check_inode_item to check the items in the tree.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index a9a5c08..756e7a1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3892,6 +3892,7 @@ out:
 #define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
 #define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
 #define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
+#define NO_INODE_ITEM		(1<<14) /* no inode_item */
 #define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
 
 /*
@@ -4725,6 +4726,81 @@ out:
 	return err;
 }
 
+/*
+ * Iterate all item on the tree and call check_inode_item() to check.
+ *
+ * @root:	the root of the tree to be checked.
+ * @ext_ref:	the EXTENDED_IREF feature
+ *
+ * Return 0 if no error found.
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
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
+
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		/*
+		 * All check must start with inode item, skip if not
+		 */
+		if (btrfs_key_type(&key) == BTRFS_INODE_ITEM_KEY) {
+			ret = check_inode_item(root, path, ext_ref);
+			if (ret == -EIO)
+				goto out;
+			err |= ret;
+			if (err & LAST_ITEM)
+				goto out;
+		} else {
+			error(
+			"root %llu ITEM[%llu %u %llu] isn't INODE_ITEM, skip to next inode",
+			root->objectid, key.objectid, key.type, key.offset);
+			goto skip;
+		}
+
+		continue;
+
+skip:
+		err |= NO_INODE_ITEM;
+		inode_id = key.objectid;
+
+		/* skip to next inode */
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
+	btrfs_free_path(path);
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



