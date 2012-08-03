Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59657 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2HCSbH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 14:31:07 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id EWNcXrSlWkeBZvob (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 12:31:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: lock extents as we map them in DIO
Date: Fri, 3 Aug 2012 14:36:09 -0400
Message-ID: <1344018969-22021-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A deadlock in xfstests 113 was uncovered by commit

d187663ef24cd3d033f0cbf2867e70b36a3a90b8

This is because we would not return EIOCBQUEUED for short AIO reads, instead
we'd wait for the DIO to complete and then return the amount of data we
transferred, which would allow our stuff to unlock the remaning amount.  But
with this change this no longer happens, so if we have a short AIO read (for
example if we try to read past EOF), we could leave the section from EOF to
the end of where we tried to read locked.  Fixing this is tricky since there
is no clear way to know exactly how much data DIO truly submitted for IO, so
to make this less hard on ourselves and less combersome we need to lock the
extents as we try to map them, and then we unlock any areas we didn't
actually map.  This makes us completely safe from deadlocks and reliance on
a particular behavior of the DIO code.  This also lays the groundwork for
allowing us to use the normal csum storage method for reads which means we
can remove an allocation.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
NOTE: This deprecates the other patch I sent for this problem, it had an issue
wehre if we failed to allocate the internal dio structure we could return
without unlocking the range.
 fs/btrfs/inode.c |  252 ++++++++++++++++++++++++++---------------------------
 1 files changed, 124 insertions(+), 128 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 48bdfd2..30f89c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5773,18 +5773,109 @@ out:
 	return ret;
 }
 
+static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
+			      struct extent_state **cached_state, int writing)
+{
+	struct btrfs_ordered_extent *ordered;
+	int ret = 0;
+
+	while (1) {
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				 0, cached_state);
+		/*
+		 * We're concerned with the entire range that we're going to be
+		 * doing DIO to, so we need to make sure theres no ordered
+		 * extents in this range.
+		 */
+		ordered = btrfs_lookup_ordered_range(inode, lockstart,
+						     lockend - lockstart + 1);
+
+		/*
+		 * We need to make sure there are no buffered pages in this
+		 * range either, we could have raced between the invalidate in
+		 * generic_file_direct_write and locking the extent.  The
+		 * invalidate needs to happen so that reads after a write do not
+		 * get stale data.
+		 */
+		if (!ordered && (!writing ||
+		    !test_range_bit(&BTRFS_I(inode)->io_tree,
+				    lockstart, lockend, EXTENT_UPTODATE, 0,
+				    *cached_state)))
+			break;
+
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				     cached_state, GFP_NOFS);
+
+		if (ordered) {
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+		} else {
+			/* Screw you mmap */
+			ret = filemap_write_and_wait_range(inode->i_mapping,
+							   lockstart,
+							   lockend);
+			if (ret)
+				break;
+
+			/*
+			 * If we found a page that couldn't be invalidated just
+			 * fall back to buffered.
+			 */
+			ret = invalidate_inode_pages2_range(inode->i_mapping,
+					lockstart >> PAGE_CACHE_SHIFT,
+					lockend >> PAGE_CACHE_SHIFT);
+			if (ret)
+				break;
+		}
+
+		cond_resched();
+	}
+
+	return ret;
+}
+
 static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_state *cached_state = NULL;
 	u64 start = iblock << inode->i_blkbits;
+	u64 lockstart, lockend;
 	u64 len = bh_result->b_size;
 	struct btrfs_trans_handle *trans;
+	int unlock_bits = EXTENT_LOCKED;
+	int ret;
+
+	lockstart = start;
+	lockend = start + len - 1;
+	if (create) {
+		ret = btrfs_delalloc_reserve_space(inode, len);
+		if (ret)
+			return ret;
+		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
+	}
+
+	/*
+	 * If this errors out it's because we couldn't invalidate pagecache for
+	 * this range and we need to fallback to buffered.
+	 */
+	if (lock_extent_direct(inode, lockstart, lockend, &cached_state, create))
+		return -ENOTBLK;
+
+	if (create) {
+		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_DELALLOC, NULL,
+				     &cached_state, GFP_NOFS);
+		if (ret)
+			goto unlock_err;
+	}
 
 	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-	if (IS_ERR(em))
-		return PTR_ERR(em);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto unlock_err;
+	}
 
 	/*
 	 * Ok for INLINE and COMPRESSED extents we need to fallback on buffered
@@ -5803,17 +5894,16 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
 	    em->block_start == EXTENT_MAP_INLINE) {
 		free_extent_map(em);
-		return -ENOTBLK;
+		ret = -ENOTBLK;
+		goto unlock_err;
 	}
 
 	/* Just a good old fashioned hole, return */
 	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
 			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 		free_extent_map(em);
