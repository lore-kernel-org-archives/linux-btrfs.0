Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:45130 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3IQCYO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 22:24:14 -0400
Received: by mail-qe0-f41.google.com with SMTP id ff1so3384682qeb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 19:24:13 -0700 (PDT)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [RFC] btrfs-progs: Add recursive defrag using -r option
Date: Mon, 16 Sep 2013 22:21:24 -0400
Message-Id: <073ec67162396b2ebda9c4ef51c6851993132b68.1379383433.git.fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm working on a patch to add the recursive option to the 
btrfs filesystem defrag command. I'd like some feedback on how
the patch looks as written. I've added two helper functions, which 
might need to be renamed, one to call the ioctl and one to actually handle the
recursion into the directory. 

Let me know what you think.

-Frank

Added a recursive option that allows defrag to defragment
the directory and all files and directories below it.

Signed-off-by: Frank Holton <fholton@gmail.com>
---
 cmds-filesystem.c |  174 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 154 insertions(+), 20 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..9a4b810 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -23,6 +23,9 @@
 #include <uuid/uuid.h>
 #include <ctype.h>
 
+#include <dirent.h> 
+#include <fcntl.h>
+
 #include "kerncompat.h"
 #include "ctree.h"
 #include "ioctl.h"
@@ -333,6 +336,7 @@ static const char * const cmd_defrag_usage[] = {
 	"Defragment a file or a directory",
 	"",
 	"-v             be verbose",
+	"-r             defragment directories and files recursively",
 	"-c[zlib,lzo]   compress the file while defragmenting",
 	"-f             flush data to disk immediately after defragmenting",
 	"-s start       defragment only from byte onward",
@@ -341,6 +345,115 @@ static const char * const cmd_defrag_usage[] = {
 	NULL
 };
 
+static int do_defrag(int fd, int fancy_ioctl, 
+			struct btrfs_ioctl_defrag_range_args *range) {
+	int ret;
+	if (!fancy_ioctl) {
+		ret = ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
+	} else {
+		ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, range);
+	}
+	return(ret);
+}
+
+static int walk_dir(char *name, int verbose, int fancy_ioctl, struct 
+			btrfs_ioctl_defrag_range_args *range) {
+	int e;
+	int dir_fd;
+	int ret = 0;
+	DIR *dir;
+	char fn[FILENAME_MAX];
+	struct dirent *dent;
+	struct stat st;
+	
+	int errors = 0;
+
+	int len = strlen(name);
+	if (len >= FILENAME_MAX - 1) {
+	fprintf(stderr, "ERROR: path name too long\n");
+		return 1;
+	}
+	
+	strcpy(fn, name);
+	if (fn[len-1] != '/')
+		fn[len++] = '/';
+	fn[len] = 0;
+	
+	if(!(dir = opendir(fn))) {
+		e = errno;
+		fprintf(stderr, "ERROR: cannot open directory %s - %s\n",
+						name, strerror(e));
+		return 1;
+	}
+	
+	errno = 0;
+	ret = 0;
+	dir_fd = dirfd(dir);
+	ret = do_defrag(dir_fd, fancy_ioctl, range);
+	e = errno;
+	if (ret) {
+		fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
+			fn, strerror(e));
+			
+		/* directories can only be defragged as root... */
+		errors++;
+	}
+		
+	while ((dent = readdir(dir)) != NULL) {
+		int fd = 0;
+		if (!strcmp(dent->d_name,".") || !strcmp(dent->d_name, ".."))
+			continue;
+			
+		fn[len] = 0;
+		strncat(fn+len, dent->d_name, FILENAME_MAX - len);
+		
+		if (lstat(fn, &st) == -1) {
+			fprintf(stderr,"ERROR: cannot stat %s\n", fn);
+			error++;
+			continue;
+		}
+		
+		/* ignore symlinks ??*/
+		if (S_ISLNK(st.st_mode))
+			continue;
+			
+		if(verbose)
+			printf("%s\n", fn);
+		
+		/* directory entry */
+		if (S_ISDIR(st.st_mode)) {
+			ret = walk_dir(fn, verbose, fancy_ioctl, range);
+			errors += ret;
+		}
+		else {
+			fd = open(fn,O_RDWR);
+			e = errno;
+			if (fd < 0) {
+				fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
+					fn, strerror(e));
+				error++;
+				continue;
+			}
+			
+			ret = do_defrag(fd, fancy_ioctl, range);
+			e = errno;
+			
+			if (ret) {
+				errors++;
+				fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
+					fn, strerror(e));
+				error++;
+			}
+			close(fd);
+		}	  
+	}
+
+	close(dir_fd);
+	closedir(dir);
+
+	return(errors);
+}
+
 static int cmd_defrag(int argc, char **argv)
 {
 	int fd;
@@ -349,6 +462,7 @@ static int cmd_defrag(int argc, char **argv)
 	u64 len = (u64)-1;
 	u32 thresh = 0;
 	int i;
+	int recursive = 0;
 	int errors = 0;
 	int ret = 0;
 	int verbose = 0;
@@ -359,7 +473,7 @@ static int cmd_defrag(int argc, char **argv)
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "vc::fs:l:t:");
+		int c = getopt(argc, argv, "vrc::fs:l:t:");
 		if (c < 0)
 			break;
 
@@ -389,6 +503,9 @@ static int cmd_defrag(int argc, char **argv)
 			thresh = parse_size(optarg);
 			fancy_ioctl = 1;
 			break;
+		case 'r':
+			recursive = 1;
+			break;		
 		default:
 			usage(cmd_defrag_usage);
 		}
@@ -409,35 +526,52 @@ static int cmd_defrag(int argc, char **argv)
 		range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
 
 	for (i = optind; i < argc; i++) {
-		if (verbose)
-			printf("%s\n", argv[i]);
+		
 		fd = open_file_or_dir(argv[i]);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s\n", argv[i]);
+			fprintf(stderr, "ERROR: failed to open %s\n", argv[i]);
 			perror("open:");
 			errors++;
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
+			// check if this is a directory
+			fstat(fd, &st);
+			
+			if (S_ISDIR(st.st_mode)) {
+				ret = walk_dir(argv[i], verbose, fancy_ioctl, &range );
+				e = errno;
+				errors += ret;
+			}
+			else {
+				if (verbose)
+					printf("%s\n", argv[i]);
+				ret = do_defrag(fd, fancy_ioctl, &range);
+				e = errno;
+				if (ret) {
+					fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
+						argv[i], strerror(e));
+					errors++;
+				}
 			}
+		}
+		else {	
+			if (verbose)
+				printf("%s\n", argv[i]);
+			ret = do_defrag(fd, fancy_ioctl, &range);
 			e = errno;
 		}
-		if (ret) {
-			fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
-				argv[i], strerror(e));
+		
+		if (ret && errno == ENOTTY) {
+			fprintf(stderr, "ERROR: defrag range ioctl not "
+				"supported in this kernel, please try "
+				"without any options.\n");
 			errors++;
+			close(fd);
+			break;
 		}
+				
 		close(fd);
 	}
 	if (verbose)
@@ -447,7 +581,7 @@ static int cmd_defrag(int argc, char **argv)
 		exit(1);
 	}
 
-	return errors;
+	return 0;
 }
 
 static const char * const cmd_resize_usage[] = {
-- 
1.7.9.5

