Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51081 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbKIK5s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:48 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvlOJ014227
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvlDj004853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:47 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avl9k020396
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/15] btrfs: support btrfs dev scan for spare device
Date: Mon,  9 Nov 2015 18:56:26 +0800
Message-Id: <1447066589-3835-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the user or system calls the BTRFS_IOC_SCAN_DEV,
ioctl this patch will make sure it is added to the device
list and set it as spare.

This operation will be same when BTRFS_IOC_DEVICES_READY
as well since BTRFS_IOC_DEVICES_READY ioctl has been doing
that by legacy.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++++
 fs/btrfs/volumes.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fcc9e57..28f549d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -526,6 +526,10 @@ static noinline int device_list_add(const char *path,
 		if (IS_ERR(fs_devices))
 			return PTR_ERR(fs_devices);
 
+		if (btrfs_super_incompat_flags(disk_super) &
+				BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
+			fs_devices->spare = 1;
+
 		list_add(&fs_devices->list, &fs_uuids);
 
 		device = NULL;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 827371e..3d995b7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -278,6 +278,8 @@ struct btrfs_fs_devices {
 	struct kobject fsid_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
+
+	int spare;
 };
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
-- 
2.4.1

