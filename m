Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:51031 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751514AbeBBIT5 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Feb 2018 03:19:57 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 7/7] btrfs-progs: volumes: Unify free dev extent search behavior between kernel and btrfs-progs.
Date: Fri,  2 Feb 2018 16:19:29 +0800
Message-Id: <20180202081929.15162-8-wqu@suse.com>
In-Reply-To: <20180202081929.15162-1-wqu@suse.com>
References: <20180202081929.15162-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As preparation to create libbtrfs which shares code between kernel and
btrfs, this patch mainly unifies the search for free device extents.

The main modifications are:

1) Search for free device extent
   Use the kernel method, by sorting the devices by its max hole
   capability, and use that sorted result to determine stripe size
   and chunk size.

   The previous method, which uses available bytes of each device to
   search, can't handle scattered small holes in each device.

2) Chunk/stripe minimal size
   Remove the minimal size requirement.
   Now the real minimal stripe size is 64K (BTRFS_STRIPE_LEN), the same
   as kernel one.

   While up limit is still kept as is, and minimal device size is still
   kept for a while.
   But since we no longer have strange minimal stripe size limit,
   existing minimal device size calculation won't cause any problem.

3) How to insert device extents
   Although not the same as kernel, here we follow kernel behavior to
   delay dev extents insert.

   There is plan to follow kernel __btrfs_alloc_chunk() to make it only
   handle chunk mapping allocation, while do nothing with tree
   operation.

4) Usage of btrfs_raid_array[]
   Which makes a lot of old if-else branches disappear.

There are still a lot of work to do (both kernel and btrfs-progs) before
we could starting extracting code into libbtrfs, but this should make
libbtrfs inside our reach.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kerncompat.h |   5 +
 volumes.c    | 611 ++++++++++++++++++++++++++---------------------------------
 volumes.h    |   7 +
 3 files changed, 281 insertions(+), 342 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index fa96715fb70c..658d28ed0792 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -285,6 +285,7 @@ static inline int IS_ERR_OR_NULL(const void *ptr)
  */
 #define kmalloc(x, y) malloc(x)
 #define kzalloc(x, y) calloc(1, x)
+#define kcalloc(x, y) calloc(x, y)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 #define vmalloc(x) malloc(x)
@@ -394,4 +395,8 @@ struct __una_u64 { __le64 x; } __attribute__((__packed__));
 #define noinline
 #endif
 
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	return dividend / ((u64) divisor);
+}
 #endif
diff --git a/volumes.c b/volumes.c
index f4009ffa7c9e..d14f46f8496e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -29,6 +29,7 @@
 #include "volumes.h"
 #include "utils.h"
 #include "kernel-lib/raid56.h"
+#include "kernel-lib/sort.h"
 
 const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
