Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbeGPPWu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:22:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GErkTB066371
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:02 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2k7a33vshr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEt2D4016693
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:02 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6GEt2OI025652
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] btrfs: add helper btrfs_num_devices() to deduce num_devices
Date: Mon, 16 Jul 2018 22:58:11 +0800
Message-Id: <20180716145812.20836-7-anand.jain@oracle.com>
In-Reply-To: <20180716145812.20836-1-anand.jain@oracle.com>
References: <20180716145812.20836-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the replace is running the fs_devices::num_devices also includes
the replace device, however in some operations like device delete and
balance it needs the actual num_devices without the repalce devices, so
now the function btrfs_num_devices() just provides that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: add comments. Thanks Nikolay.

 fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f4c512aa6b4..1c0b56374992 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1844,6 +1844,21 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 }
 
+/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
+static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
+{
+	u64 num_devices = fs_info->fs_devices->num_devices;
+
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		WARN_ON(num_devices < 1);
+		num_devices--;
+	}
+	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+
+	return num_devices;
+}
+
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		u64 devid)
 {
@@ -1857,13 +1872,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		WARN_ON(num_devices < 1);
-		num_devices--;
-	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	num_devices = btrfs_num_devices(fs_info);
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
@@ -3723,13 +3732,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	num_devices = fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		WARN_ON(num_devices < 1);
-		num_devices--;
-	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	num_devices = btrfs_num_devices(fs_info);
+
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
 	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
-- 
2.7.0

