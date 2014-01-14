Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaANLHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 06:07:55 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s0EB7sxQ021075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:54 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s0EB7rq3019473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:54 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0EB7rLF020656
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: return non zero when label is not found
Date: Tue, 14 Jan 2014 19:17:07 +0800
Message-Id: <1389698228-9580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs filesystem show <not-found-label> should return non zero

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index c50a65f..ee6cc84 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -612,6 +612,7 @@ static int cmd_show(int argc, char **argv)
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
 	char uuid_buf[37];
+	int found = 0;
 
 	while (1) {
 		int long_index;
@@ -694,8 +695,10 @@ static int cmd_show(int argc, char **argv)
 	ret = btrfs_scan_kernel_v2(search);
 	if (ret == -ENOTTY)
 		ret = btrfs_scan_kernel(search);
-	if (search && !ret)
-		return 0;
+	if (search && !ret) {
+		/* since search is found we are done */
+		goto out;
+	}
 
 	/* shows mounted only */
 	if (where == BTRFS_SCAN_MOUNTED)
@@ -717,12 +720,15 @@ devs_only:
 			continue;
 
 		print_one_uuid(fs_devices);
+		found = 1;
 	}
+	if (search && !found)
+		ret = 1;
 
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	free_seen_fsid();
-	return 0;
+	return ret;
 }
 
 static const char * const cmd_sync_usage[] = {
-- 
1.7.1

