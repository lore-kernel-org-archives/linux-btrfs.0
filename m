Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbbFOOCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 10:02:39 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5FE2dYd026030
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 14:02:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t5FE2cw4001192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 14:02:38 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t5FE2b5r026328
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 14:02:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix typo in the error log
Date: Mon, 15 Jun 2015 22:02:23 +0800
Message-Id: <1434376943-382-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/super.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 57d48f8..5147cb7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2896,7 +2896,7 @@ retry_root_backup:
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING "BTRFS: "
-			"too many missing devices, writeable mount is not allowed\n");
+			"too many missing devices, writable mount is not allowed\n");
 		goto fail_sysfs;
 	}
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 555c775..8888e39 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1545,7 +1545,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		     fs_info->num_tolerated_disk_barrier_failures &&
 		    !(*flags & MS_RDONLY)) {
 			btrfs_warn(fs_info,
-				"too many missing devices, writeable remount is not allowed");
+				"too many missing devices, writable remount is not allowed");
 			ret = -EACCES;
 			goto restore;
 		}
-- 
2.4.1

