From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: make lzo the default compression scheme
Date: Thu, 26 May 2011 11:39:03 +0800
Message-ID: <4DDDCB57.6090405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As the lzo compression feature has been established for quite
a while, we are now ready to replace zlib with lzo as the default
compression scheme.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/ioctl.c   |    2 +-
 fs/btrfs/super.c   |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 16d335b..17c9e3a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1753,7 +1753,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	 * In the long term, we'll store the compression type in the super
 	 * block, and it'll be used for per file compression control.
 	 */
-	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
+	fs_info->compress_type = BTRFS_COMPRESS_LZO;
 
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c4f17e4..a86cc2d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -747,7 +747,7 @@ static int btrfs_defrag_file(struct file *file,
 	u64 defrag_end = 0;
 	unsigned long i;
 	int ret;
-	int compress_type = BTRFS_COMPRESS_ZLIB;
+	int compress_type = BTRFS_COMPRESS_LZO;
 
 	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
 		if (range->compress_type > BTRFS_COMPRESS_TYPES)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cd0c7cd..ab9fd9c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -257,12 +257,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_compress_type:
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
-			    strcmp(args[0].from, "zlib") == 0) {
-				compress_type = "zlib";
-				info->compress_type = BTRFS_COMPRESS_ZLIB;
-			} else if (strcmp(args[0].from, "lzo") == 0) {
+			    strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+			} else if (strcmp(args[0].from, "zlib") == 0) {
+				compress_type = "zlib";
+				info->compress_type = BTRFS_COMPRESS_ZLIB;
 			} else {
 				ret = -EINVAL;
 				goto out;
-- 
1.7.3.1

