Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36400 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbCTKEm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 27/27] Btrfs: create sys/fs/btrfs/fsid when scanned instead of when mounted
Date: Fri, 20 Mar 2015 18:01:42 +0800
Message-Id: <1426845702-6298-28-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

This patch changes the life cycle of the exisiting sysfs kobjects
/sys/fs/btrfs/<fsid> and /sys/fs/btrfs/<fsid>/devices,
from that they are created and destroyed by mount and unmount event
respectively as of now, to created and destroyed by scanned-registered and
module-unload respectively.

So that information from the btrfs_fs_devices can be added.

This does not change life cycle of any attributes from the fs_info.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 fs/btrfs/sysfs.c   | 7 ++++++-
 fs/btrfs/sysfs.h   | 3 ++-
 fs/btrfs/volumes.c | 6 +++++-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4b19e41..0155ce8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3694,7 +3694,8 @@ void close_ctree(struct btrfs_root *root)
 	}
 
 	btrfs_sysfs_remove_mounted(fs_info);
-	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
+	if (fs_info->fs_devices->seed)
+		btrfs_sysfs_remove_fsid(fs_info->fs_devices->seed);
 
 	btrfs_free_fs_roots(fs_info);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index e1b4f95..253e57e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -845,6 +845,7 @@ int btrfs_init_sysfs(void)
 void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	btrfs_sysfs_remove_fsid(NULL);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
@@ -855,7 +856,8 @@ void btrfs_sysfs_prepare_sprout_reset(void)
 }
 
 void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_fs_devices *seed_devices)
+				struct btrfs_fs_devices *seed_devices,
+				struct btrfs_fs_devices *old_devices)
 {
 	char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
@@ -898,4 +900,7 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
 					&seed_devices->super_kobj))
 			pr_warn("Btrfs: sysfs: kobject move failed\n");
 	}
+
+	btrfs_sysfs_add_fsid(old_devices, NULL, 0);
+	btrfs_sysfs_add_device(old_devices, 0);
 }
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index b23e94c..34b9864 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -79,5 +79,6 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_fs_devices *seed_devices);
+				struct btrfs_fs_devices *seed_devices,
+				struct btrfs_fs_devices *old_devices);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf59224..dfb5062 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -523,6 +523,10 @@ static noinline int device_list_add(const char *path,
 		list_add(&fs_devices->list, &fs_uuids);
 
 		device = NULL;
+		if (btrfs_sysfs_add_fsid(fs_devices, NULL, 0))
+			printk(KERN_WARNING "Btrfs: sysfs add fsid failed\n");
+		if (btrfs_sysfs_add_device(fs_devices, 0))
+			printk(KERN_WARNING "Btrfs: sysfs add device failed\n");
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
 				       disk_super->dev_item.uuid);
@@ -2064,7 +2068,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
 
-	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices);
+	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices, old_devices);
 
 	return 0;
 }
-- 
2.0.0.153.g79dcccc

