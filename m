From: David Woodhouse <dwmw2@infradead.org>
Subject: RAID[56] with arbitrary numbers of "parity" stripes.
Date: Wed, 05 Aug 2009 21:04:25 +0100
Message-ID: <1249502665.23206.5.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We discussed using the top bits of the chunk type field field to store a
number of redundant disks -- so instead of RAID5, RAID6, etc., we end up
with a single 'RAID56' flag, and the amount of redundancy is stored
elsewhere.

This attempts it, but I hate it and don't really want to do it. The type
field is designed as a bitmask, and _used_ as a bitmask in a number of
places -- I think it's ugly and fragile to do it this way (and degraded
mounts aren't working for some reason I haven't chased down yet).

I'd much prefer to stick with the separate bit flags for RAID5 and RAID6
(and RAID7, RAID8, or whatever we want to call the versions with 3, 4,
or more redundant blocks). We have a 64-bit bitfield, after all -- we're
not exactly short of bits even once we start doing RAID50, RAID60,
etc...

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7326707..71dd726 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -655,8 +655,14 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
-#define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
-#define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
+#define BTRFS_BLOCK_GROUP_RAID56   (1 << 7)
+
+#define BTRFS_BLOCK_GROUP_USED_BITS 8
+/* For RAID5/RAID6, the top 8 bits indicate the number of spares
+   (1 for RAID5, 2 for RAID6, more once we get the arithmetic for it */
+#define BTRFS_BLOCK_GROUP_MASK     (((u64)1 << 56) - 1)
+
+#define BTRFS_RAID56_MAX_SPARES    2
 
 struct btrfs_block_group_item {
 	__le64 used;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0cbf28e..fff73c4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2611,20 +2611,30 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
 static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
+	u64 *avail = NULL;
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
 				   BTRFS_BLOCK_GROUP_RAID1 |
-				   BTRFS_BLOCK_GROUP_RAID5 |
-				   BTRFS_BLOCK_GROUP_RAID6 |
+				   BTRFS_BLOCK_GROUP_RAID56 |
 				   BTRFS_BLOCK_GROUP_RAID10 |
 				   BTRFS_BLOCK_GROUP_DUP);
 	if (extra_flags) {
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
-			fs_info->avail_data_alloc_bits |= extra_flags;
-		if (flags & BTRFS_BLOCK_GROUP_METADATA)
-			fs_info->avail_metadata_alloc_bits |= extra_flags;
-		if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-			fs_info->avail_system_alloc_bits |= extra_flags;
+			avail = &fs_info->avail_data_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_METADATA)
+			avail = &fs_info->avail_metadata_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			avail = &fs_info->avail_system_alloc_bits;
+		else BUG();
+
+		*avail |= extra_flags & BTRFS_BLOCK_GROUP_MASK;
 	}
+	if (avail && extra_flags & BTRFS_BLOCK_GROUP_RAID56) {
+		u64 nr_spares = flags >> 56;
+
+		if (nr_spares > *avail >> 56)
+			*avail = (*avail & BTRFS_BLOCK_GROUP_MASK) |
+				  nr_spares << 56;
+	}		
 }
 
 static void set_block_group_readonly(struct btrfs_block_group_cache *cache)
@@ -2643,27 +2653,27 @@ static void set_block_group_readonly(struct btrfs_block_group_cache *cache)
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices = root->fs_info->fs_devices->rw_devices;
+	u64 num_spares = flags >> 56;
 	u64 tmp;
 
 	/* First, mask out the RAID levels which aren't possible */
 	if (num_devices == 1)
 		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0 |
-			   BTRFS_BLOCK_GROUP_RAID5);
-	if (num_devices < 3)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID6;
+			   BTRFS_BLOCK_GROUP_RAID56);
 	if (num_devices < 4)
 		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
 
 	tmp = flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
-		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID5 |
-		       BTRFS_BLOCK_GROUP_RAID6 | BTRFS_BLOCK_GROUP_RAID10);
+		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID56 |
+		       BTRFS_BLOCK_GROUP_RAID10 | ~BTRFS_BLOCK_GROUP_MASK);
 	flags &= ~tmp;
 