@@ -522,55 +523,55 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
-static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_device *device,
-				  u64 chunk_offset, u64 num_bytes, u64 *start,
-				  int convert)
+static int btrfs_insert_dev_extents(struct btrfs_trans_handle *trans,
+				    struct btrfs_fs_info *fs_info,
+				    struct map_lookup *map, u64 stripe_size)
 {
-	int ret;
-	struct btrfs_path *path;
-	struct btrfs_root *root = device->dev_root;
+	int ret = 0;
+	struct btrfs_path path;
+	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_dev_extent *extent;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	int i;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	btrfs_init_path(&path);
 
-	/*
-	 * For convert case, just skip search free dev_extent, as caller
-	 * is responsible to make sure it's free.
-	 */
-	if (!convert) {
-		ret = find_free_dev_extent(device, num_bytes, start, NULL);
-		if (ret)
-			goto err;
-	}
+	for (i = 0; i < map->num_stripes; i++) {
+		struct btrfs_device *device = map->stripes[i].dev;
 
-	key.objectid = device->devid;
-	key.offset = *start;
-	key.type = BTRFS_DEV_EXTENT_KEY;
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(*extent));
-	BUG_ON(ret);
+		key.objectid = device->devid;
+		key.offset = map->stripes[i].physical;
+		key.type = BTRFS_DEV_EXTENT_KEY;
 
-	leaf = path->nodes[0];
-	extent = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_dev_extent);
-	btrfs_set_dev_extent_chunk_tree(leaf, extent, BTRFS_CHUNK_TREE_OBJECTID);
-	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
-					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
-
-	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
-		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
-		    BTRFS_UUID_SIZE);
-
-	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
-	btrfs_mark_buffer_dirty(leaf);
-err:
-	btrfs_free_path(path);
+		ret = btrfs_insert_empty_item(trans, root, &path, &key,
+					      sizeof(*extent));
+		if (ret < 0)
+			goto out;
+		leaf = path.nodes[0];
+		extent = btrfs_item_ptr(leaf, path.slots[0],
+					struct btrfs_dev_extent);
+		btrfs_set_dev_extent_chunk_tree(leaf, extent,
+					BTRFS_CHUNK_TREE_OBJECTID);
+		btrfs_set_dev_extent_chunk_objectid(leaf, extent,
+					BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+		btrfs_set_dev_extent_chunk_offset(leaf, extent, map->ce.start);
+
+		write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
+			(unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
+			BTRFS_UUID_SIZE);
+
+		btrfs_set_dev_extent_length(leaf, extent, stripe_size);
+		btrfs_mark_buffer_dirty(leaf);
+		btrfs_release_path(&path);
+
+		device->bytes_used += stripe_size;
+		ret = btrfs_update_device(trans, device);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -782,114 +783,23 @@ int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	return 0;
 }
 
-static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
-			       int sub_stripes)
-{
-	if (type & (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP))
-		return calc_size;
-	else if (type & BTRFS_BLOCK_GROUP_RAID10)
-		return calc_size * (num_stripes / sub_stripes);
-	else if (type & BTRFS_BLOCK_GROUP_RAID5)
-		return calc_size * (num_stripes - 1);
-	else if (type & BTRFS_BLOCK_GROUP_RAID6)
-		return calc_size * (num_stripes - 2);
-	else
-		return calc_size * num_stripes;
-}
-
-
-static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
-{
-	/* TODO, add a way to store the preferred stripe size */
-	return BTRFS_STRIPE_LEN;
-}
-
 /*
- * btrfs_device_avail_bytes - count bytes available for alloc_chunk
- *
- * It is not equal to "device->total_bytes - device->bytes_used".
- * We do not allocate any chunk in 1M at beginning of device, and not
- * allowed to allocate any chunk before alloc_start if it is specified.
- * So search holes from max(1M, alloc_start) to device->total_bytes.
+ * sort the devices in descending order by max_avail, total_avail
  */
