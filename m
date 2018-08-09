Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44684 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727588AbeHIUho (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:44 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 12/12] btrfs-progs: do sequential allocation
Date: Fri, 10 Aug 2018 03:11:05 +0900
Message-Id: <20180809181105.12856-12-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ensures that block allocation in sequential write required zones is always
done sequentially using an allocation pointer which is the zone write
pointer plus the number of blocks already allocated but not yet written.
For conventional zones, the legacy behavior is used.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 ctree.h       |  17 +++++
 extent-tree.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++
 transaction.c |  16 +++++
 3 files changed, 219 insertions(+)

diff --git a/ctree.h b/ctree.h
index 6d805ecd..5324f7b9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1062,15 +1062,32 @@ struct btrfs_space_info {
 	struct list_head list;
 };
 
+/* Block group allocation types */
+enum btrfs_alloc_type {
+
+	/* Regular first fit allocation */
+	BTRFS_ALLOC_FIT		= 0,
+
+	/*
+	 * Sequential allocation: this is for HMZONED mode and
+	 * will result in ignoring free space before a block
+	 * group allocation offset.
+	 */
+	BTRFS_ALLOC_SEQ		= 1,
+};
+
 struct btrfs_block_group_cache {
 	struct cache_extent cache;
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	struct btrfs_space_info *space_info;
 	struct btrfs_free_space_ctl *free_space_ctl;
+	enum btrfs_alloc_type alloc_type;
 	u64 bytes_super;
 	u64 pinned;
 	u64 flags;
+	u64 alloc_offset;
+	u64 write_offset;
 	int cached;
 	int ro;
 };
diff --git a/extent-tree.c b/extent-tree.c
index 5d49af5a..01660864 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -256,6 +256,14 @@ again:
 	if (cache->ro || !block_group_bits(cache, data))
 		goto new_group;
 
+	if (cache->alloc_type == BTRFS_ALLOC_SEQ) {
+		if (cache->key.offset - cache->alloc_offset < num)
+			goto new_group;
+		*start_ret = cache->key.objectid + cache->alloc_offset;
+		cache->alloc_offset += num;
+		return 0;
+	}
+
 	while(1) {
 		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
 					    last, &start, &end, EXTENT_DIRTY);
@@ -282,6 +290,7 @@ out:
 			(unsigned long long)search_start);
 		return -ENOENT;
 	}
+	printf("nospace\n");
 	return -ENOSPC;
 
 new_group:
@@ -3143,6 +3152,176 @@ error:
 	return ret;
 }
 
