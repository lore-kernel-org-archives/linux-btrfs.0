From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [Btrfs-Progs] Update for lzo support
Date: Thu, 18 Nov 2010 11:49:56 +0800
Message-ID: <4CE4A264.40102@cn.fujitsu.com>
References: <4CE226CF.70907@cn.fujitsu.com> <201011162215.58385.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201011162215.58385.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

> Please update the man page too.

Updated:

[Btrfs-Progs][V2] Update for lzo support

- Add incompat flag, otherwise btrfs-progs will report error
  when operating on btrfs filesystems mounted with lzo option.

- Update man page.

- Allow to turn on lzo compression for defrag operation:

  # btrfs filesystem defragment -c[zlib, lzo] <file>

  Note: "-c zlib" will fail, because that's how getopt() works
  for optional arguments.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 btrfs.c        |    2 +-
 btrfs_cmds.c   |   24 ++++++++++++++++++++----
 ctree.h        |   18 +++++++++++-------
 ioctl.h        |    9 ++++++++-
 man/btrfs.8.in |    6 ++++--
 5 files changed, 44 insertions(+), 15 deletions(-)

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
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..f9f6e11 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,7 +15,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
+\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
@@ -102,8 +102,10 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
-\fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
+\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 Defragment files and/or directories.
+
+The start position and the number of bytes to deframention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say eveery single extent must be rewritten. You can also turn on compression in defragment operations.
 .TP
 
 \fBdevice scan\fR \fI[<device> [<device>..]]\fR
-- 
1.6.3


