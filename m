Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966279AbeF2I44 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:56 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0994AD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/14] btrfs: switch types to int when counting eb pages
Date: Fri, 29 Jun 2018 10:56:51 +0200
Message-Id: <e2892a7416e313dda01f1a3a4a05906b064f1027.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The loops iterating eb pages use unsigned long, that's an overkill as
we know that there are at most 16 pages (64k / 4k), and 4 by default
(with nodesize 16k).

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 44 ++++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h |  2 +-
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 577bbb026042..94ca8d644de9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2062,7 +2062,7 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb, int mirror_num)
 {
 	u64 start = eb->start;
-	unsigned long i, num_pages = num_extent_pages(eb);
+	int i, num_pages = num_extent_pages(eb);
 	int ret = 0;
 
 	if (sb_rdonly(fs_info->sb))
@@ -3541,7 +3541,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 			  struct btrfs_fs_info *fs_info,
 			  struct extent_page_data *epd)
 {
-	unsigned long i, num_pages;
+	int i, num_pages;
 	int flush = 0;
 	int ret = 0;
 
@@ -3715,7 +3715,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	u64 offset = eb->start;
 	u32 nritems;
-	unsigned long i, num_pages;
+	int i, num_pages;
 	unsigned long start, end;
 	unsigned int write_flags = wbc_to_write_flags(wbc) | REQ_META;
 	int ret = 0;
@@ -4644,7 +4644,7 @@ int extent_buffer_under_io(struct extent_buffer *eb)
  */
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
-	unsigned long index;
+	int index;
 	struct page *page;
 	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
 
@@ -4740,10 +4740,10 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 {
-	unsigned long i;
+	int i;
 	struct page *p;
 	struct extent_buffer *new;
-	unsigned long num_pages = num_extent_pages(src);
+	int num_pages = num_extent_pages(src);
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
 	if (new == NULL)
@@ -4772,8 +4772,8 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len)
 {
 	struct extent_buffer *eb;
-	unsigned long num_pages;
-	unsigned long i;
+	int num_pages;
+	int i;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (!eb)
@@ -4839,7 +4839,7 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 		struct page *accessed)
 {
-	unsigned long num_pages, i;
+	int num_pages, i;
 
 	check_buffer_tree_ref(eb);
 
@@ -4940,8 +4940,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start)
 {
 	unsigned long len = fs_info->nodesize;
-	unsigned long num_pages;
-	unsigned long i;
+	int num_pages;
+	int i;
 	unsigned long index = start >> PAGE_SHIFT;
 	struct extent_buffer *eb;
 	struct extent_buffer *exists = NULL;
@@ -5156,8 +5156,8 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
 {
-	unsigned long i;
-	unsigned long num_pages;
+	int i;
+	int num_pages;
 	struct page *page;
 
 	num_pages = num_extent_pages(eb);
@@ -5186,8 +5186,8 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
 {
-	unsigned long i;
-	unsigned long num_pages;
+	int i;
+	int num_pages;
 	int was_dirty = 0;
 
 	check_buffer_tree_ref(eb);
@@ -5205,9 +5205,9 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
 void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	unsigned long i;
+	int i;
 	struct page *page;
-	unsigned long num_pages;
+	int num_pages;
 
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb);
@@ -5220,9 +5220,9 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
 void set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	unsigned long i;
+	int i;
 	struct page *page;
-	unsigned long num_pages;
+	int num_pages;
 
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb);
@@ -5235,13 +5235,13 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, int wait, int mirror_num)
 {
-	unsigned long i;
+	int i;
 	struct page *page;
 	int err;
 	int ret = 0;
 	int locked_pages = 0;
 	int all_uptodate = 1;
-	unsigned long num_pages;
+	int num_pages;
 	unsigned long num_reads = 0;
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
@@ -5573,7 +5573,7 @@ void copy_extent_buffer_full(struct extent_buffer *dst,
 			     struct extent_buffer *src)
 {
 	int i;
-	unsigned num_pages;
+	int num_pages;
 
 	ASSERT(dst->len == src->len);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8382a4a7f46..1fb9ec76d985 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -440,7 +440,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
-static inline unsigned long num_extent_pages(const struct extent_buffer *eb)
+static inline int num_extent_pages(const struct extent_buffer *eb)
 {
 	return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
 		(eb->start >> PAGE_SHIFT);
-- 
2.17.1

