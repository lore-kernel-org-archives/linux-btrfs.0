From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [Btrfs-Progs] Update for lzo support
Date: Tue, 16 Nov 2010 14:38:07 +0800
Message-ID: <4CE226CF.70907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- Add incompat flag, otherwise btrfs-progs will report error
  when operating on btrfs filesystems mounted with lzo option.

- Allow to turn on lzo compression for defrag operation:

  # btrfs filesystem defragment -c[zlib, lzo] <file>

  Note: "-c zlib" will fail, because that's how getopt() works
  for optional arguments.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

The lzo patchset for kernel code can be found here:

http://marc.info/?l=linux-btrfs&m=128799063215123&w=2

---
 btrfs.c      |    2 +-
 btrfs_cmds.c |   24 ++++++++++++++++++++----
 ctree.h      |   18 +++++++++++-------
 ioctl.h      |    9 ++++++++-
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..1b4f403 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -65,7 +65,7 @@ static struct Command commands[] = {
 		"List the recently modified files in a filesystem."
 	},
 	{ do_defrag, -1,
-	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
+	  "filesystem defragment", "[-vf] [-c[zlib,lzo]] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
 	},
 	{ do_set_default_subvol, 2,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..14f0ffd 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -142,10 +142,21 @@ static u64 parse_size(char *s)
 	return atoll(s) * mult;
 }
 
+static int parse_compress_type(char *s)
+{
+	if (strcmp(optarg, "zlib") == 0)
+		return BTRFS_COMPRESS_ZLIB;
+	else if (strcmp(optarg, "lzo") == 0)
+		return BTRFS_COMPRESS_LZO;
+	else {
+		fprintf(stderr, "Unknown compress type %s\n", s);
+		exit(1);
+	};
+}
+
 int do_defrag(int ac, char **av)
 {
 	int fd;
-	int compress = 0;
 	int flush = 0;
 	u64 start = 0;
 	u64 len = (u64)-1;
@@ -156,15 +167,18 @@ int do_defrag(int ac, char **av)
 	int verbose = 0;
 	int fancy_ioctl = 0;
 	struct btrfs_ioctl_defrag_range_args range;
+	int compress_type = BTRFS_COMPRESS_NONE;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(ac, av, "vcfs:l:t:");
+		int c = getopt(ac, av, "vc::fs:l:t:");
 		if (c < 0)
 			break;
 		switch(c) {
 		case 'c':
-			compress = 1;
+			compress_type = BTRFS_COMPRESS_ZLIB;
+			if (optarg)
+				compress_type = parse_compress_type(optarg);
 			fancy_ioctl = 1;
 			break;
 		case 'f':
@@ -202,8 +216,10 @@ int do_defrag(int ac, char **av)
 	range.start = start;
 	range.len = len;
 	range.extent_thresh = thresh;
-	if (compress)
+	if (compress_type) {
 		range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
+		range.compress_type = compress_type;
+	}
 	if (flush)
 		range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
 
diff --git a/ctree.h b/ctree.h
index b79e238..4ad7f7d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -350,13 +350,15 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
-#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
-#define BTRFS_FEATURE_INCOMPAT_SUPP		\
-	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |	\
-	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)
+#define BTRFS_FEATURE_INCOMPAT_SUPP			\
+	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -501,9 +503,11 @@ struct btrfs_timespec {
 } __attribute__ ((__packed__));
 
 typedef enum {
-	BTRFS_COMPRESS_NONE = 0,
-	BTRFS_COMPRESS_ZLIB = 1,
-	BTRFS_COMPRESS_LAST = 2,
+	BTRFS_COMPRESS_NONE  = 0,
+	BTRFS_COMPRESS_ZLIB  = 1,
+	BTRFS_COMPRESS_LZO   = 2,
+	BTRFS_COMPRESS_TYPES = 2,
+	BTRFS_COMPRESS_LAST  = 3,
 } btrfs_compression_type;
 
 /* we don't understand any encryption methods right now */
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..bb7b9e0 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -116,8 +116,15 @@ struct btrfs_ioctl_defrag_range_args {
 	 */
 	__u32 extent_thresh;
 
+	/*
+	 * which compression method to use if turning on compression
+	 * for this defrag operation.  If unspecified, zlib will
+	 * be used
+	 */
+	__u32 compress_type;
+
 	/* spare for later */
-	__u32 unused[5];
+	__u32 unused[4];
 };
 
 struct btrfs_ioctl_space_info {
-- 
1.6.3
