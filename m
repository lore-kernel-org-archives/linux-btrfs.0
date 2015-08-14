Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbbHNKdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:54 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 20/23] Btrfs: move device close to btrfs_close_one_device
Date: Fri, 14 Aug 2015 18:33:05 +0800
Message-Id: <1439548388-29686-21-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

this will help to add the proposed device offline RFE
---
 fs/btrfs/volumes.c | 66 +++++++++++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h |  1 +
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f3ca87d..00ca858 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -768,36 +768,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
-		struct btrfs_device *new_device;
-		struct rcu_string *name;
-
-		if (device->bdev)
-			fs_devices->open_devices--;
-
-		if (device->writeable &&
-		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
-			list_del_init(&device->dev_alloc_list);
-			fs_devices->rw_devices--;
-		}
-
-		if (device->missing)
-			fs_devices->missing_devices--;
-
-		new_device = btrfs_alloc_device(NULL, &device->devid,
-						device->uuid);
-		BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
-
-		/* Safe because we are under uuid_mutex */
-		if (device->name) {
-			name = rcu_string_strdup(device->name->str, GFP_NOFS);
-			BUG_ON(!name); /* -ENOMEM */
-			rcu_assign_pointer(new_device->name, name);
-		}
-
-		list_replace_rcu(&device->dev_list, &new_device->dev_list);
-		new_device->fs_devices = device->fs_devices;
-
-		call_rcu(&device->rcu, free_device);
+		btrfs_close_one_device(device);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
@@ -6890,3 +6861,38 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
 		fs_devices = fs_devices->seed;
 	}
 }
+
+void btrfs_close_one_device(struct btrfs_device *device)
+{
+	struct btrfs_fs_devices *fs_devices = device->fs_devices;
+	struct btrfs_device *new_device;
+	struct rcu_string *name;
+
+	if (device->bdev)
+		fs_devices->open_devices--;
+
+	if (device->writeable &&
+	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
+		list_del_init(&device->dev_alloc_list);
+		fs_devices->rw_devices--;
+	}
+
+	if (device->missing)
+		fs_devices->missing_devices--;
+
+	new_device = btrfs_alloc_device(NULL, &device->devid,
+					device->uuid);
+	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
+
+	/* Safe because we are under uuid_mutex */
+	if (device->name) {
+		name = rcu_string_strdup(device->name->str, GFP_NOFS);
+		BUG_ON(!name); /* -ENOMEM */
+		rcu_assign_pointer(new_device->name, name);
+	}
+
+	list_replace_rcu(&device->dev_list, &new_device->dev_list);
+	new_device->fs_devices = device->fs_devices;
+
+	call_rcu(&device->rcu, free_device);
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 32a66c7..5f4911a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -550,5 +550,6 @@ static inline void unlock_chunks(struct btrfs_root *root)
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
+void btrfs_close_one_device(struct btrfs_device *device);
 
 #endif
-- 
2.4.1

