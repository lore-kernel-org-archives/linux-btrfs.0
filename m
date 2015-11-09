Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51014 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbbKIK5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:41 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvewN014139
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avdk2011944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:40 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avd6c014197
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/15] btrfs: optimize btrfs_check_degradable() for calls outside of barrier
Date: Mon,  9 Nov 2015 18:56:19 +0800
Message-Id: <1447066589-3835-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 8 +++++++-
 fs/btrfs/volumes.c | 2 --
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 958c2a6..d3303f9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3428,6 +3428,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 /*
  * send an empty flush down to each device in parallel,
  * then wait for them
+ * fixme: optimize err_wait, err_send.
  */
 static int barrier_all_devices(struct btrfs_fs_info *info)
 {
@@ -3467,8 +3468,13 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		if (ret)
 			dev->err_wait = 1;
 	}
-	if (btrfs_check_degradable(info, info->sb->s_flags) < 0)
+	if (btrfs_check_degradable(info, info->sb->s_flags) < 0) {
+		dev->err_send = 0;
+		dev->err_wait = 0;
 		return -EIO;
+	}
+	dev->err_send = 0;
+	dev->err_wait = 0;
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8acf69b..a5262bf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6848,8 +6848,6 @@ int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
 			    map->stripes[i].dev->err_wait ||
 			    map->stripes[i].dev->err_send)
 				missing++;
-			map->stripes[i].dev->err_wait = 0;
-			map->stripes[i].dev->err_send = 0;
 		}
 		if (missing > max_tolerated) {
 			ret = -EIO;
-- 
2.4.1

