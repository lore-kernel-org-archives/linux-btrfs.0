Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35160 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdBCBuQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 20:50:16 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] Btrfs: use helper to simplify lock/unlock pages
Date: Thu,  2 Feb 2017 17:49:23 -0800
Message-Id: <1486086563-25543-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
References: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have a helper to set page bits, let lock_delalloc_pages and
__unlock_for_delalloc use it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 122 ++++++++++++++++++++++-----------------------------
 fs/btrfs/extent_io.h |   3 +-
 2 files changed, 54 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2ef2d05..7e9639f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1549,33 +1549,24 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	return found;
 }
 
+static int __process_pages_contig(struct address_space *mapping,
+				  struct page *locked_page,
+				  pgoff_t start_index, pgoff_t end_index,
+				  unsigned long page_ops, pgoff_t *index_ret);
+
 static noinline void __unlock_for_delalloc(struct inode *inode,
 					   struct page *locked_page,
 					   u64 start, u64 end)
 {
-	int ret;
-	struct page *pages[16];
 	unsigned long index = start >> PAGE_SHIFT;
 	unsigned long end_index = end >> PAGE_SHIFT;
-	unsigned long nr_pages = end_index - index + 1;
-	int i;
 
+	ASSERT(locked_page);
 	if (index == locked_page->index && end_index == index)
 		return;
 
-	while (nr_pages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long, nr_pages,
-				     ARRAY_SIZE(pages)), pages);
-		for (i = 0; i < ret; i++) {
-			if (pages[i] != locked_page)
-				unlock_page(pages[i]);
-			put_page(pages[i]);
-		}
-		nr_pages -= ret;
-		index += ret;
-		cond_resched();
-	}
+	__process_pages_contig(inode->i_mapping, locked_page, index, end_index,
+			       PAGE_UNLOCK, NULL);
 }
 
 static noinline int lock_delalloc_pages(struct inode *inode,
@@ -1584,59 +1575,19 @@ static noinline int lock_delalloc_pages(struct inode *inode,
 					u64 delalloc_end)
 {
 	unsigned long index = delalloc_start >> PAGE_SHIFT;
-	unsigned long start_index = index;
+	unsigned long index_ret = index;
 	unsigned long end_index = delalloc_end >> PAGE_SHIFT;
-	unsigned long pages_locked = 0;
-	struct page *pages[16];
-	unsigned long nrpages;
 	int ret;
-	int i;
 
-	/* the caller is responsible for locking the start index */
+	ASSERT(locked_page);
 	if (index == locked_page->index && index == end_index)
 		return 0;
 
-	/* skip the page at the start index */
-	nrpages = end_index - index + 1;
-	while (nrpages > 0) {
-		ret = find_get_pages_contig(inode->i_mapping, index,
-				     min_t(unsigned long,
-				     nrpages, ARRAY_SIZE(pages)), pages);
-		if (ret == 0) {
-			ret = -EAGAIN;
-			goto done;
-		}
-		/* now we have an array of pages, lock them all */
-		for (i = 0; i < ret; i++) {
-			/*
-			 * the caller is taking responsibility for
-			 * locked_page
-			 */
-			if (pages[i] != locked_page) {
-				lock_page(pages[i]);
-				if (!PageDirty(pages[i]) ||
-				    pages[i]->mapping != inode->i_mapping) {
-					ret = -EAGAIN;
-					unlock_page(pages[i]);
-					put_page(pages[i]);
-					goto done;
-				}
-			}
-			put_page(pages[i]);
-			pages_locked++;
-		}
-		nrpages -= ret;
-		index += ret;
-		cond_resched();
-	}
-	ret = 0;
-done:
-	if (ret && pages_locked) {
-		__unlock_for_delalloc(inode, locked_page,
-			      delalloc_start,
-			      ((u64)(start_index + pages_locked - 1)) <<
-			      PAGE_SHIFT);
-	}
+	ret = __process_pages_contig(inode->i_mapping, locked_page, index,
+				     end_index, PAGE_LOCK, &index_ret);
+	if (ret == -EAGAIN)
+		__unlock_for_delalloc(inode, locked_page, delalloc_start,
+				      (u64)index_ret << PAGE_SHIFT);
 	return ret;
 }
 
@@ -1726,17 +1677,24 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 	return found;
 }
 