-static int btrfs_device_avail_bytes(struct btrfs_trans_handle *trans,
-				    struct btrfs_device *device,
-				    u64 *avail_bytes)
+static int btrfs_cmp_device_info(const void *a, const void *b)
 {
-	struct btrfs_path *path;
-	struct btrfs_root *root = device->dev_root;
-	struct btrfs_key key;
-	struct btrfs_dev_extent *dev_extent = NULL;
-	struct extent_buffer *l;
-	u64 search_start = root->fs_info->alloc_start;
-	u64 search_end = device->total_bytes;
-	u64 extent_end = 0;
-	u64 free_bytes = 0;
-	int ret;
-	int slot = 0;
-
-	search_start = max(BTRFS_BLOCK_RESERVED_1M_FOR_SUPER, search_start);
+	const struct btrfs_device_info *di_a = a;
+	const struct btrfs_device_info *di_b = b;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	key.objectid = device->devid;
-	key.offset = root->fs_info->alloc_start;
-	key.type = BTRFS_DEV_EXTENT_KEY;
-
-	path->reada = 2;
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto error;
-	ret = btrfs_previous_item(root, path, 0, key.type);
-	if (ret < 0)
-		goto error;
-
-	while (1) {
-		l = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(l)) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret == 0)
-				continue;
-			if (ret < 0)
-				goto error;
-			break;
-		}
-		btrfs_item_key_to_cpu(l, &key, slot);
-
-		if (key.objectid < device->devid)
-			goto next;
-		if (key.objectid > device->devid)
-			break;
-		if (key.type != BTRFS_DEV_EXTENT_KEY)
-			goto next;
-		if (key.offset > search_end)
-			break;
-		if (key.offset > search_start)
-			free_bytes += key.offset - search_start;
-
-		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
-		extent_end = key.offset + btrfs_dev_extent_length(l,
-								  dev_extent);
-		if (extent_end > search_start)
-			search_start = extent_end;
-		if (search_start > search_end)
-			break;
-next:
-		path->slots[0]++;
-		cond_resched();
-	}
-
-	if (search_start < search_end)
-		free_bytes += search_end - search_start;
-
-	*avail_bytes = free_bytes;
-	ret = 0;
-error:
-	btrfs_free_path(path);
-	return ret;
+	if (di_a->max_avail > di_b->max_avail)
+		return -1;
+	if (di_a->max_avail < di_b->max_avail)
+		return 1;
+	if (di_a->total_avail > di_b->total_avail)
+		return -1;
+	if (di_a->total_avail < di_b->total_avail)
+		return 1;
+	return 0;
 }
 
 #define BTRFS_MAX_DEVS(info) ((BTRFS_LEAF_DATA_SIZE(info)	\
@@ -910,46 +820,60 @@ error:
  * @start:	return value of allocated chunk start bytenr.
  * @num_bytes:	return value of allocated chunk size
  * @type:	chunk type (including both profile and type)
- * @convert:	if the chunk is allocated for convert case.
- * 		If @convert is true, chunk allocator will skip device extent
- * 		search, but use *start and *num_bytes as chunk start/num_bytes
- * 		and devive offset, to build a 1:1 chunk mapping for convert.
+ * @convert:   if the chunk is allocated for convert case.
+ *             If @convert is true, chunk allocator will skip device extent
+ *             search, but use *start and *num_bytes as chunk start/num_bytes
+ *             and devive offset, to build a 1:1 chunk mapping for convert.
  */
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *info, u64 *start,
 		      u64 *num_bytes, u64 type, bool convert)
 {
-	u64 dev_offset;
 	struct btrfs_root *extent_root = info->extent_root;
 	struct btrfs_root *chunk_root = info->chunk_root;
-	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
 	struct btrfs_chunk *chunk;
-	struct list_head private_devs;
 	struct list_head *dev_list = &info->fs_devices->devices;
-	struct list_head *cur;
+	struct btrfs_stripe *stripe;
 	struct map_lookup *map;
-	int min_stripe_size = SZ_1M;
-	u64 calc_size = SZ_8M;
-	u64 min_free;
-	u64 max_chunk_size = 4 * calc_size;
-	u64 avail = 0;
-	u64 max_avail = 0;
+	struct btrfs_device_info *devices_info = NULL;
 	u64 percent_max;
-	int num_stripes = 1;
-	int max_stripes = 0;
-	int min_stripes = 1;
-	int sub_stripes = 0;
-	int looped = 0;
+	int num_stripes;
 	int ret;
+	int i;
+	int j;
 	int index;
+	int ndevs = 0;
+	int rw_devs = 0;
 	int stripe_len = BTRFS_STRIPE_LEN;
 	struct btrfs_key key;
 	u64 offset;
+	int data_stripes;	/* number of stripes that counts for bg size */
+	int sub_stripes;	/* sub_stripes info for map */
+	int dev_stripes;	/* stripes per dev */
+	int devs_max;		/* max devs to use */
+	int devs_min;		/* min devs needed */
+	int devs_increment;	/* ndevs has to be a multiple of this */
+	int ncopies;		/* how many copies to data has */
+	u64 max_stripe_size;	/* max physical size of each stripe */
+	u64 max_chunk_size;	/* max logical size of the block group */
+	u64 stripe_size;
 
 	if (list_empty(dev_list))
 		return -ENOSPC;
 
+	list_for_each_entry(device, dev_list, dev_list)
+		rw_devs++;
+
+	index = btrfs_bg_flags_to_raid_index(type);
+
+	sub_stripes = btrfs_raid_array[index].sub_stripes;
+	dev_stripes = btrfs_raid_array[index].dev_stripes;
+	devs_max = btrfs_raid_array[index].devs_max;
+	devs_min = btrfs_raid_array[index].devs_min;
+	devs_increment = btrfs_raid_array[index].devs_increment;
+	ncopies = btrfs_raid_array[index].ncopies;
+
 	if (convert) {
 		/* For convert, profile must be SINGLE */
 		if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
@@ -966,8 +890,10 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 				*num_bytes, info->sectorsize);
 			return -EINVAL;
 		}
