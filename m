Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbbCIRKm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 13/26] Btrfs: sysfs: add pointer to access fs_info from fs_devices v2
Date: Tue, 10 Mar 2015 06:38:31 +0800
Message-Id: <1425940724-7744-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

adds fs_info pointer with struct btrfs_fs_devices.

v2: Fix a bug:d update fs_info pointer in open_seed_devices()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   |  4 ++++
 fs/btrfs/volumes.c | 18 ++++++++++++++++++
 fs/btrfs/volumes.h |  3 +++
 3 files changed, 25 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ac15fbb..95d6257 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -530,6 +530,8 @@ static void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
+	btrfs_reset_fs_info_ptr(fs_info);
+
 	if (fs_info->space_info_kobj) {
 		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
 		kobject_del(fs_info->space_info_kobj);
@@ -729,6 +731,8 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
 	struct kobject *super_kobj = &fs_devs->super_kobj;
 
+	btrfs_set_fs_info_ptr(fs_info);
+
 	error = btrfs_sysfs_add_fsid(fs_devs, NULL);
 	if (error)
 		return error;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c1b1038..033e56a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6688,3 +6688,21 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 	}
 	unlock_chunks(root);
 }
+
+void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	while (fs_devices) {
+		fs_devices->fs_info = fs_info;
+		fs_devices = fs_devices->seed;
+	}
+}
+
+void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	while (fs_devices) {
+		fs_devices->fs_info = NULL;
+		fs_devices = fs_devices->seed;
+	}
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d4586ac..e6514c7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -254,6 +254,7 @@ struct btrfs_fs_devices {
 	 */
 	int rotating;
 
+	struct btrfs_fs_info *fs_info;
 	/* sysfs kobjects */
 	struct kobject super_kobj;
 	struct kobject *device_dir_kobj;
@@ -540,5 +541,7 @@ static inline void unlock_chunks(struct btrfs_root *root)
 }
 
 struct list_head *btrfs_get_fs_uuids(void);
+void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
+void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 
 #endif
-- 
2.0.0.153.g79dcccc

