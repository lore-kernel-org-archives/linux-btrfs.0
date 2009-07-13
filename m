From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: A start at RAID[56] support.
Date: Mon, 13 Jul 2009 10:30:28 +0100
Message-ID: <1247477428.19180.28.camel@macbook.infradead.org>
References: <1247323186.17045.15.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247323186.17045.15.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-07-11 at 15:39 +0100, David Woodhouse wrote:
> This is a preliminary attempt to add RAID5 and RAID6 support.
> 
> So far it doesn't attempt to write or read the parity blocks -- it
> just
> lays the data blocks out as we want them, so it's effectively just a
> complex and wasteful kind of RAID0.
> 
> The next step is to make btrfs_map_bio() do the right thing:
>  - Satisfy read requests for mirrors #2 and #3 by recreating data from
>    RAID5 parity or RAID6 error correction stripe respectively.
>  - Write out parity and RAID6 blocks appropriately when data writes
>    happen.

Actually, the next step is to tweak __btrfs_map_block() a bit more to
let it return information about the whole stripe-set, so that
btrfs_map_bio() _can_ do what we say above...

So rather than just mapping the requested address as if it's RAID0, we
(where appropriate) return information about the _entire_ disk set in
the btrfs_multi_bio, with an auxiliary array giving the _logical_ offset
corresponding to each physical stripe in the referenced set (with
special values for the P and Q stripes).

We do this for all writes, and for reads where mirror_num > 1 (i.e. when
we're being asked to rebuild it from parity, rather than reading the
original data blocks).

  git://, http://git.infradead.org/users/dwmw2/btrfs-raid56.git

commit ed90c58ba7c60555af4b8c00a104c7d71f6db6d2
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Sun Jul 12 11:15:22 2009 +0100

    Btrfs: Let btrfs_map_block() return full stripe information for RAID[56]
    
    ... in the cases where it's necessary -- which is for a write, or for a
    parity recovery attempt. We'll let btrfs_map_bio() do the rest.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3b231ef..55facd3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -62,6 +62,11 @@ static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 
+#define RAID5_P_STRIPE ((u64)-1)
+#define RAID6_Q_STRIPE ((u64)-2)
+
+#define is_parity_stripe(x) ( ((x) == RAID5_P_STRIPE) || ((x) == RAID6_Q_STRIPE) )
+
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -2614,7 +2619,8 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 			     u64 logical, u64 *length,
 			     struct btrfs_multi_bio **multi_ret,
-			     int mirror_num, struct page *unplug_page)
+			     int mirror_num, struct page *unplug_page,
+			     u64 **raid_map_ret)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -2622,6 +2628,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_nr;
+	u64 *raid_map = NULL;
 	int stripes_allocated = 8;
 	int stripes_required = 1;
 	int stripe_index;
@@ -2674,9 +2681,24 @@ again:
 			max_errors = 1;
 		}
 	}
-	if (multi_ret && (rw & (1 << BIO_RW)) &&
-	    stripes_allocated < stripes_required) {
-		stripes_allocated = map->num_stripes;
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)
+	    && multi_ret && (rw & (1 << BIO_RW) || mirror_num > 1) && raid_map_ret) {
+		    /* RAID[56] write or recovery. Return all stripes */
+		    stripes_required = map->num_stripes;
+		    max_errors = nr_parity_stripes(map);
+
+		    /* Only allocate the map if we've already got a large enough multi_ret */
+		    if (stripes_allocated >= stripes_required) {
+			    raid_map = kmalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
+			    if (!raid_map) {
+				    free_extent_map(em);
+				    kfree(multi);
+				    return -ENOMEM;
+			    }
+		    }
+	}
+	if (multi_ret && stripes_allocated < stripes_required) {
+		stripes_allocated = stripes_required;
 		free_extent_map(em);
 		kfree(multi);
 		goto again;
@@ -2749,18 +2771,43 @@ again:
 
 		stripe_index = do_div(stripe_nr, nr_data_stripes(map));
 
-		/*
-		 * Mirror #0 or #1 means the original data block.
-		 * Mirror #2 is RAID5 parity block.
-		 * Mirror #3 is RAID6 Q block.
-		 */
-		if (mirror_num > 1)
-			stripe_index = nr_data_stripes(map) + mirror_num - 2;
-
-		/* We distribute the parity blocks across stripes */
-		tmp = stripe_nr + stripe_index;
-		stripe_index = do_div(tmp, map->num_stripes);
-		
+		if (unplug_page) {
+			stripe_index = 0;
+			num_stripes = map->num_stripes;
+		} else if (raid_map) {
+			int i, rot;
+
+			/* Work out the disk rotation on this stripe-set */
+			tmp = stripe_nr;
+			rot = do_div(tmp, map->num_stripes);
+
+			/* Fill in the logical address of each stripe */
+			tmp = stripe_nr * nr_data_stripes(map);
+			for (i = 0; i < nr_data_stripes(map); i++)
+				raid_map[(i+rot) % map->num_stripes] =
+					em->start + (tmp + i) * map->stripe_len;
+
+			raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
+			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+				raid_map[(i+rot+1) % map->num_stripes] = RAID6_Q_STRIPE;
+
+			*length = map->stripe_len;
+			stripe_index = 0;
+			stripe_offset = 0;
+			num_stripes = map->num_stripes;
+		} else {
+			/*
+			 * Mirror #0 or #1 means the original data block.
+			 * Mirror #2 is RAID5 parity block.
+			 * Mirror #3 is RAID6 Q block.
+			 */
+			if (mirror_num > 1)
+				stripe_index = nr_data_stripes(map) + mirror_num - 2;
+				
+			/* We distribute the parity blocks across stripes */
+			tmp = stripe_nr + stripe_index;
+			stripe_index = do_div(tmp, map->num_stripes);
+		}
 	} else {
 		/*
 		 * after this do_div call, stripe_nr is the number of stripes
@@ -2795,6 +2842,8 @@ again:
 		multi->num_stripes = num_stripes;
 		multi->max_errors = max_errors;
 	}
+	if (raid_map_ret)
+		*raid_map_ret = raid_map;
 out:
 	free_extent_map(em);
 	return 0;
@@ -2805,7 +2854,7 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      struct btrfs_multi_bio **multi_ret, int mirror_num)
 {
 	return __btrfs_map_block(map_tree, rw, logical, length, multi_ret,
-				 mirror_num, NULL);
+				 mirror_num, NULL, NULL);
 }
 
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
@@ -2889,7 +2938,7 @@ int btrfs_unplug_page(struct btrfs_mapping_tree *map_tree,
 {
 	u64 length = PAGE_CACHE_SIZE;
 	return __btrfs_map_block(map_tree, READ, logical, &length,
-				 NULL, 0, page);
+				 NULL, 0, page, NULL);
 }
 
 static void end_bio_multi_stripe(struct bio *bio, int err)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

