Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60708 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbeBVGsA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Feb 2018 01:48:00 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 9/9] btrfs-progs: Refactor btrfs_alloc_chunk to mimic kernel structure and behavior
Date: Thu, 22 Feb 2018 14:47:33 +0800
Message-Id: <20180222064733.12126-10-wqu@suse.com>
In-Reply-To: <20180222064733.12126-1-wqu@suse.com>
References: <20180222064733.12126-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel uses a delayed chunk allocation behavior for metadata chunks

KERNEL:
btrfs_alloc_chunk()
|- __btrfs_alloc_chunk():	Only allocate chunk mapping
   |- btrfs_make_block_group():	Add corresponding bg to fs_info->new_bgs

Then at transaction commit time, it finishes the remaining work:
btrfs_start_dirty_block_groups():
|- btrfs_create_pending_block_groups()
   |- btrfs_insert_item():	To insert block group item
   |- btrfs_finish_chunk_alloc(): Insert chunk items/dev extents

Although btrfs-progs btrfs_alloc_chunk() does all the work in one
function, it can still benefit from function refactor like:
btrfs-progs:
btrfs_alloc_chunk():	Wrapper for both normal and convert chunks
|- __btrfs_alloc_chunk():	Only alloc chunk mapping
|  |- btrfs_make_block_group(): <<Insert bg items into extent tree>>
|- btrfs_finish_chunk_alloc():  Insert chunk items/dev extents

With such refactor, the following functions can share most of its code
with kernel now:
__btrfs_alloc_chunk()
btrfs_finish_chunk_alloc()
btrfs_alloc_dev_extent()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 421 ++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 260 insertions(+), 161 deletions(-)

diff --git a/volumes.c b/volumes.c
index 6d54e9d74cda..51b050fe3077 100644
--- a/volumes.c
+++ b/volumes.c
@@ -522,55 +522,40 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
-static int btrfs_insert_dev_extents(struct btrfs_trans_handle *trans,
-				    struct btrfs_fs_info *fs_info,
-				    struct map_lookup *map, u64 stripe_size)
+static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+				  struct btrfs_device *device,
+				  u64 chunk_offset, u64 physical,
+				  u64 stripe_size)
 {
-	int ret = 0;
-	struct btrfs_path path;
+	int ret;
+	struct btrfs_path *path;
+	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_dev_extent *extent;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	int i;
 
-	btrfs_init_path(&path);
-
-	for (i = 0; i < map->num_stripes; i++) {
-		struct btrfs_device *device = map->stripes[i].dev;
-
-		key.objectid = device->devid;
-		key.offset = map->stripes[i].physical;
-		key.type = BTRFS_DEV_EXTENT_KEY;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
-		ret = btrfs_insert_empty_item(trans, root, &path, &key,
-					      sizeof(*extent));
-		if (ret < 0)
-			goto out;
-		leaf = path.nodes[0];
-		extent = btrfs_item_ptr(leaf, path.slots[0],
-					struct btrfs_dev_extent);
-		btrfs_set_dev_extent_chunk_tree(leaf, extent,
+	key.objectid = device->devid;
+	key.offset = physical;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*extent));
+	if (ret)
+		goto out;
+	leaf = path->nodes[0];
+	extent = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dev_extent);
+	btrfs_set_dev_extent_chunk_tree(leaf, extent,
 					BTRFS_CHUNK_TREE_OBJECTID);
-		btrfs_set_dev_extent_chunk_objectid(leaf, extent,
-					BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-		btrfs_set_dev_extent_chunk_offset(leaf, extent, map->ce.start);
-
-		write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
-			(unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
-			BTRFS_UUID_SIZE);
-
-		btrfs_set_dev_extent_length(leaf, extent, stripe_size);
-		btrfs_mark_buffer_dirty(leaf);
-		btrfs_release_path(&path);
-
-		device->bytes_used += stripe_size;
-		ret = btrfs_update_device(trans, device);
-		if (ret < 0)
-			goto out;
-	}
+	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
+					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
+	btrfs_set_dev_extent_length(leaf, extent, stripe_size);
+	btrfs_mark_buffer_dirty(leaf);
 out:
