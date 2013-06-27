Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52812 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3F0R1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 13:27:23 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2F31D9A06A3
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 11:27:22 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id ZxZ8hdKSSiysd6gq (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 11:27:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make the chunk allocator completely tree lockless
Date: Thu, 27 Jun 2013 13:27:18 -0400
Message-ID: <1372354038-2111-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When adjusting the enospc rules for relocation I ran into a deadlock because we
were relocating the only system chunk and that forced us to try and allocate a
new system chunk while holding locks in the chunk tree, which caused us to
deadlock.  To fix this I've moved all of the dev extent addition and chunk
addition out to the delayed chunk completion stuff.  We still keep the in-memory
stuff which makes sure everything is consistent.

One change I had to make was to search the commit root of the device tree to
find a free dev extent, and hold onto any chunk em's that we allocated in that
transaction so we do not allocate the same dev extent twice.  This has the side
effect of fixing a bug with balance that has been there ever since balance
existed.  Basically you can free a block group and it's dev extent and then
immediately allocate that dev extent for a new block group and write stuff to
that dev extent, all within the same transaction.  So if you happen to crash
during a balance you could come back to a completely broken file system.  This
patch should keep these sort of things from happening in the future since we
won't be able to allocate free'd dev extents until after the transaction
commits.  This has passed all of the xfstests and my super annoying stress test
followed by a balance.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   15 +++-
 fs/btrfs/transaction.c |    9 ++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/volumes.c     |  301 ++++++++++++++++++++++--------------------------
 fs/btrfs/volumes.h     |    6 +-
 5 files changed, 165 insertions(+), 167 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 11ba82e..b2b27b8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7950,6 +7950,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
+	struct btrfs_trans_handle *trans;
 	u64 min_free;
 	u64 dev_min = 1;
 	u64 dev_nr = 0;
@@ -8036,6 +8037,13 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		do_div(min_free, dev_min);
 	}
 
+	/* We need to do this so that we can look at pending chunks */
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	mutex_lock(&root->fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
 		u64 dev_offset;
@@ -8046,7 +8054,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 */
 		if (device->total_bytes > device->bytes_used + min_free &&
 		    !device->is_tgtdev_for_dev_replace) {
-			ret = find_free_dev_extent(device, min_free,
+			ret = find_free_dev_extent(trans, device, min_free,
 						   &dev_offset, NULL);
 			if (!ret)
 				dev_nr++;
@@ -8058,6 +8066,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		}
 	}
 	mutex_unlock(&root->fs_info->chunk_mutex);
+	btrfs_end_transaction(trans, root);
 out:
 	btrfs_put_block_group(block_group);
 	return ret;
@@ -8423,6 +8432,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 					sizeof(item));
 		if (ret)
 			btrfs_abort_transaction(trans, extent_root, ret);
+		ret = btrfs_finish_chunk_alloc(trans, extent_root,
+					       key.objectid, key.offset);
+		if (ret)
+			btrfs_abort_transaction(trans, root, ret);
 	}
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bcfa32c..d58cce7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -63,6 +63,14 @@ static void put_transaction(struct btrfs_transaction *transaction)
 	if (atomic_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
 		WARN_ON(transaction->delayed_refs.root.rb_node);
+		while (!list_empty(&transaction->pending_chunks)) {
+			struct extent_map *em;
+
+			em = list_first_entry(&transaction->pending_chunks,
+					      struct extent_map, list);
+			list_del_init(&em->list);
+			free_extent_map(em);
+		}
 		kmem_cache_free(btrfs_transaction_cachep, transaction);
 	}
 }
@@ -202,6 +210,7 @@ loop:
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	INIT_LIST_HEAD(&cur_trans->ordered_operations);
+	INIT_LIST_HEAD(&cur_trans->pending_chunks);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
 			     fs_info->btree_inode->i_mapping);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 66d2a6c..005b037 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -56,6 +56,7 @@ struct btrfs_transaction {
 	wait_queue_head_t commit_wait;
 	struct list_head pending_snapshots;
 	struct list_head ordered_operations;
+	struct list_head pending_chunks;
 	struct btrfs_delayed_ref_root delayed_refs;
 	int aborted;
 };
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7789598..0889e04 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -982,6 +982,35 @@ out:
 	return ret;
 }
 
