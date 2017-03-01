Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45969 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751672AbdCADSJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 02C7147D8B88
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:11 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 02/20] btrfs-progs: cmds-check.c: supports dir isize fix in lowmem
Date: Wed, 1 Mar 2017 11:13:45 +0800
Message-ID: <20170301031403.23902-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a function 'repair_dir_isize_lowmem' to support dir isize
repair in lowmem mode.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 40f9d21e..f13ce317 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4880,6 +4880,62 @@ out:
 }
 
 /*
+ * Set dir isize to @isize
+ *
+ * Returns <0  means on error
+ * Returns  0  means successful repair
+ */
+static int repair_dir_isize_lowmem(struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   u64 ino, u64 isize)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_inode_item *ii;
+	struct btrfs_key key;
+	struct btrfs_key research_key;
+	int ret;
+	int ret2;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &research_key, path->slots[0]);
+	btrfs_release_path(path);
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_inode_item);
+	btrfs_set_inode_size(path->nodes[0], ii, isize);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	printf("reset isize for inode %llu root %llu\n", ino,
+	       root->root_key.objectid);
+
+	btrfs_commit_transaction(trans, root);
+out:
+	if (ret < 0)
+		error("failed to reset isize for inode %llu root %llu due to %s",
+		      ino, root->root_key.objectid, strerror(-ret));
+	btrfs_release_path(path);
+	ret2 = btrfs_search_slot(NULL, root, &research_key, path, 0, 0);
+	return ret2 < 0 ? ret2 : ret;
+}
+
+/*
  * Check INODE_ITEM and related ITEMs (the same inode number)
  * 1. check link count
  * 2. check inode ref/extref
@@ -5015,9 +5071,16 @@ out:
 		}
 
 		if (isize != size) {
-			err |= ISIZE_ERROR;
-			error("root %llu DIR INODE [%llu] size(%llu) not equal to %llu",
-			      root->objectid, inode_id, isize, size);
+			if (repair)
+				ret = repair_dir_isize_lowmem(root, path,
+							      inode_id,
+							      size);
+
+			if (!repair || ret) {
+				err |= ISIZE_ERROR;
+				error("root %llu DIR INODE [%llu] size(%llu) not equal to %llu",
+				      root->objectid, inode_id, isize, size);
+			}
 		}
 	} else {
 		if (nlink != refs) {
-- 
2.11.1



