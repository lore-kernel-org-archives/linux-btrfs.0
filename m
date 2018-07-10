Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732518AbeGJSTg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 14:19:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AIJSar062475
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:28 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2k2p7vb3jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJRxL030332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:27 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJRHJ000324
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: add helper btrfs_num_devices() to deduce num_devices
Date: Wed, 11 Jul 2018 02:22:40 +0800
Message-Id: <20180710182241.23754-2-anand.jain@oracle.com>
In-Reply-To: <20180710182241.23754-1-anand.jain@oracle.com>
References: <20180710182241.23754-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the replace is running the fs_devices::num_devices also includes
the replace device, however in some operations like device delete and
balance it needs the actual num_devices without the repalce devices, so
now the function btrfs_num_devices() just provides that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce6faeb8bcf8..59a6d8f42c98 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1931,6 +1931,20 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 }
 
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
@@ -1944,13 +1958,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
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
@@ -3810,13 +3818,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
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