-		calc_size = *num_bytes;
+		num_stripes = 1;
+		data_stripes = 1;
 		offset = *start;
+		stripe_size = *num_bytes;
 		/*
 		 * For convert, we use 1:1 chunk mapping specified by @start and
 		 * @num_bytes, so there is no need to go through dev_extent
@@ -979,70 +905,25 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/*
 	 * Chunk size calculation part.
 	 */
-	if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
-		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-			calc_size = SZ_8M;
-			max_chunk_size = calc_size * 2;
-			min_stripe_size = SZ_1M;
-			max_stripes = BTRFS_MAX_DEVS_SYS_CHUNK;
-		} else if (type & BTRFS_BLOCK_GROUP_DATA) {
-			calc_size = SZ_1G;
-			max_chunk_size = 10 * calc_size;
-			min_stripe_size = SZ_64M;
-			max_stripes = BTRFS_MAX_DEVS(info);
-		} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-			calc_size = SZ_1G;
-			max_chunk_size = 4 * calc_size;
-			min_stripe_size = SZ_32M;
-			max_stripes = BTRFS_MAX_DEVS(info);
-		}
-	}
-	if (type & BTRFS_BLOCK_GROUP_RAID1) {
-		num_stripes = min_t(u64, 2,
-				  btrfs_super_num_devices(info->super_copy));
-		if (num_stripes < 2)
-			return -ENOSPC;
-		min_stripes = 2;
-	}
-	if (type & BTRFS_BLOCK_GROUP_DUP) {
-		num_stripes = 2;
-		min_stripes = 2;
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes > max_stripes)
-			num_stripes = max_stripes;
-		min_stripes = 2;
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes > max_stripes)
-			num_stripes = max_stripes;
-		if (num_stripes < 4)
-			return -ENOSPC;
-		num_stripes &= ~(u32)1;
-		sub_stripes = 2;
-		min_stripes = 4;
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes > max_stripes)
-			num_stripes = max_stripes;
-		if (num_stripes < 2)
-			return -ENOSPC;
-		min_stripes = 2;
-		stripe_len = find_raid56_stripe_len(num_stripes - 1,
-				    btrfs_super_stripesize(info->super_copy));
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
-		num_stripes = btrfs_super_num_devices(info->super_copy);
-		if (num_stripes > max_stripes)
-			num_stripes = max_stripes;
-		if (num_stripes < 3)
-			return -ENOSPC;
-		min_stripes = 3;
-		stripe_len = find_raid56_stripe_len(num_stripes - 2,
-				    btrfs_super_stripesize(info->super_copy));
+	if (type & BTRFS_BLOCK_GROUP_DATA) {
+		max_stripe_size = SZ_1G;
+		max_chunk_size = 10 * max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS(info);
+	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
+		/* TODO: Support total_rw_bytes in fs_devices */
+		max_stripe_size = SZ_256M;
+		max_chunk_size = max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS(info);
+	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		max_stripe_size = SZ_32M;
+		max_chunk_size = 2 * max_stripe_size;
+		if (!devs_max)
+			devs_max = BTRFS_MAX_DEVS_SYS_CHUNK;
+	} else {
+		error("invalid chunk type 0x%llx requested", type);
+		return -EINVAL;
 	}
 
 	/* we don't want a chunk larger than 10% of the FS */
