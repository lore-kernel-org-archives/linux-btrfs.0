Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbeFAP0t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2018 11:26:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w51FQ6gw114189
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:26:48 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2janjedb4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jun 2018 15:26:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w51FQlOY032288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:26:47 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w51FQlkg027885
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:26:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: drop uuid_mutex in btrfs_rm_device()
Date: Fri,  1 Jun 2018 23:29:25 +0800
Message-Id: <20180601152925.19144-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

uuid_mutex in btrfs_rm_device() is pointless- 1. btrfs_rm_device() can
only delete the device of a mounted fs 2. the btrfs_control interface
doesn't add or free_stale device if the device is mounted. 3. the
contending device operations such as add/replace.. are synchronized
using the atomic BTRFS_FS_EXCL_OP flag. 4. moreover as uuid_mutex
protects the global fs_uuid list it serializes the device delete across
fsids which is pointless.

btrfs_rm_device() is already holding the device_list_mutex when it
updates the fs_devices::dev_list, so we don't need any other locks here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
The changes here are on top the patch other btrfs_rm_device patches..
 [PATCH 1/2] btrfs: fix parent in memory total_devices after seed delete
 [PATCH 2/2] btrfs: fix missing superblock update in the device delete commit transaction
But they are not related.

 fs/btrfs/volumes.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 60a6486090d3..75638e267d8b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1953,7 +1953,7 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
-		u64 devid)
+		    u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_trans_handle *trans;
@@ -1963,8 +1963,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	u64 num_devices;
 	int ret = 0;
 
-	mutex_lock(&uuid_mutex);
-
 	num_devices = fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
@@ -1975,22 +1973,22 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = btrfs_find_device_by_devspec(fs_info, devid, device_path,
 					   &device);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
 		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
-		goto out;
+		return ret;
 	}
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    fs_info->fs_devices->rw_devices == 1) {
 		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
-		goto out;
+		return ret;
 	}
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
@@ -2000,9 +1998,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
 
-	mutex_unlock(&uuid_mutex);
 	ret = btrfs_shrink_device(device, 0);
-	mutex_lock(&uuid_mutex);
 	if (ret)
 		goto error_undo;
 
@@ -2092,8 +2088,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	}
 
 	ret = btrfs_commit_transaction(trans);
-out:
-	mutex_unlock(&uuid_mutex);
 	return ret;
 
 error_undo:
@@ -2104,7 +2098,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		device->fs_devices->rw_devices++;
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
-	goto out;
+	return ret;
 }
 
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
-- 
2.7.0

