Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62517 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaKQKh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:27 -0500
Received: by mail-pd0-f171.google.com with SMTP id r10so20930726pdi.16
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:26 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 5/6] btrfs: don't mark extents used for swap as up to date
Date: Mon, 17 Nov 2014 02:36:58 -0800
Message-Id: <3d52b4347781b2e0e766989bab1df21aa736c753.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As pages in the swapcache get shuffled around and repurposed for different
pages in the swap file, the EXTENT_UPTODATE flag doesn't apply. This leads to
some really weird symptoms in userspace where pages in a process's address
space appear to get mixed up.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/extent_io.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b8dc256..ca696d5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2496,12 +2496,12 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 
 static void
 endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
-			      int uptodate)
+			      int uptodate, int swapcache)
 {
 	struct extent_state *cached = NULL;
 	u64 end = start + len - 1;
 
-	if (uptodate && tree->track_uptodate)
+	if (likely(!swapcache) && uptodate && tree->track_uptodate)
 		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
 	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 }
@@ -2532,6 +2532,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	int mirror;
 	int ret;
 	int i;
+	int swapcache = 0;
 
 	if (err)
 		uptodate = 0;
@@ -2539,6 +2540,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page_file_mapping(page)->host;
+		swapcache |= PageSwapCache(page);
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
@@ -2631,12 +2633,14 @@ readpage_ok:
 			if (extent_len) {
 				endio_readpage_release_extent(tree,
 							      extent_start,
-							      extent_len, 1);
+							      extent_len, 1,
+							      swapcache);
 				extent_start = 0;
 				extent_len = 0;
 			}
 			endio_readpage_release_extent(tree, start,
-						      end - start + 1, 0);
+						      end - start + 1, 0,
+						      swapcache);
 		} else if (!extent_len) {
 			extent_start = start;
 			extent_len = end + 1 - start;
@@ -2644,7 +2648,8 @@ readpage_ok:
 			extent_len += end + 1 - start;
 		} else {
 			endio_readpage_release_extent(tree, extent_start,
-						      extent_len, uptodate);
+						      extent_len, uptodate,
+						      swapcache);
 			extent_start = start;
 			extent_len = end + 1 - start;
 		}
@@ -2652,7 +2657,7 @@ readpage_ok:
 
 	if (extent_len)
 		endio_readpage_release_extent(tree, extent_start, extent_len,
-					      uptodate);
+					      uptodate, swapcache);
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
 	bio_put(bio);
@@ -2942,8 +2947,10 @@ static int __do_readpage(struct extent_io_tree *tree,
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			if (likely(!swapcache))
+				set_extent_uptodate(tree, cur,
+						    cur + iosize - 1,
+						    &cached, GFP_NOFS);
 			if (!parent_locked)
 				unlock_extent_cached(tree, cur,
 						     cur + iosize - 1,
@@ -2995,8 +3002,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
 
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			if (likely(!swapcache))
+				set_extent_uptodate(tree, cur, cur + iosize - 1,
+						    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 			                     &cached, GFP_NOFS);
 			cur = cur + iosize;
@@ -3006,6 +3014,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 		/* the get_extent function already copied into the page */
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
+			WARN_ON(swapcache);
 			check_page_uptodate(tree, page);
 			if (!parent_locked)
 				unlock_extent(tree, cur, cur + iosize - 1);
-- 
2.1.3

