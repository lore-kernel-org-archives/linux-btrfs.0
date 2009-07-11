From: David Woodhouse <dwmw2@infradead.org>
Subject: A start at RAID[56] support.
Date: Sat, 11 Jul 2009 15:39:46 +0100
Message-ID: <1247323186.17045.15.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a preliminary attempt to add RAID5 and RAID6 support.

So far it doesn't attempt to write or read the parity blocks -- it just
lays the data blocks out as we want them, so it's effectively just a
complex and wasteful kind of RAID0.

The next step is to make btrfs_map_bio() do the right thing:
 - Satisfy read requests for mirrors #2 and #3 by recreating data from
   RAID5 parity or RAID6 error correction stripe respectively.
 - Write out parity and RAID6 blocks appropriately when data writes
   happen.

The former is relatively easy; the latter is slightly more interesting.

Chris suggests that we can avoid read/modify/write cycles for the parity
blocks by ensuring that the file system always writes a full set of
stripes. So for a RAID5 of 4 disks with 64KiB stripe_len, that would be
a 192KiB minimum write size, for example.

I'm not entirely sure of the best way to do that -- can we set a minimum
allocation size for a chunk, and then maybe have it fall back to RAID1
(or a RAID5 chunk with smaller stripe_len) for smaller allocations if
they'd be too wasteful on the larger RAID5 chunks?

And how would we handle nodatacow?

I think I'm going to do a crappy r/m/w thing for now (in the knowledge
that the error correction stripes won't be powerfail-safe), and then we
can set about trying to render it unnecessary.

(Yes, I know I need to fix up btrfs_discard_extent() for RAID5 too -- it
doesn't discard the parity stripes, and I may want to make it avoid
discarding partial stripes for now, until we fix the above.)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 98a8738..40168d7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -653,6 +653,8 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+#define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
+#define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
 
 struct btrfs_block_group_item {
 	__le64 used;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d829ef3..fadec64 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2496,6 +2496,8 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
 				   BTRFS_BLOCK_GROUP_RAID1 |
+				   BTRFS_BLOCK_GROUP_RAID5 |
+				   BTRFS_BLOCK_GROUP_RAID6 |
 				   BTRFS_BLOCK_GROUP_RAID10 |
 				   BTRFS_BLOCK_GROUP_DUP);
 	if (extra_flags) {
@@ -2524,29 +2526,34 @@ static void set_block_group_readonly(struct btrfs_block_group_cache *cache)
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices = root->fs_info->fs_devices->rw_devices;
+	u64 tmp;
 
+	/* First, mask out the RAID levels which aren't possible */
 	if (num_devices == 1)
-		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0);
+		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0 |
+			   BTRFS_BLOCK_GROUP_RAID5);
+	if (num_devices < 3)
+		flags &= ~BTRFS_BLOCK_GROUP_RAID6;
 	if (num_devices < 4)
 		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
 
-	if ((flags & BTRFS_BLOCK_GROUP_DUP) &&
-	    (flags & (BTRFS_BLOCK_GROUP_RAID1 |
-		      BTRFS_BLOCK_GROUP_RAID10))) {
-		flags &= ~BTRFS_BLOCK_GROUP_DUP;
-	}
+	tmp = flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
+		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID5 |
+		       BTRFS_BLOCK_GROUP_RAID6 | BTRFS_BLOCK_GROUP_RAID10);
+	flags &= ~tmp;
 
-	if ((flags & BTRFS_BLOCK_GROUP_RAID1) &&
-	    (flags & BTRFS_BLOCK_GROUP_RAID10)) {
-		flags &= ~BTRFS_BLOCK_GROUP_RAID1;
-	}
+	if (tmp & BTRFS_BLOCK_GROUP_RAID6)
+		tmp = BTRFS_BLOCK_GROUP_RAID6;
+	else if (tmp & BTRFS_BLOCK_GROUP_RAID5)
+		tmp = BTRFS_BLOCK_GROUP_RAID5;
+	else if (tmp & BTRFS_BLOCK_GROUP_RAID10)
+		tmp = BTRFS_BLOCK_GROUP_RAID10;
+	else if (tmp & BTRFS_BLOCK_GROUP_RAID1)
+		tmp = BTRFS_BLOCK_GROUP_RAID1;
+	else if (tmp & BTRFS_BLOCK_GROUP_RAID0)
+		tmp = BTRFS_BLOCK_GROUP_RAID0;
 
-	if ((flags & BTRFS_BLOCK_GROUP_RAID0) &&
-	    ((flags & BTRFS_BLOCK_GROUP_RAID1) |
-	     (flags & BTRFS_BLOCK_GROUP_RAID10) |
-	     (flags & BTRFS_BLOCK_GROUP_DUP)))
-		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
-	return flags;
+	return flags | tmp;
 }
 
 static u64 btrfs_get_alloc_profile(struct btrfs_root *root, u64 data)
