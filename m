Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35482 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbbI3Duq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 23:50:46 -0400
Received: by pacfv12 with SMTP id fv12so26672936pac.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 20:50:46 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v4 1/9] Btrfs: add extent buffer bitmap operations
Date: Tue, 29 Sep 2015 20:50:30 -0700
Message-Id: <ca673db3185da390ccb941ec0fdcacb19ff37918.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

These are going to be used for the free space tree bitmap items.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent_io.c | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |   6 +++
 2 files changed, 155 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e2357e31609a..798a5ee3bd18 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5524,6 +5524,155 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	}
 }
 
+/*
+ * The extent buffer bitmap operations are done with byte granularity because
+ * bitmap items are not guaranteed to be aligned to a word and therefore a
+ * single word in a bitmap may straddle two pages in the extent buffer.
+ */
+#define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
+#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
+#define BITMAP_FIRST_BYTE_MASK(start) \
+	((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
+#define BITMAP_LAST_BYTE_MASK(nbits) \
+	(BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
+
+/*
+ * eb_bitmap_offset() - calculate the page and offset of the byte containing the
+ * given bit number
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @nr: bit number
+ * @page_index: return index of the page in the extent buffer that contains the
+ * given bit number
+ * @page_offset: return offset into the page given by page_index
+ *
+ * This helper hides the ugliness of finding the byte in an extent buffer which
+ * contains a given bit.
+ */
+static inline void eb_bitmap_offset(struct extent_buffer *eb,
+				    unsigned long start, unsigned long nr,
+				    unsigned long *page_index,
+				    size_t *page_offset)
+{
+	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t byte_offset = BIT_BYTE(nr);
+	size_t offset;
+
+	/*
+	 * The byte we want is the offset of the extent buffer + the offset of
+	 * the bitmap item in the extent buffer + the offset of the byte in the
+	 * bitmap item.
+	 */
+	offset = start_offset + start + byte_offset;
+
+	*page_index = offset >> PAGE_CACHE_SHIFT;
+	*page_offset = offset & (PAGE_CACHE_SIZE - 1);
+}
+
+/**
+ * extent_buffer_test_bit - determine whether a bit in a bitmap item is set
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @nr: bit number to test
+ */
+int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
+			   unsigned long nr)
+{
+	char *kaddr;
+	struct page *page;
+	unsigned long i;
+	size_t offset;
+
+	eb_bitmap_offset(eb, start, nr, &i, &offset);
+	page = eb->pages[i];
+	WARN_ON(!PageUptodate(page));
+	kaddr = page_address(page);
+	return 1U & (kaddr[offset] >> (nr & (BITS_PER_BYTE - 1)));
+}
+
+/**
+ * extent_buffer_bitmap_set - set an area of a bitmap
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @pos: bit number of the first bit
+ * @len: number of bits to set
+ */
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+			      unsigned long pos, unsigned long len)
+{
+	char *kaddr;
+	struct page *page;
+	unsigned long i;
+	size_t offset;
+	const unsigned int size = pos + len;
+	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
+	unsigned int mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
+
+	eb_bitmap_offset(eb, start, pos, &i, &offset);
+	page = eb->pages[i];
+	WARN_ON(!PageUptodate(page));
+	kaddr = page_address(page);
+
+	while (len >= bits_to_set) {
+		kaddr[offset] |= mask_to_set;
+		len -= bits_to_set;
+		bits_to_set = BITS_PER_BYTE;
+		mask_to_set = ~0U;
+		if (++offset >= PAGE_CACHE_SIZE && len > 0) {
+			offset = 0;
+			page = eb->pages[++i];
+			WARN_ON(!PageUptodate(page));
+			kaddr = page_address(page);
+		}
+	}
+	if (len) {
+		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
+		kaddr[offset] |= mask_to_set;
+	}
+}
+
+
+/**
+ * extent_buffer_bitmap_clear - clear an area of a bitmap
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @pos: bit number of the first bit
+ * @len: number of bits to clear
+ */
+void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
+				unsigned long pos, unsigned long len)
+{
+	char *kaddr;
+	struct page *page;
+	unsigned long i;
+	size_t offset;
+	const unsigned int size = pos + len;
+	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
+	unsigned int mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
+
+	eb_bitmap_offset(eb, start, pos, &i, &offset);
+	page = eb->pages[i];
+	WARN_ON(!PageUptodate(page));
+	kaddr = page_address(page);
+
+	while (len >= bits_to_clear) {
+		kaddr[offset] &= ~mask_to_clear;
+		len -= bits_to_clear;
+		bits_to_clear = BITS_PER_BYTE;
+		mask_to_clear = ~0U;
+		if (++offset >= PAGE_CACHE_SIZE && len > 0) {
+			offset = 0;
+			page = eb->pages[++i];
+			WARN_ON(!PageUptodate(page));
+			kaddr = page_address(page);
+		}
+	}
+	if (len) {
+		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
+		kaddr[offset] &= ~mask_to_clear;
+	}
+}
+
 static inline bool areas_overlap(unsigned long src, unsigned long dst, unsigned long len)
 {
 	unsigned long distance = (src > dst) ? src - dst : dst - src;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c668f36898d3..9185a20081d7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -309,6 +309,12 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
+int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
+			   unsigned long pos);
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+			      unsigned long pos, unsigned long len);
+void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
+				unsigned long pos, unsigned long len);
 void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
-- 
2.6.0

