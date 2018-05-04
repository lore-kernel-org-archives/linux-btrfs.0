Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbeEDF5J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 01:57:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B96BAEBB
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 05:57:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of extent tree
Date: Fri,  4 May 2018 13:56:59 +0800
Message-Id: <20180504055659.1862-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Under the following case, qgroup rescan can double account cowed tree
blocks:

In this case, extent tree only has one tree block.

-
| transid=5 last committed=4
| btrfs_qgroup_rescan_worker()
| |- btrfs_start_transaction()
| |  transid = 5
| |- qgroup_rescan_leaf()
|    |- btrfs_search_slot_for_read() on extent tree
|       Get the only extent tree block from commit root (transid = 4).
|       Scan it, set qgroup_rescan_progress to the last
|       EXTENT/META_ITEM + 1
|       now qgroup_rescan_progress = A + 1.
|
| fs tree get CoWed, new tree block is at A + 16K
| transid 5 get committed
-
| transid=6 last committed=5
| btrfs_qgroup_rescan_worker()
| btrfs_qgroup_rescan_worker()
| |- btrfs_start_transaction()
| |  transid = 5
| |- qgroup_rescan_leaf()
|    |- btrfs_search_slot_for_read() on extent tree
|       Get the only extent tree block from commit root (transid = 5).
|       scan it using qgroup_rescan_progress (A + 1).
|       found new tree block beyong A, and it's fs tree block,
|       account it to increase qgroup numbers.
-

In above case, tree block A, and tree block A + 16K get accounted twice,
while qgroup rescan should stop when it already reach the last leaf,
other than continue using its qgroup_rescan_progress.

Such case could happen by just looping btrfs/017 and with some
possibility it can hit such double qgroup accounting problem.

Fix it by checking the path to determine if we should finish qgroup
rescan, other than relying on next loop to exit.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 48 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 829e8fe5c97e..2ee2d21d43ab 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2579,6 +2579,21 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 	spin_unlock(&fs_info->qgroup_lock);
 }
 
+/*
+ * Check if the leaf is the last leaf. Which means all node pointers
+ * are at their last position.
+ */
+static bool is_last_leaf(struct btrfs_path *path)
+{
+	int i;
+
+	for (i = 1; i < BTRFS_MAX_LEVEL && path->nodes[i]; i++) {
+		if (path->slots[i] != btrfs_header_nritems(path->nodes[i]) - 1)
+			return false;
+	}
+	return true;
+}
+
 /*
  * returns < 0 on error, 0 when more leafs are to be scanned.
  * returns 1 when done.
@@ -2592,6 +2607,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	struct ulist *roots = NULL;
 	struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
 	u64 num_bytes;
+	bool done;
 	int slot;
 	int ret;
 
@@ -2606,20 +2622,9 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		fs_info->qgroup_rescan_progress.type,
 		fs_info->qgroup_rescan_progress.offset, ret);
 
-	if (ret) {
-		/*
-		 * The rescan is about to end, we will not be scanning any
-		 * further blocks. We cannot unset the RESCAN flag here, because
-		 * we want to commit the transaction if everything went well.
-		 * To make the live accounting work in this phase, we set our
-		 * scan progress pointer such that every real extent objectid
-		 * will be smaller.
-		 */
-		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
-		btrfs_release_path(path);
-		mutex_unlock(&fs_info->qgroup_rescan_lock);
-		return ret;
-	}
+	done = is_last_leaf(path);
+	if (ret)
+		goto finish;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &found,
 			      btrfs_header_nritems(path->nodes[0]) - 1);
@@ -2665,8 +2670,23 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		free_extent_buffer(scratch_leaf);
 	}
 	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
+	if (done && !ret)
+		goto finish;
 
 	return ret;
+finish:
+	/*
+	 * The rescan is about to end, we will not be scanning any
+	 * further blocks. We cannot unset the RESCAN flag here, because
+	 * we want to commit the transaction if everything went well.
+	 * To make the live accounting work in this phase, we set our
+	 * scan progress pointer such that every real extent objectid
+	 * will be smaller.
+	 */
+	fs_info->qgroup_rescan_progress.objectid = (u64)-1;
+	btrfs_release_path(path);
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+	return 1;
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
-- 
2.17.0

