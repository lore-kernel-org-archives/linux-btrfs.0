Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95ED3D5237
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263900; cv=none; b=DITh40LYzs8QGA/Eak398QFVx6HiOx0c/ZjkFEjCCFWD6Lxjsafi8FmY8pi12VVQNff6phGCc24vewZxUoUzHOqWCOITMZ8txEziZk31+IXSQQozvkxoQGs+IKzUJhkYNdEzz0DsFtinuFEj4LtLguk35AtG5xuvAg+2asEKaG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263900; c=relaxed/simple;
	bh=OLIlur75pbqP6AI4iC7kYKOGBf10+GQhAVHq5jgQkXU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS1K9LnjoZh86M1Af4JG467uT6uh9+V80WvYLG2sRwsr+MibLwvEFhmaxWxe1pgtMU5Ux4WzonEZwxbEFBeM+/QVaouTbLbyxmb6R7UJ1cAkXnWD5CFKVmn4QWlJLeK8Lya6BWJ1zfS/DU9LkCs3R/qk8RBn5jQitddTKsBZLeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQxBEcrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQxBEcrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38807C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263900;
	bh=OLIlur75pbqP6AI4iC7kYKOGBf10+GQhAVHq5jgQkXU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sQxBEcrsYt2IUqbfbV8SZZG91dma4PlmUME+eXn5KKiLbwc/QaejRWCZQJOITSWhx
	 qbjMk5qJCD740NXWj5Y/ieScG4ZpYsfVzs1XHEEmWhoPRRlT6aQvqgNdfIfvhdxB26
	 yCPuvWoMGENxuM/K2K4kLtZeEy/pUTjDmMTTNi1nXuYyUhLfxukdSiRrNUL60HltFw
	 CGibxDuSbJmrRfGPSIg9lrhAw/wOmCbu7f3c0ChTscJu04069Ou6lxlDV8TfkyW16T
	 OItLsZXDQDvoUFlyV7DvXbz82Q53OycR/XcwYujzyA207m8YCXWKFcL7A4lTzHWCxF
	 rYsOuCemDunaw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] btrfs: remove unit field from struct btrfs_free_space_ctl