-	btrfs_release_path(&path);
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -812,28 +797,28 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 				/ sizeof(struct btrfs_stripe) + 1)
 
 /*
- * Alloc a chunk, will insert dev extents, chunk item, and insert new
- * block group and update space info (so that extent allocator can use
- * newly allocated chunk).
+ * Alloc a chunk mapping.
+ * Will do chunk size calculation and free dev extent search, and insert
+ * chunk mapping into chunk mapping tree.
+ *
+ * NOTE: This function doesn't handle any chunk item/dev extent insert.
+ * chunk item/dev extent insert is handled by later btrfs_finish_chunk_alloc().
+ * And for convert chunk (1:1 mapped, more flex chunk location), it's
+ * handled by __btrfs_alloc_convert_chunk().
+ *
+ * Qu: Block group item is still inserted in this function by
+ * btrfs_make_block_group(), this still differs from kernel.
  *
  * @start:	return value of allocated chunk start bytenr.
  * @num_bytes:	return value of allocated chunk size
  * @type:	chunk type (including both profile and type)
- * @convert:   if the chunk is allocated for convert case.
- *             If @convert is true, chunk allocator will skip device extent
- *             search, but use *start and *num_bytes as chunk start/num_bytes
- *             and devive offset, to build a 1:1 chunk mapping for convert.
  */
-int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *info, u64 *start,
-		      u64 *num_bytes, u64 type, bool convert)
+static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+			       struct btrfs_fs_info *info, u64 *start,
+			       u64 *num_bytes, u64 type)
 {
-	struct btrfs_root *extent_root = info->extent_root;
-	struct btrfs_root *chunk_root = info->chunk_root;
 	struct btrfs_device *device = NULL;
-	struct btrfs_chunk *chunk;
 	struct list_head *dev_list = &info->fs_devices->devices;
-	struct btrfs_stripe *stripe;
 	struct map_lookup *map;
 	struct btrfs_device_info *devices_info = NULL;
 	u64 percent_max;
@@ -844,8 +829,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int index;
 	int ndevs = 0;
 	int rw_devs = 0;
-	int stripe_len = BTRFS_STRIPE_LEN;
-	struct btrfs_key key;
 	u64 offset;
 	int data_stripes;	/* number of stripes that counts for bg size */
 	int sub_stripes;	/* sub_stripes info for map */
@@ -873,34 +856,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	devs_increment = btrfs_raid_array[index].devs_increment;
 	ncopies = btrfs_raid_array[index].ncopies;
 
-	if (convert) {
-		/* For convert, profile must be SINGLE */
-		if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
-			error("convert only suports SINGLE profile");
-			return -EINVAL;
-		}
-		if (!IS_ALIGNED(*start, info->sectorsize)) {
-			error("chunk start not aligned, start=%llu sectorsize=%u",
-				*start, info->sectorsize);
-			return -EINVAL;
-		}
-		if (!IS_ALIGNED(*num_bytes, info->sectorsize)) {
-			error("chunk size not aligned, size=%llu sectorsize=%u",
-				*num_bytes, info->sectorsize);
-			return -EINVAL;
-		}
-		num_stripes = 1;
-		data_stripes = 1;
-		offset = *start;
-		stripe_size = *num_bytes;
-		/*
-		 * For convert, we use 1:1 chunk mapping specified by @start and
-		 * @num_bytes, so there is no need to go through dev_extent
-		 * searching.
-		 */
-		goto alloc_chunk;
-	}
-
 	/*
 	 * Chunk size calculation part.
 	 */
@@ -1046,55 +1001,23 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/*
 	 * Fill chunk mapping and chunk stripes
 	 */
-alloc_chunk:
-	if (!convert) {
-		ret = find_next_chunk(info, &offset);
-		if (ret)
-			goto out_devices_info;
-	}
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-	key.offset = offset;
-	*num_bytes =  stripe_size * data_stripes;
-
-	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
-	if (!chunk)
+	ret = find_next_chunk(info, &offset);
+	if (ret)
 		goto out_devices_info;
+	*num_bytes =  stripe_size * data_stripes;
 
 	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map)
 		goto out_chunk_map;
 	map->num_stripes = num_stripes;
 
