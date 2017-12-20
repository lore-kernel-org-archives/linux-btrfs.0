Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52885 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754205AbdLTIDc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:03:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBK81axR044556
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:32 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2eykaa8582-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBK83VDq024809
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:31 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBK83V75008796
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:03:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: handle volume split brain scenario
Date: Wed, 20 Dec 2017 16:04:02 +0800
Message-Id: <20171220080403.12702-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In raid configs RAID1/RAID5/RAID6 it's possible to have some devices
missing which would render btrfs to be mounted in degraded state but
still be operational. In those cases it's possible (albeit highly
undesirable) that the degraded and missing parts of the filesystem are
mounted independently. When writes occur such split-brain scenarios
(caused by intentional user action) then one of the sides of the RAID
config will have to be blown away when bringing it back to the
consistent state.

Handle split-brain volumes by setting a new flag
BTRFS_SUPER_FLAG_DEGRADED if the device is mounted degraded. So we
could detect and fail the mount if all the disks contains this flag.

To reassemble a split-brain volume first mount the good disk and then
scan in the device on which new writes can be ignored, (it needs patch
btrfs: handle dynamically reappearing missing device)

Warning:  A raid1 root device, in split brain condition, would fail
to bootup to protect the arbitrary loss of data.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
On top of misc-next kdave.
v2:
 Improve commit log.
 Rename to BTRFS_SUPER_FLAG_DEGRADED.
 Rename variables to fs_devices and device.
 In open_ctree() check for split-brain after btrfs_read_chunk_tree()

 fs/btrfs/disk-io.c              | 55 ++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/btrfs_tree.h |  1 +
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b302db90598c..e87924b7145b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,7 +61,8 @@
 				 BTRFS_HEADER_FLAG_RELOC |\
 				 BTRFS_SUPER_FLAG_ERROR |\
 				 BTRFS_SUPER_FLAG_SEEDING |\
-				 BTRFS_SUPER_FLAG_METADUMP)
+				 BTRFS_SUPER_FLAG_METADUMP|\
+				 BTRFS_SUPER_FLAG_DEGRADED)
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -2383,6 +2384,43 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+bool volume_has_split_brain(struct btrfs_fs_info *fs_info)
+{
+	unsigned long devs_moved_on = 0;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct list_head *head = &fs_devices->devices;
+	struct btrfs_device *device;
+
+again:
+	list_for_each_entry(device, head, dev_list) {
+		struct buffer_head *bh;
+		struct btrfs_super_block *sb;
+
+		if (!device->devid)
+			continue;
+
+		bh = btrfs_read_dev_super(device->bdev);
+		if (IS_ERR(bh))
+			continue;
+
+		sb = (struct btrfs_super_block *)bh->b_data;
+		if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_DEGRADED)
+			devs_moved_on++;
+		brelse(bh);
+	}
+
+	fs_devices = fs_devices->seed;
+	if (fs_devices) {
+		head = &fs_devices->devices;
+		goto again;
+	}
+
+	if (devs_moved_on == fs_info->fs_devices->total_devices)
+		return true;
+	else
+		return false;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2765,6 +2803,21 @@ int open_ctree(struct super_block *sb,
 		goto fail_tree_roots;
 	}
 
+	if (fs_info->fs_devices->missing_devices) {
+		btrfs_set_super_flags(fs_info->super_copy,
+				      fs_info->super_copy->flags |
+				      BTRFS_SUPER_FLAG_DEGRADED);
+	} else if (fs_info->super_copy->flags & BTRFS_SUPER_FLAG_DEGRADED) {
+		if (volume_has_split_brain(fs_info)) {
+			btrfs_err(fs_info,
+				  "Detected 'degraded' flag on all devices");
+			goto fail_tree_roots;
+		}
+		btrfs_set_super_flags(fs_info->super_copy,
+				      fs_info->super_copy->flags &
+				      ~BTRFS_SUPER_FLAG_DEGRADED);
+	}
+
 	/*
 	 * keep the device that is marked to be the target device for the
 	 * dev_replace procedure
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 33e814ef992f..c08b9b89e285 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2057,8 +2057,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	device->fs_devices->num_devices--;
 	device->fs_devices->total_devices--;
 
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
 		device->fs_devices->missing_devices--;
+		if (!device->fs_devices->missing_devices)
+			btrfs_set_super_flags(fs_info->super_copy,
+				fs_info->super_copy->flags &
+				~BTRFS_SUPER_FLAG_DEGRADED);
+	}
 
 	btrfs_assign_next_active_device(fs_info, device, NULL);
 
@@ -2132,8 +2137,13 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	list_del_rcu(&srcdev->dev_list);
 	list_del(&srcdev->dev_alloc_list);
 	fs_devices->num_devices--;
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state))
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &srcdev->dev_state)) {
 		fs_devices->missing_devices--;
+		if (!fs_devices->missing_devices)
+			btrfs_set_super_flags(fs_info->super_copy,
+				fs_info->super_copy->flags &
+				~BTRFS_SUPER_FLAG_DEGRADED);
+	}
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
 		fs_devices->rw_devices--;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 6d6e5da51527..ed1325d04033 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -456,6 +456,7 @@ struct btrfs_free_space_header {
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_DEGRADED	(1ULL << 36)
 
 
 /*
-- 
2.7.0

