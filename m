Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:62260 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IWTSs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 15:18:48 -0400
Received: by mail-qe0-f54.google.com with SMTP id cy11so2491443qeb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 12:18:47 -0700 (PDT)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH v3] btrfs-progs: Add recursive defrag using -r option
Date: Mon, 23 Sep 2013 15:18:17 -0400
Message-Id: <20ddb7ded6d0bedadd7dc68a2c29d7c3bd4b7906.1379963692.git.fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an option to defrag all files in a directory recursively.

Signed-off-by: Frank Holton <fholton@gmail.com>
---
v3: prefix globals with defrag
v2: switch to ftw amd callback

 cmds-filesystem.c |  156 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 113 insertions(+), 43 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..44a224f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,8 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <fcntl.h>
+#include <ftw.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -265,7 +267,7 @@ static int cmd_show(int argc, char **argv)
 		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 		return 18;
 	}
-	
+
 	if(searchstart < argc)
 		search = argv[searchstart];
 
@@ -308,7 +310,7 @@ static int cmd_sync(int argc, char **argv)
 	e = errno;
 	close(fd);
 	if( res < 0 ){
-		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n", 
+		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n",
 			path, strerror(e));
 		return 16;
 	}
@@ -333,6 +335,7 @@ static const char * const cmd_defrag_usage[] = {
 	"Defragment a file or a directory",
 	"",
 	"-v             be verbose",
+	"-r             defragment files recursively",
 	"-c[zlib,lzo]   compress the file while defragmenting",
 	"-f             flush data to disk immediately after defragmenting",
 	"-s start       defragment only from byte onward",
@@ -341,6 +344,57 @@ static const char * const cmd_defrag_usage[] = {
 	NULL
 };
 
+static int do_defrag(int fd, int fancy_ioctl,
+			struct btrfs_ioctl_defrag_range_args *range)
+{
+	int ret;
+
+	if (!fancy_ioctl)
+		ret = ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
+	else
+		ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, range);
+
+	return ret;
+}
+
+static int defrag_global_fancy_ioctl;
+static struct btrfs_ioctl_defrag_range_args defrag_global_range;
+static int defrag_global_verbose;
+static int defrag_global_errors;
+static int defrag_callback(const char *fpath, const struct stat *sb, int typeflag)
+{
+	int ret = 0;
+	int e = 0;
+	int fd = 0;
+
+	if (typeflag == FTW_F) {
+		if (defrag_global_verbose)
+				printf("%s\n", fpath);
+		fd = open(fpath, O_RDWR);
+		e = errno;
+		if (fd < 0)
+			goto error;
+		ret = do_defrag(fd, defrag_global_fancy_ioctl, &defrag_global_range);
+		e = errno;
+		close(fd);
+		if (ret && e == ENOTTY) {
+			fprintf(stderr, "ERROR: defrag range ioctl not "
+				"supported in this kernel, please try "
+				"without any options.\n");
+			defrag_global_errors++;
+			return ENOTTY;
+		}
+		if (ret)
+			goto error;
+	}
+	return 0;
+
+error:
+	fprintf(stderr, "ERROR: defrag failed on %s - %s\n", fpath, strerror(e));
+	defrag_global_errors++;
+	return 0;
+}
+
 static int cmd_defrag(int argc, char **argv)
 {
 	int fd;
@@ -349,17 +403,19 @@ static int cmd_defrag(int argc, char **argv)
 	u64 len = (u64)-1;
 	u32 thresh = 0;
 	int i;
-	int errors = 0;
+	int recursive = 0;
 	int ret = 0;
-	int verbose = 0;
-	int fancy_ioctl = 0;
 	struct btrfs_ioctl_defrag_range_args range;
-	int e=0;
+	int e = 0;
 	int compress_type = BTRFS_COMPRESS_NONE;
 
+	defrag_global_errors = 0;
+	defrag_global_verbose = 0;
+	defrag_global_errors = 0;
+	defrag_global_fancy_ioctl = 0;
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "vc::fs:l:t:");
+		int c = getopt(argc, argv, "vrc::fs:l:t:");
 		if (c < 0)
 			break;
 
@@ -368,26 +424,29 @@ static int cmd_defrag(int argc, char **argv)
 			compress_type = BTRFS_COMPRESS_ZLIB;
 			if (optarg)
 				compress_type = parse_compress_type(optarg);
