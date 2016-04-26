Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([125.16.236.1]:50833 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbcDZN2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:28:17 -0400
Received: from localhost
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 18:58:14 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QDSB0B52429026
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:11 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QDS9Bt010008
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:10 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com
Subject: [PATCH V18 14/18] Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page from being unlocked more than once
Date: Tue, 26 Apr 2016 18:57:13 +0530
Message-Id: <1461677237-7703-15-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/extent_io.c | 16 ++++++----
 fs/btrfs/extent_io.h |  5 ++--
 fs/btrfs/inode.c     | 84 ++++++++++++++++++++++++++++++----------------------
 3 files changed, 61 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 75221a9..3fee8ee1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1823,9 +1823,8 @@ out_failed:
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
@@ -1833,6 +1832,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
 	unsigned long nr_pages = end_index - index + 1;
+	u64 page_end;
 	int i;
 
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
@@ -1869,8 +1869,14 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 			if ((page_ops & PAGE_END_WRITEBACK)
 				&& !PagePrivate2(pages[i]))
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
index 63ad8c0..0419a89 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -499,9 +499,8 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
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
index 2a6d829..dfd5392 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -104,9 +104,10 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr);
 static int btrfs_truncate(struct inode *inode);
 static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
-				   struct page *locked_page,
-				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written, int unlock);
+				struct page *locked_page,
+				u64 start, u64 end, u64 delalloc_end,
+				int *page_started, unsigned long *nr_written,
+				int unlock);
 static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 len, u64 orig_start,
 					   u64 block_start, u64 block_len,
@@ -561,12 +562,13 @@ cont:
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
@@ -715,6 +717,8 @@ retry:
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
+					     async_extent->start +
+					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0);
 
 			/* JDM XXX */
@@ -834,6 +838,8 @@ retry:
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
+				async_extent->start +
+				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -853,9 +859,10 @@ retry:
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
@@ -869,6 +876,8 @@ out_free:
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
+				     async_extent->start +
+				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -925,10 +934,10 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
  * IO when we return.
  */
 static noinline int cow_file_range(struct inode *inode,
-				   struct page *locked_page,
-				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written,
-				   int unlock)
+				struct page *locked_page,
+				u64 start, u64 end, u64 delalloc_end,
+				int *page_started, unsigned long *nr_written,
+				int unlock)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 alloc_hint = 0;
@@ -964,7 +973,8 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
 					    NULL);
 		if (ret == 0) {
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
+			extent_clear_unlock_delalloc(inode, start, end,
+				     delalloc_end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
@@ -1054,9 +1064,9 @@ static noinline int cow_file_range(struct inode *inode,
 		page_ops = unlock ? PAGE_UNLOCK : 0;
 		page_ops |= PAGE_SET_PRIVATE2;
 		extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC;
-		extent_clear_unlock_delalloc(inode, start,
-					start + ram_size - 1, locked_page,
-					extent_ops, page_ops);
+		extent_clear_unlock_delalloc(inode, start, start + ram_size - 1,
+					delalloc_end, locked_page, extent_ops,
+					page_ops);
 		disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
@@ -1087,8 +1097,8 @@ out_unlock:
 	extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING
 		| EXTENT_DEFRAG;
 
-	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				extent_ops, page_ops);
+	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+				locked_page, extent_ops, page_ops);
 	goto out;
 }
 
@@ -1235,9 +1245,9 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
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
@@ -1263,7 +1273,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1281,7 +1292,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root);
 
 	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1422,8 +1434,8 @@ out_check:
 		btrfs_release_path(path);
 		if (cow_start != (u64)-1) {
 			ret = cow_file_range(inode, locked_page,
-					     cow_start, found_key.offset - 1,
-					     page_started, nr_written, 1);
+					cow_start, found_key.offset - 1, end,
+					page_started, nr_written, 1);
 			if (ret) {
 				if (!nolock && nocow)
 					btrfs_end_write_no_snapshoting(root);
@@ -1483,10 +1495,10 @@ out_check:
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
@@ -1501,7 +1513,7 @@ out_check:
 	}
 
 	if (cow_start != (u64)-1) {
-		ret = cow_file_range(inode, locked_page, cow_start, end,
+		ret = cow_file_range(inode, locked_page, cow_start, end, end,
 				     page_started, nr_written, 1);
 		if (ret)
 			goto error;
@@ -1513,7 +1525,7 @@ error:
 		ret = err;
 
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
@@ -1561,7 +1573,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	} else if (!inode_need_compress(inode)) {
-		ret = cow_file_range(inode, locked_page, start, end,
+		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-- 
2.1.0

