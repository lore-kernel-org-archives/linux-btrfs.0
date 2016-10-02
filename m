Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750912AbcJBNZU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:20 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNCkJ046144
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:14 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25t7f9q56a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:13 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:13 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 01/19] Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page from being unlocked more than once
Date: Sun,  2 Oct 2016 18:54:10 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-2-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

extent_clear_unlock_delalloc() can unlock a page more than once as shown
below (assume 4k as the block size and 64k as the page size).

cow_file_range
  create 4k ordered extent corresponding to page offsets 0 - 4095
  extent_clear_unlock_delalloc corresponding to page offsets 0 - 4095
    unlock page
  create 4k ordered extent corresponding to page offsets 4096 - 8191
  extent_clear_unlock_delalloc corresponding to page offsets 4096 - 8191
    unlock page

To prevent such a scenario this commit passes "delalloc end" to
extent_clear_unlock_delalloc() to help decide whether the page can be unlocked
or not.

NOTE: Since extent_clear_unlock_delalloc() is used by compression code
as well, the commit passes ordered extent "end" as the value for the
argument corresponding to "delalloc end" for invocations made from
compression code path. This will be fixed by a future commit that gets
compression to work in subpage-blocksize scenario.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 16 +++++++----
 fs/btrfs/extent_io.h |  5 ++--
 fs/btrfs/inode.c     | 78 +++++++++++++++++++++++++++++-----------------------
 3 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f669240..dc60c604 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1708,9 +1708,8 @@ out_failed:
 }
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 struct page *locked_page,
-				 unsigned clear_bits,
-				 unsigned long page_ops)
+				u64 delalloc_end, struct page *locked_page,
+				unsigned clear_bits, unsigned long page_ops)
 {
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	int ret;
@@ -1718,6 +1717,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
 	unsigned long nr_pages = end_index - index + 1;
+	u64 page_end;
 	int i;
 
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
@@ -1748,8 +1748,14 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				SetPageError(pages[i]);
 			if (page_ops & PAGE_END_WRITEBACK)
 				end_page_writeback(pages[i]);
-			if (page_ops & PAGE_UNLOCK)
-				unlock_page(pages[i]);
+
+			if (page_ops & PAGE_UNLOCK) {
+				page_end = page_offset(pages[i]) +
+					PAGE_SIZE - 1;
+				if ((page_end <= end)
+					|| (end == delalloc_end))
+					unlock_page(pages[i]);
+			}
 			put_page(pages[i]);
 		}
 		nr_pages -= ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 06b6f14..0948bca 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -430,9 +430,8 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
 void extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
-				 struct page *locked_page,
-				 unsigned bits_to_clear,
-				 unsigned long page_ops);
+				u64 delalloc_end, struct page *locked_page,
+				unsigned bits_to_clear, unsigned long page_ops);
 struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3440b52..3e4feac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -560,12 +560,13 @@ cont:
 			 * we don't need to create any more async work items.
 			 * Unlock and free up our temp pages.
 			 */
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
-						     clear_flags, PAGE_UNLOCK |
-						     PAGE_CLEAR_DIRTY |
-						     PAGE_SET_WRITEBACK |
-						     page_error_op |
-						     PAGE_END_WRITEBACK);
+			extent_clear_unlock_delalloc(inode, start, end, end,
+						NULL, clear_flags,
+						PAGE_UNLOCK
+						| PAGE_CLEAR_DIRTY
+						| PAGE_SET_WRITEBACK
+						| page_error_op
+						| PAGE_END_WRITEBACK);
 			goto free_pages_out;
 		}
 	}
@@ -835,6 +836,8 @@ retry:
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
+				async_extent->start +
+				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -854,9 +857,10 @@ retry:
 			tree->ops->writepage_end_io_hook(p, start, end,
 							 NULL, 0);
 			p->mapping = NULL;
-			extent_clear_unlock_delalloc(inode, start, end, NULL, 0,
-						     PAGE_END_WRITEBACK |
-						     PAGE_SET_ERROR);
+			extent_clear_unlock_delalloc(inode, start, end, end,
+						NULL, 0,
+						PAGE_END_WRITEBACK |
+						PAGE_SET_ERROR);
 			free_async_extent_pages(async_extent);
 		}
 		alloc_hint = ins.objectid + ins.offset;
@@ -871,6 +875,8 @@ out_free:
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
+				     async_extent->start +
+				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -942,6 +948,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	unsigned long page_ops, extent_ops;
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
@@ -964,7 +971,8 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
 					    NULL);
 		if (ret == 0) {
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
+			extent_clear_unlock_delalloc(inode, start, end,
+				     delalloc_end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
@@ -986,8 +994,6 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
 	while (disk_num_bytes > 0) {
-		unsigned long op;
-
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
@@ -1055,13 +1061,12 @@ static noinline int cow_file_range(struct inode *inode,
 		 * Do set the Private2 bit so we know this page was properly
 		 * setup for writepage
 		 */
-		op = unlock ? PAGE_UNLOCK : 0;
-		op |= PAGE_SET_PRIVATE2;
-
-		extent_clear_unlock_delalloc(inode, start,
-					     start + ram_size - 1, locked_page,
-					     EXTENT_LOCKED | EXTENT_DELALLOC,
-					     op);
+		page_ops = unlock ? PAGE_UNLOCK : 0;
+		page_ops |= PAGE_SET_PRIVATE2;
+		extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC;
+		extent_clear_unlock_delalloc(inode, start, start + ram_size - 1,
+					delalloc_end, locked_page, extent_ops,
+					page_ops);
 		disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
@@ -1076,11 +1081,14 @@ out_reserve:
 	btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 out_unlock:
-	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
-				     EXTENT_DELALLOC | EXTENT_DEFRAG,
-				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+	page_ops = unlock ? PAGE_UNLOCK : 0;
+	page_ops |= PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK
+		| PAGE_SET_ERROR;
+	extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING
+		| EXTENT_DEFRAG;
+
+	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+				locked_page, extent_ops, page_ops);
 	goto out;
 }
 
@@ -1227,9 +1235,9 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
  * blocks on disk
  */
 static noinline int run_delalloc_nocow(struct inode *inode,
-				       struct page *locked_page,
-			      u64 start, u64 end, int *page_started, int force,
-			      unsigned long *nr_written)
+				struct page *locked_page,
+				u64 start, u64 end, int *page_started,
+				int force, unsigned long *nr_written)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
@@ -1255,7 +1263,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1273,7 +1282,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root);
 
 	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1487,10 +1497,10 @@ out_check:
 		}
 
 		extent_clear_unlock_delalloc(inode, cur_offset,
-					     cur_offset + num_bytes - 1,
-					     locked_page, EXTENT_LOCKED |
-					     EXTENT_DELALLOC, PAGE_UNLOCK |
-					     PAGE_SET_PRIVATE2);
+					cur_offset + num_bytes - 1, end,
+					locked_page, EXTENT_LOCKED |
+					EXTENT_DELALLOC, PAGE_UNLOCK |
+					PAGE_SET_PRIVATE2);
 		if (!nolock && nocow)
 			btrfs_end_write_no_snapshoting(root);
 		cur_offset = extent_end;
@@ -1517,7 +1527,7 @@ error:
 		ret = err;
 
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
-- 
2.5.5

