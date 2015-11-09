Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50990 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbKIK5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:38 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvbKR014070
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvbAW029810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:37 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvbtF020327
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/15] btrfs: Do per-chunk degraded check for remount
Date: Mon,  9 Nov 2015 18:56:17 +0800
Message-Id: <1447066589-3835-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Just the same for mount time check, use new btrfs_check_degraded() to do
per chunk check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Btrfs: use btrfs_error instead of btrfs_err during remount

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b23d49d..d495790 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1662,11 +1662,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			goto restore;
 		}
 
-		if (fs_info->fs_devices->missing_devices >
-		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		ret = btrfs_check_degradable(fs_info, *flags);
+		if (ret < 0) {
+			btrfs_err(fs_info,
+				"degraded writable remount failed %d", ret);
+			goto restore;
+		} else if (ret > 0 && !btrfs_test_opt(root, DEGRADED)) {
 			btrfs_warn(fs_info,
-				"too many missing devices, writeable remount is not allowed");
+				"some device missing, but still degraded mountable, please remount with -o degraded option");
 			ret = -EACCES;
 			goto restore;
 		}
-- 
2.4.1