@@ -1052,64 +933,116 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/*
 	 * Reserve space from each device.
 	 */
-again:
-	if (chunk_bytes_by_type(type, calc_size, num_stripes, sub_stripes) >
-	    max_chunk_size) {
-		calc_size = max_chunk_size;
-		calc_size /= num_stripes;
-		calc_size /= stripe_len;
-		calc_size *= stripe_len;
-	}
-	/* we don't want tiny stripes */
-	calc_size = max_t(u64, calc_size, min_stripe_size);
-
-	calc_size /= stripe_len;
-	calc_size *= stripe_len;
-	INIT_LIST_HEAD(&private_devs);
-	cur = dev_list->next;
-	index = 0;
-
-	if (type & BTRFS_BLOCK_GROUP_DUP)
-		min_free = calc_size * 2;
-	else
-		min_free = calc_size;
 
-	/* build a private list of devices we will allocate from */
-	while(index < num_stripes) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
-		ret = btrfs_device_avail_bytes(trans, device, &avail);
-		if (ret)
-			return ret;
-		cur = cur->next;
-		if (avail >= min_free) {
-			list_move_tail(&device->dev_list,
-				       &private_devs);
-			index++;
-			if (type & BTRFS_BLOCK_GROUP_DUP)
-				index++;
-		} else if (avail > max_avail)
-			max_avail = avail;
-		if (cur == dev_list)
-			break;
-	}
-	if (index < num_stripes) {
-		list_splice(&private_devs, dev_list);
-		if (index >= min_stripes) {
-			num_stripes = index;
-			if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-				num_stripes /= sub_stripes;
-				num_stripes *= sub_stripes;
-			}
-			looped = 1;
-			goto again;
+	devices_info = kcalloc(rw_devs, sizeof(*devices_info));
+	if (!devices_info)
+		return -ENOMEM;
+	/*
+	 * in the first pass through the devices list, we gather information
+	 * about the available holes on each device.
+	 */
+	ndevs = 0;
+	list_for_each_entry(device, dev_list, dev_list) {
+		u64 max_avail;
+		u64 dev_offset;
+		u64 total_avail;
+
+		if (!device->writeable) {
+			warning("read-only device in alloc_list, devid=%llu",
+				device->devid);
+			continue;
 		}
-		if (!looped && max_avail > 0) {
-			looped = 1;
-			calc_size = max_avail;
-			goto again;
+
+		if (device->total_bytes > device->bytes_used)
+			total_avail = device->total_bytes - device->bytes_used;
+		else
+			total_avail = 0;
+
+		/* If there is no space on this device, skip it. */
+		if (total_avail == 0)
+			continue;
+
+		ret = find_free_dev_extent(device,
+					   max_stripe_size * dev_stripes,
+					   &dev_offset, &max_avail);
+		if (ret && ret != -ENOSPC)
+			goto out_devices_info;
+
+		if (ret == 0)
+			max_avail = max_stripe_size * dev_stripes;
+
+		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
+			continue;
+
+		if (ndevs == rw_devs) {
+			warning("%s: found more than %u devices", __func__,
+				rw_devs);
+			break;
 		}
-		return -ENOSPC;
+		devices_info[ndevs].dev_offset = dev_offset;
+		devices_info[ndevs].max_avail = max_avail;
+		devices_info[ndevs].total_avail = total_avail;
+		devices_info[ndevs].dev = device;
+		++ndevs;
+	}
+
+	/*
+	 * now sort the devices by hole size / available space
+	 */
+	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
+	     btrfs_cmp_device_info, NULL);
+
+	/* round down to number of usable stripes */
+	ndevs = round_down(ndevs, devs_increment);
+
+	if (ndevs < devs_min) {
+		ret = -ENOSPC;
+		goto out_devices_info;
+	}
+
+	ndevs = min(ndevs, devs_max);
+
+	/*
+	 * the primary goal is to maximize the number of stripes, so use as many
+	 * devices as possible, even if the stripes are not maximum sized.
+	 */
+	stripe_size = devices_info[ndevs-1].max_avail;
+	num_stripes = ndevs * dev_stripes;
+
+	/*
+	 * this will have to be fixed for RAID1 and RAID10 over
+	 * more drives
+	 */
+	data_stripes = num_stripes / ncopies;
+
+	if (type & BTRFS_BLOCK_GROUP_RAID5)
+		data_stripes = num_stripes - 1;
+
+	if (type & BTRFS_BLOCK_GROUP_RAID6)
+		data_stripes = num_stripes - 2;
+
+	/*
+	 * Use the number of data stripes to figure out how big this chunk
+	 * is really going to be in terms of logical address space,
+	 * and compare that answer with the max chunk size
+	 */
+	if (stripe_size * data_stripes > max_chunk_size) {
+		stripe_size = div_u64(max_chunk_size, data_stripes);
+
+		/* bump the answer up to a 16MB boundary */
+		stripe_size = round_up(stripe_size, SZ_16M);
+
+		/*
+		 * but don't go higher than the limits we found
+		 * while searching for free extents
+		 */
+		stripe_size = min(devices_info[ndevs - 1].max_avail,
+				  stripe_size);
 	}
+	stripe_size = div_u64(stripe_size, dev_stripes);
+
+	/* align to BTRFS_STRIPE_LEN */
+	stripe_size = round_down(stripe_size, BTRFS_STRIPE_LEN);
 
 	/*
 	 * Fill chunk mapping and chunk stripes
@@ -1118,11 +1051,12 @@ alloc_chunk:
 	if (!convert) {
 		ret = find_next_chunk(info, &offset);
 		if (ret)
-			return ret;
+			goto out_devices_info;
 	}
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 	key.offset = offset;
+	*num_bytes =  stripe_size * data_stripes;
 
 	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
 	if (!chunk)
@@ -1133,55 +1067,52 @@ alloc_chunk:
 		kfree(chunk);
 		return -ENOMEM;
 	}
+	map->num_stripes = num_stripes;
 
-	stripes = &chunk->stripe;
-	*num_bytes = chunk_bytes_by_type(type, calc_size,
-					 num_stripes, sub_stripes);
-	index = 0;
-	while(index < num_stripes) {
-		struct btrfs_stripe *stripe;
-
-		if (!convert) {
-			if (list_empty(&private_devs))
-				return -ENODEV;
-			cur = private_devs.next;
-			device = list_entry(cur, struct btrfs_device, dev_list);
-			if (!(type & BTRFS_BLOCK_GROUP_DUP) ||
-			    (index == num_stripes - 1)) {
-				/*
-				 * loop over this device again if we're doing a
-				 * dup group
-				 */
-				list_move_tail(&device->dev_list, dev_list);
-			}
-		} else {
-			/* Only SINGLE is accepted in convert case */
-			BUG_ON(num_stripes > 1);
-			device = list_entry(dev_list->next, struct btrfs_device,
-					    dev_list);
-			key.offset = *start;
-			dev_offset = *start;
-		}
-
-		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
-			     calc_size, &dev_offset, convert);
-		if (ret < 0)
-			goto out_chunk_map;
-
-		device->bytes_used += calc_size;
-		ret = btrfs_update_device(trans, device);
-		if (ret < 0)
-			goto out_chunk_map;
+	if (convert) {
+		device = list_entry(dev_list->next, struct btrfs_device,
+				    dev_list);
 
-		map->stripes[index].dev = device;
-		map->stripes[index].physical = dev_offset;
-		stripe = stripes + index;
+		map->stripes[0].dev = device;
+		map->stripes[0].physical = *start;
+		stripe = &chunk->stripe;
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
-		btrfs_set_stack_stripe_offset(stripe, dev_offset);
+		btrfs_set_stack_stripe_offset(stripe, *start);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		index++;
+	} else {
+		for (i = 0; i < ndevs; i++) {
+			for (j = 0; j < dev_stripes; ++j) {
+				int s = i * dev_stripes + j;
+
+				device = devices_info[i].dev;
+				map->stripes[s].dev = device;
+				map->stripes[s].physical =
+					devices_info[i].dev_offset +
+					j * stripe_size;
+				stripe = &chunk->stripe + s;
+				btrfs_set_stack_stripe_devid(stripe,
+						device->devid);
+				btrfs_set_stack_stripe_offset(stripe,
+						devices_info[i].dev_offset +
+						j * stripe_size);
+				memcpy(stripe->dev_uuid, device->uuid,
+						BTRFS_UUID_SIZE);
+			}
+		}
 	}
