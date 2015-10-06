Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18981 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbJFPFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:05:48 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH V3 2/2] Btrfs: create a framework to create pool attributes
Date: Tue,  6 Oct 2015 23:05:32 +0800
Message-Id: <1444143932-2139-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444143932-2139-1-git-send-email-anand.jain@oracle.com>
References: <1444143932-2139-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

We need fsid kobject to hold pool attributes however
its created only when fs is mounted. So, this patch
changes the life cycle of the fsid and devices kobjects
/sys/fs/btrfs/<fsid> and /sys/fs/btrfs/<fsid>/devices,
from created and destroyed by mount and unmount event
to created and destroyed by scanned and module-unload
events respectively.

However this does not alter life cycle of fs attributes as such.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: changelog update. reworded subject from
      Btrfs: create sys/fs/btrfs/fsid when scanned instead of when mounted

v2: when the open_tree fails the sysfs should clean up for seed devices

 fs/btrfs/disk-io.c | 10 +++++-----
 fs/btrfs/sysfs.c   |  7 ++++++-
 fs/btrfs/sysfs.h   |  3 ++-
 fs/btrfs/volumes.c |  7 ++++++-
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ac1e168..ebeea0f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2937,7 +2937,7 @@ retry_root_backup:
 	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
-		goto fail_fsdev_sysfs;
+		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_space_info(fs_info);
@@ -3116,9 +3116,6 @@ fail_cleaner:
 fail_sysfs:
 	btrfs_sysfs_remove_mounted(fs_info);
 
-fail_fsdev_sysfs:
-	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
-
 fail_block_groups:
 	btrfs_put_block_group_cache(fs_info);
 	btrfs_free_block_groups(fs_info);
@@ -3815,7 +3812,10 @@ void close_ctree(struct btrfs_root *root)
 	}
 
 	btrfs_sysfs_remove_mounted(fs_info);
-	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
+	if (fs_info->fs_devices->seed) {
+		btrfs_sysfs_remove_fsid(fs_info->fs_devices->seed);
+		btrfs_sysfs_rm_seed_dir(fs_info->fs_devices);
+	}
 
 	btrfs_free_fs_roots(fs_info);
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3a45462..c155d34 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -880,6 +880,7 @@ out1:
 void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	btrfs_sysfs_remove_fsid(NULL);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
@@ -890,7 +891,8 @@ void btrfs_sysfs_prepare_sprout_reset(void)
 }
 
 void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_fs_devices *seed_devices)
+				struct btrfs_fs_devices *seed_devices,
+				struct btrfs_fs_devices *old_devices)
 {
 	char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
@@ -939,4 +941,7 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
 					seed_devices->seed_dir_kobj))
 			pr_warn("Btrfs: sysfs: kobject move failed\n");
 	}
+
+	btrfs_sysfs_add_fsid(old_devices, NULL, 0);
+	btrfs_sysfs_add_device(old_devices, 0);
 }
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 5ace289..0a592f2 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -93,5 +93,6 @@ int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
 int btrfs_sysfs_add_seed_dir(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_rm_seed_dir(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
-				struct btrfs_fs_devices *seed_devices);
+				struct btrfs_fs_devices *seed_devices,
+				struct btrfs_fs_devices *old_devices);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 227f4be..4af0cf6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -528,6 +528,10 @@ static noinline int device_list_add(const char *path,
 		list_add(&fs_devices->list, &fs_uuids);
 
 		device = NULL;
+		if (btrfs_sysfs_add_fsid(fs_devices, NULL, 0))
+			printk(KERN_WARNING "Btrfs: sysfs add fsid failed\n");
+		if (btrfs_sysfs_add_device(fs_devices, 0))
+			printk(KERN_WARNING "Btrfs: sysfs add device failed\n");
 	} else {
 		device = __find_device(&fs_devices->devices, devid,
 				       disk_super->dev_item.uuid);
@@ -797,6 +801,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		fs_devices = seed_devices;
 		seed_devices = fs_devices->seed;
 		__btrfs_close_devices(fs_devices);
+		btrfs_sysfs_remove_fsid(fs_devices);
 		free_fs_devices(fs_devices);
 	}
 	/*
@@ -2102,7 +2107,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 		      ~BTRFS_SUPER_FLAG_SEEDING;
 	btrfs_set_super_flags(disk_super, super_flags);
 
-	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices);
+	btrfs_sysfs_prepare_sprout(fs_devices, seed_devices, old_devices);
 
 	return 0;
 }
-- 
2.4.1

