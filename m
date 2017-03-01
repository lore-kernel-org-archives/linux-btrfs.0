Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49904 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751435AbdCAEd3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 23:33:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8F99747D8B60
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:11 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 03/20] btrfs-progs: cmds-check.c: inode orphan item repair
Date: Wed, 1 Mar 2017 11:13:46 +0800
Message-ID: <20170301031403.23902-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a function named 'repair_inode_orphan_item_lowmem'.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index f13ce317..fb239968 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4936,6 +4936,46 @@ out:
 }
 
 /*
+ * repair ORPHAN_ITEM error
+ *
+ * Returns <0  means on error
+ * Returns  0  means successful repair
+ */
+static int repair_inode_orphan_item_lowmem(struct btrfs_root *root,
+					   struct btrfs_path *path, u64 ino)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key research_key;
+	int ret;
+	int ret2;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &research_key, path->slots[0]);
+	btrfs_release_path(path);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = btrfs_add_orphan_item(trans, root, path, ino);
+	if (ret)
+		goto out;
+
+	printf("added inode %llu orphan item root %llu", ino,
+	       root->root_key.objectid);
+
+	btrfs_commit_transaction(trans, root);
+out:
+	if (ret < 0)
+		error("failed to add inode %llu orphan item root %llu due to %s",
+		       ino, root->root_key.objectid, strerror(-ret));
+	btrfs_release_path(path);
+	ret2 = btrfs_search_slot(NULL, root, &research_key, path, 0, 0);
+
+	return ret2 < 0 ? ret2 : ret;
+}
+
+/*
  * Check INODE_ITEM and related ITEMs (the same inode number)
  * 1. check link count
  * 2. check inode ref/extref
@@ -5088,7 +5128,15 @@ out:
 			error("root %llu INODE[%llu] nlink(%llu) not equal to inode_refs(%llu)",
 			      root->objectid, inode_id, nlink, refs);
 		} else if (!nlink) {
-			err |= ORPHAN_ITEM;
+			if (repair)
+				ret = repair_inode_orphan_item_lowmem(root,
+								      path,
+								      inode_id);
+			if (!repair || ret) {
+				err |= ORPHAN_ITEM;
+				error("root %llu INODE[%llu] is orphan item",
+				      root->objectid, inode_id);
+			}
 		}
 
 		if (!nbytes && !no_holes && extent_end < isize) {
-- 
2.11.1



