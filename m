Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45997 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3HGS4I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 14:56:08 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 97CDA7C067E
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 12:56:06 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id IOQtvVkgf0C7YXee (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 12:56:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with enomem in the rewind path
Date: Wed, 7 Aug 2013 14:56:03 -0400
Message-ID: <1375901763-13511-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can get ENOMEM trying to allocate dummy bufs for the rewind operation of the
tree mod log.  Instead of BUG_ON()'ing in this case pass up ENOMEM.  I looked
back through the callers and I'm pretty sure I got everybody who did BUG_ON(ret)
in this path.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c     |    7 ++-
 fs/btrfs/extent_io.c |  145 +++++++++++++++++++++++++------------------------
 2 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0d5c686..a648ebf 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1219,7 +1219,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		btrfs_set_header_level(eb_rewin, btrfs_header_level(eb));
 	} else {
 		eb_rewin = btrfs_clone_extent_buffer(eb);
-		BUG_ON(!eb_rewin);
+		if (!eb_rewin)
+			return ERR_PTR(-ENOMEM);
 	}
 
 	btrfs_tree_read_unlock(eb);
@@ -2772,6 +2773,10 @@ again:
 							  BTRFS_READ_LOCK);
 			}
 			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
+			if (IS_ERR(b)) {
+				ret = PTR_ERR(b);
+				goto done;
+			}
 			p->locks[level] = BTRFS_READ_LOCK;
 			p->nodes[level] = b;
 		} else {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index deaea9c..b422cba 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4222,6 +4222,76 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
+static int extent_buffer_under_io(struct extent_buffer *eb)
+{
+	return (atomic_read(&eb->io_pages) ||
+		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
+		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+}
+
+/*
+ * Helper for releasing extent buffer page.
+ */
+static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
+						unsigned long start_idx)
+{
+	unsigned long index;
+	unsigned long num_pages;
+	struct page *page;
+	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
+
+	BUG_ON(extent_buffer_under_io(eb));
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	index = start_idx + num_pages;
+	if (start_idx >= index)
+		return;
+
+	do {
+		index--;
+		page = extent_buffer_page(eb, index);
+		if (page && mapped) {
+			spin_lock(&page->mapping->private_lock);
+			/*
+			 * We do this since we'll remove the pages after we've
+			 * removed the eb from the radix tree, so we could race
+			 * and have this page now attached to the new eb.  So
+			 * only clear page_private if it's still connected to
+			 * this eb.
+			 */
+			if (PagePrivate(page) &&
+			    page->private == (unsigned long)eb) {
+				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+				BUG_ON(PageDirty(page));
+				BUG_ON(PageWriteback(page));
+				/*
+				 * We need to make sure we haven't be attached
+				 * to a new eb.
+				 */
+				ClearPagePrivate(page);
+				set_page_private(page, 0);
+				/* One for the page private */
+				page_cache_release(page);
+			}
+			spin_unlock(&page->mapping->private_lock);
+
+		}
+		if (page) {
+			/* One for when we alloced the page */
+			page_cache_release(page);
+		}
+	} while (index != start_idx);
+}
+
+/*
+ * Helper for releasing the extent buffer.
+ */
+static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
+{
+	btrfs_release_extent_buffer_page(eb, 0);
+	__free_extent_buffer(eb);
+}
+
 static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   u64 start,
 						   unsigned long len,
@@ -4276,7 +4346,10 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 
 	for (i = 0; i < num_pages; i++) {
 		p = alloc_page(GFP_ATOMIC);
-		BUG_ON(!p);
+		if (!p) {
+			btrfs_release_extent_buffer(new);
+			return NULL;
+		}
 		attach_extent_buffer_page(new, p);
 		WARN_ON(PageDirty(p));
 		SetPageUptodate(p);
@@ -4317,76 +4390,6 @@ err:
 	return NULL;
 }
 
-static int extent_buffer_under_io(struct extent_buffer *eb)
-{
-	return (atomic_read(&eb->io_pages) ||
-		test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
-		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-}
-
-/*
- * Helper for releasing extent buffer page.
- */
-static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
-						unsigned long start_idx)
-{
-	unsigned long index;
-	unsigned long num_pages;
-	struct page *page;
-	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
-
-	BUG_ON(extent_buffer_under_io(eb));
-
-	num_pages = num_extent_pages(eb->start, eb->len);
-	index = start_idx + num_pages;
-	if (start_idx >= index)
-		return;
-
-	do {
-		index--;
-		page = extent_buffer_page(eb, index);
-		if (page && mapped) {
-			spin_lock(&page->mapping->private_lock);
-			/*
-			 * We do this since we'll remove the pages after we've
-			 * removed the eb from the radix tree, so we could race
-			 * and have this page now attached to the new eb.  So
-			 * only clear page_private if it's still connected to
-			 * this eb.
-			 */
-			if (PagePrivate(page) &&
-			    page->private == (unsigned long)eb) {
-				BUG_ON(test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-				BUG_ON(PageDirty(page));
-				BUG_ON(PageWriteback(page));
-				/*
-				 * We need to make sure we haven't be attached
-				 * to a new eb.
-				 */
-				ClearPagePrivate(page);
-				set_page_private(page, 0);
-				/* One for the page private */
-				page_cache_release(page);
-			}
-			spin_unlock(&page->mapping->private_lock);
-
-		}
-		if (page) {
-			/* One for when we alloced the page */
-			page_cache_release(page);
-		}
-	} while (index != start_idx);
-}
-
-/*
- * Helper for releasing the extent buffer.
- */
-static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
-{
-	btrfs_release_extent_buffer_page(eb, 0);
-	__free_extent_buffer(eb);
-}
-
 static void check_buffer_tree_ref(struct extent_buffer *eb)
 {
 	int refs;
-- 
1.7.7.6

