Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3E1KEe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 06:04:34 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4SA4UGE023652
	for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2013 18:04:30 +0800
Message-ID: <51A48173.5040000@cn.fujitsu.com>
Date: Tue, 28 May 2013 18:05:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: merge pending IO for tree log write back
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, we flushed the log tree of the fs/file
tree firstly, and then flushed the log root tree. It is ineffective,
especially on the hard disk. This patch improved this problem by wrapping
the above two flushes by the same blk_plug.

By test, the performance of the sync write went up ~60%(2.9MB/s -> 4.6MB/s)
on my scsi disk whose disk buffer was enabled.

Test step:
 # mkfs.btrfs -f -m single <disk>
 # mount <disk> <mnt>
 # dd if=/dev/zero of=<mnt>/file0 bs=32K count=1024 oflag=sync

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |  6 +++---
 fs/btrfs/tree-log.c    | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0544587..ce51603 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -736,9 +736,7 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 	struct extent_state *cached_state = NULL;
 	u64 start = 0;
 	u64 end;
-	struct blk_plug plug;
 
-	blk_start_plug(&plug);
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      mark, &cached_state)) {
 		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT,
@@ -752,7 +750,6 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 	}
 	if (err)
 		werr = err;
-	blk_finish_plug(&plug);
 	return werr;
 }
 
@@ -797,8 +794,11 @@ int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 {
 	int ret;
 	int ret2;
+	struct blk_plug plug;
 
+	blk_start_plug(&plug);
 	ret = btrfs_write_marked_extents(root, dirty_pages, mark);
+	blk_finish_plug(&plug);
 	ret2 = btrfs_wait_marked_extents(root, dirty_pages, mark);
 
 	if (ret)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c276ac9..209d789 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -18,6 +18,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 #include <linux/list_sort.h>
 #include "ctree.h"
 #include "transaction.h"
@@ -2358,6 +2359,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
 	unsigned long log_transid = 0;
+	struct blk_plug plug;
 
 	mutex_lock(&root->log_mutex);
 	log_transid = root->log_transid;
@@ -2401,8 +2403,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	/* we start IO on  all the marked extents here, but we don't actually
 	 * wait for them until later.
 	 */
+	blk_start_plug(&plug);
 	ret = btrfs_write_marked_extents(log, &log->dirty_log_pages, mark);
 	if (ret) {
+		blk_finish_plug(&plug);
 		btrfs_abort_transaction(trans, root, ret);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&root->log_mutex);
@@ -2437,6 +2441,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	if (ret) {
+		blk_finish_plug(&plug);
 		if (ret != -ENOSPC) {
 			btrfs_abort_transaction(trans, root, ret);
 			mutex_unlock(&log_root_tree->log_mutex);
@@ -2452,6 +2457,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	index2 = log_root_tree->log_transid % 2;
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
+		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		wait_log_commit(trans, log_root_tree,
 				log_root_tree->log_transid);
@@ -2474,6 +2480,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * check the full commit flag again
 	 */
 	if (root->fs_info->last_trans_log_full_commit == trans->transid) {
+		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
@@ -2481,9 +2488,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out_wake_log_root;
 	}
 
-	ret = btrfs_write_and_wait_marked_extents(log_root_tree,
-				&log_root_tree->dirty_log_pages,
-				EXTENT_DIRTY | EXTENT_NEW);
+	ret = btrfs_write_marked_extents(log_root_tree,
+					 &log_root_tree->dirty_log_pages,
+					 EXTENT_DIRTY | EXTENT_NEW);
+	blk_finish_plug(&plug);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
 		btrfs_free_logged_extents(log, log_transid);
@@ -2491,6 +2499,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out_wake_log_root;
 	}
 	btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+	btrfs_wait_marked_extents(log_root_tree,
+				  &log_root_tree->dirty_log_pages,
+				  EXTENT_NEW | EXTENT_DIRTY);
 	btrfs_wait_logged_extents(log, log_transid);
 
 	btrfs_set_super_log_root(root->fs_info->super_for_commit,
-- 
1.8.1.4
