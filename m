Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934096AbdBQSGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:32 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52477AC17
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/5] btrfs: derive maximum output size in the compression implementation
Date: Fri, 17 Feb 2017 19:06:01 +0100
Message-Id: <de15849275ea0dbb58989f879aed144f3b12dcdd.1487354456.git.dsterba@suse.com>
In-Reply-To: <cover.1487354456.git.dsterba@suse.com>
References: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of max_out can be calculated from the parameters passed to the
compressors, which is number of pages and the page size, and we don't
have to needlessly pass it around.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 6 ++----
 fs/btrfs/compression.h | 6 ++----
 fs/btrfs/inode.c       | 3 +--
 fs/btrfs/lzo.c         | 4 ++--
 fs/btrfs/zlib.c        | 4 ++--
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3a05c7576a7f..75e4e61d338b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -932,8 +932,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 u64 start, struct page **pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
-			 unsigned long *total_out,
-			 unsigned long max_out)
+			 unsigned long *total_out)
 {
 	struct list_head *workspace;
 	int ret;
@@ -943,8 +942,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
-						      total_in, total_out,
-						      max_out);
+						      total_in, total_out);
 	free_workspace(type, workspace);
 	return ret;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index c9d7e552cfa8..0f53410f755c 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -41,8 +41,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 u64 start, struct page **pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
-			 unsigned long *total_out,
-			 unsigned long max_out);
+			 unsigned long *total_out);
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
@@ -76,8 +75,7 @@ struct btrfs_compress_op {
 			      struct page **pages,
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
-			      unsigned long *total_out,
-			      unsigned long max_out);
+			      unsigned long *total_out);
 
 	int (*decompress_bio)(struct list_head *workspace,
 				 struct page **pages_in,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9533a516bace..e9d589944d23 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -509,8 +509,7 @@ static noinline void compress_file_range(struct inode *inode,
 					   pages,
 					   &nr_pages,
 					   &total_in,
-					   &total_compressed,
-					   BTRFS_MAX_COMPRESSED);
+					   &total_compressed);
 
 		if (!ret) {
 			unsigned long offset = total_compressed &
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 72b07f0bb80a..23402dde8b0a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -90,8 +90,7 @@ static int lzo_compress_pages(struct list_head *ws,
 			      struct page **pages,
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
-			      unsigned long *total_out,
-			      unsigned long max_out)
+			      unsigned long *total_out)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0;
@@ -103,6 +102,7 @@ static int lzo_compress_pages(struct list_head *ws,
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
 	unsigned long nr_dest_pages = *out_pages;
+	const unsigned long max_out = nr_dest_pages * PAGE_SIZE;
 	size_t in_len;
 	size_t out_len;
 	char *buf;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index e7f2020f8ee7..135b10823c6d 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -77,8 +77,7 @@ static int zlib_compress_pages(struct list_head *ws,
 			       struct page **pages,
 			       unsigned long *out_pages,
 			       unsigned long *total_in,
-			       unsigned long *total_out,
-			       unsigned long max_out)
+			       unsigned long *total_out)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret;
@@ -90,6 +89,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	unsigned long bytes_left;
 	unsigned long len = *total_out;
 	unsigned long nr_dest_pages = *out_pages;
+	const unsigned long max_out = nr_dest_pages * PAGE_SIZE;
 
 	*out_pages = 0;
 	*total_out = 0;
-- 
2.10.1

