Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36330 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbCTKEd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 21/27] Btrfs: sysfs: separate kobject and attribute creation
Date: Fri, 20 Mar 2015 18:01:36 +0800
Message-Id: <1426845702-6298-22-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 18 +++++++++++++++++-
 fs/btrfs/sysfs.c   | 15 ++-------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0cd6550..4b7f3b8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2785,10 +2785,22 @@ retry_root_backup:
 
 	btrfs_close_extra_devices(fs_info, fs_devices, 1);
 
+	ret = btrfs_sysfs_add_fsid(fs_devices, NULL);
+	if (ret) {
+		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
+		goto fail_block_groups;
+	}
+
+	ret = btrfs_sysfs_add_device(fs_devices);
+	if (ret) {
+		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
+		goto fail_fsdev_sysfs;
+	}
+
 	ret = btrfs_sysfs_add_one(fs_info);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
-		goto fail_block_groups;
+		goto fail_fsdev_sysfs;
 	}
 
 	ret = btrfs_init_space_info(fs_info);
@@ -3002,6 +3014,9 @@ fail_cleaner:
 fail_sysfs:
 	btrfs_sysfs_remove_one(fs_info);
 
+fail_fsdev_sysfs:
+	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
+
 fail_block_groups:
 	btrfs_put_block_group_cache(fs_info);
 	btrfs_free_block_groups(fs_info);
@@ -3679,6 +3694,7 @@ void close_ctree(struct btrfs_root *root)
 	}
 
 	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 
 	btrfs_free_fs_roots(fs_info);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 1d34538..be5342f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -556,7 +556,6 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
 	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
 	btrfs_kobj_rm_device(fs_info->fs_devices, NULL);
-	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 }
 
 const char * const btrfs_feature_set_names[3] = {
@@ -688,10 +687,6 @@ int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 	int error = 0;
 	struct btrfs_device *dev;
 
-	error = btrfs_sysfs_add_device(fs_devices);
-	if (error)
-		return error;
-
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
@@ -747,19 +742,13 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 
 	btrfs_set_fs_info_ptr(fs_info);
 
-	error = btrfs_sysfs_add_fsid(fs_devs, NULL);
-	if (error)
-		return error;
-
 	error = btrfs_kobj_add_device(fs_devs, NULL);
-	if (error) {
-		btrfs_sysfs_remove_fsid(fs_devs);
+	if (error)
 		return error;
-	}
 
 	error = sysfs_create_files(super_kobj, btrfs_attrs);
 	if (error) {
-		btrfs_sysfs_remove_fsid(fs_devs);
+		btrfs_kobj_rm_device(fs_devs, NULL);
 		return error;
 	}
 
-- 
2.0.0.153.g79dcccc

