Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaB0GKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 01:10:33 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 2/4 ] Btrfs-progs: switch to arg_strtou64() part1
Date: Thu, 27 Feb 2014 14:08:38 +0800
Message-Id: <1393481318-2360-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

switch to arg_strtou64 plus some cleanups to remove unnecessary
codes.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v2->v3:
	fix a regression in parse_size() where we can not
	use new helper actually.
---
 btrfs-find-root.c | 23 +++--------------------
 btrfs-list.c      | 14 +++-----------
 cmds-restore.c    | 27 +++++----------------------
 3 files changed, 11 insertions(+), 53 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 0ba4c57..db01923 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -289,30 +289,13 @@ int main(int argc, char **argv)
 		switch(opt) {
 			errno = 0;
 			case 'o':
-				search_objectid = (u64)strtoll(optarg, NULL,
-							       10);
-				if (errno) {
-					fprintf(stderr, "Error parsing "
-						"objectid\n");
-					exit(1);
-				}
+				search_objectid = arg_strtou64(optarg);
 				break;
 			case 'g':
-				search_generation = (u64)strtoll(optarg, NULL,
-							       10);
-				if (errno) {
-					fprintf(stderr, "Error parsing "
-						"generation\n");
-					exit(1);
-				}
+				search_generation = arg_strtou64(optarg);
 				break;
 			case 'l':
-				search_level = strtol(optarg, NULL, 10);
-				if (errno) {
-					fprintf(stderr, "Error parsing "
-						"level\n");
-					exit(1);
-				}
+				search_level = arg_strtou64(optarg);
 				break;
 			default:
 				usage();
diff --git a/btrfs-list.c b/btrfs-list.c
index 9effb27..912b27c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1854,32 +1854,24 @@ int btrfs_list_parse_filter_string(char *opt_arg,
 {
 
 	u64 arg;
-	char *ptr_parse_end = NULL;
-	char *ptr_opt_arg_end = opt_arg + strlen(opt_arg);
 
 	switch (*(opt_arg++)) {
 	case '+':
-		arg = (u64)strtol(opt_arg, &ptr_parse_end, 10);
+		arg = arg_strtou64(opt_arg);
 		type += 2;
-		if (ptr_parse_end != ptr_opt_arg_end)
-			return -1;
 
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
 	case '-':
-		arg = (u64)strtoll(opt_arg, &ptr_parse_end, 10);
+		arg = arg_strtou64(opt_arg);
 		type += 1;
-		if (ptr_parse_end != ptr_opt_arg_end)
-			return -1;
 
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
 	default:
 		opt_arg--;
-		arg = (u64)strtoll(opt_arg, &ptr_parse_end, 10);
+		arg = arg_strtou64(opt_arg);
 
-		if (ptr_parse_end != ptr_opt_arg_end)
-			return -1;
 		btrfs_list_setup_filter(filters, type, arg);
 		break;
 	}
diff --git a/cmds-restore.c b/cmds-restore.c
index fd533ce..6659c75 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1160,26 +1160,14 @@ int cmd_restore(int argc, char **argv)
 				overwrite = 1;
 				break;
 			case 't':
-				errno = 0;
-				tree_location = (u64)strtoll(optarg, NULL, 10);
-				if (errno != 0) {
-					fprintf(stderr, "Tree location not valid\n");
-					exit(1);
-				}
+				tree_location = arg_strtou64(optarg);
 				break;
 			case 'f':
-				errno = 0;
-				fs_location = (u64)strtoll(optarg, NULL, 10);
-				if (errno != 0) {
-					fprintf(stderr, "Fs location not valid\n");
-					exit(1);
-				}
+				fs_location = arg_strtou64(optarg);
 				break;
 			case 'u':
-				errno = 0;
-				super_mirror = (int)strtol(optarg, NULL, 10);
-				if (errno != 0 ||
-				    super_mirror >= BTRFS_SUPER_MIRROR_MAX) {
+				super_mirror = arg_strtou64(optarg);
+				if (super_mirror >= BTRFS_SUPER_MIRROR_MAX) {
 					fprintf(stderr, "Super mirror not "
 						"valid\n");
 					exit(1);
@@ -1189,12 +1177,7 @@ int cmd_restore(int argc, char **argv)
 				find_dir = 1;
 				break;
 			case 'r':
-				errno = 0;
-				root_objectid = (u64)strtoll(optarg, NULL, 10);
-				if (errno != 0) {
-					fprintf(stderr, "Root objectid not valid\n");
-					exit(1);
-				}
+				root_objectid = arg_strtou64(optarg);
 				break;
 			case 'l':
 				list_roots = 1;
-- 
1.9.0