Date: Wed, 15 Apr 2026 15:38:08 +0100
Message-ID: <4d202043d9abfac2dc9600de07f50be7614058b7.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The unit field always has a value matching the sector size, and since we
have a block group pointer in the structure, we can access the block group
and then its fs_info field to get to the sector size. So remove the field,
which will allow us later to shrink the structure size.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 95 ++++++++++++++++++++-----------------
 fs/btrfs/free-space-cache.h |  1 -
 2 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4f53e0908f18..9b33f68f43ec 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -690,11 +690,12 @@ static int io_ctl_read_bitmap(struct btrfs_io_ctl *io_ctl,
 static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_block_group *block_group = ctl->block_group;
+	const int unit = block_group->fs_info->sectorsize;
 	u64 max_bytes;
 	u64 bitmap_bytes;
 	u64 extent_bytes;
 	u64 size = block_group->length;
-	u64 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
+	u64 bytes_per_bg = BITS_PER_BITMAP * unit;
 	u64 max_bitmaps = div64_u64(size + bytes_per_bg - 1, bytes_per_bg);
 
 	max_bitmaps = max_t(u64, max_bitmaps, 1);
@@ -703,7 +704,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 		btrfs_err(block_group->fs_info,
 "invalid free space control: bg start=%llu len=%llu total_bitmaps=%u unit=%u max_bitmaps=%llu bytes_per_bg=%llu",
 			  block_group->start, block_group->length,
-			  ctl->total_bitmaps, ctl->unit, max_bitmaps,
+			  ctl->total_bitmaps, unit, max_bitmaps,
 			  bytes_per_bg);
 	ASSERT(ctl->total_bitmaps <= max_bitmaps);
 
@@ -718,7 +719,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	else
 		max_bytes = MAX_CACHE_BYTES_PER_GIG * div_u64(size, SZ_1G);
 
-	bitmap_bytes = ctl->total_bitmaps * ctl->unit;
+	bitmap_bytes = ctl->total_bitmaps * unit;
 
 	/*
 	 * we want the extent entry threshold to always be at most 1/2 the max
@@ -916,7 +917,7 @@ static int copy_free_space_cache(struct btrfs_block_group *block_group,
 			spin_lock(&ctl->tree_lock);
 		} else {
 			u64 offset = info->offset;
-			u64 bytes = ctl->unit;
+			u64 bytes = ctl->block_group->fs_info->sectorsize;
 
 			ret = search_bitmap(ctl, info, &offset, &bytes, false);
 			if (ret == 0) {
@@ -1571,7 +1572,7 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 	u64 bitmap_start;
 	u64 bytes_per_bitmap;
 
-	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
+	bytes_per_bitmap = BITS_PER_BITMAP * ctl->block_group->fs_info->sectorsize;
 	bitmap_start = offset - ctl->block_group->start;
 	bitmap_start = div64_u64(bitmap_start, bytes_per_bitmap);
 	bitmap_start *= bytes_per_bitmap;
@@ -1702,6 +1703,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 {
 	struct rb_node *n = ctl->free_space_offset.rb_node;
 	struct btrfs_free_space *entry = NULL, *prev = NULL;
+	const int unit = ctl->block_group->fs_info->sectorsize;
 
 	lockdep_assert_held(&ctl->tree_lock);
 
@@ -1785,7 +1787,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 			    prev->offset + prev->bytes > offset)
 				return prev;
 		}
-		if (entry->offset + BITS_PER_BITMAP * ctl->unit > offset)
+		if (entry->offset + BITS_PER_BITMAP * unit > offset)
 			return entry;
 	} else if (entry->offset + entry->bytes > offset)
 		return entry;
@@ -1799,8 +1801,7 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 			return NULL;
 		entry = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (entry->bitmap) {
-			if (entry->offset + BITS_PER_BITMAP *
-			    ctl->unit > offset)
+			if (entry->offset + BITS_PER_BITMAP * unit > offset)
 				break;
 		} else {
 			if (entry->offset + entry->bytes > offset)
@@ -1875,18 +1876,19 @@ static inline void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 				     struct btrfs_free_space *info,
 				     u64 offset, u64 bytes, bool update_stat)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	unsigned long start, count, end;
 	int extent_delta = -1;
 
-	start = offset_to_bit(info->offset, ctl->unit, offset);
-	count = bytes_to_bits(bytes, ctl->unit);
+	start = offset_to_bit(info->offset, unit, offset);
+	count = bytes_to_bits(bytes, unit);
 	end = start + count;
 	ASSERT(end <= BITS_PER_BITMAP);
 
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
-	if (info->max_extent_size > ctl->unit)
+	if (info->max_extent_size > unit)
 		info->max_extent_size = 0;
 
 	relink_bitmap_entry(ctl, info);
@@ -1911,11 +1913,12 @@ static void btrfs_bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
 				  struct btrfs_free_space *info, u64 offset,
 				  u64 bytes)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	unsigned long start, count, end;
 	int extent_delta = 1;
 
-	start = offset_to_bit(info->offset, ctl->unit, offset);
-	count = bytes_to_bits(bytes, ctl->unit);
+	start = offset_to_bit(info->offset, unit, offset);
+	count = bytes_to_bits(bytes, unit);
 	end = start + count;
 	ASSERT(end <= BITS_PER_BITMAP);
 
@@ -1952,6 +1955,7 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 			 struct btrfs_free_space *bitmap_info, u64 *offset,
 			 u64 *bytes, bool for_alloc)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	unsigned long found_bits = 0;
 	unsigned long max_bits = 0;
 	unsigned long bits, i;
@@ -1969,9 +1973,9 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 		return -1;
 	}
 
-	i = offset_to_bit(bitmap_info->offset, ctl->unit,
+	i = offset_to_bit(bitmap_info->offset, unit,
 			  max_t(u64, *offset, bitmap_info->offset));
-	bits = bytes_to_bits(*bytes, ctl->unit);
+	bits = bytes_to_bits(*bytes, unit);
 
 	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
 		if (for_alloc && bits == 1) {
@@ -1991,12 +1995,12 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 	}
 
 	if (found_bits) {
-		*offset = (u64)(i * ctl->unit) + bitmap_info->offset;
-		*bytes = (u64)(found_bits) * ctl->unit;
+		*offset = (u64)(i * unit) + bitmap_info->offset;
+		*bytes = (u64)(found_bits) * unit;
 		return 0;
 	}
 
-	*bytes = (u64)(max_bits) * ctl->unit;
+	*bytes = (u64)(max_bits) * unit;
 	bitmap_info->max_extent_size = *bytes;
 	relink_bitmap_entry(ctl, bitmap_info);
 	return -1;
@@ -2148,12 +2152,13 @@ static noinline int remove_from_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *bitmap_info,
 			      u64 *offset, u64 *bytes)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	u64 end;
 	u64 search_start, search_bytes;
 	int ret;
 
 again:
-	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * ctl->unit) - 1;
+	end = bitmap_info->offset + (u64)(BITS_PER_BITMAP * unit) - 1;
 
 	/*
 	 * We need to search for bits in this bitmap.  We could only cover some
@@ -2162,7 +2167,7 @@ static noinline int remove_from_bitmap(struct btrfs_free_space_ctl *ctl,
 	 * go searching for the next bit.
 	 */
 	search_start = *offset;
-	search_bytes = ctl->unit;
+	search_bytes = unit;
 	search_bytes = min(search_bytes, end - search_start + 1);
 	ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes,
 			    false);
