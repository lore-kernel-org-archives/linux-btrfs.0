Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2FUCjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 22:39:41 -0400
Message-ID: <4FE282D2.6000100@cn.fujitsu.com>
Date: Thu, 21 Jun 2012 10:11:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs: fix dio write vs buffered read race
References: <1340117889-28697-1-git-send-email-josef@redhat.com>
In-Reply-To: <1340117889-28697-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 19 Jun 2012 10:58:09 -0400, Josef Bacik wrote:
> Miao pointed out there's a problem with mixing dio writes and buffered
> reads.  If the read happens between us invalidating the page range and
> actually locking the extent we can bring in pages into page cache.  Then
> once the write finishes if somebody tries to read again it will just find
> uptodate pages and we'll read stale data.  So we need to lock the extent and
> check for uptodate bits in the range.  If there are uptodate bits we need to
> unlock and invalidate again.  This will keep this race from happening since
> we will hold the extent locked until we create the ordered extent, and then
> teh read side always waits for ordered extents.  Thanks,

Sorry to replay late. 
My test still failed. I thought it is because the reader may hold the lock of
the pages and the page invalidation will fail, the pages which have old data
still exist in the page cache.

Why not update the existed page directly? Just like this:
(Maybe we should move this patch to vfs layer)

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
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/inode.c |   26 +++++++++++++++++++++++---
>  1 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9d8c45d..9b631eb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6360,12 +6360,32 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>  		 */
>  		ordered = btrfs_lookup_ordered_range(inode, lockstart,
>  						     lockend - lockstart + 1);
> -		if (!ordered)
> +
> +		/*
> +		 * We need to make sure there are no buffered pages in this
> +		 * range either, we could have raced between the invalidate in
> +		 * generic_file_direct_write and locking the extent.  The
> +		 * invalidate needs to happen so that reads after a write do not
> +		 * get stale data.
> +		 */
> +		if (!ordered && (!writing ||
> +		    !test_range_bit(&BTRFS_I(inode)->io_tree,
> +				    lockstart, lockend, EXTENT_UPTODATE, 0,
> +				    cached_state)))
>  			break;
> +
>  		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>  				     &cached_state, GFP_NOFS);
> -		btrfs_start_ordered_extent(inode, ordered, 1);
> -		btrfs_put_ordered_extent(ordered);
> +
> +		if (ordered) {
> +			btrfs_start_ordered_extent(inode, ordered, 1);
> +			btrfs_put_ordered_extent(ordered);
> +		} else {
> +			invalidate_mapping_pages(file->f_mapping,
> +						 lockstart >> PAGE_CACHE_SHIFT,
> +						 lockend >> PAGE_CACHE_SHIFT);
> +		}
> +
>  		cond_resched();
>  	}
>  

