Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33853 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbcLFOw3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 09:52:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5A75ABD1
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 14:52:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: opencode chunk locking, remove helpers
Date: Tue,  6 Dec 2016 15:52:22 +0100
Message-Id: <20161206145222.14299-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers are trivial and we don't use them consistently.

Signed-off-by: David Sterba <dsterba@suse.com>
---

Refreshed on top of Jeff's cleanup regarding passing fs_info and root to
various functions.

 fs/btrfs/disk-io.c          |  4 +--
 fs/btrfs/extent-tree.c      |  8 +++---
 fs/btrfs/free-space-cache.c |  4 +--
 fs/btrfs/volumes.c          | 70 ++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h          | 10 -------
 5 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 196f1aafcea9..848d5e1c0585 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4003,7 +4003,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
@@ -4012,7 +4012,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		list_del_init(&em->list);
 		free_extent_map(em);
 	}
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2825019cd18f..e97302f437a1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9419,9 +9419,9 @@ int btrfs_inc_block_group_ro(struct btrfs_root *root,
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = update_block_group_flags(fs_info, cache->flags);
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		check_system_chunk(trans, fs_info, alloc_flags);
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 	}
 	mutex_unlock(&fs_info->ro_block_group_mutex);
 
@@ -10458,7 +10458,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	memcpy(&key, &block_group->key, sizeof(key));
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	if (!list_empty(&em->list)) {
 		/* We're in the transaction->pending_chunks list. */
 		free_extent_map(em);
@@ -10526,7 +10526,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		free_extent_map(em);
 	}
 
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	ret = remove_block_group_free_space(trans, fs_info, block_group);
 	if (ret)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2e8445e4ffa3..7015892c9ee8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3352,7 +3352,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 	spin_unlock(&block_group->lock);
 
 	if (cleanup) {
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		em_tree = &fs_info->mapping_tree.map_tree;
 		write_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, block_group->key.objectid,
@@ -3364,7 +3364,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 		 */
 		remove_extent_mapping(em_tree, em);
 		write_unlock(&em_tree->lock);
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 
 		/* once for us and once for the tree */
 		free_extent_map(em);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cf3838604987..bb8592e1a364 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1890,10 +1890,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, char *device_path, u64 devid)
 	}
 
 	if (device->writeable) {
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 		clear_super = true;
 	}
 
@@ -1982,11 +1982,11 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, char *device_path, u64 devid)
 
 error_undo:
 	if (device->writeable) {
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
 			 &fs_info->fs_devices->alloc_list);
 		device->fs_devices->rw_devices++;
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 	}
 	goto out;
 }
@@ -2211,9 +2211,9 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
 		device->fs_devices = seed_devices;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
@@ -2402,7 +2402,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	device->fs_devices = fs_info->fs_devices;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	list_add_rcu(&device->dev_list, &fs_info->fs_devices->devices);
 	list_add(&device->dev_alloc_list,
 		 &fs_info->fs_devices->alloc_list);
@@ -2435,13 +2435,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	 */
 	btrfs_clear_space_info_full(fs_info);
 
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		ret = init_first_rw_device(trans, fs_info, device);
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
@@ -2684,13 +2684,13 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (!device->writeable)
 		return -EACCES;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	old_total = btrfs_super_total_bytes(super_copy);
 	diff = new_size - device->total_bytes;
 
 	if (new_size <= device->total_bytes ||
 	    device->is_tgtdev_for_dev_replace) {
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 		return -EINVAL;
 	}
 
@@ -2705,7 +2705,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (list_empty(&device->resized_list))
 		list_add_tail(&device->resized_list,
 			      &fs_devices->resized_devices);
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	return btrfs_update_device(trans, device);
 }
@@ -2760,7 +2760,7 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 	u32 cur;
 	struct btrfs_key key;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	array_size = btrfs_super_sys_array_size(super_copy);
 
 	ptr = super_copy->sys_chunk_array;
@@ -2790,7 +2790,7 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 			cur += len;
 		}
 	}
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 	return ret;
 }
 
