Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33068 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752220AbdDKDZH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6C56547CE223
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:04 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: check: inode nbytes fix in lowmem
Date: Tue, 11 Apr 2017 11:26:27 +0800
Message-ID: <20170411032631.24932-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After checking one inode item, we should get the actual nbytes of the
inode item.
Introduce function 'repair_inode_nbytes_lowmem' to set nbytes in struct
btrfs_inode_item to the actual nbytes. After call of the function, the
wrong nbytes should have been corrected.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efbf..2bdf6a20 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1907,6 +1907,9 @@ static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
 again:
 	err |= check_inode_item(root, path, ext_ref);
 
+	/* modified cur since check_inode_item may change path */
+	cur = path->nodes[0];
+
 	if (err & LAST_ITEM)
 		goto out;
 
@@ -2255,6 +2258,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			ret = process_one_leaf_v2(root, path, nrefs,
 						  level, ext_ref);
+			cur = path->nodes[*level];
 			break;
 		} else {
 			ret = btrfs_check_node(root, NULL, cur);
@@ -4815,10 +4819,69 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
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
@@ -4968,9 +5031,16 @@ out:
 		}
 
 		if (nbytes != extent_size) {
-			err |= NBYTES_ERROR;
-			error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
-			      root->objectid, inode_id, nbytes, extent_size);
+			if (repair) {
+				ret = repair_inode_nbytes_lowmem(root, path,
+							inode_id, extent_size);
+			}
+			if (!repair || ret) {
+				err |= NBYTES_ERROR;
+				error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
+				      root->objectid, inode_id, nbytes,
+				      extent_size);
+			}
 		}
 	}
 
-- 
2.12.0



