Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44732 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751465AbdCADrA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:47:00 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E9C4A47C4EAD
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:12 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 05/20] btrfs-progs: cmds-check.c: modify check_fs_first_inode
Date: Wed, 1 Mar 2017 11:13:48 +0800
Message-ID: <20170301031403.23902-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify check_fs_first_inode to check firt_inode inode item and inode ref.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 57 ++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 246f4735..892a22ba 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5169,42 +5169,68 @@ out:
 	return err;
 }
 
+/*
+ * check first root dir's inode_item, inde_ref
+ *
+ * returns 0 means no error
+ * returns >0 means error
+ * returns <0 means fatal error
+ */
 static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
+	struct btrfs_inode_item *ii;
+	u64 index = 0;
+	u32 mode;
 	int err = 0;
 	int ret;
 
-	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
-	key.type = BTRFS_INODE_ITEM_KEY;
-	key.offset = 0;
-
 	/* For root being dropped, we don't need to check first inode */
 	if (btrfs_root_refs(&root->root_item) == 0 &&
 	    btrfs_disk_key_objectid(&root->root_item.drop_progress) >=
-	    key.objectid)
+	    BTRFS_FIRST_FREE_OBJECTID)
 		return 0;
 
+	/*search first inode item */
+	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
 	btrfs_init_path(&path);
 
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0)
+	if (ret < 0) {
 		goto out;
-	if (ret > 0) {
-		ret = 0;
+	} else if (ret > 0) {
 		err |= INODE_ITEM_MISSING;
-		error("first inode item of root %llu is missing",
-		      root->objectid);
+	} else {
+		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_inode_item);
+		mode = btrfs_inode_mode(path.nodes[0], ii);
+		if (imode_to_type(mode) != BTRFS_FT_DIR)
+			err |= INODE_ITEM_MISMATCH;
 	}
+	btrfs_release_path(&path);
+
+	/* lookup first inode ref */
+	key.offset = BTRFS_FIRST_FREE_OBJECTID;
+	key.type = BTRFS_INODE_REF_KEY;
+
+	ret = find_inode_ref(root, &key, "..", strlen(".."), &index, ext_ref);
+	if (ret < 0)
+		goto out;
+	err |= ret;
 
-	err |= check_inode_item(root, &path, ext_ref);
-	err &= ~LAST_ITEM;
-	if (err && !ret)
-		ret = -EIO;
 out:
 	btrfs_release_path(&path);
-	return ret;
+	if (err & (INODE_ITEM_MISSING | INODE_ITEM_MISMATCH))
+		error("root dir INODE_ITEM is %s",
+		      err & INODE_ITEM_MISMATCH ? "mismatch" : "missing");
+	if (err & INODE_REF_MISSING)
+		error("root dir INODE_REF is missing");
+
+	return ret < 0 ? ret : err;
 }
 
 /*
@@ -5232,6 +5258,7 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 	 * we will just skip it forever.
 	 */
 	ret = check_fs_first_inode(root, ext_ref);
+	err |= !!ret;
 	if (ret < 0)
 		return ret;
 
-- 
2.11.1



