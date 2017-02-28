Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35563 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751513AbdB1CsH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 21:48:07 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <bo.li.liu@oracle.com>
Subject: [PATCH v5] btrfs: Handle delalloc error correctly to avoid ordered extent hang
Date: Tue, 28 Feb 2017 10:42:17 +0800
Message-ID: <20170228024217.22873-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Reports about btrfs hang running btrfs/124 with default mount option and
btrfs/125 with nospace_cache or space_cache=v2 mount options, with
following backtrace.

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

[CAUSE]
The problem is caused by error handler in run_delalloc_nocow() doesn't
handle error from btrfs_reloc_clone_csums() well.

Error handlers in run_dealloc_nocow() and cow_file_range() will clear
dirty flags and finish writeback for remaining pages like the following:

|<------------------ delalloc range --------------------------->|
| Ordered extent 1 | Ordered extent 2          |
|    Submitted OK  | recloc_clone_csum() error |
|<>|               |<----------- cleanup range ---------------->|
 ||
 \_=> First page handled by end_extent_writepage() in __extent_writepage()

This behavior has two problems:
1) Ordered extent 2 will never finish
   Ordered extent 2 is already submitted, which relies endio hooks to
   wait for all its pages to finish.

   However since we finish writeback in error handler, ordered extent 2
   will never finish.

2) Metadata underflow
   btrfs_finish_ordered_io() for ordered extent will free its reserved
   metadata space, while error handlers will also free metadata space of
   the remaining range, which covers ordered extent 2.

   So even if problem 1) is solved, we can still under flow metadata
   reservation, which will leads to deadly btrfs assertion.

[FIX]
This patch will resolve the problem in two steps:
1) Introduce btrfs_cleanup_ordered_extents() to cleanup ordered extents
   Slightly modify one existing function,
   btrfs_endio_direct_write_update_ordered() to handle free space inode
   just like btrfs_writepage_endio_hook() and skip first page to
   co-operate with end_extent_writepage().

   So btrfs_cleanup_ordered_extents() will search all submitted ordered
   extent in specified range, and clean them up except the first page.

2) Make error handlers skip any range covered by ordered extent
   For run_delalloc_nocow() and cow_file_range(), only allow error
   handlers to clean up pages/extents not covered by submitted ordered
   extent.

   For compression, it's calling writepage_end_io_hook() itself to handle
   its error, and any submitted ordered extent will have its bio
   submitted, so no need to worry about compression part.

After the fix, the clean up will happen like:

|<--------------------------- delalloc range --------------------------->|
| Ordered extent 1 | Ordered extent 2          |
|    Submitted OK  | recloc_clone_csum() error |
|<>|<- Cleaned up by cleanup_ordered_extents ->|<-- old error handler--->|
 ||
 \_=> First page handled by end_extent_writepage() in __extent_writepage()

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
v4:
  Don't use extra bit to skip metadata freeing for ordered extent,
  but only handle btrfs_reloc_clone_csums() error just before processing
  next extent.
  This makes error handle much easier for run_delalloc_nocow().
v5:
  Variant gramma and comment fixes suggested by Filipe Manana
  Enhanced commit message to focus on the generic error handler bug,
  pointed out by Filipe Manana
  Adding missing wq/func user in __endio_write_update_ordered(), pointed
  out by Filipe Manana.
  Enhanced commit message with ascii art to explain the bug more easily.
  Fix a bug which can leads to corrupted extent allocation, exposed by
  Filipe Manana.
---
 fs/btrfs/inode.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 97 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a063721..589114492743 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -116,6 +116,35 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 
 static int btrfs_dirty_inode(struct inode *inode);
 
