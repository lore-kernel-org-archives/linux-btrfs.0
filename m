Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37886 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbbHNKda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 05/23] Btrfs: rename super_kobj to fsid_kobj
Date: Fri, 14 Aug 2015 18:32:50 +0800
Message-Id: <1439548388-29686-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   | 36 ++++++++++++++++++------------------
 fs/btrfs/volumes.c |  2 +-
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 52319d1..e0ac859 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -437,24 +437,24 @@ static const struct attribute *btrfs_attrs[] = {
 	NULL,
 };
 
-static void btrfs_release_super_kobj(struct kobject *kobj)
+static void btrfs_release_fsid_kobj(struct kobject *kobj)
 {
 	struct btrfs_fs_devices *fs_devs = to_fs_devs(kobj);
 
-	memset(&fs_devs->super_kobj, 0, sizeof(struct kobject));
+	memset(&fs_devs->fsid_kobj, 0, sizeof(struct kobject));
 	complete(&fs_devs->kobj_unregister);
 }
 
 static struct kobj_type btrfs_ktype = {
 	.sysfs_ops	= &kobj_sysfs_ops,
-	.release	= btrfs_release_super_kobj,
+	.release	= btrfs_release_fsid_kobj,
 };
 
 static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj)
 {
 	if (kobj->ktype != &btrfs_ktype)
 		return NULL;
-	return container_of(kobj, struct btrfs_fs_devices, super_kobj);
+	return container_of(kobj, struct btrfs_fs_devices, fsid_kobj);
 }
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)
@@ -502,12 +502,12 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 			attrs[0] = &fa->kobj_attr.attr;
 			if (add) {
 				int ret;
-				ret = sysfs_merge_group(&fs_info->fs_devices->super_kobj,
+				ret = sysfs_merge_group(&fs_info->fs_devices->fsid_kobj,
 							&agroup);
 				if (ret)
 					return ret;
 			} else
-				sysfs_unmerge_group(&fs_info->fs_devices->super_kobj,
+				sysfs_unmerge_group(&fs_info->fs_devices->fsid_kobj,
 						    &agroup);
 		}
 
@@ -523,9 +523,9 @@ static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 		fs_devs->device_dir_kobj = NULL;
 	}
 
-	if (fs_devs->super_kobj.state_initialized) {
-		kobject_del(&fs_devs->super_kobj);
-		kobject_put(&fs_devs->super_kobj);
+	if (fs_devs->fsid_kobj.state_initialized) {
+		kobject_del(&fs_devs->fsid_kobj);
+		kobject_put(&fs_devs->fsid_kobj);
 		wait_for_completion(&fs_devs->kobj_unregister);
 	}
 }
@@ -555,8 +555,8 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 		kobject_put(fs_info->space_info_kobj);
 	}
 	addrm_unknown_feature_attrs(fs_info, false);
-	sysfs_remove_group(&fs_info->fs_devices->super_kobj, &btrfs_feature_attr_group);
-	sysfs_remove_files(&fs_info->fs_devices->super_kobj, btrfs_attrs);
+	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj, &btrfs_feature_attr_group);
+	sysfs_remove_files(&fs_info->fs_devices->fsid_kobj, btrfs_attrs);
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
 }
 
@@ -675,7 +675,7 @@ int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
 {
 	if (!fs_devs->device_dir_kobj)
 		fs_devs->device_dir_kobj = kobject_create_and_add("devices",
-						&fs_devs->super_kobj);
+						&fs_devs->fsid_kobj);
 
 	if (!fs_devs->device_dir_kobj)
 		return -ENOMEM;
@@ -730,8 +730,8 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 	int error;
 
 	init_completion(&fs_devs->kobj_unregister);
-	fs_devs->super_kobj.kset = btrfs_kset;
-	error = kobject_init_and_add(&fs_devs->super_kobj,
+	fs_devs->fsid_kobj.kset = btrfs_kset;
+	error = kobject_init_and_add(&fs_devs->fsid_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
 	return error;
 }
@@ -740,7 +740,7 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 {
 	int error;
 	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
-	struct kobject *super_kobj = &fs_devs->super_kobj;
+	struct kobject *fsid_kobj = &fs_devs->fsid_kobj;
 
 	btrfs_set_fs_info_ptr(fs_info);
 
@@ -748,13 +748,13 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 	if (error)
 		return error;
 
-	error = sysfs_create_files(super_kobj, btrfs_attrs);
+	error = sysfs_create_files(fsid_kobj, btrfs_attrs);
 	if (error) {
 		btrfs_sysfs_rm_device_link(fs_devs, NULL);
 		return error;
 	}
 
-	error = sysfs_create_group(super_kobj,
+	error = sysfs_create_group(fsid_kobj,
 				   &btrfs_feature_attr_group);
 	if (error)
 		goto failure;
@@ -764,7 +764,7 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 		goto failure;
 
 	fs_info->space_info_kobj = kobject_create_and_add("allocation",
-						  super_kobj);
+						  fsid_kobj);
 	if (!fs_info->space_info_kobj) {
 		error = -ENOMEM;
 		goto failure;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4c7c344..8368393 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2350,7 +2350,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		 */
 		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
 						root->fs_info->fsid);
-		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
+		if (kobject_rename(&root->fs_info->fs_devices->fsid_kobj,
 								fsid_buf))
 			pr_warn("BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2ca784a..413a70c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -256,7 +256,7 @@ struct btrfs_fs_devices {
 
 	struct btrfs_fs_info *fs_info;
 	/* sysfs kobjects */
-	struct kobject super_kobj;
+	struct kobject fsid_kobj;
 	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
 };
-- 
2.4.1