-	if (tmp & BTRFS_BLOCK_GROUP_RAID6)
-		tmp = BTRFS_BLOCK_GROUP_RAID6;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID5)
-		tmp = BTRFS_BLOCK_GROUP_RAID5;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID10)
+	if (tmp & BTRFS_BLOCK_GROUP_RAID56) {
+		if (num_spares > num_devices - 1)
+			num_spares = num_devices - 1;
+		BUG_ON(!num_spares); 
+		tmp = BTRFS_BLOCK_GROUP_RAID56 | (num_spares << 56);
+	} else if (tmp & BTRFS_BLOCK_GROUP_RAID10)
 		tmp = BTRFS_BLOCK_GROUP_RAID10;
 	else if (tmp & BTRFS_BLOCK_GROUP_RAID1)
 		tmp = BTRFS_BLOCK_GROUP_RAID1;
@@ -2691,7 +2701,6 @@ static u64 btrfs_get_alloc_profile(struct btrfs_root *root, u64 data)
 			info->metadata_alloc_profile;
 		data = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
-
 	return btrfs_reduce_alloc_profile(root, data);
 }
 
@@ -3635,7 +3644,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
 				     u64 exclude_start, u64 exclude_nr,
-				     int data)
+				     u64 data)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -6774,8 +6783,7 @@ out:
 static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices;
-	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
-		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
+	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID56 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
 	num_devices = root->fs_info->fs_devices->rw_devices;