+static int contains_pending_extent(struct btrfs_trans_handle *trans,
+				   struct btrfs_device *device,
+				   u64 *start, u64 len)
+{
+	struct extent_map *em;
+	int ret = 0;
+
+	list_for_each_entry(em, &trans->transaction->pending_chunks, list) {
+		struct map_lookup *map;
+		int i;
+
+		map = (struct map_lookup *)em->bdev;
+		for (i = 0; i < map->num_stripes; i++) {
+			if (map->stripes[i].dev != device)
+				continue;
+			if (map->stripes[i].physical >= *start + len ||
+			    map->stripes[i].physical + em->orig_block_len <=
+			    *start)
+				continue;
+			*start = map->stripes[i].physical +
+				em->orig_block_len;
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+
 /*
  * find_free_dev_extent - find free space in the specified device
  * @device:	the device which we search the free space in
@@ -1002,7 +1031,8 @@ out:
  * But if we don't find suitable free space, it is used to store the size of
  * the max free space.
  */
-int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *len)
 {
 	struct btrfs_key key;
@@ -1026,6 +1056,10 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	 */
 	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
 
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+again:
 	max_hole_start = search_start;
 	max_hole_size = 0;
 	hole_size = 0;
@@ -1035,12 +1069,9 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		goto error;
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto error;
-	}
 	path->reada = 2;
+	path->search_commit_root = 1;
+	path->skip_locking = 1;
 
 	key.objectid = device->devid;
 	key.offset = search_start;
@@ -1081,6 +1112,15 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 
+			/*
+			 * Have to check before we set max_hole_start, otherwise
+			 * we could end up sending back this offset anyway.
+			 */
+			if (contains_pending_extent(trans, device,
+						    &search_start,
+						    hole_size))
+				hole_size = 0;
+
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
 				max_hole_size = hole_size;
@@ -1124,6 +1164,11 @@ next:
 		max_hole_size = hole_size;
 	}
 
+	if (contains_pending_extent(trans, device, &search_start, hole_size)) {
+		btrfs_release_path(path);
+		goto again;
+	}
+
 	/* See above. */
 	if (hole_size < num_bytes)
 		ret = -ENOSPC;
@@ -1244,47 +1289,22 @@ out:
 	return ret;
 }
 
-static noinline int find_next_chunk(struct btrfs_root *root,
-				    u64 objectid, u64 *offset)
+static u64 find_next_chunk(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_path *path;
-	int ret;
-	struct btrfs_key key;
-	struct btrfs_chunk *chunk;
-	struct btrfs_key found_key;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	key.objectid = objectid;
-	key.offset = (u64)-1;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto error;
-
-	BUG_ON(ret == 0); /* Corruption */
+	struct extent_map_tree *em_tree;
+	struct extent_map *em;
+	struct rb_node *n;
+	u64 ret = 0;
 
-	ret = btrfs_previous_item(root, path, 0, BTRFS_CHUNK_ITEM_KEY);
-	if (ret) {
-		*offset = 0;
-	} else {
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-				      path->slots[0]);
-		if (found_key.objectid != objectid)
-			*offset = 0;
-		else {
-			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					       struct btrfs_chunk);
-			*offset = found_key.offset +
-				btrfs_chunk_length(path->nodes[0], chunk);
-		}
+	em_tree = &fs_info->mapping_tree.map_tree;
+	read_lock(&em_tree->lock);
+	n = rb_last(&em_tree->map);
+	if (n) {
+		em = rb_entry(n, struct extent_map, rb_node);
+		ret = em->start + em->len;
 	}
-	ret = 0;
-error:
-	btrfs_free_path(path);
+	read_unlock(&em_tree->lock);
+
 	return ret;
 }
 
