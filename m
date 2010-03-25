From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 01/18] btrfs: Remove u64 conversion for PAGE_CACHE_SIZE
Date: Thu, 25 Mar 2010 20:27:26 +0800
Message-ID: <4BAB56AE.5040009@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We don't need to convert PAGE_CACHE_SIZE to u64 in bit operation.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/compression.c |    2 +-
 fs/btrfs/extent_io.c   |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 28b92a7..467e631 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -349,7 +349,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	struct block_device *bdev;
 	int ret;
 
-	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
+	WARN_ON(start & (PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c99121a..bdfbfa6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3489,7 +3489,7 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	struct page *page;
 	char *kaddr;
 	char *dst = (char *)dstv;
-	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = eb->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -3520,7 +3520,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	size_t offset = start & (PAGE_CACHE_SIZE - 1);
 	char *kaddr;
 	struct page *p;
-	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = eb->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 	unsigned long end_i = (start_offset + start + min_len - 1) >>
 		PAGE_CACHE_SHIFT;
@@ -3589,7 +3589,7 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	struct page *page;
 	char *kaddr;
 	char *ptr = (char *)ptrv;
-	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = eb->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 	int ret = 0;
 
@@ -3625,7 +3625,7 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 	struct page *page;
 	char *kaddr;
 	char *src = (char *)srcv;
-	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = eb->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -3656,7 +3656,7 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = eb->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
 
 	WARN_ON(start > eb->len);
@@ -3688,7 +3688,7 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	size_t offset;
 	struct page *page;
 	char *kaddr;
-	size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = dst->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long i = (start_offset + dst_offset) >> PAGE_CACHE_SHIFT;
 
 	WARN_ON(src->len != dst_len);
@@ -3757,7 +3757,7 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t cur;
 	size_t dst_off_in_page;
 	size_t src_off_in_page;
-	size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = dst->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long dst_i;
 	unsigned long src_i;
 
@@ -3804,7 +3804,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	size_t src_off_in_page;
 	unsigned long dst_end = dst_offset + len - 1;
 	unsigned long src_end = src_offset + len - 1;
-	size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
+	size_t start_offset = dst->start & (PAGE_CACHE_SIZE - 1);
 	unsigned long dst_i;
 	unsigned long src_i;
 
-- 
1.6.5.2