-		/* DIO will do one hole at a time, so just unlock a sector */
-		unlock_extent(&BTRFS_I(inode)->io_tree, start,
-			      start + root->sectorsize - 1);
-		return 0;
+		ret = 0;
+		goto unlock_err;
 	}
 
 	/*
@@ -5826,8 +5916,9 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	 *
 	 */
 	if (!create) {
+		lockstart = start + min(len, em->len - (start - em->start));
 		len = em->len - (start - em->start);
-		goto map;
+		goto unlock;
 	}
 
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
@@ -5859,7 +5950,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 			btrfs_end_transaction(trans, root);
 			if (ret) {
 				free_extent_map(em);
-				return ret;
+				goto unlock_err;
 			}
 			goto unlock;
 		}
@@ -5872,14 +5963,12 @@ must_cow:
 	 */
 	len = bh_result->b_size;
 	em = btrfs_new_extent_direct(inode, em, start, len);
-	if (IS_ERR(em))
-		return PTR_ERR(em);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto unlock_err;
+	}
 	len = min(len, em->len - (start - em->start));
 unlock:
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, start + len - 1,
-			  EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DIRTY, 1,
-			  0, NULL, GFP_NOFS);
-map:
 	bh_result->b_blocknr = (em->block_start + (start - em->start)) >>
 		inode->i_blkbits;
 	bh_result->b_size = len;
@@ -5897,9 +5986,26 @@ map:
 			i_size_write(inode, start + len);
 	}
 
+	/*
+	 * In the case of write we need to clear and unlock the entire range,
+	 * in the case of read we need to unlock only the end area that we
+	 * aren't using if there is any left over space.
+	 */
+	if (lockstart < lockend)
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+				 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
+
 	free_extent_map(em);
 
 	return 0;
+
+unlock_err:
+	if (create)
+		unlock_bits |= EXTENT_DO_ACCOUNTING;
+
+	clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
+	return ret;
 }
 
 struct btrfs_dio_private {
@@ -6340,132 +6446,22 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 out:
 	return retval;
 }
+
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
 			unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	struct btrfs_ordered_extent *ordered;
-	struct extent_state *cached_state = NULL;
-	u64 lockstart, lockend;
-	ssize_t ret;
-	int writing = rw & WRITE;
-	int write_bits = 0;
-	size_t count = iov_length(iov, nr_segs);
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-			    offset, nr_segs)) {
+			    offset, nr_segs))
 		return 0;
-	}
-
-	lockstart = offset;
-	lockend = offset + count - 1;
-
-	if (writing) {
-		ret = btrfs_delalloc_reserve_space(inode, count);
-		if (ret)
-			goto out;
-	}
-
-	while (1) {
-		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				 0, &cached_state);
-		/*
-		 * We're concerned with the entire range that we're going to be
-		 * doing DIO to, so we need to make sure theres no ordered
-		 * extents in this range.
-		 */
-		ordered = btrfs_lookup_ordered_range(inode, lockstart,
-						     lockend - lockstart + 1);
-
-		/*
-		 * We need to make sure there are no buffered pages in this
-		 * range either, we could have raced between the invalidate in
-		 * generic_file_direct_write and locking the extent.  The
-		 * invalidate needs to happen so that reads after a write do not
-		 * get stale data.
-		 */
-		if (!ordered && (!writing ||
-		    !test_range_bit(&BTRFS_I(inode)->io_tree,
-				    lockstart, lockend, EXTENT_UPTODATE, 0,
-				    cached_state)))
-			break;
-
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     &cached_state, GFP_NOFS);
-
-		if (ordered) {
-			btrfs_start_ordered_extent(inode, ordered, 1);
-			btrfs_put_ordered_extent(ordered);
-		} else {
-			/* Screw you mmap */
-			ret = filemap_write_and_wait_range(file->f_mapping,
-							   lockstart,
-							   lockend);
-			if (ret)
-				goto out;
-
-			/*
-			 * If we found a page that couldn't be invalidated just
-			 * fall back to buffered.
-			 */
-			ret = invalidate_inode_pages2_range(file->f_mapping,
-					lockstart >> PAGE_CACHE_SHIFT,
-					lockend >> PAGE_CACHE_SHIFT);
-			if (ret) {
-				if (ret == -EBUSY)
-					ret = 0;
-				goto out;
-			}
-		}
-
-		cond_resched();
-	}
-
-	/*
-	 * we don't use btrfs_set_extent_delalloc because we don't want
-	 * the dirty or uptodate bits
-	 */
-	if (writing) {
-		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, NULL, &cached_state,
-				     GFP_NOFS);
-		if (ret) {
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockend, EXTENT_LOCKED | write_bits,
-					 1, 0, &cached_state, GFP_NOFS);
-			goto out;
-		}
-	}
 
-	free_extent_state(cached_state);
-	cached_state = NULL;
-
-	ret = __blockdev_direct_IO(rw, iocb, inode,
+	return __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
 		   btrfs_submit_direct, 0);
-
-	if (ret < 0 && ret != -EIOCBQUEUED) {
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
-	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
-		/*
-		 * We're falling back to buffered, unlock the section we didn't
-		 * do IO on.
-		 */
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
-			      &cached_state, GFP_NOFS);
-	}
-out:
-	free_extent_state(cached_state);
-	return ret;
 }
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
1.7.7.6

