Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42125 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HUNE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 09:04:26 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7LD4PCp018236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:26 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7LD4O5k029558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:25 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7LD4OnB006313
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 13:04:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: replace fails start but in the background
Date: Wed, 21 Aug 2013 21:10:43 +0800
Message-Id: <1377090643-23658-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1377090643-23658-1-git-send-email-anand.jain@oracle.com>
References: <1377090643-23658-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when the balance is running, the replace start ioctl
fails (for the right reasons). but since the cli has
put ioctl thread to background (for right reasons)
the user won't know that cli failed to start.

so before cli goes to the background, it should check
if mutually_exclusive_operation_running is not held.

this is done by newly introduced ioctl
 BTRFS_IOC_CHECK_DEV_EXCL_OPS by the following kernel patch:

btrfs: introduce BTRFS_IOC_CHECK_DEV_EXCL_OPS ioctl to check dev excl op

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c |   14 ++++++++++++++
 ioctl.h        |    1 +
 utils.c        |   15 +++++++++++++++
 utils.h        |    1 +
 4 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index e3ff695..0b2cbc8 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -203,6 +203,20 @@ static int cmd_start_replace(int argc, char **argv)
 		goto leave_with_error;
 	}
 
+	/* check if there is some other device exclusive
+	 * operation running in the FS which won't let this replace
+	 * to run. And ENOTTY is when older kernel doesn't support
+	 * lock checking ioctl
+	 */
+	ret = is_dev_excl_op_free(fdmnt);
+	if (ret && ret != -ENOTTY) {
+		fprintf(stderr,
+			"ERROR: replace start failed on \"%s\" - %s\n",
+			path,
+			ret > 0 ? btrfs_err_str(ret) : strerror(-ret));
+		goto leave_with_error;
+	}
+
 	srcdev = argv[optind];
 	dstdev = argv[optind + 1];
 
diff --git a/ioctl.h b/ioctl.h
index e959720..afadcbc 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -598,6 +598,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_DEDUP_CTL _IOW(BTRFS_IOCTL_MAGIC, 55, int)
+#define BTRFS_IOC_CHECK_DEV_EXCL_OPS _IO(BTRFS_IOCTL_MAGIC, 56)
 
 #ifdef __cplusplus
 }
diff --git a/utils.c b/utils.c
index 422530d..f0f7719 100644
--- a/utils.c
+++ b/utils.c
@@ -1992,3 +1992,18 @@ int is_vol_small(char *file)
 		return 0;
 	}
 }
+
+/* Returns:
+ * BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
+ *	If the device is locked to prevent other device operations
+ * 	from the user cli like device add remove replace balance etc..
+ * < 0:
+ *	For any other error including if kernel don't support the
+ *	ioctl (-ENOTTY)
+ */
+int is_dev_excl_op_free(int fd)
+{
+	int ret;
+	ret = ioctl(fd, BTRFS_IOC_CHECK_DEV_EXCL_OPS, NULL);
+	return ret > 0 ? ret : -errno;
+}
diff --git a/utils.h b/utils.h
index eb6fba3..a1e5d67 100644
--- a/utils.h
+++ b/utils.h
@@ -83,4 +83,5 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int is_vol_small(char *file);
+int is_dev_excl_op_free(int fd);
 #endif
-- 
1.7.1

