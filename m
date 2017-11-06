Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34953 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdKFIgV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:21 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aKE5014447
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aKlc023896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:20 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA68aKFW005290
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] btrfs: rename btrfs_init_new_device() to btrfs_add_device()
Date: Mon,  6 Nov 2017 16:36:18 +0800
Message-Id: <20171106083618.7617-8-anand.jain@oracle.com>
In-Reply-To: <20171106083618.7617-1-anand.jain@oracle.com>
References: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes this patch renames btrfs_init_new_device()
to btrfs_add_device(), so that it matches to the btrfs_rm_device()
naming. And further it will help to further cleanup device init part
from btrfs_add_device() and btrfs_init_dev_replace().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c   | 2 +-
 fs/btrfs/volumes.c | 2 +-
 fs/btrfs/volumes.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 52289cc661f0..5df8538fc47c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2655,7 +2655,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	ret = btrfs_init_new_device(fs_info, vol_args->name);
+	ret = btrfs_add_device(fs_info, vol_args->name);
 
 	if (!ret)
 		btrfs_info(fs_info, "disk added %s", vol_args->name);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 727c815e9040..14f36d4844f0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2357,7 +2357,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path)
+int btrfs_add_device(struct btrfs_fs_info *fs_info, const char *device_path)
 {
 	struct btrfs_root *root = fs_info->dev_root;
 	struct request_queue *q;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b219f24f1c07..9d19812f5ba7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -444,7 +444,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
-int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
+int btrfs_add_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				  const char *device_path,
 				  struct btrfs_device *srcdev,
-- 
2.13.1

