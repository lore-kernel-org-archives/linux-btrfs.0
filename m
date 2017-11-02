Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42599 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752397AbdKBDUF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:20:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 3879347F13A7
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs-progs: fi defrag: extend -c to drop nocompress flag on files
Date: Thu, 2 Nov 2017 11:23:20 +0800
Message-ID: <20171102032320.12537-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, files which don't have compession property won't be defraged with
compression.

So add an option '--compress-force' to extend -c to drop nocompress flag
on files.

If the option is enable and a file doesn't have compression property:
First add a compression property which is specified by option '-c'
(default as zlib). Then do defrag.

Suggested-by: David Sterba <dsterba@suse.com>
Suggested-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 6 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7728430f16a1..4bbbc86a3b3b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -37,6 +37,7 @@
 #include "list_sort.h"
 #include "disk-io.h"
 #include "help.h"
+#include "props.h"
 
 /*
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
@@ -855,6 +856,20 @@ static int parse_compress_type(char *s)
 	};
 }
 
+static const char *compress_type_extract(int type)
+{
+	switch (type) {
+	case BTRFS_COMPRESS_ZLIB:
+		return "zlib";
+	case BTRFS_COMPRESS_LZO:
+		return "lzo";
+	case BTRFS_COMPRESS_ZSTD:
+		return "zstd";
+	}
+
+	return NULL;
+}
+
 static const char * const cmd_filesystem_defrag_usage[] = {
 	"btrfs filesystem defragment [options] <file>|<dir> [<file>|<dir>...]",
 	"Defragment a file or a directory",
@@ -867,6 +882,8 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	"-l len              defragment only up to len bytes",
 	"-t size             target extent size hint (default: 32M)",
 	"",
+	"--compress-force    drop nocompress flag on files, only work with option -c",
+	"",
 	"Warning: most Linux kernels will break up the ref-links of COW data",
 	"(e.g., files copied with 'cp --reflink', snapshots) which may cause",
 	"considerable increase of space usage. See btrfs-filesystem(8) for",
@@ -877,8 +894,49 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 static struct btrfs_ioctl_defrag_range_args defrag_global_range;
 static int defrag_global_verbose;
 static int defrag_global_errors;
+static int defrag_global_compress_force;
+static int drop_nocompress_property(const char *fpath)
+{
+	const char *name = "compression";
+	const char *compress_type;
+	int type = prop_object_inode;
+	int ret = 0;
+	const struct prop_handler *prop;
+
+	for (prop = prop_handlers; prop->name; prop++) {
+		if (!strcmp(prop->name, name))
+			break;
+	}
+	if (!prop->name) {
+		error("can't find handler of compression property");
+		ret = -1;
+		goto out;
+	}
+
+	ret = prop->getter(type, fpath, name, NULL);
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+	compress_type = compress_type_extract(
+		defrag_global_range.compress_type);
+	if (!compress_type) {
+		error("unknown compression type %d",
+		      defrag_global_range.compress_type);
+		ret = -1;
+		goto out;
+	}
+	ret = prop->setter(type, fpath, name, compress_type);
+out:
+	if (ret)
+		error("failed to drop nocompress property on file %s", fpath);
+
+	return ret;
+}
+
 static int defrag_callback(const char *fpath, const struct stat *sb,
-		int typeflag, struct FTW *ftwbuf)
+			   int typeflag, struct FTW *ftwbuf)
 {
 	int ret = 0;
 	int err = 0;
@@ -887,6 +945,11 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
+		if (defrag_global_compress_force) {
+			ret = drop_nocompress_property(fpath);
+			if (ret)
+				goto error;
+		}
 		fd = open(fpath, O_RDWR);
 		if (fd < 0) {
 			err = errno;
@@ -926,6 +989,12 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
 
+	enum { GETOPT_VAL_COMPRESS_FORCE = 257};
+	static const struct option long_options[] = {
+		{ "compress-force", no_argument, NULL,
+		  GETOPT_VAL_COMPRESS_FORCE},
+		{ NULL, 0, NULL, 0}
+	};
 	/*
 	 * Kernel has a different default (256K) that is supposed to be safe,
 	 * but it does not defragment very well. The 32M will likely lead to
@@ -937,8 +1006,10 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	defrag_global_errors = 0;
 	defrag_global_verbose = 0;
 	defrag_global_errors = 0;
+	defrag_global_compress_force = 0;
 	while(1) {
-		int c = getopt(argc, argv, "vrc::fs:l:t:");
+		int c = getopt_long(argc, argv, "vrc::fs:l:t:", long_options,
+				    NULL);
 		if (c < 0)
 			break;
 
@@ -972,6 +1043,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		case 'r':
 			recursive = 1;
 			break;
+		case GETOPT_VAL_COMPRESS_FORCE:
+			defrag_global_compress_force = 1;
+			break;
 		default:
 			usage(cmd_filesystem_defrag_usage);
 		}
@@ -987,6 +1061,8 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	if (compress_type) {
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
 		defrag_global_range.compress_type = compress_type;
+	} else if (defrag_global_compress_force) {
+		warning("Option --compress-force only works for -c");
 	}
 	if (flush)
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
@@ -1049,7 +1125,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		}
 		if (recursive && S_ISDIR(st.st_mode)) {
 			ret = nftw(argv[i], defrag_callback, 10,
-						FTW_MOUNT | FTW_PHYS);
+				   FTW_MOUNT | FTW_PHYS);
 			if (ret == ENOTTY)
 				exit(1);
 			/* errors are handled in the callback */
@@ -1057,9 +1133,15 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		} else {
 			if (defrag_global_verbose)
 				printf("%s\n", argv[i]);
-			ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE,
-					&defrag_global_range);
-			defrag_err = errno;
+			if (defrag_global_compress_force)
+				ret = drop_nocompress_property(argv[i]);
+			if (ret) {
+				defrag_err = -ret;
+			} else {
+				ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE,
+					    &defrag_global_range);
+				defrag_err = errno;
+			}
 		}
 		close_file_or_dir(fd, dirstream);
 		if (ret && defrag_err == ENOTTY) {
-- 
2.15.0



