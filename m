Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44221 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2EZK7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:50 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 07/15] Btrfs: dummy extent buffers for tree mod log
Date: Sat, 26 May 2012 12:59:41 +0200
Message-Id: <815a51c74ad14864d0a8fff5eea983819c18feae.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree modification log needs two ways to create dummy extent buffers,
once by allocating a fresh one (to rebuild an old root) and once by
cloning an existing one (to make private rewind modifications) to it.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent_io.c |   80 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_io.h |    3 ++
 2 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2fb52c2..3daed70 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3930,6 +3930,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->start = start;
 	eb->len = len;
 	eb->tree = tree;
+	eb->bflags = 0;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -3967,6 +3968,60 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	return eb;
 }
 
+struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
+{
+	unsigned long i;
+	struct page *p;
+	struct extent_buffer *new;
+	unsigned long num_pages = num_extent_pages(src->start, src->len);
+
+	new = __alloc_extent_buffer(NULL, src->start, src->len, GFP_ATOMIC);
+	if (new == NULL)
+		return NULL;
+
+	for (i = 0; i < num_pages; i++) {
+		p = alloc_page(GFP_ATOMIC);
+		BUG_ON(!p);
+		attach_extent_buffer_page(new, p);
+		WARN_ON(PageDirty(p));
+		SetPageUptodate(p);
+		new->pages[i] = p;
+	}
+
+	copy_extent_buffer(new, src, 0, 0, src->len);
+	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
+	set_bit(EXTENT_BUFFER_DUMMY, &new->bflags);
+
+	return new;
+}
+
+struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
+{
+	struct extent_buffer *eb;
+	unsigned long num_pages = num_extent_pages(0, len);
+	unsigned long i;
+
+	eb = __alloc_extent_buffer(NULL, start, len, GFP_ATOMIC);
+	if (!eb)
+		return NULL;
+
+	for (i = 0; i < num_pages; i++) {
+		eb->pages[i] = alloc_page(GFP_ATOMIC);
+		if (!eb->pages[i])
+			goto err;
+	}
+	set_extent_buffer_uptodate(eb);
+	btrfs_set_header_nritems(eb, 0);
+	set_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+
+	return eb;
+err:
+	for (i--; i > 0; i--)
+		__free_page(eb->pages[i]);
+	__free_extent_buffer(eb);
+	return NULL;
+}
+
 static int extent_buffer_under_io(struct extent_buffer *eb)
 {
 	return (atomic_read(&eb->io_pages) ||
@@ -3982,6 +4037,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 {
 	unsigned long index;
 	struct page *page;
+	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
@@ -3992,7 +4048,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	do {
 		index--;
 		page = extent_buffer_page(eb, index);
-		if (page) {
+		if (page && mapped) {
 			spin_lock(&page->mapping->private_lock);
 			/*
 			 * We do this since we'll remove the pages after we've
@@ -4017,6 +4073,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			}
 			spin_unlock(&page->mapping->private_lock);
 
+		}
+		if (page) {
 			/* One for when we alloced the page */
 			page_cache_release(page);
 		}
@@ -4235,14 +4293,18 @@ static void release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
 {
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
-		struct extent_io_tree *tree = eb->tree;
+		if (test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags)) {
+			spin_unlock(&eb->refs_lock);
+		} else {
+			struct extent_io_tree *tree = eb->tree;
 
-		spin_unlock(&eb->refs_lock);
+			spin_unlock(&eb->refs_lock);
 
-		spin_lock(&tree->buffer_lock);
-		radix_tree_delete(&tree->buffer,
-				  eb->start >> PAGE_CACHE_SHIFT);
-		spin_unlock(&tree->buffer_lock);
+			spin_lock(&tree->buffer_lock);
+			radix_tree_delete(&tree->buffer,
+					  eb->start >> PAGE_CACHE_SHIFT);
+			spin_unlock(&tree->buffer_lock);
+		}
 
 		/* Should be safe to release our pages at this point */
 		btrfs_release_extent_buffer_page(eb, 0);
@@ -4260,6 +4322,10 @@ void free_extent_buffer(struct extent_buffer *eb)
 
 	spin_lock(&eb->refs_lock);
 	if (atomic_read(&eb->refs) == 2 &&
+	    test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))
+		atomic_dec(&eb->refs);
+
+	if (atomic_read(&eb->refs) == 2 &&
 	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
 	    !extent_buffer_under_io(eb) &&
 	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b516c3b..96434a6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -39,6 +39,7 @@
 #define EXTENT_BUFFER_STALE 6
 #define EXTENT_BUFFER_WRITEBACK 7
 #define EXTENT_BUFFER_IOERR 8
+#define EXTENT_BUFFER_DUMMY 9
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
@@ -265,6 +266,8 @@ void set_page_extent_mapped(struct page *page);
 
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len);
+struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
+struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
-- 
1.7.3.4

