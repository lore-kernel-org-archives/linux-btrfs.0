Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51559 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdKMFp0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:45:26 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAD5jPes006076
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:45:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5jPxT016710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:45:25 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5jOpB026015
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:45:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add 'btrfs device ignore' cli
Date: Mon, 13 Nov 2017 13:45:36 +0800
Message-Id: <20171113054536.25288-1-anand.jain@oracle.com>
In-Reply-To: <20171113054410.24872-1-anand.jain@oracle.com>
References: <20171113054410.24872-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds
  btrfs device ignode <dev>
so that a device can be ignored/missed during mount if the device is
already been scanned. Basically, this command will undo the effect
of the command
  btrfs device scan <dev>

This change is compatible with older kernel without the ioctl
BTRFS_IOC_IGNORE_DEV which is added here. At which it shall
report 'Inappropriate ioctl for device'. And will report
'Operation not permitted' on mounted device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 56 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index 4337eb272037..78280e099492 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -320,6 +320,59 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_device_ignore_usage[] = {
+	"btrfs device ignore [<device>]",
+	"Ignore a device in the btrfs kernel module.",
+	NULL
+};
+
+static int btrfs_ignore_one_device(char *path)
+{
+	struct btrfs_ioctl_vol_args args;
+	int fd;
+	int ret;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	strncpy_null(args.name, path);
+	ret = ioctl(fd, BTRFS_IOC_IGNORE_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
+static int cmd_device_ignore(int argc, char **argv)
+{
+	int ret = 0;
+	char *path;
+
+	if (check_argc_max(argc - optind, 1))
+		usage(cmd_device_ignore_usage);
+
+	if (is_block_device(argv[1]) != 1) {
+		error("Not a block device: %s", argv[1]);
+		return -ENOENT;
+	}
+
+	path = canonicalize_path(argv[1]);
+	if (!path) {
+		error("Could not canonicalize path '%s': %s",
+					argv[1], strerror(errno));
+		return -ENOENT;
+	}
+
+	ret  = btrfs_ignore_one_device(path);
+	if (ret)
+		error("Can't ignore %s: %s", path, strerror(-ret));
+
+	free(path);
+	return ret;
+}
+
 static const char * const cmd_device_ready_usage[] = {
 	"btrfs device ready <device>",
 	"Check device to see if it has all of its devices in cache for mounting",
@@ -595,6 +648,7 @@ const struct cmd_group device_cmd_group = {
 			CMD_ALIAS },
 		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
 		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
+		{ "ignore", cmd_device_ignore, cmd_device_ignore_usage, NULL, 0 },
 		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
 		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
 		{ "usage", cmd_device_usage,
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..bef8508119aa 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_IGNORE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.13.1

