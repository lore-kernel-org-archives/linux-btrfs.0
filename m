From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 21/22] btrfs: add support for read_iter, write_iter, and direct_IO_bvec
Date: Mon, 27 Feb 2012 15:19:35 -0600
Message-ID: <1330377576-3659-22-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Some helpers were broken out of btrfs_direct_IO() in order to avoid code
duplication in new bio_vec-based function.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/file.c  |    2 +
 fs/btrfs/inode.c |  116 +++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 859ba2d..7a2fbc0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1880,6 +1880,8 @@ const struct file_operations btrfs_file_operations = {
 	.aio_read       = generic_file_aio_read,
 	.splice_read	= generic_file_splice_read,
 	.aio_write	= btrfs_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= generic_file_write_iter,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
 	.release	= btrfs_release_file,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32214fe..52199e7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6151,24 +6151,14 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 out:
 	return retval;
 }
-static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+
+static ssize_t btrfs_pre_direct_IO(int writing,  loff_t offset, size_t count,
+				   struct inode *inode, int *write_bits)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	u64 lockstart, lockend;
 	ssize_t ret;
-	int writing = rw & WRITE;
-	int write_bits = 0;
-	size_t count = iov_length(iov, nr_segs);
-
-	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-			    offset, nr_segs)) {
-		return 0;
-	}
 
 	lockstart = offset;
 	lockend = offset + count - 1;
@@ -6176,7 +6166,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	if (writing) {
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	while (1) {
@@ -6191,8 +6181,8 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 						     lockend - lockstart + 1);
 		if (!ordered)
 			break;
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     &cached_state, GFP_NOFS);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, &cached_state, GFP_NOFS);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
@@ -6203,46 +6193,99 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	 * the dirty or uptodate bits
 	 */
 	if (writing) {
-		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, 0, NULL, &cached_state,
-				     GFP_NOFS);
-		if (ret) {
+		*write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
+		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_DELALLOC, 0, NULL,
+				     &cached_state, GFP_NOFS);
+		if (ret)
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockend, EXTENT_LOCKED | write_bits,
+					 lockend, EXTENT_LOCKED | *write_bits,
 					 1, 0, &cached_state, GFP_NOFS);
-			goto out;
-		}
 	}
-
 	free_extent_state(cached_state);
-	cached_state = NULL;
 
-	ret = __blockdev_direct_IO(rw, iocb, inode,
-		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+	return ret;
+}
+
+static ssize_t btrfs_post_direct_IO(ssize_t ret, loff_t offset, size_t count,
+				   struct inode *inode, int *write_bits)
+{
+	struct extent_state *cached_state = NULL;
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
+			      offset + count - 1,
+			      EXTENT_LOCKED | *write_bits, 1, 0,
 			      &cached_state, GFP_NOFS);
-	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
+	} else if (ret >= 0 && ret < count) {
 		/*
 		 * We're falling back to buffered, unlock the section we didn't
 		 * do IO on.
 		 */
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
-			      offset + iov_length(iov, nr_segs) - 1,
-			      EXTENT_LOCKED | write_bits, 1, 0,
+			      offset + count - 1,
+			      EXTENT_LOCKED | *write_bits, 1, 0,
 			      &cached_state, GFP_NOFS);
 	}
-out:
 	free_extent_state(cached_state);
 	return ret;
 }
 
+static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
+			const struct iovec *iov, loff_t offset,
+			unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+	int writing = rw & WRITE;
+	int write_bits = 0;
+	size_t count = iov_length(iov, nr_segs);
+
+	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
+			    offset, nr_segs)) {
+		return 0;
+	}
+
+	ret = btrfs_pre_direct_IO(writing, offset, count, inode, &write_bits);
+	if (ret)
+		return ret;
+
+	ret = __blockdev_direct_IO(rw, iocb, inode,
+		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
+		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+		   btrfs_submit_direct, 0);
+
+	ret = btrfs_post_direct_IO(ret, offset, iov_length(iov, nr_segs),
+				   inode, &write_bits);
+	return ret;
+}
+
+static ssize_t btrfs_direct_IO_bvec(int rw, struct kiocb *iocb,
+			struct bio_vec *bvec, loff_t offset,
+			unsigned long bvec_len)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+	int writing = rw & WRITE;
+	int write_bits = 0;
+	size_t count = bvec_length(bvec, bvec_len);
+
+	ret = btrfs_pre_direct_IO(writing, offset, count, inode, &write_bits);
+	if (ret)
+		return ret;
+
+	ret = __blockdev_direct_IO_bvec(rw, iocb, inode,
+		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
+		   bvec, offset, bvec_len, btrfs_get_blocks_direct, NULL,
+		   btrfs_submit_direct, 0);
+
+	ret = btrfs_post_direct_IO(ret, offset, bvec_length(bvec, bvec_len),
+				   inode, &write_bits);
+	return ret;
+}
+
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
@@ -7433,6 +7476,7 @@ static const struct address_space_operations btrfs_aops = {
 	.writepages	= btrfs_writepages,
 	.readpages	= btrfs_readpages,
 	.direct_IO	= btrfs_direct_IO,
+	.direct_IO_bvec	= btrfs_direct_IO_bvec,
 	.invalidatepage = btrfs_invalidatepage,
 	.releasepage	= btrfs_releasepage,
 	.set_page_dirty	= btrfs_set_page_dirty,
-- 
1.7.9.2

