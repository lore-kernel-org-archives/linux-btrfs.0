From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Fixing the chunk allocator to allow it to better utilize the devices
Date: Sat, 11 Dec 2010 21:13:32 +0100
Message-ID: <1292098412-2986-1-git-send-email-sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The chunk allocator had several small bugs that prevented it to use the
devices fully in multi-device setups.
find_free_dev_extent didn't return max_avail correctly if the largest hole
was at the end of the device. Also it disregarded alloc_start in certain
situations.
It has also been restructured for better readability.

__btrs_alloc_chunk now uses the returned max_avail to determine the maximum
chunk available for its again-loop, instead of the total amount of free
space of the device, which might not be available in one piece.
It also uses the devices in a round robin fashion, which help balancing
the devices better.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |    4 +-
 fs/btrfs/volumes.c     |  135 +++++++++++++++++++++++++-----------------------
 2 files changed, 73 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ddaf634..00d7240 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8049,7 +8049,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	mutex_lock(&root->fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
 		u64 min_free = btrfs_block_group_used(&block_group->item);
-		u64 dev_offset, max_avail;
+		u64 dev_offset;
 
 		/*
 		 * check to make sure we can actually find a chunk with enough
@@ -8057,7 +8057,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 */
 		if (device->total_bytes > device->bytes_used + min_free) {
 			ret = find_free_dev_extent(NULL, device, min_free,
-						   &dev_offset, &max_avail);
+						   &dev_offset, NULL);
 			if (!ret)
 				break;
 			ret = -1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 91851b5..0540a9d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -738,29 +738,33 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
 	u64 hole_size = 0;
-	u64 last_byte = 0;
-	u64 search_start = 0;
+	u64 hole_start;
+	u64 hole_end;
+	u64 search_start;
 	u64 search_end = device->total_bytes;
 	int ret;
 	int slot = 0;
-	int start_found;
 	struct extent_buffer *l;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 	path->reada = 2;
-	start_found = 0;
 
 	/* FIXME use last free of some kind */
 
 	/* we don't want to overwrite the superblock on the drive,
 	 * so we make sure to start at an offset of at least 1MB
 	 */
-	search_start = max((u64)1024 * 1024, search_start);
+	search_start = max((u64)1024 * 1024, root->fs_info->alloc_start);
 
-	if (root->fs_info->alloc_start + num_bytes <= device->total_bytes)
-		search_start = max(root->fs_info->alloc_start, search_start);
+	if (search_start >= search_end) {
+		ret = -ENOSPC;
+		goto error;
+	}
+
+	hole_start = search_start;
+	hole_end = search_end;
 
 	key.objectid = device->devid;
 	key.offset = search_start;
@@ -772,8 +776,6 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_previous_item(root, path, key.objectid, key.type);
 		if (ret < 0)
 			goto error;
-		if (ret > 0)
-			start_found = 1;
 	}
 	l = path->nodes[0];
 	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
@@ -786,23 +788,8 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 				continue;
 			if (ret < 0)
 				goto error;
-no_more_items:
-			if (!start_found) {
-				if (search_start >= search_end) {
-					ret = -ENOSPC;
-					goto error;
-				}
-				*start = search_start;
-				start_found = 1;
-				goto check_pending;
-			}
-			*start = last_byte > search_start ?
-				last_byte : search_start;
-			if (search_end <= *start) {
-				ret = -ENOSPC;
-				goto error;
-			}
-			goto check_pending;
+
+			break;
 		}
 		btrfs_item_key_to_cpu(l, &key, slot);
 
@@ -810,43 +797,48 @@ no_more_items:
 			goto next;
 
 		if (key.objectid > device->devid)
-			goto no_more_items;
+			break;
 
