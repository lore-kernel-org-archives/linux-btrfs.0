From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 4/4] update allocator the handle 'hole' in address space
Date: Tue, 09 Sep 2008 02:56:42 +0800
Message-ID: <48C5756A.6090308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	yanzheng@21cn.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Space balancing creates some 'holes' in the address space, this confuses
the allocator. This patch removes all checks against the super_total_bytes.

Regards
Yan Zheng

---
diff -r 16615727163e ctree.h
--- a/ctree.h	Tue Sep 09 02:16:25 2008 +0800
+++ b/ctree.h	Tue Sep 09 02:16:35 2008 +0800
@@ -500,7 +500,6 @@
 	u64 bytes_used;
 	u64 bytes_pinned;
 	u64 bytes_reserved;
-	int full;
 	int force_alloc;
 	struct list_head list;
 };
diff -r 16615727163e extent-tree.c
--- a/extent-tree.c	Tue Sep 09 02:16:25 2008 +0800
+++ b/extent-tree.c	Tue Sep 09 02:16:35 2008 +0800
@@ -51,6 +51,8 @@
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 			       btrfs_root *extent_root);
+static int __alloc_chunk_for_extent_op(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root);
 static struct btrfs_block_group_cache *
 __btrfs_find_block_group(struct btrfs_root *root,
 			 struct btrfs_block_group_cache *hint,
@@ -254,13 +256,10 @@
 	struct extent_state *state;
 	u64 last;
 	u64 start = 0;
-	u64 cache_miss = 0;
-	u64 total_fs_bytes;
 	u64 search_start = *start_ret;
 	int wrapped = 0;
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
-	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	free_space_cache = &root->fs_info->free_space_cache;
 
 	if (!cache)
@@ -280,8 +279,6 @@
 	state = find_first_extent_bit_state(free_space_cache, last, EXTENT_DIRTY);
 	while(1) {
 		if (!state) {
-			if (!cache_miss)
-				cache_miss = last;
 			spin_unlock_irq(&free_space_cache->lock);
 			goto new_group;
 		}
@@ -318,7 +315,7 @@
 	last = cache->key.objectid + cache->key.offset;
 wrapped:
 	cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	if (!cache || cache->key.objectid >= total_fs_bytes) {
+	if (!cache) {
 no_cache:
 		if (!wrapped) {
 			wrapped = 1;
@@ -327,12 +324,6 @@
 		}
 		goto out;
 	}
-	if (cache_miss && !cache->cached) {
-		cache_block_group(root, cache);
-		last = cache_miss;
-		cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	}
-	cache_miss = 0;
 	cache = btrfs_find_block_group(root, cache, last, data, 0);
 	if (!cache)
 		goto no_cache;
@@ -719,6 +710,7 @@
 	if (!path)
 		return -ENOMEM;
 
+	__alloc_chunk_for_extent_op(trans, root);
 	ret = lookup_extent_backref(trans, extent_root, path,
 				    bytenr, orig_parent,
 				    root_objectid, ref_generation, 1);
@@ -779,6 +771,7 @@
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	key.offset = num_bytes;
 
+	__alloc_chunk_for_extent_op(trans, root);
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
 				0, 1);
 	if (ret < 0)
@@ -1277,6 +1270,7 @@
 	unsigned long bi;
 	struct extent_buffer *leaf;
 
+	__alloc_chunk_for_extent_op(trans, extent_root);
 	ret = btrfs_search_slot(trans, extent_root, &cache->key, path, 0, 1);
 	if (ret < 0)
 		goto fail;
@@ -1374,7 +1368,6 @@
 	if (found) {
 		found->total_bytes += total_bytes;
 		found->bytes_used += bytes_used;
-		found->full = 0;
 		*space_info = found;
 		return 0;
 	}
@@ -1388,7 +1381,6 @@
 	found->bytes_used = bytes_used;
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
-	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
 	return 0;
@@ -1462,8 +1454,6 @@
 		force = 1;
 		space_info->force_alloc = 0;
 	}
-	if (space_info->full)
-		goto out;
 
 	thresh = div_factor(space_info->total_bytes, 6);
 	if (!force &&
@@ -1473,12 +1463,8 @@
 
 	mutex_lock(&extent_root->fs_info->chunk_mutex);
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
-	if (ret == -ENOSPC) {
-printk("space info full %Lu\n", flags);
-		space_info->full = 1;
+	if (ret == -ENOSPC)
 		goto out_unlock;
-	}
-	BUG_ON(ret);
 
 	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
@@ -1487,6 +1473,24 @@
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 out:
 	return 0;
+}
+
+static int __alloc_chunk_for_extent_op(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	int ret;
+
+	if (root == root->fs_info->chunk_root ||
+	    root == root->fs_info->dev_root)
+		return 0;
+
+	ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+			     2 * 1024 * 1024,
+			     BTRFS_BLOCK_GROUP_METADATA |
+			     (info->metadata_alloc_profile &
+			      info->avail_metadata_alloc_bits), 0);
+	return ret;
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
@@ -2232,6 +2236,7 @@
 	if (ref_generation != trans->transid)
 		pin = 1;
 
+	__alloc_chunk_for_extent_op(trans, root);
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
 			    root_objectid, ref_generation,
 			    owner_objectid, owner_offset, pin, pin == 0);
