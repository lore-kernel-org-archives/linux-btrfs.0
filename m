Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36286 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbCTKE2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 17/27] Btrfs: sysfs btrfs_kobj_rm_device() pass fs_devices instead of fs_info
Date: Fri, 20 Mar 2015 18:01:32 +0800
Message-Id: <1426845702-6298-18-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

since btrfs_kobj_rm_device() does nothing with fs_info

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/sysfs.c       | 12 ++++++------
 fs/btrfs/sysfs.h       |  2 +-
 fs/btrfs/volumes.c     |  4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2acc0aa..124b60f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -592,7 +592,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_kobj_rm_device(fs_info, src_device);
+	btrfs_kobj_rm_device(fs_info->fs_devices, src_device);
 	btrfs_kobj_add_device(fs_info->fs_devices, tgt_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 76afc96..5055809 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -555,7 +555,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
-	btrfs_kobj_rm_device(fs_info, NULL);
+	btrfs_kobj_rm_device(fs_info->fs_devices, NULL);
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 }
 
@@ -636,20 +636,20 @@ static void init_feature_attrs(void)
 
 /* when one_device is NULL, it removes all device links */
 
-int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
+int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device)
 {
 	struct hd_struct *disk;
 	struct kobject *disk_kobj;
 
-	if (!fs_info->fs_devices->device_dir_kobj)
+	if (!fs_devices->device_dir_kobj)
 		return -EINVAL;
 
 	if (one_device && one_device->bdev) {
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
-		sysfs_remove_link(fs_info->fs_devices->device_dir_kobj,
+		sysfs_remove_link(fs_devices->device_dir_kobj,
 						disk_kobj->name);
 	}
 
@@ -657,13 +657,13 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	list_for_each_entry(one_device,
-			&fs_info->fs_devices->devices, dev_list) {
+			&fs_devices->devices, dev_list) {
 		if (!one_device->bdev)
 			continue;
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
-		sysfs_remove_link(fs_info->fs_devices->device_dir_kobj,
+		sysfs_remove_link(fs_devices->device_dir_kobj,
 						disk_kobj->name);
 	}
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index eeb86a8..3938ac1 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -72,6 +72,6 @@ extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
-int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
+int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ee318af..549f978 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1701,7 +1701,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_kobj_rm_device(root->fs_info, device);
+		btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
 	}
 
 	call_rcu(&device->rcu, free_device);
@@ -2285,7 +2285,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 error_trans:
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_kobj_rm_device(root->fs_info, device);
+	btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.0.0.153.g79dcccc

