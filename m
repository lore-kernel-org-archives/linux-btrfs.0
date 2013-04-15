Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3DOGhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 04/11 v2] btrfs-progs: cmd replace should check target-dev fully
Date: Mon, 15 Apr 2013 14:38:10 +0800
Message-Id: <1366007897-26567-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as of now in replace command target dev is being checked
for mounted and for existing fs, however there is newly
introduced test_dev_for_mkfs in mkfs.c which is suitable
for this job, and further it also checks if dev can be
opened for with O_EXCL. Its better to use test_dev_for_mkfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index ab34388..4e881b7 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -137,12 +137,11 @@ static int cmd_start_replace(int argc, char **argv)
 	char *dstdev;
 	int avoid_reading_from_srcdev = 0;
 	int force_using_targetdev = 0;
-	u64 total_devs = 1;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct stat st;
 	u64 dstdev_block_count;
 	int do_not_background = 0;
 	int mixed = 0;
+	char estr[100];
 
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
@@ -263,30 +262,16 @@ static int cmd_start_replace(int argc, char **argv)
 		start_args.start.srcdevid = 0;
 	}
 
-	ret = check_mounted(dstdev);
-	if (ret < 0) {
-		fprintf(stderr, "Error checking %s mount status\n", dstdev);
-		goto leave_with_error;
-	}
-	if (ret == 1) {
-		fprintf(stderr,
-			"Error, target device %s is in use and currently mounted!\n",
-			dstdev);
+	if (test_dev_for_mkfs(dstdev, force_using_targetdev, estr)) {
+		fprintf(stderr, "Error: %s", estr);
 		goto leave_with_error;
 	}
+
 	fddstdev = open(dstdev, O_RDWR);
 	if (fddstdev < 0) {
 		fprintf(stderr, "Unable to open %s\n", dstdev);
 		goto leave_with_error;
 	}
-	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0ull);
-	if (ret >= 0 && !force_using_targetdev) {
-		fprintf(stderr,
-			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
-			dstdev);
-		goto leave_with_error;
-	}
 	ret = fstat(fddstdev, &st);
 	if (ret) {
 		fprintf(stderr, "Error: Unable to stat '%s'\n", dstdev);
-- 
1.8.1.227.g44fe835

