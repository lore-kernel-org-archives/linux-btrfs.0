Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51303 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754322AbdLGOwc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:52:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB7EqOoD136209
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2eq4kn8w16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 14:52:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB7EqUjc002763
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:30 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB7EqUJd028543
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:52:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/2] btrfs-progs: add feature to deregister all devices
Date: Thu,  7 Dec 2017 22:52:55 +0800
Message-Id: <20171207145255.27686-2-anand.jain@oracle.com>
In-Reply-To: <20171207145255.27686-1-anand.jain@oracle.com>
References: <20171207143623.26710-1-anand.jain@oracle.com>
 <20171207145255.27686-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds default no option to deregister all unmounted
devices in the kernel at once. For example:
  btrfs device deregister

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1-4: NA.
v5: New patch in v5.

 cmds-device.c | 31 +++++++++++++++++++++++++++++--
 ioctl.h       |  6 +++++-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 8244ff9802be..6b9c3616b641 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -331,10 +331,30 @@ out:
 
 static const char * const cmd_device_deregister_usage[] = {
 	"btrfs device deregister [<device>]",
-	"Deregister device in btrfs kernel module.",
+	"Deregister one or all scanned device(s) in the kernel.",
 	NULL
 };
 
+static int btrfs_deregister_devices(void)
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
+	args.ioctl_flag = BTRFS_IOCTL_PURGE_ALL_DEVS;
+	ret = ioctl(fd, BTRFS_IOC_DEREGISTER_DEV, &args);
+	if (ret)
+		ret = -errno;
+	close(fd);
+	return ret;
+
+}
+
 static int btrfs_deregister_one_device(char *path)
 {
 	struct btrfs_ioctl_vol_args args;
@@ -359,9 +379,16 @@ static int cmd_device_deregister(int argc, char **argv)
 	char *path;
 	int ret = 0;
 
-	if (check_argc_exact(argc - optind, 1))
+	if (check_argc_max(argc - optind, 1))
 		usage(cmd_device_deregister_usage);
 
+	if (argc == 1) {
+		ret = btrfs_deregister_devices();
+		if (ret)
+			error("Can't deregister: %s", strerror(-ret));
+		return ret;
+	}
+
 	if (is_block_device(argv[1]) != 1) {
 		error("Not a block device: %s", argv[1]);
 		return -ENOENT;
diff --git a/ioctl.h b/ioctl.h
index 3cdb88eb5bb2..a36055b453e2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -41,8 +41,12 @@ extern "C" {
 
 /* this should be 4k */
 #define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_IOCTL_PURGE_ALL_DEVS	(1ULL << 0)
 struct btrfs_ioctl_vol_args {
-	__s64 fd;
+	union {
+		__s64 fd;
+		__u64 ioctl_flag;
+	};
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_vol_args) == 4096);
-- 
2.7.0