-	BUG_ON(!convert && !list_empty(&private_devs));
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->io_width = BTRFS_STRIPE_LEN;
+	map->io_width = BTRFS_STRIPE_LEN;
+	map->type = type;
+	map->sub_stripes = sub_stripes;
+	map->sector_size = info->sectorsize;
+	map->ce.start = key.offset;
+	map->ce.size = *num_bytes;
+
+
+	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
+	if (ret < 0)
+		goto out_chunk_map;
 
 	/* key was set above */
 	btrfs_set_stack_chunk_length(chunk, *num_bytes);
@@ -1193,13 +1124,6 @@ alloc_chunk:
 	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
 	btrfs_set_stack_chunk_sector_size(chunk, info->sectorsize);
 	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
-	map->sector_size = info->sectorsize;
-	map->stripe_len = stripe_len;
-	map->io_align = stripe_len;
-	map->io_width = stripe_len;
-	map->type = type;
-	map->num_stripes = num_stripes;
-	map->sub_stripes = sub_stripes;
 
 	/*
 	 * Insert chunk item and chunk mapping.
@@ -1209,13 +1133,6 @@ alloc_chunk:
 	BUG_ON(ret);
 	*start = key.offset;;
 
-	map->ce.start = key.offset;
-	map->ce.size = *num_bytes;
-
-	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
-	if (ret < 0)
-		goto out_chunk_map;
-
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_add_system_chunk(info, &key,
 				    chunk, btrfs_chunk_item_size(num_stripes));
@@ -1225,14 +1142,24 @@ alloc_chunk:
 
 	kfree(chunk);
 
+	/*
+	 * Insert device extents
+	 */
+	ret = btrfs_insert_dev_extents(trans, info, map, stripe_size);
+	if (ret < 0)
+		goto out_devices_info;
+
 	ret = btrfs_make_block_group(trans, info, 0, type, map->ce.start,
 				     map->ce.size);
+	kfree(devices_info);
 	return ret;
 
 out_chunk_map:
 	kfree(map);
 out_chunk:
 	kfree(chunk);
+out_devices_info:
+	kfree(devices_info);
 	return ret;
 }
 
diff --git a/volumes.h b/volumes.h
index 612a0a7586f4..3741d45cae80 100644
--- a/volumes.h
+++ b/volumes.h
@@ -108,6 +108,13 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct btrfs_device_info {
+	struct btrfs_device *dev;
+	u64 dev_offset;
+	u64 max_avail;
+	u64 total_avail;
+};
+
 struct btrfs_raid_attr {
 	int sub_stripes;	/* sub_stripes info for map */
 	int dev_stripes;	/* stripes per dev */
-- 
2.16.1

