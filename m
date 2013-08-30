Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32767 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H3LCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 07:02:25 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7UB2N0L012037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 11:02:24 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7UB2MeJ017937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 11:02:23 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7UB2MBS016196
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 11:02:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: device add should check existing FS before adding
Date: Fri, 30 Aug 2013 19:09:01 +0800
Message-Id: <1377860941-5741-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as of now, when 'btrfs device add' adds a device it doesn't
check if the given device contains an existing FS. This
patch will change that to check the same. which when true
add will fail, and ask user to use -f option to overwrite.

further, since now we have test_dev_for_mkfs() function
to check if a disk can be used, so this patch will also
use this function to test the given device before adding.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |   44 ++++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 282590c..8446502 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -53,12 +53,25 @@ static const char * const cmd_add_dev_usage[] = {
 static int cmd_add_dev(int argc, char **argv)
 {
 	char	*mntpnt;
-	int	i, fdmnt, ret=0, e;
+	int	i = 1, fdmnt, ret = 0, e;
 	DIR	*dirstream = NULL;
+	int	c, force = 0;
+	char	estr[100];
 
 	if (check_argc_min(argc, 3))
 		usage(cmd_add_dev_usage);
 
+	while ((c = getopt(argc, argv, "f")) != -1) {
+		switch (c) {
+		case 'f':
+			force = 1;
+			i++;
+			break;
+		default:
+			usage(cmd_add_dev_usage);
+		}
+	}
+
 	mntpnt = argv[argc - 1];
 
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
@@ -67,23 +80,15 @@ static int cmd_add_dev(int argc, char **argv)
 		return 12;
 	}
 
-	for (i = 1; i < argc - 1; i++ ){
+	for (; i < argc - 1; i++) {
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
-		struct stat st;
 		int mixed = 0;
 
-		res = check_mounted(argv[i]);
-		if (res < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
-				argv[i]);
-			ret++;
-			continue;
-		}
-		if (res == 1) {
-			fprintf(stderr, "%s is mounted\n", argv[i]);
-			ret++;
+		res = test_dev_for_mkfs(argv[i], force, estr);
+		if (res) {
+			fprintf(stderr, "%s", estr);
 			continue;
 		}
 
@@ -93,19 +98,6 @@ static int cmd_add_dev(int argc, char **argv)
 			ret++;
 			continue;
 		}
-		res = fstat(devfd, &st);
-		if (res) {
-			fprintf(stderr, "ERROR: Unable to stat '%s'\n", argv[i]);
-			close(devfd);
-			ret++;
-			continue;
-		}
-		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "ERROR: '%s' is not a block device\n", argv[i]);
-			close(devfd);
-			ret++;
-			continue;
-		}
 
 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
 					   0, &mixed, 0);
-- 
1.7.1