-		if (key.offset >= search_start && key.offset > last_byte &&
-		    start_found) {
-			if (last_byte < search_start)
-				last_byte = search_start;
-			hole_size = key.offset - last_byte;
+		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
+			goto next;
 
-			if (hole_size > *max_avail)
-				*max_avail = hole_size;
+		if (key.offset > hole_start) {
+			hole_size = key.offset - hole_start;
 
-			if (key.offset > last_byte &&
-			    hole_size >= num_bytes) {
-				*start = last_byte;
-				goto check_pending;
+			if (hole_size >= num_bytes) {
+				hole_end = key.offset;
+				break;
 			}
+
+			if (max_avail && hole_size > *max_avail)
+				*max_avail = hole_size;
 		}
-		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
-			goto next;
 
-		start_found = 1;
 		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
-		last_byte = key.offset + btrfs_dev_extent_length(l, dev_extent);
+		hole_start = key.offset + btrfs_dev_extent_length(l, dev_extent);
+		if (hole_start < search_start)
+			hole_start = search_start;
 next:
 		path->slots[0]++;
 		cond_resched();
 	}
-check_pending:
 	/* we have to make sure we didn't find an extent that has already
 	 * been allocated by the map tree or the original allocation
 	 */
-	BUG_ON(*start < search_start);
+	BUG_ON(hole_start < search_start);
+
+	hole_size = hole_end - hole_start;
 
-	if (*start + num_bytes > search_end) {
+	if (max_avail && hole_size > *max_avail)
+		*max_avail = hole_size;
+
+	if (hole_start + num_bytes > search_end) {
 		ret = -ENOSPC;
 		goto error;
 	}
+
+	*start = hole_start;
+
 	/* check for pending inserts here */
 	ret = 0;
 
@@ -2154,6 +2146,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_device *device = NULL;
+	struct btrfs_device *smallest_dev;
 	struct btrfs_fs_devices *fs_devices = info->fs_devices;
 	struct list_head *cur;
 	struct map_lookup *map = NULL;
@@ -2165,7 +2158,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_chunk_size = calc_size;
 	u64 min_free;
 	u64 avail;
-	u64 max_avail = 0;
+	u64 min_max_avail = 0;
 	u64 dev_offset;
 	int num_stripes = 1;
 	int min_stripes = 1;
@@ -2223,7 +2216,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			     max_chunk_size);
 
 again:
-	max_avail = 0;
 	if (!map || map->num_stripes != num_stripes) {
 		kfree(map);
 		map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
@@ -2260,15 +2252,9 @@ again:
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
+	min_max_avail = 0;
+	smallest_dev = NULL;
 	while (index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
 		BUG_ON(!device->writeable);
@@ -2278,10 +2264,20 @@ again:
 			avail = 0;
 		cur = cur->next;
 
-		if (device->in_fs_metadata && avail >= min_free) {
-			ret = find_free_dev_extent(trans, device,
-						   min_free, &dev_offset,
-						   &max_avail);
+		if (device->in_fs_metadata) {
+			u64 max_avail = 0;
+			ret = find_free_dev_extent(trans, device, min_free,
+			                           &dev_offset, &max_avail);
+			/*
+			 * track the minimum stripe len that is available on all devices,
+			 * but don't count holes that are too small
+			 */
+			if (max_avail >= stripe_len * 4 &&
+			    (max_avail < min_max_avail || min_max_avail == 0)) {
+				min_max_avail = max_avail;
+				smallest_dev = device;
+			}
+
 			if (ret == 0) {
 				list_move_tail(&device->dev_alloc_list,
 					       &private_devs);
@@ -2295,12 +2291,16 @@ again:
 					index++;
 				}
 			}
-		} else if (device->in_fs_metadata && avail > max_avail)
-			max_avail = avail;
+		}
 		if (cur == &fs_devices->alloc_list)
 			break;
 	}
-	list_splice(&private_devs, &fs_devices->alloc_list);
+	/*
+	 * splice the list of used devices to the end. This achieves
+	 * a basic round-robin scheme which help balancing the devices
+	 * better.
+	 */
+	list_splice_tail(&private_devs, &fs_devices->alloc_list);
 	if (index < num_stripes) {
 		if (index >= min_stripes) {
 			num_stripes = index;
@@ -2311,9 +2311,16 @@ again:
 			looped = 1;
 			goto again;
 		}
-		if (!looped && max_avail > 0) {
+		if (!looped && min_max_avail > 0) {
 			looped = 1;
-			calc_size = max_avail;
+			calc_size = min_max_avail;
+			/*
+			 * move the smallest device to the head of the list to
+			 * make sure it gets included in the chunk.
+			 */
+			BUG_ON(!smallest_dev);
+			list_move(&smallest_dev->dev_alloc_list,
+			          &fs_devices->alloc_list);
 			goto again;
 		}
 		kfree(map);
-- 
1.7.2.2

