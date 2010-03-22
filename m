From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 10/18] Btrfs: add direct I/O helper to process inline compressed
 extents.
Date: Sun, 21 Mar 2010 23:27:18 -0400
Message-ID: <4BA6E396.1040104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Use access_extent_buffer_page() to point at btree location of
inline compressed data so it can be inflated without a memcopy.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/extent_io.c |   16 ++++++++++++++++
 fs/btrfs/extent_io.h |    8 ++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c99121a..5a5370d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3072,6 +3072,22 @@ static inline struct page *extent_buffer_page(struct extent_buffer *eb,
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
index bbab481..9356be1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/bio.h>
 
 /* bits for the extent state */
 #define EXTENT_DIRTY 1
@@ -181,8 +182,8 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, gfp_t mask);
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete, struct extent_state **cached,
-		     gfp_t mask);
+		     int bits, int wake, int delete,
+		     struct extent_state **cached, gfp_t mask);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
@@ -304,4 +305,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 				struct extent_io_tree *tree,
 				u64 start, u64 end, struct page *locked_page,
 				unsigned long op);
+extern void access_extent_buffer_page(struct bio_vec *vec,
+				struct extent_buffer *eb,
+				unsigned long start, unsigned long len);
 #endif
-- 
1.6.3.3
