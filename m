Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:30886 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbdJKCS7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 22:18:59 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E8EFAAC00D0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:18:53 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 163E3BD64EF
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:18:53 +0900 (JST)
Subject: [PATCH v2 3/3] btrfs-progs: device: add remove missing-all
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
Message-ID: <be3e6086-5a2f-77d0-5dbc-dcb5a1a57815@jp.fujitsu.com>
Date: Wed, 11 Oct 2017 11:18:50 +0900
MIME-Version: 1.0
In-Reply-To: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add 'btrfs remove missing-all' to remove all the missing devices
at once for improving usability.

Example:
 sudo mkfs.btrfs -f -d raid1 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
 sudo wipefs -a /dev/sdb1 /dev/sdb3
 sudo mount -o degraded /dev/sdb2 /mnt
 sudo btrfs filesystem show /mnt
 sudo btrfs device remove missing-all /mnt
 sudo btrfs filesystem show /mnt

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-device.asciidoc |  1 +
 cmds-device.c                       | 24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index dd60415..f08d64d 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -79,6 +79,7 @@ lowest device id.
 If device is mounted as degraded mode (-o degraded), special term "missing"
 can be used for <device>. In that case, the first device that is described by
 the filesystem metadata, but not preseted at the mount time will be removed.
+Also, "missing-all" can be used to remove all the missing devices.
 
 *delete* <device>|<devid> [<device>|<devid>...] <path>::
 Alias of remove kept for backward compatibility
diff --git a/cmds-device.c b/cmds-device.c
index d28ed0f..507ad04 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -164,6 +164,8 @@ static int _cmd_device_remove(int argc, char **argv,
 		struct	btrfs_ioctl_vol_args arg;
 		struct btrfs_ioctl_vol_args_v2 argv2 = {0};
 		int is_devid = 0;
+		int is_missing_all = 0;
+		int num_missing = 0;
 		int	res;
 
 		if (string_is_numerical(argv[i])) {
@@ -173,12 +175,16 @@ static int _cmd_device_remove(int argc, char **argv,
 		} else if (is_block_device(argv[i]) == 1 ||
 				strcmp(argv[i], "missing") == 0) {
 			strncpy_null(argv2.name, argv[i]);
+		} else if (strcmp(argv[i], "missing-all") == 0) {
+			is_missing_all = 1;
+			strncpy_null(argv2.name, "missing");
 		} else {
 			error("not a block device: %s", argv[i]);
 			ret++;
 			continue;
 		}
 
+again:
 		/*
 		 * Positive values are from BTRFS_ERROR_DEV_*,
 		 * otherwise it's a generic error, one of errnos
@@ -202,6 +208,21 @@ static int _cmd_device_remove(int argc, char **argv,
 			res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		}
 
+		if (is_missing_all) {
+			if (!res) {
+				num_missing++;
+				goto again;
+			}
+
+			if (num_missing > 0 &&
+				(res == BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET ||
+				 res == BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET ||
+				 res == BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET ||
+				 res == BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET ||
+				 res == BTRFS_ERROR_DEV_MISSING_NOT_FOUND))
+				continue;
+		}
+
 		if (res) {
 			const char *msg;
 
@@ -228,7 +249,8 @@ static int _cmd_device_remove(int argc, char **argv,
 	"", \
 	"If 'missing' is specified for <device>, the first device that is", \
 	"described by the filesystem metadata, but not presented at the", \
-	"mount time will be removed."
+	"mount time will be removed. Use 'missing-all' to remove all the", \
+	"missing devices."
 
 static const char * const cmd_device_remove_usage[] = {
 	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
-- 
2.9.5

