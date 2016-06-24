Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbcFXWPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6984EADE5
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 25/31] btrfs: root->fs_info cleanup, lock/unlock_chunks
Date: Fri, 24 Jun 2016 18:15:18 -0400
Message-Id: <1466806524-27508-26-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c          |  4 +--
 fs/btrfs/extent-tree.c      |  8 +++---
 fs/btrfs/free-space-cache.c |  4 +--
 fs/btrfs/volumes.c          | 70 ++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h          |  8 +++---
 5 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b7891c4..18b41d7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3949,7 +3949,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	__btrfs_free_block_rsv(root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
@@ -3958,7 +3958,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		list_del_init(&em->list);
 		free_extent_map(em);
 	}
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 088182c..14f4d05 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9418,9 +9418,9 @@ again:
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = update_block_group_flags(root, cache->flags);
-		lock_chunks(root->fs_info->chunk_root);
+		lock_chunks(root->fs_info);
 		check_system_chunk(trans, root, alloc_flags);
-		unlock_chunks(root->fs_info->chunk_root);
+		unlock_chunks(root->fs_info);
 	}
 	mutex_unlock(&root->fs_info->ro_block_group_mutex);
 
@@ -10433,7 +10433,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	memcpy(&key, &block_group->key, sizeof(key));
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	if (!list_empty(&em->list)) {
 		/* We're in the transaction->pending_chunks list. */
 		free_extent_map(em);
@@ -10501,7 +10501,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		free_extent_map(em);
 	}
 
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 
 	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
 	if (ret)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 02803e9..b194c09 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3327,7 +3327,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 	spin_unlock(&block_group->lock);
 
 	if (cleanup) {
-		lock_chunks(block_group->fs_info->chunk_root);
+		lock_chunks(block_group->fs_info);
 		em_tree = &block_group->fs_info->mapping_tree.map_tree;
 		write_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, block_group->key.objectid,
@@ -3339,7 +3339,7 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 		 */
 		remove_extent_mapping(em_tree, em);
 		write_unlock(&em_tree->lock);
-		unlock_chunks(block_group->fs_info->chunk_root);
+		unlock_chunks(block_group->fs_info);
 
 		/* once for us and once for the tree */
 		free_extent_map(em);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 26e8687..e90246d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1833,10 +1833,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	}
 
 	if (device->writeable) {
-		lock_chunks(root);
+		lock_chunks(root->fs_info);
 		list_del_init(&device->dev_alloc_list);
 		device->fs_devices->rw_devices--;
-		unlock_chunks(root);
+		unlock_chunks(root->fs_info);
 		dev_name = kstrdup(device->name->str, GFP_KERNEL);
 		if (!dev_name) {
 			ret = -ENOMEM;
@@ -1938,11 +1938,11 @@ out:
 
 error_undo:
 	if (device->writeable) {
-		lock_chunks(root);
+		lock_chunks(root->fs_info);
 		list_add(&device->dev_alloc_list,
 			 &root->fs_info->fs_devices->alloc_list);
 		device->fs_devices->rw_devices++;
-		unlock_chunks(root);
+		unlock_chunks(root->fs_info);
 	}
 	goto out;
 }
@@ -2164,9 +2164,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
 		device->fs_devices = seed_devices;
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
@@ -2356,7 +2356,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	device->fs_devices = root->fs_info->fs_devices;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);
 	list_add(&device->dev_alloc_list,
 		 &root->fs_info->fs_devices->alloc_list);
@@ -2390,13 +2390,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	 */
 	btrfs_clear_space_info_full(root->fs_info);
 
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
-		lock_chunks(root);
+		lock_chunks(root->fs_info);
 		ret = init_first_rw_device(trans, root, device);
-		unlock_chunks(root);
+		unlock_chunks(root->fs_info);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
@@ -2641,13 +2641,13 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (!device->writeable)
 		return -EACCES;
 
-	lock_chunks(device->fs_info->dev_root);
+	lock_chunks(device->fs_info);
 	old_total = btrfs_super_total_bytes(super_copy);
 	diff = new_size - device->total_bytes;
 
 	if (new_size <= device->total_bytes ||
 	    device->is_tgtdev_for_dev_replace) {
-		unlock_chunks(device->fs_info->dev_root);
+		unlock_chunks(device->fs_info);
 		return -EINVAL;
 	}
 
@@ -2662,7 +2662,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (list_empty(&device->resized_list))
 		list_add_tail(&device->resized_list,
 			      &fs_devices->resized_devices);
-	unlock_chunks(device->fs_info->dev_root);
+	unlock_chunks(device->fs_info);
 
 	return btrfs_update_device(trans, device);
 }
@@ -2718,7 +2718,7 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 	u32 cur;
 	struct btrfs_key key;
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	array_size = btrfs_super_sys_array_size(super_copy);
 
 	ptr = super_copy->sys_chunk_array;
@@ -2748,7 +2748,7 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 			cur += len;
 		}
 	}
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 	return ret;
 }
 
@@ -2785,9 +2785,9 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	}
 	map = em->map_lookup;
