Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34934 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdKFIgT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:19 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aIg8014373
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aIcN023377
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:18 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aHoh014654
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs: btrfs_rm_device() does not need uuid_mutex
Date: Mon,  6 Nov 2017 16:36:16 +0800
Message-Id: <20171106083618.7617-6-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2329f429ce40..3d5ed4518f20 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1914,7 +1914,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	int ret = 0;
 
 	mutex_lock(&fs_info->volume_mutex);
-	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
@@ -1950,9 +1949,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
 
-	mutex_unlock(&uuid_mutex);
 	ret = btrfs_shrink_device(device, 0);
-	mutex_lock(&uuid_mutex);
 	if (ret)
 		goto error_undo;
 
@@ -2027,7 +2024,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	}
 
 out:
-	mutex_unlock(&uuid_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
 	return ret;
 
-- 
2.13.1

