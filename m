Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754305AbdLGOwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:52:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB7EpfeI188710
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:30 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2epd12qpgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 14:52:30 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB7EqTI5002715
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:29 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB7EqT9O018635
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 1/2] btrfs-progs: add cli to deregister a device
Date: Thu,  7 Dec 2017 22:52:54 +0800
Message-Id: <20171207145255.27686-1-anand.jain@oracle.com>
In-Reply-To: <20171207143623.26710-1-anand.jain@oracle.com>
References: <20171207143623.26710-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds
  btrfs device deregister <dev>
so that an already registered device (through scan) can be deregistered.

This change is compatible with older kernel without the ioctl
BTRFS_IOC_PURGE_DEV it shall report 'Inappropriate ioctl for device'.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1-4: No change.
v5: make provision to add no option to delete all fsids

 cmds-device.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 57 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index f4cdb39f64ac..8244ff9802be 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -329,6 +329,60 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_device_deregister_usage[] = {
+	"btrfs device deregister [<device>]",
+	"Deregister device in btrfs kernel module.",
+	NULL
+};
+
+static int btrfs_deregister_one_device(char *path)
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
+	ret = ioctl(fd, BTRFS_IOC_DEREGISTER_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+}
+
+static int cmd_device_deregister(int argc, char **argv)
+{
+	char *path;
+	int ret = 0;
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_device_deregister_usage);
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
+	ret  = btrfs_deregister_one_device(path);
+	if (ret)
+		error("Can't deregister '%s': %s", path, strerror(-ret));
+
+	free(path);
+
+	return ret;
+}
+
 static const char * const cmd_device_ready_usage[] = {
 	"btrfs device ready <device>",
 	"Check device to see if it has all of its devices in cache for mounting",
@@ -604,6 +658,7 @@ const struct cmd_group device_cmd_group = {
 			CMD_ALIAS },
 		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
 		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
+		{ "deregister", cmd_device_deregister, cmd_device_deregister_usage, NULL, 0 },
 		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
 		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
 		{ "usage", cmd_device_usage,
diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..3cdb88eb5bb2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_DEREGISTER_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
2.7.0

