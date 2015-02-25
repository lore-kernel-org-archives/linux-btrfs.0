Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYSYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:46 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 13F62AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:45 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 04/11] btrfs: cleanup 64bit/32bit divs, provably bounded values
Date: Wed, 25 Feb 2015 19:24:44 +0100
Message-Id: <31454f437f9ee0fd74c59af6bf2b79a467ba8311.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The divisor is derived from nodesize or PAGE_SIZE, fits into 32bit type.
Get rid of a few more do_div instances.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c      |  4 ++--
 fs/btrfs/free-space-cache.c |  8 ++++----
 fs/btrfs/ioctl.c            |  2 +-
 fs/btrfs/scrub.c            |  8 +++-----
 fs/btrfs/volumes.c          | 26 +++++++++++++-------------
 5 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2cb32bc45bcc..4ccc3397c644 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5032,7 +5032,7 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	    BTRFS_I(inode)->csum_bytes == 0)
 		return 0;
 
-	old_csums = (int)div64_u64(BTRFS_I(inode)->csum_bytes, root->sectorsize);
+	old_csums = (int)div_u64(BTRFS_I(inode)->csum_bytes, root->sectorsize);
 	if (reserve)
 		BTRFS_I(inode)->csum_bytes += num_bytes;
 	else
@@ -5041,7 +5041,7 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	num_csums_per_leaf = (int)div_u64(csum_size,
 					    sizeof(struct btrfs_csum_item) +
 					    sizeof(struct btrfs_disk_key));
-	num_csums = (int)div64_u64(BTRFS_I(inode)->csum_bytes, root->sectorsize);
+	num_csums = (int)div_u64(BTRFS_I(inode)->csum_bytes, root->sectorsize);
 	num_csums = num_csums + num_csums_per_leaf - 1;
 	num_csums = num_csums / num_csums_per_leaf;
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cb84923561e4..16cc62b87ba5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1298,11 +1298,11 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 				   u64 offset)
 {
 	u64 bitmap_start;
-	u64 bytes_per_bitmap;
+	u32 bytes_per_bitmap;
 
 	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
 	bitmap_start = offset - ctl->start;
-	bitmap_start = div64_u64(bitmap_start, bytes_per_bitmap);
+	bitmap_start = div_u64(bitmap_start, bytes_per_bitmap);
 	bitmap_start *= bytes_per_bitmap;
 	bitmap_start += ctl->start;
 
@@ -1521,8 +1521,8 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	u64 bitmap_bytes;
 	u64 extent_bytes;
 	u64 size = block_group->key.offset;
-	u64 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
-	int max_bitmaps = div64_u64(size + bytes_per_bg - 1, bytes_per_bg);
+	u32 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
+	u32 max_bitmaps = div_u64(size + bytes_per_bg - 1, bytes_per_bg);
 
 	max_bitmaps = max(max_bitmaps, 1);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d49fe8a0f6b5..5544a79dc2ba 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1564,7 +1564,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		goto out_free;
 	}
 
-	do_div(new_size, root->sectorsize);
+	new_size = div_u64(new_size, root->sectorsize);
 	new_size *= root->sectorsize;
 
 	printk_in_rcu(KERN_INFO "BTRFS: new size for %s is %llu\n",
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index db21f17df996..07be15d4ce7b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2624,9 +2624,8 @@ static int get_raid56_logic_offset(u64 physical, int num,
 	for (i = 0; i < nr_data_stripes(map); i++) {
 		*offset = last_offset + i * map->stripe_len;
 
-		stripe_nr = *offset;
-		do_div(stripe_nr, map->stripe_len);
-		do_div(stripe_nr, nr_data_stripes(map));
+		stripe_nr = div_u64(*offset, map->stripe_len);
+		stripe_nr = div_u64(stripe_nr, nr_data_stripes(map));
 
 		/* Work out the disk rotation on this stripe-set */
 		rot = do_div(stripe_nr, map->num_stripes);
@@ -2995,10 +2994,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	int extent_mirror_num;
 	int stop_loop = 0;
 
-	nstripes = length;
 	physical = map->stripes[num].physical;
 	offset = 0;
-	do_div(nstripes, map->stripe_len);
+	nstripes = div_u64(length, map->stripe_len);
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 		offset = map->stripe_len * num;
 		increment = map->stripe_len * map->num_stripes;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 50bb7b8b17e8..446e4b24fc14 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3021,7 +3021,7 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 
 		stripe_offset = btrfs_stripe_offset(leaf, stripe);
 		stripe_length = btrfs_chunk_length(leaf, chunk);
-		do_div(stripe_length, factor);
+		stripe_length = div_u64(stripe_length, factor);
 
 		if (stripe_offset < bargs->pend &&
 		    stripe_offset + stripe_length > bargs->pstart)
@@ -4399,8 +4399,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
 		u64 mask = (1ULL << 24) - 1;
-		stripe_size = max_chunk_size;
-		do_div(stripe_size, data_stripes);
+
+		stripe_size = div_u64(max_chunk_size, data_stripes);
 
 		/* bump the answer up to a 16MB boundary */
 		stripe_size = (stripe_size + mask) & ~mask;
@@ -4412,10 +4412,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			stripe_size = devices_info[ndevs-1].max_avail;
 	}
 
-	do_div(stripe_size, dev_stripes);
+	stripe_size = div_u64(stripe_size, dev_stripes);
 
 	/* align to BTRFS_STRIPE_LEN */
-	do_div(stripe_size, raid_stripe_len);
+	stripe_size = div_u64(stripe_size, raid_stripe_len);
 	stripe_size *= raid_stripe_len;
 
 	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
@@ -5135,7 +5135,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	stripe_index = 0;
 	stripe_nr_orig = stripe_nr;
 	stripe_nr_end = ALIGN(offset + *length, map->stripe_len);
-	do_div(stripe_nr_end, map->stripe_len);
+	stripe_nr_end = div_u64(stripe_nr_end, map->stripe_len);
 	stripe_end_offset = stripe_nr_end * map->stripe_len -
 			    (offset + *length);
 
@@ -5197,8 +5197,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
 		     mirror_num > 1)) {
 			/* push stripe_nr back to the start of the full stripe */
-			stripe_nr = raid56_full_stripe_start;
-			do_div(stripe_nr, stripe_len * nr_data_stripes(map));
+			stripe_nr = div_u64(raid56_full_stripe_start,
+					stripe_len * nr_data_stripes(map));
 
 			/* RAID[56] write or recovery. Return all stripes */
 			num_stripes = map->num_stripes;
@@ -5534,11 +5534,11 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	rmap_len = map->stripe_len;
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID10)
-		do_div(length, map->num_stripes / map->sub_stripes);
+		length = div_u64(length, map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
-		do_div(length, map->num_stripes);
+		length = div_u64(length, map->num_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-		do_div(length, nr_data_stripes(map));
+		length = div_u64(length, nr_data_stripes(map));
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}
 
@@ -5553,11 +5553,11 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 			continue;
 
 		stripe_nr = physical - map->stripes[i].physical;
-		do_div(stripe_nr, map->stripe_len);
+		stripe_nr = div_u64(stripe_nr, map->stripe_len);
 
 		if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 			stripe_nr = stripe_nr * map->num_stripes + i;
-			do_div(stripe_nr, map->sub_stripes);
+			stripe_nr = div_u64(stripe_nr, map->sub_stripes);
 		} else if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 			stripe_nr = stripe_nr * map->num_stripes + i;
 		} /* else if RAID[56], multiply by nr_data_stripes().
-- 
2.1.3