-static void __process_pages_contig(struct address_space *mapping,
-				   struct page *locked_page,
-				   pgoff_t start_index, pgoff_t end_index,
-				   unsigned long page_ops)
+static int __process_pages_contig(struct address_space *mapping,
+				  struct page *locked_page,
+				  pgoff_t start_index, pgoff_t end_index,
+				  unsigned long page_ops, pgoff_t *index_ret)
 {
 	unsigned long nr_pages = end_index - start_index + 1;
+	unsigned long pages_locked = 0;
 	pgoff_t index = start_index;
 	struct page *pages[16];
 	unsigned ret;
+	int err = 0;
 	int i;
 
+	if (page_ops & PAGE_LOCK) {
+		ASSERT(page_ops == PAGE_LOCK);
+		ASSERT(index_ret && *index_ret == start_index);
+	}
+
 	if ((page_ops & PAGE_SET_ERROR) && nr_pages > 0)
 		mapping_set_error(mapping, -EIO);
 
@@ -1744,13 +1702,22 @@ static void __process_pages_contig(struct address_space *mapping,
 		ret = find_get_pages_contig(mapping, index,
 				     min_t(unsigned long,
 				     nr_pages, ARRAY_SIZE(pages)), pages);
-		for (i = 0; i < ret; i++) {
+		if (ret == 0) {
+			/*
+			 * Only if we're going to lock these pages,
+			 * can we find nothing at @index.
+			 */
+			ASSERT(page_ops & PAGE_LOCK);
+			return ret;
+		}
 
+		for (i = 0; i < ret; i++) {
 			if (page_ops & PAGE_SET_PRIVATE2)
 				SetPagePrivate2(pages[i]);
 
 			if (pages[i] == locked_page) {
 				put_page(pages[i]);
+				pages_locked++;
 				continue;
 			}
 			if (page_ops & PAGE_CLEAR_DIRTY)
@@ -1763,12 +1730,27 @@ static void __process_pages_contig(struct address_space *mapping,
 				end_page_writeback(pages[i]);
 			if (page_ops & PAGE_UNLOCK)
 				unlock_page(pages[i]);
+			if (page_ops & PAGE_LOCK) {
+				lock_page(pages[i]);
+				if (!PageDirty(pages[i]) ||
+				    pages[i]->mapping != mapping) {
+					unlock_page(pages[i]);
+					put_page(pages[i]);
+					err = -EAGAIN;
+					goto out;
+				}
+			}
 			put_page(pages[i]);
+			pages_locked++;
 		}
 		nr_pages -= ret;
 		index += ret;
 		cond_resched();
 	}
+out:
+	if (err && index_ret)
+		*index_ret = start_index + pages_locked - 1;
+	return err;
 }
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
@@ -1781,7 +1763,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 
 	__process_pages_contig(inode->i_mapping, locked_page,
 			       start >> PAGE_SHIFT, end >> PAGE_SHIFT,
-			       page_ops);
+			       page_ops, NULL);
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 17f9ce4..4551a5b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -45,13 +45,14 @@
 #define EXTENT_BUFFER_IN_TREE 10
 #define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
 
-/* these are flags for extent_clear_unlock_delalloc */
+/* these are flags for __process_pages_contig */
 #define PAGE_UNLOCK		(1 << 0)
 #define PAGE_CLEAR_DIRTY	(1 << 1)
 #define PAGE_SET_WRITEBACK	(1 << 2)
 #define PAGE_END_WRITEBACK	(1 << 3)
 #define PAGE_SET_PRIVATE2	(1 << 4)
 #define PAGE_SET_ERROR		(1 << 5)
+#define PAGE_LOCK		(1 << 6)
 
 /*
  * page->private values.  Every page that is controlled by the extent
-- 
2.5.5

