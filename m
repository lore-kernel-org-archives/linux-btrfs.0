From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: optimize fsync for the single writer case
Date: Thu, 8 Oct 2009 15:39:33 -0400
Message-ID: <20091008193932.GD16258@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch optimizes the tree logging stuff so it doesn't always wait 1 jiffie
for new people to join the logging transaction if there is only ever 1 writer.
This helps a little bit with latency where we have something like RPM where it
will fdatasync every file it writes, and so waiting the 1 jiffie for every
fdatasync really starts to add up.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h    |    2 ++
 fs/btrfs/tree-log.c |   12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2aeb3a8..f77935e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1001,6 +1001,8 @@ struct btrfs_root {
 	atomic_t log_commit[2];
 	unsigned long log_transid;
 	unsigned long log_batch;
+	pid_t log_start_pid;
+	bool log_multiple_pids;
 
 	u64 objectid;
 	u64 last_trans;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f4a7b62..a38f6f3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -137,11 +137,20 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
+		if (!root->log_start_pid) {
+			root->log_start_pid = current->pid;
+			root->log_multiple_pids = false;
+		} else if (root->log_start_pid != current->pid) {
+			root->log_multiple_pids = true;
+		}
+
 		root->log_batch++;
 		atomic_inc(&root->log_writers);
 		mutex_unlock(&root->log_mutex);
 		return 0;
 	}
+	root->log_multiple_pids = false;
+	root->log_start_pid = current->pid;
 	mutex_lock(&root->fs_info->tree_log_mutex);
 	if (!root->fs_info->log_root_tree) {
 		ret = btrfs_init_log_root_tree(trans, root->fs_info);
@@ -1985,7 +1994,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
 		wait_log_commit(trans, root, root->log_transid - 1);
 
-	while (1) {
+	while (root->log_multiple_pids) {
 		unsigned long batch = root->log_batch;
 		mutex_unlock(&root->log_mutex);
 		schedule_timeout_uninterruptible(1);
@@ -2011,6 +2020,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	root->log_batch = 0;
 	root->log_transid++;
 	log->log_transid = root->log_transid;
+	root->log_start_pid = 0;
 	smp_mb();
 	/*
 	 * log tree has been flushed to disk, new modifications of
-- 
1.5.4.3

