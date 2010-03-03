From: jim owens <owens6336@gmail.com>
Subject: [PATCH V2] Btrfs: split btrfs_map_block into two parts for direct
 I/O.
Date: Wed, 03 Mar 2010 12:23:25 -0500
Message-ID: <4B8E9B0D.2070904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The part of btrfs_map_block() that decodes the extent map and
rw/logical/length/mirror parameters is split into a routine
btrfs_map_to_stripe() so direct I/O can build multiple bios
with one lookup_extent_mapping().

The part of btrfs_map_block() that does lookup_extent_mapping()
and optional creation of the btrfs_multi_bio struct now calls
btrfs_map_to_stripe().

Signed-off-by: jim owens <jowens@hp.com>
Signed-off-by: jim owens <jim6336@gmail.com>
---

V2 fixes long line checkpatch warning

 fs/btrfs/volumes.c |   85 +++++++++++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h |   10 ++++++
 2 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 98c0924..ee66267 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2619,33 +2619,16 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 	return optimal;
 }
 
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-			     u64 logical, u64 *length,
-			     struct btrfs_multi_bio **multi_ret,
-			     int mirror_num)
+void btrfs_map_to_stripe(struct extent_map *em, int rw, int mirror_num,
+			u64 logical, u64 *length,
+			struct btrfs_stripe_info *stripe_info)
 {
-	struct extent_map *em;
 	struct map_lookup *map;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_nr;
 	int stripe_index;
-	int i;
 	int num_stripes;
-	int max_errors;
-	struct btrfs_multi_bio *multi;
-
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, logical, *length);
-	read_unlock(&em_tree->lock);
-
-	if (!em) {
-		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
-		       (unsigned long long)logical,
-		       (unsigned long long)*length);
-		BUG();
-	}
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = (struct map_lookup *)em->bdev;
@@ -2675,19 +2658,19 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		*length = min(*length, em->len - offset);
 	}
 
-	if (!multi_ret)
-		goto out;
+	if (!stripe_info)
+		return;
 
 	if (mirror_num > map->num_stripes)
 		mirror_num = 0;
 
-	max_errors = 0;
+	stripe_info->max_errors = 0;
 	if (rw & (1 << BIO_RW)) {
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 				 BTRFS_BLOCK_GROUP_DUP))
-			max_errors = 1;
+			stripe_info->max_errors = 1;
 		else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
-			max_errors = 1;
+			stripe_info->max_errors = 1;
 	}
 
 	num_stripes = 1;
@@ -2734,22 +2717,58 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
-	multi = kzalloc(btrfs_multi_bio_size(num_stripes), GFP_NOFS);
+	stripe_info->num_stripes = num_stripes;
+	stripe_info->stripe_index = stripe_index;
+	stripe_info->phys_offset = stripe_offset + stripe_nr * map->stripe_len;
+}
+
+int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+			u64 logical, u64 *length,
+			struct btrfs_multi_bio **multi_ret, int mirror_num)
+{
+	struct extent_map *em;
+	struct map_lookup *map;
+	struct extent_map_tree *em_tree = &map_tree->map_tree;
+	struct btrfs_multi_bio *multi;
+	struct btrfs_stripe_info stripe_info;
+	int i;
+
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, logical, *length);
+	read_unlock(&em_tree->lock);
+
+	if (!em) {
+		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
+		       (unsigned long long)logical,
+		       (unsigned long long)*length);
+		BUG();
+	}
+
+	btrfs_map_to_stripe(em, rw, mirror_num, logical, length,
+				multi_ret ? &stripe_info : NULL);
+	if (!multi_ret)
+		goto out;
+
+	multi = kzalloc(btrfs_multi_bio_size(stripe_info.num_stripes),
+			GFP_NOFS);
 	if (!multi)
 		return -ENOMEM;
 	*multi_ret = multi;
 
 	atomic_set(&multi->error, 0);
-	multi->num_stripes = num_stripes;
-	multi->max_errors = max_errors;
+	multi->num_stripes = stripe_info.num_stripes;
+	multi->max_errors = stripe_info.max_errors;
 
-	for (i = 0; i < num_stripes; i++) {
+	map = (struct map_lookup *)em->bdev;
+	for (i = 0; i < stripe_info.num_stripes; i++) {
 		multi->stripes[i].physical =
-			map->stripes[stripe_index].physical +
-			stripe_offset + stripe_nr * map->stripe_len;
-		multi->stripes[i].dev = map->stripes[stripe_index].dev;
-		stripe_index++;
+			map->stripes[stripe_info.stripe_index].physical +
+			stripe_info.phys_offset;
+		multi->stripes[i].dev =
+			map->stripes[stripe_info.stripe_index].dev;
+		stripe_info.stripe_index++;
 	}
+
 out:
 	free_extent_map(em);
 	return 0;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d5aab74..76c4394 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -135,6 +135,13 @@ struct btrfs_multi_bio {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct btrfs_stripe_info {
+	int num_stripes;
+	int max_errors;
+	int stripe_index;
+	u64 phys_offset;
+};
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -142,6 +149,9 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
 			   u64 chunk_offset, u64 start, u64 num_bytes);
+void btrfs_map_to_stripe(struct extent_map *em, int rw, int mirror_num,
+			u64 logical, u64 *length,
+			struct btrfs_stripe_info *stripe_info);
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num);
-- 
1.6.3.3
