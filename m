Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39289 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbcFNHM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 03:12:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5E79IC6146430
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:27 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23gcydps7p-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:27 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 14 Jun 2016 01:12:25 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V19 14/19] Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page from being unlocked more than once
Date: Tue, 14 Jun 2016 12:41:11 +0530
In-Reply-To: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1465888276-30670-15-git-send-email-chandan@linux.vnet.ibm.com>
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
index 9e28419..73cb21d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1835,9 +1835,8 @@ out_failed:
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
@@ -1845,6 +1844,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
 	unsigned long nr_pages = end_index - index + 1;
+	u64 page_end;
 	int i;
 
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
@@ -1881,8 +1881,14 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
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
index cbc2099..e8e504c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -505,9 +505,8 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
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
index a8d745a..4a4ea7f 100644
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
@@ -562,12 +563,13 @@ cont:
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
@@ -716,6 +718,8 @@ retry:
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
+					     async_extent->start +
+					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0);
 
 			/* JDM XXX */
@@ -836,6 +840,8 @@ retry:
 		extent_clear_unlock_delalloc(inode, async_extent->start,
 				async_extent->start +
 				async_extent->ram_size - 1,
+				async_extent->start +
+				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
@@ -855,9 +861,10 @@ retry:
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
@@ -872,6 +879,8 @@ out_free:
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
 				     async_extent->ram_size - 1,
+				     async_extent->start +
+				     async_extent->ram_size - 1,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
@@ -928,10 +937,10 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
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
@@ -967,7 +976,8 @@ static noinline int cow_file_range(struct inode *inode,
 		ret = cow_file_range_inline(root, inode, start, end, 0, 0,
 					    NULL);
 		if (ret == 0) {
-			extent_clear_unlock_delalloc(inode, start, end, NULL,
+			extent_clear_unlock_delalloc(inode, start, end,
+				     delalloc_end, NULL,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DEFRAG, PAGE_UNLOCK |
 				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
@@ -1059,9 +1069,9 @@ static noinline int cow_file_range(struct inode *inode,
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
@@ -1093,8 +1103,8 @@ out_unlock:
 	extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING
 		| EXTENT_DEFRAG;
 
-	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				extent_ops, page_ops);
+	extent_clear_unlock_delalloc(inode, start, end, delalloc_end,
+				locked_page, extent_ops, page_ops);
 	goto out;
 }
 
@@ -1241,9 +1251,9 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
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
@@ -1269,7 +1279,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1287,7 +1298,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root);
 
 	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+		extent_clear_unlock_delalloc(inode, start, end, end,
+					     locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
@@ -1434,8 +1446,8 @@ out_check:
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
@@ -1500,10 +1512,10 @@ out_check:
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
@@ -1518,7 +1530,7 @@ out_check:
 	}
 
 	if (cow_start != (u64)-1) {
-		ret = cow_file_range(inode, locked_page, cow_start, end,
+		ret = cow_file_range(inode, locked_page, cow_start, end, end,
 				     page_started, nr_written, 1);
 		if (ret)
 			goto error;
@@ -1530,7 +1542,7 @@ error:
 		ret = err;
 
 	if (ret && cur_offset < end)
-		extent_clear_unlock_delalloc(inode, cur_offset, end,
+		extent_clear_unlock_delalloc(inode, cur_offset, end, end,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
@@ -1578,7 +1590,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
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

