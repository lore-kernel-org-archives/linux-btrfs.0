From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 20/21] btrfs: add support for read_iter and write_iter
Date: Fri, 30 Mar 2012 10:43:47 -0500
Message-ID: <1333122228-13633-21-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs can use generic_file_read_iter(). Base btrfs_file_write_iter()
on btrfs_file_aio_write(), then have the latter call the former.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/file.c |   55 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e8d06b6..31275d1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1285,20 +1285,17 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 }
 
 static ssize_t __btrfs_direct_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t pos,
-				    loff_t *ppos, size_t count, size_t ocount)
+				    struct iov_iter *iter,
+				    loff_t pos, loff_t *ppos, size_t count)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
-	struct iov_iter i;
 	ssize_t written;
 	ssize_t written_buffered;
 	loff_t endbyte;
 	int err;
 
-	written = generic_file_direct_write(iocb, iov, &nr_segs, pos, ppos,
-					    count, ocount);
+	written = generic_file_direct_write_iter(iocb, iter, pos, ppos, count);
 
 	/*
 	 * the generic O_DIRECT will update in-memory i_size after the
@@ -1317,8 +1314,7 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 
 	pos += written;
 	count -= written;
-	iov_iter_init(&i, iov, nr_segs, count, written);
-	written_buffered = __btrfs_buffered_write(file, &i, pos);
+	written_buffered = __btrfs_buffered_write(file, iter, pos);
 	if (written_buffered < 0) {
 		err = written_buffered;
 		goto out;
@@ -1335,9 +1331,8 @@ out:
 	return written ? written : err;
 }
 
-static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t pos)
+static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
+				     struct iov_iter *iter, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
@@ -1346,18 +1341,13 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	u64 start_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
-	size_t count, ocount;
+	size_t count;
 
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 
 	mutex_lock(&inode->i_mutex);
 
-	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
-		goto out;
-	}
-	count = ocount;
+	count = iov_iter_count(iter);
 
 	current->backing_dev_info = inode->i_mapping->backing_dev_info;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
@@ -1406,14 +1396,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	}
 
 	if (unlikely(file->f_flags & O_DIRECT)) {
-		num_written = __btrfs_direct_write(iocb, iov, nr_segs,
-						   pos, ppos, count, ocount);
+		num_written = __btrfs_direct_write(iocb, iter, pos, ppos,
+						   count);
 	} else {
-		struct iov_iter i;
-
-		iov_iter_init(&i, iov, nr_segs, count, num_written);
-
-		num_written = __btrfs_buffered_write(file, &i, pos);
+		num_written = __btrfs_buffered_write(file, iter, pos);
 		if (num_written > 0)
 			*ppos = pos + num_written;
 	}
@@ -1443,6 +1429,23 @@ out:
 	return num_written ? num_written : err;
 }
 
+static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
+				    const struct iovec *iov,
+				    unsigned long nr_segs, loff_t pos)
+{
+	struct iov_iter i;
+	int ret;
+	size_t count;
+
+	ret = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (ret)
+		return ret;
+
+	iov_iter_init(&i, iov, nr_segs, count, 0);
+
+	return btrfs_file_write_iter(iocb, &i, pos);
+}
+
 int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	/*
@@ -1874,7 +1877,9 @@ const struct file_operations btrfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read       = generic_file_aio_read,
 	.splice_read	= generic_file_splice_read,
+	.read_iter	= generic_file_read_iter,
 	.aio_write	= btrfs_file_aio_write,
+	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
 	.release	= btrfs_release_file,
-- 
1.7.9.5

