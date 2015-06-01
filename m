Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20054 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbFAGZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 02:25:38 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t516PaBB017560
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t516Pa9U016769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:36 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t516Pa53002434
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:25:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: avoid duplicate checks on user provided devid
Date: Mon,  1 Jun 2015 14:25:17 +0800
Message-Id: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel is already checking it (rightly), we don't need to check that in the user land.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 6ea7c61..0787ce3 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -118,7 +118,6 @@ static int cmd_start_replace(int argc, char **argv)
 	struct btrfs_ioctl_dev_replace_args start_args = {0};
 	struct btrfs_ioctl_dev_replace_args status_args = {0};
 	int ret;
-	int i;
 	int c;
 	int fdmnt = -1;
 	int fdsrcdev = -1;
@@ -214,33 +213,7 @@ static int cmd_start_replace(int argc, char **argv)
 	}
 
 	if (is_numerical(srcdev)) {
-		struct btrfs_ioctl_fs_info_args fi_args;
-		struct btrfs_ioctl_dev_info_args *di_args = NULL;
-
 		start_args.start.srcdevid = arg_strtou64(srcdev);
-
-		ret = get_fs_info(path, &fi_args, &di_args);
-		if (ret) {
-			fprintf(stderr, "ERROR: getting dev info for devstats failed: "
-					"%s\n", strerror(-ret));
-			free(di_args);
-			goto leave_with_error;
-		}
-		if (!fi_args.num_devices) {
-			fprintf(stderr, "ERROR: no devices found\n");
-			free(di_args);
-			goto leave_with_error;
-		}
-
-		for (i = 0; i < fi_args.num_devices; i++)
-			if (start_args.start.srcdevid == di_args[i].devid)
-				break;
-		free(di_args);
-		if (i == fi_args.num_devices) {
-			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
-				srcdev, path);
-			goto leave_with_error;
-		}
 	} else {
 		fdsrcdev = open(srcdev, O_RDWR);
 		if (fdsrcdev < 0) {
-- 
2.4.1