@@ -2824,9 +2824,9 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	}
 	map = em->map_lookup;
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	check_system_chunk(trans, fs_info, map->type);
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	/*
 	 * Take the device list mutex to prevent races with the final phase of
@@ -2846,14 +2846,14 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		}
 
 		if (device->bytes_used > 0) {
-			lock_chunks(fs_info);
+			mutex_lock(&fs_info->chunk_mutex);
 			btrfs_device_set_bytes_used(device,
 					device->bytes_used - dev_extent_len);
 			spin_lock(&fs_info->free_chunk_lock);
 			fs_info->free_chunk_space += dev_extent_len;
 			spin_unlock(&fs_info->free_chunk_lock);
 			btrfs_clear_space_info_full(fs_info);
-			unlock_chunks(fs_info);
+			mutex_unlock(&fs_info->chunk_mutex);
 		}
 
 		if (map->stripes[i].dev) {
@@ -4373,7 +4373,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	path->reada = READA_FORWARD;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 
 	btrfs_device_set_total_bytes(device, new_size);
 	if (device->writeable) {
@@ -4382,7 +4382,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		fs_info->free_chunk_space -= diff;
 		spin_unlock(&fs_info->free_chunk_lock);
 	}
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 again:
 	key.objectid = device->devid;
@@ -4454,7 +4454,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		goto done;
 	}
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 
 	/*
 	 * We checked in the above loop all device extents that were already in
@@ -4474,7 +4474,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 		if (contains_pending_extent(trans->transaction, device,
 					    &start, len)) {
-			unlock_chunks(fs_info);
+			mutex_unlock(&fs_info->chunk_mutex);
 			checked_pending_chunks = true;
 			failed = 0;
 			retried = false;
@@ -4492,7 +4492,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	WARN_ON(diff > old_total);
 	btrfs_set_super_total_bytes(super_copy, old_total - diff);
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
@@ -4500,14 +4500,14 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 done:
 	btrfs_free_path(path);
 	if (ret) {
-		lock_chunks(fs_info);
+		mutex_lock(&fs_info->chunk_mutex);
 		btrfs_device_set_total_bytes(device, old_size);
 		if (device->writeable)
 			device->fs_devices->total_rw_bytes += diff;
 		spin_lock(&fs_info->free_chunk_lock);
 		fs_info->free_chunk_space += diff;
 		spin_unlock(&fs_info->free_chunk_lock);
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 	}
 	return ret;
 }
@@ -4521,11 +4521,11 @@ static int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info,
 	u32 array_size;
 	u8 *ptr;
 
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	array_size = btrfs_super_sys_array_size(super_copy);
 	if (array_size + item_size + sizeof(disk_key)
 			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		unlock_chunks(fs_info);
+		mutex_unlock(&fs_info->chunk_mutex);
 		return -EFBIG;
 	}
 
@@ -4536,7 +4536,7 @@ static int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info,
 	memcpy(ptr, chunk, item_size);
 	item_size += sizeof(disk_key);
 	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	return 0;
 }
@@ -6783,7 +6783,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 
 	mutex_lock(&uuid_mutex);
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 
 	/*
 	 * Read all device items, and then all the chunk items. All
@@ -6850,7 +6850,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	}
 	ret = 0;
 error:
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_free_path(path);
@@ -7149,13 +7149,13 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 		return;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
 				 resized_list) {
 		list_del_init(&curr->resized_list);
 		curr->commit_total_bytes = curr->disk_total_bytes;
 	}
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
@@ -7172,7 +7172,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
 		return;
 
 	/* In order to kick the device replace finish process */
-	lock_chunks(fs_info);
+	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry(em, &transaction->pending_chunks, list) {
 		map = em->map_lookup;
 
@@ -7181,7 +7181,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
 			dev->commit_bytes_used = dev->bytes_used;
 		}
 	}
-	unlock_chunks(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 }
 
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 18b4449fa5a5..811328984702 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -534,16 +534,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
 void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
 					struct btrfs_transaction *transaction);
 
-static inline void lock_chunks(struct btrfs_fs_info *fs_info)
-{
-	mutex_lock(&fs_info->chunk_mutex);
-}
-
-static inline void unlock_chunks(struct btrfs_fs_info *fs_info)
-{
-	mutex_unlock(&fs_info->chunk_mutex);
-}
-
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
-- 
2.10.1

