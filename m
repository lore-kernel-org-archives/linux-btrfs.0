Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37764 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbeEKGa1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 02:30:27 -0400
Received: by mail-pl0-f65.google.com with SMTP id w19-v6so101062plq.4
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:30:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 1/3] fs: add initial bh_result->b_private value to __blockdev_direct_IO()
Date: Thu, 10 May 2018 23:30:10 -0700
Message-Id: <9a09b9878759e377b138336886b3e2c6e5d7eae9.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Btrfs abuses current->journal_info in btrfs_direct_IO() in order to pass
around some state to get_block() and submit_io(). The generic DIO code
already provides bh_result->b_private as a way to pass data between
calls to get_block() and end_io(), but it is always initialized to NULL.
Let's allow an initial value to be passed in from the caller of
__blockdev_direct_IO().

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c   | 6 +++---
 fs/direct-io.c     | 9 +++++----
 fs/ext4/inode.c    | 6 +++---
 fs/gfs2/aops.c     | 2 +-
 fs/ocfs2/aops.c    | 5 ++---
 include/linux/fs.h | 8 ++++----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..d8b0a7eacd19 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8618,9 +8618,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	ret = __blockdev_direct_IO(iocb, inode,
-				   fs_info->fs_devices->latest_bdev,
-				   iter, btrfs_get_blocks_direct, NULL,
-				   btrfs_submit_direct, flags);
+				   fs_info->fs_devices->latest_bdev, iter,
+				   btrfs_get_blocks_direct, NULL,
+				   btrfs_submit_direct, flags, NULL);
 	if (iov_iter_rw(iter) == WRITE) {
 		up_read(&BTRFS_I(inode)->dio_sem);
 		current->journal_info = NULL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 874607bb6e02..9bb33d9c206c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1171,7 +1171,7 @@ static inline ssize_t
 do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		      struct block_device *bdev, struct iov_iter *iter,
 		      get_block_t get_block, dio_iodone_t end_io,
-		      dio_submit_t submit_io, int flags)
+		      dio_submit_t submit_io, int flags, void *private)
 {
 	unsigned i_blkbits = READ_ONCE(inode->i_blkbits);
 	unsigned blkbits = i_blkbits;
@@ -1182,7 +1182,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	const loff_t end = offset + count;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
-	struct buffer_head map_bh = { 0, };
+	struct buffer_head map_bh = { .b_private = private, };
 	struct blk_plug plug;
 	unsigned long align = offset | iov_iter_alignment(iter);
 
@@ -1304,6 +1304,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 
 	sdio.get_block = get_block;
 	dio->end_io = end_io;
+	dio->private = map_bh.b_private;
 	sdio.submit_io = submit_io;
 	sdio.final_block_in_bio = -1;
 	sdio.next_block_for_io = -1;
@@ -1400,7 +1401,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
 			     get_block_t get_block,
 			     dio_iodone_t end_io, dio_submit_t submit_io,
-			     int flags)
+			     int flags, void *private)
 {
 	/*
 	 * The block device state is needed in the end to finally
@@ -1415,7 +1416,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
 	return do_blockdev_direct_IO(iocb, inode, bdev, iter, get_block,
-				     end_io, submit_io, flags);
+				     end_io, submit_io, flags, private);
 }
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1e50c5efae67..e453e7529a3e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3739,7 +3739,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	}
 	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
 				   get_block_func, ext4_end_io_dio, NULL,
-				   dio_flags);
+				   dio_flags, NULL);
 
 	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
 						EXT4_STATE_DIO_UNWRITTEN)) {
@@ -3830,8 +3830,8 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 					   iocb->ki_pos + count - 1);
 	if (ret)
 		goto out_unlock;
-	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-				   iter, ext4_dio_get_block, NULL, NULL, 0);
+	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
+				   ext4_dio_get_block, NULL, NULL, 0, NULL);
 out_unlock:
 	inode_unlock_shared(inode);
 	return ret;
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index f58716567972..d42e68543baa 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1113,7 +1113,7 @@ static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	rv = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
-				  gfs2_get_block_direct, NULL, NULL, 0);
+				  gfs2_get_block_direct, NULL, NULL, 0, NULL);
 out:
 	gfs2_glock_dq(&gh);
 out_uninit:
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 302cd7caa4a7..58b74d9da931 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2446,9 +2446,8 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	else
 		get_block = ocfs2_dio_wr_get_block;
 
-	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-				    iter, get_block,
-				    ocfs2_dio_end_io, NULL, 0);
+	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
+				    get_block, ocfs2_dio_end_io, NULL, 0, NULL);
 }
 
 const struct address_space_operations ocfs2_aops = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 760d8da1b6c7..b9ef2fb1224b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2993,9 +2993,8 @@ void dio_warn_stale_pagecache(struct file *filp);
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-			     get_block_t get_block,
-			     dio_iodone_t end_io, dio_submit_t submit_io,
-			     int flags);
+			     get_block_t get_block, dio_iodone_t end_io,
+			     dio_submit_t submit_io, int flags, void *private);
 
 static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
 					 struct inode *inode,
@@ -3003,7 +3002,8 @@ static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
 					 get_block_t get_block)
 {
 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
-			get_block, NULL, NULL, DIO_LOCKING | DIO_SKIP_HOLES);
+				    get_block, NULL, NULL,
+				    DIO_LOCKING | DIO_SKIP_HOLES, NULL);
 }
 #endif
 
-- 
2.17.0

