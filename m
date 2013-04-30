Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22952 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625Ab3D3NRa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 09:17:30 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3UDHTCN021656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:17:30 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3UDHSQW012535
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:17:29 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3UDHSIl012518
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 13:17:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: device delete to get errors from the kernel
Date: Tue, 30 Apr 2013 21:19:41 +0800
Message-Id: <1367327981-28000-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
References: <517FC485.3080208@oracle.com>
 <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1->v2:
introduce error codes for the device mgmt usage

v1:
add another parameter to the ioctl arg structure to carry the error string

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 10 ++++++++--
 ioctl.h       | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..bc81937 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -163,8 +163,14 @@ static int cmd_rm_dev(int argc, char **argv)
 		strncpy_null(arg.name, argv[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
-		if(res<0){
-			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
+		if (res > 0) {
+			fprintf(stderr,
+				"ERROR: error removing the device '%s' - %s\n",
+				argv[i], btrfs_err_str(res));
+			ret++;
+		} else if (res < 0) {
+			fprintf(stderr,
+				"ERROR: error removing the device '%s' - %s\n",
 				argv[i], strerror(e));
 			ret++;
 		}
diff --git a/ioctl.h b/ioctl.h
index 1ee631a..63d5831 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -537,6 +537,43 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
 
+enum btrfs_err_code {
+	notused,
+	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_TGT_REPLACE,
+	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
+	BTRFS_ERROR_DEV_ONLY_WRITABLE,
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+};
+
+static inline char *btrfs_err_str(enum btrfs_err_code err_code)
+{
+	switch (err_code) {
+		case BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET:
+			return "unable to go below two devices on raid1";
+		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
+			return "unable to go below four devices on raid10";
+		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
+			return "unable to go below two devices on raid5";
+		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
+			return "unable to go below three devices on raid6";
+		case BTRFS_ERROR_DEV_TGT_REPLACE:
+			return "unable to remove the dev_replace target dev";
+		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
+			return "no missing devices found to remove";
+		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
+			return "unable to remove the only writeable device";
+		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
+			return "add/delete/balance/replace/resize operation "\
+				"in progress";
+		default:
+			return NULL;
+	}
+}
+
 #ifdef __cplusplus
 }
 #endif
-- 
1.8.1.227.g44fe835

