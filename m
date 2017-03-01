Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751688AbdCADSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:08 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 669D847D8B60
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:10 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 01/20] btrfs-progs: cmds-check.c: supports inode nbytes fix in lowmem
Date: Wed, 1 Mar 2017 11:13:44 +0800
Message-ID: <20170301031403.23902-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a function 'repair_inode_nbytes_lowmem' to correct inode item nbytes
error in lowmem mode.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9cc1932c..40f9d21e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1907,6 +1907,9 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
 again:
 	err |= check_inode_item(root, path, ext_ref);
 
+	/* remodified cur since check_inode_item may change path */
+	cur = path->nodes[0];
+
 	if (err & LAST_ITEM)
 		goto out;
 
@@ -2256,6 +2259,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			ret = process_one_leaf_v2(root, path, nrefs,
 						  level, ext_ref);
+			cur = path->nodes[*level];
 			break;
 		} else {
 			ret = btrfs_check_node(root, NULL, cur);
@@ -4819,10 +4823,69 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 }
 
 /*
+ * Set inode item nbytes to @nbytes
+ *
+ * Returns <0  means on error
+ * Returns  0  means successful repair
+ */
+static int repair_inode_nbytes_lowmem(struct btrfs_root *root,
+				      struct btrfs_path *path,
+				      u64 ino, u64 nbytes)
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
+	btrfs_set_inode_nbytes(path->nodes[0], ii, nbytes);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	printf("reset nbytes for inode %llu root %llu\n", ino,
+	       root->root_key.objectid);
+
+	btrfs_commit_transaction(trans, root);
+out:
+	if (ret < 0)
+		error("failed to reset nbytes for inode %llu root %llu due to %s",
+		      ino, root->root_key.objectid, strerror(-ret));
+
+	/* research path */
+	btrfs_release_path(path);
+	ret2 = btrfs_search_slot(NULL, root, &research_key, path, 0, 0);
+	return ret2 < 0 ? ret2 : ret;
+}
+
+/*
  * Check INODE_ITEM and related ITEMs (the same inode number)
  * 1. check link count
  * 2. check inode ref/extref
  * 3. check dir item/index
+ * Be Careful, if repair is enable, @path may be changed.
+ * Remember to reassign any context about @path in repair mode.
  *
  * @ext_ref:	the EXTENDED_IREF feature
  *
@@ -4972,9 +5035,17 @@ out:
 		}
 
 		if (nbytes != extent_size) {
-			err |= NBYTES_ERROR;
-			error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
-			      root->objectid, inode_id, nbytes, extent_size);
+			if (repair) {
+				ret = repair_inode_nbytes_lowmem(root, path,
+								 inode_id,
+								 extent_size);
+			}
+			if (!repair || ret) {
+				err |= NBYTES_ERROR;
+				error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
+				      root->objectid, inode_id, nbytes,
+				      extent_size);
+			}
 		}
 	}
 
@@ -12798,11 +12869,10 @@ int cmd_check(int argc, char **argv)
 	}
 
 	/*
-	 * Not supported yet
+	 * Support partially
 	 */
 	if (repair && check_mode == CHECK_MODE_LOWMEM) {
-		error("low memory mode doesn't support repair yet");
-		exit(1);
+		warning("low memory mode support repair partially");
 	}
 
 	radix_tree_init();
-- 
2.11.1



