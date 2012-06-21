Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55334 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab2FUUGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 16:06:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <harald@redhat.com>
Subject: [PATCH] Btrfs-progs: add btrfs device ready command
Date: Thu, 21 Jun 2012 16:10:31 -0400
Message-ID: <1340309431-9972-3-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This command will be used by things like dracut that wish to know very
simply if all of the devices have been added to the kernel cache yet for the
device to be fully mounted.  This keeps initrd's from constantly having to
try to mount the file system until it succeeds every time a device is added
to the system.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-device.c |   35 +++++++++++++++++++++++++++++++++++
 ioctl.h       |    2 ++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index db625a6..fccf870 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -246,11 +246,46 @@ static int cmd_scan_dev(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_ready_dev_usage[] = {
+	"btrfs device ready <device>",
+	"Check device to see if it has all of it's devices in cache for mounting",
+	NULL
+};
+
+static int cmd_ready_dev(int argc, char **argv)
+{
+	struct	btrfs_ioctl_vol_args args;
+	int	fd;
+	int	ret;
+
+	if (check_argc_min(argc, 2))
+		usage(cmd_ready_dev_usage);
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0) {
+		perror("failed to open /dev/btrfs-control");
+		return 10;
+	}
+
+	strncpy(args.name, argv[argc - 1], BTRFS_PATH_NAME_MAX);
+	ret = ioctl(fd, BTRFS_IOC_DEVICES_READY, &args);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to determine if the device '%s'"
+			" is ready for mounting - %s\n", argv[argc - 1],
+			strerror(errno));
+		ret = 1;
+	}
+
+	close(fd);
+	return ret;
+}
+
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
 		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
+		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..e5f8a94 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -330,5 +330,7 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_DEVICES_READY _IOW(BTRFS_IOCTL_MAGIC, 54, \
+				     struct btrfs_ioctl_vol_args)
 
 #endif
-- 
1.7.7.6

