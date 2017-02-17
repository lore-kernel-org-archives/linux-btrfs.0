Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934096AbdBQSGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:23 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DC45AABCC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/5] btrfs: merge nr_pages input and output parameter in compress_pages
Date: Fri, 17 Feb 2017 19:05:52 +0100
Message-Id: <555a8ac313514f3b69cfad5c1ffe016174b04b09.1487354456.git.dsterba@suse.com>
In-Reply-To: <cover.1487354456.git.dsterba@suse.com>
References: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The parameter saying how many pages can be allocated at maximum can be
merged with the output page counter, to save some stack space.  The
compression implementation will sink the parameter to a local variable
so everything works as before.

The nr_pages variables can also be simply merged in compress_file_range
into one.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c |  7 +++----
 fs/btrfs/compression.h |  2 --
 fs/btrfs/inode.c       | 13 ++++++-------
 fs/btrfs/lzo.c         |  2 +-
 fs/btrfs/zlib.c        |  2 +-
 5 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index eca4704fba9d..3a05c7576a7f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -914,8 +914,8 @@ static void free_workspaces(void)
  * Given an address space and start and length, compress the bytes into @pages
  * that are allocated on demand.
  *
- * @out_pages is used to return the number of pages allocated.  There
- * may be pages allocated even if we return an error.
+ * @out_pages is an in/out parameter, holds maximum number of pages to allocate
+ * and returns number of actually allocated pages
  *
  * @total_in is used to return the number of bytes actually read.  It
  * may be smaller than the input length if we had to exit early because we
@@ -930,7 +930,6 @@ static void free_workspaces(void)
  */
 int btrfs_compress_pages(int type, struct address_space *mapping,
 			 u64 start, struct page **pages,
-			 unsigned long nr_dest_pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
 			 unsigned long *total_out,
@@ -943,7 +942,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
 						      start, pages,
-						      nr_dest_pages, out_pages,
+						      out_pages,
 						      total_in, total_out,
 						      max_out);
 	free_workspace(type, workspace);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 2d53879e8519..e453f42b3bbf 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -24,7 +24,6 @@ void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
 			 u64 start, struct page **pages,
-			 unsigned long nr_dest_pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
 			 unsigned long *total_out,
@@ -60,7 +59,6 @@ struct btrfs_compress_op {
 			      struct address_space *mapping,
 			      u64 start,
 			      struct page **pages,
-			      unsigned long nr_dest_pages,
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
 			      unsigned long *total_out,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7b9cdc0a1b5c..801d1b3fd9d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -430,7 +430,6 @@ static noinline void compress_file_range(struct inode *inode,
 	int ret = 0;
 	struct page **pages = NULL;
 	unsigned long nr_pages;
-	unsigned long nr_pages_ret = 0;
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
 	unsigned long max_compressed = SZ_128K;
@@ -517,7 +516,7 @@ static noinline void compress_file_range(struct inode *inode,
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
 					   pages,
-					   nr_pages, &nr_pages_ret,
+					   &nr_pages,
 					   &total_in,
 					   &total_compressed,
 					   max_compressed);
@@ -525,7 +524,7 @@ static noinline void compress_file_range(struct inode *inode,
 		if (!ret) {
 			unsigned long offset = total_compressed &
 				(PAGE_SIZE - 1);
-			struct page *page = pages[nr_pages_ret - 1];
+			struct page *page = pages[nr_pages - 1];
 			char *kaddr;
 
 			/* zero the tail end of the last page, we might be
@@ -606,7 +605,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 * will submit them to the elevator.
 			 */
 			add_async_extent(async_cow, start, num_bytes,
-					total_compressed, pages, nr_pages_ret,
+					total_compressed, pages, nr_pages,
 					compress_type);
 
 			if (start + num_bytes < end) {
@@ -623,14 +622,14 @@ static noinline void compress_file_range(struct inode *inode,
 		 * the compression code ran but failed to make things smaller,
 		 * free any pages it allocated and our page pointer array
 		 */
-		for (i = 0; i < nr_pages_ret; i++) {
+		for (i = 0; i < nr_pages; i++) {
 			WARN_ON(pages[i]->mapping);
 			put_page(pages[i]);
 		}
 		kfree(pages);
 		pages = NULL;
 		total_compressed = 0;
-		nr_pages_ret = 0;
+		nr_pages = 0;
 
 		/* flag the file so we don't compress in the future */
 		if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) &&
@@ -659,7 +658,7 @@ static noinline void compress_file_range(struct inode *inode,
 	return;
 
 free_pages_out:
-	for (i = 0; i < nr_pages_ret; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		WARN_ON(pages[i]->mapping);
 		put_page(pages[i]);
 	}
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index dfa690d4ce86..72b07f0bb80a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -88,7 +88,6 @@ static int lzo_compress_pages(struct list_head *ws,
 			      struct address_space *mapping,
 			      u64 start,
 			      struct page **pages,
-			      unsigned long nr_dest_pages,
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
 			      unsigned long *total_out,
@@ -103,6 +102,7 @@ static int lzo_compress_pages(struct list_head *ws,
 	struct page *out_page = NULL;
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
+	unsigned long nr_dest_pages = *out_pages;
 	size_t in_len;
 	size_t out_len;
 	char *buf;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 42d76b7824c3..e7f2020f8ee7 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -75,7 +75,6 @@ static int zlib_compress_pages(struct list_head *ws,
 			       struct address_space *mapping,
 			       u64 start,
 			       struct page **pages,
-			       unsigned long nr_dest_pages,
 			       unsigned long *out_pages,
 			       unsigned long *total_in,
 			       unsigned long *total_out,
@@ -90,6 +89,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	struct page *out_page = NULL;
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
+	unsigned long nr_dest_pages = *out_pages;
 
 	*out_pages = 0;
 	*total_out = 0;
-- 
2.10.1

