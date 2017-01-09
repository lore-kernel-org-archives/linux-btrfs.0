Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41070 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932110AbdAIFiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 00:38:20 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 6C34D46701DB
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jan 2017 13:37:58 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: cmds-check.c: supports inode isize fix in lowmem
Date: Mon, 9 Jan 2017 13:38:08 +0800
Message-ID: <20170109053808.1979-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170109053808.1979-1-suy.fnst@cn.fujitsu.com>
References: <20170109053808.1979-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a function 'repair_inode_isize' to support inode isize repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 567ca80..088c0d8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2457,6 +2457,45 @@ out:
 }
 
 /*
+ * Set inode's isize to correct value in @info
+ *
+ * Returns <0  means on error
+ * Returns  0  means successful repair
+ */
+static int repair_inode_isize_lowmem(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct inode_item_fix_info *info)
+{
+	struct btrfs_inode_item *ei;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	int ret;
+
+	ASSERT(info);
+	key.objectid = info->ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_inode_item);
+	btrfs_set_inode_size(path.nodes[0], ei, info->isize);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	printf("reset isize for inode %llu root %llu\n", info->ino,
+	       root->root_key.objectid);
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
  * repair_inode_item - repair inode item errors
  *
  * Repair the inode item if error can be repaired. Any caller should compare
@@ -2484,7 +2523,7 @@ static int repair_inode_item(struct btrfs_root *root,
 		ret = 0;
 		goto out;
 	}
-	if (!(err & NBYTES_ERROR)) {
+	if (!(err & NBYTES_ERROR) && !(err & ISIZE_ERROR)) {
 		warning("root %llu INODE[%llu] have error(s) can't repair, error : %d",
 			root->objectid,	info->ino, err);
 		/* can't fix any errors, ret should be positive */
@@ -2505,6 +2544,13 @@ static int repair_inode_item(struct btrfs_root *root,
 		else if (ret < 0)
 			goto out;
 	}
+	if (err & ISIZE_ERROR) {
+		ret = repair_inode_isize_lowmem(trans, root, info);
+		if (ret == 0)
+			err &= ~ISIZE_ERROR;
+		else if (ret < 0)
+			goto out;
+	}
 
 	if (err != info->err) {
 		info->err = err;
@@ -5039,6 +5085,7 @@ out:
 
 		if (isize != size) {
 			err |= ISIZE_ERROR;
+			info->isize = size;
 			error("root %llu DIR INODE [%llu] size(%llu) not equal to %llu",
 			      root->objectid, inode_id, isize, size);
 		}
-- 
2.11.0



