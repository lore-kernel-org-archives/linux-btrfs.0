Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52841 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdJaRqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E32DCAD9F
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/11] btrfs: use free_device where opencoded
Date: Tue, 31 Oct 2017 18:44:40 +0100
Message-Id: <eae0c7b1a25267d3af10f9f31155098c1bdbacaf.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 35c546aade83..f206e83d4f52 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -195,9 +195,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
+		free_device(device);
 	}
 	kfree(fs_devices);
 }
@@ -590,9 +588,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			} else {
 				fs_devs->num_devices--;
 				list_del(&dev->dev_list);
-				rcu_string_free(dev->name);
-				bio_put(dev->flush_bio);
-				kfree(dev);
+				free_device(dev);
 			}
 			break;
 		}
@@ -644,8 +640,7 @@ static noinline int device_list_add(const char *path,
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name) {
-			bio_put(device->flush_bio);
-			kfree(device);
+			free_device(device);
 			return -ENOMEM;
 		}
 		rcu_assign_pointer(device->name, name);
@@ -757,8 +752,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 			name = rcu_string_strdup(orig_dev->name->str,
 					GFP_KERNEL);
 			if (!name) {
-				bio_put(device->flush_bio);
-				kfree(device);
+				free_device(device);
 				goto error;
 			}
 			rcu_assign_pointer(device->name, name);
@@ -822,9 +816,7 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
+		free_device(device);
 	}
 
 	if (fs_devices->seed) {
@@ -842,9 +834,7 @@ static void free_device_rcu(struct rcu_head *head)
 	struct btrfs_device *device;
 
 	device = container_of(head, struct btrfs_device, rcu);
-	rcu_string_free(device->name);
-	bio_put(device->flush_bio);
-	kfree(device);
+	free_device(device);
 }
 
 static void btrfs_close_bdev(struct btrfs_device *device)
@@ -2354,8 +2344,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-		bio_put(device->flush_bio);
-		kfree(device);
+		free_device(device);
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -2363,9 +2352,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		rcu_string_free(device->name);
-		bio_put(device->flush_bio);
-		kfree(device);
+		free_device(device);
 		ret = PTR_ERR(trans);
 		goto error;
 	}
@@ -2507,9 +2494,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		sb->s_flags |= MS_RDONLY;
 	if (trans)
 		btrfs_end_transaction(trans);
-	rcu_string_free(device->name);
-	bio_put(device->flush_bio);
-	kfree(device);
+	free_device(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
 	if (seeding_dev && !unlocked) {
@@ -2575,8 +2560,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-		bio_put(device->flush_bio);
-		kfree(device);
+		free_device(device);
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -6292,8 +6276,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 
 		ret = find_next_devid(fs_info, &tmp);
 		if (ret) {
-			bio_put(dev->flush_bio);
-			kfree(dev);
+			free_device(dev);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.14.0

