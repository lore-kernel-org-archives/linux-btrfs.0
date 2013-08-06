Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3HFSn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 14:43:29 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@redhat.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/4] btrfs: Introduce extent_read_full_page_nolock()
Date: Tue,  6 Aug 2013 11:42:50 -0700
Message-Id: <1375814571-31753-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
References: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want this for btrfs_extent_same. Basically readpage and friends do their
own extent locking but for the purposes of dedupe, we want to have both
files locked down across a set of readpage operations (so that we can
compare data). Introduce this variant and a flag which can be set for
extent_read_full_page() to indicate that we are already locked.

Partial credit for this patch goes to Gabriel de Perthuis <g2p.code@gmail.com>
as I have included a fix from him to the original patch which avoids a
deadlock on compressed extents.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/compression.c |  6 +++++-
 fs/btrfs/extent_io.c   | 41 +++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h   |  3 +++
 3 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 15b9408..05819c3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -636,7 +636,11 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	faili = nr_pages - 1;
 	cb->nr_pages = nr_pages;
 
-	add_ra_bio_pages(inode, em_start + em_len, cb);
+	/* In the parent-locked case, we only locked the range we are
+	 * interested in.  In all other cases, we can opportunistically
+	 * cache decompressed data that goes beyond the requested range. */
+	if (!(bio_flags & EXTENT_BIO_PARENT_LOCKED))
+		add_ra_bio_pages(inode, em_start + em_len, cb);
 
 	/* include any pages we added in add_ra-bio_pages */
 	uncompressed_len = bio->bi_vcnt * PAGE_CACHE_SIZE;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..80ce106 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2643,11 +2643,12 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	struct btrfs_ordered_extent *ordered;
 	int ret;
 	int nr = 0;
+	int parent_locked = *bio_flags & EXTENT_BIO_PARENT_LOCKED;
 	size_t pg_offset = 0;
 	size_t iosize;
 	size_t disk_io_size;
 	size_t blocksize = inode->i_sb->s_blocksize;
-	unsigned long this_bio_flag = 0;
+	unsigned long this_bio_flag = *bio_flags & EXTENT_BIO_PARENT_LOCKED;
 
 	set_page_extent_mapped(page);
 
@@ -2659,7 +2660,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	}
 
 	end = page_end;
-	while (1) {
+	while (!parent_locked) {
 		lock_extent(tree, start, end);
 		ordered = btrfs_lookup_ordered_extent(inode, start);
 		if (!ordered)
@@ -2695,15 +2696,18 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
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
@@ -2711,7 +2715,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		BUG_ON(end < cur);
 
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
-			this_bio_flag = EXTENT_BIO_COMPRESSED;
+			this_bio_flag |= EXTENT_BIO_COMPRESSED;
 			extent_set_compress_type(&this_bio_flag,
 						 em->compress_type);
 		}
@@ -2755,7 +2759,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
 			check_page_uptodate(tree, page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2765,7 +2770,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -2783,7 +2789,8 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			*bio_flags = this_bio_flag;
 		} else {
 			SetPageError(page);
-			unlock_extent(tree, cur, cur + iosize - 1);
+			if (!parent_locked)
+				unlock_extent(tree, cur, cur + iosize - 1);
 		}
 		cur = cur + iosize;
 		pg_offset += iosize;
@@ -2811,6 +2818,20 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	return ret;
 }
 
+int extent_read_full_page_nolock(struct extent_io_tree *tree, struct page *page,
+				 get_extent_t *get_extent, int mirror_num)
+{
+	struct bio *bio = NULL;
+	unsigned long bio_flags = EXTENT_BIO_PARENT_LOCKED;
+	int ret;
+
+	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
+				      &bio_flags);
+	if (bio)
+		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+	return ret;
+}
+
 static noinline void update_nr_written(struct page *page,
 				      struct writeback_control *wbc,
 				      unsigned long nr_written)
@@ -3666,7 +3687,7 @@ int extent_readpages(struct extent_io_tree *tree,
 			continue;
 		for (i = 0; i < nr; i++) {
 			__extent_read_full_page(tree, pagepool[i], get_extent,
-					&bio, 0, &bio_flags);
+						&bio, 0, &bio_flags);
 			page_cache_release(pagepool[i]);
 		}
 		nr = 0;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 258c921..e3654bd 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -28,6 +28,7 @@
  */
 #define EXTENT_BIO_COMPRESSED 1
 #define EXTENT_BIO_TREE_LOG 2
+#define EXTENT_BIO_PARENT_LOCKED 4
 #define EXTENT_BIO_FLAG_SHIFT 16
 
 /* these are bit numbers for test/set bit */
@@ -198,6 +199,8 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent, int mirror_num);
+int extent_read_full_page_nolock(struct extent_io_tree *tree, struct page *page,
+				 get_extent_t *get_extent, int mirror_num);
 int __init extent_io_init(void);
 void extent_io_exit(void);
 
-- 
1.8.1.4

