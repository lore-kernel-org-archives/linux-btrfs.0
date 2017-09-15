Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50968 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdIOPhO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 11:37:14 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 15 Sep 2017 17:36:59 +0200
Message-Id: <20170915153659.24603-3-kilobyte@angband.pl>
In-Reply-To: <20170915153659.24603-1-kilobyte@angband.pl>
References: <20170915153457.dt5zjcbrryn3qj3t@angband.pl>
 <20170915153659.24603-1-kilobyte@angband.pl>
Subject: [RFC PATCH 3/3] btrfs: allow setting zstd level
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Capped at 15 because of currently used encoding, which is also a reasonable
limit because highest levels shine only on blocks much bigger than btrfs'
128KB.

Memory is allocated for the biggest supported level rather than for
what is actually used.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/compression.c | 21 +++++++++++++++------
 fs/btrfs/props.c       |  2 +-
 fs/btrfs/super.c       |  3 ++-
 fs/btrfs/zstd.c        | 24 +++++++++++++++++++-----
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 71782ec976c7..2d4337756fef 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1091,13 +1091,22 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 
 unsigned int btrfs_compress_str2level(const char *str)
 {
-	if (strncmp(str, "zlib", 4) != 0)
+	long level;
+	int max;
+
+	if (strncmp(str, "zlib", 4) == 0)
+		max = 9;
+	else if (strncmp(str, "zstd", 4) == 0)
+		max = 15; // encoded on 4 bits, real max is 22
+	else
 		return 0;
 
-	if ('1' <= str[4] && str[4] <= '9' )
-		return str[4] - '0';
-	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9')
-		return str[5] - '0';
+	str += 4;
+	if (*str == ':')
+		str++;
 
-	return 0;
+	if (kstrtoul(str, 10, &level))
+		return 0;
+
+	return (level > max) ? 0 : level;
 }
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f6a05f836629..2e35aa2b2d79 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -414,7 +414,7 @@ static int prop_compression_apply(struct inode *inode,
 		type = BTRFS_COMPRESS_LZO;
 	else if (!strncmp("zlib", value, 4))
 		type = BTRFS_COMPRESS_ZLIB;
-	else if (!strncmp("zstd", value, len))
+	else if (!strncmp("zstd", value, 4))
 		type = BTRFS_COMPRESS_ZSTD;
 	else
 		return -EINVAL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 537e04120457..f9d4522336db 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -515,9 +515,10 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 				no_compress = 0;
-			} else if (strcmp(args[0].from, "zstd") == 0) {
+			} else if (strncmp(args[0].from, "zstd", 4) == 0) {
 				compress_type = "zstd";
 				info->compress_type = BTRFS_COMPRESS_ZSTD;
+				info->compress_level = btrfs_compress_str2level(args[0].from);
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 607ce47b483a..99e11cb2d60e 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -26,11 +26,14 @@
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
 #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
 #define ZSTD_BTRFS_DEFAULT_LEVEL 3
+// Max supported by the algorithm is 22, but gains for small blocks (128KB)
+// are limited, thus we cap at 15.
+#define ZSTD_BTRFS_MAX_LEVEL 15
 
-static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len)
+static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len, int level)
 {
-	ZSTD_parameters params = ZSTD_getParams(ZSTD_BTRFS_DEFAULT_LEVEL,
-						src_len, 0);
+	ZSTD_parameters params = ZSTD_getParams(level, src_len, 0);
+	BUG_ON(level > ZSTD_maxCLevel());
 
 	if (params.cParams.windowLog > ZSTD_BTRFS_MAX_WINDOWLOG)
 		params.cParams.windowLog = ZSTD_BTRFS_MAX_WINDOWLOG;
@@ -43,6 +46,7 @@ struct workspace {
 	size_t size;
 	char *buf;
 	struct list_head list;
+	int level;
 };
 
 static void zstd_free_workspace(struct list_head *ws)
@@ -57,7 +61,8 @@ static void zstd_free_workspace(struct list_head *ws)
 static struct list_head *zstd_alloc_workspace(void)
 {
 	ZSTD_parameters params =
-			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
+			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT,
+						  ZSTD_BTRFS_MAX_LEVEL);
 	struct workspace *workspace;
 
 	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
@@ -101,7 +106,7 @@ static int zstd_compress_pages(struct list_head *ws,
 	unsigned long len = *total_out;
 	const unsigned long nr_dest_pages = *out_pages;
 	unsigned long max_out = nr_dest_pages * PAGE_SIZE;
-	ZSTD_parameters params = zstd_get_btrfs_parameters(len);
+	ZSTD_parameters params = zstd_get_btrfs_parameters(len, workspace->level);
 
 	*out_pages = 0;
 	*total_out = 0;
@@ -423,10 +428,19 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
+static void zstd_set_level(struct list_head *ws, unsigned int type)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	unsigned level = (type & 0xF0) >> 4;
+
+	workspace->level = level > 0 ? level : ZSTD_BTRFS_DEFAULT_LEVEL;
+}
+
 const struct btrfs_compress_op btrfs_zstd_compress = {
 	.alloc_workspace = zstd_alloc_workspace,
 	.free_workspace = zstd_free_workspace,
 	.compress_pages = zstd_compress_pages,
 	.decompress_bio = zstd_decompress_bio,
 	.decompress = zstd_decompress,
+	.set_level = zstd_set_level,
 };
-- 
2.14.1

