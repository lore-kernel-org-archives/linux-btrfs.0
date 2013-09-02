Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37658 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3IBCtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 22:49:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH] btrfs-progs: replace fails start but in the background v2
Date: Mon,  2 Sep 2013 10:55:48 +0800
Message-Id: <1378090548-12719-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1377090643-23658-2-git-send-email-anand.jain@oracle.com>
References: <1377090643-23658-2-git-send-email-anand.jain@oracle.com>
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

v2:
 fix checkpatch.pl warnings as spotted by Wang

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c  |    4 ++--
 cmds-replace.c |   14 ++++++++++++++
 ioctl.h        |    1 +
 man/btrfs.8.in |    4 ++--
 utils.c        |   15 +++++++++++++++
 utils.h        |    1 +
 6 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 8446502..27f7f84 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -45,7 +45,7 @@ static const char * const device_cmd_group_usage[] = {
 };
 
 static const char * const cmd_add_dev_usage[] = {
-	"btrfs device add <device> [<device>...] <path>",
+	"btrfs device add [-f] <device> [<device>...] <path>",
 	"Add a device to a filesystem",
 	NULL
 };
@@ -85,7 +85,7 @@ static int cmd_add_dev(int argc, char **argv)
 		int	devfd, res;
 		u64 dev_block_count = 0;
 		int mixed = 0;
-
+printf("asj: add %s\n", argv[i]);
 		res = test_dev_for_mkfs(argv[i], force, estr);
 		if (res) {
 			fprintf(stderr, "%s", estr);
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
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d493d7e..0cca5c3 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -47,7 +47,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fB[filesystem] balance status\fP [-v] \fI<path>\fP
 .PP
 .PP
-\fBbtrfs\fP \fBdevice add\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
+\fBbtrfs\fP \fBdevice add\fP [-f] \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
@@ -386,7 +386,7 @@ be verbose
 .RE
 .TP
 
-\fBdevice add\fR\fI <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
+\fBdevice add\fR [-f] \fI <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
 
diff --git a/utils.c b/utils.c
index b039a03..c53b7f1 100644
--- a/utils.c
+++ b/utils.c
@@ -1993,3 +1993,18 @@ int is_vol_small(char *file)
 		return 0;
 	}
 }
+
+/* Returns:
+ * BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
+ *	If the device is locked to prevent other device operations
+ *	from the user cli like device add remove replace balance etc..
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