@@ -2324,9 +2329,6 @@
 
 	search_start = max(search_start, first_logical_byte(root, 0));
 	orig_search_start = search_start;
-
-	if (search_end == (u64)-1)
-		search_end = btrfs_super_total_bytes(&info->super_copy);
 
 	if (hint_byte) {
 		block_group = btrfs_lookup_first_block_group(info, hint_byte);
@@ -2399,9 +2401,6 @@
 	ins->objectid = search_start;
 	ins->offset = num_bytes;
 
-	if (ins->objectid + num_bytes >= search_end)
-		goto enospc;
-
 	if (ins->objectid + num_bytes >
 	    block_group->key.objectid + block_group->key.offset) {
 		search_start = block_group->key.objectid +
@@ -2443,7 +2442,8 @@
 	return 0;
 
 new_group:
-	if (search_start + num_bytes >= search_end) {
+	block_group = btrfs_lookup_first_block_group(info, search_start);
+	if (!block_group) {
 enospc:
 		search_start = orig_search_start;
 		if (full_scan) {
@@ -2457,7 +2457,6 @@
 		} else
 			wrapped = 1;
 	}
-	block_group = btrfs_lookup_first_block_group(info, search_start);
 	cond_resched();
 	block_group = btrfs_find_block_group(root, block_group,
 					     search_start, data, 0);
@@ -2613,6 +2612,7 @@
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
+	__alloc_chunk_for_extent_op(trans, root);
 	ret = btrfs_insert_empty_items(trans, extent_root, path, keys,
 				       sizes, 2);
 
@@ -3795,6 +3795,8 @@
 		needs_lock = 1;
 		mutex_lock(&root->fs_info->alloc_mutex);
 	}
+	if (root == root->fs_info->extent_root)
+		__alloc_chunk_for_extent_op(trans, root);
 
 	path->lowest_level = level;
 	ret = btrfs_search_slot(trans, root, first_key, path, 0, 1);
@@ -4406,9 +4408,6 @@
 		set_extent_bits(block_group_cache, found_key.objectid,
 				found_key.objectid + found_key.offset - 1,
 				bit | EXTENT_LOCKED, GFP_NOFS);
-		if (key.objectid >=
-		    btrfs_super_total_bytes(&info->super_copy))
-			break;
 	}
 	ret = 0;
 error:
diff -r 16615727163e volumes.c
--- a/volumes.c	Tue Sep 09 02:16:25 2008 +0800
+++ b/volumes.c	Tue Sep 09 02:16:35 2008 +0800
@@ -1094,6 +1094,7 @@
 		 &root->fs_info->fs_devices->alloc_list);
 	root->fs_info->fs_devices->num_devices++;
 	root->fs_info->fs_devices->open_devices++;
+	root->fs_info->fs_devices->full = 0;
 out:
 	unlock_chunks(root);
 	btrfs_end_transaction(trans, root);
@@ -1376,6 +1377,8 @@
 		BUG_ON(ret);
 
 		btrfs_end_transaction(trans, dev_root);
+
+		dev_root->fs_info->fs_devices->full = 0;
 	}
 
 	/* step two, relocate all the chunks */
@@ -1422,6 +1425,8 @@
 					   found_key.objectid,
 					   found_key.offset);
 		BUG_ON(ret);
+
+		dev_root->fs_info->fs_devices->full = 0;
 	}
 	ret = 0;
 error:
@@ -1601,6 +1606,10 @@
 		WARN_ON(1);
 		type &= ~BTRFS_BLOCK_GROUP_DUP;
 	}
+
+	if (extent_root->fs_info->fs_devices->full)
+		return -ENOSPC;
+
 	dev_list = &extent_root->fs_info->fs_devices->alloc_list;
 	if (list_empty(dev_list))
 		return -ENOSPC;
@@ -1717,7 +1726,12 @@
 			calc_size = max_avail;
 			goto again;
 		}
+		if (calc_size > min_stripe_size) {
+			calc_size >>= 1;
+			goto again;
+		}
 		btrfs_free_path(path);
+		extent_root->fs_info->fs_devices->full = 1;
 		return -ENOSPC;
 	}
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
diff -r 16615727163e volumes.h
--- a/volumes.h	Tue Sep 09 02:16:25 2008 +0800
+++ b/volumes.h	Tue Sep 09 02:16:35 2008 +0800
@@ -85,6 +85,7 @@
 	struct list_head alloc_list;
 	struct list_head list;
 	int mounted;
+	int full;
 };
 
 struct btrfs_bio_stripe {
