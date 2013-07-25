Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab3GYLWy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:54 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMmic027104
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 5/6] Btrfs: batch the extent state operation when reading pages
Date: Thu, 25 Jul 2013 19:22:36 +0800
Message-Id: <1374751357-3327-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
References: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the past, we cached the checksum value in the extent state object, so we
had to split the extent state object by the block size, or we had no space
to keep this checksum value. But it increased the lock contention of the
extent state tree.

Now we removed this limit by caching the checksum into the bio object, so
it is unnecessary to do the extent state operations by the block size, we
can do it in batches, in this way, we can reduce the lock contention of
the extent state tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch
---
 fs/btrfs/extent_io.c | 135 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 107 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 38fb5dd..53a1828 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2727,11 +2727,11 @@ void set_page_extent_mapped(struct page *page)
  * handlers)
  * XXX JDM: This needs looking at to ensure proper page locking
  */
-static int __extent_read_full_page(struct extent_io_tree *tree,
-				   struct page *page,
-				   get_extent_t *get_extent,
-				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags, int rw)
+static int __do_readpage(struct extent_io_tree *tree,
+			 struct page *page,
+			 get_extent_t *get_extent,
+			 struct bio **bio, int mirror_num,
+			 unsigned long *bio_flags, int rw)
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = page_offset(page);
@@ -2745,7 +2745,6 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	sector_t sector;
 	struct extent_map *em;
 	struct block_device *bdev;
-	struct btrfs_ordered_extent *ordered;
 	int ret;
 	int nr = 0;
 	size_t pg_offset = 0;
@@ -2756,24 +2755,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	set_page_extent_mapped(page);
 
+	end = page_end;
 	if (!PageUptodate(page)) {
 		if (cleancache_get_page(page) == 0) {
 			BUG_ON(blocksize != PAGE_SIZE);
+			unlock_extent(tree, start, end);
 			goto out;
 		}
 	}
 
-	end = page_end;
-	while (1) {
-		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_extent(inode, start);
-		if (!ordered)
-			break;
-		unlock_extent(tree, start, end);
-		btrfs_start_ordered_extent(inode, ordered, 1);
-		btrfs_put_ordered_extent(ordered);
-	}
-
 	if (page->index == last_byte >> PAGE_CACHE_SHIFT) {
 		char *userpage;
 		size_t zero_offset = last_byte & (PAGE_CACHE_SIZE - 1);
@@ -2902,6 +2892,101 @@ out:
 	return 0;
 }
 
+static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
+					     struct page *pages[], int nr_pages,
+					     u64 start, u64 end,
+					     get_extent_t *get_extent,
+					     struct bio **bio, int mirror_num,
+					     unsigned long *bio_flags, int rw)
+{
+	struct inode *inode;
+	struct btrfs_ordered_extent *ordered;
+	int index;
+
+	inode = pages[0]->mapping->host;
+	while (1) {
+		lock_extent(tree, start, end);
+		ordered = btrfs_lookup_ordered_range(inode, start,
+						     end - start + 1);
+		if (!ordered)
+			break;
+		unlock_extent(tree, start, end);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
+
+	for (index = 0; index < nr_pages; index++) {
+		__do_readpage(tree, pages[index], get_extent, bio, mirror_num,
+			      bio_flags, rw);
+		page_cache_release(pages[index]);
+	}
+}
+
+static void __extent_readpages(struct extent_io_tree *tree,
+			       struct page *pages[],
+			       int nr_pages, get_extent_t *get_extent,
+			       struct bio **bio, int mirror_num,
+			       unsigned long *bio_flags, int rw)
+{
+	u64 start;
+	u64 end = 0;
+	u64 page_start;
+	int index;
+	int first_index;
+
+	for (index = 0; index < nr_pages; index++) {
+		page_start = page_offset(pages[index]);
+		if (!end) {
+			start = page_start;
+			end = start + PAGE_CACHE_SIZE - 1;
+			first_index = index;
+		} else if (end + 1 == page_start) {
+			end += PAGE_CACHE_SIZE;
+		} else {
+			__do_contiguous_readpages(tree, &pages[first_index],
+						  index - first_index, start,
+						  end, get_extent, bio,
+						  mirror_num, bio_flags, rw);
+			start = page_start;
+			end = start + PAGE_CACHE_SIZE - 1;
+			first_index = index;
+		}
+	}
+
+	if (end)
+		__do_contiguous_readpages(tree, &pages[first_index],
+					  index - first_index, start,
+					  end, get_extent, bio,
+					  mirror_num, bio_flags, rw);
+}
+
+static int __extent_read_full_page(struct extent_io_tree *tree,
+				   struct page *page,
+				   get_extent_t *get_extent,
+				   struct bio **bio, int mirror_num,
+				   unsigned long *bio_flags, int rw)
+{
+	struct inode *inode = page->mapping->host;
+	struct btrfs_ordered_extent *ordered;
+	u64 start = page_offset(page);
+	u64 end = start + PAGE_CACHE_SIZE - 1;
+	int ret;
+
+	while (1) {
+		lock_extent(tree, start, end);
+		ordered = btrfs_lookup_ordered_extent(inode, start);
+		if (!ordered)
+			break;
+		unlock_extent(tree, start, end);
+		btrfs_start_ordered_extent(inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+	}
+
+	ret = __do_readpage(tree, page, get_extent, bio, mirror_num, bio_flags,
+			    rw);
+	return ret;
+}
+
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			    get_extent_t *get_extent, int mirror_num)
 {
@@ -3752,7 +3837,6 @@ int extent_readpages(struct extent_io_tree *tree,
 	unsigned long bio_flags = 0;
 	struct page *pagepool[16];
 	struct page *page;
-	int i = 0;
 	int nr = 0;
 
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
@@ -3769,18 +3853,13 @@ int extent_readpages(struct extent_io_tree *tree,
 		pagepool[nr++] = page;
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
-		for (i = 0; i < nr; i++) {
-			__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags, READ);
-			page_cache_release(pagepool[i]);
-		}
+		__extent_readpages(tree, pagepool, nr, get_extent,
+				   &bio, 0, &bio_flags, READ);
 		nr = 0;
 	}
-	for (i = 0; i < nr; i++) {
-		__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags, READ);
-		page_cache_release(pagepool[i]);
-	}
+	if (nr)
+		__extent_readpages(tree, pagepool, nr, get_extent,
+				   &bio, 0, &bio_flags, READ);
 
 	BUG_ON(!list_empty(pages));
 	if (bio)
-- 
1.8.1.4

