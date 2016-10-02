Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60316 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbcJBNZw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:52 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNHFF120687
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:52 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25u1dv2hjx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:52 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:51 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 11/19] Btrfs: subpage-blocksize: Deal with partial ordered extent allocations.
Date: Sun,  2 Oct 2016 18:54:20 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-12-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpage-blocksize scenario, extent allocations for only some of the
dirty blocks of a page can succeed, while allocation for rest of the
blocks can fail. This patch allows I/O against such pages to be
submitted.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 27 ++++++++++++++-------------
 fs/btrfs/inode.c     | 11 ++++++++++-
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9af8237..0832797 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1843,17 +1843,23 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
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
 
 			if (page_ops & PAGE_UNLOCK) {
@@ -2554,7 +2560,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 			uptodate = 0;
 	}
 
-	if (!uptodate) {
+	if (!uptodate || PageError(page)) {
 		ClearPageUptodate(page);
 		SetPageError(page);
 		ret = ret < 0 ? ret : -EIO;
@@ -3401,7 +3407,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 					       nr_written);
 		/* File system has been set read-only */
 		if (ret) {
-			SetPageError(page);
 			/* fill_delalloc should be return < 0 for error
 			 * but just in case, we use > 0 here meaning the
 			 * IO is started, so we don't want to return > 0
@@ -3618,7 +3623,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	u64 start = page_offset(page);
-	u64 page_end = start + PAGE_SIZE - 1;
 	int ret;
 	int nr = 0;
 	size_t pg_offset = 0;
@@ -3661,7 +3665,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
 	if (ret == 1)
 		goto done_unlocked;
-	if (ret)
+	if (ret && !PagePrivate2(page))
 		goto done;
 
 	ret = __extent_writepage_io(inode, page, wbc, epd,
@@ -3675,10 +3679,7 @@ done:
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
index 42f844b..cf55622 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -951,6 +951,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_ordered_extent *ordered;
 	unsigned long page_ops, extent_ops;
 	int ret = 0;
 
@@ -1049,7 +1050,7 @@ static noinline int cow_file_range(struct inode *inode,
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			if (ret)
-				goto out_drop_extent_cache;
+				goto out_remove_ordered_extent;
 		}
 
 		btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
@@ -1078,6 +1079,14 @@ static noinline int cow_file_range(struct inode *inode,
 out:
 	return ret;
 
+out_remove_ordered_extent:
+	ordered = btrfs_lookup_ordered_extent(inode, start);
+	ASSERT(ordered);
+	btrfs_remove_ordered_extent(inode, ordered);
+	/* once for us */
+	btrfs_put_ordered_extent(ordered);
+	/* once for the tree */
+	btrfs_put_ordered_extent(ordered);
 out_drop_extent_cache:
 	btrfs_drop_extent_cache(inode, start, start + ram_size - 1, 0);
 out_reserve:
-- 
2.5.5

