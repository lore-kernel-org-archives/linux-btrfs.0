Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40457 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752666AbcJEMXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 08:23:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71B2DACF7
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 12:23:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: opencode chunk locking, remove helpers
Date: Wed,  5 Oct 2016 14:23:04 +0200
Message-Id: <20161005122306.3530-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers are trivial and we don't use them consistently.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c          |  4 +--
 fs/btrfs/extent-tree.c      |  8 +++---
 fs/btrfs/free-space-cache.c |  4 +--
 fs/btrfs/volumes.c          | 70 ++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h          | 10 -------
 5 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54bc8c7c6bcd..6091663a9ed3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3989,7 +3989,7 @@ void close_ctree(struct btrfs_root *root)
 	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
-	lock_chunks(root);
+	mutex_lock(&fs_info->chunk_mutex);
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
@@ -3998,7 +3998,7 @@ void close_ctree(struct btrfs_root *root)
 		list_del_init(&em->list);
 		free_extent_map(em);
 	}
-	unlock_chunks(root);
+	mutex_unlock(&fs_info->chunk_mutex);
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 665da8f66ff1..00e5655cfd84 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9617,9 +9617,9 @@ int btrfs_inc_block_group_ro(struct btrfs_root *root,
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = update_block_group_flags(root, cache->flags);
-		lock_chunks(root->fs_info->chunk_root);
+		mutex_lock(&root->fs_info->chunk_mutex);
 		check_system_chunk(trans, root, alloc_flags);
-		unlock_chunks(root->fs_info->chunk_root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 	}
 	mutex_unlock(&root->fs_info->ro_block_group_mutex);
 
@@ -10647,7 +10647,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	memcpy(&key, &block_group->key, sizeof(key));
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	if (!list_empty(&em->list)) {
 		/* We're in the transaction->pending_chunks list. */
 		free_extent_map(em);
@@ -10715,7 +10715,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		free_extent_map(em);
 	}
 
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
 	if (ret)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d571bd2b697b..0e33d3d84870 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3328,7 +3328,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 	spin_unlock(&block_group->lock);
 
 	if (cleanup) {
-		lock_chunks(block_group->fs_info->chunk_root);
+		mutex_lock(&block_group->fs_info->chunk_mutex);
 		em_tree = &block_group->fs_info->mapping_tree.map_tree;
 		write_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, block_group->key.objectid,
@@ -3340,7 +3340,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 		 */
 		remove_extent_mapping(em_tree, em);
 		write_unlock(&em_tree->lock);
-		unlock_chunks(block_group->fs_info->chunk_root);
+		mutex_unlock(&block_group->fs_info->chunk_mutex);
 
 		/* once for us and once for the tree */
 		free_extent_map(em);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 035efce603a9..cc31b39160be 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1878,10 +1878,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	}
 
 	if (device->writeable) {
-		lock_chunks(root);
+		mutex_lock(&root->fs_info->chunk_mutex);
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
-		unlock_chunks(root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 		dev_name = kstrdup(device->name->str, GFP_KERNEL);
 		if (!dev_name) {
 			ret = -ENOMEM;
@@ -1985,11 +1985,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 
 error_undo:
 	if (device->writeable) {
-		lock_chunks(root);
+		mutex_lock(&root->fs_info->chunk_mutex);
 		list_add(&device->dev_alloc_list,
 			 &root->fs_info->fs_devices->alloc_list);
 		device->fs_devices->rw_devices++;
-		unlock_chunks(root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 	}
 	goto out;
 }
@@ -2216,9 +2216,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
 		device->fs_devices = seed_devices;
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
@@ -2407,7 +2407,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	device->fs_devices = root->fs_info->fs_devices;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
 	list_add(&device->dev_alloc_list,
 		 &root->fs_info->fs_devices->alloc_list);
@@ -2441,13 +2441,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	 */
 	btrfs_clear_space_info_full(root->fs_info);
 
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
-		lock_chunks(root);
+		mutex_lock(&root->fs_info->chunk_mutex);
 		ret = init_first_rw_device(trans, root, device);
-		unlock_chunks(root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
@@ -2691,13 +2691,13 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (!device->writeable)
 		return -EACCES;
 
-	lock_chunks(device->dev_root);
+	mutex_lock(&device->dev_root->fs_info->chunk_mutex);
 	old_total = btrfs_super_total_bytes(super_copy);
 	diff = new_size - device->total_bytes;
 
 	if (new_size <= device->total_bytes ||
 	    device->is_tgtdev_for_dev_replace) {
-		unlock_chunks(device->dev_root);
+		mutex_unlock(&device->dev_root->fs_info->chunk_mutex);
 		return -EINVAL;
 	}
 
@@ -2712,7 +2712,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (list_empty(&device->resized_list))
 		list_add_tail(&device->resized_list,
 			      &fs_devices->resized_devices);
-	unlock_chunks(device->dev_root);
+	mutex_unlock(&device->dev_root->fs_info->chunk_mutex);
 
 	return btrfs_update_device(trans, device);
 }
@@ -2767,7 +2767,7 @@ static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 	u32 cur;
 	struct btrfs_key key;
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	array_size = btrfs_super_sys_array_size(super_copy);
 
 	ptr = super_copy->sys_chunk_array;
@@ -2797,7 +2797,7 @@ static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 			cur += len;
 		}
 	}
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 	return ret;
 }
 
@@ -2834,9 +2834,9 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	}
 	map = em->map_lookup;
