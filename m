Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50487 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752345AbdDKDZJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:09 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0544447CE222
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:05 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs-progs: check: dir isize fix in lowmem
Date: Tue, 11 Apr 2017 11:26:28 +0800
Message-ID: <20170411032631.24932-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After traversal of whole directory, we should get the actual isize.

Introduce function 'repair_dir_isize_lowmem' to set isize in the directory
inode item to actual size. After call of the function, the wrong dir isize
should have been corrected.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2bdf6a20..6ab18b26 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4876,6 +4876,62 @@ out:
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
@@ -5011,9 +5067,15 @@ out:
 		}
 
 		if (isize != size) {
-			err |= ISIZE_ERROR;
-			error("root %llu DIR INODE [%llu] size(%llu) not equal to %llu",
-			      root->objectid, inode_id, isize, size);
+			if (repair)
+				ret = repair_dir_isize_lowmem(root, path,
+							      inode_id, size);
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
2.12.0



