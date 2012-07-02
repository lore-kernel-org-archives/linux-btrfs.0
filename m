Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58033 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2GBVKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 17:10:45 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id MXDla98cQLIbR50w (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 15:10:43 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: rework shrink_delalloc
Date: Mon, 2 Jul 2012 17:15:29 -0400
Message-ID: <1341263729-26101-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So shrink_delalloc has grown all sorts of cruft over the years thanks to
many reworkings of how we track enospc.  What happens now as we fill up the
disk is we will loop for freaking ever hoping to reclaim a arbitrary amount
of space of metadata, this was from when everybody flushed at the same time.
Now we only have people flushing one at a time.  So instead of trying to
reclaim a huge amount of space, just try to flush a decent chunk of space,
and stop looping as soon as we have enough free space to satisfy our
reservation.  This makes xfstests 224 go much faster.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   81 ++++++++++++++---------------------------------
 1 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a1d9d2..e66967c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3585,89 +3585,58 @@ out:
 /*
  * shrink metadata reservation for delalloc
  */
-static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim,
-			   bool wait_ordered)
+static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
+			    bool wait_ordered)
 {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
-	u64 reserved;
+	u64 delalloc_bytes;
 	u64 max_reclaim;
-	u64 reclaimed = 0;
 	long time_left;
 	unsigned long nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
 	int loops = 0;
-	unsigned long progress;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
 	space_info = block_rsv->space_info;
 
 	smp_mb();
-	reserved = space_info->bytes_may_use;
-	progress = space_info->reservation_progress;
-
-	if (reserved == 0)
-		return 0;
-
-	smp_mb();
-	if (root->fs_info->delalloc_bytes == 0) {
+	delalloc_bytes = root->fs_info->delalloc_bytes;
+	if (delalloc_bytes == 0) {
 		if (trans)
-			return 0;
+			return;
 		btrfs_wait_ordered_extents(root, 0, 0);
-		return 0;
+		return;
 	}
 
-	max_reclaim = min(reserved, to_reclaim);
-	nr_pages = max_t(unsigned long, nr_pages,
-			 max_reclaim >> PAGE_CACHE_SHIFT);
-	while (loops < 1024) {
-		/* have the flusher threads jump in and do some IO */
-		smp_mb();
-		nr_pages = min_t(unsigned long, nr_pages,
-		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
+	while (delalloc_bytes && loops < 3) {
+		max_reclaim = min(delalloc_bytes, to_reclaim);
+		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
-						WB_REASON_FS_FREE_SPACE);
+					       WB_REASON_FS_FREE_SPACE);
 
 		spin_lock(&space_info->lock);
-		if (reserved > space_info->bytes_may_use)
-			reclaimed += reserved - space_info->bytes_may_use;
-		reserved = space_info->bytes_may_use;
+		if (space_info->bytes_used + space_info->bytes_reserved +
+		    space_info->bytes_pinned + space_info->bytes_readonly +
+		    space_info->bytes_may_use + orig <=
+		    space_info->total_bytes) {
+			spin_unlock(&space_info->lock);
+			break;
+		}
 		spin_unlock(&space_info->lock);
 
 		loops++;
-
-		if (reserved == 0 || reclaimed >= max_reclaim)
-			break;
-
-		if (trans && trans->transaction->blocked)
-			return -EAGAIN;
-
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_extents(root, 0, 0);
 		} else {
-			time_left = schedule_timeout_interruptible(1);
-
-			/* We were interrupted, exit */
+			time_left = schedule_timeout_killable(1);
 			if (time_left)
 				break;
 		}
-
-		/* we've kicked the IO a few times, if anything has been freed,
-		 * exit.  There is no sense in looping here for a long time
-		 * when we really need to commit the transaction, or there are
-		 * just too many writers without enough free space
-		 */
-
-		if (loops > 3) {
-			smp_mb();
-			if (progress != space_info->reservation_progress)
-				break;
-		}
-
+		smp_mb();
+		delalloc_bytes = root->fs_info->delalloc_bytes;
 	}
-
-	return reclaimed >= to_reclaim;
 }
 
 /**
@@ -3741,15 +3710,13 @@ static int flush_space(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *trans;
 	int nr;
-	int ret;
+	int ret = 0;
 
 	switch (state) {
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		ret = shrink_delalloc(root, num_bytes,
-				      state == FLUSH_DELALLOC_WAIT);
-		if (ret > 0)
-			ret = 0;
+		shrink_delalloc(root, num_bytes, orig_bytes,
+				state == FLUSH_DELALLOC_WAIT);
 		break;
 	case FLUSH_DELAYED_ITEMS_NR:
 	case FLUSH_DELAYED_ITEMS:
-- 
1.7.7.6

