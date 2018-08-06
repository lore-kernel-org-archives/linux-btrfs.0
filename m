Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbeHFDMz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 23:12:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7614j6R055249
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:19 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2kn3jstsve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Aug 2018 01:06:19 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7616IZT019676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:18 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7616Itt016211
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 01:06:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add cli to forget one or all scanned devices
Date: Mon,  6 Aug 2018 09:09:49 +0800
Message-Id: <20180806010949.26915-3-anand.jain@oracle.com>
In-Reply-To: <20180806010949.26915-1-anand.jain@oracle.com>
References: <20180806010949.26915-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds cli
  btrfs device forget [dev]
to remove the given device structure in the kernel if the device
is unmounted. If no argument is given it shall remove all stale
(device which are not mounted) from the kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 60 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index 86459d1b9564..49cfd4b41adb 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -326,6 +326,63 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_device_forget_usage[] = {
+	"btrfs device forget [<device>]",
+	"Forget a stale device or all stale devices in btrfs.ko",
+	NULL
+};
+
+static int btrfs_forget_devices(char *path)
+{
+	struct btrfs_ioctl_vol_args args;
+	int ret;
+	int fd;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	memset(&args, 0, sizeof(args));
+	if (path)
+		strncpy_null(args.name, path);
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
+		ret = btrfs_forget_devices(NULL);
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
+	ret  = btrfs_forget_devices(path);
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
@@ -601,6 +658,7 @@ const struct cmd_group device_cmd_group = {
 			CMD_ALIAS },
 		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
 		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
+		{ "forget", cmd_device_forget, cmd_device_forget_usage, NULL, 0 },
 		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
 		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
 		{ "usage", cmd_device_usage,
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..e27d80e09392 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
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

