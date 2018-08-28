Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f170.google.com ([209.85.214.170]:45909 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbeH1DwY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:24 -0400
Received: by mail-pl1-f170.google.com with SMTP id j8-v6so300863pll.12
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:30 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: [RFC PATCH v2 1/6] fs: pass iocb to direct I/O get_block()
Date: Mon, 27 Aug 2018 17:03:14 -0700
Message-Id: <227068b6699a1f16c7a84dc6559a9a501efb6313.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Split out dio_get_block_t which is the same as get_block_t except that
it takes the iocb as well, and update fs/direct-io.c and all callers to
use it. This is preparation for replacing the use of bh->b_private in
the direct I/O code with iocb->private.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/affs/file.c      |  9 ++++++++-
 fs/btrfs/inode.c    |  3 ++-
 fs/direct-io.c      | 13 ++++++-------
 fs/ext2/inode.c     |  9 ++++++++-
 fs/ext4/ext4.h      |  2 --
 fs/ext4/inode.c     | 27 ++++++++++++++++++---------
 fs/f2fs/data.c      |  5 +++--
 fs/fat/inode.c      |  9 ++++++++-
 fs/gfs2/aops.c      |  5 +++--
 fs/hfs/inode.c      |  9 ++++++++-
 fs/hfsplus/inode.c  |  9 ++++++++-
 fs/jfs/inode.c      |  9 ++++++++-
 fs/nilfs2/inode.c   |  9 ++++++++-
 fs/ocfs2/aops.c     | 15 +++++++++------
 fs/reiserfs/inode.c |  4 ++--
 fs/udf/inode.c      |  9 ++++++++-
 include/linux/fs.h  | 10 ++++++----
 17 files changed, 113 insertions(+), 43 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index a85817f54483..66a1a5601d65 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -389,6 +389,13 @@ static void affs_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
+static int affs_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			      sector_t block, struct buffer_head *bh_result,
+			      int create)
+{
+	return affs_get_block(inode, block, bh_result, create);
+}
+
 static ssize_t
 affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
@@ -406,7 +413,7 @@ affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return 0;
 	}
 
-	ret = blockdev_direct_IO(iocb, inode, iter, affs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, affs_get_block_dio);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		affs_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eba61bcb9bb3..b61ea6dd9956 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7659,7 +7659,8 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	return ret;
 }
 
