Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbbDTITz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:19:55 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH 2/2] btrfs-progs: device delete to accept devid
Date: Mon, 20 Apr 2015 18:29:16 +0800
Message-Id: <1429525756-2727-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1429525756-2727-1-git-send-email-anand.jain@oracle.com>
References: <1429525756-2727-1-git-send-email-anand.jain@oracle.com>
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
 Documentation/btrfs-device.txt |  2 +-
 cmds-device.c                  | 47 ++++++++++++++++++++++++++++++++----------
 ioctl.h                        |  8 +++++++
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 66be6b3..4bb5ea5 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -74,7 +74,7 @@ do not perform discard by default
 -f|--force::::
 force overwrite of existing filesystem on the given disk(s)
 
-*delete* <dev> [<dev>...] <path>::
+*delete* <dev>|<devid> [<dev>|<devid>...] <path>::
 Remove device(s) from a filesystem identified by <path>.
 
 *ready* <device>::
diff --git a/cmds-device.c b/cmds-device.c
index 1c32771..69e79d4 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -145,7 +145,7 @@ error_out:
 }
 
 static const char * const cmd_rm_dev_usage[] = {
-	"btrfs device delete <device> [<device>...] <path>",
+	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
@@ -169,26 +169,51 @@ static int cmd_rm_dev(int argc, char **argv)
 
 	for(i=1 ; i < argc - 1; i++ ){
 		struct	btrfs_ioctl_vol_args arg;
+		struct	btrfs_ioctl_vol_args_v3 argv3 = {0};
 		int	res;
+		int 	its_num = false;
 
-		if (!is_block_device(argv[i])) {
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
-		strncpy_null(arg.name, argv[i]);
-		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV_V2, &argv3);
 		e = errno;
+		if (res && e == ENOTTY) {
+			if (its_num) {
+				fprintf(stderr, "Error: Kernel does not support delete by devid\n");
+				continue;
+			}
+			strncpy_null(arg.name, argv[i]);
+			res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+			e = errno;
+		}
 		if (res > 0) {
-			fprintf(stderr,
-				"ERROR: error removing the device '%s' - %s\n",
-				argv[i], btrfs_err_str(res));
+			if (its_num)
+				fprintf(stderr,
+					"ERROR: removing the devid '%llu' - %s\n",
+					argv3.devid, btrfs_err_str(res));
+			else
+				fprintf(stderr,
+					"ERROR: removing the device '%s' - %s\n",
+					argv[i], btrfs_err_str(res));
 			ret++;
 		} else if (res < 0) {
-			fprintf(stderr,
-				"ERROR: ioctl error removing the device '%s' - %s\n",
-				argv[i], strerror(e));
+			if (its_num)
+				fprintf(stderr,
+					"ERROR: ioctl removing the devid '%llu' - %s\n",
+					argv3.devid, strerror(e));
+			else
+				fprintf(stderr,
+					"ERROR: ioctl removing the device '%s' - %s\n",
+					argv[i], strerror(e));
 			ret++;
 		}
 	}
diff --git a/ioctl.h b/ioctl.h
index d550ca6..4354c37 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -37,6 +37,12 @@ struct btrfs_ioctl_vol_args {
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
@@ -621,6 +627,8 @@ struct btrfs_ioctl_clone_range_args {
                                   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_vol_args_v3)
 #ifdef __cplusplus
 }
 #endif
-- 
2.0.0.153.g79dcccc

