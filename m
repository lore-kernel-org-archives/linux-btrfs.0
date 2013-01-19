Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:55790 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3ASSGd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:33 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180633.TEMH17456.eastrmfepo201.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:33 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 5/6] Btrfs-progs: add btrfs device ready command
Date: Sat, 19 Jan 2013 13:06:20 -0500
Message-Id: <1358618781-26629-6-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-1-git-send-email-gene@czarc.net>
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fusionio.com>

This command will be used by things like dracut that wish to know very
simply if all of the devices have been added to the kernel cache yet for the
device to be fully mounted.  This keeps initrd's from constantly having to
try to mount the file system until it succeeds every time a device is added
to the system.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-device.c | 35 +++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index 4787aca..75ee293 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -250,11 +250,46 @@ static int cmd_scan_dev(int argc, char **argv)
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
index 6fda3a1..d32e22c 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -419,6 +419,8 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
+#define BTRFS_IOC_DEVICES_READY _IOR(BTRFS_IOCTL_MAGIC, 39, \
+				     struct btrfs_ioctl_vol_args)
 
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args)
-- 
1.8.1

