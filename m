Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25417 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751516AbdBUIfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:35:13 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9D17E47C4E90
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2017 16:34:48 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 12/12] btrfs-progs: cmds-check.c: walk_down_tree_v2 break cause of leaf process
Date: Tue, 21 Feb 2017 16:34:38 +0800
Message-ID: <20170221083438.25719-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

In lowmem mode, 'walk_down_tree_v2' returns negative values wheather
the error is fatal or not. It causes the loop where 'walk_down_tree_v2'
is to break even the error is tolerated and then subsequent nodes process
will be skipped.

Fix it by redefining meanings of values 'walk_down_tree_v2' returns.
Do a similar fix for 'process_one_leaf_v2'.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7d273623..9cc1932c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1868,6 +1868,11 @@ static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
 static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 			    unsigned int ext_ref);
 
+/*
+ * Returns >0  Found error, not fatal, should continue process
+ * Returns <0  Fata error, must exit the whole check
+ * returns 0   No error is found
+ */
 static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
 			       struct node_refs *nrefs, int *level, int ext_ref)
 {
@@ -1937,13 +1942,8 @@ again:
 	}
 out:
 	err &= ~LAST_ITEM;
-	/*
-	 * Convert any error bitmap to -EIO, as we should avoid
-	 * mixing positive and negative return value to represent
-	 * error
-	 */
 	if (err && !ret)
-		ret = -EIO;
+		ret = err;
 	return ret;
 }
 
@@ -2213,6 +2213,11 @@ out:
 static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 			    unsigned int ext_ref);
 
+/*
+ * Returns >0  Found error, should continue
+ * Returns 0   No error is found
+ * Returns <0  Fatal error, must exit the whole check
+ */
 static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 			     int *level, struct node_refs *nrefs, int ext_ref)
 {
@@ -5028,8 +5033,9 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 	struct btrfs_path path;
 	struct node_refs nrefs;
 	struct btrfs_root_item *root_item = &root->root_item;
-	int ret, wret;
+	int ret;
 	int level;
+	int err = 0;
 
 	/*
 	 * We need to manually check the first inode item(256)
@@ -5063,17 +5069,21 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 	}
 
 	while (1) {
-		wret = walk_down_tree_v2(root, &path, &level, &nrefs, ext_ref);
-		if (wret < 0)
-			ret = wret;
-		if (wret != 0)
+		ret = walk_down_tree_v2(root, &path, &level, &nrefs, ext_ref);
+		err |= !!ret;
+
+		/* if ret is negative, walk shall stop */
+		if (ret < 0) {
+			ret = err;
 			break;
+		}
 
-		wret = walk_up_tree_v2(root, &path, &level);
-		if (wret < 0)
-			ret = wret;
-		if (wret != 0)
+		ret = walk_up_tree_v2(root, &path, &level);
+		if (ret != 0) {
+			/* Normal exit, reset ret to err */
+			ret = err;
 			break;
+		}
 	}
 
 out:
-- 
2.11.1



