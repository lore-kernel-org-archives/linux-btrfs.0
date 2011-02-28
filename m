From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] btrfs file write debugging patch
Date: Sun, 27 Feb 2011 20:46:05 -0500
Message-ID: <1298857223-sup-5612@think>
References: <AANLkTik3KtjzP4zVU-foQUxEvZEtrTi7T2aj6PJzUV43@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: =?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTik3KtjzP4zVU-foQUxEvZEtrTi7T2aj6PJzUV43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500:
> Some clarification on my previous message...
> 
> After looking at my ftrace log more closely, I can see where Btrfs is
> trying to release the allocated pages.  However, the calculation for
> the number of dirty_pages is equal to 1 when "copied == 0".
> 
> So I'm seeing at least two problems:
> (1)  It keeps looping when "copied == 0".
> (2)  One dirty page is not being released on every loop even though
> "copied == 0" (at least this problem keeps it from being an infinite
> loop by eventually exhausting reserveable space on the disk).

Hi everyone,

There are actually tow bugs here.  First the one that Mitch hit, and a
second one that still results in bad file_write results with my
debugging hunks (the first two hunks below) in place.

My patch fixes Mitch's bug by checking for copied == 0 after
btrfs_copy_from_user and going the correct delalloc accounting.  This
one looks solved, but you'll notice the patch is bigger.

First, I add some random failures to btrfs_copy_from_user() by failing
everyone once and a while.  This was much more reliable than trying to
use memory pressure than making copy_from_user fail.

If copy_from_user fails and we partially update a page, we end up with a
page that may go away due to memory pressure.  But, btrfs_file_write
assumes that only the first and last page may have good data that needs
to be read off the disk.

This patch ditches that code and puts it into prepare_pages instead.
But I'm still having some errors during long stress.sh runs.  Ideas are
more than welcome, hopefully some other timezones will kick in ideas
while I sleep.

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7084140..89a6a26 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -54,6 +54,13 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 	int offset = pos & (PAGE_CACHE_SIZE - 1);
 	int total_copied = 0;
 
+	if ((jiffies % 10) == 0)
+		return 0;
+
+	if ((jiffies % 25) == 0) {
+		write_bytes /= 2;
+	}
+
 	while (write_bytes > 0) {
 		size_t count = min_t(size_t,
 				     PAGE_CACHE_SIZE - offset, write_bytes);
@@ -763,6 +770,26 @@ out:
 }
 
 /*
+ * on error we return an unlocked page and the error value
+ * on success we return a locked page and 0
+ */
+static int prepare_uptodate_page(struct page *page, u64 pos)
+{
+	int ret = 0;
+	if ((pos & (PAGE_CACHE_SIZE - 1)) && !PageUptodate(page)) {
+		ret = btrfs_readpage(NULL, page);
+		if (ret)
+			return ret;
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			unlock_page(page);
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+/*
  * this gets pages into the page cache and locks them down, it also properly
  * waits for data=ordered extents to finish before allowing the pages to be
  * modified.
@@ -777,6 +804,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	struct inode *inode = fdentry(file)->d_inode;
 	int err = 0;
+	int faili = 0;
 	u64 start_pos;
 	u64 last_pos;
 
@@ -794,15 +822,24 @@ again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = grab_cache_page(inode->i_mapping, index + i);
 		if (!pages[i]) {
-			int c;
-			for (c = i - 1; c >= 0; c--) {
-				unlock_page(pages[c]);
-				page_cache_release(pages[c]);
-			}
-			return -ENOMEM;
+			faili = i - 1;
+			err = -ENOMEM;
+			goto fail;
+		}
+
+		if (i == 0)
+			err = prepare_uptodate_page(pages[i], pos);
+		else if (i == num_pages - 1)
+			err = prepare_uptodate_page(pages[i],
+						    pos + write_bytes);
+		if (err) {
+			page_cache_release(pages[i]);
+			faili = i - 1;
+			goto fail;
 		}
 		wait_on_page_writeback(pages[i]);
 	}
+	err = 0;
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
@@ -842,6 +879,14 @@ again:
 		WARN_ON(!PageLocked(pages[i]));
 	}
 	return 0;
+fail:
+	while (faili >= 0) {
+		unlock_page(pages[faili]);
+		page_cache_release(pages[faili]);
+		faili--;
+	}
+	return err;
+
 }
 
 static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
@@ -851,7 +896,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct page *pinned[2];
 	struct page **pages = NULL;
 	struct iov_iter i;
 	loff_t *ppos = &iocb->ki_pos;
@@ -872,9 +916,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
 
-	pinned[0] = NULL;
-	pinned[1] = NULL;
-
 	start_pos = pos;
 
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
@@ -962,32 +1003,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	first_index = pos >> PAGE_CACHE_SHIFT;
 	last_index = (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;
 
-	/*
-	 * there are lots of better ways to do this, but this code
-	 * makes sure the first and last page in the file range are
-	 * up to date and ready for cow
-	 */
-	if ((pos & (PAGE_CACHE_SIZE - 1))) {
-		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
-		if (!PageUptodate(pinned[0])) {
-			ret = btrfs_readpage(NULL, pinned[0]);
-			BUG_ON(ret);
-			wait_on_page_locked(pinned[0]);
-		} else {
-			unlock_page(pinned[0]);
-		}
-	}
-	if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
-		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
-		if (!PageUptodate(pinned[1])) {
-			ret = btrfs_readpage(NULL, pinned[1]);
-			BUG_ON(ret);
-			wait_on_page_locked(pinned[1]);
-		} else {
-			unlock_page(pinned[1]);
-		}
-	}
-
 	while (iov_iter_count(&i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
 		size_t write_bytes = min(iov_iter_count(&i),
@@ -1024,8 +1039,12 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, &i);
-		dirty_pages = (copied + offset + PAGE_CACHE_SIZE - 1) >>
-				PAGE_CACHE_SHIFT;
+		if (copied == 0)
+			dirty_pages = 0;
+		else
+			dirty_pages = (copied + offset +
+				       PAGE_CACHE_SIZE - 1) >>
+				       PAGE_CACHE_SHIFT;
 
 		if (num_pages > dirty_pages) {
 			if (copied > 0)
@@ -1069,10 +1088,6 @@ out:
 		err = ret;
 
 	kfree(pages);
-	if (pinned[0])
-		page_cache_release(pinned[0]);
-	if (pinned[1])
-		page_cache_release(pinned[1]);
 	*ppos = pos;
 
 	/*
