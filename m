Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:24000 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2KVTXI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Nov 2012 14:23:08 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH v4 24/31] btrfs: add support for read_iter and write_iter
Date: Wed, 21 Nov 2012 16:41:04 -0600
Message-Id: <1353537671-26284-25-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
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
index 9ab1bed..b691dd5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -375,7 +375,7 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 		write_bytes -= copied;
 		total_copied += copied;
 
-		/* Return to btrfs_file_aio_write to fault page */
+		/* Return to btrfs_file_write_iter to fault page */
 		if (unlikely(copied == 0))
 			break;
 
@@ -1361,27 +1361,23 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
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
@@ -1398,9 +1394,8 @@ out:
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
@@ -1409,18 +1404,13 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	u64 start_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
-	size_t count, ocount;
+	size_t count;
 
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
@@ -1468,14 +1458,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
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
@@ -2280,9 +2266,9 @@ const struct file_operations btrfs_file_operations = {
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
1.8.0

