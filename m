Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60182 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2F1NEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 09:04:24 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <miaox@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix dio write vs buffered read race V3
Date: Thu, 28 Jun 2012 09:09:04 -0400
Message-ID: <1340888944-9471-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <josef@redhat.com>

Miao pointed out there's a problem with mixing dio writes and buffered
reads.  If the read happens between us invalidating the page range and
actually locking the extent we can bring in pages into page cache.  Then
once the write finishes if somebody tries to read again it will just find
uptodate pages and we'll read stale data.  So we need to lock the extent and
check for uptodate bits in the range.  If there are uptodate bits we need to
unlock and invalidate again.  This will keep this race from happening since
we will hold the extent locked until we create the ordered extent, and then
teh read side always waits for ordered extents.  There was also a race in
how we updated i_size, previously we were relying on the generic DIO stuff
to adjust the i_size after the DIO had completed, but this happens outside
of the extent lock which means reads could come in and not see the updated
i_size.  So instead move this work into where we create the extents, and
then this way the update ordered i_size stuff works properly in the endio
handlers.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V2->V3: update the i_size as we add extents past the current i_size so the
updates are done under the extent lock.

 fs/btrfs/file.c  |   13 ------------
 fs/btrfs/inode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 70dc8ca..9aa01ec 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1334,7 +1334,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 				    loff_t *ppos, size_t count, size_t ocount)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = fdentry(file)->d_inode;
 	struct iov_iter i;
 	ssize_t written;
 	ssize_t written_buffered;
@@ -1344,18 +1343,6 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 	written = generic_file_direct_write(iocb, iov, &nr_segs, pos, ppos,
 					    count, ocount);
 
-	/*
-	 * the generic O_DIRECT will update in-memory i_size after the
-	 * DIOs are done.  But our endio handlers that update the on
-	 * disk i_size never update past the in memory i_size.  So we
-	 * need one more update here to catch any additions to the
-	 * file
-	 */
-	if (inode->i_size != BTRFS_I(inode)->disk_i_size) {
-		btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
-		mark_inode_dirty(inode);
-	}
-
 	if (written < 0 || written == count)
 		return written;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d8c45d..d455a87 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5876,8 +5876,17 @@ map:
 	bh_result->b_size = len;
 	bh_result->b_bdev = em->bdev;
 	set_buffer_mapped(bh_result);
-	if (create && !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-		set_buffer_new(bh_result);
+	if (create) {
+		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			set_buffer_new(bh_result);
+
+		/*
+		 * Need to update the i_size under the extent lock so buffered
+		 * readers will get the updated i_size when we unlock.
+		 */
+		if (start + len > i_size_read(inode))
+			i_size_write(inode, start + len);
+	}
 
 	free_extent_map(em);
 
@@ -6360,12 +6369,48 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		 */
 		ordered = btrfs_lookup_ordered_range(inode, lockstart,
 						     lockend - lockstart + 1);
-		if (!ordered)
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
+				    cached_state)))
 			break;
+
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				     &cached_state, GFP_NOFS);
-		btrfs_start_ordered_extent(inode, ordered, 1);
-		btrfs_put_ordered_extent(ordered);
+
+		if (ordered) {
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+		} else {
+			/* Screw you mmap */
+			ret = filemap_write_and_wait_range(file->f_mapping,
+							   lockstart,
+							   lockend);
+			if (ret)
+				goto out;
+
+			/*
+			 * If we found a page that couldn't be invalidated just
+			 * fall back to buffered.
+			 */
+			ret = invalidate_inode_pages2_range(file->f_mapping,
+					lockstart >> PAGE_CACHE_SHIFT,
+					lockend >> PAGE_CACHE_SHIFT);
+			if (ret) {
+				if (ret == -EBUSY)
+					ret = 0;
+				goto out;
+			}
+		}
+
 		cond_resched();
 	}
 
-- 
1.7.7.6

