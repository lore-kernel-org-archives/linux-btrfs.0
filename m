Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17790 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbcFNHMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 03:12:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5E79LZ6140335
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:04 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23gdxtw13p-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:04 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 14 Jun 2016 01:12:02 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V19 08/19] Btrfs: subpage-blocksize: Deal with partial ordered extent allocations.
Date: Tue, 14 Jun 2016 12:41:05 +0530
In-Reply-To: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1465888276-30670-9-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpage-blocksize scenario, extent allocations for only some of the
dirty blocks of a page can succeed, while allocation for rest of the
blocks can fail. This patch allows I/O against such pages to be
submitted.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 27 ++++++++++++++-------------
 fs/btrfs/inode.c     | 39 ++++++++++++++++++++++++++-------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0465311..74e27f9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1863,17 +1863,23 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 			if (page_ops & PAGE_SET_PRIVATE2)
 				SetPagePrivate2(pages[i]);
 
+			if (page_ops & PAGE_SET_ERROR)
+				SetPageError(pages[i]);
+
 			if (pages[i] == locked_page) {
 				put_page(pages[i]);
 				continue;
 			}
-			if (page_ops & PAGE_CLEAR_DIRTY)
+
+			if ((page_ops & PAGE_CLEAR_DIRTY)
+				&& !PagePrivate2(pages[i]))
 				clear_page_dirty_for_io(pages[i]);
-			if (page_ops & PAGE_SET_WRITEBACK)
+			if ((page_ops & PAGE_SET_WRITEBACK)
+				&& !PagePrivate2(pages[i]))
 				set_page_writeback(pages[i]);
-			if (page_ops & PAGE_SET_ERROR)
-				SetPageError(pages[i]);
-			if (page_ops & PAGE_END_WRITEBACK)
+
+			if ((page_ops & PAGE_END_WRITEBACK)
+				&& !PagePrivate2(pages[i]))
 				end_page_writeback(pages[i]);
 			if (page_ops & PAGE_UNLOCK)
 				unlock_page(pages[i]);
@@ -2565,7 +2571,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 			uptodate = 0;
 	}
 
-	if (!uptodate) {
+	if (!uptodate || PageError(page)) {
 		ClearPageUptodate(page);
 		SetPageError(page);
 		ret = ret < 0 ? ret : -EIO;
@@ -3420,7 +3426,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 					       nr_written);
 		/* File system has been set read-only */
 		if (ret) {
-			SetPageError(page);
 			/* fill_delalloc should be return < 0 for error
 			 * but just in case, we use > 0 here meaning the
 			 * IO is started, so we don't want to return > 0
@@ -3641,7 +3646,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_SIZE - 1;
 	int ret;
 	int nr = 0;
 	size_t pg_offset = 0;
@@ -3686,7 +3690,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
 	if (ret == 1)
 		goto done_unlocked;
-	if (ret)
+	if (ret && !PagePrivate2(page))
 		goto done;
 
 	ret = __extent_writepage_io(inode, page, wbc, epd,
@@ -3700,10 +3704,7 @@ done:
 		set_page_writeback(page);
 		end_page_writeback(page);
 	}
-	if (PageError(page)) {
-		ret = ret < 0 ? ret : -EIO;
-		end_extent_writepage(page, ret, start, page_end);
-	}
+
 	unlock_page(page);
 	return ret;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e85865b..a6bb415 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -943,6 +943,8 @@ static noinline int cow_file_range(struct inode *inode,
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_ordered_extent *ordered;
+	unsigned long page_ops, extent_ops;
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
@@ -987,8 +989,6 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
 	while (disk_num_bytes > 0) {
-		unsigned long op;
-
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
@@ -1041,7 +1041,7 @@ static noinline int cow_file_range(struct inode *inode,
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			if (ret)
-				goto out_drop_extent_cache;
+				goto out_remove_ordered_extent;
 		}
 
 		btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
@@ -1056,13 +1056,12 @@ static noinline int cow_file_range(struct inode *inode,
 		 * Do set the Private2 bit so we know this page was properly
 		 * setup for writepage
 		 */
-		op = unlock ? PAGE_UNLOCK : 0;
-		op |= PAGE_SET_PRIVATE2;
-
+		page_ops = unlock ? PAGE_UNLOCK : 0;
+		page_ops |= PAGE_SET_PRIVATE2;
+		extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC;
 		extent_clear_unlock_delalloc(inode, start,
-					     start + ram_size - 1, locked_page,
-					     EXTENT_LOCKED | EXTENT_DELALLOC,
-					     op);
+					start + ram_size - 1, locked_page,
+					extent_ops, page_ops);
 		disk_num_bytes -= cur_alloc_size;
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
@@ -1071,17 +1070,31 @@ static noinline int cow_file_range(struct inode *inode,
 out:
 	return ret;
 
+out_remove_ordered_extent:
+	ordered = btrfs_lookup_ordered_extent(inode, start);
+	BUG_ON(!ordered);
+	btrfs_remove_ordered_extent(inode, ordered);
+	/* once for us */
+	btrfs_put_ordered_extent(ordered);
+	/* once for the tree */
+	btrfs_put_ordered_extent(ordered);
+
 out_drop_extent_cache:
 	btrfs_drop_extent_cache(inode, start, start + ram_size - 1, 0);
+
 out_reserve:
 	btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
+
 out_unlock:
+	page_ops = unlock ? PAGE_UNLOCK : 0;
+	page_ops |= PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK
+		| PAGE_SET_ERROR;
+	extent_ops = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING
+		| EXTENT_DEFRAG;
+
 	extent_clear_unlock_delalloc(inode, start, end, locked_page,
-				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
-				     EXTENT_DELALLOC | EXTENT_DEFRAG,
-				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
+				extent_ops, page_ops);
 	goto out;
 }
 
-- 
2.1.0

