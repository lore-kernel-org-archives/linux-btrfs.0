Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40081 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbbFAGZk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 02:25:40 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t516Pe6Y025708
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t516PdZI026784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:40 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t516Pdwx010337
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: use function is_block_device() instead
Date: Mon,  1 Jun 2015 14:25:18 +0800
Message-Id: <1433139918-820-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
References: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here the delete code as below, is trying to check if the provided device
is a block device, there is a function for it. use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 0787ce3..e6bc27e 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -120,14 +120,12 @@ static int cmd_start_replace(int argc, char **argv)
 	int ret;
 	int c;
 	int fdmnt = -1;
-	int fdsrcdev = -1;
 	int fddstdev = -1;
 	char *path;
 	char *srcdev;
 	char *dstdev = NULL;
 	int avoid_reading_from_srcdev = 0;
 	int force_using_targetdev = 0;
-	struct stat st;
 	u64 dstdev_block_count;
 	int do_not_background = 0;
 	int mixed = 0;
@@ -214,28 +212,9 @@ static int cmd_start_replace(int argc, char **argv)
 
 	if (is_numerical(srcdev)) {
 		start_args.start.srcdevid = arg_strtou64(srcdev);
-	} else {
-		fdsrcdev = open(srcdev, O_RDWR);
-		if (fdsrcdev < 0) {
-			fprintf(stderr, "Error: Unable to open device '%s'\n",
-				srcdev);
-			fprintf(stderr, "\tTry using the devid instead of the path\n");
-			goto leave_with_error;
-		}
-		ret = fstat(fdsrcdev, &st);
-		if (ret) {
-			fprintf(stderr, "Error: Unable to stat '%s'\n", srcdev);
-			goto leave_with_error;
-		}
-		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "Error: '%s' is not a block device\n",
-				srcdev);
-			goto leave_with_error;
-		}
+	} else if (is_block_device(srcdev)) {
 		strncpy((char *)start_args.start.srcdev_name, srcdev,
 			BTRFS_DEVICE_PATH_NAME_MAX);
-		close(fdsrcdev);
-		fdsrcdev = -1;
 		start_args.start.srcdevid = 0;
 	}
 
@@ -308,8 +287,6 @@ leave_with_error:
 		free(dstdev);
 	if (fdmnt != -1)
 		close(fdmnt);
-	if (fdsrcdev != -1)
-		close(fdsrcdev);
 	if (fddstdev != -1)
 		close(fddstdev);
 	return 1;
-- 
2.4.1

