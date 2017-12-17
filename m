Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34721 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752960AbdLQN5O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 08:57:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBHDupni059394
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:57:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ewstq80c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:57:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBHDqCEM001038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:52:12 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBHDqCQt024309
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 13:52:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs: handle volume split brain scenario
Date: Sun, 17 Dec 2017 21:52:46 +0800
Message-Id: <20171217135247.1838-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In two device configs of RAID1/RAID5 where one device can be missing
in the degraded mount, or in the configs such as four devices RAID6
where two devices can be missing, in these type of configs it can form
two separate set of devices where each of the set can be mounted without
the other set. And if user does that and writes the data, one set would
have to loose the data. As of now we just loose the data without the
user consent depending on the SB generation number which user won't have
any meaningful interpretations.

This patch introduces a new SB flag BTRFS_SUPER_FLAG_VOL_MOVED_ON which
will be set when RAID group is mounted with missing device, so when RAID
is mounted with no missing device and if all the devices contains this
flag then we know that each of these set are mounted without the other
set. In this scenario this patch will fail the mount so that user can
decide which set would they prefer to keep the data.

Now the procedure to assemble the disks would be to continue to mount
the good set first without the device set on which new data can be
ignored, and later run btrfs device scan to bring in the missing device
and complete the RAID group which then shall reset the flag
BTRFS_SUPER_FLAG_VOL_MOVED_ON.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
On top of kdave misc-next.

 fs/btrfs/disk-io.c              | 56 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c              | 14 +++++++++--
 include/uapi/linux/btrfs_tree.h |  1 +
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a3e9b74f6006..55bc6c846671 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,7 +61,8 @@
 				 BTRFS_HEADER_FLAG_RELOC |\
 				 BTRFS_SUPER_FLAG_ERROR |\
 				 BTRFS_SUPER_FLAG_SEEDING |\
-				 BTRFS_SUPER_FLAG_METADUMP)
+				 BTRFS_SUPER_FLAG_METADUMP|\
+				 BTRFS_SUPER_FLAG_VOL_MOVED_ON)
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -2383,6 +2384,43 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+bool volume_has_split_brain(struct btrfs_fs_info *fs_info)
+{
+	unsigned long devs_moved_on = 0;
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
+	struct list_head *head = &fs_devs->devices;
+	struct btrfs_device *dev;
+
+again:
+	list_for_each_entry(dev, head, dev_list) {
+		struct buffer_head *bh;
+		struct btrfs_super_block *sb;
+
+		if (!dev->devid)
+			continue;
+
+		bh = btrfs_read_dev_super(dev->bdev);
+		if (IS_ERR(bh))
+			continue;
+
+		sb = (struct btrfs_super_block *)bh->b_data;
+		if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_VOL_MOVED_ON)
+			devs_moved_on++;
+		brelse(bh);
+	}
+
+	fs_devs = fs_devs->seed;
+	if (fs_devs) {
+		head = &fs_devs->devices;
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
@@ -2872,6 +2910,22 @@ int open_ctree(struct super_block *sb,
 		goto fail_sysfs;
 	}
 
+	if (fs_info->fs_devices->missing_devices) {
+		btrfs_set_super_flags(fs_info->super_copy,
+			fs_info->super_copy->flags |
+			BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	} else if (fs_info->super_copy->flags &
+			BTRFS_SUPER_FLAG_VOL_MOVED_ON) {
+		if (volume_has_split_brain(fs_info)) {
+			btrfs_err(fs_info,
+				"Detected 'moved_on' flag on all device");
+			goto fail_sysfs;
+		}
+		btrfs_set_super_flags(fs_info->super_copy,
+			fs_info->super_copy->flags &
+			~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	}
+
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
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
+				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
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
+				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	}
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &srcdev->dev_state))
 		fs_devices->rw_devices--;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 6d6e5da51527..a9f625be0589 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -456,6 +456,7 @@ struct btrfs_free_space_header {
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_VOL_MOVED_ON	(1ULL << 36)
 
 
 /*
-- 
2.7.0

