Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57969 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3CLRbR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:17 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 013B39A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:17 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id kB04mCD8qwgDCfHQ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:16 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/10] restore: Add regex matching of paths and files to be restored
Date: Tue, 12 Mar 2013 13:38:13 -0400
Message-ID: <1363109897-7931-7-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Peter Stuge <peter@stuge.se>

The option -m is used to specify the regex string. -c is used to
specify case insensitive matching. -i was already taken.

In order to restore only a single folder somewhere in the btrfs
tree, it is unfortunately neccessary to construct a slightly
nontrivial regex, e.g.:

restore -m '^/(|home(|/username(|/Desktop(|/.*))))$' /dev/sdb2 /output

This is needed in order to match each directory along the way to the
Desktop directory, as well as all contents below the Desktop directory.

Signed-off-by: Peter Stuge <peter@stuge.se>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 cmds-restore.c |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 215958f..365cd15 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -27,8 +27,10 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include <zlib.h>
-
+#include <regex.h>
+#include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
@@ -455,7 +457,8 @@ set_size:
 }
 
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
-		      const char *output_rootdir, const char *dir)
+		      const char *output_rootdir, const char *dir,
+		      const regex_t *mreg)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -562,6 +565,9 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		/* full path from root of btrfs being restored */
 		snprintf(fs_name, 4096, "%s/%s", dir, filename);
 
+		if (REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
+			goto next;
+
 		/* full path from system root */
 		snprintf(path_name, 4096, "%s%s", output_rootdir, fs_name);
 
@@ -674,7 +680,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 			loops = 0;
 			ret = search_dir(search_root, &location,
-					 output_rootdir, dir);
+					 output_rootdir, dir, mreg);
 			free(dir);
 			if (ret) {
 				if (ignore_errors)
@@ -798,8 +804,12 @@ int cmd_restore(int argc, char **argv)
 	int opt;
 	int super_mirror = 0;
 	int find_dir = 0;
+	const char *match_regstr = NULL;
+	int match_cflags = REG_EXTENDED | REG_NOSUB | REG_NEWLINE;
+	regex_t match_reg, *mreg = NULL;
+	char reg_err[256];
 
-	while ((opt = getopt(argc, argv, "sviot:u:df:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "sviot:u:df:r:cm:")) != -1) {
 		switch (opt) {
 			case 's':
 				get_snaps = 1;
@@ -850,6 +860,12 @@ int cmd_restore(int argc, char **argv)
 					exit(1);
 				}
 				break;
+			case 'c':
+				match_cflags |= REG_ICASE;
+				break;
+			case 'm':
+				match_regstr = optarg;
+				break;
 			default:
 				usage(cmd_restore_usage);
 		}
@@ -916,9 +932,21 @@ int cmd_restore(int argc, char **argv)
 		key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	}
 
-	ret = search_dir(root, &key, dir_name, "");
+	if (match_regstr) {
+		ret = regcomp(&match_reg, match_regstr, match_cflags);
+		if (ret) {
+			regerror(ret, &match_reg, reg_err, sizeof(reg_err));
+			fprintf(stderr, "Regex compile failed: %s\n", reg_err);
+			goto out;
+		}
+		mreg = &match_reg;
+	}
+
+	ret = search_dir(root, &key, dir_name, "", mreg);
 
 out:
+	if (mreg)
+		regfree(mreg);
 	close_ctree(root);
 	return ret;
 }
-- 
1.7.7.6

