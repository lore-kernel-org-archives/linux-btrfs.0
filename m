Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753761AbeDSQft (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:35:49 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00031AD00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:35:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 03/16] btrfs: export and rename free_device
Date: Thu, 19 Apr 2018 18:33:16 +0200
Message-Id: <b74343551a6fa25b2153c7b43959434f6c8e2371.1524146555.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function will be used outside of volumes.c, the allocation
btrfs_alloc_device is also exported.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 24 ++++++++++++------------
 fs/btrfs/volumes.h |  1 +
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8086c5687b72..ca5521cc1a5b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -246,7 +246,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	return fs_devs;
 }
 
-static void free_device(struct btrfs_device *device)
+void btrfs_free_device(struct btrfs_device *device)
 {
 	rcu_string_free(device->name);
 	bio_put(device->flush_bio);
@@ -261,7 +261,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-		free_device(device);
+		btrfs_free_device(device);
 	}
 	kfree(fs_devices);
 }
@@ -294,7 +294,7 @@ void __exit btrfs_cleanup_fs_uuids(void)
 /*
  * Returns a pointer to a new btrfs_device on success; ERR_PTR() on error.
  * Returned struct is not linked onto any lists and must be destroyed using
- * free_device.
+ * btrfs_free_device.
  */
 static struct btrfs_device *__alloc_device(void)
 {
@@ -650,7 +650,7 @@ static void btrfs_free_stale_devices(const char *path,
 			} else {
 				fs_devs->num_devices--;
 				list_del(&dev->dev_list);
-				free_device(dev);
+				btrfs_free_device(dev);
 			}
 		}
 	}
@@ -765,7 +765,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
-			free_device(device);
+			btrfs_free_device(device);
 			return ERR_PTR(-ENOMEM);
 		}
 		rcu_assign_pointer(device->name, name);
@@ -878,7 +878,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 			name = rcu_string_strdup(orig_dev->name->str,
 					GFP_KERNEL);
 			if (!name) {
-				free_device(device);
+				btrfs_free_device(device);
 				goto error;
 			}
 			rcu_assign_pointer(device->name, name);
@@ -950,7 +950,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-		free_device(device);
+		btrfs_free_device(device);
 	}
 
 	if (fs_devices->seed) {
@@ -968,7 +968,7 @@ static void free_device_rcu(struct rcu_head *head)
 	struct btrfs_device *device;
 
 	device = container_of(head, struct btrfs_device, rcu);
-	free_device(device);
+	btrfs_free_device(device);
 }
 
 static void btrfs_close_bdev(struct btrfs_device *device)
@@ -2582,7 +2582,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (trans)
 		btrfs_end_transaction(trans);
 error_free_device:
-	free_device(device);
+	btrfs_free_device(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
 	if (seeding_dev && !unlocked) {
@@ -2653,7 +2653,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-		free_device(device);
+		btrfs_free_device(device);
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -6419,7 +6419,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
  *
  * Return: a pointer to a new &struct btrfs_device on success; ERR_PTR()
  * on error.  Returned struct is not linked onto any lists and must be
- * destroyed with free_device.
+ * destroyed with btrfs_free_device.
  */
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
@@ -6442,7 +6442,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 
 		ret = find_next_devid(fs_info, &tmp);
 		if (ret) {
-			free_device(dev);
+			btrfs_free_device(dev);
 			return ERR_PTR(ret);
 		}
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d1fcaea9fef5..45e3ece21290 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -434,6 +434,7 @@ int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
+void btrfs_free_device(struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    const char *device_path, u64 devid);
 void __exit btrfs_cleanup_fs_uuids(void);
-- 
2.16.2

