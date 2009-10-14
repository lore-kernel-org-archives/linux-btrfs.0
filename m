From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] properly wait log writers during log sync
Date: Wed, 14 Oct 2009 16:00:34 +0800
Message-ID: <4AD58522.2070707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A recently fsync optimization make btrfs_sync_log skip calling
wait_for_writer in the single log writer case. This is incorrect
since the writer count can also be increased by btrfs_pin_log.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2009-10-14 09:31:46.631606303 +0800
+++ 2/fs/btrfs/tree-log.c	2009-10-14 15:56:15.095844476 +0800
@@ -1995,12 +1995,13 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
 		wait_log_commit(trans, root, root->log_transid - 1);
 
-	while (root->log_multiple_pids) {
+	while (1) {
 		unsigned long batch = root->log_batch;
-		mutex_unlock(&root->log_mutex);
-		schedule_timeout_uninterruptible(1);
-		mutex_lock(&root->log_mutex);
-
+		if (root->log_multiple_pids) {
+			mutex_unlock(&root->log_mutex);
+			schedule_timeout_uninterruptible(1);
+			mutex_lock(&root->log_mutex);
+		}
 		wait_for_writer(trans, root);
 		if (batch == root->log_batch)
 			break;