-	if (convert) {
-		device = list_entry(dev_list->next, struct btrfs_device,
-				    dev_list);
+	for (i = 0; i < ndevs; i++) {
+		for (j = 0; j < dev_stripes; ++j) {
+			int s = i * dev_stripes + j;
 
-		map->stripes[0].dev = device;
-		map->stripes[0].physical = *start;
-		stripe = &chunk->stripe;
-		btrfs_set_stack_stripe_devid(stripe, device->devid);
-		btrfs_set_stack_stripe_offset(stripe, *start);
-		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-	} else {
-		for (i = 0; i < ndevs; i++) {
-			for (j = 0; j < dev_stripes; ++j) {
-				int s = i * dev_stripes + j;
-
-				device = devices_info[i].dev;
-				map->stripes[s].dev = device;
-				map->stripes[s].physical =
-					devices_info[i].dev_offset +
-					j * stripe_size;
-				stripe = &chunk->stripe + s;
-				btrfs_set_stack_stripe_devid(stripe,
-						device->devid);
-				btrfs_set_stack_stripe_offset(stripe,
-						devices_info[i].dev_offset +
-						j * stripe_size);
-				memcpy(stripe->dev_uuid, device->uuid,
-						BTRFS_UUID_SIZE);
-			}
+			map->stripes[s].dev = devices_info[i].dev;
+			map->stripes[s].physical = devices_info[i].dev_offset +
+						   j * stripe_size;
 		}
 	}
 	map->stripe_len = BTRFS_STRIPE_LEN;
@@ -1103,60 +1026,236 @@ alloc_chunk:
 	map->type = type;
 	map->sub_stripes = sub_stripes;
 	map->sector_size = info->sectorsize;
-	map->ce.start = key.offset;
+	map->ce.start = offset;
 	map->ce.size = *num_bytes;
 
+	kfree(devices_info);
 
+	/*
+	 * Insert chunk mapping and block group
+	 */
 	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
 	if (ret < 0)
 		goto out_chunk_map;
 
-	/* key was set above */
-	btrfs_set_stack_chunk_length(chunk, *num_bytes);
-	btrfs_set_stack_chunk_owner(chunk, extent_root->root_key.objectid);
-	btrfs_set_stack_chunk_stripe_len(chunk, stripe_len);
-	btrfs_set_stack_chunk_type(chunk, type);
-	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
-	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
-	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
-	btrfs_set_stack_chunk_sector_size(chunk, info->sectorsize);
-	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
+	ret = btrfs_make_block_group(trans, info, 0, type, offset,
+				     *num_bytes);
+	*start = offset;
+	return ret;
+
+out_chunk_map:
+	kfree(map);
+out_devices_info:
+	kfree(devices_info);
+	return ret;
+}
+
+/*
+ * Alloc a chunk mapping for convert.
+ * Convert needs special SINGLE chunk whose logical bytenr is the same as its
+ * physical bytenr.
+ * Chunk size and start bytenr are all specified by @start and @num_bytes
+ *
+ * And just like __btrfs_alloc_chunk() this only handles chunk mapping and
+ * block group item.
+ */
+static int __btrfs_alloc_convert_chunk(struct btrfs_trans_handle *trans,
+				       struct btrfs_fs_info *fs_info, u64 start,
+				       u64 num_bytes, u64 type)
+{
+	struct list_head *dev_list = &fs_info->fs_devices->devices;
+	struct map_lookup *map;
+	struct btrfs_device *device;
+	int ret;
+
+	/* For convert, profile must be SINGLE */
+	if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+		error("convert only suports SINGLE profile");
+		return -EINVAL;
+	}
+	if (!IS_ALIGNED(start, fs_info->sectorsize)) {
+		error("chunk start not aligned, start=%llu sectorsize=%u",
+		      start, fs_info->sectorsize);
+		return -EINVAL;
+	}
+	if (!IS_ALIGNED(num_bytes, fs_info->sectorsize)) {
+		error("chunk size not aligned, size=%llu sectorsize=%u",
+		      num_bytes, fs_info->sectorsize);
+		return -EINVAL;
+	}
+	if (list_empty(dev_list)) {
+		error("no writable device");
+		return -ENODEV;
+	}
+
+	device = list_entry(dev_list->next, struct btrfs_device, dev_list);
+	map = malloc(btrfs_map_lookup_size(1));
+	if (!map)
+		return -ENOMEM;
+	map->num_stripes = 1;
+	map->stripes[0].dev = device;
+	map->stripes[0].physical = start;
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->io_align = BTRFS_STRIPE_LEN;
+	map->io_width = BTRFS_STRIPE_LEN;
+	map->type = type;
+	map->sub_stripes = 1;
+	map->sector_size = fs_info->sectorsize;
+	map->ce.start = start;
+	map->ce.size = num_bytes;
+
+	ret = insert_cache_extent(&fs_info->mapping_tree.cache_tree, &map->ce);
+	if (ret < 0)
+		goto error;
+	ret = btrfs_make_block_group(trans, fs_info, 0, type, start, num_bytes);
+	return ret;
+error:
+	free(map);
+	return ret;
+}
+
+/*
+ * Finish the chunk allocation by inserting needed chunk item and device
+ * extents, and update device used bytes
+ */
+static int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
+				    struct btrfs_fs_info *fs_info,
+				    u64 chunk_start, u64 chunk_size)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_key key;
+	struct btrfs_device *device;
+	struct btrfs_chunk *chunk;
+	struct btrfs_stripe *stripe;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	size_t item_size;
+	u64 dev_offset;
+	u64 stripe_size;
+	int i = 0;
+	int ret = 0;
+
+	ce = search_cache_extent(&fs_info->mapping_tree.cache_tree, chunk_start);
+	if (!ce)
+		return -ENOENT;
+
+	map = container_of(ce, struct map_lookup, ce);
+	item_size = btrfs_chunk_item_size(map->num_stripes);
+	stripe_size = calc_stripe_length(map->type, map->ce.size,
+					 map->num_stripes);
+
+	chunk = kzalloc(item_size, GFP_NOFS);
+	if (!chunk) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/*
-	 * Insert chunk item and chunk mapping.
+	 * Take the device list mutex to prevent races with the final phase of
+	 * a device replace operation that replaces the device object associated
+	 * with the map's stripes, because the device object's id can change
+	 * at any time during that final phase of the device replace operation
+	 * (dev-replace.c:btrfs_dev_replace_finishing()).
 	 */
