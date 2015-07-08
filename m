Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35672 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbbGHHmh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 03:42:37 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 4/6] Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
Date: Wed,  8 Jul 2015 15:32:52 +0800
Message-Id: <1436340774-10909-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
References: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/sysfs.c       | 6 +++---
 fs/btrfs/sysfs.h       | 2 +-
 fs/btrfs/volumes.c     | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index f7c390b..31e0145 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -587,7 +587,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
-	btrfs_kobj_rm_device(fs_info->fs_devices, src_device);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index df67f6b..52319d1 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -557,7 +557,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
-	btrfs_kobj_rm_device(fs_info->fs_devices, NULL);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
 }
 
 const char * const btrfs_feature_set_names[3] = {
@@ -637,7 +637,7 @@ static void init_feature_attrs(void)
 
 /* when one_device is NULL, it removes all device links */
 
-int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device)
 {
 	struct hd_struct *disk;
@@ -750,7 +750,7 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 
 	error = sysfs_create_files(super_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_kobj_rm_device(fs_devs, NULL);
+		btrfs_sysfs_rm_device_link(fs_devs, NULL);
 		return error;
 	}
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 6529680..9c09522 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -84,7 +84,7 @@ extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
-int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
 int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc1c8de..6483da1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1787,7 +1787,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev) {
 		device->fs_devices->open_devices--;
 		/* remove sysfs entry */
-		btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 	}
 
 	call_rcu(&device->rcu, free_device);
@@ -1957,7 +1957,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	WARN_ON(!tgtdev);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 
-	btrfs_kobj_rm_device(fs_info->fs_devices, tgtdev);
+	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
 
 	if (tgtdev->bdev) {
 		btrfs_scratch_superblock(tgtdev);
@@ -2374,7 +2374,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 error_trans:
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
-	btrfs_kobj_rm_device(root->fs_info->fs_devices, device);
+	btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.4.1

