Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731686AbeGSOPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:15:41 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F472AF46
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 13:32:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: remove remaing full_sync logic from btrfs_sync_file
Date: Thu, 19 Jul 2018 15:32:20 +0200
Message-Id: <20180719133220.2666-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The logic to check if the inode is already in the log can now be
simplified since we always wait for the ordered extents to complete
before deciding whether the inode needs to be logged. The big comment
about it can go away too.

CC: Filipe Manana <fdmanana@suse.com>
Suggested-by: Filipe Manana <fdmanana@suse.com>
[ code and changelog copied from mail discussion ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file.c         | 37 +------------------------------------
 fs/btrfs/ordered-data.c | 14 --------------
 fs/btrfs/ordered-data.h |  3 ---
 3 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 206462a78630..2be00e873e92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2039,7 +2039,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_log_ctx ctx;
 	int ret = 0, err;
-	bool full_sync = false;
 	u64 len;
 
 	/*
@@ -2063,8 +2062,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	inode_lock(inode);
 	atomic_inc(&root->log_batch);
-	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			     &BTRFS_I(inode)->runtime_flags);
 
 	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
@@ -2077,41 +2074,9 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 	atomic_inc(&root->log_batch);
 
-	/*
-	 * If the last transaction that changed this file was before the current
-	 * transaction and we have the full sync flag set in our inode, we can
-	 * bail out now without any syncing.
-	 *
-	 * Note that we can't bail out if the full sync flag isn't set. This is
-	 * because when the full sync flag is set we start all ordered extents
-	 * and wait for them to fully complete - when they complete they update
-	 * the inode's last_trans field through:
-	 *
-	 *     btrfs_finish_ordered_io() ->
-	 *         btrfs_update_inode_fallback() ->
-	 *             btrfs_update_inode() ->
-	 *                 btrfs_set_inode_last_trans()
-	 *
-	 * So we are sure that last_trans is up to date and can do this check to
-	 * bail out safely. For the fast path, when the full sync flag is not
-	 * set in our inode, we can not do it because we start only our ordered
-	 * extents and don't wait for them to complete (that is when
-	 * btrfs_finish_ordered_io runs), so here at this point their last_trans
-	 * value might be less than or equals to fs_info->last_trans_committed,
-	 * and setting a speculative last_trans for an inode when a buffered
-	 * write is made (such as fs_info->generation + 1 for example) would not
-	 * be reliable since after setting the value and before fsync is called
-	 * any number of transactions can start and commit (transaction kthread
-	 * commits the current transaction periodically), and a transaction
-	 * commit does not start nor waits for ordered extents to complete.
-	 */
 	smp_mb();
 	if (btrfs_inode_in_log(BTRFS_I(inode), fs_info->generation) ||
-	    (full_sync && BTRFS_I(inode)->last_trans <=
-	     fs_info->last_trans_committed) ||
-	    (!btrfs_have_ordered_extents_in_range(inode, start, len) &&
-	     BTRFS_I(inode)->last_trans
-	     <= fs_info->last_trans_committed)) {
+	    BTRFS_I(inode)->last_trans <= fs_info->last_trans_committed) {
 		/*
 		 * We've had everything committed since the last time we were
 		 * modified so clear this flag in case it was set for whatever
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index d1dd0104e77e..0c4ef208b8b9 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -789,20 +789,6 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(
 	return entry;
 }
 
-bool btrfs_have_ordered_extents_in_range(struct inode *inode,
-					 u64 file_offset,
-					 u64 len)
-{
-	struct btrfs_ordered_extent *oe;
-
-	oe = btrfs_lookup_ordered_range(BTRFS_I(inode), file_offset, len);
-	if (oe) {
-		btrfs_put_ordered_extent(oe);
-		return true;
-	}
-	return false;
-}
-
 /*
  * lookup and return any extent before 'file_offset'.  NULL is returned
  * if none is found
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index b2d3f6a091f7..02d813aaa261 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -178,9 +178,6 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(
 		struct btrfs_inode *inode,
 		u64 file_offset,
 		u64 len);
-bool btrfs_have_ordered_extents_in_range(struct inode *inode,
-					 u64 file_offset,
-					 u64 len);
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
-- 
2.18.0

