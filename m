From: Jan Kara <jack@suse.cz>
Subject: [PATCH] btrfs: Fix busyloops in transaction waiting code
Date: Thu, 26 Jan 2012 17:11:36 +0100
Message-ID: <1327594296-23688-1-git-send-email-jack@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

wait_log_commit() and wait_for_writer() were using slightly different
conditions for deciding whether they should call schedule() and whether they
should continue in the wait loop. Thus it could happen that we busylooped when
the first condition was not true while the second one was. That is burning CPU
cycles needlessly and is deadly on UP machines...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/tree-log.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cb877e0..966cc74 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1957,7 +1957,8 @@ static int wait_log_commit(struct btrfs_trans_handle *trans,
 
 		finish_wait(&root->log_commit_wait[index], &wait);
 		mutex_lock(&root->log_mutex);
-	} while (root->log_transid < transid + 2 &&
+	} while (root->fs_info->last_trans_log_full_commit !=
+		 trans->transid && root->log_transid < transid + 2 &&
 		 atomic_read(&root->log_commit[index]));
 	return 0;
 }
@@ -1966,7 +1967,8 @@ static int wait_for_writer(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
-	while (atomic_read(&root->log_writers)) {
+	while (root->fs_info->last_trans_log_full_commit !=
+	       trans->transid && atomic_read(&root->log_writers)) {
 		prepare_to_wait(&root->log_writer_wait,
 				&wait, TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&root->log_mutex);
-- 
1.7.1

