Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759217Ab3B1OyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 09:54:22 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4D4B1A3A4A
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 15:54:21 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: use only inline_pages from extent buffer
Date: Thu, 28 Feb 2013 15:54:18 +0100
Message-Id: <1362063258-21292-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The nodesize is capped at 64k and there are enough pages preallocated in
extent_buffer::inline_pages. The fallback to kmalloc never happened
because even on the smallest page size considered (4k) inline_pages
covered the needs.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c | 21 ++++++---------------
 fs/btrfs/extent_io.h |  3 +--
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 597ab89..0306665 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3981,8 +3981,6 @@ static void __free_extent_buffer(struct extent_buffer *eb)
 	list_del(&eb->leak_list);
 	spin_unlock_irqrestore(&leak_lock, flags);
 #endif
-	if (eb->pages && eb->pages != eb->inline_pages)
-		kfree(eb->pages);
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
@@ -4023,19 +4021,12 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	atomic_set(&eb->refs, 1);
 	atomic_set(&eb->io_pages, 0);
 
-	if (len > MAX_INLINE_EXTENT_BUFFER_SIZE) {
-		struct page **pages;
-		int num_pages = (len + PAGE_CACHE_SIZE - 1) >>
-			PAGE_CACHE_SHIFT;
-		pages = kzalloc(num_pages, mask);
-		if (!pages) {
-			__free_extent_buffer(eb);
-			return NULL;
-		}
-		eb->pages = pages;
-	} else {
-		eb->pages = eb->inline_pages;
-	}
+	/*
+	 * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
+	 */
+	BUILD_BUG_ON(BTRFS_MAX_METADATA_BLOCKSIZE
+		> MAX_INLINE_EXTENT_BUFFER_SIZE);
+	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
 	return eb;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index dc81868..6068a19 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -158,8 +158,7 @@ struct extent_buffer {
 	 */
 	wait_queue_head_t read_lock_wq;
 	wait_queue_head_t lock_wq;
-	struct page *inline_pages[INLINE_EXTENT_BUFFER_PAGES];
-	struct page **pages;
+	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
 };
 
 static inline void extent_set_compress_type(unsigned long *bio_flags,
-- 
1.8.1.4

