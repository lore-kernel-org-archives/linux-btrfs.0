Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3IMLa0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 07:30:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: replace fails start but in the background
Date: Fri, 13 Sep 2013 19:37:31 +0800
Message-Id: <1379072251-27664-1-git-send-email-anand.jain@oracle.com>
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
 cmds-replace.c | 14 ++++++++++++++
 ioctl.h        |  1 +
 utils.c        | 15 +++++++++++++++
 utils.h        |  1 +
 4 files changed, 31 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index a31d77e..f69c5ce 100644
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
index c0dcc06..7df7fc9 100644
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
index 02a2658..22c3310 100644
--- a/utils.c
+++ b/utils.c
@@ -2004,3 +2004,18 @@ int is_vol_small(char *file)
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
index 616bae1..6952d34 100644
--- a/utils.h
+++ b/utils.h
@@ -85,4 +85,5 @@ int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+int is_dev_excl_op_free(int fd);
 #endif
-- 
1.8.4.rc4.1.g0d8beaa

