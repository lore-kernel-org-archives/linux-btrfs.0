Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57299 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2FZUNV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:13:21 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id Kumtc63hQWEDsTgv (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 14:13:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: change how we indicate we're adding csums
Date: Tue, 26 Jun 2012 16:17:54 -0400
Message-ID: <1340741874-9244-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is weird logic I had to put in place to make sure that when we were
adding csums that we'd used the delalloc block rsv instead of the global
block rsv.  Part of this meant that we had to free up our transaction
reservation before we ran the delayed refs since csum deletion happens
during the delayed ref work.  The problem with this is that when we release
a reservation we will add it to the global reserve if it is not full in
order to keep us going along longer before we have to force a transaction
commit.  By releasing our reservation before we run delayed refs we don't
get the opportunity to drain down the global reserve for the work we did, so
we won't refill it as often.  This isn't a problem per-se, it just results
in us possibly committing transactions more and more often, and in rare
cases could cause those WARN_ON()'s to pop in use_block_rsv because we ran
out of space in our block rsv.

This also helps us by holding onto space while the delayed refs run so we
don't end up with as many people trying to do things at the same time, which
again will help us not force commits or hit the use_block_rsv warnings.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    8 +++++++-
 fs/btrfs/file-item.c   |    2 ++
 fs/btrfs/transaction.c |   22 ++++++++--------------
 fs/btrfs/transaction.h |    1 +
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 570ac47..e552ba5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3962,7 +3962,10 @@ static struct btrfs_block_rsv *get_block_rsv(
 {
 	struct btrfs_block_rsv *block_rsv = NULL;
 
-	if (root->ref_cows || root == root->fs_info->csum_root)
+	if (root->ref_cows)
+		block_rsv = trans->block_rsv;
+
+	if (root == root->fs_info->csum_root && trans->adding_csums)
 		block_rsv = trans->block_rsv;
 
 	if (!block_rsv)
@@ -4314,6 +4317,9 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root)
 {
+	if (!trans->block_rsv)
+		return;
+
 	if (!trans->bytes_reserved)
 		return;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5d158d3..863c34d 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -690,6 +690,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	sector_sum = sums->sums;
+	trans->adding_csums = 1;
 again:
 	next_offset = (u64)-1;
 	found_next = 0;
@@ -853,6 +854,7 @@ next_sector:
 		goto again;
 	}
 out:
+	trans->adding_csums = 0;
 	btrfs_free_path(path);
 	return ret;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e5f1b15..021c6e2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -351,6 +351,7 @@ again:
 	h->bytes_reserved = 0;
 	h->delayed_ref_updates = 0;
 	h->use_count = 1;
+	h->adding_csums = 0;
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
 	h->aborted = 0;
@@ -473,7 +474,6 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	struct btrfs_block_rsv *rsv = trans->block_rsv;
 	int updates;
 	int err;
 
@@ -481,12 +481,6 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 	if (cur_trans->blocked || cur_trans->delayed_refs.flushing)
 		return 1;
 
-	/*
-	 * We need to do this in case we're deleting csums so the global block
-	 * rsv get's used instead of the csum block rsv.
-	 */
-	trans->block_rsv = NULL;
-
 	updates = trans->delayed_ref_updates;
 	trans->delayed_ref_updates = 0;
 	if (updates) {
@@ -495,8 +489,6 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 			return err;
 	}
 
-	trans->block_rsv = rsv;
-
 	return should_end_transaction(trans, root);
 }
 
@@ -513,8 +505,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	btrfs_trans_release_metadata(trans, root);
-	trans->block_rsv = NULL;
 	while (count < 2) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
@@ -527,6 +517,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		}
 		count++;
 	}
+	btrfs_trans_release_metadata(trans, root);
+	trans->block_rsv = NULL;
 
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
 	    should_end_transaction(trans, root)) {
@@ -1269,9 +1261,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_run_ordered_operations(root, 0);
 
-	btrfs_trans_release_metadata(trans, root);
-	trans->block_rsv = NULL;
-
 	if (cur_trans->aborted)
 		goto cleanup_transaction;
 
@@ -1282,6 +1271,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto cleanup_transaction;
 
+	btrfs_trans_release_metadata(trans, root);
+	trans->block_rsv = NULL;
+
 	cur_trans = trans->transaction;
 
 	/*
@@ -1532,6 +1524,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	return ret;
 
 cleanup_transaction:
+	btrfs_trans_release_metadata(trans, root);
+	trans->block_rsv = NULL;
 	btrfs_printk(root->fs_info, "Skipping commit of aborted transaction.\n");
 //	WARN_ON(1);
 	if (current->journal_info == trans)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index fe27379..d314a74 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -57,6 +57,7 @@ struct btrfs_trans_handle {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
 	int aborted;
+	int adding_csums;
 };
 
 struct btrfs_pending_snapshot {
-- 
1.7.7.6