-			fancy_ioctl = 1;
+			defrag_global_fancy_ioctl = 1;
 			break;
 		case 'f':
 			flush = 1;
-			fancy_ioctl = 1;
+			defrag_global_fancy_ioctl = 1;
 			break;
 		case 'v':
-			verbose = 1;
+			defrag_global_verbose = 1;
 			break;
 		case 's':
 			start = parse_size(optarg);
-			fancy_ioctl = 1;
+			defrag_global_fancy_ioctl = 1;
 			break;
 		case 'l':
 			len = parse_size(optarg);
-			fancy_ioctl = 1;
+			defrag_global_fancy_ioctl = 1;
 			break;
 		case 't':
 			thresh = parse_size(optarg);
-			fancy_ioctl = 1;
+			defrag_global_fancy_ioctl = 1;
+			break;
+		case 'r':
+			recursive = 1;
 			break;
 		default:
 			usage(cmd_defrag_usage);
@@ -397,57 +456,68 @@ static int cmd_defrag(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_defrag_usage);
 
-	memset(&range, 0, sizeof(range));
-	range.start = start;
-	range.len = len;
-	range.extent_thresh = thresh;
+	memset(&defrag_global_range, 0, sizeof(range));
+	defrag_global_range.start = start;
+	defrag_global_range.len = len;
+	defrag_global_range.extent_thresh = thresh;
 	if (compress_type) {
-		range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
-		range.compress_type = compress_type;
+		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
+		defrag_global_range.compress_type = compress_type;
 	}
 	if (flush)
-		range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
+		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
 
 	for (i = optind; i < argc; i++) {
-		if (verbose)
-			printf("%s\n", argv[i]);
 		fd = open_file_or_dir(argv[i]);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s\n", argv[i]);
+			fprintf(stderr, "ERROR: failed to open %s\n", argv[i]);
 			perror("open:");
-			errors++;
+			defrag_global_errors++;
 			continue;
 		}
-		if (!fancy_ioctl) {
-			ret = ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
-			e=errno;
-		} else {
-			ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range);
-			if (ret && errno == ENOTTY) {
-				fprintf(stderr, "ERROR: defrag range ioctl not "
-					"supported in this kernel, please try "
-					"without any options.\n");
-				errors++;
-				close(fd);
-				break;
+		if (recursive) {
+			struct stat st;
+			fstat(fd, &st);
+			if (S_ISDIR(st.st_mode)) {
+				ret = ftw(argv[i], defrag_callback, 10);
+				if (ret == ENOTTY)
+					exit(1);
+				/* errors are handled in the callback */
+				ret = 0;
+			} else {
+				if (defrag_global_verbose)
+					printf("%s\n", argv[i]);
+				ret = do_defrag(fd, defrag_global_fancy_ioctl, &defrag_global_range);
+				e = errno;
 			}
+		} else {
+			if (defrag_global_verbose)
+				printf("%s\n", argv[i]);
+			ret = do_defrag(fd, defrag_global_fancy_ioctl, &defrag_global_range);
 			e = errno;
 		}
+		close(fd);
+		if (ret && e == ENOTTY) {
+			fprintf(stderr, "ERROR: defrag range ioctl not "
+				"supported in this kernel, please try "
+				"without any options.\n");
+			defrag_global_errors++;
+			break;
+		}
 		if (ret) {
 			fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
 				argv[i], strerror(e));
-			errors++;
+			defrag_global_errors++;
 		}
-		close(fd);
 	}
-	if (verbose)
+	if (defrag_global_verbose)
 		printf("%s\n", BTRFS_BUILD_VERSION);
-	if (errors) {
-		fprintf(stderr, "total %d failures\n", errors);
+	if (defrag_global_errors) {
+		fprintf(stderr, "total %d failures\n", defrag_global_errors);
 		exit(1);
 	}
 
-	return errors;
+	return 0;
 }
 
 static const char * const cmd_resize_usage[] = {
@@ -489,7 +559,7 @@ static int cmd_resize(int argc, char **argv)
 	e = errno;
 	close(fd);
 	if( res < 0 ){
-		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n", 
+		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n",
 			path, strerror(e));
 		return 30;
 	}
-- 
1.7.9.5

