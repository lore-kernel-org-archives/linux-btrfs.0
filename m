Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3GKF1F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 01:27:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6B5R10W001059
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 13:27:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: batch the extent state operation in the end io handle of the read page
Date: Thu, 11 Jul 2013 13:25:39 +0800
Message-Id: <1373520339-13870-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is unnecessary to unlock the extent by the page size, we can do it
in batches, it makes the random read be faster by ~6%.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 70 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9f4dedf..8f95418 100644
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
@@ -2395,6 +2386,18 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
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
@@ -2417,6 +2420,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	u64 start;
 	u64 end;
 	u64 len;
+	u64 extent_start = 0;
+	u64 extent_len = 0;
 	int mirror;
 	int ret;
 
@@ -2425,8 +2430,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 	do {
 		struct page *page = bvec->bv_page;
-		struct extent_state *cached = NULL;
-		struct extent_state *state;
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
@@ -2452,17 +2455,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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
@@ -2501,18 +2493,11 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
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
@@ -2528,8 +2513,33 @@ readpage_ok:
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

