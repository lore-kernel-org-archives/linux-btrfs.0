Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34923 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755583AbdIGSYO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 14:24:14 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v87IOEhS012061
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODTD008847
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:14 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODjn002972
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: remove nr_async_submits and async_submit_draining
Date: Thu,  7 Sep 2017 11:22:22 -0600
Message-Id: <20170907172222.20444-4-bo.li.liu@oracle.com>
In-Reply-To: <20170907172222.20444-1-bo.li.liu@oracle.com>
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have the combo of flushing twice, which can make sure IO
have started since the second flush will wait for page lock which
won't be unlocked unless setting page writeback and queuing ordered
extents, we don't need %async_submit_draining, %async_delalloc_pages
and %nr_async_submits to tell whether IO have actually started.

Moreover, all the flushers in use are followed by functions that wait
for ordered extents to complete, so %nr_async_submits, which tracks
whether bio's async submit has made progress, doesn't really make
sense.

However, %async_delalloc_pages is still required by shrink_delalloc()
as that function doesn't flush twice in the normal case (just issues a
writeback with WB_REASON_FS_FREE_SPACE).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h   |  2 --
 fs/btrfs/disk-io.c | 24 ------------------------
 fs/btrfs/inode.c   | 28 ----------------------------
 3 files changed, 54 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 27cd882..a226097 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -879,8 +879,6 @@ struct btrfs_fs_info {
 	rwlock_t tree_mod_log_lock;
 	struct rb_root tree_mod_log;
 
-	atomic_t nr_async_submits;
-	atomic_t async_submit_draining;
 	atomic_t async_delalloc_pages;
 	atomic_t open_ioctl_trans;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 95583e2..fabe302 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -879,22 +879,9 @@ static void run_one_async_start(struct btrfs_work *work)
 
 static void run_one_async_done(struct btrfs_work *work)
 {
-	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
-	int limit;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	fs_info = async->fs_info;
-
-	limit = btrfs_async_submit_limit(fs_info);
-	limit = limit * 2 / 3;
-
-	/*
-	 * atomic_dec_return implies a barrier for waitqueue_active
-	 */
-	if (atomic_dec_return(&fs_info->nr_async_submits) < limit &&
-	    waitqueue_active(&fs_info->async_submit_wait))
-		wake_up(&fs_info->async_submit_wait);
 
 	/* If an error occurred we just want to clean up the bio and move on */
 	if (async->status) {
@@ -942,19 +929,10 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	async->status = 0;
 
-	atomic_inc(&fs_info->nr_async_submits);
-
 	if (op_is_sync(bio->bi_opf))
 		btrfs_set_work_high_priority(&async->work);
 
 	btrfs_queue_work(fs_info->workers, &async->work);
-
-	while (atomic_read(&fs_info->async_submit_draining) &&
-	      atomic_read(&fs_info->nr_async_submits)) {
-		wait_event(fs_info->async_submit_wait,
-			   (atomic_read(&fs_info->nr_async_submits) == 0));
-	}
-
 	return 0;
 }
 
@@ -2654,9 +2632,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
 	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
 			     BTRFS_BLOCK_RSV_DELOPS);
-	atomic_set(&fs_info->nr_async_submits, 0);
 	atomic_set(&fs_info->async_delalloc_pages, 0);
-	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 24bcd5c..f58528b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1209,13 +1209,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 
 		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
 
-		while (atomic_read(&fs_info->async_submit_draining) &&
-		       atomic_read(&fs_info->async_delalloc_pages)) {
-			wait_event(fs_info->async_submit_wait,
-				   (atomic_read(&fs_info->async_delalloc_pages) ==
-				    0));
-		}
-
 		*nr_written += nr_pages;
 		start = cur_end + 1;
 	}
@@ -10235,19 +10228,6 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	ret = __start_delalloc_inodes(root, delay_iput, -1);
 	if (ret > 0)
 		ret = 0;
-	/*
-	 * the filemap_flush will queue IO into the worker threads, but
-	 * we have to make sure the IO is actually started and that
-	 * ordered extents get created before we return
-	 */
-	atomic_inc(&fs_info->async_submit_draining);
-	while (atomic_read(&fs_info->nr_async_submits) ||
-	       atomic_read(&fs_info->async_delalloc_pages)) {
-		wait_event(fs_info->async_submit_wait,
-			   (atomic_read(&fs_info->nr_async_submits) == 0 &&
-			    atomic_read(&fs_info->async_delalloc_pages) == 0));
-	}
-	atomic_dec(&fs_info->async_submit_draining);
 	return ret;
 }
 
@@ -10289,14 +10269,6 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 	spin_unlock(&fs_info->delalloc_root_lock);
 
 	ret = 0;
-	atomic_inc(&fs_info->async_submit_draining);
-	while (atomic_read(&fs_info->nr_async_submits) ||
-	      atomic_read(&fs_info->async_delalloc_pages)) {
-		wait_event(fs_info->async_submit_wait,
-		   (atomic_read(&fs_info->nr_async_submits) == 0 &&
-		    atomic_read(&fs_info->async_delalloc_pages) == 0));
-	}
-	atomic_dec(&fs_info->async_submit_draining);
 out:
 	if (!list_empty_careful(&splice)) {
 		spin_lock(&fs_info->delalloc_root_lock);
-- 
2.9.4

