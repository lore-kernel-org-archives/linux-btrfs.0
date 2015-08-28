Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbH1OLs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 10:11:48 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, kreijack@inwind.it
Subject: [PATCH] btrfs-progs: fix is_block_device() return checks
Date: Fri, 28 Aug 2015 22:11:30 +0800
Message-Id: <1440771090-338-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

it was highlighted to me is_block_device(), returns
 1 if the file is a block device,
 < 0 in case of an error (eg: file not found)
 0 otherwise

This patch makes proper return checks at all the places
where is_block_device() is used. Thanks to Goffredo.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Suggested-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-device.c | 6 +++---
 mkfs.c        | 6 +++---
 utils.c       | 7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index eb4358d..e9f17bd 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -170,7 +170,7 @@ static int _cmd_rm_dev(int argc, char **argv, const char * const *usagestr)
 		if (is_numerical(argv[i])) {
 			argv3.devid = arg_strtou64(argv[i]);
 			its_num = true;
-		} else if (is_block_device(argv[i])) {
+		} else if (is_block_device(argv[i]) == 1) {
 			strncpy_null(argv3.name, argv[i]);
 		} else {
 			fprintf(stderr,
@@ -290,7 +290,7 @@ static int cmd_scan_dev(int argc, char **argv)
 	for( i = devstart ; i < argc ; i++ ){
 		char *path;
 
-		if (!is_block_device(argv[i])) {
+		if (is_block_device(argv[i]) != 1) {
 			fprintf(stderr,
 				"ERROR: %s is not a block device\n", argv[i]);
 			ret = 1;
@@ -348,7 +348,7 @@ static int cmd_ready_dev(int argc, char **argv)
 		goto out;
 	}
 
-	if (!is_block_device(path)) {
+	if (is_block_device(path) != 1) {
 		fprintf(stderr,
 			"ERROR: %s is not a block device\n", path);
 		ret = 1;
diff --git a/mkfs.c b/mkfs.c
index b60fc5a..faef748 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1357,7 +1357,7 @@ int main(int ac, char **av)
 	
 	while (dev_cnt-- > 0) {
 		file = av[optind++];
-		if (is_block_device(file))
+		if (is_block_device(file) == 1)
 			if (test_dev_for_mkfs(file, force_overwrite))
 				exit(1);
 	}
@@ -1592,7 +1592,7 @@ int main(int ac, char **av)
 
 	trans = btrfs_start_transaction(root, 1);
 
-	if (is_block_device(file))
+	if (is_block_device(file) == 1)
 		btrfs_register_one_device(file);
 
 	if (dev_cnt == 0)
@@ -1642,7 +1642,7 @@ int main(int ac, char **av)
 				(unsigned long long)device->devid);
 		}
 
-		if (is_block_device(file))
+		if (is_block_device(file) == 1)
 			btrfs_register_one_device(file);
 	}
 
diff --git a/utils.c b/utils.c
index 39b295a..479b97a 100644
--- a/utils.c
+++ b/utils.c
@@ -1063,7 +1063,8 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 	char mp[PATH_MAX];
 	int fdmnt;
 
-	if (is_block_device(path)) {
+	fdmnt = is_block_device(path);
+	if (fdmnt == 1) {
 		int ret;
 
 		ret = get_btrfs_mount(path, mp, sizeof(mp));
@@ -1073,7 +1074,7 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 			return -1;
 		}
 		fdmnt = open_file_or_dir(mp, dirstream);
-	} else {
+	} else if (fdmnt == 0) {
 		fdmnt = open_file_or_dir(path, dirstream);
 	}
 
@@ -2061,7 +2062,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 
 	memset(fi_args, 0, sizeof(*fi_args));
 
-	if (is_block_device(path)) {
+	if (is_block_device(path) == 1) {
 		struct btrfs_super_block *disk_super;
 		char buf[BTRFS_SUPER_INFO_SIZE];
 		u64 devid;
-- 
2.4.1

