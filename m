Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3DZJjY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 05:39:24 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3Q9dNmq024982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:24 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9dMwT019713
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:22 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9dMG4006716
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:39:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: device delete to get errors from the kernel
Date: Fri, 26 Apr 2013 17:41:14 +0800
Message-Id: <1366969275-3036-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <517A4B44.5060608@oracle.com>
References: <517A4B44.5060608@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add another parameter to the ioctl arg structure to carry the error string

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 13 +++++++++----
 ioctl.h       |  9 ++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..3cf96db 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -157,15 +157,20 @@ static int cmd_rm_dev(int argc, char **argv)
 	}
 
 	for(i=1 ; i < argc - 1; i++ ){
-		struct	btrfs_ioctl_vol_args arg;
+		struct	btrfs_ioctl_dev_args arg;
 		int	res;
 
+		memset(&arg, 0, sizeof(arg));
 		strncpy_null(arg.name, argv[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
-		if(res<0){
-			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
-				argv[i], strerror(e));
+		if (res < 0) {
+			if (strlen(arg.ret_err_str))
+				fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
+					argv[i], arg.ret_err_str);
+			else
+				fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
+					argv[i], strerror(e));
 			ret++;
 		}
 	}
diff --git a/ioctl.h b/ioctl.h
index 1ee631a..b55bcb7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -36,6 +36,13 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_IOCTL_ERR_LEN 256
+struct btrfs_ioctl_dev_args {
+	__s64 fd;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+	char ret_err_str[BTRFS_IOCTL_ERR_LEN];
+};
+
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
@@ -467,7 +474,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_CLONE        _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #define BTRFS_IOC_ADD_DEV _IOW(BTRFS_IOCTL_MAGIC, 10, \
 				   struct btrfs_ioctl_vol_args)
-#define BTRFS_IOC_RM_DEV _IOW(BTRFS_IOCTL_MAGIC, 11, \
+#define BTRFS_IOC_RM_DEV _IOWR(BTRFS_IOCTL_MAGIC, 11, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
-- 
1.8.1.227.g44fe835

