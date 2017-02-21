Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43600 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750977AbdBUC3y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 21:29:54 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Handle delalloc error correctly to avoid deadlock
Date: Tue, 21 Feb 2017 10:29:36 +0800
Message-ID: <20170221022936.24179-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If run btrfs/125 with nospace_cache or space_cache=v2 mount option,
btrfs will block with the following backtrace:

Call Trace:
 __schedule+0x2d4/0xae0
 schedule+0x3d/0x90
 btrfs_start_ordered_extent+0x160/0x200 [btrfs]
 ? wake_atomic_t_function+0x60/0x60
 btrfs_run_ordered_extent_work+0x25/0x40 [btrfs]
 btrfs_scrubparity_helper+0x1c1/0x620 [btrfs]
 btrfs_flush_delalloc_helper+0xe/0x10 [btrfs]
 process_one_work+0x2af/0x720
 ? process_one_work+0x22b/0x720
 worker_thread+0x4b/0x4f0
 kthread+0x10f/0x150
 ? process_one_work+0x720/0x720
 ? kthread_create_on_node+0x40/0x40
 ret_from_fork+0x2e/0x40

The direct cause is the error handler in run_delalloc_nocow() doesn't
handle error from btrfs_reloc_clone_csums() well.

The error handler of run_delalloc_nocow() will clear dirty and finish IO
for the pages in that extent.
However we have already inserted one ordered extent.
And that ordered extent is relying on endio hooks to wait all its pages
to finish, while only the first page will finish.

This makes that ordered extent never finish, so blocking the file
system.

Although the root cause is still in RAID5/6, it won't hurt to fix the
error routine first.

This patch will slightly modify one existing function,
btrfs_endio_direct_write_update_ordered() to handle free space inode,
just like what btrfs_writepage_end_io_hook() does.

And use it as base to implement one inline function,
btrfs_cleanup_ordered_extents() to handle the error in
run_delalloc_nocow() and cow_file_range().

For compression, it's calling writepage_end_io_hook() itself to handle
its error, and any submitted ordered extent will have its bio submitted,
so no need to worry about compression part.

Suggested-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a063721..e2e2267b9a73 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -113,6 +113,24 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 block_start, u64 block_len,
 					   u64 orig_block_len, u64 ram_bytes,
 					   int type);
+static void btrfs_endio_write_update_ordered(struct inode *inode,
+					     const u64 offset,
+					     const u64 bytes,
+					     const int uptodate);
+/*
+ * Set error bit and cleanup all ordered extents in specified range of @inode.
+ *
+ * This is for error case where ordered extent(s) is submitted but
+ * corresponding bio is not submitted.
+ * This can make waiter on such ordered extent never finish, as there is no
+ * endio hook called to finish such ordered extent.
+ */
+static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
+						 const u64 start,
+						 const u64 len)
+{
+	return btrfs_endio_write_update_ordered(inode, start, len, 0);
+}
 
 static int btrfs_dirty_inode(struct inode *inode);
 
@@ -1096,6 +1114,7 @@ static noinline int cow_file_range(struct inode *inode,
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+	btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
 	goto out;
 }
 
@@ -1538,7 +1557,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	if (!ret)
 		ret = err;
 
-	if (ret && cur_offset < end)
+	if (ret && cur_offset < end) {
 		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
@@ -1546,6 +1565,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
+		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+	}
 	btrfs_free_path(path);
 	return ret;
 }
@@ -8185,17 +8206,27 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
-						    const u64 offset,
-						    const u64 bytes,
-						    const int uptodate)
+static void btrfs_endio_write_update_ordered(struct inode *inode,
+					     const u64 offset,
+					     const u64 bytes,
+					     const int uptodate)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ordered_extent *ordered = NULL;
+	struct btrfs_workqueue *wq;
+	btrfs_work_func_t func;
 	u64 ordered_offset = offset;
 	u64 ordered_bytes = bytes;
 	int ret;
 
+	if (btrfs_is_free_space_inode(inode)) {
+		wq = fs_info->endio_freespace_worker;
+		func = btrfs_freespace_write_helper;
+	} else {
+		wq = fs_info->endio_write_workers;
+		func = btrfs_endio_write_helper;
+	}
+
 again:
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
@@ -8204,9 +8235,8 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
 	if (!ret)
 		goto out_test;
 
-	btrfs_init_work(&ordered->work, btrfs_endio_write_helper,
-			finish_ordered_fn, NULL, NULL);
-	btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
+	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
+	btrfs_queue_work(wq, &ordered->work);
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
@@ -8224,10 +8254,10 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio *dio_bio = dip->dio_bio;
 
-	btrfs_endio_direct_write_update_ordered(dip->inode,
-						dip->logical_offset,
-						dip->bytes,
-						!bio->bi_error);
+	btrfs_endio_write_update_ordered(dip->inode,
+					 dip->logical_offset,
+					 dip->bytes,
+					 !bio->bi_error);
 
 	kfree(dip);
 
@@ -8587,7 +8617,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 		io_bio = NULL;
 	} else {
 		if (write)
-			btrfs_endio_direct_write_update_ordered(inode,
+			btrfs_endio_write_update_ordered(inode,
 						file_offset,
 						dio_bio->bi_iter.bi_size,
 						0);
@@ -8726,7 +8756,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			 */
 			if (dio_data.unsubmitted_oe_range_start <
 			    dio_data.unsubmitted_oe_range_end)
-				btrfs_endio_direct_write_update_ordered(inode,
+				btrfs_endio_write_update_ordered(inode,
 					dio_data.unsubmitted_oe_range_start,
 					dio_data.unsubmitted_oe_range_end -
 					dio_data.unsubmitted_oe_range_start,
-- 
2.11.1



