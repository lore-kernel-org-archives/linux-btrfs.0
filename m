Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2461 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754079AbdKGCVO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 21:21:14 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 47CE948089DE
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 10:21:02 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: fi defrag: extend -c to drop nocompress flag on files
Date: Tue, 7 Nov 2017 10:24:31 +0800
Message-ID: <20171107022431.17938-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171107022431.17938-1-suy.fnst@cn.fujitsu.com>
References: <20171107022431.17938-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, files which have nocompress flag also will be defraged
with compression. However, nocompress flag is still existed
and have to be cleared manually.

So add an option '--clear-nocompress' to extend -c to drop
nocompress flag after defragement.

Suggested-by: David Sterba <dsterba@suse.com>
Suggested-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0893a44f28fe..86de86a3f416 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -27,6 +27,7 @@
 #include <mntent.h>
 #include <linux/limits.h>
 #include <getopt.h>
+#include <linux/fs.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -867,6 +868,8 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	"-l len              defragment only up to len bytes",
 	"-t size             target extent size hint (default: 32M)",
 	"",
+	"--compress-force    clear nocompress flag on files after defragment, only work with option -c",
+	"",
 	"Warning: most Linux kernels will break up the ref-links of COW data",
 	"(e.g., files copied with 'cp --reflink', snapshots) which may cause",
 	"considerable increase of space usage. See btrfs-filesystem(8) for",
@@ -874,11 +877,41 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	NULL
 };
 
+static int clear_nocompress_flag(int fd)
+{
+	unsigned int flags;
+	int ret = 0;
+
+	ret = ioctl(fd, FS_IOC_GETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		error("failed to get flags: %s", strerror(-ret));
+		goto out;
+	}
+
+	if (!(flags & FS_NOCOMP_FL)) {
+		ret = 0;
+		goto out;
+	}
+	flags &= ~FS_NOCOMP_FL;
+	ret = ioctl(fd, FS_IOC_SETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		error("failed to set flags: %s", strerror(-ret));
+		goto out;
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
 static struct btrfs_ioctl_defrag_range_args defrag_global_range;
 static int defrag_global_verbose;
 static int defrag_global_errors;
+static int defrag_global_clear_nocompress;
 static int defrag_callback(const char *fpath, const struct stat *sb,
-		int typeflag, struct FTW *ftwbuf)
+			   int typeflag, struct FTW *ftwbuf)
 {
 	int ret = 0;
 	int err = 0;
@@ -904,6 +937,14 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 			err = errno;
 			goto error;
 		}
+
+		if (defrag_global_clear_nocompress) {
+			ret = clear_nocompress_flag(fd);
+			if (ret) {
+				err = -ret;
+				goto error;
+			}
+		}
 	}
 	return 0;
 
@@ -926,6 +967,12 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
 
+	enum { GETOPT_VAL_CLEAR_NOCOMPRESS = 257};
+	static const struct option long_options[] = {
+		{ "clear-nocompress", no_argument, NULL,
+		  GETOPT_VAL_CLEAR_NOCOMPRESS},
+		{ NULL, 0, NULL, 0}
+	};
 	/*
 	 * Kernel has a different default (256K) that is supposed to be safe,
 	 * but it does not defragment very well. The 32M will likely lead to
@@ -937,8 +984,10 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	defrag_global_errors = 0;
 	defrag_global_verbose = 0;
 	defrag_global_errors = 0;
+	defrag_global_clear_nocompress = 0;
 	while(1) {
-		int c = getopt(argc, argv, "vrc::fs:l:t:");
+		int c = getopt_long(argc, argv, "vrc::fs:l:t:", long_options,
+				    NULL);
 		if (c < 0)
 			break;
 
@@ -972,6 +1021,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		case 'r':
 			recursive = 1;
 			break;
+		case GETOPT_VAL_CLEAR_NOCOMPRESS:
+			defrag_global_clear_nocompress = 1;
+			break;
 		default:
 			usage(cmd_filesystem_defrag_usage);
 		}
@@ -987,6 +1039,8 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	if (compress_type) {
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
 		defrag_global_range.compress_type = compress_type;
+	} else if (defrag_global_clear_nocompress) {
+		warning("Option --clear-nocompress only works for -c");
 	}
 	if (flush)
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
@@ -1065,12 +1119,20 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 				close_file_or_dir(fd, dirstream);
 				break;
 			}
-
 			if (ret) {
 				error("defrag failed on %s: %s", argv[i],
 				      strerror(defrag_err));
 				goto next;
 			}
+
+			if (defrag_global_clear_nocompress)
+				ret = clear_nocompress_flag(fd);
+			if (ret) {
+				error(
+				"failed to drop nocompress flag on %s: %s",
+				argv[i], strerror(-ret));
+				goto next;
+			}
 		}
 next:
 		if (ret)
-- 
2.15.0



