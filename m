Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755649Ab3GYLWw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMmWa027101
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 4/6] Btrfs: batch the extent state operation in the end io handle of the read page
Date: Thu, 25 Jul 2013 19:22:35 +0800
Message-Id: <1374751357-3327-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
References: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, we set the uptodate flag and unlock the extent
by the page size, it is unnecessary, we can do it in batches, it can reduce
the lock contention of the extent state tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- Fix wrong check in clean_io_failure()
---
 fs/btrfs/extent_io.c | 73 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8eccbbc..38fb5dd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -762,15 +762,6 @@ static void cache_state(struct extent_state *state,
 	}
 }
 
-static void uncache_state(struct extent_state **cached_ptr)
-{
-	if (cached_ptr && (*cached_ptr)) {
-		struct extent_state *state = *cached_ptr;
-		*cached_ptr = NULL;
-		free_extent_state(state);
-	}
-}
-
 /*
  * set some bits on a range in the tree.  This may require allocations or
  * sleeping, so the gfp mask is used to indicate what is allowed.
@@ -2115,7 +2106,8 @@ static int clean_io_failure(u64 start, struct page *page)
 					    EXTENT_LOCKED);
 	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
 
-	if (state && state->start == failrec->start) {
+	if (state && state->start <= failrec->start &&
+	    state->end >= failrec->start + failrec->len - 1) {
 		fs_info = BTRFS_I(inode)->root->fs_info;
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
@@ -2394,6 +2386,18 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 	bio_put(bio);
 }
 
+static void
+endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
+			      int uptodate)
+{
+	struct extent_state *cached = NULL;
+	u64 end = start + len - 1;
+
+	if (uptodate && tree->track_uptodate)
+		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
+	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+}
+
 /*
  * after a readpage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2416,6 +2420,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	u64 start;
 	u64 end;
 	u64 len;
+	u64 extent_start = 0;
+	u64 extent_len = 0;
 	int mirror;
 	int ret;
 
@@ -2424,8 +2430,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 	do {
 		struct page *page = bvec->bv_page;
-		struct extent_state *cached = NULL;
-		struct extent_state *state;
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
@@ -2451,17 +2455,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
-		spin_lock(&tree->lock);
-		state = find_first_extent_bit_state(tree, start, EXTENT_LOCKED);
-		if (likely(state && state->start == start)) {
-			/*
-			 * take a reference on the state, unlock will drop
-			 * the ref
-			 */
-			cache_state(state, &cached);
-		}
-		spin_unlock(&tree->lock);
-
 		mirror = io_bio->mirror_num;
 		if (likely(uptodate && tree->ops &&
 			   tree->ops->readpage_end_io_hook)) {
@@ -2500,18 +2493,11 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
-				uncache_state(&cached);
 				continue;
 			}
 		}
 readpage_ok:
-		if (uptodate && tree->track_uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
-		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
-
-		if (uptodate) {
+		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
 			pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 			unsigned offset;
@@ -2527,8 +2513,33 @@ readpage_ok:
 		}
 		unlock_page(page);
 		offset += len;
+
+		if (unlikely(!uptodate)) {
+			if (extent_len) {
+				endio_readpage_release_extent(tree,
+							      extent_start,
+							      extent_len, 1);
+				extent_start = 0;
+				extent_len = 0;
+			}
+			endio_readpage_release_extent(tree, start,
+						      end - start + 1, 0);
+		} else if (!extent_len) {
+			extent_start = start;
+			extent_len = end + 1 - start;
+		} else if (extent_start + extent_len == start) {
+			extent_len += end + 1 - start;
+		} else {
+			endio_readpage_release_extent(tree, extent_start,
+						      extent_len, uptodate);
+			extent_start = start;
+			extent_len = end + 1 - start;
+		}
 	} while (bvec <= bvec_end);
 
+	if (extent_len)
+		endio_readpage_release_extent(tree, extent_start, extent_len,
+					      uptodate);
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
 	bio_put(bio);
-- 
1.8.1.4

