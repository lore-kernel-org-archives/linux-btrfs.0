Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3040 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751053AbdBVFHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:07:49 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <bo.li.liu@oracle.com>
Subject: [PATCH v3 2/2] btrfs: Handle delalloc error correctly to avoid ordered extent deadlock
Date: Wed, 22 Feb 2017 13:07:14 +0800
Message-ID: <20170222050714.25457-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170222050714.25457-1-quwenruo@cn.fujitsu.com>
References: <20170222050714.25457-1-quwenruo@cn.fujitsu.com>
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
and skip releasing metadata, which will be handled by
extent_clear_unlock_delalloc().

And use it as base to implement one inline function,
btrfs_cleanup_ordered_extents() to handle the error in
run_delalloc_nocow() and cow_file_range().

Also, extent_clear_unlock_delalloc() will handle all the metadata
release, so btrfs_cleanup_ordered_extents() doesn't need to do it.

For compression, it's calling writepage_end_io_hook() itself to handle
its error, and any submitted ordered extent will have its bio submitted,
so no need to worry about compression part.

Suggested-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add BTRFS_ORDERED_SKIP_METADATA flag to avoid double reducing
  outstanding extents, which is already done by
  extent_clear_unlock_delalloc() with EXTENT_DO_ACCOUNT control bit
v3:
  Skip first page to avoid underflow ordered->bytes_left.
  Fix range passed in cow_file_range() which doesn't cover the whole
  extent.
  Expend extent_clear_unlock_delalloc() range to allow them to handle
  metadata release.
---
 fs/btrfs/extent_io.c |  1 -
 fs/btrfs/inode.c     | 68 +++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a3a649..a14d1b0840c5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3258,7 +3258,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 					       delalloc_end,
 					       &page_started,
 					       nr_written);
-		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
 			/* fill_delalloc should be return < 0 for error
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92a7c3051b94..d4bac8f5caeb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -116,6 +116,33 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 
 static int btrfs_dirty_inode(struct inode *inode);
 
+
+static void __endio_write_update_ordered(struct inode *inode,
+					 const u64 offset, const u64 bytes,
+					 bool uptodate, bool cleanup);
+static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
+							   const u64 offset,
+							   const u64 bytes,
+							   const int uptodate)
+{
+	return __endio_write_update_ordered(inode, offset, bytes, uptodate, false);
+}
+
+/*
+ * Cleanup all submitted ordered extent in specified range to handle error
+ * in cow_file_range() and run_delalloc_nocow().
+ * Compression handles error and ordered extent submission all by themselves,
+ * so no need to call this function.
+ *
+ * NOTE: caller must ensure they have already released their metadata by
+ * extent_clear_unlock_delalloc() with EXTENT_DO_ACCOUNTING control bit.
+ */
+static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
+						 u64 offset, u64 bytes)
+{
+	return __endio_write_update_ordered(inode, offset, bytes, false, true);
+}
+
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode)
 {
@@ -950,6 +977,7 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = fs_info->sectorsize;
+	u64 orig_start = start;
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
@@ -1090,12 +1118,13 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
 out_unlock:
-	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+	extent_clear_unlock_delalloc(inode, orig_start, end, delalloc_end,
 				     locked_page,
 				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+	btrfs_cleanup_ordered_extents(inode, orig_start, end - orig_start + 1);
 	goto out;
 }
 
@@ -1538,14 +1567,18 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	if (!ret)
 		ret = err;
 
-	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
+	if (ret && cur_offset < end) {
+		/* All metadata of the whole range freed by this function */
+		extent_clear_unlock_delalloc(inode, start, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
+		/* Only handle ordered extents, no metadata freeing */
+		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+	}
 	btrfs_free_path(path);
 	return ret;
 }
@@ -8186,22 +8219,41 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
-						    const u64 offset,
-						    const u64 bytes,
-						    const int uptodate)
+static void __endio_write_update_ordered(struct inode *inode,
+					 const u64 offset, const u64 bytes,
+					 bool uptodate, bool cleanup)
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
+	/*
+	 * In cleanup case, the first page of the range will be handled
+	 * by end_extent_writepage() under done tag of __extent_writepage().
+	 *
+	 * So we must skip first page, or we will underflow ordered->bytes_left
+	 */
+	if (cleanup) {
+		ordered_offset += PAGE_SIZE;
+		ordered_bytes -= PAGE_SIZE;
+	}
 again:
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
 						   ordered_bytes,
-						   uptodate, false);
+						   uptodate, cleanup);
 	if (!ret)
 		goto out_test;
 
-- 
2.11.1



