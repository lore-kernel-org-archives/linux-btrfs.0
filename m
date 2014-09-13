Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30450 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaIMJLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 05:11:49 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8D9BluH031264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:48 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9BlTs002356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:47 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9Blu8002347
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs-progs: don't fall back to recursive /dev scan
Date: Sat, 13 Sep 2014 09:21:19 +0800
Message-Id: <1410571282-3482-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
References: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

If we didn't find what we are looking for in /proc/partitions,
we're not going to find it by scanning every node under /dev, either.

But that's just what btrfs_scan_for_fsid() does.

Remove that fallback; at that point btrfs_scan_for_fsid() just calls
scan_for_btrfs(), so remove the wrapper & call it directly.

Side note: so, these paths always use /proc/partitions, not libblkid.
Userspace-intiated scans default to libblkid.  I presume this is
part of the design, and intentional?  Anyway, not changing it now!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c |  2 +-
 utils.c   | 12 +-----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index f71f5ca..2a1f6d4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1007,7 +1007,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(run_ioctl);
+		ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctl);
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index 0064587..cf7635c 100644
--- a/utils.c
+++ b/utils.c
@@ -1148,7 +1148,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if ((ret = btrfs_scan_for_fsid(!BTRFS_UPDATE_KERNEL)))
+		if ((ret = scan_for_btrfs(BTRFS_SCAN_PROC, !BTRFS_UPDATE_KERNEL)))
 			return ret;
 	}
 
@@ -1336,16 +1336,6 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(int run_ioctls)
-{
-	int ret;
-
-	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
-	if (ret)
-		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
-	return ret;
-}
-
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset)
 {
-- 
2.0.0.153.g79dcccc