@@ -7284,6 +7292,47 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		key.objectid = found_key.objectid + found_key.offset;
 		btrfs_release_path(root, path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
+
+		if (!!(cache->flags & BTRFS_BLOCK_GROUP_DATA) +
+		    !!(cache->flags & BTRFS_BLOCK_GROUP_METADATA) +
+		    !!(cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) != 1) {
+			printk(KERN_ERR "btrfs block group has no storage type (%llx)\n",
+			       cache->flags);
+			kfree(cache);
+			ret = -EINVAL;
+			goto error;
+		}
+#if 1 /* Compat with old progs */
+		if (cache->flags & BTRFS_BLOCK_GROUP_RAID56) {
+			int num_spares = cache->flags >> 56;
+			if (!num_spares)
+				cache->flags |= 1ULL<<56;
+
+		}
+
+		if (cache->flags & (BTRFS_BLOCK_GROUP_RAID56 << 1)) {
+			cache->flags &= ~(BTRFS_BLOCK_GROUP_RAID56 << 1);
+			cache->flags |= BTRFS_BLOCK_GROUP_RAID56 | 2ULL<<56;
+		}
+#endif
+		if ((cache->flags & BTRFS_BLOCK_GROUP_MASK) >> BTRFS_BLOCK_GROUP_USED_BITS) {
+			printk(KERN_ERR "btrfs block group has unknown bits (%llx)\n",
+			       cache->flags);
+			kfree(cache);
+			ret = -EINVAL;
+			goto error;
+		}			
+		if (cache->flags & BTRFS_BLOCK_GROUP_RAID56) {
+			int num_spares = cache->flags >> 56;
+			if (!num_spares || num_spares > BTRFS_RAID56_MAX_SPARES) {
+				printk(KERN_ERR "btrfs RAID5/6 group has %d spares (flags %llx)\n",
+				       num_spares, cache->flags);
+				kfree(cache);
+				ret = -EINVAL;
+				goto error;
+			}
+		}
+
 		cache->sectorsize = root->sectorsize;
 
 		remove_sb_from_cache(root, cache);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 95babc1..28291cc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -45,12 +45,7 @@ struct map_lookup {
 
 static inline int nr_parity_stripes(struct map_lookup *map)
 {
-	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		return 1;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		return 2;
-	else 
-		return 0;
+	return map->type >> 56;
 }
 
 static inline int nr_data_stripes(struct map_lookup *map)
@@ -1176,19 +1171,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
-	    root->fs_info->fs_devices->rw_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid5\n");
-		ret = -EINVAL;
-		goto out;
-	}
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
-	    root->fs_info->fs_devices->rw_devices <= 3) {
-		printk(KERN_ERR "btrfs: unable to go below three "
-		       "devices on raid6\n");
-		ret = -EINVAL;
-		goto out;
+	if (all_avail & BTRFS_BLOCK_GROUP_RAID56) {
+		int required_devs = max(root->fs_info->avail_data_alloc_bits >> 56,
+					max(root->fs_info->avail_system_alloc_bits >> 56,
+					    root->fs_info->avail_metadata_alloc_bits >> 56));
+		if (root->fs_info->fs_devices->rw_devices <= required_devs + 1) {
+			printk(KERN_ERR "btrfs: unable to go below %d "
+			       "devices on raid5/raid6\n", required_devs + 1);
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	if (strcmp(device_path, "missing") == 0) {
@@ -2142,10 +2134,8 @@ static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
 		return calc_size;
 	else if (type & BTRFS_BLOCK_GROUP_RAID10)
 		return calc_size * (num_stripes / sub_stripes);
-	else if (type & BTRFS_BLOCK_GROUP_RAID5)
-		return calc_size * (num_stripes - 1);
-	else if (type & BTRFS_BLOCK_GROUP_RAID6)
-		return calc_size * (num_stripes - 2);
+	else if (type & BTRFS_BLOCK_GROUP_RAID56)
+		return calc_size * (num_stripes - (type >> 56));
 	else
 		return calc_size * num_stripes;
 }
@@ -2209,17 +2199,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		sub_stripes = 2;
 		min_stripes = 4;
 	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
-		num_stripes = fs_devices->rw_devices;
-		if (num_stripes < 2)
-			return -ENOSPC;
-		min_stripes = 2;
-	}
-	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
+	if (type & (BTRFS_BLOCK_GROUP_RAID56)) {
 		num_stripes = fs_devices->rw_devices;
-		if (num_stripes < 3)
+		min_stripes = (type >> 56) + 1;
+		if (num_stripes < min_stripes)
 			return -ENOSPC;
-		min_stripes = 3;
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
@@ -2609,10 +2593,8 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		ret = 2;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		ret = 3;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID56)
+		ret = nr_parity_stripes(map);
 	else
 		ret = 1;
 	free_extent_map(em);
@@ -2734,8 +2716,8 @@ again:
 			max_errors = 1;
 		}
 	}
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)
-	    && multi_ret && (rw & (1 << BIO_RW) || mirror_num > 1) && raid_map_ret) {
+	if (map->type & BTRFS_BLOCK_GROUP_RAID56 && multi_ret &&
+	    (rw & (1 << BIO_RW) || mirror_num > 1) && raid_map_ret) {
 		    /* RAID[56] write or recovery. Return all stripes */
 		    stripes_required = map->num_stripes;
 		    max_errors = nr_parity_stripes(map);
@@ -2770,8 +2752,7 @@ again:
 	stripe_offset = offset - stripe_offset;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
-			 BTRFS_BLOCK_GROUP_RAID10 |
+			 BTRFS_BLOCK_GROUP_RAID56 | BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
 		*length = min_t(u64, em->len - offset,
@@ -2818,8 +2799,7 @@ again:
 					      current->pid % map->sub_stripes);
 		}
 
-	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-				BTRFS_BLOCK_GROUP_RAID6)) {
+	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56) {
 		u64 tmp;
 
 		stripe_index = do_div(stripe_nr, nr_data_stripes(map));
@@ -2841,7 +2821,7 @@ again:
 					em->start + (tmp + i) * map->stripe_len;
 
 			raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
-			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+			if ((map->type >> 56) >= 2)
 				raid_map[(i+rot+1) % map->num_stripes] = RAID6_Q_STRIPE;
 
 			*length = map->stripe_len;
@@ -2940,8 +2920,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		do_div(length, map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
 		do_div(length, map->num_stripes);
-	else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			      BTRFS_BLOCK_GROUP_RAID6)) {
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID56) {
 		do_div(length, nr_data_stripes(map));
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

