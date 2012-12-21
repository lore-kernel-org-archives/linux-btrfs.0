Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LUJRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 04:17:17 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBL9IvYT026252
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 17:18:57 +0800
Message-ID: <50D42939.7010306@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 17:17:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/3] Btrfs: use wrapper page_offset
References: <50D2F45E.2060305@cn.fujitsu.com> <20121220193319.GB9195@lenny.home.zabbo.net>
In-Reply-To: <20121220193319.GB9195@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use wrapper page_offset to get byte-offset into filesystem object for page.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c    |  2 +-
 fs/btrfs/extent_io.c  | 24 +++++++++++-------------
 fs/btrfs/inode.c      |  5 ++---
 fs/btrfs/relocation.c |  2 +-
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65f0367..e045203 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -420,7 +420,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
 	struct extent_io_tree *tree;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..bda36fe 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1834,7 +1834,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  */
 static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
@@ -1846,7 +1846,7 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
  */
 static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
 		unlock_page(page);
@@ -1960,7 +1960,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	}
 	bio->bi_bdev = dev->bdev;
-	bio_add_page(bio, page, length, start-page_offset(page));
+	bio_add_page(bio, page, length, start - page_offset(page));
 	btrfsic_submit_bio(WRITE_SYNC, bio);
 	wait_for_completion(&compl);
 
@@ -2293,8 +2293,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		struct page *page = bvec->bv_page;
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
-			 bvec->bv_offset;
+		start = page_offset(page) + bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
 
 		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
@@ -2353,8 +2352,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 (long int)bio->bi_bdev);
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
-			bvec->bv_offset;
+		start = page_offset(page) + bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
 
 		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
@@ -2471,7 +2469,7 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = ((u64)page->index << PAGE_CACHE_SHIFT) + bvec->bv_offset;
+	start = page_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
 
@@ -2595,7 +2593,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   unsigned long *bio_flags)
 {
 	struct inode *inode = page->mapping->host;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
 	u64 cur = start;
@@ -2806,7 +2804,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	struct inode *inode = page->mapping->host;
 	struct extent_page_data *epd = data;
 	struct extent_io_tree *tree = epd->tree;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 delalloc_start;
 	u64 page_end = start + PAGE_CACHE_SIZE - 1;
 	u64 end;
@@ -3674,7 +3672,7 @@ int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset)
 {
 	struct extent_state *cached_state = NULL;
-	u64 start = ((u64)page->index << PAGE_CACHE_SHIFT);
+	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	size_t blocksize = page->mapping->host->i_sb->s_blocksize;
 
@@ -3700,7 +3698,7 @@ int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask)
 {
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	int ret = 1;
 
@@ -3739,7 +3737,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			       gfp_t mask)
 {
 	struct extent_map *em;
-	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
+	u64 start = page_offset(page);
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 
 	if ((mask & __GFP_WAIT) &&
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..0eea4f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2062,7 +2062,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state, int mirror)
 {
-	size_t offset = start - ((u64)page->index << PAGE_CACHE_SHIFT);
+	size_t offset = start - page_offset(page);
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	char *kaddr;
@@ -6695,8 +6695,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned long offset)
 		return;
 	}
 	lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
-	ordered = btrfs_lookup_ordered_extent(inode,
-					   page_offset(page));
+	ordered = btrfs_lookup_ordered_extent(inode, page_offset(page));
 	if (ordered) {
 		/*
 		 * IO on this page will never be started, so we need
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 300e09a..ba5a321 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3017,7 +3017,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			}
 		}
 
-		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
+		page_start = page_offset(page);
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 
 		lock_extent(&BTRFS_I(inode)->io_tree, page_start, page_end);
-- 
1.7.11.7

