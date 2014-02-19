Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaBSLTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 06:19:43 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBJZMF025817
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:19:36 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs-progs: switch to btrfs_strtoull() part3
Date: Wed, 19 Feb 2014 19:17:54 +0800
Message-Id: <1392808674-21656-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 btrfs-show-super.c | 7 ++++---
 btrfstune.c        | 4 ++--
 cmds-replace.c     | 7 +------
 cmds-subvolume.c   | 8 ++------
 4 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index b87f16a..378c7d2 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -59,17 +59,18 @@ int main(int argc, char **argv)
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
+			arg = btrfs_strtoull(optarg, 10);
 
 			if (arg < 0 || arg >= BTRFS_SUPER_MIRROR_MAX) {
 				fprintf(stderr,
-					"Illegal super_mirror %d\n",
+					"Illegal super_mirror %llu\n",
 					arg);
 				print_usage();
 				exit(1);
diff --git a/btrfstune.c b/btrfstune.c
index da82f36..744dec5 100644
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
+			seeding_value = btrfs_strtoull(optarg, 10);
 			break;
 		case 'r':
 			extrefs_flag = 1;
diff --git a/cmds-replace.c b/cmds-replace.c
index c683d6c..3dc6c49 100644
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
+		start_args.start.srcdevid = btrfs_strtoull(srcdev, 10);
 
 		ret = get_fs_info(path, &fi_args, &di_args);
 		if (ret) {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0bd76f2..98470f7 100644
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
+	objectid = btrfs_strtoull(subvolid, 10);
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -861,7 +857,7 @@ static int cmd_find_new(int argc, char **argv)
 		usage(cmd_find_new_usage);
 
 	subvol = argv[1];
-	last_gen = atoll(argv[2]);
+	last_gen = btrfs_strtoull(argv[2], 10);
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
-- 
1.8.3.1

