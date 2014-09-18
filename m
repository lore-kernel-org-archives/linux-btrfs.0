Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58245 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513AbaIRDck (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 23:32:40 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/3] btrfs-progs: remove scan_for_btrfs()
Date: Thu, 18 Sep 2014 11:31:45 +0800
Message-ID: <1411011106-21945-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1411011106-21945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1411011106-21945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

With the changes as in the previous patch, now scan_for_btrfs()
is an unused function. So delete it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 15 ---------------
 utils.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/utils.c b/utils.c
index 0ae0475..0cd97c7 100644
--- a/utils.c
+++ b/utils.c
@@ -2173,21 +2173,6 @@ int btrfs_scan_lblkid(int update_kernel)
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
index 13f2e60..12466a6 100644
--- a/utils.h
+++ b/utils.h
@@ -105,7 +105,6 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
-- 
1.8.1.4

