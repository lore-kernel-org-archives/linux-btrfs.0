Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44640 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdI1Gvo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:51:44 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8S6phoJ014795
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8S6pghJ020897
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:43 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8S6pggA002281
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 06:51:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/3] btrfs: fix BUG_ON in btrfs_init_new_device()
Date: Thu, 28 Sep 2017 14:51:10 +0800
Message-Id: <20170928065111.10224-2-anand.jain@oracle.com>
In-Reply-To: <20170928065111.10224-1-anand.jain@oracle.com>
References: <20170928065111.10224-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of BUG_ON return error to the caller. And handle the fail
condition by calling the abort transaction and going through the
error path.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v4: none;
v3: meld this with
     btrfs: cleanup btrfs_init_new_device()
v2: do not consolidate btrfs_abort_transaction()

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

