From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 5/6] btrfs: make the chunk allocator utilize the devices better
Date: Wed, 22 Dec 2010 18:47:35 +0800
Message-ID: <4D11D747.4050503@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With this patch, we change the handling method when we can not get enough free
extents with default size.

Implementation:
1. Look up the suitable free extent on each device and keep the search result.
   If not find a suitable free extent, keep the max free extent
2. If we get enough suitable free extents with default size, chunk allocation
   succeeds.
3. If we can not get enough free extents, but the number of the extent with
   default size is >= min_stripes, we just change the mapping information
   (reduce the number of stripes in the extent map), and chunk allocation
   succeeds.
4. If the number of the extent with default size is < min_stripes, sort the
   devices by its max free extent's size descending
5. Use the size of the max free extent on the (num_stripes - 1)th device as the
   stripe size to allocate the device space

By this way, the chunk allocator can allocate chunks as large as possible when
the devices' space is not enough and make full use of the devices.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |  371 ++++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/volumes.h |   24 ++++
 2 files changed, 297 insertions(+), 98 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15e8c3f..c298367 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -877,7 +877,7 @@ out:
 	btrfs_free_path(path);
 error:
 	*start = max_hole_start;
-	if (len && max_hole_size > *len)
+	if (len)
 		*len = max_hole_size;
 	return ret;
 }
@@ -2176,70 +2176,67 @@ static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
 		return calc_size * num_stripes;
 }
 
-static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *extent_root,
-			       struct map_lookup **map_ret,
-			       u64 *num_bytes, u64 *stripe_size,
-			       u64 start, u64 type)
+/* Used to sort the devices by max_avail(descending sort) */
+int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
 {
-	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_device *device = NULL;
-	struct btrfs_fs_devices *fs_devices = info->fs_devices;
-	struct list_head *cur;
-	struct map_lookup *map = NULL;
-	struct extent_map_tree *em_tree;
-	struct extent_map *em;
-	struct list_head private_devs;
-	int min_stripe_size = 1 * 1024 * 1024;
-	u64 calc_size = 1024 * 1024 * 1024;
-	u64 max_chunk_size = calc_size;
-	u64 min_free;
-	u64 avail;
-	u64 max_avail = 0;
-	u64 dev_offset;
-	int num_stripes = 1;
-	int min_stripes = 1;
-	int sub_stripes = 0;
-	int ncopies = 1;
-	int looped = 0;
-	int ret;
-	int index;
-	int stripe_len = 64 * 1024;
+	if (((struct btrfs_device_info *)dev_info1)->max_avail >
+	    ((struct btrfs_device_info *)dev_info2)->max_avail)
+		return -1;
+	else if (((struct btrfs_device_info *)dev_info1)->max_avail <
+		 ((struct btrfs_device_info *)dev_info2)->max_avail)
+		return 1;
+	else
+		return 0;
+}
 
-	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
-	    (type & BTRFS_BLOCK_GROUP_DUP)) {
-		WARN_ON(1);
-		type &= ~BTRFS_BLOCK_GROUP_DUP;
-	}
-	if (list_empty(&fs_devices->alloc_list))
-		return -ENOSPC;
+static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
+				 int *num_stripes, int *min_stripes,
+				 int *sub_stripes)
+{
+	*num_stripes = 1;
+	*min_stripes = 1;
+	*sub_stripes = 0;
 
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		num_stripes = fs_devices->rw_devices;
-		min_stripes = 2;
+		*num_stripes = fs_devices->rw_devices;
+		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
-		num_stripes = 2;
-		min_stripes = 2;
-		ncopies = 2;
+		*num_stripes = 2;
+		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
 		if (fs_devices->rw_devices < 2)
 			return -ENOSPC;
-		num_stripes = 2;
-		min_stripes = 2;
-		ncopies = 2;
+		*num_stripes = 2;
+		*min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		num_stripes = fs_devices->rw_devices;
-		if (num_stripes < 4)
+		*num_stripes = fs_devices->rw_devices;
+		if (*num_stripes < 4)
 			return -ENOSPC;
-		num_stripes &= ~(u32)1;
-		sub_stripes = 2;
-		ncopies = 2;
-		min_stripes = 4;
+		*num_stripes &= ~(u32)1;
+		*sub_stripes = 2;
+		*min_stripes = 4;
 	}
 
