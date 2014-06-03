Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49212 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaFCDgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:40 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 3/6 v2] btrfs: dev add should add its sysfs entry
Date: Tue,  3 Jun 2014 11:36:01 +0800
Message-Id: <1401766564-7381-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>

we would need the device links to be created,
when device is added.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v2: the function name change applied here

 fs/btrfs/sysfs.c   | 12 +++++++++---
 fs/btrfs/sysfs.h   |  2 ++
 fs/btrfs/volumes.c |  5 +++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4100771..9733cfc 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -592,14 +592,17 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info)
+int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *one_device)
 {
 	int error = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *dev;
 
-	fs_info->device_dir_kobj = kobject_create_and_add("devices",
+	if (!fs_info->device_dir_kobj)
+		fs_info->device_dir_kobj = kobject_create_and_add("devices",
 						&fs_info->super_kobj);
+
 	if (!fs_info->device_dir_kobj)
 		return -ENOMEM;
 
@@ -610,6 +613,9 @@ static int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info)
 		if (!dev->bdev)
 			continue;
 
+		if (one_device && one_device != dev)
+			continue;
+
 		disk = dev->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
@@ -653,7 +659,7 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		goto failure;
 
-	error = btrfs_kobj_add_device(fs_info);
+	error = btrfs_kobj_add_device(fs_info, NULL);
 	if (error)
 		goto failure;
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 529554e..ac46df3 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -66,6 +66,8 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
+int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *one_device);
 int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
                 struct btrfs_device *one_device);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5f434d7..4a66e6b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2101,6 +2101,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	total_bytes = btrfs_super_num_devices(root->fs_info->super_copy);
 	btrfs_set_super_num_devices(root->fs_info->super_copy,
 				    total_bytes + 1);
+
+	/* add sysfs device entry */
+	btrfs_kobj_add_device(root->fs_info, device);
+
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
@@ -2161,6 +2165,7 @@ error_trans:
 	unlock_chunks(root);
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
+	btrfs_kobj_rm_device(root->fs_info, device);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
1.8.5.3

