From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 18/18] btrfs: fix extent buffer pages release
Date: Thu, 25 Mar 2010 20:38:17 +0800
Message-ID: <4BAB5939.4060603@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

try_release_extent_buffer() releases the first page of extent buffer early, and
it may cause oops, because extent_buffer_page() gets the other pages by the
first page's ->mapping. So we must release the first page at the end.

This patch fixes this problem. And In order to avoid making the same mistake,
__release_extent_buffer_page() was written, and if someone want to release
the extent buffer pages, please use it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dbbf9ca..a4391a6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3099,6 +3099,31 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	return eb;
 }
 
+/*
+ * Used for releasing extent buffer page.
+ *
+ * can't release the first page of extent buffer at the beginning, because 
+ * extent_buffer_page() gets address_space just by the first page->mapping,
+ * and then gets other pages.
+ */
+static void __release_extent_buffer_page(struct extent_buffer *eb)
+{
+	unsigned long index, num_pages;
+	struct page *page;
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	for (index = 1; index < num_pages; index++) {
+		page = extent_buffer_page(eb, index);
+		if (page)
+			page_cache_release(page);
+		else
+			break;
+	}
+	page = extent_buffer_page(eb, 0);
+	if (page)
+		page_cache_release(page);
+}
+
 static void __free_extent_buffer(struct extent_buffer *eb)
 {
 #if LEAK_DEBUG
@@ -3187,9 +3212,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 free_eb:
 	if (!atomic_dec_and_test(&eb->refs))
 		return exists;
-	for (index = 1; index < i; index++)
-		page_cache_release(extent_buffer_page(eb, index));
-	page_cache_release(extent_buffer_page(eb, 0));
+	__release_extent_buffer_page(eb);
 	__free_extent_buffer(eb);
 	return exists;
 }
@@ -3863,9 +3886,7 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 		goto out;
 	}
 	/* at this point we can safely release the extent buffer */
-	num_pages = num_extent_pages(eb->start, eb->len);
-	for (i = 0; i < num_pages; i++)
-		page_cache_release(extent_buffer_page(eb, i));
+	__release_extent_buffer_page(eb);
 	rb_erase(&eb->rb_node, &tree->buffer);
 	__free_extent_buffer(eb);
 out:
-- 
1.6.5.2