+#ifdef BTRFS_ZONED
+static int
+btrfs_get_block_group_alloc_offset(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_device *device;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	u64 logical = cache->key.objectid;
+	u64 length = cache->key.offset;
+	u64 physical = 0;
+	int ret = 0;
+	int i;
+	u64 zone_size = fs_info->fs_devices->zone_size;
+	u64 *alloc_offsets = NULL;
+
+	if (!btrfs_fs_incompat(fs_info, HMZONED))
+		return 0;
+
+	/* Sanity check */
+	if (!IS_ALIGNED(length, zone_size)) {
+		fprintf(stderr, "unaligned block group at %llu", logical);
+		return -EIO;
+	}
+
+	/* Get the chunk mapping */
+	ce = search_cache_extent(&map_tree->cache_tree, logical);
+	if (!ce) {
+		fprintf(stderr, "failed to find block group at %llu", logical);
+		return -ENOENT;
+	}
+	map = container_of(ce, struct map_lookup, ce);
+
+	/*
+	 * Get the zone type: if the group is mapped to a non-sequential zone,
+	 * there is no need for the allocation offset (fit allocation is OK).
+	 */
+	device = map->stripes[0].dev;
+	physical = map->stripes[0].physical;
+	if (!zone_is_random_write(&device->zinfo, physical))
+		cache->alloc_type = BTRFS_ALLOC_SEQ;
+
+	/* check block group mapping */
+	alloc_offsets = calloc(map->num_stripes, sizeof(*alloc_offsets));
+	for (i = 0; i < map->num_stripes; i++) {
+		int is_sequential;
+		struct blk_zone zone;
+
+		device = map->stripes[i].dev;
+		physical = map->stripes[i].physical;
+
+		is_sequential = !zone_is_random_write(&device->zinfo, physical);
+		if ((is_sequential && cache->alloc_type != BTRFS_ALLOC_SEQ) ||
+		    (!is_sequential && cache->alloc_type == BTRFS_ALLOC_SEQ)) {
+			fprintf(stderr,
+				"found block group of mixed zone types");
+			ret = -EIO;
+			goto out;
+		}
+
+		if (!is_sequential)
+			continue;
+
+		WARN_ON(!IS_ALIGNED(physical, zone_size));
+		zone = device->zinfo.zones[physical / zone_size];
+
+		/*
+		 * The group is mapped to a sequential zone. Get the zone write
+		 * pointer to determine the allocation offset within the zone.
+		 */
+		switch (zone.cond) {
+		case BLK_ZONE_COND_OFFLINE:
+		case BLK_ZONE_COND_READONLY:
+			fprintf(stderr, "Offline/readonly zone %llu",
+				physical / fs_info->fs_devices->zone_size);
+			ret = -EIO;
+			goto out;
+		case BLK_ZONE_COND_EMPTY:
+			alloc_offsets[i] = 0;
+			break;
+		case BLK_ZONE_COND_FULL:
+			alloc_offsets[i] = zone_size;
+			break;
+		default:
+			/* Partially used zone */
+			alloc_offsets[i] = ((zone.wp - zone.start) << 9);
+			break;
+		}
+	}
+
+	if (cache->alloc_type != BTRFS_ALLOC_SEQ)
+		goto out;
+
+	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* single */
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID1:
+		for (i = 1; i < map->num_stripes; i++) {
+			if (alloc_offsets[i] != alloc_offsets[0]) {
+				fprintf(stderr,
+					"zones' write pointers mismatch\n");
+				ret = -EIO;
+				goto out;
+			}
+		}
+		cache->alloc_offset = alloc_offsets[0];
+		break;
+	case BTRFS_BLOCK_GROUP_RAID0:
+		cache->alloc_offset = alloc_offsets[0];
+		for (i = 1; i < map->num_stripes; i++) {
+			cache->alloc_offset += alloc_offsets[i];
+			if (alloc_offsets[0] < alloc_offsets[i]) {
+				fprintf(stderr,
+					"zones' write pointers mismatch\n");
+				ret = -EIO;
+				goto out;
+			}
+		}
+		break;
+	case BTRFS_BLOCK_GROUP_RAID10:
+		cache->alloc_offset = 0;
+		for (i = 0; i < map->num_stripes / map->sub_stripes; i++) {
+			int j;
+			int base;
+
+			base = i*map->sub_stripes;
+			for (j = 1; j < map->sub_stripes; j++) {
+				if (alloc_offsets[base] !=
+					alloc_offsets[base+j]) {
+					fprintf(stderr,
+						"zones' write pointer mismatch\n");
+					ret = -EIO;
+					goto out;
+				}
+			}
+
+			if (alloc_offsets[0] < alloc_offsets[base]) {
+				fprintf(stderr,
+					"zones' write pointer mismatch\n");
+				ret = -EIO;
+				goto out;
+			}
+			cache->alloc_offset += alloc_offsets[base];
+		}
+		break;
+	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_RAID6:
+		/* RAID5/6 is not supported yet */
+	default:
+		fprintf(stderr, "Unsupported profile %llu\n",
+			map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		ret = -EINVAL;
+		goto out;
+	}
+
+out:
+	cache->write_offset = cache->alloc_offset;
+	free(alloc_offsets);
+	return ret;
+}
+#else
+static int
+btrfs_get_block_group_alloc_offset(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_group_cache *cache)
+{
+	return 0;
+}
+#endif
+
 int btrfs_read_block_groups(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -3226,6 +3405,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		BUG_ON(ret);
 		cache->space_info = space_info;
 
+		ret = btrfs_get_block_group_alloc_offset(info, cache);
+		if (ret)
+			goto error;
+
 		/* use EXTENT_LOCKED to prevent merging */
 		set_extent_bits(block_group_cache, found_key.objectid,
 				found_key.objectid + found_key.offset - 1,
@@ -3255,6 +3438,9 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 
+	ret = btrfs_get_block_group_alloc_offset(fs_info, cache);
+	BUG_ON(ret);
+
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	btrfs_set_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item,
diff --git a/transaction.c b/transaction.c
index ecafbb15..0e49b8b7 100644
--- a/transaction.c
+++ b/transaction.c
@@ -115,16 +115,32 @@ int __commit_transaction(struct btrfs_trans_handle *trans,
 {
 	u64 start;
 	u64 end;
+	u64 next = 0;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *eb;
 	struct extent_io_tree *tree = &fs_info->extent_cache;
+	struct btrfs_block_group_cache *bg = NULL;
 	int ret;
 
 	while(1) {
+again:
 		ret = find_first_extent_bit(tree, 0, &start, &end,
 					    EXTENT_DIRTY);
 		if (ret)
 			break;
+		bg = btrfs_lookup_first_block_group(fs_info, start);
+		BUG_ON(!bg);
+		if (bg->alloc_type == BTRFS_ALLOC_SEQ &&
+		    bg->key.objectid + bg->write_offset < start) {
+			next = bg->key.objectid + bg->write_offset;
+			BUG_ON(next + fs_info->nodesize > start);
+			eb = btrfs_find_create_tree_block(fs_info, next);
+			btrfs_mark_buffer_dirty(eb);
+			free_extent_buffer(eb);
+			goto again;
+		}
+		if (bg->alloc_type == BTRFS_ALLOC_SEQ)
+			bg->write_offset += (end + 1 - start);
 		while(start <= end) {
 			eb = find_first_extent_buffer(tree, start);
 			BUG_ON(!eb || eb->start != start);
-- 
2.18.0