@@ -3666,10 +3686,8 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 }
 
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *extent_root,
-			       struct map_lookup **map_ret,
-			       u64 *num_bytes_out, u64 *stripe_size_out,
-			       u64 start, u64 type)
+			       struct btrfs_root *extent_root, u64 start,
+			       u64 type)
 {
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_fs_devices *fs_devices = info->fs_devices;
@@ -3776,7 +3794,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (total_avail == 0)
 			continue;
 
-		ret = find_free_dev_extent(device,
+		ret = find_free_dev_extent(trans, device,
 					   max_stripe_size * dev_stripes,
 					   &dev_offset, &max_avail);
 		if (ret && ret != -ENOSPC)
@@ -3888,12 +3906,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	map->type = type;
 	map->sub_stripes = sub_stripes;
 
-	*map_ret = map;
 	num_bytes = stripe_size * data_stripes;
 
-	*stripe_size_out = stripe_size;
-	*num_bytes_out = num_bytes;
-
 	trace_btrfs_chunk_alloc(info->chunk_root, map, start, num_bytes);
 
 	em = alloc_extent_map();
@@ -3906,38 +3920,26 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	em->len = num_bytes;
 	em->block_start = 0;
 	em->block_len = em->len;
+	em->orig_block_len = stripe_size;
 
 	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em, 0);
+	if (!ret) {
+		list_add_tail(&em->list, &trans->transaction->pending_chunks);
+		atomic_inc(&em->refs);
+	}
 	write_unlock(&em_tree->lock);
 	if (ret) {
 		free_extent_map(em);
 		goto error;
 	}
 
-	for (i = 0; i < map->num_stripes; ++i) {
-		struct btrfs_device *device;
-		u64 dev_offset;
-
-		device = map->stripes[i].dev;
-		dev_offset = map->stripes[i].physical;
-
-		ret = btrfs_alloc_dev_extent(trans, device,
-				info->chunk_root->root_key.objectid,
-				BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				start, dev_offset, stripe_size);
-		if (ret)
-			goto error_dev_extent;
-	}
-
 	ret = btrfs_make_block_group(trans, extent_root, 0, type,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     start, num_bytes);
-	if (ret) {
-		i = map->num_stripes - 1;
-		goto error_dev_extent;
-	}
+	if (ret)
+		goto error_del_extent;
 
 	free_extent_map(em);
 	check_raid56_incompat_flag(extent_root->fs_info, type);
@@ -3945,18 +3947,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	kfree(devices_info);
 	return 0;
 
-error_dev_extent:
-	for (; i >= 0; i--) {
-		struct btrfs_device *device;
-		int err;
-
-		device = map->stripes[i].dev;
-		err = btrfs_free_dev_extent(trans, device, start);
-		if (err) {
-			btrfs_abort_transaction(trans, extent_root, err);
-			break;
-		}
-	}
+error_del_extent:
 	write_lock(&em_tree->lock);
 	remove_extent_mapping(em_tree, em);
 	write_unlock(&em_tree->lock);
@@ -3971,33 +3962,68 @@ error:
 	return ret;
 }
 
-static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
+int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 				struct btrfs_root *extent_root,
-				struct map_lookup *map, u64 chunk_offset,
-				u64 chunk_size, u64 stripe_size)
+				u64 chunk_offset, u64 chunk_size)
 {
-	u64 dev_offset;
 	struct btrfs_key key;
 	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
 	struct btrfs_device *device;
 	struct btrfs_chunk *chunk;
 	struct btrfs_stripe *stripe;
-	size_t item_size = btrfs_chunk_item_size(map->num_stripes);
-	int index = 0;
+	struct extent_map_tree *em_tree;
+	struct extent_map *em;
+	struct map_lookup *map;
+	size_t item_size;
+	u64 dev_offset;
+	u64 stripe_size;
+	int i = 0;
 	int ret;
 
+	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, chunk_offset, chunk_size);
+	read_unlock(&em_tree->lock);
+
+	if (!em) {
+		btrfs_crit(extent_root->fs_info, "unable to find logical "
+			   "%Lu len %Lu", chunk_offset, chunk_size);
+		return -EINVAL;
+	}
+
+	if (em->start != chunk_offset || em->len != chunk_size) {
+		btrfs_crit(extent_root->fs_info, "found a bad mapping, wanted"
+			  " %Lu-%Lu, found %Lu-%Lu\n", chunk_offset,
+			  chunk_size, em->start, em->len);
+		free_extent_map(em);
+		return -EINVAL;
+	}
+
+	map = (struct map_lookup *)em->bdev;
+	item_size = btrfs_chunk_item_size(map->num_stripes);
+	stripe_size = em->orig_block_len;
+
 	chunk = kzalloc(item_size, GFP_NOFS);
