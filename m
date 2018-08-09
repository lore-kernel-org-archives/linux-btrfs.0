Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:50518 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbeHIJ3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 05:29:16 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DDBA9AC0096
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 16:05:41 +0900 (JST)
Subject: [PATCH v5] btrfs: qgroup: Remove qgroup items along with subvolume
 deletion
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
Message-ID: <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
Date: Thu, 9 Aug 2018 16:05:36 +0900
MIME-Version: 1.0
In-Reply-To: <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When qgroup is on, subvolume deletion does not remove qgroup items
of the subvolume (qgroup info, limit, relation) from quota tree and
they need to get removed manually by "btrfs qgroup destroy".

Since level 0 qgroup cannot be used/inherited by any other subvolume,
let's remove them automatically when subvolume is deleted
(to be precise, when the subvolume root is dropped).

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
v4 -> v5:
  Commit current transaction before calling btrfs_remove_qgroup() to
  keep qgroup consistency in all case. This resolves the concern in
  v4 path and there should be no demerit in this patch.

 fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e7b237b9547..ed052105e741 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct walk_control *wc;
 	struct btrfs_key key;
+	u64 objectid = root->root_key.objectid;
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
 
@@ -9056,6 +9056,43 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		btrfs_put_fs_root(root);
 	}
 	root_dropped = true;
+
+	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
+		/*
+		 * Remove level-0 qgroup items since no other subvolume can
+		 * use them.
+		 *
+		 * First, commit current transaction in order to make sure
+		 * this subvolume's excl == rfer == 0. Otherwise removing
+		 * qgroup relation causes qgroup inconsistency if excl != rfer.
+		 */
+		ret = btrfs_commit_transaction(trans);
+		if (ret)
+			goto out_free;
+
+		/* Start new transaction and remove qgroup items */
+		trans = btrfs_start_transaction(tree_root, 0);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			goto out_free;
+		}
+
+		ret = btrfs_remove_qgroup(trans, objectid);
+		if (ret == 1) {
+			/*
+			 * This means qgroup becomes inconsistent
+			 * (should not happen since we did transaction commit)
+			 */
+			btrfs_warn(fs_info,
+			"qgroup inconsistency found, need qgroup rescan");
+		} else if (ret == -EINVAL || ret == -ENOENT) {
+			/* qgroup is already removed, just ignore this */
+		} else if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			err = ret;
+		}
+	}
+
 out_end_trans:
 	btrfs_end_transaction_throttle(trans);
 out_free:
-- 
2.14.4