@@ -2208,7 +2213,7 @@ static noinline int remove_from_bitmap(struct btrfs_free_space_ctl *ctl,
 		 * everything over again.
 		 */
 		search_start = *offset;
-		search_bytes = ctl->unit;
+		search_bytes = unit;
 		ret = search_bitmap(ctl, bitmap_info, &search_start,
 				    &search_bytes, false);
 		if (ret < 0 || search_start != *offset)
@@ -2225,6 +2230,7 @@ static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 			       struct btrfs_free_space *info, u64 offset,
 			       u64 bytes, enum btrfs_trim_state trim_state)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	u64 bytes_to_set = 0;
 	u64 end;
 
@@ -2241,7 +2247,7 @@ static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 		info->trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 	}
 
-	end = info->offset + (u64)(BITS_PER_BITMAP * ctl->unit);
+	end = info->offset + (u64)(BITS_PER_BITMAP * unit);
 
 	bytes_to_set = min(end - offset, bytes);
 
@@ -2295,7 +2301,7 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 	 * so allow those block groups to still be allowed to have a bitmap
 	 * entry.
 	 */
-	if (((BITS_PER_BITMAP * ctl->unit) >> 1) > block_group->length)
+	if (((BITS_PER_BITMAP * fs_info->sectorsize) >> 1) > block_group->length)
 		return false;
 
 	return true;
@@ -2494,6 +2500,7 @@ static bool steal_from_bitmap_to_end(struct btrfs_free_space_ctl *ctl,
 				     struct btrfs_free_space *info,
 				     bool update_stat)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	struct btrfs_free_space *bitmap;
 	unsigned long i;
 	unsigned long j;
