Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37149 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935102AbcAUK2V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:28:21 -0500
Received: from localhost
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 21 Jan 2016 20:28:19 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id D2AB83578053
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:28:16 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0LARk3046727204
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:54 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0LARhT4026118
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:44 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH V13 08/14] Btrfs: subpagesize-blocksize: Deal with partial ordered extent allocations.
Date: Thu, 21 Jan 2016 15:56:55 +0530
Message-Id: <1453372021-5089-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1453372021-5089-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1453372021-5089-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize scenario, extent allocations for only some of the
dirty blocks of a page can succeed, while allocation for rest of the blocks
can fail. This patch allows I/O against such pages to be submitted.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 27 ++++++++++++++-------------
 fs/btrfs/inode.c     | 39 ++++++++++++++++++++++++++-------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b106502..61480ab 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1853,17 +1853,23 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 			if (page_ops & PAGE_SET_PRIVATE2)
 				SetPagePrivate2(pages[i]);
 
+			if (page_ops & PAGE_SET_ERROR)
+				SetPageError(pages[i]);
+
 			if (pages[i] == locked_page) {
 				page_cache_release(pages[i]);
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
@@ -2552,7 +2558,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 			uptodate = 0;
 	}
 
-	if (!uptodate) {
+	if (!uptodate || PageError(page)) {
 		ClearPageUptodate(page);
 		SetPageError(page);
 		ret = ret < 0 ? ret : -EIO;
@@ -3393,7 +3399,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 					       nr_written);
 		/* File system has been set read-only */
 		if (ret) {
-			SetPageError(page);
 			/* fill_delalloc should be return < 0 for error
 			 * but just in case, we use > 0 here meaning the
 			 * IO is started, so we don't want to return > 0
@@ -3625,7 +3630,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	int ret;
 	int nr = 0;
 	size_t pg_offset = 0;
@@ -3670,7 +3674,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
 	if (ret == 1)
 		goto done_unlocked;
-	if (ret)
+	if (ret && !PagePrivate2(page))
 		goto done;
 
 	ret = __extent_writepage_io(inode, page, wbc, epd,
@@ -3684,10 +3688,7 @@ done:
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
index f8472c0..3254b6a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -941,6 +941,8 @@ static noinline int cow_file_range(struct inode *inode,
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_ordered_extent *ordered;
+	unsigned long page_ops, extent_ops;
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
@@ -985,8 +987,6 @@ static noinline int cow_file_range(struct inode *inode,
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
 	while (disk_num_bytes > 0) {
-		unsigned long op;
-
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
@@ -1039,7 +1039,7 @@ static noinline int cow_file_range(struct inode *inode,
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			if (ret)
-				goto out_drop_extent_cache;
+				goto out_remove_ordered_extent;
 		}
 
 		if (disk_num_bytes < cur_alloc_size)
@@ -1052,13 +1052,12 @@ static noinline int cow_file_range(struct inode *inode,
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
@@ -1067,16 +1066,30 @@ static noinline int cow_file_range(struct inode *inode,
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

