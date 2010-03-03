From: jim owens <owens6336@gmail.com>
Subject: [PATCH V2] Btrfs: add direct I/O helper to process inline compressed
 extents.
Date: Wed, 03 Mar 2010 09:48:04 -0500
Message-ID: <4B8E76A4.9080704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Use access_extent_buffer_page() to point at btree location of
inline compressed data so it can be inflated without a memcopy.

Signed-off-by: jim owens <jowens@hp.com>
Signed-off-by: jim owens <jim6336@gmail.com>
---

V2 fixes whitespace checkpatch warning

 fs/btrfs/extent_io.c |   16 ++++++++++++++++
 fs/btrfs/extent_io.h |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b177ed3..d2fc17a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3053,6 +3053,22 @@ static inline struct page *extent_buffer_page(struct extent_buffer *eb,
 	return p;
 }
 
+void access_extent_buffer_page(struct bio_vec *vec, struct extent_buffer *eb,
+				unsigned long start, unsigned long len)
+{
+	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
+	size_t offset = (start_offset + start) &
+				((unsigned long)PAGE_CACHE_SIZE - 1);
+
+	WARN_ON(start > eb->len);
+	WARN_ON(start + len > eb->start + eb->len);
+
+	vec->bv_page = extent_buffer_page(eb, i);
+	vec->bv_offset = offset;
+	vec->bv_len = min(len, (PAGE_CACHE_SIZE - offset));
+}
+
 static inline unsigned long num_extent_pages(u64 start, u64 len)
 {
 	return ((start + len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) -
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 36de250..c8c129b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/bio.h>
 
 /* bits for the extent state */
 #define EXTENT_DIRTY 1
@@ -300,4 +301,6 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 				struct extent_io_tree *tree,
 				u64 start, u64 end, struct page *locked_page,
 				unsigned long op);
+extern void access_extent_buffer_page(struct bio_vec *vec, struct extent_buffer *eb,
+				unsigned long start, unsigned long len);
 #endif
-- 
1.6.3.3
