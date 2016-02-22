Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35790 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbcBVRx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 12:53:29 -0500
Received: by mail-lf0-f45.google.com with SMTP id l143so99090311lfe.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 09:53:28 -0800 (PST)
From: Henrik Asp <solenskiner@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Henrik Asp <solenskiner@gmail.com>
Subject: [PATCH] btrfs-progs: restore: make btrfs restore able to read a file which lists files to restore
Date: Mon, 22 Feb 2016 18:53:23 +0100
Message-Id: <1456163603-6712-1-git-send-email-solenskiner@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--path-regex' syntax does not map well to restoring specific files.
this patch introduces --path-from-file which takes a file listing
files to restore.
that file is memory mapped, and for every leaf, memmem is used to
check if fs_file is in that list.

Signed-off-by: Henrik Asp <solenskiner@gmail.com>
Tested-by: Henrik Asp <solenskiner@gmail.com>
---
 cmds-restore.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index dd0b242..5fa0b98 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -16,7 +16,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-
 #include "kerncompat.h"
 
 #include <ctype.h>
@@ -33,6 +32,7 @@
 #include <getopt.h>
 #include <sys/types.h>
 #include <sys/xattr.h>
+#include <sys/mman.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -932,7 +932,9 @@ out:
 
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		      const char *output_rootdir, const char *in_dir,
-		      const regex_t *mreg)
+		      const regex_t *mreg,
+		      const char *mfile,
+		      const int msize)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -1040,6 +1042,9 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		if (mreg && REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
 			goto next;
 
+		if (mfile && NULL == memmem(mfile, msize, fs_name, strlen(fs_name)))
+			goto next;
+
 		/* full path from system root */
 		snprintf(path_name, PATH_MAX, "%s%s", output_rootdir, fs_name);
 
@@ -1142,7 +1147,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 			loops = 0;
 			ret = search_dir(search_root, &location,
-					 output_rootdir, dir, mreg);
+					 output_rootdir, dir, mreg, mfile, msize);
 			free(dir);
 			if (ret) {
 				fprintf(stderr, "Error searching %s\n",
@@ -1402,6 +1407,9 @@ const char * const cmd_restore_usage[] = {
 	"                     you have to use following syntax (possibly quoted):",
 	"                     ^/(|home(|/username(|/Desktop(|/.*))))$",
 	"-c                   ignore case (--path-regex only)",
+	"--path-from-file <file>",
+	"                     restore only filenames from file,",
+	"                     one file per line, case sensitive",
 	NULL
 };
 
@@ -1422,11 +1430,17 @@ int cmd_restore(int argc, char **argv)
 	int match_cflags = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
 	regex_t match_reg, *mreg = NULL;
 	char reg_err[256];
+	char *mfile = NULL;
+	int msize = 0;
+	const char *match_filename = NULL;
+	struct stat match_filestat;
+	int match_fd = 0;
 
 	while (1) {
 		int opt;
 		static const struct option long_options[] = {
 			{ "path-regex", required_argument, NULL, 256},
+			{ "path-from-file", required_argument, NULL, 255},
 			{ "dry-run", no_argument, NULL, 'D'},
 			{ "metadata", no_argument, NULL, 'm'},
 			{ "symlinks", no_argument, NULL, 'S'},
@@ -1503,6 +1517,9 @@ int cmd_restore(int argc, char **argv)
 			case 256:
 				match_regstr = optarg;
 				break;
+			case 255:
+				match_filename = optarg;
+				break;
 			case 'x':
 				get_xattrs = 1;
 				break;
@@ -1599,14 +1616,37 @@ int cmd_restore(int argc, char **argv)
 		mreg = &match_reg;
 	}
 
+	if (match_filename) {
+		if ((match_fd = open(match_filename, O_RDONLY)) == -1) {
+			fprintf(stderr, "Failed to open file: %s\n", match_filename);
+			goto out;
+		}
+		if ((fstat (match_fd, &match_filestat)) == -1) {
+			fprintf(stderr, "Failed to stat file: %s\n", match_filename);
+			goto out;
+		}
+		msize = match_filestat.st_size;
+		if ((mfile = mmap(0, match_filestat.st_size, PROT_READ, MAP_PRIVATE, match_fd, 0)) == (char*) -1) {
+			fprintf(stderr, "Failed to map file: %s\n", match_filename);
+			mfile = NULL;
+			goto out;
+		}
+		if (close(match_fd) == -1) {
+			fprintf(stderr, "Failed to close file: %s\n", match_filename);
+			goto out;
+		}
+	}
+
 	if (dry_run)
 		printf("This is a dry-run, no files are going to be restored\n");
 
-	ret = search_dir(root, &key, dir_name, "", mreg);
+	ret = search_dir(root, &key, dir_name, "", mreg, mfile, msize);
 
 out:
 	if (mreg)
 		regfree(mreg);
+	if (mfile)
+		munmap(mfile, match_filestat.st_size);
 	close_ctree(root);
 	return !!ret;
 }
-- 
2.7.1

