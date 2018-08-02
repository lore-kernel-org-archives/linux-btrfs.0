Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50982 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHBL4i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 07:56:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w72A3RGp100553
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Aug 2018 10:06:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2kge0dapr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2018 10:06:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w72A69H8006577
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Aug 2018 10:06:09 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w72A694H010293
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Aug 2018 10:06:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/4] btrfs: add helper btrfs_num_devices() to deduce num_devices
Date: Thu,  2 Aug 2018 18:09:34 +0800
Message-Id: <20180802100934.12468-1-anand.jain@oracle.com>
In-Reply-To: <20180726065334.30594-5-anand.jain@oracle.com>
References: <20180726065334.30594-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the replace is running the fs_devices::num_devices also includes
the replace device, however in some operations like device delete and
balance it needs the actual num_devices without the repalce devices, so
now the function btrfs_num_devices() just provides that.

And here is a scenario how balance and repalce items could co-exist.
Consider balance is started and paused, now start the replace
followed by a power-recycle of the system. During following mount,
the open_ctree() first restarts the balance so it must check for the
replace device otherwise our num_devices calculation will be wrong.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: update changelog with not so obvious balance and repalce
co-existance secnario
v1->v2: add comments

 fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe74fefc75f7..8844904f9009 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1854,6 +1854,21 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 }
 
+/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
+static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
+{
+	u64 num_devices = fs_info->fs_devices->num_devices;
+
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		BUG_ON(num_devices < 1);
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
@@ -1865,13 +1880,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
-		num_devices--;
-	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	num_devices = btrfs_num_devices(fs_info);
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
@@ -3721,13 +3730,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	num_devices = fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
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

