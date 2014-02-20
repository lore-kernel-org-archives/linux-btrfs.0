Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32122 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBTBcw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 20:32:52 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K1Wg0b006794
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 09:32:47 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] Btrfs-progs: switch to arg_strtou64() part3
Date: Thu, 20 Feb 2014 09:30:52 +0800
Message-Id: <1392859852-15829-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch to new helper arg_strtou64(), also check if user assign
a valid super copy.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-select-super.c | 12 +++++++++---
 btrfs-show-super.c   | 10 +++++-----
 btrfstune.c          |  4 ++--
 cmds-check.c         | 14 ++++++++++----
 cmds-replace.c       |  7 +------
 cmds-subvolume.c     |  8 ++------
 6 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 6a458b8..15e6921 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -43,7 +43,7 @@ int main(int ac, char **av)
 {
 	struct btrfs_root *root;
 	int ret;
-	int num = 0;
+	u64 num = 0;
 	u64 bytenr = 0;
 
 	while(1) {
@@ -53,8 +53,14 @@ int main(int ac, char **av)
 			break;
 		switch(c) {
 			case 's':
-				num = atol(optarg);
-				bytenr = btrfs_sb_offset(num);
+				num = arg_strtou64(optarg);
+				if (num >= BTRFS_SUPER_MIRROR_MAX) {
+					fprintf(stderr,
+						"ERROR: super mirror should be less than: %d\n",
+						BTRFS_SUPER_MIRROR_MAX);
+					exit(1);
+				}
+				bytenr = btrfs_sb_offset(((int)num));
 				break;
 			default:
 				print_usage();
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index b87f16a..d4df0ac 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -59,17 +59,17 @@ int main(int argc, char **argv)
 	int all = 0;
 	char *filename;
 	int fd = -1;
-	int arg, i;
+	int i;
+	u64 arg;
 	u64 sb_bytenr = btrfs_sb_offset(0);
 
 	while ((opt = getopt(argc, argv, "ai:")) != -1) {
 		switch (opt) {
 		case 'i':
-			arg = atoi(optarg);
-
-			if (arg < 0 || arg >= BTRFS_SUPER_MIRROR_MAX) {
+			arg = arg_strtou64(optarg);
+			if (arg >= BTRFS_SUPER_MIRROR_MAX) {
 				fprintf(stderr,
-					"Illegal super_mirror %d\n",
+					"Illegal super_mirror %llu\n",
 					arg);
 				print_usage();
 				exit(1);
diff --git a/btrfstune.c b/btrfstune.c
index da82f36..855427f 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -111,7 +111,7 @@ int main(int argc, char *argv[])
 	int success = 0;
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
-	int seeding_value = 0;
+	u64 seeding_value = 0;
 	int skinny_flag = 0;
 	int ret;
 
@@ -123,7 +123,7 @@ int main(int argc, char *argv[])
 		switch(c) {
 		case 'S':
 			seeding_flag = 1;
-			seeding_value = atoi(optarg);
+			seeding_value = arg_strtou64(optarg);
 			break;
 		case 'r':
 			extrefs_flag = 1;
diff --git a/cmds-check.c b/cmds-check.c
index 61c1815..a2afae6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6388,7 +6388,7 @@ int cmd_check(int argc, char **argv)
 	u64 bytenr = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
-	int num;
+	u64 num;
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int init_extent_tree = 0;
@@ -6407,9 +6407,15 @@ int cmd_check(int argc, char **argv)
 				ctree_flags |= OPEN_CTREE_BACKUP_ROOT;
 				break;
 			case 's':
-				num = atol(optarg);
-				bytenr = btrfs_sb_offset(num);
-				printf("using SB copy %d, bytenr %llu\n", num,
+				num = arg_strtou64(optarg);
+				if (num >= BTRFS_SUPER_MIRROR_MAX) {
+					fprintf(stderr,
+						"ERROR: super mirror should be less than: %d\n",
+						BTRFS_SUPER_MIRROR_MAX);
+					exit(1);
+				}
+				bytenr = btrfs_sb_offset(((int)num));
+				printf("using SB copy %llu, bytenr %llu\n", num,
 				       (unsigned long long)bytenr);
 				break;
 			case '?':
diff --git a/cmds-replace.c b/cmds-replace.c
index c683d6c..01ab77c 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -210,12 +210,7 @@ static int cmd_start_replace(int argc, char **argv)
 		struct btrfs_ioctl_fs_info_args fi_args;
 		struct btrfs_ioctl_dev_info_args *di_args = NULL;
 
-		if (atoi(srcdev) == 0) {
-			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
-				srcdev);
-			goto leave_with_error;
-		}
-		start_args.start.srcdevid = (__u64)atoi(srcdev);
+		start_args.start.srcdevid = arg_strtou64(srcdev);
 
 		ret = get_fs_info(path, &fi_args, &di_args);
 		if (ret) {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0bd76f2..5e821c7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -820,11 +820,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 	subvolid = argv[1];
 	path = argv[2];
 
-	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
-	if (errno == ERANGE) {
-		fprintf(stderr, "ERROR: invalid tree id (%s)\n", subvolid);
-		return 1;
-	}
+	objectid = arg_strtou64(subvolid);
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -861,7 +857,7 @@ static int cmd_find_new(int argc, char **argv)
 		usage(cmd_find_new_usage);
 
 	subvol = argv[1];
-	last_gen = atoll(argv[2]);
+	last_gen = arg_strtou64(argv[2]);
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
-- 
1.8.3.1

