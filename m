Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab3GYLWx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMlhg027098
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 6/6] Btrfs: cache the extent map struct when reading several pages
Date: Thu, 25 Jul 2013 19:22:37 +0800
Message-Id: <1374751357-3327-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
References: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we read several pages at once, we needn't get the extent map object
every time we deal with a page, and we can cache the extent map object.
So, we can reduce the search time of the extent map, and besides that, we
also can reduce the lock contention of the extent map tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch
---
 fs/btrfs/extent_io.c | 57 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 53a1828..2e6dfeb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2721,6 +2721,33 @@ void set_page_extent_mapped(struct page *page)
 	}
 }
 
+static struct extent_map *
+__get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
+		 u64 start, u64 len, get_extent_t *get_extent,
+		 struct extent_map **em_cached)
+{
+	struct extent_map *em;
+
+	if (em_cached && *em_cached) {
+		em = *em_cached;
+		if (em->in_tree && start >= em->start &&
+		    start < extent_map_end(em)) {
+			atomic_inc(&em->refs);
+			return em;
+		}
+
+		free_extent_map(em);
+		*em_cached = NULL;
+	}
+
+	em = get_extent(inode, page, pg_offset, start, len, 0);
+	if (em_cached && !IS_ERR_OR_NULL(em)) {
+		BUG_ON(*em_cached);
+		atomic_inc(&em->refs);
+		*em_cached = em;
+	}
+	return em;
+}
 /*
  * basic readpage implementation.  Locked extent state structs are inserted
  * into the tree that are removed when the IO is done (by the end_io
@@ -2730,6 +2757,7 @@ void set_page_extent_mapped(struct page *page)
 static int __do_readpage(struct extent_io_tree *tree,
 			 struct page *page,
 			 get_extent_t *get_extent,
+			 struct extent_map **em_cached,
 			 struct bio **bio, int mirror_num,
 			 unsigned long *bio_flags, int rw)
 {
@@ -2794,8 +2822,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 					     &cached, GFP_NOFS);
 			break;
 		}
-		em = get_extent(inode, page, pg_offset, cur,
-				end - cur + 1, 0);
+		em = __get_extent_map(inode, page, pg_offset, cur,
+				      end - cur + 1, get_extent, em_cached);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
 			unlock_extent(tree, cur, end);
@@ -2896,6 +2924,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     struct page *pages[], int nr_pages,
 					     u64 start, u64 end,
 					     get_extent_t *get_extent,
+					     struct extent_map **em_cached,
 					     struct bio **bio, int mirror_num,
 					     unsigned long *bio_flags, int rw)
 {
@@ -2916,8 +2945,8 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 	}
 
 	for (index = 0; index < nr_pages; index++) {
-		__do_readpage(tree, pages[index], get_extent, bio, mirror_num,
-			      bio_flags, rw);
+		__do_readpage(tree, pages[index], get_extent, em_cached, bio,
+			      mirror_num, bio_flags, rw);
 		page_cache_release(pages[index]);
 	}
 }
@@ -2925,6 +2954,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 static void __extent_readpages(struct extent_io_tree *tree,
 			       struct page *pages[],
 			       int nr_pages, get_extent_t *get_extent,
+			       struct extent_map **em_cached,
 			       struct bio **bio, int mirror_num,
 			       unsigned long *bio_flags, int rw)
 {
@@ -2945,8 +2975,9 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		} else {
 			__do_contiguous_readpages(tree, &pages[first_index],
 						  index - first_index, start,
-						  end, get_extent, bio,
-						  mirror_num, bio_flags, rw);
+						  end, get_extent, em_cached,
+						  bio, mirror_num, bio_flags,
+						  rw);
 			start = page_start;
 			end = start + PAGE_CACHE_SIZE - 1;
 			first_index = index;
@@ -2956,7 +2987,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 	if (end)
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
-					  end, get_extent, bio,
+					  end, get_extent, em_cached, bio,
 					  mirror_num, bio_flags, rw);
 }
 
@@ -2982,8 +3013,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		btrfs_put_ordered_extent(ordered);
 	}
 
-	ret = __do_readpage(tree, page, get_extent, bio, mirror_num, bio_flags,
-			    rw);
+	ret = __do_readpage(tree, page, get_extent, NULL, bio, mirror_num,
+			    bio_flags, rw);
 	return ret;
 }
 
@@ -3837,6 +3868,7 @@ int extent_readpages(struct extent_io_tree *tree,
 	unsigned long bio_flags = 0;
 	struct page *pagepool[16];
 	struct page *page;
+	struct extent_map *em_cached = NULL;
 	int nr = 0;
 
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
@@ -3853,14 +3885,17 @@ int extent_readpages(struct extent_io_tree *tree,
 		pagepool[nr++] = page;
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
-		__extent_readpages(tree, pagepool, nr, get_extent,
+		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
 				   &bio, 0, &bio_flags, READ);
 		nr = 0;
 	}
 	if (nr)
-		__extent_readpages(tree, pagepool, nr, get_extent,
+		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
 				   &bio, 0, &bio_flags, READ);
 
+	if (em_cached)
+		free_extent_map(em_cached);
+
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		return submit_one_bio(READ, bio, 0, bio_flags);
-- 
1.8.1.4

