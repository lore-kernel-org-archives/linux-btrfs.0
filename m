Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36455 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbbHTFY1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 01:24:27 -0400
Received: by wicja10 with SMTP id ja10so135571524wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 22:24:25 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] btrfs-progs: Add further checks to btrfs replace start command
Date: Thu, 20 Aug 2015 07:24:23 +0200
Message-Id: <1440048263-6089-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add further checks to btrfs replace start command.

The following tests where added in user space before calling
the ioctl():
1) check if the new disk is greather or equal to the old one
2) check if the source device is or a block device or a
numerical dev-id

These checks are already performed in kernel space; however
when "btrfs replace start" is ran in background is not possible
to show any error returned by the ioctl(), so in case of fail 
the user had to check dmesg to understand the what happened.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-replace.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 85365e3..45fe060 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -142,6 +142,8 @@ static int cmd_start_replace(int argc, char **argv)
 	int do_not_background = 0;
 	int mixed = 0;
 	DIR *dirstream = NULL;
+	u64 srcdev_size;
+	u64 dstdev_size;
 
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
@@ -249,16 +251,28 @@ static int cmd_start_replace(int argc, char **argv)
 				srcdev, path);
 			goto leave_with_error;
 		}
-	} else if (is_block_device(srcdev)) {
+		srcdev_size = di_args[i].total_bytes;
+	} else if (is_block_device(srcdev) > 0) {
 		strncpy((char *)start_args.start.srcdev_name, srcdev,
 			BTRFS_DEVICE_PATH_NAME_MAX);
 		start_args.start.srcdevid = 0;
+		srcdev_size = get_partition_size(srcdev);
+	} else {
+		fprintf(stderr, "ERROR: source device must be a block device or a devid\n");
+		goto leave_with_error;
 	}
 
 	ret = test_dev_for_mkfs(dstdev, force_using_targetdev);
 	if (ret)
 		goto leave_with_error;
 
+	dstdev_size = get_partition_size(dstdev);
+	if (srcdev_size > dstdev_size) {
+		fprintf(stderr, "ERROR: target device smaller than source device (required %llu bytes)\n",
+			srcdev_size);
+		goto leave_with_error;
+	}
+
 	fddstdev = open(dstdev, O_RDWR);
 	if (fddstdev < 0) {
 		fprintf(stderr, "Unable to open %s\n", dstdev);
-- 
2.5.0

