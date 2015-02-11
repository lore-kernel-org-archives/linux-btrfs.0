Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbbBLHWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:22:17 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 12/24] Btrfs: sysfs: add pointer to access fs_info from fs_devices
Date: Thu, 12 Feb 2015 07:20:56 +0800
Message-Id: <1423696868-8971-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

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
index c2e5bd0..53fd278 100644
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
2.0.0.153.g79dcccc

