From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH RESEND 1/2] btrfs: restructure try_release_extent_buffer()
Date: Tue, 12 Oct 2010 17:43:11 +0800
Message-ID: <4CB42DAF.20308@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

restructure try_release_extent_buffer() and write a function to release the
extent buffer. It will be used later.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 41277d6..70b7cc5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3097,6 +3097,39 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
+/*
+ * Helper for releasing extent buffer page.
+ */
+static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
+						unsigned long start_idx)
+{
+	unsigned long index;
+	struct page *page;
+
+	if (!eb->first_page)
+		return;
+
+	index = num_extent_pages(eb->start, eb->len);
+	if (start_idx >= index)
+		return;
+
+	do {
+		index--;
+		page = extent_buffer_page(eb, index);
+		if (page)
+			page_cache_release(page);
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
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len,
 					  struct page *page0,
@@ -3174,10 +3207,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 free_eb:
 	if (!atomic_dec_and_test(&eb->refs))
 		return exists;
-	for (index = 1; index < i; index++)
-		page_cache_release(extent_buffer_page(eb, index));
-	page_cache_release(extent_buffer_page(eb, 0));
-	__free_extent_buffer(eb);
+	btrfs_release_extent_buffer(eb);
 	return exists;
 }
 
@@ -3831,8 +3861,6 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 	u64 start = page_offset(page);
 	struct extent_buffer *eb;
 	int ret = 1;
-	unsigned long i;
-	unsigned long num_pages;
 
 	spin_lock(&tree->buffer_lock);
 	eb = buffer_search(tree, start);
@@ -3847,12 +3875,10 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 		ret = 0;
 		goto out;
 	}
-	/* at this point we can safely release the extent buffer */
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++)
-		page_cache_release(extent_buffer_page(eb, i));
+
 	rb_erase(&eb->rb_node, &tree->buffer);
-	__free_extent_buffer(eb);
+	/* at this point we can safely release the extent buffer */
+	btrfs_release_extent_buffer(eb);
 out:
 	spin_unlock(&tree->buffer_lock);
 	return ret;
-- 
1.7.0.1
