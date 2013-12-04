Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16890 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3LDNRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 08:17:15 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rB4DHD7g010686
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Dec 2013 21:17:13 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: wrap repeated code into scrub_blocked_if_needed()
Date: Wed, 4 Dec 2013 21:16:53 +0800
Message-Id: <1386163013-1904-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just wrap same code into one function scrub_blocked_if_needed().

This make a change that we will move waiting (@workers_pending = 0)
before we can wake up commiting transaction(atomic_inc(@scrub_paused)), 
we must take carefully to not deadlock here.

Thread 1			Thread 2
				|->btrfs_commit_transaction()
					|->set trans type(COMMIT_DOING)
					|->btrfs_scrub_paused()(blocked)
|->join_transaction(blocked)

Move btrfs_scrub_paused() before setting trans type which means we can
still join a transaction when commiting_transaction is blocked.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Suggested-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c       | 43 +++++++++++++++++--------------------------
 fs/btrfs/transaction.c |  3 ++-
 2 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d27f95e..fced60c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -257,6 +257,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace);
 static void copy_nocow_pages_worker(struct btrfs_work *work);
+static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 
 
@@ -271,7 +272,7 @@ static void scrub_pending_bio_dec(struct scrub_ctx *sctx)
 	wake_up(&sctx->list_wait);
 }
 
-static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
+static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 {
 	while (atomic_read(&fs_info->scrub_pause_req)) {
 		mutex_unlock(&fs_info->scrub_lock);
@@ -281,6 +282,19 @@ static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
 	}
 }
 
+static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info)
+{
+	atomic_inc(&fs_info->scrubs_paused);
+	wake_up(&fs_info->scrub_pause_wait);
+
+	mutex_lock(&fs_info->scrub_lock);
+	__scrub_blocked_if_needed(fs_info);
+	atomic_dec(&fs_info->scrubs_paused);
+	mutex_unlock(&fs_info->scrub_lock);
+
+	wake_up(&fs_info->scrub_pause_wait);
+}
+
 /*
  * used for workers that require transaction commits (i.e., for the
  * NOCOW case)
@@ -2315,8 +2329,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 	wait_event(sctx->list_wait,
 		   atomic_read(&sctx->bios_in_flight) == 0);
-	atomic_inc(&fs_info->scrubs_paused);
-	wake_up(&fs_info->scrub_pause_wait);
+	scrub_blocked_if_needed(fs_info);
 
 	/* FIXME it might be better to start readahead at commit root */
 	key_start.objectid = logical;
@@ -2340,12 +2353,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	if (!IS_ERR(reada2))
 		btrfs_reada_wait(reada2);
 
-	mutex_lock(&fs_info->scrub_lock);
-	scrub_blocked_if_needed(fs_info);
-	atomic_dec(&fs_info->scrubs_paused);
-	mutex_unlock(&fs_info->scrub_lock);
-
-	wake_up(&fs_info->scrub_pause_wait);
 
 	/*
 	 * collect all data csums for the stripe to avoid seeking during
@@ -2382,15 +2389,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			wait_event(sctx->list_wait,
 				   atomic_read(&sctx->bios_in_flight) == 0);
 			atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
-			atomic_inc(&fs_info->scrubs_paused);
-			wake_up(&fs_info->scrub_pause_wait);
-
-			mutex_lock(&fs_info->scrub_lock);
 			scrub_blocked_if_needed(fs_info);
-			atomic_dec(&fs_info->scrubs_paused);
-			mutex_unlock(&fs_info->scrub_lock);
-
-			wake_up(&fs_info->scrub_pause_wait);
 		}
 
 		key.objectid = logical;
@@ -2705,17 +2704,9 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->bios_in_flight) == 0);
 		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
-		atomic_inc(&fs_info->scrubs_paused);
-		wake_up(&fs_info->scrub_pause_wait);
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->workers_pending) == 0);
-
-		mutex_lock(&fs_info->scrub_lock);
 		scrub_blocked_if_needed(fs_info);
-		atomic_dec(&fs_info->scrubs_paused);
-		mutex_unlock(&fs_info->scrub_lock);
-
-		wake_up(&fs_info->scrub_pause_wait);
 
 		btrfs_put_block_group(cache);
 		if (ret)
@@ -2932,7 +2923,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 * checking @scrub_pause_req here, we can avoid
 	 * race between committing transaction and scrubbing.
 	 */
-	scrub_blocked_if_needed(fs_info);
+	__scrub_blocked_if_needed(fs_info);
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 57c16b4..cc17d3e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1746,6 +1746,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 
 	btrfs_wait_delalloc_flush(root->fs_info);
+
+	btrfs_scrub_pause(root);
 	/*
 	 * Ok now we need to make sure to block out any other joins while we
 	 * commit the transaction.  We could have started a join before setting
@@ -1810,7 +1812,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	WARN_ON(cur_trans != trans->transaction);
 
-	btrfs_scrub_pause(root);
 	/* btrfs_commit_tree_roots is responsible for getting the
 	 * various roots consistent with each other.  Every pointer
 	 * in the tree of tree roots has to point to the most up to date
-- 
1.8.3.1

