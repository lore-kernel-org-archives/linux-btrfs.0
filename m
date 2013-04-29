Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3D2NiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 09:38:10 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 56B35A55F4
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 15:38:09 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: use only memmove_extent_buffer and simplify the helpers
Date: Mon, 29 Apr 2013 15:38:01 +0200
Message-Id: <1367242681-8835-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After commit a65917156e34594 ("Btrfs: stop using highmem for
extent_buffers") we don't need to call kmap_atomic anymore and can
reduce the move_pages helper to a simple memmove.

There's only one caller of memcpy_extent_buffer, we can use the
memmove_ variant here.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c     |    2 +-
 fs/btrfs/extent_io.c |   88 +------------------------------------------------
 2 files changed, 3 insertions(+), 87 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 566d99b..154573e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4270,7 +4270,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 			       item_size, item_size +
 			       sizeof(struct btrfs_item), 1);
 	leaf = path->nodes[0];
-	memcpy_extent_buffer(leaf,
+	memmove_extent_buffer(leaf,
 			     btrfs_item_ptr_offset(leaf, path->slots[0]),
 			     btrfs_item_ptr_offset(leaf, path->slots[0] - 1),
 			     item_size);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dbb2bde..e1abebd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4943,89 +4943,9 @@ static void move_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long len)
 {
 	char *dst_kaddr = page_address(dst_page);
-	if (dst_page == src_page) {
-		memmove(dst_kaddr + dst_off, dst_kaddr + src_off, len);
-	} else {
-		char *src_kaddr = page_address(src_page);
-		char *p = dst_kaddr + dst_off + len;
-		char *s = src_kaddr + src_off + len;
+	char *src_kaddr = page_address(src_page);
 
-		while (len--)
-			*--p = *--s;
-	}
-}
-
-static inline bool areas_overlap(unsigned long src, unsigned long dst, unsigned long len)
-{
-	unsigned long distance = (src > dst) ? src - dst : dst - src;
-	return distance < len;
-}
-
-static void copy_pages(struct page *dst_page, struct page *src_page,
-		       unsigned long dst_off, unsigned long src_off,
-		       unsigned long len)
-{
-	char *dst_kaddr = page_address(dst_page);
-	char *src_kaddr;
-	int must_memmove = 0;
-
-	if (dst_page != src_page) {
-		src_kaddr = page_address(src_page);
-	} else {
-		src_kaddr = dst_kaddr;
-		if (areas_overlap(src_off, dst_off, len))
-			must_memmove = 1;
-	}
-
-	if (must_memmove)
-		memmove(dst_kaddr + dst_off, src_kaddr + src_off, len);
-	else
-		memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
-}
-
-void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
-			   unsigned long src_offset, unsigned long len)
-{
-	size_t cur;
-	size_t dst_off_in_page;
-	size_t src_off_in_page;
-	size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
-	unsigned long dst_i;
-	unsigned long src_i;
-
-	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
-		       "len %lu dst len %lu\n", src_offset, len, dst->len);
-		BUG_ON(1);
-	}
-	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
-		       "len %lu dst len %lu\n", dst_offset, len, dst->len);
-		BUG_ON(1);
-	}
-
-	while (len > 0) {
-		dst_off_in_page = (start_offset + dst_offset) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
-		src_off_in_page = (start_offset + src_offset) &
-			((unsigned long)PAGE_CACHE_SIZE - 1);
-
-		dst_i = (start_offset + dst_offset) >> PAGE_CACHE_SHIFT;
-		src_i = (start_offset + src_offset) >> PAGE_CACHE_SHIFT;
-
-		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE -
-					       src_off_in_page));
-		cur = min_t(unsigned long, cur,
-			(unsigned long)(PAGE_CACHE_SIZE - dst_off_in_page));
-
-		copy_pages(extent_buffer_page(dst, dst_i),
-			   extent_buffer_page(dst, src_i),
-			   dst_off_in_page, src_off_in_page, cur);
-
-		src_offset += cur;
-		dst_offset += cur;
-		len -= cur;
-	}
+	memmove(dst_kaddr + dst_off, src_kaddr + src_off, len);
 }
 
 void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
@@ -5050,10 +4970,6 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
-		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
-		return;
-	}
 	while (len > 0) {
 		dst_i = (start_offset + dst_end) >> PAGE_CACHE_SHIFT;
 		src_i = (start_offset + src_end) >> PAGE_CACHE_SHIFT;
-- 
1.7.9