-	lock_chunks(root->fs_info->chunk_root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	check_system_chunk(trans, extent_root, map->type);
-	unlock_chunks(root->fs_info->chunk_root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	/*
 	 * Take the device list mutex to prevent races with the final phase of
@@ -2856,14 +2856,14 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		}
 
 		if (device->bytes_used > 0) {
-			lock_chunks(root);
+			mutex_lock(&root->fs_info->chunk_mutex);
 			btrfs_device_set_bytes_used(device,
 					device->bytes_used - dev_extent_len);
 			spin_lock(&root->fs_info->free_chunk_lock);
 			root->fs_info->free_chunk_space += dev_extent_len;
 			spin_unlock(&root->fs_info->free_chunk_lock);
 			btrfs_clear_space_info_full(root->fs_info);
-			unlock_chunks(root);
+			mutex_unlock(&root->fs_info->chunk_mutex);
 		}
 
 		if (map->stripes[i].dev) {
@@ -4383,7 +4383,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	path->reada = READA_FORWARD;
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 
 	btrfs_device_set_total_bytes(device, new_size);
 	if (device->writeable) {
@@ -4392,7 +4392,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		root->fs_info->free_chunk_space -= diff;
 		spin_unlock(&root->fs_info->free_chunk_lock);
 	}
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 again:
 	key.objectid = device->devid;
@@ -4464,7 +4464,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		goto done;
 	}
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 
 	/*
 	 * We checked in the above loop all device extents that were already in
@@ -4484,7 +4484,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 		if (contains_pending_extent(trans->transaction, device,
 					    &start, len)) {
-			unlock_chunks(root);
+			mutex_unlock(&root->fs_info->chunk_mutex);
 			checked_pending_chunks = true;
 			failed = 0;
 			retried = false;
@@ -4502,7 +4502,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	WARN_ON(diff > old_total);
 	btrfs_set_super_total_bytes(super_copy, old_total - diff);
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
@@ -4510,14 +4510,14 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 done:
 	btrfs_free_path(path);
 	if (ret) {
-		lock_chunks(root);
+		mutex_lock(&root->fs_info->chunk_mutex);
 		btrfs_device_set_total_bytes(device, old_size);
 		if (device->writeable)
 			device->fs_devices->total_rw_bytes += diff;
 		spin_lock(&root->fs_info->free_chunk_lock);
 		root->fs_info->free_chunk_space += diff;
 		spin_unlock(&root->fs_info->free_chunk_lock);
-		unlock_chunks(root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 	}
 	return ret;
 }
@@ -4531,11 +4531,11 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	u32 array_size;
 	u8 *ptr;
 
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	array_size = btrfs_super_sys_array_size(super_copy);
 	if (array_size + item_size + sizeof(disk_key)
 			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		unlock_chunks(root);
+		mutex_unlock(&root->fs_info->chunk_mutex);
 		return -EFBIG;
 	}
 
@@ -4546,7 +4546,7 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	memcpy(ptr, chunk, item_size);
 	item_size += sizeof(disk_key);
 	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	return 0;
 }
@@ -6795,7 +6795,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 		return -ENOMEM;
 
 	mutex_lock(&uuid_mutex);
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 
 	/*
 	 * Read all device items, and then all the chunk items. All
@@ -6862,7 +6862,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	}
 	ret = 0;
 error:
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_free_path(path);
@@ -7161,13 +7161,13 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 		return;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	lock_chunks(fs_info->dev_root);
+	mutex_lock(&fs_info->dev_root->fs_info->chunk_mutex);
 	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
 				 resized_list) {
 		list_del_init(&curr->resized_list);
 		curr->commit_total_bytes = curr->disk_total_bytes;
 	}
-	unlock_chunks(fs_info->dev_root);
+	mutex_unlock(&fs_info->dev_root->fs_info->chunk_mutex);
 	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
@@ -7184,7 +7184,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 		return;
 
 	/* In order to kick the device replace finish process */
-	lock_chunks(root);
+	mutex_lock(&root->fs_info->chunk_mutex);
 	list_for_each_entry(em, &transaction->pending_chunks, list) {
 		map = em->map_lookup;
 
@@ -7193,7 +7193,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 			dev->commit_bytes_used = dev->bytes_used;
 		}
 	}
-	unlock_chunks(root);
+	mutex_unlock(&root->fs_info->chunk_mutex);
 }
 
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6613e6335ca2..6f9422013715 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -512,16 +512,6 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
 void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 					struct btrfs_transaction *transaction);
 
-static inline void lock_chunks(struct btrfs_root *root)
-{
-	mutex_lock(&root->fs_info->chunk_mutex);
-}
-
-static inline void unlock_chunks(struct btrfs_root *root)
-{
-	mutex_unlock(&root->fs_info->chunk_mutex);
-}
-
 struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
-- 
2.10.0

