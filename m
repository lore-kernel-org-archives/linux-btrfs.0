Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab2FNIQJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:09 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/10] Btrfs: use wrapper page_offset
Date: Thu, 14 Jun 2012 16:23:26 +0800
Message-Id: <1339662206-5307-11-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use wrapper page_offset to get byte-offset into filesystem object for page.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c    |    2 +-
 fs/btrfs/extent_io.c  |   20 ++++++++++----------
 fs/btrfs/inode.c      |    2 +-
 fs/btrfs/relocation.c |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d16f4ce..97f4837 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -420,7 +420,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
 	struct extent_io_tree *tree;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2c8f7b2..6afbcf1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1780,7 +1780,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  */
 static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
@@ -1792,7 +1792,7 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
  */
 static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
 		unlock_page(page);
@@ -2241,7 +2241,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		struct page *page = bvec->bv_page;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
+		start = ((u64)page_offset(page)) +
 			 bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
 
@@ -2301,7 +2301,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 (long int)bio->bi_bdev);
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
+		start = ((u64)page_offset(page)) +
 			bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
 
@@ -2436,7 +2436,7 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = ((u64)page->index << PAGE_CACHE_SHIFT) + bvec->bv_offset;
+	start = ((u64)page_offset(page)) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
 
@@ -2560,7 +2560,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   unsigned long *bio_flags)
 {
 	struct inode *inode = page->mapping->host;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
@@ -2768,7 +2768,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	struct extent_io_tree *tree = epd->tree;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 delalloc_start;
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
@@ -3570,7 +3570,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset)
 {
 	struct extent_state *cached_state = NULL;
-	u64 start = ((u64)page->index << PAGE_CACHE_SHIFT);
+	u64 start = (u64)page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
 
@@ -3596,7 +3596,7 @@ int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	int ret = 1;
 
@@ -3635,7 +3635,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			       gfp_t mask)
 {
 	struct extent_map *em;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = (u64)page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 
 	if ((mask & __GFP_WAIT) &&
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index da2fd8e..94e23da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1984,7 +1984,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state, int mirror)
 {
-	size_t offset = start - ((u64)page->index << PAGE_CACHE_SHIFT);
+	size_t offset = start - ((u64)page_offset(page));
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	char *kaddr;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 646ee21..60bb8e1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3016,7 +3016,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			}
 		}
 
-		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
+		page_start = (u64)page_offset(page);
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 		lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
-- 
1.6.5.2

