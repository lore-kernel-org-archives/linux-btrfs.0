From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add missing unlocks to transaction abort paths
Date: Mon,  2 Apr 2012 18:31:37 +0200
Message-ID: <1333384297-8954-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, dan.carpenter@oracle.com,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Added in commit 49b25e0540904be0bf558b84475c69d72e4de66e
("btrfs: enhance transaction abort infrastructure")

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/transaction.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8da29e8..9bfa262 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -73,8 +73,10 @@ loop:
 
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans) {
-		if (cur_trans->aborted)
+		if (cur_trans->aborted) {
+			spin_unlock(&root->fs_info->trans_lock);
 			return cur_trans->aborted;
+		}
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
@@ -1399,6 +1401,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
@@ -1410,6 +1413,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_cowonly_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
-- 
1.7.6.233.gd79bc

