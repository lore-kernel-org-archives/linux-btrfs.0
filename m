Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34927 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3EaIO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 04:14:29 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4V8ERsJ012807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 08:14:28 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4V8ERpo028400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 08:14:27 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4V8ERnl028395
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 08:14:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6 v3] btrfs-progs: congregate dev scan
Date: Fri, 31 May 2013 16:17:44 +0800
Message-Id: <1369988264-21609-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-5-git-send-email-anand.jain@oracle.com>
References: <1369885226-3640-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 cmds-device.c     | 11 +++--------
 cmds-filesystem.c |  9 +++------
 utils.c           | 22 ++++++++++++++++++++--
 utils.h           |  5 ++++-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index d25159b..b6ecb3b 100644
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
index c6a7100..0d76d58 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -245,21 +245,18 @@ static int cmd_show(int argc, char **argv)
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
index 25f3cb4..6b2344d 100644
--- a/utils.c
+++ b/utils.c
@@ -1114,9 +1114,9 @@ int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
 	if (ret)
-		ret = btrfs_scan_one_dir("/dev", run_ioctls);
+		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
 	return ret;
 }
 
@@ -1806,3 +1806,21 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
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
index dba37e8..78f3a65 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,9 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
+#define BTRFS_SCAN_PROC	1
+#define BTRFS_SCAN_DEV	2
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
@@ -64,5 +67,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-
+int scan_for_btrfs(int where, int update_kernel);
 #endif
-- 
1.8.1.227.g44fe835

