From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 32/35] btrfs: Fix busyloop in transaction_kthread()
Date: Wed, 21 Mar 2012 21:11:36 -0400
Message-ID: <20120322011137.504023260@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When a filesystem got aborted due do error, transaction_kthread() will
busyloop.  Fix it by going to sleep in that case as well. Maybe we should
just stop transaction_kthread() when filesystem is aborted but that would be
more complex.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/disk-io.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 16a0cad..438993e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1640,8 +1640,10 @@ static int transaction_kthread(void *arg)
 	u64 transid;
 	unsigned long now;
 	unsigned long delay;
+	bool cannot_commit;
 
 	do {
+		cannot_commit = false;
 		delay = HZ * 30;
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
@@ -1665,8 +1667,10 @@ static int transaction_kthread(void *arg)
 
 		/* If the file system is aborted, this will always fail. */
 		trans = btrfs_join_transaction(root);
-		if (IS_ERR(trans))
+		if (IS_ERR(trans)) {
+			cannot_commit = true;
 			goto sleep;
+		}
 		if (transid == trans->transid) {
 			btrfs_commit_transaction(trans, root);
 		} else {
@@ -1679,7 +1683,8 @@ sleep:
 		if (!try_to_freeze()) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop() &&
-			    !btrfs_transaction_blocked(root->fs_info))
+			    (!btrfs_transaction_blocked(root->fs_info) ||
+			     cannot_commit))
 				schedule_timeout(delay);
 			__set_current_state(TASK_RUNNING);
 		}
-- 
1.7.9



