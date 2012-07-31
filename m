Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41853 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab2GaU2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 16:28:46 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id QrP749nINPwxnuHb (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 14:28:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: unlock extent when the dio completes for reads
Date: Tue, 31 Jul 2012 16:33:47 -0400
Message-ID: <1343766827-6674-1-git-send-email-jbacik@fusionio.com>
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
the end of where we tried to read locked.  To fix this we need to store the
end of the region we've locked in our locked state bit and then only unlock
when the dio has finished completely.  This makes sure we always unlock the
entire range we locked when reading.  Before this patch we would hang when
running 113, no this no longer happens.  Thanks to Zach Brown for the idea,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 48bdfd2..c2f9300 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5810,9 +5810,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
 			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 		free_extent_map(em);
-		/* DIO will do one hole at a time, so just unlock a sector */
-		unlock_extent(&BTRFS_I(inode)->io_tree, start,
-			      start + root->sectorsize - 1);
 		return 0;
 	}
 
@@ -5961,8 +5958,6 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 		bvec++;
 	} while (bvec <= bvec_end);
 
-	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
-		      dip->logical_offset + dip->bytes - 1);
 	bio->bi_private = dip->private;
 
 	kfree(dip->csums);
@@ -6340,6 +6335,26 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 out:
 	return retval;
 }
+
+static void btrfs_direct_read_iodone(struct kiocb *iocb, loff_t offset,
+				     ssize_t bytes, void *private, int ret,
+				     bool is_async)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	u64 lockend;
+
+	if (get_state_private(&BTRFS_I(inode)->io_tree, offset, &lockend)) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	unlock_extent(&BTRFS_I(inode)->io_tree, offset, lockend);
+out:
+	if (is_async)
+		aio_complete(iocb, ret, 0);
+	inode_dio_done(inode);
+}
+
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
 			unsigned long nr_segs)
@@ -6353,6 +6368,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	int writing = rw & WRITE;
 	int write_bits = 0;
 	size_t count = iov_length(iov, nr_segs);
+	dio_iodone_t *iodone = NULL;
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
 			    offset, nr_segs)) {
@@ -6438,6 +6454,9 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 					 1, 0, &cached_state, GFP_NOFS);
 			goto out;
 		}
+	} else {
+		set_state_private(&BTRFS_I(inode)->io_tree, lockstart, lockend);
+		iodone = btrfs_direct_read_iodone;
 	}
 
 	free_extent_state(cached_state);
@@ -6445,9 +6464,13 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+		   iov, offset, nr_segs, btrfs_get_blocks_direct, iodone,
 		   btrfs_submit_direct, 0);
 
+	/* If we're reading we will be unlocked by the iodone call */
+	if (!writing)
+		goto out;
+
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
 			      offset + iov_length(iov, nr_segs) - 1,
-- 
1.7.7.6

