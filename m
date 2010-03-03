From: jim owens <owens6336@gmail.com>
Subject: [PATCH V2] Btrfs: remove dead code for unplugging pages.
Date: Wed, 03 Mar 2010 09:29:15 -0500
Message-ID: <4B8E723B.1080603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The code in btrfs_unplug_io_fn() to selectively unplug just the
stripes affected by a page had been previously disabled.  The
unneeded code for unplug_page in __btrfs_map_block made changes
for btrfs directio more difficult so I'm removing all of it.

Signed-off-by: jim owens <jowens@hp.com>
Signed-off-by: jim owens <jim6336@gmail.com>
---

V2 is only updated to apply against current btrfs-unstable

 fs/btrfs/disk-io.c |   62 ++--------------------------------------------
 fs/btrfs/volumes.c |   69 +++++++++++++---------------------------------------
 fs/btrfs/volumes.h |    2 -
 3 files changed, 20 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b59201..a205017 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1289,10 +1289,10 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 }
 
 /*
- * this unplugs every device on the box, and it is only used when page
- * is null
+ * this unplugs every device on the box, and yes that is ugly
+ * but there are currently no low cost alternatives
  */
-static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
+static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_info *info;
@@ -1308,62 +1308,6 @@ static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 	}
 }
 
-static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-	struct inode *inode;
-	struct extent_map_tree *em_tree;
-	struct extent_map *em;
-	struct address_space *mapping;
-	u64 offset;
-
-	/* the generic O_DIRECT read code does this */
-	if (1 || !page) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	/*
-	 * page->mapping may change at any time.  Get a consistent copy
-	 * and use that for everything below
-	 */
-	smp_mb();
-	mapping = page->mapping;
-	if (!mapping)
-		return;
-
-	inode = mapping->host;
-
-	/*
-	 * don't do the expensive searching for a small number of
-	 * devices
-	 */
-	if (BTRFS_I(inode)->root->fs_info->fs_devices->open_devices <= 2) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	offset = page_offset(page);
-
-	em_tree = &BTRFS_I(inode)->extent_tree;
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
-	read_unlock(&em_tree->lock);
-	if (!em) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		free_extent_map(em);
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-	offset = offset - em->start;
-	btrfs_unplug_page(&BTRFS_I(inode)->root->fs_info->mapping_tree,
-			  em->block_start + offset, page);
-	free_extent_map(em);
-}
-
 /*
  * If this fails, caller must call bdi_destroy() to get rid of the
  * bdi again.
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5e54c96..98c0924 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2619,10 +2619,10 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 	return optimal;
 }
 
-static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 			     u64 logical, u64 *length,
 			     struct btrfs_multi_bio **multi_ret,
-			     int mirror_num, struct page *unplug_page)
+			     int mirror_num)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -2634,17 +2634,12 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	int i;
 	int num_stripes;
 	int max_errors;
-	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_multi_bio *multi;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
 
-	if (!em && unplug_page) {
-		kfree(multi);
-		return 0;
-	}
-
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
 		       (unsigned long long)logical,
@@ -2680,7 +2675,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		*length = min(*length, em->len - offset);
 	}
 
-	if (!multi_ret && !unplug_page)
+	if (!multi_ret)
 		goto out;
 
 	if (mirror_num > map->num_stripes)
@@ -2698,7 +2693,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	num_stripes = 1;
 	stripe_index = 0;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (unplug_page || (rw & (1 << BIO_RW)))
+		if (rw & (1 << BIO_RW))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -2720,7 +2715,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		stripe_index = do_div(stripe_nr, factor);
 		stripe_index *= map->sub_stripes;
 
-		if (unplug_page || (rw & (1 << BIO_RW)))
+		if (rw & (1 << BIO_RW))
 			num_stripes = map->sub_stripes;
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
@@ -2739,34 +2734,20 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
-	if (multi_ret) {
-		multi = kzalloc(btrfs_multi_bio_size(num_stripes), GFP_NOFS);
-		if (!multi)
-			return -ENOMEM;
-		*multi_ret = multi;
+	multi = kzalloc(btrfs_multi_bio_size(num_stripes), GFP_NOFS);
+	if (!multi)
+		return -ENOMEM;
+	*multi_ret = multi;
 
-		atomic_set(&multi->error, 0);
-		multi->num_stripes = num_stripes;
-		multi->max_errors = max_errors;
-	}
+	atomic_set(&multi->error, 0);
+	multi->num_stripes = num_stripes;
+	multi->max_errors = max_errors;
 
 	for (i = 0; i < num_stripes; i++) {
-		if (unplug_page) {
-			struct btrfs_device *device;
-			struct backing_dev_info *bdi;
-
-			device = map->stripes[stripe_index].dev;
-			if (device->bdev) {
-				bdi = blk_get_backing_dev_info(device->bdev);
-				if (bdi->unplug_io_fn)
-					bdi->unplug_io_fn(bdi, unplug_page);
-			}
-		} else {
-			multi->stripes[i].physical =
-				map->stripes[stripe_index].physical +
-				stripe_offset + stripe_nr * map->stripe_len;
-			multi->stripes[i].dev = map->stripes[stripe_index].dev;
-		}
+		multi->stripes[i].physical =
+			map->stripes[stripe_index].physical +
+			stripe_offset + stripe_nr * map->stripe_len;
+		multi->stripes[i].dev = map->stripes[stripe_index].dev;
 		stripe_index++;
 	}
 out:
@@ -2774,14 +2755,6 @@ out:
 	return 0;
 }
 
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-		      u64 logical, u64 *length,
-		      struct btrfs_multi_bio **multi_ret, int mirror_num)
-{
-	return __btrfs_map_block(map_tree, rw, logical, length, multi_ret,
-				 mirror_num, NULL);
-}
-
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len)
@@ -2847,14 +2820,6 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
-int btrfs_unplug_page(struct btrfs_mapping_tree *map_tree,
-		      u64 logical, struct page *page)
-{
-	u64 length = PAGE_CACHE_SIZE;
-	return __btrfs_map_block(map_tree, READ, logical, &length,
-				 NULL, 0, page);
-}
-
 static void end_bio_multi_stripe(struct bio *bio, int err)
 {
 	struct btrfs_multi_bio *multi = bio->bi_private;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 31b0fab..d5aab74 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -169,8 +169,6 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
 int btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
-int btrfs_unplug_page(struct btrfs_mapping_tree *map_tree,
-		      u64 logical, struct page *page);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-- 
1.6.3.3
