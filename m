Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34380 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752593AbdBRB3Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:25 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/7] Btrfs: create a helper for getting chunk map
Date: Fri, 17 Feb 2017 17:28:15 -0800
Message-Id: <1487381301-865-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have similar code here and there, this merges them into a helper.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c |   3 +-
 fs/btrfs/volumes.c   | 163 +++++++++++++++++----------------------------------
 fs/btrfs/volumes.h   |   2 +-
 3 files changed, 57 insertions(+), 111 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a..609ece1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2007,14 +2007,13 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	u64 map_length = 0;
 	u64 sector;
 	struct btrfs_bio *bbio = NULL;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	int ret;
 
 	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
 	BUG_ON(!mirror_num);
 
 	/* we can't repair anything in raid56 yet */
-	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num))
+	if (btrfs_is_parity_mirror(fs_info, logical, length, mirror_num))
 		return 0;
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3c3c69c..c52b0fe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2794,10 +2794,38 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
+					u64 logical, u64 length)
+{
+	struct extent_map_tree *em_tree;
+	struct extent_map *em;
+
+	em_tree = &fs_info->mapping_tree.map_tree;
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, logical, length);
+	read_unlock(&em_tree->lock);
+
+	if (!em) {
+		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
+			logical, length);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (em->start > logical || em->start + em->len < logical) {
+		btrfs_crit(fs_info,
+			   "found a bad mapping, wanted %llu, found %llu-%llu",
+			   logical, em->start, em->start + em->len);
+		free_extent_map(em);
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* callers are responsible for dropping em's ref. */
+	return em;
+}
+
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
-	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
 	u64 dev_extent_len = 0;
@@ -2805,23 +2833,15 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
-	em_tree = &fs_info->mapping_tree.map_tree;
-
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
-	read_unlock(&em_tree->lock);
-
-	if (!em || em->start > chunk_offset ||
-	    em->start + em->len < chunk_offset) {
+	em = get_chunk_map(fs_info, chunk_offset, 1);
+	if (IS_ERR(em)) {
 		/*
 		 * This is a logic error, but we don't want to just rely on the
 		 * user having built with ASSERT enabled, so if ASSERT doesn't
 		 * do anything we still error out.
 		 */
 		ASSERT(0);
-		if (em)
-			free_extent_map(em);
-		return -EINVAL;
+		return PTR_ERR(em);
 	}
 	map = em->map_lookup;
 	mutex_lock(&fs_info->chunk_mutex);
@@ -4888,7 +4908,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	struct btrfs_device *device;
 	struct btrfs_chunk *chunk;
 	struct btrfs_stripe *stripe;
-	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
 	size_t item_size;
@@ -4897,24 +4916,9 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	int i = 0;
 	int ret = 0;
 
-	em_tree = &fs_info->mapping_tree.map_tree;
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, chunk_offset, chunk_size);
-	read_unlock(&em_tree->lock);
-
-	if (!em) {
-		btrfs_crit(fs_info, "unable to find logical %Lu len %Lu",
-			   chunk_offset, chunk_size);
-		return -EINVAL;
-	}
-
-	if (em->start != chunk_offset || em->len != chunk_size) {
-		btrfs_crit(fs_info,
-			   "found a bad mapping, wanted %Lu-%Lu, found %Lu-%Lu",
-			    chunk_offset, chunk_size, em->start, em->len);
-		free_extent_map(em);
-		return -EINVAL;
-	}
+	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
+	if (IS_ERR(em))
+		return PTR_ERR(em);
 
 	map = em->map_lookup;
 	item_size = btrfs_chunk_item_size(map->num_stripes);
@@ -5057,15 +5061,12 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	int readonly = 0;
 	int miss_ndevs = 0;
 	int i;
 
-	read_lock(&map_tree->map_tree.lock);
-	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
-	read_unlock(&map_tree->map_tree.lock);
-	if (!em)
+	em = get_chunk_map(fs_info, chunk_offset, 1);
+	if (IS_ERR(em))
 		return 1;
 
 	map = em->map_lookup;
