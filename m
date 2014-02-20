Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBTBcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 20:32:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K1Wg0a006794
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 09:32:45 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] Btrfs-progs: switch to arg_strtou64() part2
Date: Thu, 20 Feb 2014 09:30:51 +0800
Message-Id: <1392859852-15829-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 45 +++++++++------------------------------------
 btrfs-debug-tree.c    |  2 +-
 btrfs-image.c         | 12 ++++++------
 btrfs-map-logical.c   | 26 ++++++--------------------
 cmds-inspect.c        |  8 ++++----
 5 files changed, 26 insertions(+), 67 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 10cae00..6ecbe47 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -36,7 +36,7 @@
 #define FIELD_BUF_LEN 80
 
 struct extent_buffer *debug_corrupt_block(struct btrfs_root *root, u64 bytenr,
-				     u32 blocksize, int copy)
+				     u32 blocksize, u64 copy)
 {
 	int ret;
 	struct extent_buffer *eb;
@@ -165,7 +165,7 @@ static int corrupt_keys_in_block(struct btrfs_root *root, u64 bytenr)
 }
 
 static int corrupt_extent(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, u64 bytenr, int copy)
+			  struct btrfs_root *root, u64 bytenr, u64 copy)
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -792,7 +792,7 @@ int main(int ac, char **av)
 	u64 logical = (u64)-1;
 	int ret = 0;
 	int option_index = 0;
-	int copy = 0;
+	u64 copy = 0;
 	u64 bytes = 4096;
 	int extent_rec = 0;
 	int extent_tree = 0;
