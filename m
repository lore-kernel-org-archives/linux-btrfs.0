Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29192 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967452Ab3E3DhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:12 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3b9NM029352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:10 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bB2l021573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:11 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3bA9W006784
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6 v2] btrfs-progs: congregate dev scan
Date: Thu, 30 May 2013 11:40:24 +0800
Message-Id: <1369885226-3640-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
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

thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     | 11 +++--------
 cmds-filesystem.c |  9 +++------
 utils.c           | 18 ++++++++++++++++++
 utils.h           |  5 ++++-
 4 files changed, 28 insertions(+), 15 deletions(-)

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
index 25f3cb4..f15136b 100644
--- a/utils.c
+++ b/utils.c
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

