Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:40965 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbeEBFPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 01:15:54 -0400
Received: by mail-lf0-f67.google.com with SMTP id o123-v6so18964275lfe.8
        for <linux-btrfs@vger.kernel.org>; Tue, 01 May 2018 22:15:53 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V3 3/3] Btrfs: btrfs_extent_same() reuse cmp workspace
Date: Wed,  2 May 2018 08:15:38 +0300
Message-Id: <20180502051538.26432-4-nefelim4ag@gmail.com>
In-Reply-To: <20180502051538.26432-1-nefelim4ag@gmail.com>
References: <20180502051538.26432-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We support big dedup requests by split range to several smaller,
and call dedup logic over each of them.

Instead of alloc/dealloc on each, let's reuse allocated memory.

Changes:
  v3:
    - Splited from one to 3 patches

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ioctl.c | 80 +++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 38ce990e9b4c..f2521bc0b069 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2769,8 +2769,6 @@ static void btrfs_cmp_data_free(struct cmp_pages *cmp)
 			put_page(pg);
 		}
 	}
-	kfree(cmp->src_pages);
-	kfree(cmp->dst_pages);
 }
 
 static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
@@ -2779,40 +2777,14 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
 {
 	int ret;
 	int num_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
-	struct page **src_pgarr, **dst_pgarr;
 
-	/*
-	 * We must gather up all the pages before we initiate our
-	 * extent locking. We use an array for the page pointers. Size
-	 * of the array is bounded by len, which is in turn bounded by
-	 * BTRFS_MAX_DEDUPE_LEN.
-	 */
-	src_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
-	dst_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!src_pgarr || !dst_pgarr) {
-		kfree(src_pgarr);
-		kfree(dst_pgarr);
-		return -ENOMEM;
-	}
 	cmp->num_pages = num_pages;
-	cmp->src_pages = src_pgarr;
-	cmp->dst_pages = dst_pgarr;
 
-	/*
-	 * If deduping ranges in the same inode, locking rules make it mandatory
-	 * to always lock pages in ascending order to avoid deadlocks with
-	 * concurrent tasks (such as starting writeback/delalloc).
-	 */
-	if (src == dst && dst_loff < loff) {
-		swap(src_pgarr, dst_pgarr);
-		swap(loff, dst_loff);
-	}
-
-	ret = gather_extent_pages(src, src_pgarr, cmp->num_pages, loff);
+	ret = gather_extent_pages(src, cmp->src_pages, num_pages, loff);
 	if (ret)
 		goto out;
 
-	ret = gather_extent_pages(dst, dst_pgarr, cmp->num_pages, dst_loff);
+	ret = gather_extent_pages(dst, cmp->dst_pages, num_pages, dst_loff);
 
 out:
 	if (ret)
@@ -2883,11 +2855,11 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
 }
 
 static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
-			       struct inode *dst, u64 dst_loff)
+			       struct inode *dst, u64 dst_loff,
+			       struct cmp_pages *cmp)
 {
 	int ret;
 	u64 len = olen;
-	struct cmp_pages cmp;
 	bool same_inode = (src == dst);
 	u64 same_lock_start = 0;
 	u64 same_lock_len = 0;
@@ -2927,7 +2899,7 @@ static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	}
 
 again:
-	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, &cmp);
+	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, cmp);
 	if (ret)
 		return ret;
 
@@ -2950,7 +2922,7 @@ static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		 * Ranges in the io trees already unlocked. Now unlock all
 		 * pages before waiting for all IO to complete.
 		 */
-		btrfs_cmp_data_free(&cmp);
+		btrfs_cmp_data_free(cmp);
 		if (same_inode) {
 			btrfs_wait_ordered_range(src, same_lock_start,
 						 same_lock_len);
@@ -2963,12 +2935,12 @@ static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	ASSERT(ret == 0);
 	if (WARN_ON(ret)) {
 		/* ranges in the io trees already unlocked */
-		btrfs_cmp_data_free(&cmp);
+		btrfs_cmp_data_free(cmp);
 		return ret;
 	}
 
 	/* pass original length for comparison so we stay within i_size */
-	ret = btrfs_cmp_data(olen, &cmp);
+	ret = btrfs_cmp_data(olen, cmp);
 	if (ret == 0)
 		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
 
@@ -2978,7 +2950,7 @@ static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	else
 		btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
 
-	btrfs_cmp_data_free(&cmp);
+	btrfs_cmp_data_free(cmp);
 
 	return ret;
 }
@@ -2989,6 +2961,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
+	struct cmp_pages cmp;
+	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
 	bool same_inode = (src == dst);
 	u64 i, tail_len, chunk_count;
 
@@ -3003,6 +2977,30 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
+	if (chunk_count == 0)
+		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
+
+	/*
+	 * If deduping ranges in the same inode, locking rules make it mandatory
+	 * to always lock pages in ascending order to avoid deadlocks with
+	 * concurrent tasks (such as starting writeback/delalloc).
+	 */
+	if (same_inode && dst_loff < loff)
+		swap(loff, dst_loff);
+
+	/*
+	 * We must gather up all the pages before we initiate our
+	 * extent locking. We use an array for the page pointers. Size
+	 * of the array is bounded by len, which is in turn bounded by
+	 * BTRFS_MAX_DEDUPE_LEN.
+	 */
+	cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!cmp.src_pages || !cmp.dst_pages) {
+		kfree(cmp.src_pages);
+		kfree(cmp.dst_pages);
+		return -ENOMEM;
+	}
 
 	if (same_inode)
 		inode_lock(src);
@@ -3011,7 +3009,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	for (i = 0; i < chunk_count; i++) {
 		ret = __btrfs_extent_same(src, loff, BTRFS_MAX_DEDUPE_LEN,
-					  dst, dst_loff);
+					  dst, dst_loff, &cmp);
 		if (ret)
 			goto out;
 
@@ -3020,7 +3018,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	}
 
 	if (tail_len > 0)
-		ret = __btrfs_extent_same(src, loff, tail_len, dst, dst_loff);
+		ret = __btrfs_extent_same(src, loff, tail_len,
+					  dst, dst_loff, &cmp);
 
 out:
 	if (same_inode)
@@ -3028,6 +3027,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	else
 		btrfs_double_inode_unlock(src, dst);
 
+	kfree(cmp.src_pages);
+	kfree(cmp.dst_pages);
+
 	return ret;
 }
 
-- 
2.17.0
