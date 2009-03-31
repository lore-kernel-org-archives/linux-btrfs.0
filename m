From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RFC] [PATCH] Btrfs: improve fsync/osync write performance
Date: Tue, 31 Mar 2009 14:18:07 +0900
Message-ID: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris.

I noticed performance of fsync() and write() with O_SYNC flag on Btrfs is
very slow as compared to ext3/4. I used blktrace to try to investigate the 
cause of this. One of cause is that unplug is done by kblockd even if the I/O is 
issued through fsync() or write() with O_SYNC flag. kblockd's unplug timeout
is 3msec, so unplug via blockd can decrease I/O response. To increase 
fsync/osync write performance, speeding up unplug should be done here.

Btrfs's write I/O is issued via kernel thread, not via user application context
that calls fsync(). While waiting for page writeback, wait_on_page_writeback() 
can not unplug I/O sometimes on Btrfs because submit_bio is not called from 
user application context so when submit_bio is called from kernel thread, 
wait_on_page_writeback() sleeps on io_schedule(). 

I introduced btrfs_wait_on_page_writeback() on following patch, this is replacement 
of wait_on_page_writeback() for Btrfs. This does unplug every 1 tick while
waiting for page writeback.

I did a performance test using the sysbench.

# sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
--file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
--file-fsync-freq=5  run

The result was:
-2.6.29

Test execution summary:
    total time:                          628.1047s
    total number of events:              10000
    total time taken by event execution: 413.0834
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0413s
         max:                            1.9075s
         approx.  95 percentile:         0.3712s

Threads fairness:
    events (avg/stddev):           2500.0000/29.21
    execution time (avg/stddev):   103.2708/4.04


-2.6.29-patched

Test execution summary:
    total time:                          579.8049s
    total number of events:              10004
    total time taken by event execution: 355.3098
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0355s
         max:                            1.7670s
         approx.  95 percentile:         0.3154s

Threads fairness:
    events (avg/stddev):           2501.0000/8.03
    execution time (avg/stddev):   88.8274/1.94


This patch has some effect for performance improvement. 

I think there are other reasons that should be fixed why fsync() or 
write() with O_SYNC flag is slow on Btrfs.

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> 

diff -Nrup linux-2.6.29.org/fs/btrfs/ctree.h linux-2.6.29.btrfs/fs/btrfs/ctree.h
--- linux-2.6.29.org/fs/btrfs/ctree.h	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/ctree.h	2009-03-24 16:48:36.000000000 +0900
@@ -1703,6 +1703,14 @@ static inline struct dentry *fdentry(str
 	return file->f_path.dentry;
 }
 
+extern void btrfs_wait_on_page_bit(struct page *page);
+
+static inline void btrfs_wait_on_page_writeback(struct page *page)
+{
+	if (PageWriteback(page))
+		btrfs_wait_on_page_bit(page);
+}
+
 /* extent-tree.c */
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
diff -Nrup linux-2.6.29.org/fs/btrfs/extent-tree.c linux-2.6.29.btrfs/fs/btrfs/extent-tree.c
--- linux-2.6.29.org/fs/btrfs/extent-tree.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/extent-tree.c	2009-03-24 15:34:12.000000000 +0900
@@ -4529,7 +4529,7 @@ again:
 				goto out_unlock;
 			}
 		}
-		wait_on_page_writeback(page);
+		btrfs_wait_on_page_writeback(page);
 
 		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
diff -Nrup linux-2.6.29.org/fs/btrfs/extent_io.c linux-2.6.29.btrfs/fs/btrfs/extent_io.c
--- linux-2.6.29.org/fs/btrfs/extent_io.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/extent_io.c	2009-03-24 15:34:30.000000000 +0900
@@ -2423,7 +2423,7 @@ retry:
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page))
 					flush_fn(data);
-				wait_on_page_writeback(page);
+				btrfs_wait_on_page_writeback(page);
 			}
 
 			if (PageWriteback(page) ||
diff -Nrup linux-2.6.29.org/fs/btrfs/file.c linux-2.6.29.btrfs/fs/btrfs/file.c
--- linux-2.6.29.org/fs/btrfs/file.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/file.c	2009-03-24 15:34:49.000000000 +0900
@@ -967,7 +967,7 @@ again:
 			err = -ENOMEM;
 			BUG_ON(1);
 		}
-		wait_on_page_writeback(pages[i]);
+		btrfs_wait_on_page_writeback(pages[i]);
 	}
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
diff -Nrup linux-2.6.29.org/fs/btrfs/inode.c linux-2.6.29.btrfs/fs/btrfs/inode.c
--- linux-2.6.29.org/fs/btrfs/inode.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/inode.c	2009-03-24 15:35:23.000000000 +0900
@@ -2733,7 +2733,7 @@ again:
 			goto out_unlock;
 		}
 	}
