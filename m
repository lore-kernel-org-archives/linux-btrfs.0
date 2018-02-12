Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753044AbeBLPgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:36:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFajNX066931
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:49 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2g3d8x07dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFZA73013948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFZ9sS002231
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: open code btrfs_init_dev_replace_tgtdev_for_resume()
Date: Mon, 12 Feb 2018 23:36:25 +0800
Message-Id: <20180212153625.19541-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_dev_replace_tgtdev_for_resume()  initializes replace
target device in few simple steps, so do it at the parent function.
Moreover, there isn't any other caller so just open code it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 10 ++++++++--
 fs/btrfs/volumes.c     | 13 -------------
 fs/btrfs/volumes.h     |  2 --
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7efbc4d1128b..197be3fe307b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -174,8 +174,14 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 			}
 			set_bit(BTRFS_DEV_STATE_REPLACE_TGT,
 				&dev_replace->tgtdev->dev_state);
-			btrfs_init_dev_replace_tgtdev_for_resume(fs_info,
-				dev_replace->tgtdev);
+
+			WARN_ON(fs_info->fs_devices->rw_devices == 0);
+			dev_replace->tgtdev->io_width = fs_info->sectorsize;
+			dev_replace->tgtdev->io_align = fs_info->sectorsize;
+			dev_replace->tgtdev->sector_size = fs_info->sectorsize;
+			dev_replace->tgtdev->fs_info = fs_info;
+			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+				&dev_replace->tgtdev->dev_state);
 		}
 		break;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bbdcf50cd65b..28c385d6419a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2681,19 +2681,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
-					      struct btrfs_device *tgtdev)
-{
-	u32 sectorsize = fs_info->sectorsize;
-
-	WARN_ON(fs_info->fs_devices->rw_devices == 0);
-	tgtdev->io_width = sectorsize;
-	tgtdev->io_align = sectorsize;
-	tgtdev->sector_size = sectorsize;
-	tgtdev->fs_info = fs_info;
-	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &tgtdev->dev_state);
-}
-
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 					struct btrfs_device *device)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7281f55dea05..c69d8b4eb4c6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -483,8 +483,6 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *srcdev);
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev);
-void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
-					      struct btrfs_device *tgtdev);
 void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path);
 int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 			   u64 logical, u64 len);
-- 
2.15.0

