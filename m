Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38242 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422827Ab3FUHhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:37:16 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7Uvgl007323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:30:58 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7bEEo014222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:37:14 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7bDQk029437
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:37:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/13 v2] btrfs-progs: get_label_mounted to return label instead of print
Date: Fri, 21 Jun 2013 15:41:20 +0800
Message-Id: <1371800480-14320-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-9-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-9-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This would help to reuse the function

v1->v2: removed static and updated .h file, in a preparation
        work for the following patch

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 18 +++++++++++++-----
 utils.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index f9545b8..fc3c41e 100644
--- a/utils.c
+++ b/utils.c
@@ -1313,7 +1313,7 @@ static int get_label_unmounted(const char *dev)
  * mounted path rather than device.  Return the corresponding error
  * the user specified the device path.
  */
-static int get_label_mounted(const char *mount_path)
+int get_label_mounted(const char *mount_path, char *labelp)
 {
 	char label[BTRFS_LABEL_SIZE];
 	int fd;
@@ -1331,16 +1331,24 @@ static int get_label_mounted(const char *mount_path)
 		return -1;
 	}
 
-	fprintf(stdout, "%s\n", label);
+	strncpy(labelp, label, sizeof(label));
 	close(fd);
 	return 0;
 }
 
 int get_label(const char *btrfs_dev)
 {
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		get_label_unmounted(btrfs_dev) :
-		get_label_mounted(btrfs_dev);
+	int ret;
+	char label[BTRFS_LABEL_SIZE];
+
+	if (is_existing_blk_or_reg_file(btrfs_dev))
+		ret = get_label_unmounted(btrfs_dev);
+	else {
+		ret = get_label_mounted(btrfs_dev, label);
+		if (!ret)
+			fprintf(stdout, "%s\n", label);
+	}
+	return ret;
 }
 
 int set_label(const char *btrfs_dev, const char *label)
diff --git a/utils.h b/utils.h
index 733d13b..1fa1c5a 100644
--- a/utils.h
+++ b/utils.h
@@ -69,4 +69,5 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+int get_label_mounted(const char *mount_path, char *labelp);
 #endif
-- 
1.8.1.227.g44fe835

