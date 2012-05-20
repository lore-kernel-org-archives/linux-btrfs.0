Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46288 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 05/24] Btrfs: dummy extent buffers for tree mod log
Date: Sun, 20 May 2012 18:06:16 +0200
Message-Id: <3d77abdd466abb242591516786a8fe414b8d5156.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree modification log needs two ways to create dummy extent buffers,
once by allocating a fresh one (to rebuild an old root) and once by
cloning an existing one (to make private rewind modifications) to it.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent_io.c |   73 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_io.h |    3 ++
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2fb52c2..4f4bcaa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3967,6 +3967,58 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
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
@@ -3978,7 +4030,8 @@ static int extent_buffer_under_io(struct extent_buffer *eb)
  * Helper for releasing extent buffer page.
  */
 static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
-						unsigned long start_idx)
+						unsigned long start_idx,
+						int mapped)
 {
 	unsigned long index;
 	struct page *page;
@@ -3992,7 +4045,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	do {
 		index--;
 		page = extent_buffer_page(eb, index);
-		if (page) {
+		if (page && mapped) {
 			spin_lock(&page->mapping->private_lock);
 			/*
 			 * We do this since we'll remove the pages after we've
@@ -4017,6 +4070,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			}
 			spin_unlock(&page->mapping->private_lock);
 
+		}
+		if (page) {
 			/* One for when we alloced the page */
 			page_cache_release(page);
 		}
@@ -4026,12 +4081,18 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 /*
  * Helper for releasing the extent buffer.
  */
-static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
+static inline void btrfs_release_extent_buffer(struct extent_buffer *eb,
+					       int mapped)
 {
-	btrfs_release_extent_buffer_page(eb, 0);
+	btrfs_release_extent_buffer_page(eb, 0, mapped);
 	__free_extent_buffer(eb);
 }
 
+void free_cloned_extent_buffer(struct extent_buffer *eb)
+{
+	btrfs_release_extent_buffer(eb, 0);
+}
+
 static void check_buffer_tree_ref(struct extent_buffer *eb)
 {
 	/* the ref bit is tricky.  We have to make sure it is set
@@ -4201,7 +4262,7 @@ free_eb:
 	}
 
 	WARN_ON(!atomic_dec_and_test(&eb->refs));
-	btrfs_release_extent_buffer(eb);
+	btrfs_release_extent_buffer(eb, 1);
 	return exists;
 }
 
@@ -4245,7 +4306,7 @@ static void release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
 		spin_unlock(&tree->buffer_lock);
 
 		/* Should be safe to release our pages at this point */
-		btrfs_release_extent_buffer_page(eb, 0);
+		btrfs_release_extent_buffer_page(eb, 0, 1);
 
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 		return;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b516c3b..80dd65a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -265,6 +265,9 @@ void set_page_extent_mapped(struct page *page);
 
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len);
+struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
+struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
+void free_cloned_extent_buffer(struct extent_buffer *eb);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
-- 
1.7.3.4

