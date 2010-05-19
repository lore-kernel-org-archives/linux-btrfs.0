From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 6/6] Btrfs: do aio_write instead of write V2
Date: Wed, 19 May 2010 16:24:54 -0400
Message-ID: <1274300694-8976-6-git-send-email-josef@redhat.com>
References: <1274300694-8976-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1274300694-8976-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

V1->V2
-Fix some things that git rebase screwed up
-Use iov_iter_count() instead of count in a few places
-Update pos if we had a short read/write

In order for AIO to work, we need to implement aio_write.  This patch converts
our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
nothing broke, and the AIO stuff magically started working.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   11 +++-
 fs/btrfs/file.c      |  152 +++++++++++++++++++++++---------------------------
 2 files changed, 80 insertions(+), 83 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d2d0368..c407f1c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2020,6 +2020,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	sector_t sector;
 	struct extent_map *em;
 	struct block_device *bdev;
+	struct btrfs_ordered_extent *ordered;
 	int ret;
 	int nr = 0;
 	size_t page_offset = 0;
@@ -2031,7 +2032,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	set_page_extent_mapped(page);
 
 	end = page_end;
-	lock_extent(tree, start, end, GFP_NOFS);
+	while (1) {
+		lock_extent(tree, start, end, GFP_NOFS);
+		ordered = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered)
+			break;
+		unlock_extent(tree, start, end, GFP_NOFS);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
 
 	if (page->index == last_byte >> PAGE_CACHE_SHIFT) {
 		char *userpage;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dace07b..ce35431 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -46,32 +46,42 @@
 static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 					 int write_bytes,
 					 struct page **prepared_pages,
-					 const char __user *buf)
+					 struct iov_iter *i)
 {
-	long page_fault = 0;
-	int i;
+	size_t copied;
+	int pg = 0;
 	int offset = pos & (PAGE_CACHE_SIZE - 1);
 
-	for (i = 0; i < num_pages && write_bytes > 0; i++, offset = 0) {
+	while (write_bytes > 0) {
 		size_t count = min_t(size_t,
 				     PAGE_CACHE_SIZE - offset, write_bytes);
-		struct page *page = prepared_pages[i];
-		fault_in_pages_readable(buf, count);
+		struct page *page = prepared_pages[pg];
+again:
+		if (unlikely(iov_iter_fault_in_readable(i, count)))
+			return -EFAULT;
 
 		/* Copy data from userspace to the current page */
-		kmap(page);
-		page_fault = __copy_from_user(page_address(page) + offset,
-					      buf, count);
+		copied = iov_iter_copy_from_user(page, i, offset, count);
+
 		/* Flush processor's dcache for this page */
 		flush_dcache_page(page);
-		kunmap(page);
-		buf += count;
-		write_bytes -= count;
+		iov_iter_advance(i, copied);
+		write_bytes -= copied;
 
-		if (page_fault)
-			break;
+		if (unlikely(copied == 0)) {
+			count = min_t(size_t, PAGE_CACHE_SIZE - offset,
+				      iov_iter_single_seg_count(i));
+			goto again;
+		}
+
+		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
+			offset += copied;
+		} else {
+			pg++;
+			offset = 0;
+		}
 	}
-	return page_fault ? -EFAULT : 0;
+	return 0;
 }
 
 /*
@@ -823,60 +833,24 @@ again:
 	return 0;
 }
 
-/* Copied from read-write.c */
-static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
-{
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	if (!kiocbIsKicked(iocb))
-		schedule();
-	else
-		kiocbClearKicked(iocb);
-	__set_current_state(TASK_RUNNING);
-}
-
-/*
- * Just a copy of what do_sync_write does.
- */
-static ssize_t __btrfs_direct_write(struct file *file, const char __user *buf,
-				    size_t count, loff_t pos, loff_t *ppos)
-{
-	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
-	unsigned long nr_segs = 1;
-	struct kiocb kiocb;
-	ssize_t ret;
-
-	init_sync_kiocb(&kiocb, file);
-	kiocb.ki_pos = pos;
-	kiocb.ki_left = count;
-	kiocb.ki_nbytes = count;
-
-	while (1) {
-		ret = generic_file_direct_write(&kiocb, &iov, &nr_segs, pos,
-						ppos, count, count);
-		if (ret != -EIOCBRETRY)
-			break;
-		wait_on_retry_sync_kiocb(&kiocb);
-	}
-
-	if (ret == -EIOCBQUEUED)
-		ret = wait_on_sync_kiocb(&kiocb);
-	*ppos = kiocb.ki_pos;
-	return ret;
-}
-
-static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
+				    const struct iovec *iov,
+				    unsigned long nr_segs, loff_t pos)
 {
-	loff_t pos;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct page *pinned[2];
+	struct page **pages = NULL;
+	struct iov_iter i;
+	loff_t *ppos = &iocb->ki_pos;
 	loff_t start_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
+	size_t count;
+	size_t ocount;
 	int ret = 0;
-	struct inode *inode = fdentry(file)->d_inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct page **pages = NULL;
 	int nrptrs;
-	struct page *pinned[2];
 	unsigned long first_index;
 	unsigned long last_index;
 	int will_write;
@@ -888,7 +862,6 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	pinned[0] = NULL;
 	pinned[1] = NULL;
 
-	pos = *ppos;
 	start_pos = pos;
 
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
@@ -902,6 +875,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&inode->i_mutex);
 