-static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
+static int btrfs_get_blocks_direct(struct kiocb *iocb, struct inode *inode,
+				   sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 093fb54cd316..f631aa98849b 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -82,7 +82,7 @@ struct dio_submit {
 	int reap_counter;		/* rate limit reaping */
 	sector_t final_block_in_request;/* doesn't change */
 	int boundary;			/* prev block is at a boundary */
-	get_block_t *get_block;		/* block mapping function */
+	dio_get_block_t *get_block;	/* block mapping function */
 	dio_submit_t *submit_io;	/* IO submition function */
 
 	loff_t logical_offset_in_bio;	/* current first logical block in bio */
@@ -713,8 +713,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 				create = 0;
 		}
 
-		ret = (*sdio->get_block)(dio->inode, fs_startblk,
-						map_bh, create);
+		ret = (*sdio->get_block)(dio->iocb, dio->inode, fs_startblk,
+					 map_bh, create);
 
 		/* Store for completion */
 		dio->private = map_bh->b_private;
@@ -1170,7 +1170,7 @@ static inline int drop_refcount(struct dio *dio)
 static inline ssize_t
 do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		      struct block_device *bdev, struct iov_iter *iter,
-		      get_block_t get_block, dio_iodone_t end_io,
+		      dio_get_block_t get_block, dio_iodone_t end_io,
 		      dio_submit_t submit_io, int flags)
 {
 	unsigned i_blkbits = READ_ONCE(inode->i_blkbits);
@@ -1398,9 +1398,8 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-			     get_block_t get_block,
-			     dio_iodone_t end_io, dio_submit_t submit_io,
-			     int flags)
+			     dio_get_block_t get_block, dio_iodone_t end_io,
+			     dio_submit_t submit_io, int flags)
 {
 	/*
 	 * The block device state is needed in the end to finally
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 71635909df3b..f390e6392238 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -930,6 +930,13 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping,block,ext2_get_block);
 }
 
+static int ext2_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			      sector_t iblock, struct buffer_head *bh_result,
+			      int create)
+{
+	return ext2_get_block(inode, iblock, bh_result, create);
+}
+
 static ssize_t
 ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
@@ -940,7 +947,7 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block_dio);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		ext2_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7c7123f265c2..2c46c2e69b42 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2425,8 +2425,6 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 			     struct buffer_head *bh_result, int create);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
-int ext4_dio_get_block(struct inode *inode, sector_t iblock,
-		       struct buffer_head *bh_result, int create);
 int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			   struct buffer_head *bh, int create);
 int ext4_walk_page_buffers(handle_t *handle,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4efe77286ecd..18ad91b1c8f6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -850,8 +850,9 @@ static int ext4_get_block_trans(struct inode *inode, sector_t iblock,
 }
 
 /* Get block function for DIO reads and writes to inodes without extents */
-int ext4_dio_get_block(struct inode *inode, sector_t iblock,
-		       struct buffer_head *bh, int create)
+static int ext4_dio_get_block(struct kiocb *iocb, struct inode *inode,
+			      sector_t iblock, struct buffer_head *bh,
+			      int create)
 {
 	/* We don't expect handle for direct IO */
 	WARN_ON_ONCE(ext4_journal_current_handle());
@@ -866,8 +867,11 @@ int ext4_dio_get_block(struct inode *inode, sector_t iblock,
  * blocks are not allocated yet. The extent will be converted to written
  * after IO is complete.
  */
-static int ext4_dio_get_block_unwritten_async(struct inode *inode,
-		sector_t iblock, struct buffer_head *bh_result,	int create)
+static int ext4_dio_get_block_unwritten_async(struct kiocb *iocb,
+					      struct inode *inode,
+					      sector_t iblock,
+					      struct buffer_head *bh_result,
+					      int create)
 {
 	int ret;
 
@@ -905,8 +909,11 @@ static int ext4_dio_get_block_unwritten_async(struct inode *inode,
  * blocks are not allocated yet. The extent will be converted to written
  * after IO is complete by ext4_direct_IO_write().
  */
-static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
-		sector_t iblock, struct buffer_head *bh_result,	int create)
+static int ext4_dio_get_block_unwritten_sync(struct kiocb *iocb,
+					     struct inode *inode,
+					     sector_t iblock,
+					     struct buffer_head *bh_result,
+					     int create)
 {
 	int ret;
 
@@ -927,8 +934,10 @@ static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
 	return ret;
 }
 
-static int ext4_dio_get_block_overwrite(struct inode *inode, sector_t iblock,
-		   struct buffer_head *bh_result, int create)
+static int ext4_dio_get_block_overwrite(struct kiocb *iocb, struct inode *inode,
+					sector_t iblock,
+					struct buffer_head *bh_result,
+					int create)
 {
 	int ret;
 
@@ -3663,7 +3672,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t offset = iocb->ki_pos;
 	size_t count = iov_iter_count(iter);
 	int overwrite = 0;
-	get_block_t *get_block_func = NULL;
+	dio_get_block_t *get_block_func = NULL;
 	int dio_flags = 0;
 	loff_t final_size = offset + count;
 	int orphan = 0;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8f931d699287..a465d7877886 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1232,8 +1232,9 @@ static int get_data_block(struct inode *inode, sector_t iblock,
 							NO_CHECK_TYPE);
 }
 
-static int get_data_block_dio(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create)
+static int get_data_block_dio(struct kiocb *iocb, struct inode *inode,
+			      sector_t iblock, struct buffer_head *bh_result,
+			      int create)
 {
 	return __get_data_block(inode, iblock, bh_result, create,
 						F2FS_GET_BLOCK_DEFAULT, NULL,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index bfd589ea74c0..b2caca4ed6bc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -251,6 +251,13 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	return err;
 }
 
+static int fat_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			     sector_t iblock, struct buffer_head *bh_result,
+			     int create)
+{
+	return fat_get_block(inode, iblock, bh_result, create);
+}
+
 static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -279,7 +286,7 @@ static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(iocb, inode, iter, fat_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, fat_get_block_dio);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		fat_write_failed(mapping, offset + count);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 35f5ee23566d..cb908153559b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -82,8 +82,9 @@ static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
 	return 0;
 }
 
-static int gfs2_get_block_direct(struct inode *inode, sector_t lblock,
-				 struct buffer_head *bh_result, int create)
+static int gfs2_get_block_direct(struct kiocb *iocb, struct inode *inode,
+				 sector_t lblock, struct buffer_head *bh_result,
+				 int create)
 {
 	return gfs2_block_map(inode, lblock, bh_result, 0);
 }
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 2a16111d312f..6986024c8ba0 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -126,6 +126,13 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
+static int hfs_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			     sector_t block, struct buffer_head *bh_result,
+			     int create)
+{
+	return hfs_get_block(inode, block, bh_result, create);
+}
+
 static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -134,7 +141,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block_dio);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index c824f702feec..0e1659bc934f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -124,6 +124,13 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
+static int hfsplus_get_block_dio(struct kiocb *iocb, struct inode *inode,
+				 sector_t iblock, struct buffer_head *bh_result,
+				 int create)
+{
+	return hfsplus_get_block(inode, iblock, bh_result, create);
+}
+
 static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -132,7 +139,7 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block_dio);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 054cc761b426..e255bd5b15dc 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -332,6 +332,13 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, jfs_get_block);
 }
 
