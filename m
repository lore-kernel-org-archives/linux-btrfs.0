Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934096AbdBQSGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:21 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6C9AABCC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] btrfs: merge length input and output parameter in compress_pages
Date: Fri, 17 Feb 2017 19:05:49 +0100
Message-Id: <e8c6df5ba73e58afec9bfbf333d95d26e1cb2756.1487354456.git.dsterba@suse.com>
In-Reply-To: <cover.1487354456.git.dsterba@suse.com>
References: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The length parameter is basically duplicated for input and output in the
top level caller of the compress_pages chain. We can simply use one
variable for that and reduce stack consumption. The compression
implementation will sink the parameter to a local variable so everything
works as before.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 24 +++++++++++-------------
 fs/btrfs/compression.h |  5 ++---
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/lzo.c         |  4 ++--
 fs/btrfs/zlib.c        |  3 ++-
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 903c32c9eb22..eca4704fba9d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -911,27 +911,25 @@ static void free_workspaces(void)
 }
 
 /*
- * given an address space and start/len, compress the bytes.
+ * Given an address space and start and length, compress the bytes into @pages
+ * that are allocated on demand.
  *
- * pages are allocated to hold the compressed result and stored
- * in 'pages'
+ * @out_pages is used to return the number of pages allocated.  There
+ * may be pages allocated even if we return an error.
  *
- * out_pages is used to return the number of pages allocated.  There
- * may be pages allocated even if we return an error
- *
- * total_in is used to return the number of bytes actually read.  It
- * may be smaller then len if we had to exit early because we
+ * @total_in is used to return the number of bytes actually read.  It
+ * may be smaller than the input length if we had to exit early because we
  * ran out of room in the pages array or because we cross the
  * max_out threshold.
  *
- * total_out is used to return the total number of compressed bytes
+ * @total_out is an in/out parameter, must be set to the input length and will
+ * be also used to return the total number of compressed bytes
  *
- * max_out tells us the max number of bytes that we're allowed to
+ * @max_out tells us the max number of bytes that we're allowed to
  * stuff into pages
  */
 int btrfs_compress_pages(int type, struct address_space *mapping,
-			 u64 start, unsigned long len,
-			 struct page **pages,
+			 u64 start, struct page **pages,
 			 unsigned long nr_dest_pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
@@ -944,7 +942,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 	workspace = find_workspace(type);
 
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
-						      start, len, pages,
+						      start, pages,
 						      nr_dest_pages, out_pages,
 						      total_in, total_out,
 						      max_out);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 09879579fbc8..2d53879e8519 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -23,8 +23,7 @@ void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
-			 u64 start, unsigned long len,
-			 struct page **pages,
+			 u64 start, struct page **pages,
 			 unsigned long nr_dest_pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
@@ -59,7 +58,7 @@ struct btrfs_compress_op {
 
 	int (*compress_pages)(struct list_head *workspace,
 			      struct address_space *mapping,
-			      u64 start, unsigned long len,
+			      u64 start,
 			      struct page **pages,
 			      unsigned long nr_dest_pages,
 			      unsigned long *out_pages,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dae2734a725b..7b9cdc0a1b5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -516,7 +516,7 @@ static noinline void compress_file_range(struct inode *inode,
 		redirty = 1;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
-					   total_compressed, pages,
+					   pages,
 					   nr_pages, &nr_pages_ret,
 					   &total_in,
 					   &total_compressed,
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 45d26980caf9..dfa690d4ce86 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -86,7 +86,7 @@ static inline size_t read_compress_length(char *buf)
 
 static int lzo_compress_pages(struct list_head *ws,
 			      struct address_space *mapping,
-			      u64 start, unsigned long len,
+			      u64 start,
 			      struct page **pages,
 			      unsigned long nr_dest_pages,
 			      unsigned long *out_pages,
@@ -102,7 +102,7 @@ static int lzo_compress_pages(struct list_head *ws,
 	struct page *in_page = NULL;
 	struct page *out_page = NULL;
 	unsigned long bytes_left;
-
+	unsigned long len = *total_out;
 	size_t in_len;
 	size_t out_len;
 	char *buf;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index da497f184ff4..42d76b7824c3 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -73,7 +73,7 @@ static struct list_head *zlib_alloc_workspace(void)
 
 static int zlib_compress_pages(struct list_head *ws,
 			       struct address_space *mapping,
-			       u64 start, unsigned long len,
+			       u64 start,
 			       struct page **pages,
 			       unsigned long nr_dest_pages,
 			       unsigned long *out_pages,
@@ -89,6 +89,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	struct page *in_page = NULL;
 	struct page *out_page = NULL;
 	unsigned long bytes_left;
+	unsigned long len = *total_out;
 
 	*out_pages = 0;
 	*total_out = 0;
-- 
2.10.1

