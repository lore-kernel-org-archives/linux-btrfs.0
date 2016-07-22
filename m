Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36660 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbcGVNm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 09:42:29 -0400
Received: by mail-wm0-f67.google.com with SMTP id x83so6236442wma.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 06:42:28 -0700 (PDT)
From: Sanidhya Solanki <lkml.page@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Sanidhya Solanki <lkml.page@gmail.com>
Subject: [PATCH] btrfs-progs: Make RAID stripesize configurable
Date: Fri, 22 Jul 2016 09:42:09 -0400
Message-Id: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds the user-space component of making the RAID stripesize user configurable.
Updates the btrfs-documentation to provide the information to users.
Adds parsing capabilities for the new options.
Adds the means of transfering the data to kernel space.
Updates the kernel ioctl interface to account for new options.
Updates the user-space component of RAID stripesize management.
Updates the TODO list for future tasks.

Patch applies to the v4.6.1 release branch.

Signed-off-by: Sanidhya Solanki <lkml.page@gmail.com>
---
 Documentation/btrfs-balance.asciidoc | 14 +++++++++
 btrfs-convert.c                      | 59 +++++++++++++++++++++++-------------
 btrfs-image.c                        |  4 ++-
 btrfsck.h                            |  2 +-
 chunk-recover.c                      |  8 +++--
 cmds-balance.c                       | 45 +++++++++++++++++++++++++--
 cmds-check.c                         |  4 ++-
 disk-io.c                            | 10 ++++--
 extent-tree.c                        |  4 ++-
 ioctl.h                              | 10 ++++--
 mkfs.c                               | 18 +++++++++++
 raid6.c                              |  3 ++
 utils.c                              |  4 ++-
 volumes.c                            | 18 ++++++++---
 volumes.h                            | 12 +++++---
 15 files changed, 170 insertions(+), 45 deletions(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 7df40b9..fd61523 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -32,6 +32,7 @@ The filters can be used to perform following actions:
 - convert block group profiles (filter 'convert')
 - make block group usage more compact  (filter 'usage')
 - perform actions only on a given device (filters 'devid', 'drange')
+- perform an operation that changes the stripe size for a RAID instance
 
 The filters can be applied to a combination of block group types (data,
 metadata, system). Note that changing 'system' needs the force option.
@@ -157,6 +158,19 @@ is a range specified as 'start..end'. Makes sense for block group profiles that
 utilize striping, ie. RAID0/10/5/6.  The range minimum and maximum are
 inclusive.
 
+*stripesize=<number>*;;
+Specifies the new stripe size for a filesystem instance. Multiple BTrFS
+filesystems mounted in parallel with varying stripe size are supported, the only
+limitation being that the stripe size provided to balance in this option must
+be a multiple of 512 bytes, and greater than 512 bytes, but not larger than
+16 KiBytes. These limitations exist in the user's best interest. due to sizes too
+large or too small leading to performance degradations on modern devices.
+
+It is recommended that the user try various sizes to find one that best suit the
+performance requirements of the system. This option renders the RAID instance as
+in-compatible with previous kernel versions, due to the basis for this operation
+being implemented through FS metadata.
+
 *soft*::
 Takes no parameters. Only has meaning when converting between profiles.
 When doing convert from one profile to another and soft mode is on,
diff --git a/btrfs-convert.c b/btrfs-convert.c
index b18de59..dc796d0 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -278,12 +278,14 @@ static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 {
 	int i;
 	u64 offset;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		offset = btrfs_sb_offset(i);
-		offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
+		offset &= ~((u64)((sz_stripe) * (stripe_width)) - 1);
 
-		if (bytenr < offset + BTRFS_STRIPE_LEN &&
+		if (bytenr < offset + ((sz_stripe) * (stripe_width)) &&
 		    bytenr + num_bytes > offset)
 			return 1;
 	}
@@ -603,6 +605,8 @@ static int block_iterate_proc(u64 disk_block, u64 file_block,
 	int ret = 0;
 	int sb_region;
 	int do_barrier;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct btrfs_root *root = idata->root;
 	struct btrfs_block_group_cache *cache;
 	u64 bytenr = disk_block * root->sectorsize;
@@ -629,8 +633,8 @@ static int block_iterate_proc(u64 disk_block, u64 file_block,
 		}
 
 		if (sb_region) {
-			bytenr += BTRFS_STRIPE_LEN - 1;
-			bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
+			bytenr += ((sz_stripe) * (stripe_width)) - 1;
+			bytenr &= ~((u64)((sz_stripe) * (stripe_width)) - 1);
 		} else {
 			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
 			BUG_ON(!cache);
@@ -1269,6 +1273,8 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	u64 disk_bytenr;
 	int i;
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	BUG_ON(bytenr != round_down(bytenr, root->sectorsize));
 	BUG_ON(len != round_down(len, root->sectorsize));
@@ -1288,8 +1294,8 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		u64 cur = btrfs_sb_offset(i);
 
-		if (bytenr >= cur && bytenr < cur + BTRFS_STRIPE_LEN) {
-			*ret_len = cur + BTRFS_STRIPE_LEN - bytenr;
+		if (bytenr >= cur && bytenr < cur + ((sz_stripe) * (stripe_width))) {
+			*ret_len = cur + ((sz_stripe) * (stripe_width)) - bytenr;
 			return 0;
 		}
 	}
@@ -1310,8 +1316,8 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		 *      |---range---|
 		 * Drop out, no need to insert anything
 		 */
-		if (bytenr >= cur && bytenr < cur + BTRFS_STRIPE_LEN) {
-			*ret_len = cur + BTRFS_STRIPE_LEN - bytenr;
+		if (bytenr >= cur && bytenr < cur + ((sz_stripe) * (stripe_width))) {
+			*ret_len = cur + ((sz_stripe) * (stripe_width)) - bytenr;
 			return 0;
 		}
 	}
@@ -1464,8 +1470,8 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 /*
  * Relocate the used ext2 data in reserved ranges
  * [0,1M)
- * [btrfs_sb_offset(1), +BTRFS_STRIPE_LEN)
- * [btrfs_sb_offset(2), +BTRFS_STRIPE_LEN)
+ * [btrfs_sb_offset(1), +((sz_stripe) * (stripe_width)))
+ * [btrfs_sb_offset(2), +((sz_stripe) * (stripe_width)))
  */
 static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
@@ -1475,6 +1481,8 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 {
 	u64 cur_off;
 	u64 cur_len;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	int ret = 0;
 
 	/* 0 ~ 1M */
@@ -1487,7 +1495,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 
 	/* second sb(fisrt sb is included in 0~1M) */
 	cur_off = btrfs_sb_offset(1);
-	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
+	cur_len = min(total_bytes, cur_off + ((sz_stripe) * (stripe_width))) - cur_off;
 	if (cur_off > total_bytes)
 		return ret;
 	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
@@ -1497,7 +1505,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 
 	/* Last sb */
 	cur_off = btrfs_sb_offset(2);
-	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
+	cur_len = min(total_bytes, cur_off + ((sz_stripe) * (stripe_width))) - cur_off;
 	if (cur_off > total_bytes)
 		return ret;
 	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
@@ -1932,6 +1940,8 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 {
 	struct btrfs_chunk *chunk;
 	struct btrfs_disk_key *key;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	u32 sectorsize = btrfs_super_sectorsize(super);
 
 	key = (struct btrfs_disk_key *)(super->sys_chunk_array);
@@ -1944,7 +1954,7 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 
 	btrfs_set_stack_chunk_length(chunk, btrfs_super_total_bytes(super));
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
+	btrfs_set_stack_chunk_stripe_len(chunk, ((sz_stripe) * (stripe_width)));
 	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
 	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
 	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
@@ -2052,6 +2062,8 @@ static int wipe_one_reserved_range(struct cache_tree *tree,
 {
 	struct cache_extent *cache;
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	BUG_ON(ensure_size && min_stripe_size == 0);
 	/*
@@ -2059,11 +2071,11 @@ static int wipe_one_reserved_range(struct cache_tree *tree,
 	 * So we don't need to consider merge case for ensure_size
 	 */
 	BUG_ON(min_stripe_size && (min_stripe_size < len * 2 ||
-	       min_stripe_size / 2 < BTRFS_STRIPE_LEN));
+	       min_stripe_size / 2 < ((sz_stripe) * (stripe_width))));
 
 	/* Also, wipe range should already be aligned */
-	BUG_ON(start != round_down(start, BTRFS_STRIPE_LEN) ||
-	       start + len != round_up(start + len, BTRFS_STRIPE_LEN));
+	BUG_ON(start != round_down(start, ((sz_stripe) * (stripe_width))) ||
+	       start + len != round_up(start + len, ((sz_stripe) * (stripe_width))));
 
 	min_stripe_size /= 2;
 
@@ -2160,22 +2172,26 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 				int ensure_size)
 {
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	ret = wipe_one_reserved_range(tree, 0, 1024 * 1024, min_stripe_size,
 				      ensure_size);
 	if (ret < 0)
 		return ret;
 	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(1),
-			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
+			((sz_stripe) * (stripe_width)), min_stripe_size, ensure_size);
 	if (ret < 0)
 		return ret;
 	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(2),
-			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
+			((sz_stripe) * (stripe_width)), min_stripe_size, ensure_size);
 	return ret;
 }
 
 static int calculate_available_space(struct btrfs_convert_context *cctx)
 {
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct cache_tree *used = &cctx->used;
 	struct cache_tree *data_chunks = &cctx->data_chunks;
 	struct cache_tree *free = &cctx->free;
@@ -2228,8 +2244,9 @@ static int calculate_available_space(struct btrfs_convert_context *cctx)
 			u64 len;
 
 			len = cache->start - round_up(cur_off,
-						      BTRFS_STRIPE_LEN);
-			insert_start = round_up(cur_off, BTRFS_STRIPE_LEN);
+						      ((sz_stripe) * (stripe_width)));
+			insert_start = round_up(cur_off,
+					        ((sz_stripe) * (stripe_width)));
 
 			ret = add_merge_cache_extent(free, insert_start, len);
 			if (ret < 0)
@@ -2242,7 +2259,7 @@ static int calculate_available_space(struct btrfs_convert_context *cctx)
 		u64 len = cctx->total_bytes - cur_off;
 		u64 insert_start;
 
-		insert_start = round_up(cur_off, BTRFS_STRIPE_LEN);
+		insert_start = round_up(cur_off, ((sz_stripe) * (stripe_width)));
 
 		ret = add_merge_cache_extent(free, insert_start, len);
 		if (ret < 0)
diff --git a/btrfs-image.c b/btrfs-image.c
index 6feeb46..93deb43 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1406,6 +1406,8 @@ out:
 
 static void update_super_old(u8 *buffer)
 {
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct btrfs_super_block *super = (struct btrfs_super_block *)buffer;
 	struct btrfs_chunk *chunk;
 	struct btrfs_disk_key *key;
@@ -1425,7 +1427,7 @@ static void update_super_old(u8 *buffer)
 
 	btrfs_set_stack_chunk_length(chunk, (u64)-1);
 	btrfs_set_stack_chunk_owner(chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_stack_chunk_stripe_len(chunk, BTRFS_STRIPE_LEN);
+	btrfs_set_stack_chunk_stripe_len(chunk, ((sz_stripe) * (stripe_width)));
 	btrfs_set_stack_chunk_type(chunk, BTRFS_BLOCK_GROUP_SYSTEM);
 	btrfs_set_stack_chunk_io_align(chunk, sectorsize);
 	btrfs_set_stack_chunk_io_width(chunk, sectorsize);
diff --git a/btrfsck.h b/btrfsck.h
index e16f52f..aa72d75 100644
--- a/btrfsck.h
+++ b/btrfsck.h
@@ -89,7 +89,7 @@ struct chunk_record {
 	u64 owner;
 	u64 length;
 	u64 type_flags;
-	u64 stripe_len;
+	u32 stripe_len;
 	u16 num_stripes;
 	u16 sub_stripes;
 	u32 io_align;
diff --git a/chunk-recover.c b/chunk-recover.c
index 085e9a2..3be4afa 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -2211,6 +2211,8 @@ static int btrfs_rebuild_ordered_data_chunk_stripes(struct recover_control *rc,
 
 static int btrfs_recover_chunks(struct recover_control *rc)
 {
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct chunk_record *chunk;
 	struct block_group_record *bg;
 	struct block_group_record *next;
@@ -2237,10 +2239,10 @@ static int btrfs_recover_chunks(struct recover_control *rc)
 		chunk->generation = bg->generation;
 		chunk->length = bg->offset;
 		chunk->owner = BTRFS_CHUNK_TREE_OBJECTID;
-		chunk->stripe_len = BTRFS_STRIPE_LEN;
+		chunk->stripe_len = ((sz_stripe) * (stripe_width));
 		chunk->type_flags = bg->flags;
-		chunk->io_width = BTRFS_STRIPE_LEN;
-		chunk->io_align = BTRFS_STRIPE_LEN;
+		chunk->io_width = ((sz_stripe) * (stripe_width));
+		chunk->io_align = ((sz_stripe) * (stripe_width));
 		chunk->sector_size = rc->sectorsize;
 		chunk->sub_stripes = calc_sub_nstripes(bg->flags);
 
diff --git a/cmds-balance.c b/cmds-balance.c
index 708bbf4..9a2e4a2 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -75,6 +75,19 @@ static int parse_profiles(char *profiles, u64 *flags)
 	return 0;
 }
 
+static int parse_u32(const char *str, u32 *result)
+{
+	char *endptr;
+	u32 val;
+
+	val = strtoull(str, &endptr, 10);
+	if (*endptr)
+		return 1;
+
+	*result = val;
+	return 0;
+}
+
 static int parse_u64(const char *str, u64 *result)
 {
 	char *endptr;
@@ -334,6 +347,16 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 				return 1;
 			}
 			args->flags |= BTRFS_BALANCE_ARGS_STRIPES_RANGE;
+		} else if (!strcmp(this_char, "stripesize")) {
+			if (!value || !*value) {
+				error("the stripesize filter requires an argument");
+				return 1;
+			}
+			if (parse_u32(value, &args->sz_stripe)) {
+				error("invalid stripesize argument");
+				return 1;
+			}
+			args->flags |= BTRFS_BALANCE_ARGS_STRIPESIZE;
 		} else {
 			error("unrecognized balance option: %s", this_char);
 			return 1;
@@ -381,6 +404,9 @@ static void dump_balance_args(struct btrfs_balance_args *args)
 		printf(", stripes=");
 		print_range_u32(args->stripes_min, args->stripes_max);
 	}
+	if (args->flags & BTRFS_BALANCE_ARGS_STRIPESIZE) {
+		printf(", stripesize=%llu", (unsigned long long)args->sz_stripe);
+	}
 
 	printf("\n");
 }
@@ -400,11 +426,17 @@ static void dump_ioctl_balance_args(struct btrfs_ioctl_balance_args *args)
 		       (unsigned long long)args->meta.flags);
 		dump_balance_args(&args->meta);
 	}
+	if (args->flags & BTRFS_BALANCE_RAID) {
+		printf("  RAID (flags 0x%llx): ",
+			(unsigned long long)args->raid.flags);
+		dump_balance_args(&args->raid);
+	}
 	if (args->flags & BTRFS_BALANCE_SYSTEM) {
 		printf("  SYSTEM (flags 0x%llx): ",
 		       (unsigned long long)args->sys.flags);
 		dump_balance_args(&args->sys);
 	}
+
 }
 
 static int do_balance_v1(int fd)
@@ -507,6 +539,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"-d[filters]    act on data chunks",
 	"-m[filters]    act on metadata chunks",
 	"-s[filters]    act on system chunks (only under -f)",
+	"-r[filters]    act on datachange the RAID stripe size",
 	"-v             be verbose",
 	"-f             force reducing of metadata integrity",
 	"--full-balance do not print warning and do not delay start",
@@ -517,7 +550,7 @@ static int cmd_balance_start(int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	struct btrfs_balance_args *ptrs[] = { &args.data, &args.sys,
-						&args.meta, NULL };
+					      &args.raid, &args.meta, NULL };
 	int force = 0;
 	int verbose = 0;
 	unsigned start_flags = 0;
@@ -531,6 +564,7 @@ static int cmd_balance_start(int argc, char **argv)
 		static const struct option longopts[] = {
 			{ "data", optional_argument, NULL, 'd'},
 			{ "metadata", optional_argument, NULL, 'm' },
+			{ "raid", required_argument, NULL, 'r' },
 			{ "system", optional_argument, NULL, 's' },
 			{ "force", no_argument, NULL, 'f' },
 			{ "verbose", no_argument, NULL, 'v' },
@@ -539,7 +573,7 @@ static int cmd_balance_start(int argc, char **argv)
 			{ NULL, 0, NULL, 0 }
 		};
 
-		int opt = getopt_long(argc, argv, "d::s::m::fv", longopts, NULL);
+		int opt = getopt_long(argc, argv, "d::s::m::r::fv", longopts, NULL);
 		if (opt < 0)
 			break;
 
@@ -565,6 +599,13 @@ static int cmd_balance_start(int argc, char **argv)
 			if (parse_filters(optarg, &args.meta))
 				return 1;
 			break;
+		case 'r':
+			start_flags |= BALANCE_START_FILTERS;
+			args.flags |= BTRFS_BALANCE_RAID;
+
+			if (parse_filters(optarg, &args.raid))
+				return 1;
+			break;
 		case 'f':
 			force = 1;
 			break;
diff --git a/cmds-check.c b/cmds-check.c
index 9927fce..2bda5f2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4572,6 +4572,8 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 static int add_extent_rec(struct cache_tree *extent_cache,
 		struct extent_record *tmpl)
 {
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct extent_record *rec;
 	struct cache_extent *cache;
 	int ret = 0;
@@ -4650,7 +4652,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		/*
 		 * A metadata extent can't cross stripe_len boundary, otherwise
 		 * kernel scrub won't be able to handle it.
-		 * As now stripe_len is fixed to BTRFS_STRIPE_LEN, just check
+		 * As of now, stripe_len is fixed to BTRFS_STRIPE_LEN, just check
 		 * it.
 		 */
 		if (tmpl->metadata)
diff --git a/disk-io.c b/disk-io.c
index fbce506..5cff941 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1160,12 +1160,13 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
+	extern u32 sz_stripe;
 	int ret;
 
 	nodesize = btrfs_super_nodesize(sb);
 	leafsize = btrfs_super_leafsize(sb);
 	sectorsize = btrfs_super_sectorsize(sb);
-	stripesize = btrfs_super_stripesize(sb);
+	stripesize = sz_stripe;
 
 	__setup_root(nodesize, leafsize, sectorsize, stripesize,
 		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
@@ -1398,6 +1399,7 @@ static int check_super(struct btrfs_super_block *sb)
 	u32 crc;
 	u16 csum_type;
 	int csum_size;
+	extern u32 sz_stripe;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
 		error("superblock magic doesn't match");
@@ -1476,8 +1478,10 @@ static int check_super(struct btrfs_super_block *sb)
 		error("invalid bytes_used %llu", btrfs_super_bytes_used(sb));
 		goto error_out;
 	}
-	if ((btrfs_super_stripesize(sb) != 4096)
-		&& (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
+	/* No need to check if stripesize is a power of two, due to the means
+	 * of selecting stripesize.
+	 */
+	if (btrfs_super_stripesize(sb) != sz_stripe) {
 		error("invalid stripesize %u", btrfs_super_stripesize(sb));
 		goto error_out;
 	}
diff --git a/extent-tree.c b/extent-tree.c
index 5ca53fa..87662b6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2529,6 +2529,8 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 				     int data)
 {
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	u64 orig_search_start = search_start;
 	struct btrfs_root * root = orig_root->fs_info->extent_root;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -2608,7 +2610,7 @@ check_failed:
 	if (!(data & BTRFS_BLOCK_GROUP_DATA)) {
 		if (check_crossing_stripes(ins->objectid, num_bytes)) {
 			search_start = round_down(ins->objectid + num_bytes,
-						  BTRFS_STRIPE_LEN);
+						  ((sz_stripe) * (stripe_width)));
 			goto new_group;
 		}
 		block_group = btrfs_lookup_block_group(info, ins->objectid);
diff --git a/ioctl.h b/ioctl.h
index 5f18bcb..766abac 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -265,7 +265,10 @@ struct btrfs_balance_args {
 	};
 	__u32 stripes_min;
 	__u32 stripes_max;
-	__u64 unused[6];
+	__u32 sz_stripe;
+
+	/* pad to 128 bytes */
+	__u32 unused[9];
 } __attribute__ ((__packed__));
 
 /* report balance progress to userspace */
@@ -286,11 +289,14 @@ struct btrfs_ioctl_balance_args {
 
 	struct btrfs_balance_args data;		/* in/out */
 	struct btrfs_balance_args meta;		/* in/out */
+	struct btrfs_balance_args raid;		/* in/out */
 	struct btrfs_balance_args sys;		/* in/out */
 
 	struct btrfs_balance_progress stat;	/* out */
 
-	__u64 unused[72];			/* pad to 1k */
+	/* pad to 1k */
+	__u32 unused[(1024 - ((sizeof(struct btrfs_balance_args) * 4) + \
+			      (sizeof(struct btrfs_balance_progress)) + 16)) / 4];
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
diff --git a/mkfs.c b/mkfs.c
index 697bdc2..e9b5a47 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -322,6 +322,7 @@ static void print_usage(int ret)
 	fprintf(stderr, "\t-M|--mixed              mix metadata and data together\n");
 	fprintf(stderr, "\t-n|--nodesize SIZE      size of btree nodes\n");
 	fprintf(stderr, "\t-s|--sectorsize SIZE    min block allocation (may not mountable by current kernel)\n");
+	fprintf(stderr, "\t-z|--stripesize SIZE    size of RAID stripes\n");
 	fprintf(stderr, "\t-r|--rootdir DIR        the source directory\n");
 	fprintf(stderr, "\t-K|--nodiscard          do not perform whole device TRIM\n");
 	fprintf(stderr, "\t-O|--features LIST      comma separated list of filesystem features, use '-O list-all' to list features\n");
@@ -1336,6 +1337,8 @@ out:
 int main(int argc, char **argv)
 {
 	char *file;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 	char *label = NULL;
@@ -1384,6 +1387,7 @@ int main(int argc, char **argv)
 			{ "mixed", no_argument, NULL, 'M' },
 			{ "nodesize", required_argument, NULL, 'n' },
 			{ "sectorsize", required_argument, NULL, 's' },
+			{ "stripesize", required_argument, NULL, 'z' },
 			{ "data", required_argument, NULL, 'd' },
 			{ "version", no_argument, NULL, 'V' },
 			{ "rootdir", required_argument, NULL, 'r' },
@@ -1453,6 +1457,20 @@ int main(int argc, char **argv)
 				block_count = parse_size(optarg);
 				zero_end = 0;
 				break;
+			case 'z':
+				stripesize = parse_size(optarg);
+				if (((stripesize % 512) != 0) ||
+				    ((((stripesize % 512) % 2) != 0)
+				     |( stripesize != 512))  ||
+				    (stripesize < 512) ||
+				    (stripesize > 16384)) {
+					fprintf(stderr,
+						"Stripesize must be between 512" \
+						" & 16KiB. and a multiple of 512");
+				}
+				stripe_width = ((64 * 1024) / stripesize);
+				sz_stripe = stripesize;
+				break;
 			case 'V':
 				print_version();
 				break;
diff --git a/raid6.c b/raid6.c
index a6ee483..65cddc0 100644
--- a/raid6.c
+++ b/raid6.c
@@ -27,6 +27,9 @@
  * This is the C data type to use
  */
 
+u32 sz_stripe = 4096;
+u32 stripe_width = (16 * 1024);
+
 /* Change this from BITS_PER_LONG if there is something better... */
 #if BITS_PER_LONG == 64
 # define NBYTES(x) ((x) * 0x0101010101010101UL)
diff --git a/utils.c b/utils.c
index 578fdb0..64130b0 100644
--- a/utils.c
+++ b/utils.c
@@ -915,6 +915,8 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	u64 fs_bytenr;
 	u64 csum_bytenr;
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	/* Shouldn't happen */
 	BUG_ON(cache_tree_empty(used));
@@ -924,7 +926,7 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	 * Here we allocate a little larger space, to keep later
 	 * free space will be STRIPE_LEN aligned
 	 */
-	ret = reserve_free_space(free, BTRFS_STRIPE_LEN,
+	ret = reserve_free_space(free, ((sz_stripe) * (stripe_width)),
 				 &cfg->super_bytenr);
 	if (ret < 0)
 		goto out;
diff --git a/volumes.c b/volumes.c
index ccfa732..76040a6 100644
--- a/volumes.c
+++ b/volumes.c
@@ -675,8 +675,10 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 
 static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
 {
-	/* TODO, add a way to store the preferred stripe size */
-	return BTRFS_STRIPE_LEN;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+
+	return ((sz_stripe) * (stripe_width));
 }
 
 /*
@@ -805,7 +807,9 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int looped = 0;
 	int ret;
 	int index;
-	int stripe_len = BTRFS_STRIPE_LEN;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+	int stripe_len = ((sz_stripe) * (stripe_width));
 	struct btrfs_key key;
 	u64 offset;
 
@@ -1061,7 +1065,9 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	int sub_stripes = 0;
 	int ret;
 	int index;
-	int stripe_len = BTRFS_STRIPE_LEN;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+	int stripe_len = ((sz_stripe) * (stripe_width));
 	struct btrfs_key key;
 
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
@@ -1622,6 +1628,8 @@ static int btrfs_check_chunk_valid(struct btrfs_root *root,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -1645,7 +1653,7 @@ static int btrfs_check_chunk_valid(struct btrfs_root *root,
 		error("invalid chunk length %llu",  length);
 		return -EIO;
 	}
-	if (stripe_len != BTRFS_STRIPE_LEN) {
+	if (stripe_len != ((sz_stripe) * (stripe_width))) {
 		error("invalid chunk stripe length: %llu", stripe_len);
 		return -EIO;
 	}
diff --git a/volumes.h b/volumes.h
index d88e1cf..06b2f50 100644
--- a/volumes.h
+++ b/volumes.h
@@ -22,8 +22,6 @@
 #include "kerncompat.h"
 #include "ctree.h"
 
-#define BTRFS_STRIPE_LEN	(64 * 1024)
-
 struct btrfs_device {
 	struct list_head dev_list;
 	struct btrfs_root *dev_root;
@@ -119,8 +117,10 @@ struct map_lookup {
 #define BTRFS_BALANCE_DATA		(1ULL << 0)
 #define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
 #define BTRFS_BALANCE_METADATA		(1ULL << 2)
+#define BTRFS_BALANCE_RAID		(1ULL << 11)
 
 #define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_RAID |	    \
 					 BTRFS_BALANCE_SYSTEM |	    \
 					 BTRFS_BALANCE_METADATA)
 
@@ -139,6 +139,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_LIMIT_RANGE	(1ULL << 6)
 #define BTRFS_BALANCE_ARGS_STRIPES_RANGE (1ULL << 7)
 #define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 10)
+#define BTRFS_BALANCE_ARGS_STRIPESIZE   (1ULL << 11)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
@@ -158,8 +159,11 @@ struct map_lookup {
  */
 static inline int check_crossing_stripes(u64 start, u64 len)
 {
-	return (start / BTRFS_STRIPE_LEN) !=
-	       ((start + len - 1) / BTRFS_STRIPE_LEN);
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+
+	return (start / ((sz_stripe) * (stripe_width))) !=
+	       ((start + len - 1) / ((sz_stripe) * (stripe_width)));
 }
 
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-- 
2.5.5

