Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24863 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbcCIKKj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 05:10:39 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V4 2/2] btrfs-progs: Introduce device delete by devid
Date: Wed,  9 Mar 2016 18:10:26 +0800
Message-Id: <1457518226-601-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch introduces new option <devid> for the command

  btrfs device delete <device_path|devid>[..]  <mnt>

In a user reported issue on a 3-disk-RAID1, one disk failed with its SB
unreadable. Now with this patch user will have a choice to delete the
device using devid.

The other method we could do, is to match the input device_path to the
available device_paths with in the kernel. But that won't work in all the
cases, like what if user provided mapper path when the path within the
kernel is a non-mapper path.

This patch depends on the below kernel patch for the new feature to work,
however it will fail-back to the old interface for the kernel without the
patch

  Btrfs: Introduce device delete by devid

Signed-off-by: Anand Jain <anand.jain@oracle.com>
[ coding style fixes ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
v4: a. For future benefit we should check for EOPNOTSUPP as well.
    b. Update the changes to be inline with kernel that is
       BTRFS_DEVICE_SPEC_BY_ID and BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED
       naming changes. and
    (c. As I didn't see progs patch matching with the kernel naming
       changes in the ML.)

v3: enahnced btrfs_ioctl_vol_args_v2 to accept devid instead of
    creating a new structure. Thanks to David.
    Changed subject from
      btrfs-progs: device delete to accept devid

v2: update the missed Documentation for delete (not just remove) as well.
    Thanks to Goffredo.
 Documentation/btrfs-device.asciidoc |  4 +--
 cmds-device.c                       | 52 ++++++++++++++++++++++++++++++-------
 ioctl.h                             | 15 ++++++++++-
 3 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 2827598a37f5..bd878f4c33e1 100644
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
index 50c1c5dfb394..fcb2735e18ce 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -158,19 +158,45 @@ static int _cmd_device_remove(int argc, char **argv,
 	for(i=1 ; i < argc - 1; i++ ){
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
-
-		if (is_block_device(argv[i]) != 1 && strcmp(argv[i], "missing")) {
-			error("not a block device: %s", argv[i]);
+		struct btrfs_ioctl_vol_args_v2 argv2 = {0};
+		int is_devid = 0;
+
+		if (string_is_numerical(argv[i])) {
+			argv2.devid = arg_strtou64(argv[i]);
+			argv2.flags = BTRFS_DEVICE_SPEC_BY_ID;
+			is_devid = 1;
+		} else if (is_block_device(argv[i]) == 1
+				|| strcmp(argv[i], "missing") == 0) {
+			strncpy_null(argv2.name, argv[i]);
+		} else {
+			fprintf(stderr,
+				"ERROR: %s is not a block device or devid\n",
+				argv[i]);
 			ret++;
 			continue;
 		}
-		memset(&arg, 0, sizeof(arg));
-		strncpy_null(arg.name, argv[i]);
 		/*
 		 * Positive values are from BTRFS_ERROR_DEV_*,
 		 * otherwise it's a generic error, one of errnos
 		 */
-		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV_V2, &argv2);
+
+		/*
+		 * if BTRFS_IOC_RM_DEV_V2 is not supported we get ENOTTY and if
+		 * argv2.flags includes a flag which kernel don't understand then
+		 * we shall get EOPNOTSUPP
+		 */
+		if (res && (errno == EOPNOTSUPP || errno == ENOTTY)) {
+			if (is_devid) {
+				fprintf(stderr,
+				"ERROR: kernel does not support delete by devid\n");
+				ret = -EOPNOTSUPP;
+				continue;
+			}
+			memset(&arg, 0, sizeof(arg));
+			strncpy_null(arg.name, argv[i]);
+			res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		}
 		if (res) {
 			const char *msg;
 
@@ -178,8 +204,14 @@ static int _cmd_device_remove(int argc, char **argv,
 				msg = btrfs_err_str(res);
 			else
 				msg = strerror(errno);
-			error("error removing device '%s': %s",
-				argv[i], msg);
+
+			if (is_devid) {
+				error("error removing devid '%llu': %s",
+					(unsigned long long)argv2.devid, msg);
+			} else {
+				error("error removing device '%s': %s",
+								argv[i], msg);
+			}
 			ret++;
 		}
 	}
@@ -189,7 +221,7 @@ static int _cmd_device_remove(int argc, char **argv,
 }
 
 static const char * const cmd_device_remove_usage[] = {
-	"btrfs device remove <device> [<device>...] <path>",
+	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
@@ -200,7 +232,7 @@ static int cmd_device_remove(int argc, char **argv)
 }
 
 static const char * const cmd_device_delete_usage[] = {
-	"btrfs device delete <device> [<device>...] <path>",
+	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
diff --git a/ioctl.h b/ioctl.h
index 771da23160f3..9912a2bc98c7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -45,6 +45,14 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+#define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
+
+#define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
+			(BTRFS_SUBVOL_CREATE_ASYNC |	\
+			BTRFS_SUBVOL_RDONLY |		\
+			BTRFS_SUBVOL_QGROUP_INHERIT |	\
+			BTRFS_DEVICE_SPEC_BY_ID)
+
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
@@ -84,7 +92,10 @@ struct btrfs_ioctl_vol_args_v2 {
 		};
 		__u64 unused[4];
 	};
-	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+	union {
+		char name[BTRFS_SUBVOL_NAME_MAX + 1];
+		u64 devid;
+	};
 };
 
 /*
@@ -709,6 +720,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_vol_args_v2)
 #ifdef __cplusplus
 }
 #endif
-- 
2.7.0

