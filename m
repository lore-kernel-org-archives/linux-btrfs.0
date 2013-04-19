Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967981Ab3DSJgn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 05:36:43 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3J9afSM008943
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 09:36:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3J9afEs000634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 09:36:41 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3J9ae2Z017265
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 09:36:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: subvol show could take more than one subvol
Date: Fri, 19 Apr 2013 17:38:29 +0800
Message-Id: <1366364309-28525-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 74e2130..e3b8032 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -800,16 +800,18 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct btrfs_list_filter_set *filter_set;
 	char tstr[256];
 	char uuidparse[37];
-	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
+	char *fullpath, *svpath = NULL, *mnt;
 	char raw_prefix[] = "\t\t\t\t";
 	u64 sv_id, mntid;
 	int fd = -1, mntfd = -1;
 	int ret = -1;
 
-	if (check_argc_exact(argc, 2))
+	if (check_argc_min(argc, 2))
 		usage(cmd_subvol_show_usage);
-
-	fullpath = realpath(argv[1], 0);
+again:
+	mnt = NULL;
+	fullpath = NULL;
+	fullpath = realpath(argv[optind++], 0);
 	if (!fullpath) {
 		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
 			argv[1], strerror(errno));
@@ -939,6 +941,8 @@ out:
 	if (fullpath)
 		free(fullpath);
 
+	if (optind < argc)
+		goto again;
 	return ret;
 }
 
-- 
1.8.1.227.g44fe835

