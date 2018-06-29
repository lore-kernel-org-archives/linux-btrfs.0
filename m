Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33990 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966226AbeF2I4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:51 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D69BAD6B
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:50 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/14] btrfs: pass only eb to num_extent_pages
Date: Fri, 29 Jun 2018 10:56:49 +0200
Message-Id: <6dcc9a3bbb003dff2feff4328d27e5bf88b21e9d.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Almost all callers pass the start and len as 2 arguments but this is not
necessary, all the information is provided by the eb. By reordering the
calls to num_extent_pages, we don't need the local variables with
start/len.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 30 +++++++++++++++---------------
 fs/btrfs/extent_io.h |  6 +++---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8e4a7cdbc9f5..577bbb026042 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2062,7 +2062,7 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb, int mirror_num)
 {
 	u64 start = eb->start;
-	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
+	unsigned long i, num_pages = num_extent_pages(eb);
 	int ret = 0;
 
 	if (sb_rdonly(fs_info->sb))
@@ -3591,7 +3591,7 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	if (!ret)
 		return ret;
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
@@ -3721,7 +3721,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	atomic_set(&eb->io_pages, num_pages);
 
 	/* set btree blocks beyond nritems with 0 to avoid stale content. */
@@ -4650,7 +4650,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 
 	BUG_ON(extent_buffer_under_io(eb));
 
-	index = num_extent_pages(eb->start, eb->len);
+	index = num_extent_pages(eb);
 	if (index == 0)
 		return;
 
@@ -4743,7 +4743,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	unsigned long i;
 	struct page *p;
 	struct extent_buffer *new;
-	unsigned long num_pages = num_extent_pages(src->start, src->len);
+	unsigned long num_pages = num_extent_pages(src);
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
 	if (new == NULL)
@@ -4775,12 +4775,11 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	unsigned long num_pages;
 	unsigned long i;
 
-	num_pages = num_extent_pages(start, len);
-
 	eb = __alloc_extent_buffer(fs_info, start, len);
 	if (!eb)
 		return NULL;
 
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		eb->pages[i] = alloc_page(GFP_NOFS);
 		if (!eb->pages[i])
@@ -4844,7 +4843,7 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb,
 
 	check_buffer_tree_ref(eb);
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
@@ -4941,7 +4940,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start)
 {
 	unsigned long len = fs_info->nodesize;
-	unsigned long num_pages = num_extent_pages(start, len);
+	unsigned long num_pages;
 	unsigned long i;
 	unsigned long index = start >> PAGE_SHIFT;
 	struct extent_buffer *eb;
@@ -4964,6 +4963,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (!eb)
 		return ERR_PTR(-ENOMEM);
 
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++, index++) {
 		p = find_or_create_page(mapping, index, GFP_NOFS|__GFP_NOFAIL);
 		if (!p) {
@@ -5160,7 +5160,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 	unsigned long num_pages;
 	struct page *page;
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
@@ -5194,7 +5194,7 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
 
 	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
 
@@ -5210,7 +5210,7 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 	unsigned long num_pages;
 
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		if (page)
@@ -5225,7 +5225,7 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 	unsigned long num_pages;
 
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		SetPageUptodate(page);
@@ -5249,7 +5249,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
 		return 0;
 
-	num_pages = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
 		if (wait == WAIT_NONE) {
@@ -5577,7 +5577,7 @@ void copy_extent_buffer_full(struct extent_buffer *dst,
 
 	ASSERT(dst->len == src->len);
 
-	num_pages = num_extent_pages(dst->start, dst->len);
+	num_pages = num_extent_pages(dst);
 	for (i = 0; i < num_pages; i++)
 		copy_page(page_address(dst->pages[i]),
 				page_address(src->pages[i]));
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0bfd4aeb822d..d8382a4a7f46 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -440,10 +440,10 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
-static inline unsigned long num_extent_pages(u64 start, u64 len)
+static inline unsigned long num_extent_pages(const struct extent_buffer *eb)
 {
-	return ((start + len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
-		(start >> PAGE_SHIFT);
+	return ((eb->start + eb->len + PAGE_SIZE - 1) >> PAGE_SHIFT) -
+		(eb->start >> PAGE_SHIFT);
 }
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
-- 
2.17.1

