Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44482 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3GOFac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:30:32 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6F5UV3O029938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:31 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F5UTYi013931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:30 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F5UTUt023614
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: fix the long lines
Date: Mon, 15 Jul 2013 13:35:26 +0800
Message-Id: <1373866527-10604-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866527-10604-1-git-send-email-anand.jain@oracle.com>
References: <1373866527-10604-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

trivial: cmds-replace.c contains long lines fix it

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..c68986a 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -211,8 +211,8 @@ static int cmd_start_replace(int argc, char **argv)
 		struct btrfs_ioctl_dev_info_args *di_args = NULL;
 
 		if (atoi(srcdev) == 0) {
-			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
-				srcdev);
+			fprintf(stderr, "Error: Failed to parse the numerical "\
+				"devid value '%s'\n", srcdev);
 			goto leave_with_error;
 		}
 		start_args.start.srcdevid = (__u64)atoi(srcdev);
@@ -235,8 +235,8 @@ static int cmd_start_replace(int argc, char **argv)
 				break;
 		free(di_args);
 		if (i == fi_args.num_devices) {
-			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
-				srcdev, path);
+			fprintf(stderr, "Error: '%s' is not a valid devid for "\
+				"filesystem '%s'\n", srcdev, path);
 			goto leave_with_error;
 		}
 	} else {
@@ -283,7 +283,8 @@ static int cmd_start_replace(int argc, char **argv)
 				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
 	if (ret >= 0 && !force_using_targetdev) {
 		fprintf(stderr,
-			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
+			"Error, target device %s contains filesystem, "\
+			"use '-f' to force overwriting.\n",
 			dstdev);
 		goto leave_with_error;
 	}
@@ -321,7 +322,8 @@ static int cmd_start_replace(int argc, char **argv)
 	if (do_not_background) {
 		if (ret) {
 			fprintf(stderr,
-				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
+				"ERROR: ioctl(DEV_REPLACE_START) failed "\
+				"on \"%s\": %s, %s\n",
 				path, strerror(errno),
 				replace_dev_result2string(start_args.result));
 			goto leave_with_error;
@@ -330,7 +332,8 @@ static int cmd_start_replace(int argc, char **argv)
 		if (start_args.result !=
 		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
 			fprintf(stderr,
-				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" returns error: %s\n",
+				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" "\
+				"returns error: %s\n",
 				path,
 				replace_dev_result2string(start_args.result));
 			goto leave_with_error;
-- 
1.7.7.6