-	wait_on_page_writeback(page);
+	btrfs_wait_on_page_writeback(page);
 
 	lock_extent(io_tree, page_start, page_end, GFP_NOFS);
 	set_page_extent_mapped(page);
@@ -4240,7 +4240,7 @@ static void btrfs_invalidatepage(struct 
 	u64 page_start = page_offset(page);
 	u64 page_end = page_start + PAGE_CACHE_SIZE - 1;
 
-	wait_on_page_writeback(page);
+	btrfs_wait_on_page_writeback(page);
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	if (offset) {
 		btrfs_releasepage(page, GFP_NOFS);
@@ -4322,7 +4322,7 @@ again:
 		/* page got truncated out from underneath us */
 		goto out_unlock;
 	}
-	wait_on_page_writeback(page);
+	btrfs_wait_on_page_writeback(page);
 
 	lock_extent(io_tree, page_start, page_end, GFP_NOFS);
 	set_page_extent_mapped(page);
diff -Nrup linux-2.6.29.org/fs/btrfs/ioctl.c linux-2.6.29.btrfs/fs/btrfs/ioctl.c
--- linux-2.6.29.org/fs/btrfs/ioctl.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/ioctl.c	2009-03-24 15:35:46.000000000 +0900
@@ -400,7 +400,7 @@ again:
 			}
 		}
 
-		wait_on_page_writeback(page);
+		btrfs_wait_on_page_writeback(page);
 
 		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
diff -Nrup linux-2.6.29.org/fs/btrfs/ordered-data.c linux-2.6.29.btrfs/fs/btrfs/ordered-data.c
--- linux-2.6.29.org/fs/btrfs/ordered-data.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/ordered-data.c	2009-03-25 11:04:32.000000000 +0900
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/hash.h>
 #include "ctree.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
@@ -673,6 +674,46 @@ int btrfs_fdatawrite_range(struct addres
 	return btrfs_writepages(mapping, &wbc);
 }
 
+static void process_timeout(unsigned long __data)
+{
+	wake_up_process((struct task_struct *)__data);
+}
+
+static int btrfs_sync_page(void *word)
+{
+	struct address_space *mapping;
+	struct page *page;
+	struct timer_list timer;
+
+	page = container_of((unsigned long *)word, struct page, flags);
+
+	smp_mb();
+	mapping = page->mapping;
+	if (mapping && mapping->a_ops && mapping->a_ops->sync_page)
+		mapping->a_ops->sync_page(page);
+	setup_timer(&timer, process_timeout, (unsigned long)current);
+	__mod_timer(&timer, jiffies + 1);
+	io_schedule();
+	del_timer_sync(&timer);
+	return 0;
+}
+
+static wait_queue_head_t *page_waitqueue(struct page *page)
+{
+	const struct zone *zone = page_zone(page);
+
+	return &zone->wait_table[hash_ptr(page, zone->wait_table_bits)];
+}
+
+void btrfs_wait_on_page_bit(struct page *page)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, PG_writeback);
+
+	if (test_bit(PG_writeback, &page->flags))
+		__wait_on_bit(page_waitqueue(page), &wait, btrfs_sync_page,
+							TASK_UNINTERRUPTIBLE);
+}
+
 /**
  * taken from mm/filemap.c because it isn't exported
  *
@@ -710,7 +751,7 @@ int btrfs_wait_on_page_writeback_range(s
 			if (page->index > end)
 				continue;
 
-			wait_on_page_writeback(page);
+			btrfs_wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
 		}
diff -Nrup linux-2.6.29.org/fs/btrfs/transaction.c linux-2.6.29.btrfs/fs/btrfs/transaction.c
--- linux-2.6.29.org/fs/btrfs/transaction.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29.btrfs/fs/btrfs/transaction.c	2009-03-24 15:37:19.000000000 +0900
@@ -352,7 +352,7 @@ int btrfs_write_and_wait_marked_extents(
 
 			if (PageWriteback(page)) {
 				if (PageDirty(page))
-					wait_on_page_writeback(page);
+					btrfs_wait_on_page_writeback(page);
 				else {
 					unlock_page(page);
 					page_cache_release(page);
@@ -380,12 +380,12 @@ int btrfs_write_and_wait_marked_extents(
 				continue;
 			if (PageDirty(page)) {
 				btree_lock_page_hook(page);
-				wait_on_page_writeback(page);
+				btrfs_wait_on_page_writeback(page);
 				err = write_one_page(page, 0);
 				if (err)
 					werr = err;
 			}
-			wait_on_page_writeback(page);
+			btrfs_wait_on_page_writeback(page);
 			page_cache_release(page);
 			cond_resched();
 		}

