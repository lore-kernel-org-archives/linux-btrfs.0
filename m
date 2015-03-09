Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20911 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbCIRKt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:49 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 15/26] Btrfs: sysfs btrfs_kobj_add_device() pass fs_devices instead of fs_info
Date: Tue, 10 Mar 2015 06:38:33 +0800
Message-Id: <1425940724-7744-16-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_kobj_add_device() does not need fs_info any more.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/sysfs.c       | 7 +++----
 fs/btrfs/sysfs.h       | 2 +-
 fs/btrfs/volumes.c     | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ca6a3a3..2acc0aa 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -593,7 +593,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	/* replace the sysfs entry */
 	btrfs_kobj_rm_device(fs_info, src_device);
-	btrfs_kobj_add_device(fs_info, tgt_device);
+	btrfs_kobj_add_device(fs_info->fs_devices, tgt_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a8ee136..76afc96 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -682,11 +682,10 @@ int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
 	return 0;
 }
 
-int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
-		struct btrfs_device *one_device)
+int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
+				struct btrfs_device *one_device)
 {
 	int error = 0;
-	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *dev;
 
 	error = btrfs_sysfs_add_device(fs_devices);
@@ -752,7 +751,7 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		return error;
 
-	error = btrfs_kobj_add_device(fs_info, NULL);
+	error = btrfs_kobj_add_device(fs_devs, NULL);
 	if (error) {
 		btrfs_sysfs_remove_fsid(fs_devs);
 		return error;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index f7dd298..eeb86a8 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -70,7 +70,7 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
-int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
+int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
 int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
                 struct btrfs_device *one_device);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 033e56a..ee318af 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2206,7 +2206,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 				    tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_kobj_add_device(root->fs_info, device);
+	btrfs_kobj_add_device(root->fs_info->fs_devices, device);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
-- 
2.0.0.153.g79dcccc

