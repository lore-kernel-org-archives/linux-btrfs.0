Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26652 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3EQKul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:50:41 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HAoc43022462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:50:39 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAodqe002703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:50:39 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAociF004071
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:50:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs-progs: device delete to get errors from the kernel
Date: Fri, 17 May 2013 18:53:31 +0800
Message-Id: <1368788011-12006-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1367327981-28000-2-git-send-email-anand.jain@oracle.com>
References: <1367327981-28000-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when user runs command btrfs dev del the raid requisite error if any
goes to the /var/log/messages, its not good idea to clutter messages
with these user (knowledge) errors, further user don't have to review
the system messages to know problem with the cli it should be dropped
to the user as part of the cli return.

to bring this feature created a set of the ERROR defined
BTRFS_ERROR_DEV* error codes and created their error string.

I expect this enum to be added with other error which we might
want to communicate to the user land

v3:
moved the code with in the file no logical change

v1->v2:
introduce error codes for the device mgmt usage

v1:
add another parameter to the ioctl arg structure to carry the error string

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 10 ++++++++--
 ioctl.h       | 43 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 3 deletions(-)

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
index 1ee631a..897dd26 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -441,6 +441,48 @@ struct btrfs_ioctl_qgroup_create_args {
 	__u64 create;
 	__u64 qgroupid;
 };
+
+/* Error codes as returned by the kernel */
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
+/* An error code to error string mapping for the kernel
+*  error codes
+*/
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
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -536,7 +578,6 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
-
 #ifdef __cplusplus
 }
 #endif
-- 
1.8.1.227.g44fe835

