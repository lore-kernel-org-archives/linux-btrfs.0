Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2488 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750951AbdBUIHG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:07:06 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs: Handle delalloc error correctly to avoid deadlock
Date: Tue, 21 Feb 2017 16:06:59 +0800
Message-ID: <20170221080659.23299-1-quwenruo@cn.fujitsu.com>
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
v2:
  Add BTRFS_ORDERED_SKIP_METADATA flag to avoid double reducing
  outstanding extents, which is already done by
  extent_clear_unlock_delalloc()
---
 fs/btrfs/inode.c        | 75 +++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.h |  2 ++
 2 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a063721..a0b09ff73eae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -116,6 +116,41 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 
 static int btrfs_dirty_inode(struct inode *inode);
 
+static void __endio_write_update_ordered(struct inode *inode,
+					 const u64 offset,
+					 const u64 bytes,
+					 const int uptodate,
+					 const int skip_meta);
+static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
+							   const u64 offset,
+							   const u64 bytes,
+							   const int uptodate)
+{
+	return __endio_write_update_ordered(inode, offset, bytes, uptodate, 0);
+}
+
+/*
+ * Set error bit and cleanup all ordered extents in specified range of @inode.
+ *
+ * This is for error case where ordered extent(s) is submitted but
+ * corresponding bio is not submitted.
+ * This can make waiter on such ordered extent never finish, as there is no
+ * endio hook called to finish such ordered extent.
+ */
+static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
+						 const u64 offset,
+						 const u64 bytes)
+{
+	/*
+	 * In error handler, we have extent_clear_unlock_delalloc() called
+	 * to reduce our metadata space reservation and outstanding extents.
+	 *
+	 * So here, we don't need finish_ordered_io() to free metadata space
+	 * for us, or we will underflow outstanding extents.
+	 */
+	return __endio_write_update_ordered(inode, offset, bytes, 0, 1);
+}
+
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode)
 {
@@ -237,7 +272,6 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-
 /*
  * conditionally insert an inline extent into the file.  This
  * does the checks required to make sure the data is small enough
@@ -1096,6 +1130,7 @@ static noinline int cow_file_range(struct inode *inode,
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+	btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
 	goto out;
 }
 
@@ -1538,7 +1573,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	if (!ret)
 		ret = err;
 
-	if (ret && cur_offset < end)
+	if (ret && cur_offset < end) {
 		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
@@ -1546,6 +1581,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
+		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+	}
 	btrfs_free_path(path);
 	return ret;
 }
@@ -2889,6 +2926,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	nolock = btrfs_is_free_space_inode(inode);
 
+	/* Ordered extent with SKIP_META implies IOERR */
+	if (test_bit(BTRFS_ORDERED_SKIP_META, &ordered_extent->flags))
+		ASSERT(test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags));
+
 	if (test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags)) {
 		ret = -EIO;
 		goto out;
@@ -3008,7 +3049,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
-	if (root != fs_info->tree_root)
+	if (root != fs_info->tree_root &&
+	    !test_bit(BTRFS_ORDERED_SKIP_META, &ordered_extent->flags))
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans)
 		btrfs_end_transaction(trans);
@@ -8185,17 +8227,28 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
-						    const u64 offset,
-						    const u64 bytes,
-						    const int uptodate)
+static void __endio_write_update_ordered(struct inode *inode,
+					 const u64 offset,
+					 const u64 bytes,
+					 const int uptodate,
+					 const int skip_meta)
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
@@ -8203,10 +8256,10 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
 						   uptodate);
 	if (!ret)
 		goto out_test;
-
-	btrfs_init_work(&ordered->work, btrfs_endio_write_helper,
-			finish_ordered_fn, NULL, NULL);
-	btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
+	if (skip_meta)
+		set_bit(BTRFS_ORDERED_SKIP_META, &ordered->flags);
+	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
+	btrfs_queue_work(wq, &ordered->work);
 out_test:
 	/*
 	 * our bio might span multiple ordered extents.  If we haven't
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 5f2b0ca28705..1434372c6352 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -75,6 +75,8 @@ struct btrfs_ordered_sum {
 				 * in the logging code. */
 #define BTRFS_ORDERED_PENDING 11 /* We are waiting for this ordered extent to
 				  * complete in the current transaction. */
+#define BTRFS_ORDERED_SKIP_META 12 /* No need to free metadata */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
-- 
2.11.1



