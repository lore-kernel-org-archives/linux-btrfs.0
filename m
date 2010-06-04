From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: [PATCH] btrfs: use zero_user family instead of writing down the
 same sequence repeatedly
Date: Fri, 4 Jun 2010 17:14:48 +0900
Message-ID: <20100604171448.4f1e2dbe.yoshikawa.takuya@oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	takuya.yoshikawa@gmail.com
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As other filesystems do, btrfs can use zero_user family.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 fs/btrfs/compression.c |   12 +++---------
 fs/btrfs/extent_io.c   |   44 ++++++++------------------------------------
 2 files changed, 11 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 396039b..12aded9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -512,17 +512,11 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		free_extent_map(em);
 
 		if (page->index == end_index) {
-			char *userpage;
 			size_t zero_offset = isize & (PAGE_CACHE_SIZE - 1);
 
-			if (zero_offset) {
-				int zeros;
-				zeros = PAGE_CACHE_SIZE - zero_offset;
-				userpage = kmap_atomic(page, KM_USER0);
-				memset(userpage + zero_offset, 0, zeros);
-				flush_dcache_page(page);
-				kunmap_atomic(userpage, KM_USER0);
-			}
+			if (zero_offset)
+				zero_user_segment(page, zero_offset,
+						  PAGE_CACHE_SIZE);
 		}
 
 		ret = bio_add_page(cb->orig_bio, page,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a4080c2..15dce48 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2039,25 +2039,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	}
 
 	if (page->index == last_byte >> PAGE_CACHE_SHIFT) {
-		char *userpage;
 		size_t zero_offset = last_byte & (PAGE_CACHE_SIZE - 1);
 
-		if (zero_offset) {
-			iosize = PAGE_CACHE_SIZE - zero_offset;
-			userpage = kmap_atomic(page, KM_USER0);
-			memset(userpage + zero_offset, 0, iosize);
-			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
-		}
+		if (zero_offset)
+			zero_user_segment(page, zero_offset, PAGE_CACHE_SIZE);
 	}
 	while (cur <= end) {
 		if (cur >= last_byte) {
-			char *userpage;
 			iosize = PAGE_CACHE_SIZE - page_offset;
-			userpage = kmap_atomic(page, KM_USER0);
-			memset(userpage + page_offset, 0, iosize);
-			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			zero_user(page, page_offset, iosize);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    GFP_NOFS);
 			unlock_extent(tree, cur, cur + iosize - 1, GFP_NOFS);
@@ -2096,11 +2086,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 		/* we've found a hole, just zero and go on */
 		if (block_start == EXTENT_MAP_HOLE) {
-			char *userpage;
-			userpage = kmap_atomic(page, KM_USER0);
-			memset(userpage + page_offset, 0, iosize);
-			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			zero_user(page, page_offset, iosize);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    GFP_NOFS);
@@ -2236,15 +2222,9 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		return 0;
 	}
 
-	if (page->index == end_index) {
-		char *userpage;
+	if (page->index == end_index)
+		zero_user_segment(page, pg_offset, PAGE_CACHE_SIZE);
 
-		userpage = kmap_atomic(page, KM_USER0);
-		memset(userpage + pg_offset, 0,
-		       PAGE_CACHE_SIZE - pg_offset);
-		kunmap_atomic(userpage, KM_USER0);
-		flush_dcache_page(page);
-	}
 	pg_offset = 0;
 
 	set_page_extent_mapped(page);
@@ -2789,16 +2769,8 @@ int extent_prepare_write(struct extent_io_tree *tree,
 
 		if (!PageUptodate(page) && isnew &&
 		    (block_off_end > to || block_off_start < from)) {
-			void *kaddr;
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_off_end > to)
-				memset(kaddr + to, 0, block_off_end - to);
-			if (block_off_start < from)
-				memset(kaddr + block_off_start, 0,
-				       from - block_off_start);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_segments(page, to, block_off_end,
+					   block_off_start, from);
 		}
 		if ((em->block_start != EXTENT_MAP_HOLE &&
 		     em->block_start != EXTENT_MAP_INLINE) &&
-- 
1.6.3.3