@@ -5119,34 +5120,19 @@ void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
 
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 {
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	int ret;
 
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, logical, len);
-	read_unlock(&em_tree->lock);
-
-	/*
-	 * We could return errors for these cases, but that could get ugly and
-	 * we'd probably do the same thing which is just not do anything else
-	 * and exit, so return 1 so the callers don't try to use other copies.
-	 */
-	if (!em) {
-		btrfs_crit(fs_info, "No mapping for %Lu-%Lu", logical,
-			    logical+len);
-		return 1;
-	}
-
-	if (em->start > logical || em->start + em->len < logical) {
-		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got %Lu-%Lu",
-			   logical, logical+len, em->start,
-			   em->start + em->len);
-		free_extent_map(em);
+	em = get_chunk_map(fs_info, logical, len);
+	if (IS_ERR(em))
+		/*
+		 * We could return errors for these cases, but that could get
+		 * ugly and we'd probably do the same thing which is just not do
+		 * anything else and exit, so return 1 so the callers don't try
+		 * to use other copies.
+		 */
 		return 1;
-	}
 
 	map = em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
@@ -5175,15 +5161,11 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 {
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	unsigned long len = fs_info->sectorsize;
 
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, logical, len);
-	read_unlock(&em_tree->lock);
-	BUG_ON(!em);
+	em = get_chunk_map(fs_info, logical, len);
+	BUG_ON(IS_ERR(em));
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
 		len = map->stripe_len * nr_data_stripes(map);
@@ -5191,20 +5173,16 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	return len;
 }
 
-int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
+int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 			   u64 logical, u64 len, int mirror_num)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	int ret = 0;
 
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, logical, len);
-	read_unlock(&em_tree->lock);
-	BUG_ON(!em);
+	em = get_chunk_map(fs_info, logical, len);
+	BUG_ON(IS_ERR(em));
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
 		ret = 1;
@@ -5324,8 +5302,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 {
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_end_offset;
@@ -5347,23 +5323,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	u64 physical_to_patch_in_first_stripe = 0;
 	u64 raid56_full_stripe_start = (u64)-1;
 
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, logical, *length);
-	read_unlock(&em_tree->lock);
-
-	if (!em) {
-		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
-			logical, *length);
-		return -EINVAL;
-	}
-
-	if (em->start > logical || em->start + em->len < logical) {
-		btrfs_crit(fs_info,
-			   "found a bad mapping, wanted %Lu, found %Lu-%Lu",
-			   logical, em->start, em->start + em->len);
-		free_extent_map(em);
-		return -EINVAL;
-	}
+	em = get_chunk_map(fs_info, logical, *length);
+	if (IS_ERR(em))
+		return PTR_ERR(em);
 
 	map = em->map_lookup;
 	offset = logical - em->start;
@@ -5899,8 +5861,6 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len)
 {
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
-	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
 	u64 *buf;
@@ -5910,24 +5870,11 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 	u64 rmap_len;
 	int i, j, nr = 0;
 
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, chunk_start, 1);
-	read_unlock(&em_tree->lock);
-
-	if (!em) {
-		btrfs_err(fs_info, "couldn't find em for chunk %Lu",
-			chunk_start);
+	em = get_chunk_map(fs_info, chunk_start, 1);
+	if (IS_ERR(em))
 		return -EIO;
-	}
 
-	if (em->start != chunk_start) {
-		btrfs_err(fs_info, "bad chunk start, em=%Lu, wanted=%Lu",
-		       em->start, chunk_start);
-		free_extent_map(em);
-		return -EIO;
-	}
 	map = em->map_lookup;
-
 	length = em->len;
 	rmap_len = map->stripe_len;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 24ba6bc..bd5f6cd 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -475,7 +475,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
 void btrfs_scratch_superblocks(struct block_device *bdev, char *device_path);
-int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
+int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 			   u64 logical, u64 len, int mirror_num);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    struct btrfs_mapping_tree *map_tree,
-- 
2.5.5

