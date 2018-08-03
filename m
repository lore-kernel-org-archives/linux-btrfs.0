Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:64189 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbeHCIQp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 04:16:45 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CBE89AC01E3
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 15:21:51 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id E0D246D688F
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 15:21:50 +0900 (JST)
Subject: [PATCH v2] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
Message-ID: <9e46637d-f717-7210-06e2-a077a58d9638@jp.fujitsu.com>
Date: Fri, 3 Aug 2018 15:21:12 +0900
MIME-Version: 1.0
In-Reply-To: <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When qgroup is on, subvolume deletion does not remove qgroup item
of the subvolume (qgroup info, limits, relation) from quota tree and
they needs to get removed manually by "btrfs qgroup destroy".

Since level 0 qgroup cannot be used/inherited by any other subvolume,
let's remove them automatically when subvolume is deleted
(to be precise, when the subvolume root is dropped).

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
Note that btrfs/057 fails, but it is the problem of testcase.
I will update it too.

v1 -> v2:
  Move call of btrfs_remove_qgroup() from btrfs_delete_subvolume()
  to btrfs_snapshot_destroy() so that it will be called after the
  subvolume root is really dropped

 fs/btrfs/extent-tree.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e7b237b9547..b56dea8c8b9f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct walk_control *wc;
 	struct btrfs_key key;
+	u64 objectid = root->objectid;
 	int err = 0;
 	int ret;
 	int level;
 	bool root_dropped = false;
 
-	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
+	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		goto out_end_trans;
 	}
 
-	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+	if (objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		ret = btrfs_find_root(tree_root, &root->root_key, path,
 				      NULL, NULL);
 		if (ret < 0) {
@@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 			 *
 			 * The most common failure here is just -ENOENT.
 			 */
-			btrfs_del_orphan_item(trans, tree_root,
-					      root->root_key.objectid);
+			btrfs_del_orphan_item(trans, tree_root, objectid);
 		}
 	}
 
@@ -9056,6 +9056,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		btrfs_put_fs_root(root);
 	}
 	root_dropped = true;
+
+	 /* Remove level-0 qgroup items since no other subvolume can use them */
+	ret = btrfs_remove_qgroup(trans, objectid);
+	if (ret && ret != -EINVAL && ret != -ENOENT) {
+		btrfs_abort_transaction(trans, ret);
+		err = ret;
+	}
+
 out_end_trans:
 	btrfs_end_transaction_throttle(trans);
 out_free:
-- 
2.14.4