+	return 0;
+}
+
+static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
+				    u64 proposed_size, u64 type,
+				    int num_stripes, int small_stripe)
+{
+	int min_stripe_size = 1 * 1024 * 1024;
+	u64 calc_size = proposed_size;
+	u64 max_chunk_size = calc_size;
+	int ncopies = 1;
+
+	if (type & (BTRFS_BLOCK_GROUP_RAID1 |
+		    BTRFS_BLOCK_GROUP_DUP |
+		    BTRFS_BLOCK_GROUP_RAID10))
+		ncopies = 2;
+
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_chunk_size = 10 * calc_size;
 		min_stripe_size = 64 * 1024 * 1024;
@@ -2256,52 +2253,211 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-again:
-	max_avail = 0;
-	if (!map || map->num_stripes != num_stripes) {
-		kfree(map);
-		map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
-		if (!map)
-			return -ENOMEM;
-		map->num_stripes = num_stripes;
-	}
-
 	if (calc_size * num_stripes / ncopies > max_chunk_size) {
 		calc_size = max_chunk_size * ncopies;
 		do_div(calc_size, num_stripes);
-		do_div(calc_size, stripe_len);
-		calc_size *= stripe_len;
+		do_div(calc_size, BTRFS_STRIPE_LEN);
+		calc_size *= BTRFS_STRIPE_LEN;
 	}
 
 	/* we don't want tiny stripes */
-	if (!looped)
+	if (!small_stripe)
 		calc_size = max_t(u64, min_stripe_size, calc_size);
 
 	/*
-	 * we're about to do_div by the stripe_len so lets make sure
+	 * we're about to do_div by the BTRFS_STRIPE_LEN so lets make sure
 	 * we end up with something bigger than a stripe
 	 */
-	calc_size = max_t(u64, calc_size, stripe_len * 4);
+	calc_size = max_t(u64, calc_size, BTRFS_STRIPE_LEN);
+
+	do_div(calc_size, BTRFS_STRIPE_LEN);
+	calc_size *= BTRFS_STRIPE_LEN;
+
+	return calc_size;
+}
+
+static struct map_lookup *__shrink_map_lookup_stripes(struct map_lookup *map,
+						      int num_stripes)
+{
+	struct map_lookup *new;
+	size_t len = map_lookup_size(num_stripes);
+
+	new = kmalloc(len, GFP_NOFS);
+	if (!new) {
+		/* just change map->num_stripes */
+		map->num_stripes = num_stripes;
+		return map;
+	}
+
+	memcpy(new, map, len);
+	kfree(map);
+	return new;
+}
+
+/*
+ * helper to allocate device space from btrfs_device_info, in which we stored
+ * max free space information of every device. It is used when we can not
+ * allocate chunks by default size.
+ *
+ * By this helper, we can allocate a new chunk as larger as possible.
+ */
+static struct map_lookup *__btrfs_alloc_tiny_space(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_fs_devices *fs_devices,
+					struct btrfs_device_info *devices,
+					int nr_device, u64 type,
+					struct map_lookup *map,
+					int num_stripes, int min_stripes,
+					u64 *stripe_size)
+{
+	int i, sort_again = 0;
+	u64 max_avail, min_free;
+
+	if (nr_device < min_stripes)
+		return ERR_PTR(-ENOSPC);
+
+	if (nr_device < num_stripes)
+		num_stripes = nr_device;
+
+	btrfs_descending_sort_devices(devices, nr_device);
+
+	max_avail = devices[0].max_avail;
+	if (!max_avail)
+		return ERR_PTR(-ENOSPC);
+
+	for (i = 0; i < nr_device; i++) {
+		/*
+		 * if dev_offset = 0, it means the free space of this device
+		 * is less than what we need, and we didn't search max avail
+		 * extent on this device, so do it now.
+		 *
+		 * if max_avail = 0, it means when we search max avail extent
+		 * on this device, error happened, so try to search again.
+		 */
+		if (!devices[i].dev_offset || !devices[i].max_avail) {
+			find_free_dev_extent(trans, devices[i].dev, max_avail,
+					     &devices[i].dev_offset,
+					     &devices[i].max_avail);
+			sort_again = 1;
+		}
+	}
+
+	/* we update the max avail free extent of each devices, sort again */
+	if (sort_again)
+		btrfs_descending_sort_devices(devices, nr_device);
+
+	i = num_stripes - 1;
+	for (; i >= min_stripes - 1; i--) {
+		if (!devices[i].max_avail) {
+			num_stripes--;
+			continue;
+		}
 
-	do_div(calc_size, stripe_len);
-	calc_size *= stripe_len;
+		BUG_ON(!devices[i].dev_offset);
+
+		max_avail = devices[i].max_avail;
+		if (type & BTRFS_BLOCK_GROUP_DUP)
+			max_avail /= 2;
+
+		max_avail = __btrfs_calc_stripe_size(fs_devices, max_avail,
+						     type, num_stripes, 1);
+		if (type & BTRFS_BLOCK_GROUP_DUP)
+			min_free = max_avail * 2;
+		else
+			min_free = max_avail;
+
+		if (min_free <= devices[i].max_avail)
+			break;
+
+		num_stripes--;
+	}
+
+	if (i < min_stripes - 1)
+		return ERR_PTR(-ENOSPC);
+
+	num_stripes = i + 1;
+	map = __shrink_map_lookup_stripes(map, num_stripes);
+	*stripe_size = max_avail;
+
+	for (i = 0; i < num_stripes; i++) {
+		map->stripes[i].dev = devices[i].dev;
+		map->stripes[i].physical = devices[i].dev_offset;
+		if (type & BTRFS_BLOCK_GROUP_DUP) {
+			map->stripes[i].dev = devices[i].dev;
+			map->stripes[i].physical = devices[i].dev_offset +
+						   max_avail;
+		}
+	}
+
+	return map;
+}
+
+static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *extent_root,
+			       struct map_lookup **map_ret,
+			       u64 *num_bytes, u64 *stripe_size,
+			       u64 start, u64 type)
+{
+	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_device *device = NULL;
+	struct btrfs_fs_devices *fs_devices = info->fs_devices;
+	struct list_head *cur;
+	struct map_lookup *map = NULL;
+	struct extent_map_tree *em_tree;
+	struct extent_map *em;
+	struct btrfs_device_info *devices_info;
+	struct list_head private_devs;
+	u64 calc_size = 1024 * 1024 * 1024;
+	u64 min_free;
+	u64 avail;
+	u64 dev_offset;
+	int num_stripes;
+	int min_stripes;
+	int sub_stripes;
+	int i;
+	int ret;
+	int index;
+
+	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
+	    (type & BTRFS_BLOCK_GROUP_DUP)) {
+		WARN_ON(1);
+		type &= ~BTRFS_BLOCK_GROUP_DUP;
+	}
+	if (list_empty(&fs_devices->alloc_list))
+		return -ENOSPC;
+
+	ret = __btrfs_calc_nstripes(fs_devices, type, &num_stripes,
+				    &min_stripes, &sub_stripes);
+	if (ret)
+		return ret;
+
+	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
+			       GFP_NOFS);
+	if (!devices_info)
+		return -ENOMEM;
+
+	if (!map || map->num_stripes != num_stripes) {
+		kfree(map);
+		map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+		if (!map) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		map->num_stripes = num_stripes;
+	}
 
 	cur = fs_devices->alloc_list.next;
 	index = 0;
