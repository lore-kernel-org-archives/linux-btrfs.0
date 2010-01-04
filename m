From: jim owens <jowens@hp.com>
Subject: [RFC 03/12 RESEND PATCH] Btrfs: Reorder __btrfs_map_block to make
 code more efficient.
Date: Mon, 04 Jan 2010 16:12:55 -0500
Message-ID: <4B4259D7.3000701@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Allocate multi structure only after we know the correct size
and do not do unneeded steps when we are only returning length.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/volumes.c |   65 +++++++++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5af76fc..e6599ef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2625,26 +2625,12 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
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
@@ -2663,27 +2649,6 @@ again:
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
@@ -2711,6 +2676,18 @@ again:
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
@@ -2755,6 +2732,17 @@ again:
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
@@ -2774,11 +2762,6 @@ again:
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
1.5.6.3
