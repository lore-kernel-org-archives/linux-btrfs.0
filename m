Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60392 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758131Ab2IFKow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A4d38017638
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:04:40 +0800
Message-ID: <5048752B.1040902@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:04:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 10/12] Btrfs: fix unprotected ->log_batch
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

We forget to protect ->log_batch when syncing a file, this patch fix
this problem by atomic operation. And ->log_batch is used to check
if there are parallel sync operations or not, so it is unnecessary to
reset it to 0 after the sync operation of the current log tree complete.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- new patch.
---
 fs/btrfs/ctree.h    |    2 +-
 fs/btrfs/disk-io.c  |    2 +-
 fs/btrfs/file.c     |    4 ++--
 fs/btrfs/tree-log.c |   12 +++++-------
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 171458a..dbb461f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1490,9 +1490,9 @@ struct btrfs_root {
 	wait_queue_head_t log_commit_wait[2];
 	atomic_t log_writers;
 	atomic_t log_commit[2];
+	atomic_t log_batch;
 	unsigned long log_transid;
 	unsigned long last_log_commit;
-	unsigned long log_batch;
 	pid_t log_start_pid;
 	bool log_multiple_pids;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0c0f8eb..7fb7069 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1168,8 +1168,8 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->log_commit[0], 0);
 	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
+	atomic_set(&root->log_batch, 0);
 	atomic_set(&root->orphan_inodes, 0);
-	root->log_batch = 0;
 	root->log_transid = 0;
 	root->last_log_commit = 0;
 	extent_io_tree_init(&root->dirty_log_pages,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9aa01ec..af888da 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1520,9 +1520,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * ordered range does a filemape_write_and_wait_range which is why we
 	 * don't do it above like other file systems.
 	 */
-	root->log_batch++;
+	atomic_inc(&root->log_batch);
 	btrfs_wait_ordered_range(inode, start, end);
-	root->log_batch++;
+	atomic_inc(&root->log_batch);
 
 	/*
 	 * check the transaction that last modified this inode
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..71a2d19 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -146,7 +146,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 			root->log_multiple_pids = true;
 		}
 
-		root->log_batch++;
+		atomic_inc(&root->log_batch);
 		atomic_inc(&root->log_writers);
 		mutex_unlock(&root->log_mutex);
 		return 0;
@@ -165,7 +165,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 			err = ret;
 	}
 	mutex_unlock(&root->fs_info->tree_log_mutex);
-	root->log_batch++;
+	atomic_inc(&root->log_batch);
 	atomic_inc(&root->log_writers);
 	mutex_unlock(&root->log_mutex);
 	return err;
@@ -2037,7 +2037,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
 		wait_log_commit(trans, root, root->log_transid - 1);
 	while (1) {
-		unsigned long batch = root->log_batch;
+		int batch = atomic_read(&root->log_batch);
 		/* when we're on an ssd, just kick the log commit out */
 		if (!btrfs_test_opt(root, SSD) && root->log_multiple_pids) {
 			mutex_unlock(&root->log_mutex);
@@ -2045,7 +2045,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 			mutex_lock(&root->log_mutex);
 		}
 		wait_for_writer(trans, root);
-		if (batch == root->log_batch)
+		if (batch == atomic_read(&root->log_batch))
 			break;
 	}
 
@@ -2074,7 +2074,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	btrfs_set_root_node(&log->root_item, log->node);
 
-	root->log_batch = 0;
 	root->log_transid++;
 	log->log_transid = root->log_transid;
 	root->log_start_pid = 0;
@@ -2087,7 +2086,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&root->log_mutex);
 
 	mutex_lock(&log_root_tree->log_mutex);
-	log_root_tree->log_batch++;
+	atomic_inc(&log_root_tree->log_batch);
 	atomic_inc(&log_root_tree->log_writers);
 	mutex_unlock(&log_root_tree->log_mutex);
 
@@ -2157,7 +2156,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	btrfs_set_super_log_root_level(root->fs_info->super_for_commit,
 				btrfs_header_level(log_root_tree->node));
 
-	log_root_tree->log_batch = 0;
 	log_root_tree->log_transid++;
 	smp_mb();
 
-- 
1.7.6.5
