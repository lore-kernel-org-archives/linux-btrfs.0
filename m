Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43394 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3GOF0K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 04/11] btrfs-progs: congregate dev scan
Date: Mon, 15 Jul 2013 13:30:50 +0800
Message-Id: <1373866257-10519-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

the dev scan to find btrfs is performed at two locations
all most the same way one at filesystem show and another
at device scan. They both follow the same steps. This
patch does not alter anything except that it brings these
two same logic into the function scan_for_btrfs so that
we can play tweaking it.

the patch which recommends to use /dev/mapper
will also need it

v3:
bring in btrfs_scan_for_fsid to use scan_for_btrfs

thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |   11 +++--------
 cmds-filesystem.c |    9 +++------
 utils.c           |   22 ++++++++++++++++++++--
 utils.h           |    5 ++++-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index c94fcd5..59edcb9 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -186,26 +186,21 @@ static const char * const cmd_scan_dev_usage[] = {
 static int cmd_scan_dev(int argc, char **argv)
 {
 	int	i, fd, e;
-	int	checklist = 1;
+	int	where = BTRFS_SCAN_PROC;
 	int	devstart = 1;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
 		if (check_argc_max(argc, 2))
 			usage(cmd_scan_dev_usage);
 
-		checklist = 0;
+		where = BTRFS_SCAN_DEV;
 		devstart += 1;
 	}
 
 	if(argc<=devstart){
-
 		int ret;
-
 		printf("Scanning for Btrfs filesystems\n");
-		if(checklist)
-			ret = btrfs_scan_block_devices(1);
-		else
-			ret = btrfs_scan_one_dir("/dev", 1);
+		ret = scan_for_btrfs(where, 1);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a1a8830..6ef6e6b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -236,21 +236,18 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *cur_uuid;
 	char *search = 0;
 	int ret;
-	int checklist = 1;
+	int where = BTRFS_SCAN_PROC;
 	int searchstart = 1;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		checklist = 0;
+		where = BTRFS_SCAN_DEV;
 		searchstart += 1;
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
 		usage(cmd_show_usage);
 
-	if(checklist)
-		ret = btrfs_scan_block_devices(0);
-	else
-		ret = btrfs_scan_one_dir("/dev", 0);
+	ret = scan_for_btrfs(where, 0);
 
 	if (ret){
 		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
diff --git a/utils.c b/utils.c
index 4f74d78..345bfdc 100644
--- a/utils.c
+++ b/utils.c
@@ -1136,9 +1136,9 @@ int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
 	if (ret)
-		ret = btrfs_scan_one_dir("/dev", run_ioctls);
+		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
 	return ret;
 }
 
@@ -1830,3 +1830,21 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	close(fd);
 	return 0;
 }
+
+/*
+ * scans devs for the btrfs
+*/
+int scan_for_btrfs(int where, int update_kernel)
+{
+	int ret = 0;
+
+	switch (where) {
+	case BTRFS_SCAN_PROC:
+		ret = btrfs_scan_block_devices(update_kernel);
+		break;
+	case BTRFS_SCAN_DEV:
+		ret = btrfs_scan_one_dir("/dev", update_kernel);
+		break;
+	}
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 5e5ea53..bdfa76b 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,9 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
+#define BTRFS_SCAN_PROC	1
+#define BTRFS_SCAN_DEV		2
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
@@ -72,5 +75,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-
+int scan_for_btrfs(int where, int update_kernel);
 #endif
-- 
1.7.7.6

