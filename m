From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 05/16] Btrfs: use wait_event()
Date: Thu, 14 Jul 2011 11:17:00 +0800
Message-ID: <4E1E5FAC.3040906@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Use wait_event() when possible to avoid code duplication.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |   59 +++++------------------------------------------
 1 files changed, 7 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 51dcec8..34a30ea 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -216,17 +216,11 @@ static void wait_current_trans(struct btrfs_root *root)
 	spin_lock(&root->fs_info->trans_lock);
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans && cur_trans->blocked) {
-		DEFINE_WAIT(wait);
 		atomic_inc(&cur_trans->use_count);
 		spin_unlock(&root->fs_info->trans_lock);
-		while (1) {
-			prepare_to_wait(&root->fs_info->transaction_wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-			if (!cur_trans->blocked)
-				break;
-			schedule();
-		}
-		finish_wait(&root->fs_info->transaction_wait, &wait);
+
+		wait_event(root->fs_info->transaction_wait,
+			   !cur_trans->blocked);
 		put_transaction(cur_trans);
 	} else {
 		spin_unlock(&root->fs_info->trans_lock);
@@ -362,15 +356,7 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root
 static noinline int wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
 {
-	DEFINE_WAIT(wait);
-	while (!commit->commit_done) {
-		prepare_to_wait(&commit->commit_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (commit->commit_done)
-			break;
-		schedule();
-	}
-	finish_wait(&commit->commit_wait, &wait);
+	wait_event(commit->commit_wait, commit->commit_done);
 	return 0;
 }
 
@@ -1080,22 +1066,7 @@ int btrfs_transaction_blocked(struct btrfs_fs_info *info)
 static void wait_current_trans_commit_start(struct btrfs_root *root,
 					    struct btrfs_transaction *trans)
 {
-	DEFINE_WAIT(wait);
-
-	if (trans->in_commit)
-		return;
-
-	while (1) {
-		prepare_to_wait(&root->fs_info->transaction_blocked_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (trans->in_commit) {
-			finish_wait(&root->fs_info->transaction_blocked_wait,
-				    &wait);
-			break;
-		}
-		schedule();
-		finish_wait(&root->fs_info->transaction_blocked_wait, &wait);
-	}
+	wait_event(root->fs_info->transaction_blocked_wait, trans->in_commit);
 }
 
 /*
@@ -1105,24 +1076,8 @@ static void wait_current_trans_commit_start(struct btrfs_root *root,
 static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
 					 struct btrfs_transaction *trans)
 {
-	DEFINE_WAIT(wait);
-
-	if (trans->commit_done || (trans->in_commit && !trans->blocked))
-		return;
-
-	while (1) {
-		prepare_to_wait(&root->fs_info->transaction_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		if (trans->commit_done ||
-		    (trans->in_commit && !trans->blocked)) {
-			finish_wait(&root->fs_info->transaction_wait,
-				    &wait);
-			break;
-		}
-		schedule();
-		finish_wait(&root->fs_info->transaction_wait,
-			    &wait);
-	}
+	wait_event(root->fs_info->transaction_wait,
+		   trans->commit_done || (trans->in_commit && !trans->blocked));
 }
 
 /*
-- 
1.7.3.1
