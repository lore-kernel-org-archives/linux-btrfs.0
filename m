Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751147AbcJBNZX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNCpj099308
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:22 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25ta6ek5yk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:22 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:21 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 03/19] Btrfs: subpage-blocksize: Use PG_Uptodate flag to track block uptodate status
Date: Sun,  2 Oct 2016 18:54:12 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-4-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit causes a block's uptodate status to be tracked using
struct page's PG_Uptodate flag instead of extent_io_tree's
EXTENT_UPTODATE flag.

This is in preparation for subpage-blocksize patchset which will use a
per-page bitmap for tracking individual block's uptodate status in the
case of blocksize < PAGE_SIZE. We will continue to use PG_Uptodate flag
to track uptodate status for blocksize == PAGE_SIZE scenario.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 61 +++++++---------------------------------------------
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/inode.c     |  6 ++----
 3 files changed, 11 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dd7faa1..522c943 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1950,12 +1950,9 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
+static void check_page_uptodate(struct page *page)
 {
-	u64 start = page_offset(page);
-	u64 end = start + PAGE_SIZE - 1;
-	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
-		SetPageUptodate(page);
+	SetPageUptodate(page);
 }
 
 int free_io_failure(struct extent_io_tree *failure_tree,
@@ -2492,18 +2489,6 @@ static void end_bio_extent_writepage(struct bio *bio)
 	bio_put(bio);
 }
 
-static void
-endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
-			      int uptodate)
-{
-	struct extent_state *cached = NULL;
-	u64 end = start + len - 1;
-
-	if (uptodate && tree->track_uptodate)
-		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
-	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
-}
-
 /*
  * after a readpage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2525,8 +2510,6 @@ static void end_bio_extent_readpage(struct bio *bio)
 	u64 start;
 	u64 end;
 	u64 len;
-	u64 extent_start = 0;
-	u64 extent_len = 0;
 	int mirror;
 	int ret;
 	int i;
@@ -2612,7 +2595,7 @@ readpage_ok:
 			off = i_size & (PAGE_SIZE-1);
 			if (page->index == end_index && off)
 				zero_user_segment(page, off, PAGE_SIZE);
-			SetPageUptodate(page);
+			check_page_uptodate(page);
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
@@ -2620,32 +2603,10 @@ readpage_ok:
 		unlock_page(page);
 		offset += len;
 
-		if (unlikely(!uptodate)) {
-			if (extent_len) {
-				endio_readpage_release_extent(tree,
-							      extent_start,
-							      extent_len, 1);
-				extent_start = 0;
-				extent_len = 0;
-			}
-			endio_readpage_release_extent(tree, start,
-						      end - start + 1, 0);
-		} else if (!extent_len) {
-			extent_start = start;
-			extent_len = end + 1 - start;
-		} else if (extent_start + extent_len == start) {
-			extent_len += end + 1 - start;
-		} else {
-			endio_readpage_release_extent(tree, extent_start,
-						      extent_len, uptodate);
-			extent_start = start;
-			extent_len = end + 1 - start;
-		}
+		unlock_extent_cached(tree, start, end, NULL, GFP_ATOMIC);
+
 	}
 
-	if (extent_len)
-		endio_readpage_release_extent(tree, extent_start, extent_len,
-					      uptodate);
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, bio->bi_error);
 	bio_put(bio);
@@ -2933,18 +2894,15 @@ static int __do_readpage(struct extent_io_tree *tree,
 
 		if (cur >= last_byte) {
 			char *userpage;
-			struct extent_state *cached = NULL;
 
 			iosize = PAGE_SIZE - pg_offset;
 			userpage = kmap_atomic(page);
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1,
-					     &cached, GFP_NOFS);
+					     NULL, GFP_NOFS);
 			break;
 		}
 		em = __get_extent_map(inode, page, pg_offset, cur,
@@ -3034,8 +2992,6 @@ static int __do_readpage(struct extent_io_tree *tree,
 			flush_dcache_page(page);
 			kunmap_atomic(userpage);
 
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1,
 					     &cached, GFP_NOFS);
@@ -3044,9 +3000,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 			continue;
 		}
 		/* the get_extent function already copied into the page */
-		if (test_range_bit(tree, cur, cur_end,
-				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
+		if (PageUptodate(page)) {
+			check_page_uptodate(page);
 			unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0948bca..922f4c1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -310,7 +310,7 @@ static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached_state)
 {
 	return set_extent_bit(tree, start, end,
-			      EXTENT_DELALLOC | EXTENT_UPTODATE,
+			      EXTENT_DELALLOC,
 			      NULL, cached_state, GFP_NOFS);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3e4feac..652d01d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3009,7 +3009,6 @@ out:
 		else
 			start = ordered_extent->file_offset;
 		end = ordered_extent->file_offset + ordered_extent->len - 1;
-		clear_extent_uptodate(io_tree, start, end, NULL, GFP_NOFS);
 
 		/* Drop the cache for the part of the extent we didn't write. */
 		btrfs_drop_extent_cache(inode, start, end, 0);
@@ -6807,7 +6806,6 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
 	const bool new_inline = !page || create;
 
@@ -6984,8 +6982,8 @@ next:
 			kunmap(page);
 			btrfs_mark_buffer_dirty(leaf);
 		}
-		set_extent_uptodate(io_tree, em->start,
-				    extent_map_end(em) - 1, NULL, GFP_NOFS);
+
+		SetPageUptodate(page);
 		goto insert;
 	}
 not_found:
-- 
2.5.5