+static int jfs_get_block_dio(struct kiocb *iocb, struct inode *ip,
+			     sector_t lblock, struct buffer_head *bh_result,
+			     int create)
+{
+	return jfs_get_block(ip, lblock, bh_result, create);
+}
+
 static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -340,7 +347,7 @@ static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, jfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, jfs_get_block_dio);
 
 	/*
 	 * In case of error extending write may have instantiated a few
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6a612d832e7d..10f1b063fb4d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -300,6 +300,13 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 	return err ? : copied;
 }
 
+static int nilfs_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			       sector_t blkoff, struct buffer_head *bh_result,
+			       int create)
+{
+	return nilfs_get_block(inode, blkoff, bh_result, create);
+}
+
 static ssize_t
 nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
@@ -309,7 +316,7 @@ nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	return blockdev_direct_IO(iocb, inode, iter, nilfs_get_block);
+	return blockdev_direct_IO(iocb, inode, iter, nilfs_get_block_dio);
 }
 
 const struct address_space_operations nilfs_aops = {
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 302cd7caa4a7..93ca23c56b07 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -134,8 +134,9 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 	return err;
 }
 
-static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
-		    struct buffer_head *bh_result, int create)
+static int ocfs2_lock_get_block(struct kiocb *iocb, struct inode *inode,
+				sector_t iblock, struct buffer_head *bh_result,
+				int create)
 {
 	int ret = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -2143,8 +2144,9 @@ static void ocfs2_dio_free_write_ctx(struct inode *inode,
  * called like this: dio->get_blocks(dio->inode, fs_startblk,
  * 					fs_count, map_bh, dio->rw == WRITE);
  */
-static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
-			       struct buffer_head *bh_result, int create)
+static int ocfs2_dio_wr_get_block(struct kiocb *iocb, struct inode *inode,
+				  sector_t iblock,
+				  struct buffer_head *bh_result, int create)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -2171,7 +2173,8 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	if (pos + total_len <= i_size_read(inode)) {
 
 		/* This is the fast path for re-write. */
-		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
+		ret = ocfs2_lock_get_block(iocb, inode, iblock, bh_result,
+					   create);
 		if (buffer_mapped(bh_result) &&
 		    !buffer_new(bh_result) &&
 		    ret == 0)
@@ -2427,7 +2430,7 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	get_block_t *get_block;
+	dio_get_block_t *get_block;
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 132ec4406ed0..55ac918dbc73 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -511,8 +511,8 @@ static int reiserfs_get_block_create_0(struct inode *inode, sector_t block,
  * This is special helper for reiserfs_get_block in case we are executing
  * direct_IO request.
  */
-static int reiserfs_get_blocks_direct_io(struct inode *inode,
-					 sector_t iblock,
+static int reiserfs_get_blocks_direct_io(struct kiocb *iocb,
+					 struct inode *inode, sector_t iblock,
 					 struct buffer_head *bh_result,
 					 int create)
 {
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 9915a58fbabd..5ef1c72fa1ab 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -206,6 +206,13 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+static int udf_get_block_dio(struct kiocb *iocb, struct inode *inode,
+			     sector_t block, struct buffer_head *bh_result,
+			     int create)
+{
+	return udf_get_block(inode, block, bh_result, create);
+}
+
 static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -214,7 +221,7 @@ static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, udf_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, udf_get_block_dio);
 	if (unlikely(ret < 0 && iov_iter_rw(iter) == WRITE))
 		udf_write_failed(mapping, iocb->ki_pos + count);
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 805bf22898cf..85db69835023 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -80,6 +80,9 @@ typedef __kernel_rwf_t rwf_t;
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
+typedef int (dio_get_block_t)(struct kiocb *iocb, struct inode *inode,
+			      sector_t iblock, struct buffer_head *bh_result,
+			      int create);
 typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 
@@ -3017,14 +3020,13 @@ void dio_warn_stale_pagecache(struct file *filp);
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-			     get_block_t get_block,
-			     dio_iodone_t end_io, dio_submit_t submit_io,
-			     int flags);
+			     dio_get_block_t get_block, dio_iodone_t end_io,
+			     dio_submit_t submit_io, int flags);
 
 static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
 					 struct inode *inode,
 					 struct iov_iter *iter,
-					 get_block_t get_block)
+					 dio_get_block_t get_block)
 {
 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
 			get_block, NULL, NULL, DIO_LOCKING | DIO_SKIP_HOLES);
-- 
2.18.0
