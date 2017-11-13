Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35252 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdKMFyJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:54:09 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAD5s8xO010645
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5s86Q024105
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:08 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAD5s7ZS028220
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:54:08 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: handle volume split brain scenario
Date: Mon, 13 Nov 2017 13:53:40 +0800
Message-Id: <20171113055341.25764-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In two device configs of RAID1/RAID5 where one device can be missing
in the degraded mount, or in the configs such as four devices RAID6
where two devices can be missing, in these type of configs it can form
two separate set of devices where each of the set can be mounted without
the other set. And if user does that and writes the data, one set would
have to loose the data, as of now we just loose the data without the
user consent depending on the SB generation number which user won't have
any aware.

This patch introduces a new SB flag BTRFS_SUPER_FLAG_VOL_MOVED_ON which
will be set when RAID group is mounted with missing device, so when RAID
is mounted with no missing device and if all the devices contains this
flag then we know that each of these set are mounted without the other
set. In this scenario this patch will fail the mount so that user can
decide which set to keep the data.

Now the procedure to reassemble the disks would be to continue to mount
the good set first without the device set on which new data can be
ignored, and later on run btrfs device scan to bring-in the missing device
and complete the RAID group which then shall reset the flag
BTRFS_SUPER_FLAG_VOL_MOVED_ON.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c              | 53 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c              | 14 +++++++++--
 include/uapi/linux/btrfs_tree.h |  1 +
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..62b80226d157 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -59,7 +59,8 @@
 				 BTRFS_HEADER_FLAG_RELOC |\
 				 BTRFS_SUPER_FLAG_ERROR |\
 				 BTRFS_SUPER_FLAG_SEEDING |\
-				 BTRFS_SUPER_FLAG_METADUMP)
+				 BTRFS_SUPER_FLAG_METADUMP|\
+				 BTRFS_SUPER_FLAG_VOL_MOVED_ON)
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -2552,6 +2553,43 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
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
@@ -3044,6 +3082,19 @@ int open_ctree(struct super_block *sb,
 		goto fail_sysfs;
 	}
 
+	if (fs_info->fs_devices->missing_devices) {
+		btrfs_set_super_flags(fs_info->super_copy,
+			fs_info->super_copy->flags | BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	} else if (fs_info->super_copy->flags & BTRFS_SUPER_FLAG_VOL_MOVED_ON) {
+		if (volume_has_split_brain(fs_info)) {
+			btrfs_err(fs_info,
+				"Detected 'moved_on' flag on all device");
+			goto fail_sysfs;
+		}
+		btrfs_set_super_flags(fs_info->super_copy,
+			fs_info->super_copy->flags & ~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	}
+
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e7dd996831f2..ba32e2d73fbe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1988,8 +1988,13 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	device->fs_devices->num_devices--;
 	device->fs_devices->total_devices--;
 
-	if (device->missing)
+	if (device->missing) {
 		device->fs_devices->missing_devices--;
+		if (!device->missing)
+			btrfs_set_super_flags(fs_info->super_copy,
+				fs_info->super_copy->flags &
+				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	}
 
 	btrfs_assign_next_active_device(fs_info, device, NULL);
 
@@ -2062,8 +2067,13 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
 	fs_devices->num_devices--;
-	if (srcdev->missing)
+	if (srcdev->missing) {
 		fs_devices->missing_devices--;
+		if (!srcdev->missing)
+			btrfs_set_super_flags(fs_info->super_copy,
+				fs_info->super_copy->flags &
+				~BTRFS_SUPER_FLAG_VOL_MOVED_ON);
+	}
 
 	if (srcdev->writeable)
 		fs_devices->rw_devices--;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 10689e1fdf11..b53731b5b5a0 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -455,6 +455,7 @@ struct btrfs_free_space_header {
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_VOL_MOVED_ON	(1ULL << 36)
 
 
 /*
-- 
2.13.1