@@ -6548,6 +6555,7 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices;
 	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
+		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
 	num_devices = root->fs_info->fs_devices->rw_devices;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f1f10ea..3b231ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -42,6 +42,21 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+static inline int nr_parity_stripes(struct map_lookup *map)
+{
+	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
+		return 1;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+		return 2;
+	else 
+		return 0;
+}
+
+static inline int nr_data_stripes(struct map_lookup *map)
+{
+	return map->num_stripes - nr_parity_stripes(map);
+}
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
@@ -1140,6 +1155,21 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
+	    root->fs_info->fs_devices->rw_devices <= 2) {
+		printk(KERN_ERR "btrfs: unable to go below two "
+		       "devices on raid5\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
+	    root->fs_info->fs_devices->rw_devices <= 3) {
+		printk(KERN_ERR "btrfs: unable to go below three "
+		       "devices on raid6\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
@@ -2090,6 +2120,10 @@ static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
 		return calc_size;
 	else if (type & BTRFS_BLOCK_GROUP_RAID10)
 		return calc_size * (num_stripes / sub_stripes);
+	else if (type & BTRFS_BLOCK_GROUP_RAID5)
+		return calc_size * (num_stripes - 1);
+	else if (type & BTRFS_BLOCK_GROUP_RAID6)
+		return calc_size * (num_stripes - 2);
 	else
 		return calc_size * num_stripes;
 }
@@ -2153,6 +2187,18 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		sub_stripes = 2;
 		min_stripes = 4;
 	}
+	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
+		num_stripes = fs_devices->rw_devices;
+		if (num_stripes < 2)
+			return -ENOSPC;
+		min_stripes = 2;
+	}
+	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
+		num_stripes = fs_devices->rw_devices;
+		if (num_stripes < 3)
+			return -ENOSPC;
+		min_stripes = 3;
+	}
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_chunk_size = 10 * calc_size;
@@ -2539,6 +2585,10 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
+		ret = 2;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+		ret = 3;
 	else
 		ret = 1;
 	free_extent_map(em);
@@ -2645,6 +2695,7 @@ again:
 	stripe_offset = offset - stripe_offset;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 			 BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
@@ -2691,6 +2742,25 @@ again:
 					      map->sub_stripes, stripe_index +
 					      current->pid % map->sub_stripes);
 		}
+
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+		u64 tmp;
+
+		stripe_index = do_div(stripe_nr, nr_data_stripes(map));
+
+		/*
+		 * Mirror #0 or #1 means the original data block.
+		 * Mirror #2 is RAID5 parity block.
+		 * Mirror #3 is RAID6 Q block.
+		 */
+		if (mirror_num > 1)
+			stripe_index = nr_data_stripes(map) + mirror_num - 2;
+
+		/* We distribute the parity blocks across stripes */
+		tmp = stripe_nr + stripe_index;
+		stripe_index = do_div(tmp, map->num_stripes);
+		
 	} else {
 		/*
 		 * after this do_div call, stripe_nr is the number of stripes
@@ -2749,6 +2819,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 bytenr;
 	u64 length;
 	u64 stripe_nr;
+	u64 rmap_len;
 	int i, j, nr = 0;
 
 	spin_lock(&em_tree->lock);
@@ -2759,10 +2830,17 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	map = (struct map_lookup *)em->bdev;
 
 	length = em->len;
+	rmap_len = map->stripe_len;
+
 	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		do_div(length, map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
 		do_div(length, map->num_stripes);
+	else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+			      BTRFS_BLOCK_GROUP_RAID6)) {
+		do_div(length, nr_data_stripes(map));
+		rmap_len = map->stripe_len * nr_data_stripes(map);
+	}
 
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
 	BUG_ON(!buf);
@@ -2782,8 +2860,11 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 			do_div(stripe_nr, map->sub_stripes);
 		} else if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 			stripe_nr = stripe_nr * map->num_stripes + i;
-		}
-		bytenr = chunk_start + stripe_nr * map->stripe_len;
+		} /* else if RAID[56], multiply by nr_data_stripes().
+		   * Alternatively, just use rmap_len below instead of
+		   * map->stripe_len */
+
+		bytenr = chunk_start + stripe_nr * rmap_len;
 		WARN_ON(nr >= map->num_stripes);
 		for (j = 0; j < nr; j++) {
 			if (buf[j] == bytenr)
@@ -2797,7 +2878,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 
 	*logical = buf;
 	*naddrs = nr;
-	*stripe_len = map->stripe_len;
+	*stripe_len = rmap_len;
 
 	free_extent_map(em);
 	return 0;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

