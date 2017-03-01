Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21599 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751800AbdCADZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:25:38 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id AA2E347D8B81
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:17 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 13/20] btrfs-progs: cmds-check.c: repair_inode_item_missing
Date: Wed, 1 Mar 2017 11:13:56 +0800
Message-ID: <20170301031403.23902-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'repair_inode_item_missing' to fix INODE_ITEM_MISSING
This patch is for further repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 256bfbc9..6dafbd7d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5463,6 +5463,49 @@ out:
 }
 
 /*
+ * Insert the missing inode item.
+ *
+ * Returns 0 means success.
+ * Returns <0 means error.
+ */
+static int repair_inode_item_missing(struct btrfs_root *root, u64 ino,
+				     u8 filetype, int err)
+{
+	struct btrfs_key key;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path path;
+	int ret;
+
+	if (!err)
+		return 0;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_search_slot(trans, root, &key, &path, 1, 1);
+	if (ret < 0 || !ret)
+		goto out;
+	/* insert inode item */
+	create_inode_item_lowmem(trans, root, ino, filetype);
+	ret = 0;
+	btrfs_commit_transaction(trans, root);
+out:
+	if (ret)
+		error("Failed to repair root %llu INODE ITEM[%llu] missing",
+		      root->objectid, ino);
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
  * check first root dir's inode_item, inde_ref
  *
  * returns 0 means no error
-- 
2.11.1



