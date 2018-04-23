Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932609AbeDWXGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 19:06:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB073AC92
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 23:06:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: switch types to int when counting eb pages
Date: Tue, 24 Apr 2018 01:03:47 +0200
Message-Id: <868400eeb4643da5af1e3a76c63e220299a191ee.1524523682.git.dsterba@suse.com>
In-Reply-To: <cover.1524523681.git.dsterba@suse.com>
References: <cover.1524523681.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The loops iterating eb pages use unsigned long, that's an overkill as
we know that there are at most 16 pages (64k / 4k), and 4 by default
(with nodesize 16k).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 44 ++++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h |  2 +-
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0cc5d6ae1876..5bdfdb9c8777 100644
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
@@ -4648,7 +4648,7 @@ int extent_buffer_under_io(struct extent_buffer *eb)
  */
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
-	unsigned long index;
+	int index;
 	struct page *page;
 	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
 
@@ -4744,10 +4744,10 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 
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
@@ -4776,8 +4776,8 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len)
 {
 	struct extent_buffer *eb;
-	unsigned long num_pages;
-	unsigned long i;
+	int num_pages;
+	int i;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (!eb)
@@ -4843,7 +4843,7 @@ static void check_buffer_tree_ref(struct extent_buffer *eb)
 static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 		struct page *accessed)
 {
-	unsigned long num_pages, i;
+	int num_pages, i;
 
 	check_buffer_tree_ref(eb);
 
@@ -4944,8 +4944,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
@@ -5160,8 +5160,8 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
 {
-	unsigned long i;
-	unsigned long num_pages;
+	int i;
+	int num_pages;
 	struct page *page;
 
 	num_pages = num_extent_pages(eb);
@@ -5190,8 +5190,8 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 int set_extent_buffer_dirty(struct extent_buffer *eb)
 {
-	unsigned long i;
-	unsigned long num_pages;
+	int i;
+	int num_pages;
 	int was_dirty = 0;
 
 	check_buffer_tree_ref(eb);
@@ -5209,9 +5209,9 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
 void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	unsigned long i;
+	int i;
 	struct page *page;
-	unsigned long num_pages;
+	int num_pages;
 
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb);
@@ -5224,9 +5224,9 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
 void set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	unsigned long i;
+	int i;
 	struct page *page;
-	unsigned long num_pages;
+	int num_pages;
 
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb);
@@ -5239,13 +5239,13 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
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
@@ -5577,7 +5577,7 @@ void copy_extent_buffer_full(struct extent_buffer *dst,
 			     struct extent_buffer *src)
 {
 	int i;
-	unsigned num_pages;
+	int num_pages;
 
 	ASSERT(dst->len == src->len);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d08abc9d385e..3248553a3aa2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -452,7 +452,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
-static inline unsigned long num_extent_pages(const struct extent_buffer *eb)
+static inline int num_extent_pages(const struct extent_buffer *eb)
 {
 	return eb->len >> PAGE_SHIFT;
 }
-- 
2.16.2