-	lock_chunks(root->fs_info->chunk_root);
+	lock_chunks(fs_info);
 	check_system_chunk(trans, extent_root, map->type);
-	unlock_chunks(root->fs_info->chunk_root);
+	unlock_chunks(fs_info);
 
 	/*
 	 * Take the device list mutex to prevent races with the final phase of
@@ -2807,14 +2807,14 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		}
 
 		if (device->bytes_used > 0) {
-			lock_chunks(root);
+			lock_chunks(root->fs_info);
 			btrfs_device_set_bytes_used(device,
 					device->bytes_used - dev_extent_len);
 			spin_lock(&root->fs_info->free_chunk_lock);
 			root->fs_info->free_chunk_space += dev_extent_len;
 			spin_unlock(&root->fs_info->free_chunk_lock);
 			btrfs_clear_space_info_full(root->fs_info);
-			unlock_chunks(root);
+			unlock_chunks(root->fs_info);
 		}
 
 		if (map->stripes[i].dev) {
@@ -4315,7 +4315,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	path->reada = READA_FORWARD;
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 
 	btrfs_device_set_total_bytes(device, new_size);
 	if (device->writeable) {
@@ -4324,7 +4324,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		root->fs_info->free_chunk_space -= diff;
 		spin_unlock(&root->fs_info->free_chunk_lock);
 	}
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 
 again:
 	key.objectid = device->devid;
@@ -4396,7 +4396,7 @@ again:
 		goto done;
 	}
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 
 	/*
 	 * We checked in the above loop all device extents that were already in
@@ -4416,7 +4416,7 @@ again:
 
 		if (contains_pending_extent(trans->transaction, device,
 					    &start, len)) {
-			unlock_chunks(root);
+			unlock_chunks(root->fs_info);
 			checked_pending_chunks = true;
 			failed = 0;
 			retried = false;
@@ -4434,7 +4434,7 @@ again:
 
 	WARN_ON(diff > old_total);
 	btrfs_set_super_total_bytes(super_copy, old_total - diff);
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
@@ -4442,14 +4442,14 @@ again:
 done:
 	btrfs_free_path(path);
 	if (ret) {
-		lock_chunks(root);
+		lock_chunks(root->fs_info);
 		btrfs_device_set_total_bytes(device, old_size);
 		if (device->writeable)
 			device->fs_devices->total_rw_bytes += diff;
 		spin_lock(&root->fs_info->free_chunk_lock);
 		root->fs_info->free_chunk_space += diff;
 		spin_unlock(&root->fs_info->free_chunk_lock);
-		unlock_chunks(root);
+		unlock_chunks(root->fs_info);
 	}
 	return ret;
 }
@@ -4463,11 +4463,11 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	u32 array_size;
 	u8 *ptr;
 
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	array_size = btrfs_super_sys_array_size(super_copy);
 	if (array_size + item_size + sizeof(disk_key)
 			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		unlock_chunks(root);
+		unlock_chunks(root->fs_info);
 		return -EFBIG;
 	}
 
@@ -4478,7 +4478,7 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 	memcpy(ptr, chunk, item_size);
 	item_size += sizeof(disk_key);
 	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 
 	return 0;
 }
@@ -6724,7 +6724,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 
 	mutex_lock(&uuid_mutex);
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 
 	/*
 	 * Read all device items, and then all the chunk items. All
@@ -6791,7 +6791,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	}
 	ret = 0;
 error:
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 	mutex_unlock(&uuid_mutex);
 
 	btrfs_free_path(path);
@@ -7090,13 +7090,13 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info)
 		return;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	lock_chunks(fs_info->dev_root);
+	lock_chunks(fs_info);
 	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
 				 resized_list) {
 		list_del_init(&curr->resized_list);
 		curr->commit_total_bytes = curr->disk_total_bytes;
 	}
-	unlock_chunks(fs_info->dev_root);
+	unlock_chunks(fs_info);
 	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
@@ -7113,7 +7113,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 		return;
 
 	/* In order to kick the device replace finish process */
-	lock_chunks(root);
+	lock_chunks(root->fs_info);
 	list_for_each_entry(em, &transaction->pending_chunks, list) {
 		map = em->map_lookup;
 
@@ -7122,7 +7122,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 			dev->commit_bytes_used = dev->bytes_used;
 		}
 	}
-	unlock_chunks(root);
+	unlock_chunks(root->fs_info);
 }
 
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a0ac26e..52fad80 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -511,14 +511,14 @@ void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
 void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 					struct btrfs_transaction *transaction);
 
-static inline void lock_chunks(struct btrfs_root *root)
+static inline void lock_chunks(struct btrfs_fs_info *fs_info)
 {
-	mutex_lock(&root->fs_info->chunk_mutex);
+	mutex_lock(&fs_info->chunk_mutex);
 }
 
-static inline void unlock_chunks(struct btrfs_root *root)
+static inline void unlock_chunks(struct btrfs_fs_info *fs_info)
 {
-	mutex_unlock(&root->fs_info->chunk_mutex);
+	mutex_unlock(&fs_info->chunk_mutex);
 }
 
 struct list_head *btrfs_get_fs_uuids(void);
-- 
2.7.1