@@ -816,23 +816,13 @@ int main(int ac, char **av)
 			break;
 		switch(c) {
 			case 'l':
-				logical = atoll(optarg);
+				logical = arg_strtou64(optarg);
 				break;
 			case 'c':
-				copy = atoi(optarg);
-				if (copy <= 0) {
-					fprintf(stderr,
-						"invalid copy number\n");
-					print_usage();
-				}
+				copy = arg_strtou64(optarg);
 				break;
 			case 'b':
-				bytes = atoll(optarg);
-				if (bytes == 0) {
-					fprintf(stderr,
-						"invalid byte count\n");
-					print_usage();
-				}
+				bytes = arg_strtou64(optarg);
 				break;
 			case 'e':
 				extent_rec = 1;
@@ -849,33 +839,16 @@ int main(int ac, char **av)
 			case 'U':
 				chunk_tree = 1;
 			case 'i':
-				inode = atoll(optarg);
-				if (inode == 0) {
-					fprintf(stderr,
-						"invalid inode number\n");
-					print_usage();
-				}
+				inode = arg_strtou64(optarg);
 				break;
 			case 'f':
 				strncpy(field, optarg, FIELD_BUF_LEN);
 				break;
 			case 'x':
-				errno = 0;
-				file_extent = atoll(optarg);
-				if (errno) {
-					fprintf(stderr, "error converting "
-						"%d\n", errno);
-					print_usage();
-				}
+				file_extent = arg_strtou64(optarg);
 				break;
 			case 'm':
-				errno = 0;
-				metadata_block = atoll(optarg);
-				if (errno) {
-					fprintf(stderr, "error converting "
-						"%d\n", errno);
-					print_usage();
-				}
+				metadata_block = arg_strtou64(optarg);
 				break;
 			case 'K':
 				ret = sscanf(optarg, "%llu,%u,%llu",
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index f37de9d..8ae7270 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -162,7 +162,7 @@ int main(int ac, char **av)
 				root_backups = 1;
 				break;
 			case 'b':
-				block_only = atoll(optarg);
+				block_only = arg_strtou64(optarg);
 				break;
 			default:
 				print_usage();
diff --git a/btrfs-image.c b/btrfs-image.c
index 1b2831a..1fc641f 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2463,8 +2463,8 @@ int main(int argc, char *argv[])
 {
 	char *source;
 	char *target;
-	int num_threads = 0;
-	int compress_level = 0;
+	u64 num_threads = 0;
+	u64 compress_level = 0;
 	int create = 1;
 	int old_restore = 0;
 	int walk_trees = 0;
@@ -2483,13 +2483,13 @@ int main(int argc, char *argv[])
 			create = 0;
 			break;
 		case 't':
-			num_threads = atoi(optarg);
-			if (num_threads <= 0 || num_threads > 32)
+			num_threads = arg_strtou64(optarg);
+			if (num_threads > 32)
 				print_usage();
 			break;
 		case 'c':
-			compress_level = atoi(optarg);
-			if (compress_level < 0 || compress_level > 9)
+			compress_level = arg_strtou64(optarg);
+			if (compress_level > 9)
 				print_usage();
 			break;
 		case 'o':
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 51179a3..a907e4d 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -31,6 +31,7 @@
 #include "transaction.h"
 #include "list.h"
 #include "version.h"
+#include "utils.h"
 
 /* we write the mirror info to stdout unless they are dumping the data
  * to stdout
@@ -38,7 +39,7 @@
 static FILE *info_file;
 
 static struct extent_buffer * debug_read_block(struct btrfs_root *root,
-		u64 bytenr, u32 blocksize, int copy)
+		u64 bytenr, u32 blocksize, u64 copy)
 {
 	int ret;
 	struct extent_buffer *eb;
@@ -120,7 +121,7 @@ int main(int ac, char **av)
 	u64 logical = 0;
 	int ret = 0;
 	int option_index = 0;
-	int copy = 0;
+	u64 copy = 0;
 	u64 bytes = 0;
 	int out_fd = 0;
 
@@ -132,28 +133,13 @@ int main(int ac, char **av)
 			break;
 		switch(c) {
 			case 'l':
-				logical = atoll(optarg);
-				if (logical == 0) {
-					fprintf(stderr,
-						"invalid extent number\n");
-					print_usage();
-				}
+				logical = arg_strtou64(optarg);
 				break;
 			case 'c':
-				copy = atoi(optarg);
-				if (copy == 0) {
-					fprintf(stderr,
-						"invalid copy number\n");
-					print_usage();
-				}
+				copy = arg_strtou64(optarg);
 				break;
 			case 'b':
-				bytes = atoll(optarg);
-				if (bytes == 0) {
-					fprintf(stderr,
-						"invalid byte count\n");
-					print_usage();
-				}
+				bytes = arg_strtou64(optarg);
 				break;
 			case 'o':
 				output_file = strdup(optarg);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index f0c8e3d..cd9d2c6 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -120,7 +120,7 @@ static int cmd_inode_resolve(int argc, char **argv)
 		return 1;
 	}
 
-	ret = __ino_to_path_fd(atoll(argv[optind]), fd, verbose,
+	ret = __ino_to_path_fd(arg_strtou64(argv[optind]), fd, verbose,
 			       argv[optind+1]);
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
@@ -167,7 +167,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 			verbose = 1;
 			break;
 		case 's':
-			size = atoll(optarg);
+			size = arg_strtou64(optarg);
 			break;
 		default:
 			usage(cmd_logical_resolve_usage);
@@ -183,7 +183,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 		return 1;
 
 	memset(inodes, 0, sizeof(*inodes));
-	loi.logical = atoll(argv[optind]);
+	loi.logical = arg_strtou64(argv[optind]);
 	loi.size = size;
 	loi.inodes = (uintptr_t)inodes;
 
@@ -283,7 +283,7 @@ static int cmd_subvolid_resolve(int argc, char **argv)
 		goto out;
 	}
 
-	subvol_id = atoll(argv[1]);
+	subvol_id = arg_strtou64(argv[1]);
 	ret = btrfs_subvolid_resolve(fd, path, sizeof(path), subvol_id);
 
 	if (ret) {
-- 
1.8.3.1

