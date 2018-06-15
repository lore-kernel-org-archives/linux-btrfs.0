Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965627AbeFOLGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:11 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/6] btrfs-progs: Add extent buffer bitmap manipulation infrastructure
Date: Fri, 15 Jun 2018 14:05:58 +0300
Message-Id: <1529060762-4372-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1529060762-4372-1-git-send-email-nborisov@suse.com>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Those functions are in preparation for adding the freespace tree
repair code since it needs to be able to deal with bitmap based fsts.
This patch adds extent_buffer_bitmap_set and extent_buffer_bitmap_clear
functions. Since in userspace we don't have to deal with page mappings
their implementation is vastly simplified by simply setting each bit in
the passed range.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent_io.c | 39 +++++++++++++++++++++++++++++++++++++++
 extent_io.h | 15 +++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/extent_io.c b/extent_io.c
index 198492699438..568a12f7084b 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -204,6 +204,45 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	return ret;
 }
 
+/**
+ * extent_buffer_bitmap_set - set an area of a bitmap
+ * @eb: the extent buffer
+ * @start: offset of the bitmap item in the extent buffer
+ * @pos: bit number of the first bit
+ * @len: number of bits to set
+ */
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+                              unsigned long pos, unsigned long len)
+{
+        u8 *kaddr = (u8 *)eb->data + start;
+
+        while (len) {
+		le_set_bit(pos, kaddr);
+		pos++;
+		len--;
+        }
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
+                                unsigned long pos, unsigned long len)
+{
+        u8 *kaddr = (u8 *)eb->data + start;
+
+        while (len) {
+		le_clear_bit(pos, kaddr);
+		pos++;
+		len--;
+        }
+}
+
 /*
  * clear some bits on a range in the tree.
  */
diff --git a/extent_io.h b/extent_io.h
index d407d93d617e..f9097911f5ef 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -68,6 +68,17 @@ static inline int le_test_bit(int nr, const u8 *addr)
 	return 1U & (addr[BIT_BYTE(nr)] >> (nr & (BITS_PER_BYTE-1)));
 }
 
+
+static inline void le_set_bit(int nr, u8 *addr)
+{
+	addr[BIT_BYTE(nr)] |= (1U << (nr & (BITS_PER_BYTE-1)));
+}
+
+static inline void le_clear_bit(int nr, u8 *addr)
+{
+	addr[BIT_BYTE(nr)] &= ~(1U << (nr & (BITS_PER_BYTE-1)));
+}
+
 struct btrfs_fs_info;
 
 struct extent_io_tree {
@@ -175,4 +186,8 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 			u64 bytes, int mirror);
 int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 		       u64 bytes, int mirror);
+void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
+                                unsigned long pos, unsigned long len);
+void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
+                              unsigned long pos, unsigned long len);
 #endif
-- 
2.7.4

