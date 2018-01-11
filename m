Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbeAKBZA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 20:25:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0B1CZS6103031
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 01:24:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fdv65raat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 01:24:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0B1OwMl027297
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 01:24:58 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0B1Ow3g003353
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 01:24:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: add cli to forget one or all scanned devices
Date: Thu, 11 Jan 2018 09:25:51 +0800
Message-Id: <20180111012551.14765-3-anand.jain@oracle.com>
In-Reply-To: <20180111012551.14765-1-anand.jain@oracle.com>
References: <20180111012551.14765-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds cli
  btrfs device forget [dev]
which shall remove the relevant device entries in the kernel
matching the dev. If no argument is given it shall remove all
stale (device which are not mounted) from the kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  6 ++++-
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index f4cdb39f64ac..8c3ad3080437 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -329,6 +329,82 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_device_forget_usage[] = {
+	"btrfs device forget [<device>]",
+	"Forget a scanned device or all stale devices in the btrfs.ko",
+	NULL
+};
+
+static int btrfs_forget_devices(void)
+{
+	struct btrfs_ioctl_vol_args_v2 args;
+	int fd;
+	int ret;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	args.flags = BTRFS_DEVICE_SPEC_ALL;
+	ret = ioctl(fd, BTRFS_IOC_FORGET_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+
+}
+
+static int btrfs_forget_one_device(char *path)
+{
+	struct btrfs_ioctl_vol_args_v2 args;
+	int fd;
+	int ret;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	strncpy_null(args.name, path);
+	ret = ioctl(fd, BTRFS_IOC_FORGET_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
+static int cmd_device_forget(int argc, char **argv)
+{
+	char *path;
+	int ret = 0;
+
+	if (check_argc_max(argc - optind, 1))
+		usage(cmd_device_forget_usage);
+
+	if (argc == 1) {
+		ret = btrfs_forget_devices();
+		if (ret)
+			error("Can't forget: %s", strerror(-ret));
+		return ret;
+	}
+
+	path = canonicalize_path(argv[1]);
+	if (!path) {
+		error("Could not canonicalize path '%s': %s",
+					argv[1], strerror(errno));
+		return -ENOENT;
+	}
+
+	ret  = btrfs_forget_one_device(path);
+	if (ret)
+		error("Can't forget '%s': %s", path, strerror(-ret));
+
+	free(path);
+
+	return ret;
+}
+
 static const char * const cmd_device_ready_usage[] = {
 	"btrfs device ready <device>",
 	"Check device to see if it has all of its devices in cache for mounting",
@@ -604,6 +680,7 @@ const struct cmd_group device_cmd_group = {
 			CMD_ALIAS },
 		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
 		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
+		{ "forget", cmd_device_forget, cmd_device_forget_usage, NULL, 0 },
 		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
 		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
 		{ "usage", cmd_device_usage,
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..ac697f044950 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -53,12 +53,14 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
+#define BTRFS_DEVICE_SPEC_ALL		(1ULL << 4)
 
 #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
 			(BTRFS_SUBVOL_CREATE_ASYNC |	\
 			BTRFS_SUBVOL_RDONLY |		\
 			BTRFS_SUBVOL_QGROUP_INHERIT |	\
-			BTRFS_DEVICE_SPEC_BY_ID)
+			BTRFS_DEVICE_SPEC_BY_ID |	\
+			BTRFS_DEVICE_SPEC_ALL)
 
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
@@ -721,6 +723,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.7.0