+	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
+	if (err)
+		goto out;
+	count = ocount;
+
 	current->backing_dev_info = inode->i_mapping->backing_dev_info;
 	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
 	if (err)
@@ -918,14 +896,24 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	BTRFS_I(inode)->sequence++;
 
 	if (unlikely(file->f_flags & O_DIRECT)) {
-		num_written = __btrfs_direct_write(file, buf, count, pos,
-						   ppos);
-		pos += num_written;
-		count -= num_written;
+		ret = btrfs_check_data_free_space(root, inode, count);
+		if (ret)
+			goto out;
 
-		/* We've written everything we wanted to, exit */
-		if (num_written < 0 || !count)
+		num_written = generic_file_direct_write(iocb, iov, &nr_segs,
+							pos, ppos, count,
+							ocount);
+
+		/* All reservations for DIO are done internally */
+		btrfs_free_reserved_data_space(root, inode, count);
+
+		if (num_written < 0) {
+			ret = num_written;
+			num_written = 0;
+			goto out;
+		} else if (num_written == count) {
 			goto out;
+		}
 
 		/*
 		 * We are going to do buffered for the rest of the range, so we
@@ -933,18 +921,20 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		 * done.
 		 */
 		buffered = 1;
-		buf += num_written;
+		pos += num_written;
 	}
 
-	nrptrs = min((count + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE,
-		     PAGE_CACHE_SIZE / (sizeof(struct page *)));
+	iov_iter_init(&i, iov, nr_segs, count, num_written);
+	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
+		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
+		     (sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
 
 	first_index = pos >> PAGE_CACHE_SHIFT;
-	last_index = (pos + count) >> PAGE_CACHE_SHIFT;
+	last_index = (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;
 
 	/*
 	 * there are lots of better ways to do this, but this code
@@ -961,7 +951,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 			unlock_page(pinned[0]);
 		}
 	}
-	if ((pos + count) & (PAGE_CACHE_SIZE - 1)) {
+	if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
 		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
 		if (!PageUptodate(pinned[1])) {
 			ret = btrfs_readpage(NULL, pinned[1]);
@@ -972,10 +962,10 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		}
 	}
 
-	while (count > 0) {
+	while (iov_iter_count(&i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
-		size_t write_bytes = min(count, nrptrs *
-					(size_t)PAGE_CACHE_SIZE -
+		size_t write_bytes = min(iov_iter_count(&i),
+					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
 		size_t num_pages = (write_bytes + PAGE_CACHE_SIZE - 1) >>
 					PAGE_CACHE_SHIFT;
@@ -997,7 +987,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		}
 
 		ret = btrfs_copy_from_user(pos, num_pages,
-					   write_bytes, pages, buf);
+					   write_bytes, pages, &i);
 		if (ret) {
 			btrfs_free_reserved_data_space(root, inode,
 						       write_bytes);
@@ -1026,8 +1016,6 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 			btrfs_throttle(root);
 		}
 
-		buf += write_bytes;
-		count -= write_bytes;
 		pos += write_bytes;
 		num_written += write_bytes;
 
@@ -1222,7 +1210,7 @@ const struct file_operations btrfs_file_operations = {
 	.read		= do_sync_read,
 	.aio_read       = generic_file_aio_read,
 	.splice_read	= generic_file_splice_read,
-	.write		= btrfs_file_write,
+	.aio_write	= btrfs_file_aio_write,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
 	.release	= btrfs_release_file,
-- 
1.6.6.1

