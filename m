Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2GYF7n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 01:59:43 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6P5xWH2005253
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:59:42 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6 v3][RFC] Btrfs: batch merge state in readpage endio
Date: Wed, 25 Jul 2012 13:58:41 +0800
Message-Id: <1343195922-31405-6-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the first part of parallel endio for read.

The main idea behind it is that in theory we can gain a lot of performance
if we are able to reduce the write locks taken at endio time.

Here we batch the merge state part in unlocking extent state and we don't
need to touch the tree, which means that we don't need to acquire the write
locks unless we start to process batched merges.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   37 ++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.h |    1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 842a4e5..d91821b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -643,6 +643,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *node;
 	u64 last_end;
 	u64 orig_start = start;
+	int orig_bits = bits;
 	int err;
 	int clear = 0;
 	int rw = EXTENT_READ;
@@ -802,8 +803,13 @@ out:
 	extent_rw_unlock(tree, &rw);
 	if (prealloc)
 		free_extent_state(prealloc);
-	if (merge)
-		process_merge_state(tree, orig_start);
+
+	if (merge) {
+		if (orig_bits & EXTENT_NOMERGE)
+			return merge;
+		else
+			process_merge_state(tree, orig_start);
+	}
 
 	return 0;
 
@@ -1481,6 +1487,15 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 				mask);
 }
 
+int unlock_extent_cached_nomerge(struct extent_io_tree *tree, u64 start,
+				 u64 end, struct extent_state **cached,
+				 gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end,
+				EXTENT_LOCKED | EXTENT_NOMERGE,
+				1, 0, cached, mask);
+}
+
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
@@ -2560,21 +2575,25 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
-	struct extent_io_tree *tree;
+	struct extent_io_tree *tree = NULL;
+	struct page *page = NULL;
 	u64 start;
 	u64 end;
+	u64 range_start = (u64)-1;
+	u64 range_end = 0;
 	int whole_page;
 	int mirror;
 	int ret;
+	bool merge = false;
 
 	if (err)
 		uptodate = 0;
 
 	do {
-		struct page *page = bvec->bv_page;
 		struct extent_state *cached = NULL;
 		struct extent_state *state;
 
+		page = bvec->bv_page;
 		pr_debug("end_bio_extent_readpage: bi_vcnt=%d, idx=%d, err=%d, "
 			 "mirror=%ld\n", bio->bi_vcnt, bio->bi_idx, err,
 			 (long int)bio->bi_bdev);
@@ -2583,6 +2602,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
 			bvec->bv_offset;
 		end = start + bvec->bv_len - 1;
+		range_start = min(start, range_start);
+		range_end = max(end, range_end);
 
 		if (bvec->bv_offset == 0 && bvec->bv_len == PAGE_CACHE_SIZE)
 			whole_page = 1;
@@ -2657,7 +2678,10 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+		ret = unlock_extent_cached_nomerge(tree, start, end,
+						   &cached, GFP_ATOMIC);
+		if (ret && merge == false)
+			merge = true;
 
 		if (whole_page) {
 			if (uptodate) {
@@ -2678,6 +2702,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		}
 	} while (bvec <= bvec_end);
 
+	if (merge && tree && range_start < (u64)-1)
+		process_merge_state(tree, range_start);
+
 	bio_put(bio);
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bf403f2..86a310c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,7 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_NOMERGE (1 << 15)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
-- 
1.6.5.2

