Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35357 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3A2QYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 11:24:32 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V6 23/30] btrfs: add support for read_iter and write_iter
Date: Tue, 29 Jan 2013 10:23:36 -0600
Message-Id: <1359476623-10544-24-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs can use generic_file_read_iter(). Base btrfs_file_write_iter()
on btrfs_file_aio_write(), then have the latter call the former.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/file.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f76b1fd..f23e24b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -437,7 +437,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 		write_bytes -= copied;
 		total_copied += copied;
 
-		/* Return to btrfs_file_aio_write to fault page */
+		/* Return to btrfs_file_write_iter to fault page */
 		if (unlikely(copied == 0))
 			break;
 
@@ -1426,27 +1426,23 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 }
 
 static ssize_t __btrfs_direct_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t pos,
-				    loff_t *ppos, size_t count, size_t ocount)
+				     struct iov_iter *iter, loff_t pos,
+				    loff_t *ppos, size_t count)
 {
 	struct file *file = iocb->ki_filp;
-	struct iov_iter i;
 	ssize_t written;
 	ssize_t written_buffered;
 	loff_t endbyte;
 	int err;
 
-	written = generic_file_direct_write(iocb, iov, &nr_segs, pos, ppos,
-					    count, ocount);
+	written = generic_file_direct_write_iter(iocb, iter, pos, ppos, count);
 
 	if (written < 0 || written == count)
 		return written;
 
 	pos += written;
 	count -= written;
-	iov_iter_init(&i, iov, nr_segs, count, written);
-	written_buffered = __btrfs_buffered_write(file, &i, pos);
+	written_buffered = __btrfs_buffered_write(file, iter, pos);
 	if (written_buffered < 0) {
 		err = written_buffered;
 		goto out;
@@ -1481,9 +1477,8 @@ static void update_time_for_write(struct inode *inode)
 		inode_inc_iversion(inode);
 }
 
-static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t pos)
+static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
+				     struct iov_iter *iter, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
@@ -1492,19 +1487,14 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	u64 start_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
-	size_t count, ocount;
+	size_t count;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 
 	sb_start_write(inode->i_sb);
 
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
@@ -1557,14 +1547,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
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
@@ -2387,9 +2373,9 @@ const struct file_operations btrfs_file_operations = {
 	.llseek		= btrfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read       = generic_file_aio_read,
 	.splice_read	= generic_file_splice_read,
-	.aio_write	= btrfs_file_aio_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
 	.release	= btrfs_release_file,
-- 
1.8.1.1

