Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbBAIDQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:16 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 12/12] Btrfs: sysfs: add pointer to access fs_info from fs_devices
Date: Sun,  1 Feb 2015 16:01:42 +0800
Message-Id: <1422777702-12584-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

adds fs_info pointer with struct btrfs_fs_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   | 4 ++++
 fs/btrfs/volumes.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ac15fbb..4b5bac6 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -530,6 +530,8 @@ static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
+	fs_info->fs_devices->fs_info = NULL;
+
 	if (fs_info->space_info_kobj) {
 		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
 		kobject_del(fs_info->space_info_kobj);
@@ -729,6 +731,8 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
 	struct kobject *super_kobj = &fs_devs->super_kobj;
 
+	fs_devs->fs_info = fs_info;
+
 	error = btrfs_sysfs_add_fsid(fs_devs, NULL);
 	if (error)
 		return error;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a1df344..40c38ab 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -254,6 +254,7 @@ struct btrfs_fs_devices {
 	 */
 	int rotating;
 
+	struct btrfs_fs_info *fs_info;
 	/* sysfs kobjects */
 	struct kobject super_kobj;
 	struct kobject *device_dir_kobj;
-- 
1.9.1

