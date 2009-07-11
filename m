From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: A start at RAID[56] support.
Date: Sat, 11 Jul 2009 15:40:41 +0100
Message-ID: <1247323241.17045.16.camel@macbook.infradead.org>
References: <1247323186.17045.15.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247323186.17045.15.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-07-11 at 15:39 +0100, David Woodhouse wrote:
> This is a preliminary attempt to add RAID5 and RAID6 support.

Matching btrfs-progs patch...

diff --git a/ctree.h b/ctree.h
index a9062ea..5b3c690 100644
--- a/ctree.h
+++ b/ctree.h
@@ -640,6 +640,8 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+#define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
+#define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
 
 struct btrfs_block_group_item {
 	__le64 used;
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..77cfcb5 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1775,6 +1775,8 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	u64 extra_flags = flags & (BTRFS_BLOCK_GROUP_RAID0 |
 				   BTRFS_BLOCK_GROUP_RAID1 |
+				   BTRFS_BLOCK_GROUP_RAID5 |
+				   BTRFS_BLOCK_GROUP_RAID6 |
 				   BTRFS_BLOCK_GROUP_DUP);
 	if (extra_flags) {
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..aefe1af 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -203,16 +203,22 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      u64 metadata_profile)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
-	u64 allowed;
+	u64 allowed = 0;
 	int ret;
 
-	if (num_devices == 1)
-		allowed = BTRFS_BLOCK_GROUP_DUP;
-	else if (num_devices >= 4) {
-		allowed = BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			BTRFS_BLOCK_GROUP_RAID10;
-	} else
-		allowed = BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1;
+	switch (num_devices) {
+	default:
+	case 4:
+		allowed |= BTRFS_BLOCK_GROUP_RAID10;
+	case 3:
+		allowed |= BTRFS_BLOCK_GROUP_RAID6;
+	case 2:
+		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			BTRFS_BLOCK_GROUP_RAID5;
+		break;
+	case 1:
+		allowed |= BTRFS_BLOCK_GROUP_DUP;
+	}
 
 	if (allowed & metadata_profile) {
 		ret = create_one_raid_group(trans, root,
@@ -292,6 +298,10 @@ static u64 parse_profile(char *s)
 		return BTRFS_BLOCK_GROUP_RAID0;
 	} else if (strcmp(s, "raid1") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP;
+	} else if (strcmp(s, "raid5") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID5;
+	} else if (strcmp(s, "raid6") == 0) {
+		return BTRFS_BLOCK_GROUP_RAID6;
 	} else if (strcmp(s, "raid10") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_DUP;
 	} else if (strcmp(s, "single") == 0) {
diff --git a/volumes.c b/volumes.c
index 7671855..90090b0 100644
--- a/volumes.c
+++ b/volumes.c
@@ -47,6 +47,21 @@ struct map_lookup {
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
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -623,6 +638,10 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
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
@@ -664,6 +683,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	if (type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+		    BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 		    BTRFS_BLOCK_GROUP_RAID10 |
 		    BTRFS_BLOCK_GROUP_DUP)) {
 		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
@@ -703,6 +723,18 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		sub_stripes = 2;
 		min_stripes = 4;
 	}
+	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
+		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		if (num_stripes < 2)
+			return -ENOSPC;
+		min_stripes = 2;
+	}
+	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
+		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		if (num_stripes < 3)
+			return -ENOSPC;
+		min_stripes = 3;
+	}
 
 	/* we don't want a chunk larger than 10% of the FS */
 	percent_max = div_factor(btrfs_super_total_bytes(&info->super_copy), 1);
@@ -879,6 +911,10 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
+		ret = 2;
+	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+		ret = 3;
 	else
 		ret = 1;
 	return ret;
@@ -894,6 +930,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	u64 bytenr;
 	u64 length;
 	u64 stripe_nr;
+	u64 rmap_len;
 	int i, j, nr = 0;
 
 	ce = find_first_cache_extent(&map_tree->cache_tree, chunk_start);
@@ -901,10 +938,16 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	map = container_of(ce, struct map_lookup, ce);
 
 	length = ce->size;
+	rmap_len = map->stripe_len;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		length = ce->size / (map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
 		length = ce->size / map->num_stripes;
+	else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+			      BTRFS_BLOCK_GROUP_RAID6)) {
+		length = ce->size / nr_data_stripes(map);
+		rmap_len = map->stripe_len * nr_data_stripes(map);
+	}
 
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
 
@@ -923,8 +966,11 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 				    map->sub_stripes;
 		} else if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 			stripe_nr = stripe_nr * map->num_stripes + i;
-		}
-		bytenr = ce->start + stripe_nr * map->stripe_len;
+		} /* else if RAID[56], multiply by nr_data_stripes().
+		   * Alternatively, just use rmap_len below instead of
+		   * map->stripe_len */
+
+		bytenr = ce->start + stripe_nr * rmap_len;
 		for (j = 0; j < nr; j++) {
 			if (buf[j] == bytenr)
 				break;
@@ -935,7 +981,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 
 	*logical = buf;
 	*naddrs = nr;
-	*stripe_len = map->stripe_len;
+	*stripe_len = rmap_len;
 
 	return 0;
 }
@@ -1001,6 +1047,7 @@ again:
 	stripe_offset = offset - stripe_offset;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			 BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
 			 BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
@@ -1041,6 +1088,23 @@ again:
 			multi->num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+
+		stripe_index = stripe_nr % nr_data_stripes(map);
+		stripe_nr = stripe_nr / nr_data_stripes(map);
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
+		stripe_index = (stripe_nr + stripe_index) & map->num_stripes;
+
 	} else {
 		/*
 		 * after this do_div call, stripe_nr is the number of stripes

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