@@ -2505,11 +2512,11 @@ static bool steal_from_bitmap_to_end(struct btrfs_free_space_ctl *ctl,
 	if (!bitmap)
 		return false;
 
-	i = offset_to_bit(bitmap->offset, ctl->unit, end);
+	i = offset_to_bit(bitmap->offset, unit, end);
 	j = find_next_zero_bit(bitmap->bitmap, BITS_PER_BITMAP, i);
 	if (j == i)
 		return false;
-	bytes = (j - i) * ctl->unit;
+	bytes = (j - i) * unit;
 	info->bytes += bytes;
 
 	/* See try_merge_free_space() comment. */
@@ -2528,6 +2535,7 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 				       struct btrfs_free_space *info,
 				       bool update_stat)
 {
+	const int unit = ctl->block_group->fs_info->sectorsize;
 	struct btrfs_free_space *bitmap;
 	u64 bitmap_offset;
 	unsigned long i;
@@ -2547,7 +2555,7 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 	if (!bitmap)
 		return false;
 
-	i = offset_to_bit(bitmap->offset, ctl->unit, info->offset) - 1;
+	i = offset_to_bit(bitmap->offset, unit, info->offset) - 1;
 	j = 0;
 	prev_j = (unsigned long)-1;
 	for_each_clear_bit_from(j, bitmap->bitmap, BITS_PER_BITMAP) {
@@ -2559,9 +2567,9 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 		return false;
 
 	if (prev_j == (unsigned long)-1)
-		bytes = (i + 1) * ctl->unit;
+		bytes = (i + 1) * unit;
 	else
-		bytes = (i - prev_j) * ctl->unit;
+		bytes = (i - prev_j) * unit;
 
 	info->offset -= bytes;
 	info->bytes += bytes;
@@ -2947,10 +2955,7 @@ void btrfs_dump_free_space(struct btrfs_block_group *block_group,
 void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 			       struct btrfs_free_space_ctl *ctl)
 {
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
-
 	spin_lock_init(&ctl->tree_lock);
-	ctl->unit = fs_info->sectorsize;
 	ctl->block_group = block_group;
 	ctl->op = &free_space_op;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
@@ -3326,6 +3331,7 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group *block_group,
 				u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	const int unit = block_group->fs_info->sectorsize;
 	unsigned long next_zero;
 	unsigned long i;
 	unsigned long want_bits;
@@ -3338,10 +3344,10 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group *block_group,
 
 	lockdep_assert_held(&ctl->tree_lock);
 
-	i = offset_to_bit(entry->offset, ctl->unit,
+	i = offset_to_bit(entry->offset, unit,
 			  max_t(u64, offset, entry->offset));
-	want_bits = bytes_to_bits(bytes, ctl->unit);
-	min_bits = bytes_to_bits(min_bytes, ctl->unit);
+	want_bits = bytes_to_bits(bytes, unit);
+	min_bits = bytes_to_bits(min_bytes, unit);
 
 	/*
 	 * Don't bother looking for a cluster in this bitmap if it's heavily
@@ -3367,7 +3373,7 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group *block_group,
 	}
 
 	if (!found_bits) {
-		entry->max_extent_size = (u64)max_bits * ctl->unit;
+		entry->max_extent_size = (u64)max_bits * unit;
 		return -ENOSPC;
 	}
 
@@ -3378,15 +3384,15 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group *block_group,
 
 	total_found += found_bits;
 
-	if (cluster->max_size < found_bits * ctl->unit)
-		cluster->max_size = found_bits * ctl->unit;
+	if (cluster->max_size < found_bits * unit)
+		cluster->max_size = found_bits * unit;
 
 	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
 		i = next_zero + 1;
 		goto again;
 	}
 
-	cluster->window_start = start * ctl->unit + entry->offset;
+	cluster->window_start = start * unit + entry->offset;
 	rb_erase(&entry->offset_index, &ctl->free_space_offset);
 	rb_erase_cached(&entry->bytes_index, &ctl->free_space_bytes);
 
@@ -3402,8 +3408,7 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group *block_group,
 	ret = tree_insert_offset(ctl, cluster, entry);
 	ASSERT(!ret); /* -EEXIST; Logic error */
 
-	trace_btrfs_setup_cluster(block_group, cluster,
-				  total_found * ctl->unit, 1);
+	trace_btrfs_setup_cluster(block_group, cluster, total_found * unit, 1);
 	return 0;
 }
 
@@ -4043,7 +4048,9 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 		}
 next:
 		if (next_bitmap) {
-			offset += BITS_PER_BITMAP * ctl->unit;
+			const int unit = block_group->fs_info->sectorsize;
+
+			offset += BITS_PER_BITMAP * unit;
 			start = offset;
 		} else {
 			start += bytes;
@@ -4070,6 +4077,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	const int unit = block_group->fs_info->sectorsize;
 	int ret;
 	u64 rem = 0;
 
@@ -4090,7 +4098,7 @@ int btrfs_trim_block_group(struct btrfs_block_group *block_group,
 		goto out;
 
 	ret = trim_bitmaps(block_group, trimmed, start, end, minlen, 0, false);
-	div64_u64_rem(end, BITS_PER_BITMAP * ctl->unit, &rem);
+	div64_u64_rem(end, BITS_PER_BITMAP * unit, &rem);
 	/* If we ended in the middle of a bitmap, reset the trimming flag */
 	if (rem)
 		reset_trimming_bitmap(ctl, offset_to_bitmap(ctl, end));
@@ -4309,6 +4317,7 @@ int test_check_exists(struct btrfs_block_group *cache,
 		      u64 offset, u64 bytes)
 {
 	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
+	const int unit = cache->fs_info->sectorsize;
 	struct btrfs_free_space *info;
 	int ret = 0;
 
@@ -4328,7 +4337,7 @@ int test_check_exists(struct btrfs_block_group *cache,
 		struct btrfs_free_space *tmp;
 
 		bit_off = offset;
-		bit_bytes = ctl->unit;
+		bit_bytes = unit;
 		ret = search_bitmap(ctl, info, &bit_off, &bit_bytes, false);
 		if (!ret) {
 			if (bit_off == offset) {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index e75482fb2d69..2ee0b876723a 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -81,7 +81,6 @@ struct btrfs_free_space_ctl {
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
-	int unit;
 	s32 discardable_extents[BTRFS_STAT_NR_ENTRIES];
 	s64 discardable_bytes[BTRFS_STAT_NR_ENTRIES];
 	const struct btrfs_free_space_op *op;
-- 
2.47.2

