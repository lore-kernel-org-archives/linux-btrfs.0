Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab2FZGIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 02:08:37 -0400
Message-ID: <4FE95195.3080402@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 14:07:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] Btrfs: fix old data problem caused by aio vs dio
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 209th case of xfstests failed because of the race between aio and dio. The
detail reason is following:
	Task1		Task2			Btrfs-worker
			invalidate pages
	read pages
			do direct io
			invalidate pages fail*
						finish ordered io
	read data from
	pages

* This step failed because the kernel found the ordered extent object that
covered the pages and thought the pages were still under busy. And then Task1
read the old data from those pages.

This patch fixes the above problem by updating the existed pages directly.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c  |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c |    1 +
 2 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 876cddd..fc0f485 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -18,6 +18,7 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
 #include <linux/init.h>
@@ -1328,6 +1329,91 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	return num_written ? num_written : ret;
 }
 
+static void btrfs_dio_update_existed_pages(struct inode *inode,
+					   struct iov_iter *it,
+					   loff_t pos, size_t size)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct pagevec pvec;
+	pgoff_t index;
+	pgoff_t end;
+	size_t copied;
+	loff_t copy_pos = pos;
+	int offset = pos & (PAGE_CACHE_SIZE - 1);
+	int i;
+
+	BUG_ON(pos & (PAGE_CACHE_SIZE - 1));
+	BUG_ON(size & (PAGE_CACHE_SIZE - 1));
+
+	pagevec_init(&pvec, 0);
+	index = pos >> PAGE_CACHE_SHIFT;
+	end = (pos + size - 1) >> PAGE_CACHE_SHIFT;
+
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		i = 0;
+		while (i < pagevec_count(&pvec)) {
+			struct page *page = pvec.pages[i];
+			size_t count = min_t(size_t, PAGE_CACHE_SIZE - offset,
+					     size);
+
+			index = page->index;
+			if (index > end)
+				break;
+
+			lock_page(page);
+			WARN_ON(page->index != index);
+			BUG_ON(PageDirty(page));
+			BUG_ON(PageWriteback(page));
+
+			if (page->mapping != mapping) {
+				unlock_page(page);
+				i++;
+				continue;
+			}
+
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				i++;
+				continue;
+			}
+
+			if ((index << PAGE_CACHE_SHIFT) > copy_pos) {
+				copied = (index << PAGE_CACHE_SHIFT) - copy_pos;
+				iov_iter_advance(it, copied);
+				offset = 0;
+				size -= copied;
+				count = min_t(size_t, PAGE_CACHE_SIZE, size);
+			}
+
+			pagefault_disable();
+			copied = iov_iter_copy_from_user_atomic(page, it,
+								offset,
+								count);
+			pagefault_enable();
+			flush_dcache_page(page);
+
+			if (copied < count)
+				copied = 0;
+
+			iov_iter_advance(it, copied);
+			size -= copied;
+			copy_pos += copied;
+
+			if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
+				offset += copied;
+			} else {
+				offset = 0;
+				i++;
+			}
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+		index++;
+	}
+}
+
 static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs, loff_t pos,
@@ -1356,6 +1442,11 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 		mark_inode_dirty(inode);
 	}
 
+	if (written > 0) {
+		iov_iter_init(&i, iov, nr_segs, count, 0);
+		btrfs_dio_update_existed_pages(inode, &i, pos, written);
+	}
+
 	if (written < 0 || written == count)
 		return written;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f2c8cb..6de67a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6350,6 +6350,7 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 out:
 	return retval;
 }
+
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
 			unsigned long nr_segs)
-- 
1.7.6.5