+
+static void __endio_write_update_ordered(struct inode *inode,
+					 u64 offset, u64 bytes,
+					 bool uptodate, bool cleanup);
+
+static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
+							   u64 offset,
+							   u64 bytes,
+							   bool uptodate)
+{
+	return __endio_write_update_ordered(inode, offset, bytes, uptodate, false);
+}
+
+/*
+ * Cleanup all submitted ordered extents in specified range to handle error
+ * in cow_file_range() and run_delalloc_nocow().
+ * Compression handles error and ordered extent submission by itself,
+ * so no need to call this function.
+ *
+ * NOTE: caller must ensure extent_clear_unlock_delalloc() in error handler
+ * doesn't cover any range of submitted ordered extent.
+ * Or we will double free metadata for submitted ordered extent.
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
@@ -950,6 +979,7 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = fs_info->sectorsize;
+	u64 orig_start = start;
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
@@ -1052,15 +1082,24 @@ static noinline int cow_file_range(struct inode *inode,
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
+			/*
+			 * Only drop cache here, and process as normal.
+			 *
+			 * We must not allow extent_clear_unlock_delalloc()
+			 * at out_unlock label to free meta of this ordered
+			 * extent, as its meta should be freed by
+			 * btrfs_finish_ordered_io().
+			 *
+			 * So we must continue until @start is increased to
+			 * skip current ordered extent.
+			 */
 			if (ret)
-				goto out_drop_extent_cache;
+				btrfs_drop_extent_cache(inode, start,
+						start + ram_size - 1, 0);
 		}
 
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 
-		if (disk_num_bytes < cur_alloc_size)
-			break;
-
 		/* we're not doing compressed IO, don't unlock the first
 		 * page (which the caller expects to stay locked), don't
 		 * clear any dirty bits and don't set any writeback bits
@@ -1076,10 +1115,21 @@ static noinline int cow_file_range(struct inode *inode,
 					     delalloc_end, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     op);
-		disk_num_bytes -= cur_alloc_size;
+		if (disk_num_bytes < cur_alloc_size)
+			disk_num_bytes = 0;
+		else
+			disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
 		start += cur_alloc_size;
+
+		/*
+		 * btrfs_reloc_clone_csums() error, since start is increased
+		 * extent_clear_unlock_delalloc() at out_unlock label won't
+		 * free metadata of current ordered extent, we're OK to exit.
+		 */
+		if (ret)
+			goto out_unlock;
 	}
 out:
 	return ret;
@@ -1096,6 +1146,7 @@ static noinline int cow_file_range(struct inode *inode,
 				     EXTENT_DELALLOC | EXTENT_DEFRAG,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+	btrfs_cleanup_ordered_extents(inode, orig_start, end - orig_start + 1);
 	goto out;
 }
 
@@ -1496,15 +1547,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		BUG_ON(ret); /* -ENOMEM */
 
 		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
+		    BTRFS_DATA_RELOC_TREE_OBJECTID)
+			/*
+			 * Error handled later, as we must prevent
+			 * extent_clear_unlock_delalloc() in error handler
+			 * from freeing metadata of submitted ordered extent.
+			 */
 			ret = btrfs_reloc_clone_csums(inode, cur_offset,
 						      num_bytes);
-			if (ret) {
-				if (!nolock && nocow)
-					btrfs_end_write_no_snapshoting(root);
-				goto error;
-			}
-		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
 					     cur_offset + num_bytes - 1, end,
@@ -1516,6 +1566,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		if (!nolock && nocow)
 			btrfs_end_write_no_snapshoting(root);
 		cur_offset = extent_end;
+
+		/*
+		 * btrfs_reloc_clone_csums() error, now we're OK to call error
+		 * handler, as metadata for submitted ordered extent will only
+		 * be freed by btrfs_finish_ordered_io().
+		 */
+		if (ret)
+			goto error;
 		if (cur_offset > end)
 			break;
 	}
@@ -1546,6 +1604,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					     PAGE_CLEAR_DIRTY |
 					     PAGE_SET_WRITEBACK |
 					     PAGE_END_WRITEBACK);
+	if (ret)
+		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -8185,17 +8245,36 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
-						    const u64 offset,
-						    const u64 bytes,
-						    const int uptodate)
+static void __endio_write_update_ordered(struct inode *inode,
+					 u64 offset, u64 bytes,
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
+	 * by end_extent_writepage() when called from __extent_writepage()
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
@@ -8204,9 +8283,8 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
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
-- 
2.11.1