-	if (!chunk)
-		return -ENOMEM;
+	if (!chunk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < map->num_stripes; i++) {
+		device = map->stripes[i].dev;
+		dev_offset = map->stripes[i].physical;
 
-	index = 0;
-	while (index < map->num_stripes) {
-		device = map->stripes[index].dev;
 		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
 		if (ret)
-			goto out_free;
-		index++;
+			goto out;
+		ret = btrfs_alloc_dev_extent(trans, device,
+					     chunk_root->root_key.objectid,
+					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+					     chunk_offset, dev_offset,
+					     stripe_size);
+		if (ret)
+			goto out;
 	}
 
 	spin_lock(&extent_root->fs_info->free_chunk_lock);
@@ -4005,17 +4031,15 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 						   map->num_stripes);
 	spin_unlock(&extent_root->fs_info->free_chunk_lock);
 
-	index = 0;
 	stripe = &chunk->stripe;
-	while (index < map->num_stripes) {
-		device = map->stripes[index].dev;
-		dev_offset = map->stripes[index].physical;
+	for (i = 0; i < map->num_stripes; i++) {
+		device = map->stripes[i].dev;
+		dev_offset = map->stripes[i].physical;
 
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
 		stripe++;
-		index++;
 	}
 
 	btrfs_set_stack_chunk_length(chunk, chunk_size);
@@ -4033,7 +4057,6 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	key.offset = chunk_offset;
 
 	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
-
 	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		/*
 		 * TODO: Cleanup of inserted chunk root in case of
@@ -4043,8 +4066,9 @@ static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
 					     item_size);
 	}
 
-out_free:
+out:
 	kfree(chunk);
+	free_extent_map(em);
 	return ret;
 }
 
@@ -4059,27 +4083,9 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 type)
 {
 	u64 chunk_offset;
-	u64 chunk_size;
-	u64 stripe_size;
-	struct map_lookup *map;
-	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
-	int ret;
 
-	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &chunk_offset);
-	if (ret)
-		return ret;
-
-	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
-				  &stripe_size, chunk_offset, type);
-	if (ret)
-		return ret;
-
-	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
-				   chunk_size, stripe_size);
-	if (ret)
-		return ret;
-	return 0;
+	chunk_offset = find_next_chunk(extent_root->fs_info);
+	return __btrfs_alloc_chunk(trans, extent_root, chunk_offset, type);
 }
 
 static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
@@ -4088,66 +4094,31 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 {
 	u64 chunk_offset;
 	u64 sys_chunk_offset;
-	u64 chunk_size;
-	u64 sys_chunk_size;
-	u64 stripe_size;
-	u64 sys_stripe_size;
 	u64 alloc_profile;
-	struct map_lookup *map;
-	struct map_lookup *sys_map;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
 
-	ret = find_next_chunk(fs_info->chunk_root,
-			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
-	if (ret)
-		return ret;
-
+	chunk_offset = find_next_chunk(fs_info);
 	alloc_profile = btrfs_get_alloc_profile(extent_root, 0);
-	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
-				  &stripe_size, chunk_offset, alloc_profile);
+	ret = __btrfs_alloc_chunk(trans, extent_root, chunk_offset,
+				  alloc_profile);
 	if (ret)
 		return ret;
 
-	sys_chunk_offset = chunk_offset + chunk_size;
-
+	sys_chunk_offset = find_next_chunk(root->fs_info);
 	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
-	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
-				  &sys_chunk_size, &sys_stripe_size,
-				  sys_chunk_offset, alloc_profile);
+	ret = __btrfs_alloc_chunk(trans, extent_root, sys_chunk_offset,
+				  alloc_profile);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
 		goto out;
 	}
 
 	ret = btrfs_add_device(trans, fs_info->chunk_root, device);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto out;
-	}
-
-	/*
-	 * Modifying chunk tree needs allocating new blocks from both
-	 * system block group and metadata block group. So we only can
-	 * do operations require modifying the chunk tree after both
-	 * block groups were created.
-	 */
-	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
-				   chunk_size, stripe_size);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto out;
-	}
-
-	ret = __finish_chunk_alloc(trans, extent_root, sys_map,
-				   sys_chunk_offset, sys_chunk_size,
-				   sys_stripe_size);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
-
 out:
-
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 857acd3..8670558 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -316,7 +316,8 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
-int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
+int find_free_dev_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,
@@ -337,6 +338,9 @@ int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
 				    struct btrfs_mapping_tree *map_tree,
 				    u64 logical);
+int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
+				struct btrfs_root *extent_root,
+				u64 chunk_offset, u64 chunk_size);
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
 {
-- 
1.7.7.6

