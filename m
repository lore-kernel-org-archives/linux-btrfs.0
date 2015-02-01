Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51340 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbBAIDN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:13 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 10/12] Btrfs: sysfs: separate device kobject and its attribute creation
Date: Sun,  1 Feb 2015 16:01:40 +0800
Message-Id: <1422777702-12584-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Separate device kobject and its attribute creation so that device
kobject can be created from the device discovery thread.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5208a49..2cb4c69 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -645,13 +645,8 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
-		struct btrfs_device *one_device)
+int btrfs_sysfs_add_device(struct btrfs_fs_info *fs_info)
 {
-	int error = 0;
-	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	struct btrfs_device *dev;
-
 	if (!fs_info->device_dir_kobj)
 		fs_info->device_dir_kobj = kobject_create_and_add("devices",
 						&fs_info->super_kobj);
@@ -659,6 +654,20 @@ int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
 	if (!fs_info->device_dir_kobj)
 		return -ENOMEM;
 
+	return 0;
+}
+
+int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *one_device)
+{
+	int error = 0;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *dev;
+
+	error = btrfs_sysfs_add_device(fs_info);
+	if (error)
+		return error;
+
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
 		struct hd_struct *disk;
 		struct kobject *disk_kobj;
-- 
1.9.1

