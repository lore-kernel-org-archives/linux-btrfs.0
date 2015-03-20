Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36208 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbCTKEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:14 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 07/27] Btrfs: sysfs: reorder the kobject creations
Date: Fri, 20 Mar 2015 18:01:22 +0800
Message-Id: <1426845702-6298-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

As of now the order in which the kobjects are created
at btrfs_sysfs_add_one() is..
 fsid
 features
 unknown features (dynamic features)
 devices.

Since we would move fsid and device kobject to fs_devices
from fs_info structure, this patch will reorder in which
the kobjects are created as below.
 fsid
 devices
 features
 unknown features (dynamic features)

And hence the btrfs_sysfs_remove_one() will follow the same
in reverse order. and the device kobject destroy now can
be moved into the function __btrfs_sysfs_remove_one()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 506f7e4..c3e7f06 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -510,6 +510,13 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 
 static void __btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->device_dir_kobj) {
+		btrfs_kobj_rm_device(fs_info, NULL);
+		kobject_del(fs_info->device_dir_kobj);
+		kobject_put(fs_info->device_dir_kobj);
+		fs_info->device_dir_kobj = NULL;
+	}
+
 	kobject_del(&fs_info->super_kobj);
 	kobject_put(&fs_info->super_kobj);
 	wait_for_completion(&fs_info->kobj_unregister);
@@ -522,12 +529,6 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->space_info_kobj);
 		kobject_put(fs_info->space_info_kobj);
 	}
-	if (fs_info->device_dir_kobj) {
-		btrfs_kobj_rm_device(fs_info, NULL);
-		kobject_del(fs_info->device_dir_kobj);
-		kobject_put(fs_info->device_dir_kobj);
-		fs_info->device_dir_kobj = NULL;
-	}
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
 	__btrfs_sysfs_remove_one(fs_info);
@@ -700,6 +701,12 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		return error;
 
+	error = btrfs_kobj_add_device(fs_info, NULL);
+	if (error) {
+		__btrfs_sysfs_remove_one(fs_info);
+		return error;
+	}
+
 	error = sysfs_create_group(&fs_info->super_kobj,
 				   &btrfs_feature_attr_group);
 	if (error) {
@@ -711,10 +718,6 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		goto failure;
 
-	error = btrfs_kobj_add_device(fs_info, NULL);
-	if (error)
-		goto failure;
-
 	fs_info->space_info_kobj = kobject_create_and_add("allocation",
 						  &fs_info->super_kobj);
 	if (!fs_info->space_info_kobj) {
-- 
2.0.0.153.g79dcccc

