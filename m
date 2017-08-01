Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44589 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbdHARP6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:58 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFv4T012852
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFuEQ014126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFt0h032305
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs-progs: add option to add raid5/6 log device
Date: Tue,  1 Aug 2017 10:14:38 -0600
Message-Id: <20170801161439.13426-16-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces an option for 'btrfs device add' to add a device as
raid5/6 log at run time.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-device.c | 30 +++++++++++++++++++++++++-----
 ioctl.h       |  3 +++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 4337eb2..ec6037e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -45,6 +45,7 @@ static const char * const cmd_device_add_usage[] = {
 	"Add a device to a filesystem",
 	"-K|--nodiscard    do not perform whole device TRIM",
 	"-f|--force        force overwrite existing filesystem on the disk",
+	"-L|--r5log        add a disk as raid56 log",
 	NULL
 };
 
@@ -55,6 +56,7 @@ static int cmd_device_add(int argc, char **argv)
 	DIR	*dirstream = NULL;
 	int discard = 1;
 	int force = 0;
+	int for_r5log = 0;
 	int last_dev;
 
 	while (1) {
@@ -62,10 +64,11 @@ static int cmd_device_add(int argc, char **argv)
 		static const struct option long_options[] = {
 			{ "nodiscard", optional_argument, NULL, 'K'},
 			{ "force", no_argument, NULL, 'f'},
+			{ "r5log", no_argument, NULL, 'L'},
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "Kf", long_options, NULL);
+		c = getopt_long(argc, argv, "KfL", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -75,6 +78,9 @@ static int cmd_device_add(int argc, char **argv)
 		case 'f':
 			force = 1;
 			break;
+		case 'L':
+			for_r5log = 1;
+			break;
 		default:
 			usage(cmd_device_add_usage);
 		}
@@ -83,6 +89,9 @@ static int cmd_device_add(int argc, char **argv)
 	if (check_argc_min(argc - optind, 2))
 		usage(cmd_device_add_usage);
 
+	if (for_r5log && check_argc_max(argc - optind, 2))
+		usage(cmd_device_add_usage);
+
 	last_dev = argc - 1;
 	mntpnt = argv[last_dev];
 
@@ -91,7 +100,6 @@ static int cmd_device_add(int argc, char **argv)
 		return 1;
 
 	for (i = optind; i < last_dev; i++){
-		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
 		char *path;
@@ -126,9 +134,21 @@ static int cmd_device_add(int argc, char **argv)
 			goto error_out;
 		}
 
-		memset(&ioctl_args, 0, sizeof(ioctl_args));
-		strncpy_null(ioctl_args.name, path);
-		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
+		if (!for_r5log) {
+			struct btrfs_ioctl_vol_args ioctl_args;
+
+			memset(&ioctl_args, 0, sizeof(ioctl_args));
+			strncpy_null(ioctl_args.name, path);
+			res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
+		} else {
+			/* apply v2 args format */
+			struct btrfs_ioctl_vol_args_v2 ioctl_args;
+
+			memset(&ioctl_args, 0, sizeof(ioctl_args));
+			strncpy_null(ioctl_args.name, path);
+			ioctl_args.flags |= BTRFS_DEVICE_RAID56_LOG;
+			res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV_V2, &ioctl_args);
+		}
 		if (res < 0) {
 			error("error adding device '%s': %s",
 				path, strerror(errno));
diff --git a/ioctl.h b/ioctl.h
index 709e996..748a7af 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -53,6 +53,7 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
+#define BTRFS_DEVICE_RAID56_LOG		(1ULL << 4)
 
 #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
 			(BTRFS_SUBVOL_CREATE_ASYNC |	\
@@ -828,6 +829,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_ADD_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 59, \
+				   struct btrfs_ioctl_vol_args_v2)
 #ifdef __cplusplus
 }
 #endif
-- 
2.5.0

