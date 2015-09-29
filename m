Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38709 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbI2WEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 18:04:08 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/2] btrfs-progs: device delete to accept devid
Date: Wed, 30 Sep 2015 06:03:42 +0800
Message-Id: <1443564222-1641-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces new option <devid> for the command

  btrfs device delete <device_path|devid>[..]  <mnt>

In a user reported issue on a 3-disk-RAID1, one disk failed with its
SB unreadable. Now with this patch user will have a choice to delete
the device using devid.

The other method we could do, is to match the input device_path
to the available device_paths with in the kernel. But that won't
work in all the cases, like what if user provided mapper path
when the path within the kernel is a non-mapper path.

This patch depends on the below kernel patch for the new feature to work,
however it will fail-back to the old interface for the kernel without the
patch

  Btrfs: device delete by devid

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: update the missed Documentation for delete (not just remove) as well.
        Thanks to Goffredo.

 Documentation/btrfs-device.asciidoc |  4 ++--
 cmds-device.c                       | 45 ++++++++++++++++++++++++++++---------
 ioctl.h                             |  8 +++++++
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 2827598..bd878f4 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -74,10 +74,10 @@ do not perform discard by default
 -f|--force::::
 force overwrite of existing filesystem on the given disk(s)
 
-*remove* <dev> [<dev>...] <path>::
+*remove* <dev>|<devid> [<dev>|<devid>...] <path>::
 Remove device(s) from a filesystem identified by <path>.
 
-*delete* <dev> [<dev>...] <path>::
+*delete* <dev>|<devid> [<dev>|<devid>...] <path>::
 Alias of remove kept for backwards compatability
 
 *ready* <device>::
diff --git a/cmds-device.c b/cmds-device.c
index 2bb6bcb..4416d00 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -163,16 +163,34 @@ static int _cmd_device_remove(int argc, char **argv,
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		if (!is_block_device(argv[i])) {
+		struct  btrfs_ioctl_vol_args_v3 argv3 = {0};
+		int     its_num = false;
+
+		if (is_numerical(argv[i])) {
+			argv3.devid = arg_strtou64(argv[i]);
+			its_num = true;
+		} else if (is_block_device(argv[i])) {
+			strncpy_null(argv3.name, argv[i]);
+		} else {
 			fprintf(stderr,
-				"ERROR: %s is not a block device\n", argv[i]);
+				"ERROR: %s is not a block device or devid\n", argv[i]);
 			ret++;
 			continue;
 		}
-		memset(&arg, 0, sizeof(arg));
-		strncpy_null(arg.name, argv[i]);
-		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV_V2, &argv3);
 		e = errno;
+		if (res && e == ENOTTY) {
+			if (its_num) {
+				fprintf(stderr,
+				"Error: Kernel does not support delete by devid\n");
+				ret = 1;
+				continue;
+			}
+			memset(&arg, 0, sizeof(arg));
+			strncpy_null(arg.name, argv[i]);
+			res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+			e = errno;
+		}
 		if (res) {
 			const char *msg;
 
@@ -180,9 +198,16 @@ static int _cmd_device_remove(int argc, char **argv,
 				msg = btrfs_err_str(res);
 			else
 				msg = strerror(e);
-			fprintf(stderr,
-				"ERROR: error removing the device '%s' - %s\n",
-				argv[i], msg);
+
+			if (its_num)
+				fprintf(stderr,
+					"ERROR: error removing the devid '%llu' - %s\n",
+					argv3.devid, msg);
+			else
+				fprintf(stderr,
+					"ERROR: error removing the device '%s' - %s\n",
+					argv[i], msg);
+
 			ret++;
 		}
 	}
@@ -192,7 +217,7 @@ static int _cmd_device_remove(int argc, char **argv,
 }
 
 static const char * const cmd_device_remove_usage[] = {
-	"btrfs device remove <device> [<device>...] <path>",
+	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
@@ -203,7 +228,7 @@ static int cmd_device_remove(int argc, char **argv)
 }
 
 static const char * const cmd_device_delete_usage[] = {
-	"btrfs device delete <device> [<device>...] <path>",
+	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
diff --git a/ioctl.h b/ioctl.h
index dff015a..6870931 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -40,6 +40,12 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+struct btrfs_ioctl_vol_args_v3 {
+	__s64 fd;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+	__u64 devid;
+};
+
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
@@ -683,6 +689,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_vol_args_v3)
 #ifdef __cplusplus
 }
 #endif
-- 
2.4.1

