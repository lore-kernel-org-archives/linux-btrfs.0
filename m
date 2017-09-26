Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44522 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030409AbdIZIjz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:39:55 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8Q8ds2C015829
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8Q8ds2p029888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:54 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8Q8dsX5009788
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: fix BUG_ON in btrfs_init_new_device()
Date: Tue, 26 Sep 2017 16:47:38 +0800
Message-Id: <20170926084738.3558-3-anand.jain@oracle.com>
In-Reply-To: <20170926084738.3558-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170926084738.3558-1-anand.jain@oracle.com>

Instead of BUG_ON return error to the caller. And handle the fail
condition by calling the abort transaction and going through the
error path.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: do not consolidate btrfs_abort_transaction()
v3: meld 2/3 and 3/3 from v2

 fs/btrfs/volumes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9d64700cc9b6..4cb575fbf643 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2399,7 +2399,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(fs_info);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto error_trans;
+		}
 	}
 
 	device->fs_devices = fs_info->fs_devices;
@@ -2445,14 +2448,14 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		mutex_unlock(&fs_info->chunk_mutex);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
+			goto error_sysfs;
 		}
 	}
 
 	ret = btrfs_add_device(trans, fs_info, device);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto error_trans;
+		goto error_sysfs;
 	}
 
 	if (seeding_dev) {
@@ -2461,7 +2464,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		ret = btrfs_finish_sprout(trans, fs_info);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-			goto error_trans;
+			goto error_sysfs;
 		}
 
 		/* Sprouting would change fsid of the mounted root,
@@ -2500,12 +2503,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	update_dev_time(device_path);
 	return ret;
 
+error_sysfs:
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 error_trans:
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
 	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
-	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.13.1

