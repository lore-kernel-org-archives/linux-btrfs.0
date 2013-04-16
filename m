Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485Ab3DPWOZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 18:14:25 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, chris.mason@fusionio.com,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/4] btrfs: Introduce extent_read_full_page_nolock()
Date: Tue, 16 Apr 2013 15:15:34 -0700
Message-Id: <1366150535-18750-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want this for btrfs_extent_same. Basically readpage and friends do their
own extent locking but for the purposes of dedupe, we want to have both
files locked down across a set of readpage operations (so that we can
compare data). Introduce this variant and a flag which can be set for
extent_read_full_page() to indicate that we are already locked.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/extent_io.c |   44 ++++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h |    2 ++
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..9256503 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2592,7 +2592,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags)
+				   unsigned long *bio_flags, int parent_locked)
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
@@ -2625,7 +2625,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	}
 
 	end = page_end;
-	while (1) {
+	while (1 && !parent_locked) {
 		lock_extent(tree, start, end);
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
@@ -2659,15 +2659,18 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			kunmap_atomic(userpage);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
-			unlock_extent_cached(tree, cur, cur + iosize - 1,
-					     &cached, GFP_NOFS);
+			if (!parent_locked)
+				unlock_extent_cached(tree, cur,
+						     cur + iosize - 1,
+						     &cached, GFP_NOFS);
 			break;
 		}
 		em = get_extent(inode, page, pg_offset, cur,
 				end - cur + 1, 0);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
-			unlock_extent(tree, cur, end);
+			if (!parent_locked)
+				unlock_extent(tree, cur, end);
 			break;
 		}
 		extent_offset = cur - em->start;
@@ -2719,7 +2722,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
 			check_page_uptodate(tree, page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2729,7 +2733,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2756,7 +2761,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		}
 		if (ret) {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 		}
 		cur = cur + iosize;
 		pg_offset += iosize;
@@ -2778,7 +2784,21 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
-				      &bio_flags);
+				      &bio_flags, 0);
+	if (bio)
+		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+	return ret;
+}
+
+int extent_read_full_page_nolock(struct extent_io_tree *tree, struct page *page,
+				 get_extent_t *get_extent, int mirror_num)
+{
+	struct bio *bio = NULL;
+	unsigned long bio_flags = 0;
+	int ret;
+
+	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
+				      &bio_flags, 1);
 	if (bio)
 		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
 	return ret;
@@ -3648,14 +3668,14 @@ int extent_readpages(struct extent_io_tree *tree,
 			continue;
 		for (i = 0; i < nr; i++) {
 			__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags);
+						&bio, 0, &bio_flags, 0);
 			page_cache_release(pagepool[i]);
 		}
 		nr = 0;
 	}
 	for (i = 0; i < nr; i++) {
 		__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags);
+					&bio, 0, &bio_flags, 0);
 		page_cache_release(pagepool[i]);
 	}
 
@@ -4620,7 +4640,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
 						      get_extent, &bio,
-						      mirror_num, &bio_flags);
+						      mirror_num, &bio_flags, 0);
 			if (err)
 				ret = err;
 		} else {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 2eacfab..71752fc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -202,6 +202,8 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent, int mirror_num);
+int extent_read_full_page_nolock(struct extent_io_tree *tree, struct page *page,
+				 get_extent_t *get_extent, int mirror_num);
 int __init extent_io_init(void);
 void extent_io_exit(void);
 
-- 
1.7.10.4

