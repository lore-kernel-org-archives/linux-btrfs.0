Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51179 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGRMU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 12:12:20 -0500
Received: by mail-pd0-f177.google.com with SMTP id x10so3343055pdj.8
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 09:12:19 -0800 (PST)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] btrfs-progs: add dry-run option to restore command
Date: Fri,  7 Feb 2014 09:12:03 -0800
Message-Id: <1391793123-4617-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes it is useful to see what btrfs restore is going to do
before provisioning enough external storage to restore onto.
Add a dry-run option so we can see what files and paths are found
by restore, without actually restoring any data.
---
 cmds-restore.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 1748262..5116af0 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -53,6 +53,7 @@ static int verbose = 0;
 static int ignore_errors = 0;
 static int overwrite = 0;
 static int get_xattrs = 0;
+static int dry_run = 0;
 
 #define LZO_LEN 4
 #define PAGE_CACHE_SIZE 4096
@@ -801,6 +802,8 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			}
 			if (verbose)
 				printf("Restoring %s\n", path_name);
+			if (dry_run)
+				goto next;
 			fd = open(path_name, O_CREAT|O_WRONLY, 0644);
 			if (fd < 0) {
 				fprintf(stderr, "Error creating %s: %d\n",
@@ -873,7 +876,10 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				printf("Restoring %s\n", path_name);
 
 			errno = 0;
-			ret = mkdir(path_name, 0755);
+			if (dry_run)
+				ret = 0;
+			else
+				ret = mkdir(path_name, 0755);
 			if (ret && errno != EEXIST) {
 				free(dir);
 				fprintf(stderr, "Error mkdiring %s: %d\n",
@@ -1108,6 +1114,7 @@ const char * const cmd_restore_usage[] = {
 	"-r <rootid>	 root objectid",
 	"-d              find dir",
 	"-l              list tree roots",
+	"-D              dry run (only list files that would be recovered)",
 	"--path-regex <regex>",
 	"                restore only filenames matching regex,",
 	"                you have to use following syntax (possibly quoted):",
@@ -1135,7 +1142,7 @@ int cmd_restore(int argc, char **argv)
 	regex_t match_reg, *mreg = NULL;
 	char reg_err[256];
 
-	while ((opt = getopt_long(argc, argv, "sxviot:u:df:r:lc", long_options,
+	while ((opt = getopt_long(argc, argv, "sxviot:u:df:r:lDc", long_options,
 					&option_index)) != -1) {
 
 		switch (opt) {
@@ -1191,6 +1198,9 @@ int cmd_restore(int argc, char **argv)
 			case 'l':
 				list_roots = 1;
 				break;
+			case 'D':
+				dry_run = 1;
+				break;
 			case 'c':
 				match_cflags |= REG_ICASE;
 				break;
-- 
1.7.9.5

