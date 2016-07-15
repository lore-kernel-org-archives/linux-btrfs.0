Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35836 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbcGOTM7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 15:12:59 -0400
Received: by mail-pf0-f176.google.com with SMTP id c2so44061976pfa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 12:12:59 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] btrfs-progs: fix btrfsck of space_cache=v2 bitmaps on big-endian
Date: Fri, 15 Jul 2016 12:12:48 -0700
Message-Id: <17d32b3a20611fe19ab62726bf8626563ff3ec19.1468609012.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Copy le_test_bit() from the kernel and use that for the free space tree
bitmaps.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Same sort of mistake as in the kernel. Applies to v4.6.1.

 extent_io.c  |  2 +-
 extent_io.h  | 19 +++++++++++++++++++
 kerncompat.h |  3 ++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index c99d3627e370..d956c5731332 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -889,5 +889,5 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
 			   unsigned long nr)
 {
-	return test_bit(nr, (unsigned long *)(eb->data + start));
+	return le_test_bit(nr, (u8 *)eb->data + start);
 }
diff --git a/extent_io.h b/extent_io.h
index a9a7353556a7..94a42bf5e180 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -49,6 +49,25 @@
 
 #define BLOCK_GROUP_DIRTY EXTENT_DIRTY
 
+/*
+ * The extent buffer bitmap operations are done with byte granularity instead of
+ * word granularity for two reasons:
+ * 1. The bitmaps must be little-endian on disk.
+ * 2. Bitmap items are not guaranteed to be aligned to a word and therefore a
+ *    single word in a bitmap may straddle two pages in the extent buffer.
+ */
+#define BIT_BYTE(nr) ((nr) / BITS_PER_BYTE)
+#define BYTE_MASK ((1 << BITS_PER_BYTE) - 1)
+#define BITMAP_FIRST_BYTE_MASK(start) \
+	((BYTE_MASK << ((start) & (BITS_PER_BYTE - 1))) & BYTE_MASK)
+#define BITMAP_LAST_BYTE_MASK(nbits) \
+	(BYTE_MASK >> (-(nbits) & (BITS_PER_BYTE - 1)))
+
+static inline int le_test_bit(int nr, const u8 *addr)
+{
+	return 1U & (addr[BIT_BYTE(nr)] >> (nr & (BITS_PER_BYTE-1)));
+}
+
 struct btrfs_fs_info;
 
 struct extent_io_tree {
diff --git a/kerncompat.h b/kerncompat.h
index 378f0552edd2..c9b9b79782b9 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -55,7 +55,8 @@
 #define gfp_t int
 #define get_cpu_var(p) (p)
 #define __get_cpu_var(p) (p)
-#define BITS_PER_LONG (__SIZEOF_LONG__ * 8)
+#define BITS_PER_BYTE 8
+#define BITS_PER_LONG (__SIZEOF_LONG__ * BITS_PER_BYTE)
 #define __GFP_BITS_SHIFT 20
 #define __GFP_BITS_MASK ((int)((1 << __GFP_BITS_SHIFT) - 1))
 #define GFP_KERNEL 0
-- 
2.9.0