+	i = 0;
+
+	calc_size = __btrfs_calc_stripe_size(fs_devices, calc_size, type,
+					     num_stripes, 0);
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
 		min_free = calc_size * 2;
 	else
 		min_free = calc_size;
 
-	/*
-	 * we add 1MB because we never use the first 1MB of the device, unless
-	 * we've looped, then we are likely allocating the maximum amount of
-	 * space left already
-	 */
-	if (!looped)
-		min_free += 1024 * 1024;
-
 	INIT_LIST_HEAD(&private_devs);
 	while (index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
@@ -2313,27 +2469,37 @@ again:
 		cur = cur->next;
 
 		if (device->in_fs_metadata && avail >= min_free) {
-			ret = find_free_dev_extent(trans, device,
-						   min_free, &dev_offset,
-						   &max_avail);
+			ret = find_free_dev_extent(trans, device, min_free,
+						   &devices_info[i].dev_offset,
+						   &devices_info[i].max_avail);
 			if (ret == 0) {
 				list_move_tail(&device->dev_alloc_list,
 					       &private_devs);
 				map->stripes[index].dev = device;
-				map->stripes[index].physical = dev_offset;
+				map->stripes[index].physical =
+						devices_info[i].dev_offset;
 				index++;
 				if (type & BTRFS_BLOCK_GROUP_DUP) {
 					map->stripes[index].dev = device;
 					map->stripes[index].physical =
-						dev_offset + calc_size;
+						devices_info[i].dev_offset +
+						calc_size;
 					index++;
 				}
 			}
-		} else if (device->in_fs_metadata && avail > max_avail)
-			max_avail = avail;
+			devices_info[i].dev = device;
+			i++;
+		} else if (device->in_fs_metadata &&
+			   avail >= BTRFS_STRIPE_LEN) {
+			devices_info[i].dev = device;
+			devices_info[i].max_avail = avail;
+			i++;
+		}
+
 		if (cur == &fs_devices->alloc_list)
 			break;
 	}
