From: Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Add missing unlocks on error paths
Date: Thu, 26 Apr 2012 00:04:51 +0800
Message-ID: <1335369891-19137-1-git-send-email-daniel@quora.org>
Cc: "Josef Bacik" <josef@redhat.com>,
	Daniel J Blueman <daniel@quora.org>
To: linux-btrfs@vger.kernel.org, "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Correctly drop locks during error cases.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 fs/btrfs/transaction.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 11b77a5..ede3988 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -73,8 +73,11 @@ loop:
 
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans) {
-		if (cur_trans->aborted)
+		if (cur_trans->aborted) {
+			spin_unlock(&root->fs_info->trans_lock);
 			return cur_trans->aborted;
+		}
+
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
@@ -1400,6 +1403,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
@@ -1411,6 +1415,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_cowonly_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
-- 
1.7.9.5

