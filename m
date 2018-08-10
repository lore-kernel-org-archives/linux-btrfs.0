Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbeHJISH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 04:18:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7A5mX1d108894
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:48 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2kn4sq5skf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:47 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7A5nkSp013758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:47 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7A5nk8b020192
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/2] btrfs: add helper btrfs_num_devices() to deduce num_devices
Date: Fri, 10 Aug 2018 13:53:21 +0800
Message-Id: <20180810055321.19730-4-anand.jain@oracle.com>
In-Reply-To: <20180810055321.19730-1-anand.jain@oracle.com>
References: <20180810055321.19730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the replace is running the fs_devices::num_devices also includes
the replace device, however in some operations like device delete and
balance it needs the actual num_devices without the repalce devices, so
now the function btrfs_num_devices() just provides that.

And here is a scenario how balance and repalce items could co-exist.
Consider balance is started and paused, now start the replace
followed by a unmount or power-recycle of the system. During following
mount, the open_ctree() first restarts the balance so it must check for
the replace device otherwise our num_devices calculation will be wrong.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4->v5: uses assert.
v3->v4: add comment and drop the inline (sorry missed it before)
v2->v3: update changelog with not so obvious balance and repalce
co-existance secnario
v1->v2: add comments

 fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0062615a79be..630f9ec158d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1863,6 +1863,21 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 }
 
+/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
+static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
+{
+	u64 num_devices = fs_info->fs_devices->num_devices;
+
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		ASSERT(num_devices > 0);
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
@@ -1874,13 +1889,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	mutex_lock(&uuid_mutex);
 
-	num_devices = fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		ASSERT(num_devices > 0);
-		num_devices--;
-	}
-	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
+	num_devices = btrfs_num_devices(fs_info);
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
@@ -3749,13 +3758,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	num_devices = fs_info->fs_devices->num_devices;
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		ASSERT(num_devices > 0);
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