+
 	list_splice(&private_devs, &fs_devices->alloc_list);
 	if (index < num_stripes) {
 		if (index >= min_stripes) {
@@ -2342,23 +2508,26 @@ again:
 				num_stripes /= sub_stripes;
 				num_stripes *= sub_stripes;
 			}
-			looped = 1;
-			goto again;
-		}
-		if (!looped && max_avail > 0) {
-			looped = 1;
-			calc_size = max_avail;
-			if (type & BTRFS_BLOCK_GROUP_DUP)
-				calc_size /= 2;
-			goto again;
+
+			map = __shrink_map_lookup_stripes(map, num_stripes);
+		} else if (i >= min_stripes) {
+			map = __btrfs_alloc_tiny_space(trans, fs_devices,
+						       devices_info, i, type,
+						       map, num_stripes,
+						       min_stripes, &calc_size);
+			if (IS_ERR(map)) {
+				ret = PTR_ERR(map);
+				goto error;
+			}
+		} else {
+			ret = -ENOSPC;
+			goto error;
 		}
-		kfree(map);
-		return -ENOSPC;
 	}
 	map->sector_size = extent_root->sectorsize;
-	map->stripe_len = stripe_len;
-	map->io_align = stripe_len;
-	map->io_width = stripe_len;
+	map->stripe_len = BTRFS_STRIPE_LEN;
+	map->io_align = BTRFS_STRIPE_LEN;
+	map->io_width = BTRFS_STRIPE_LEN;
 	map->type = type;
 	map->num_stripes = num_stripes;
 	map->sub_stripes = sub_stripes;
@@ -2370,8 +2539,8 @@ again:
 
 	em = alloc_extent_map(GFP_NOFS);
 	if (!em) {
-		kfree(map);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 	em->bdev = (struct block_device *)map;
 	em->start = start;
@@ -2404,7 +2573,13 @@ again:
 		index++;
 	}
 
+	kfree(devices_info);
 	return 0;
+
+error:
+	kfree(map);
+	kfree(devices_info);
+	return ret;
 }
 
 static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a668c01..a5cfedf 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -20,8 +20,11 @@
 #define __BTRFS_VOLUMES_
 
 #include <linux/bio.h>
+#include <linux/sort.h>
 #include "async-thread.h"
 
+#define BTRFS_STRIPE_LEN	(64 * 1024)
+
 struct buffer_head;
 struct btrfs_pending_bios {
 	struct bio *head;
@@ -137,6 +140,27 @@ struct btrfs_multi_bio {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct btrfs_device_info {
+	struct btrfs_device *dev;
+	u64 dev_offset;
+	u64 max_avail;
+};
+
+/* Used to sort the devices by max_avail(descending sort) */
+int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
+
+/*
+ * sort the devices by max_avail, in which max free extent size of each device
+ * is stored.(Descending Sort)
+ */
+static inline void btrfs_descending_sort_devices(
+					struct btrfs_device_info *devices,
+					size_t nr_devices)
+{
+	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
+	     btrfs_cmp_device_free_bytes, NULL);
+}
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
-- 
1.7.0.1
