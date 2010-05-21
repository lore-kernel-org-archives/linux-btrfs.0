From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/6] fs: kill blockdev_direct_IO_no_locking
Date: Fri, 21 May 2010 13:03:40 -0400
Message-ID: <1274461422-18433-4-git-send-email-josef@redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274461422-18433-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph said he'd rather everybody use __blockdev_direct_IO directly instead
of having a bunch of random helper functions, so thats what this patch does.
It's a basic change, I've tested it with xfstests on ext4 and xfs.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c              |    5 +++--
 fs/ext4/inode.c             |    8 ++++----
 fs/gfs2/aops.c              |    6 +++---
 fs/ocfs2/aops.c             |    8 +++-----
 fs/xfs/linux-2.6/xfs_aops.c |    7 +++----
 include/linux/fs.h          |    9 ---------
 6 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6dcee88..0f42cbc 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -172,8 +172,9 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO_no_locking(rw, iocb, inode, I_BDEV(inode),
-				iov, offset, nr_segs, blkdev_get_blocks, NULL);
+	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov,
+				    offset, nr_segs, blkdev_get_blocks, NULL,
+				    NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 81d6054..8f37762 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3494,10 +3494,10 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode))
-		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL);
+		ret = __blockdev_direct_IO(rw, iocb, inode,
+					   inode->i_sb->s_bdev, iov, offset,
+					   nr_segs, ext4_get_block, NULL, NULL,
+					   0);
 	else
 		ret = blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 0c1d0b8..45b23b0 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1039,9 +1039,9 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
-	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
-					   iov, offset, nr_segs,
-					   gfs2_get_block_direct, NULL);
+	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
+				  iov, offset, nr_segs, gfs2_get_block_direct,
+				  NULL, NULL, 0);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 21441dd..f2e53a9 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -669,11 +669,9 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset)
 		return 0;
 
-	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-					    inode->i_sb->s_bdev, iov, offset,
-					    nr_segs,
-					    ocfs2_direct_IO_get_blocks,
-					    ocfs2_dio_end_io);
+	ret = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+				   offset, nr_segs, ocfs2_direct_IO_get_blocks,
+				   ocfs2_dio_end_io, NULL, 0);
 
 	mlog_exit(ret);
 	return ret;
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 0f8b996..fcc14d8 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1617,10 +1617,9 @@ xfs_vm_direct_IO(
 	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
 					IOMAP_UNWRITTEN : IOMAP_READ);
 
-	ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    xfs_end_io_direct);
+	ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset, nr_segs,
+				   xfs_get_blocks_direct, xfs_end_io_direct,
+				   NULL, 0);
 
 	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
 		xfs_destroy_ioend(iocb->private);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5dc079..5b7a8bd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2277,15 +2277,6 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 				    nr_segs, get_block, end_io, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
-
-static inline ssize_t blockdev_direct_IO_no_locking(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
-{
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				    nr_segs, get_block, end_io, NULL, 0);
-}
 #endif
 
 extern const struct file_operations generic_ro_fops;
-- 
1.6.6.1
