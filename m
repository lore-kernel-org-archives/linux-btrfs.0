From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 04/18] Btrfs: Reorder __btrfs_map_block to make code more
 efficient.
Date: Sun, 21 Mar 2010 23:21:54 -0400
Message-ID: <4BA6E252.2000805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Allocate multi structure only after we know the correct size
and do not do unneeded steps when we are only returning length.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/volumes.c |   65 +++++++++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e6c173..39c3299 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2637,26 +2637,12 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_nr;
-	int stripes_allocated = 8;
-	int stripes_required = 1;
 	int stripe_index;
 	int i;
 	int num_stripes;
-	int max_errors = 0;
+	int max_errors;
 	struct btrfs_multi_bio *multi = NULL;
 
-	if (multi_ret && !(rw & (1 << BIO_RW)))
-		stripes_allocated = 1;
-again:
-	if (multi_ret) {
-		multi = kzalloc(btrfs_multi_bio_size(stripes_allocated),
-				GFP_NOFS);
-		if (!multi)
-			return -ENOMEM;
-
-		atomic_set(&multi->error, 0);
-	}
-
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
@@ -2677,27 +2663,6 @@ again:
 	map = (struct map_lookup *)em->bdev;
 	offset = logical - em->start;
 
-	if (mirror_num > map->num_stripes)
-		mirror_num = 0;
-
-	/* if our multi bio struct is too small, back off and try again */
-	if (rw & (1 << BIO_RW)) {
-		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
-				 BTRFS_BLOCK_GROUP_DUP)) {
-			stripes_required = map->num_stripes;
-			max_errors = 1;
-		} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
-			stripes_required = map->sub_stripes;
-			max_errors = 1;
-		}
-	}
-	if (multi_ret && (rw & (1 << BIO_RW)) &&
-	    stripes_allocated < stripes_required) {
-		stripes_allocated = map->num_stripes;
-		free_extent_map(em);
-		kfree(multi);
-		goto again;
-	}
 	stripe_nr = offset;
 	/*
 	 * stripe_nr counts the total number of stripes we have to stride
@@ -2725,6 +2690,18 @@ again:
 	if (!multi_ret && !unplug_page)
 		goto out;
 
+	if (mirror_num > map->num_stripes)
+		mirror_num = 0;
+
+	max_errors = 0;
+	if (rw & (1 << BIO_RW)) {
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				 BTRFS_BLOCK_GROUP_DUP))
+			max_errors = 1;
+		else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
+			max_errors = 1;
+	}
+
 	num_stripes = 1;
 	stripe_index = 0;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
@@ -2769,6 +2746,17 @@ again:
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
+	if (multi_ret) {
+		multi = kzalloc(btrfs_multi_bio_size(num_stripes), GFP_NOFS);
+		if (!multi)
+			return -ENOMEM;
+		*multi_ret = multi;
+
+		atomic_set(&multi->error, 0);
+		multi->num_stripes = num_stripes;
+		multi->max_errors = max_errors;
+	}
+
 	for (i = 0; i < num_stripes; i++) {
 		if (unplug_page) {
 			struct btrfs_device *device;
@@ -2788,11 +2776,6 @@ again:
 		}
 		stripe_index++;
 	}
-	if (multi_ret) {
-		*multi_ret = multi;
-		multi->num_stripes = num_stripes;
-		multi->max_errors = max_errors;
-	}
 out:
 	free_extent_map(em);
 	return 0;
-- 
1.6.3.3
