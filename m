Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaIMJLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 05:11:52 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8D9Bpr0032622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:52 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9BpkH018826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:51 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9BoYr018820
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs-progs: remove scan_for_btrfs()
Date: Sat, 13 Sep 2014 09:21:22 +0800
Message-Id: <1410571282-3482-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
References: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the changes as in the previous patch, now scan_for_btrfs()
is an unused function. So delete it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 15 ---------------
 utils.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/utils.c b/utils.c
index 7c1e48b..38d867d 100644
--- a/utils.c
+++ b/utils.c
@@ -2125,21 +2125,6 @@ int btrfs_scan_lblkid(int update_kernel)
 	return 0;
 }
 
-/*
- * scans devs for the btrfs
-*/
-int scan_for_btrfs(int where, int update_kernel)
-{
-	int ret = 0;
-
-	switch (where) {
-	case BTRFS_SCAN_LBLKID:
-		ret = btrfs_scan_lblkid(update_kernel);
-		break;
-	}
-	return ret;
-}
-
 int is_vol_small(char *file)
 {
 	int fd = -1;
diff --git a/utils.h b/utils.h
index ea0d5d4..b639bb6 100644
--- a/utils.h
+++ b/utils.h
@@ -100,7 +100,6 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
-- 
2.0.0.153.g79dcccc

