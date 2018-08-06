Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:53984 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeHFHBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2018 03:01:17 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id BC8A7AC0186
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 13:53:54 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id E2E8432862B
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 13:53:53 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v3] btrfs: qgroup: Remove qgroup items along with subvolume
 deletion
References: <cover.1533517699.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <3ea480fc-46ad-4072-198d-1e8f49121be0@jp.fujitsu.com>
Date: Mon, 6 Aug 2018 13:53:28 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1533517699.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When qgroup is on, subvolume deletion does not remove qgroup items
of the subvolume (qgroup info, limit, relation) from quota tree and
they need to get removed manually by "btrfs qgroup destroy".

Since level 0 qgroup cannot be used/inherited by any other subvolume,
let's remove them automatically when subvolume is deleted
(to be precise, when the subvolume root is dropped).

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
v2 -> v3:
  Use root->root_key.objectid instead of root->objectid
  Add Reviewed-by tag

v1 -> v2:
  Move call of btrfs_remove_qgroup() from btrfs_delete_subvolume()
  to btrfs_snapshot_destroy() so that it will be called after the
  subvolume root is really dropped

 fs/btrfs/extent-tree.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e7b237b9547..48edf839ed2c 100644
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


