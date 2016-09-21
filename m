Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3275 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753066AbcIUDQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 14/14] btrfs-progs: check: Enhance leaf traversal function to handle missing inode item
Date: Wed, 21 Sep 2016 11:16:04 +0800
Message-Id: <20160921031604.23334-15-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The leaf traversal function in lowmem mode will skip to the first inode
item of leaf and begin to check the inode.

That's designed to avoid checking overlapping part of a leaf.

But that will cause problem in fsck/010 test case, as in that case inode
item of the first inode(256) is missing.
So above traversal will check from inode 257 and found nothing wrong.

The fix is done in 2 part:
1) Manually check the first inode
   To avoid case like fsck/010

2) Check inode if ino changes from the first ino of a leaf
   To avoid missing inode_item problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d290a66..f5be153 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1875,6 +1875,7 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_key key;
 	u64 cur_bytenr;
 	u32 nritems;
+	u64 first_ino = 0;
 	int root_level = btrfs_header_level(root->node);
 	int i;
 	int ret = 0; /* Final return value */
@@ -1882,11 +1883,14 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
 
 	cur_bytenr = cur->start;
 
-	/* skip to first inode item in this leaf */
+	/* skip to first inode item or the first inode number change */
 	nritems = btrfs_header_nritems(cur);
 	for (i = 0; i < nritems; i++) {
 		btrfs_item_key_to_cpu(cur, &key, i);
-		if (key.type == BTRFS_INODE_ITEM_KEY)
+		if (i == 0)
+			first_ino = key.objectid;
+		if (key.type == BTRFS_INODE_ITEM_KEY ||
+		    (first_ino && first_ino != key.objectid))
 			break;
 	}
 	if (i == nritems) {
@@ -4951,6 +4955,34 @@ out:
 	return err;
 }
 
+static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int err = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	key.objectid = 256;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+	if (ret > 0) {
+		ret = 0;
+		err |= INODE_ITEM_MISSING;
+	}
+
+	err |= check_inode_item(root, path, ext_ref);
+	err &= ~LAST_ITEM;
+	if (err && !ret)
+		ret = -EIO;
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Iterate all item on the tree and call check_inode_item() to check.
  *
@@ -4968,6 +5000,16 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 	int ret, wret;
 	int level;
 
+	/*
+	 * We need to manually check the first inode item(256)
+	 * As the following traversal function will only start from
+	 * the first inode item in the leaf, if inode item(256) is missing
+	 * we will just skip it forever.
+	 */
+	ret = check_fs_first_inode(root, ext_ref);
+	if (ret < 0)
+		return ret;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
2.10.0