-	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
-				btrfs_chunk_item_size(num_stripes));
-	BUG_ON(ret);
-	*start = key.offset;
+	/* mutex_lock(&fs_info->fs_devices->device_list_mutex); */
+	for (i = 0; i < map->num_stripes; i++) {
+		device = map->stripes[i].dev;
+		dev_offset = map->stripes[i].physical;
 
-	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_add_system_chunk(info, &key,
-				    chunk, btrfs_chunk_item_size(num_stripes));
-		if (ret < 0)
-			goto out_chunk;
+		device->bytes_used += stripe_size;
+		ret = btrfs_update_device(trans, device);
+		if (ret)
+			break;
+		ret = btrfs_alloc_dev_extent(trans, device, chunk_start,
+					     dev_offset, stripe_size);
+		if (ret)
+			break;
+	}
+	if (ret) {
+		/* mutex_unlock(&fs_info->fs_devices->device_list_mutex); */
+		goto out;
 	}
 
+	stripe = &chunk->stripe;
+	for (i = 0; i < map->num_stripes; i++) {
+		device = map->stripes[i].dev;
+		dev_offset = map->stripes[i].physical;
+
+		btrfs_set_stack_stripe_devid(stripe, device->devid);
+		btrfs_set_stack_stripe_offset(stripe, dev_offset);
+		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
+		stripe++;
+	}
+	/* mutex_unlock(&fs_info->fs_devices->device_list_mutex); */
+
+	btrfs_set_stack_chunk_length(chunk, chunk_size);
+	btrfs_set_stack_chunk_owner(chunk, extent_root->root_key.objectid);
+	btrfs_set_stack_chunk_stripe_len(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_type(chunk, map->type);
+	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
+	btrfs_set_stack_chunk_io_align(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_io_width(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_sector_size(chunk, fs_info->sectorsize);
+	btrfs_set_stack_chunk_sub_stripes(chunk, map->sub_stripes);
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = chunk_start;
+
+	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
+	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		/*
+		 * TODO: Cleanup of inserted chunk root in case of
+		 * failure.
+		 */
+		ret = btrfs_add_system_chunk(fs_info, &key, chunk, item_size);
+	}
+
+out:
 	kfree(chunk);
+	return ret;
+}
+
+/*
+ * Alloc a chunk.
+ * Will do all the needed work including seaching free device extent, insert
+ * chunk mapping, chunk item, block group item and device extents.
+ *
+ * @start:	return value of allocated chunk start bytenr.
+ * @num_bytes:	return value of allocated chunk size
+ * @type:	chunk type (including both profile and type)
+ * @convert:	if the chunk is allocated for convert case.
+ *		If @convert is true, chunk allocator will skip device extent
+ *		search, but use *start and *num_bytes as chunk start/num_bytes
+ *		and devive offset, to build a 1:1 chunk mapping for convert.
+ */
+int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *fs_info, u64 *start, u64 *num_bytes,
+		      u64 type, bool convert)
+{
+	int ret;
 
 	/*
-	 * Insert device extents
+	 * Allocate chunk mapping
 	 */
-	ret = btrfs_insert_dev_extents(trans, info, map, stripe_size);
-	if (ret < 0)
-		goto out_devices_info;
-
-	ret = btrfs_make_block_group(trans, info, 0, type, map->ce.start,
-				     map->ce.size);
-	kfree(devices_info);
-	return ret;
+	if (convert)
+		ret = __btrfs_alloc_convert_chunk(trans, fs_info, *start,
+						  *num_bytes, type);
+	else
+		ret = __btrfs_alloc_chunk(trans, fs_info, start, num_bytes,
+					  type);
+	if (ret < 0) {
+		error("failed to allocate chunk mapping: %s", strerror(-ret));
+		return ret;
+	}
 
-out_chunk_map:
-	kfree(map);
-out_chunk:
-	kfree(chunk);
-out_devices_info:
-	kfree(devices_info);
+	/*
+	 * Insert the remaining part (insert variant items)
+	 */
+	ret = btrfs_finish_chunk_alloc(trans, fs_info, *start, *num_bytes);
+	if (ret < 0)
+		error("failed to finish chunk allocation: %s", strerror(-ret));
 	return ret;
 }
 
-- 
2.16.2

