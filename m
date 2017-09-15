Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50963 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdIOPhO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 11:37:14 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.com>
Date: Fri, 15 Sep 2017 17:36:57 +0200
Message-Id: <20170915153659.24603-1-kilobyte@angband.pl>
In-Reply-To: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
References: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
Subject: [RFC PATCH 1/3] btrfs: allow to set compression level for zlib
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.com>

Preliminary support for setting compression level for zlib, the
following works:

$ mount -o compess=zlib                 # default
$ mount -o compess=zlib0                # same
$ mount -o compess=zlib9                # level 9, slower sync, less data
$ mount -o compess=zlib1                # level 1, faster sync, more data
$ mount -o remount,compress=zlib3	# level set by remount

The level is visible in the same format in /proc/mounts. Level set via
file property does not work yet.

Required patch: "btrfs: prepare for extensions in compression options"

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 20 +++++++++++++++++++-
 fs/btrfs/compression.h |  6 +++++-
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/inode.c       |  5 ++++-
 fs/btrfs/lzo.c         |  5 +++++
 fs/btrfs/super.c       |  7 +++++--
 fs/btrfs/zlib.c        | 12 +++++++++++-
 7 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b51d23f5cafa..70a50194fcf5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -867,6 +867,11 @@ static void free_workspaces(void)
  * Given an address space and start and length, compress the bytes into @pages
  * that are allocated on demand.
  *
+ * @type_level is encoded algorithm and level, where level 0 means whatever
+ * default the algorithm chooses and is opaque here;
+ * - compression algo are 0-3
+ * - the level are bits 4-7
+ *
  * @out_pages is an in/out parameter, holds maximum number of pages to allocate
  * and returns number of actually allocated pages
  *
@@ -881,7 +886,7 @@ static void free_workspaces(void)
  * @max_out tells us the max number of bytes that we're allowed to
  * stuff into pages
  */
-int btrfs_compress_pages(int type, struct address_space *mapping,
+int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 u64 start, struct page **pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
@@ -889,9 +894,11 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 {
 	struct list_head *workspace;
 	int ret;
+	int type = type_level & 0xF;
 
 	workspace = find_workspace(type);
 
+	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1081,3 +1088,14 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 
 	return ret;
 }
+
+unsigned int btrfs_compress_str2level(const char *str)
+{
+	if (strncmp(str, "zlib", 4) != 0)
+		return 0;
+
+	if ('1' <= str[4] && str[4] <= '9' )
+		return str[4] - '0';
+
+	return 0;
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index d2781ff8f994..da20755ebf21 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -76,7 +76,7 @@ struct compressed_bio {
 void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
-int btrfs_compress_pages(int type, struct address_space *mapping,
+int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 u64 start, struct page **pages,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
@@ -95,6 +95,8 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
+unsigned btrfs_compress_str2level(const char *str);
+
 enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
@@ -124,6 +126,8 @@ struct btrfs_compress_op {
 			  struct page *dest_page,
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
+
+	void (*set_level)(struct list_head *ws, unsigned int type);
 };
 
 extern const struct btrfs_compress_op btrfs_zlib_compress;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5a8933da39a7..dd07a7ef234c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -791,6 +791,7 @@ struct btrfs_fs_info {
 	 */
 	unsigned long pending_changes;
 	unsigned long compress_type:4;
+	unsigned int compress_level;
 	int commit_interval;
 	/*
 	 * It is a suggestive number, the read side is safe even it gets a
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 128f3e58634f..28201b924575 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -530,7 +530,10 @@ static noinline void compress_file_range(struct inode *inode,
 		 */
 		extent_range_clear_dirty_for_io(inode, start, end);
 		redirty = 1;
-		ret = btrfs_compress_pages(compress_type,
+
+		/* Compression level is applied here and only here */
+		ret = btrfs_compress_pages(
+			compress_type | (fs_info->compress_level << 4),
 					   inode->i_mapping, start,
 					   pages,
 					   &nr_pages,
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index d433e75d489a..6c7f18cd3b61 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -430,10 +430,15 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
+static void lzo_set_level(struct list_head *ws, unsigned int type)
+{
+}
+
 const struct btrfs_compress_op btrfs_lzo_compress = {
 	.alloc_workspace	= lzo_alloc_workspace,
 	.free_workspace		= lzo_free_workspace,
 	.compress_pages		= lzo_compress_pages,
 	.decompress_bio		= lzo_decompress_bio,
 	.decompress		= lzo_decompress,
+	.set_level		= lzo_set_level,
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 35a128acfbd1..5467187701ef 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -502,6 +502,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			    strncmp(args[0].from, "zlib", 4) == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
+				info->compress_level = btrfs_compress_str2level(args[0].from);
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
@@ -549,9 +550,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			      compress_force != saved_compress_force)) ||
 			    (!btrfs_test_opt(info, COMPRESS) &&
 			     no_compress == 1)) {
-				btrfs_info(info, "%s %s compression",
+				btrfs_info(info, "%s %s compression, level %d",
 					   (compress_force) ? "force" : "use",
-					   compress_type);
+					   compress_type, info->compress_level);
 			}
 			compress_force = false;
 			break;
@@ -1246,6 +1247,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
 			seq_printf(seq, ",compress=%s", compress_type);
+		if (info->compress_level)
+			seq_printf(seq, "%d", info->compress_level);
 	}
 	if (btrfs_test_opt(info, NOSSD))
 		seq_puts(seq, ",nossd");
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index c248f9286366..c890032e680f 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -37,6 +37,7 @@ struct workspace {
 	z_stream strm;
 	char *buf;
 	struct list_head list;
+	int level;
 };
 
 static void zlib_free_workspace(struct list_head *ws)
@@ -96,7 +97,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	*total_out = 0;
 	*total_in = 0;
 
-	if (Z_OK != zlib_deflateInit(&workspace->strm, 3)) {
+	if (Z_OK != zlib_deflateInit(&workspace->strm, workspace->level)) {
 		pr_warn("BTRFS: deflateInit failed\n");
 		ret = -EIO;
 		goto out;
@@ -402,10 +403,19 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
+static void zlib_set_level(struct list_head *ws, unsigned int type)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	unsigned level = (type & 0xF0) >> 4;
+
+	workspace->level = level > 0 ? level : 3;
+}
+
 const struct btrfs_compress_op btrfs_zlib_compress = {
 	.alloc_workspace	= zlib_alloc_workspace,
 	.free_workspace		= zlib_free_workspace,
 	.compress_pages		= zlib_compress_pages,
 	.decompress_bio		= zlib_decompress_bio,
 	.decompress		= zlib_decompress,
+	.set_level              = zlib_set_level,
 };
-- 
2.14.1

