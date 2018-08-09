Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38694 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbeHIUhh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:37 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 10/12] btrfs-progs: device-add: support HMZONED device
Date: Fri, 10 Aug 2018 03:11:03 +0900
Message-Id: <20180809181105.12856-10-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch check if the target file system is flagged as HMZONED. If it is,
the device to be added is flagged PREP_DEVICE_HMZONED.  Also add checks to
prevent mixing non-zoned devices and zoned devices.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 cmds-device.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 2a05f70a..10696bf7 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -56,6 +56,9 @@ static int cmd_device_add(int argc, char **argv)
 	int discard = 1;
 	int force = 0;
 	int last_dev;
+	int res;
+	int hmzoned;
+	struct btrfs_ioctl_feature_flags feature_flags;
 
 	optind = 0;
 	while (1) {
@@ -91,12 +94,33 @@ static int cmd_device_add(int argc, char **argv)
 	if (fdmnt < 0)
 		return 1;
 
+	res = ioctl(fdmnt, BTRFS_IOC_GET_FEATURES, &feature_flags);
+	if (res) {
+		error("error getting feature flags '%s': %m", mntpnt);
+		return 1;
+	}
+	hmzoned = feature_flags.incompat_flags & BTRFS_FEATURE_INCOMPAT_HMZONED;
+
 	for (i = optind; i < last_dev; i++){
 		struct btrfs_ioctl_vol_args ioctl_args;
-		int	devfd, res;
+		int	devfd;
 		u64 dev_block_count = 0;
 		char *path;
 
+		if (hmzoned && zoned_model(argv[i]) == ZONED_NONE) {
+			error("cannot add non-zoned device to HMZONED file system '%s'",
+			      argv[i]);
+			ret++;
+			continue;
+		}
+
+		if (!hmzoned && zoned_model(argv[i]) == ZONED_HOST_MANAGED) {
+			error("cannot add host managed zoned device to non-HMZONED file system '%s'",
+			      argv[i]);
+			ret++;
+			continue;
+		}
+
 		res = test_dev_for_mkfs(argv[i], force);
 		if (res) {
 			ret++;
@@ -112,7 +136,8 @@ static int cmd_device_add(int argc, char **argv)
 
 		res = btrfs_prepare_device(devfd, argv[i], &dev_block_count, 0,
 				PREP_DEVICE_ZERO_END | PREP_DEVICE_VERBOSE |
-				(discard ? PREP_DEVICE_DISCARD : 0));
+				(discard ? PREP_DEVICE_DISCARD : 0) |
+				(hmzoned ? PREP_DEVICE_HMZONED : 0));
 		close(devfd);
 		if (res) {
 			ret++;
-- 
2.18.0

