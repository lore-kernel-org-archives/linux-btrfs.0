Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbbHNKd1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 03/23] Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
Date: Fri, 14 Aug 2015 18:32:48 +0800
Message-Id: <1439548388-29686-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/sysfs.c       | 4 ++--
 fs/btrfs/sysfs.h       | 2 +-
 fs/btrfs/volumes.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 564a7de..c1bf0d6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -376,7 +376,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
-	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
+	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
 	if (ret)
 		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 095a302..df67f6b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -683,7 +683,7 @@ int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
 	return 0;
 }
 
-int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 				struct btrfs_device *one_device)
 {
 	int error = 0;
@@ -744,7 +744,7 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 
 	btrfs_set_fs_info_ptr(fs_info);
 
-	error = btrfs_kobj_add_device(fs_devs, NULL);
+	error = btrfs_sysfs_add_device_link(fs_devs, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 6392527..6529680 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -82,7 +82,7 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
-int btrfs_kobj_add_device(struct btrfs_fs_devices *fs_devices,
+int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
 int btrfs_kobj_rm_device(struct btrfs_fs_devices *fs_devices,
                 struct btrfs_device *one_device);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7c84a81..18ea1eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2309,7 +2309,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 				    tmp + 1);
 
 	/* add sysfs device entry */
-	btrfs_kobj_add_device(root->fs_info->fs_devices, device);
+	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device);
 
 	/*
 	 * we've got more storage, clear any full flags on the space
-- 
2.4.1

