Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34208 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbcGVNnF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 09:43:05 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so6270449wma.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 06:43:05 -0700 (PDT)
From: Sanidhya Solanki <lkml.page@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Sanidhya Solanki <lkml.page@gmail.com>
Subject: [PATCH] btrfs: Change RAID stripesize to a user-configurable option
Date: Fri, 22 Jul 2016 09:42:47 -0400
Message-Id: <1469194967-27734-1-git-send-email-lkml.page@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds the kernel component of making the RAID stripesize user configurable.
Updates the kernel ioctl interface to account for new options.
Updates the existing implementations of RAID stripesize in metadata.
Make the stripesize an user-configurable option.
Convert the existing metadata option of stripesize into the basis for
this option.
Updates the kernel component of RAID stripesize management.
Update the RAID stripe block management.

Signed-off-by: Sanidhya Solanki <lkml.page@gmail.com>
---
 fs/btrfs/ctree.h                | 21 ++++++++++++++++++--
 fs/btrfs/disk-io.c              | 12 ++++++-----
 fs/btrfs/extent-tree.c          |  2 ++
 fs/btrfs/ioctl.c                |  2 ++
 fs/btrfs/raid56.c               | 19 ++++++++++++++++++
 fs/btrfs/scrub.c                |  6 ++++--
 fs/btrfs/super.c                | 12 ++++++-----
 fs/btrfs/volumes.c              | 44 ++++++++++++++++++++++++++++++++++-------
 fs/btrfs/volumes.h              |  3 +--
 include/trace/events/btrfs.h    |  2 ++
 include/uapi/linux/btrfs.h      | 13 ++++++++++--
 include/uapi/linux/btrfs_tree.h | 10 ++++++++--
 12 files changed, 119 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4274a7b..3fa4723 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2139,6 +2139,25 @@ static inline void btrfs_set_balance_data(struct extent_buffer *eb,
 	write_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
 }
 
+static inline void btrfs_balance_raid(struct extent_buffer *eb,
+				      struct btrfs_balance_item *bi,
+				      struct btrfs_disk_balance_args *ba)
+{
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+
+	sz_stripe = ba->sz_stripe;
+	stripe_width = ((64 * 1024) / sz_stripe);
+	read_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
+}
+
+static inline void btrfs_set_balance_raid(struct extent_buffer *eb,
+					struct btrfs_balance_item *bi,
+					struct btrfs_disk_balance_args *ba)
+{
+	write_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
+}
+
 static inline void btrfs_balance_meta(struct extent_buffer *eb,
 				      struct btrfs_balance_item *bi,
 				      struct btrfs_disk_balance_args *ba)
@@ -2233,8 +2252,6 @@ BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
-			 stripesize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60ce119..45344ed 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2523,6 +2523,8 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *tree_root;
 	struct btrfs_root *chunk_root;
 	int ret;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
@@ -2704,7 +2706,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	__setup_root(4096, 4096, 4096, tree_root,
+	__setup_root(4096, 4096, sz_stripe, tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	invalidate_bdev(fs_devices->latest_bdev);
@@ -2806,7 +2808,7 @@ int open_ctree(struct super_block *sb,
 
 	nodesize = btrfs_super_nodesize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
+	stripesize = sz_stripe;
 	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
 	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
 
@@ -4050,6 +4052,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
+	extern u32 sz_stripe;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
 		printk(KERN_ERR "BTRFS: no valid FS found\n");
@@ -4133,9 +4136,8 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 		       btrfs_super_bytes_used(sb));
 		ret = -EINVAL;
 	}
-	if (!is_power_of_2(btrfs_super_stripesize(sb))) {
-		btrfs_err(fs_info, "invalid stripesize %u",
-		       btrfs_super_stripesize(sb));
+	if (!is_power_of_2(sz_stripe)) {
+		btrfs_err(fs_info, "invalid stripesize %u", sz_stripe);
 		ret = -EINVAL;
 	}
 	if (btrfs_super_num_devices(sb) > (1UL << 31))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 82b912a..1903944 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7205,6 +7205,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 				     u64 hint_byte, struct btrfs_key *ins,
 				     u64 flags, int delalloc)
 {
+	extern u32 sz_stripe;
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
@@ -7534,6 +7535,7 @@ unclustered_alloc:
 			goto loop;
 		}
 checks:
+		root->stripesize = sz_stripe;
 		search_start = ALIGN(offset, root->stripesize);
 
 		/* move on to the next group */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0517356..d6e2617 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4614,6 +4614,7 @@ void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 
 	memcpy(&bargs->data, &bctl->data, sizeof(bargs->data));
 	memcpy(&bargs->meta, &bctl->meta, sizeof(bargs->meta));
+	memcpy(&bargs->raid, &bctl->raid, sizeof(bargs->raid));
 	memcpy(&bargs->sys, &bctl->sys, sizeof(bargs->sys));
 
 	if (lock) {
@@ -4729,6 +4730,7 @@ locked:
 	if (arg) {
 		memcpy(&bctl->data, &bargs->data, sizeof(bctl->data));
 		memcpy(&bctl->meta, &bargs->meta, sizeof(bctl->meta));
+		memcpy(&bctl->raid, &bargs->raid, sizeof(bctl->raid));
 		memcpy(&bctl->sys, &bargs->sys, sizeof(bctl->sys));
 
 		bctl->flags = bargs->flags;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f8b6d41..9598fbb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -44,6 +44,25 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 
+/*
+ * The BTRFS_STRIPE_LEN is replaced by the following two variables. These two
+ * options are multiplied by each other to obtain the BTRFS_STRIPE_LEN.
+ *
+ * This allows the stripe size and stripe superblock to be user-configurable.
+ * These options can be configured by using the BTrFS RAID stripe size balance
+ * option. After this configuration is used and changed, a data re-balance
+ * needs to be done to spread the stripe blocks over the drives according to
+ * the new stripe size.
+ *
+ * This variable will be the definitive means of manipulating stripe size of
+ * the RAID setup.
+ *
+ * The calculation to ensure that only a reasonable value is used will be done
+ * in userspace, before making the mkfs or balance ioctl.
+ */
+u32 sz_stripe = 4096;
+u32 stripe_width = (16 * 1024);
+
 /* set when additional merges to this rbio are not allowed */
 #define RBIO_RMW_LOCKED_BIT	1
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 70427ef..fd3f84f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3838,11 +3838,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	struct rcu_string *name;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
 
-	if (fs_info->chunk_root->nodesize > BTRFS_STRIPE_LEN) {
+	if (fs_info->chunk_root->nodesize > ((sz_stripe) * (stripe_width))) {
 		/*
 		 * in this case scrub is unable to calculate the checksum
 		 * the way scrub is implemented. Do not handle this
@@ -3850,7 +3852,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 */
 		btrfs_err(fs_info,
 			   "scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails",
-		       fs_info->chunk_root->nodesize, BTRFS_STRIPE_LEN);
+		       fs_info->chunk_root->nodesize, ((sz_stripe) * (stripe_width)));
 		return -EINVAL;
 	}
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60e7179..32bd72b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1874,6 +1874,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	u64 avail_space;
 	u64 used_space;
 	u64 min_stripe_size;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 	int min_stripes = 1, num_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
@@ -1912,9 +1914,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
-		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
+		min_stripe_size = 2 * ((sz_stripe) * (stripe_width));
 	else
-		min_stripe_size = BTRFS_STRIPE_LEN;
+		min_stripe_size = ((sz_stripe) * (stripe_width));
 
 	if (fs_info->alloc_start)
 		mutex_lock(&fs_devices->device_list_mutex);
@@ -1930,8 +1932,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		avail_space = device->total_bytes - device->bytes_used;
 
 		/* align with stripe_len */
-		avail_space = div_u64(avail_space, BTRFS_STRIPE_LEN);
-		avail_space *= BTRFS_STRIPE_LEN;
+		avail_space = div_u64(avail_space, ((sz_stripe) * (stripe_width)));
+		avail_space *= ((sz_stripe) * (stripe_width));
 
 		/*
 		 * In order to avoid overwriting the superblock on the drive,
@@ -1942,7 +1944,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 		/* user can set the offset in fs_info->alloc_start. */
 		if (fs_info->alloc_start &&
-		    fs_info->alloc_start + BTRFS_STRIPE_LEN <=
+		    fs_info->alloc_start + ((sz_stripe) * (stripe_width)) <=
 		    device->total_bytes) {
 			rcu_read_unlock();
 			skip_space = max(fs_info->alloc_start, skip_space);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 589f128..aa41dc1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3020,6 +3020,8 @@ static int insert_balance_item(struct btrfs_root *root,
 	btrfs_set_balance_data(leaf, item, &disk_bargs);
 	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->meta);
 	btrfs_set_balance_meta(leaf, item, &disk_bargs);
+	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->raid);
+	btrfs_set_balance_raid(leaf, item, &disk_bargs);
 	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->sys);
 	btrfs_set_balance_sys(leaf, item, &disk_bargs);
 
@@ -3083,6 +3085,8 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
 	 */
 	if (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT)
 		bctl->data.flags |= BTRFS_BALANCE_ARGS_SOFT;
+	if (bctl->raid.flags & BTRFS_BALANCE_ARGS_CONVERT)
+		bctl->raid.flags |= BTRFS_BALANCE_ARGS_SOFT;
 	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT)
 		bctl->sys.flags |= BTRFS_BALANCE_ARGS_SOFT;
 	if (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT)
@@ -3101,6 +3105,12 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
 		bctl->data.flags |= BTRFS_BALANCE_ARGS_USAGE;
 		bctl->data.usage = 90;
 	}
+	if (!(bctl->raid.flags & BTRFS_BALANCE_ARGS_USAGE) &&
+	    !(bctl->raid.flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
+	    !(bctl->raid.flags & BTRFS_BALANCE_ARGS_CONVERT)) {
+		bctl->raid.flags |= BTRFS_BALANCE_ARGS_USAGE;
+		bctl->raid.usage = 90;
+	}
 	if (!(bctl->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
 	    !(bctl->sys.flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
 	    !(bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT)) {
@@ -3337,6 +3347,8 @@ static int should_balance_chunk(struct btrfs_root *root,
 
 	if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
 		bargs = &bctl->data;
+	else if (chunk_type & BTRFS_BLOCK_GROUP_RAID)
+		bargs = &bctl->raid;
 	else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
 		bargs = &bctl->sys;
 	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
@@ -3433,9 +3445,11 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	/* The single value limit and min/max limits use the same bytes in the */
 	u64 limit_data = bctl->data.limit;
 	u64 limit_meta = bctl->meta.limit;
+	u64 limit_raid = bctl->raid.limit;
 	u64 limit_sys = bctl->sys.limit;
 	u32 count_data = 0;
 	u32 count_meta = 0;
+	u32 count_raid = 0;
 	u32 count_sys = 0;
 	int chunk_reserved = 0;
 	u64 bytes_used = 0;
@@ -3485,6 +3499,7 @@ again:
 		 */
 		bctl->data.limit = limit_data;
 		bctl->meta.limit = limit_meta;
+		bctl->raid.limit = limit_raid;
 		bctl->sys.limit = limit_sys;
 	}
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
@@ -3555,6 +3570,8 @@ again:
 
 			if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
 				count_data++;
+			else if (chunk_type & BTRFS_BLOCK_GROUP_RAID)
+				count_raid++;
 			else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
 				count_sys++;
 			else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
@@ -3571,6 +3588,8 @@ again:
 					count_data < bctl->data.limit_min)
 				|| ((chunk_type & BTRFS_BLOCK_GROUP_METADATA) &&
 					count_meta < bctl->meta.limit_min)
+				|| ((chunk_type & BTRFS_BLOCK_GROUP_RAID) &&
+					count_raid < bctl->raid.limit_min)
 				|| ((chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) &&
 					count_sys < bctl->sys.limit_min)) {
 			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
@@ -3758,6 +3777,13 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		ret = -EINVAL;
 		goto out;
 	}
+	if (validate_convert_profile(&bctl->raid, allowed)) {
+		btrfs_err(fs_info,
+			   "unable to start balance with target RAID profile %llu",
+		       bctl->raid.target);
+		ret = -EINVAL;
+		goto out;
+	}
 	if (validate_convert_profile(&bctl->sys, allowed)) {
 		btrfs_err(fs_info,
 			   "unable to start balance with target system profile %llu",
@@ -3937,6 +3963,8 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
 	btrfs_balance_meta(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->meta, &disk_bargs);
+	btrfs_balance_raid(leaf, item, &disk_bargs);
+	btrfs_disk_balance_args_to_cpu(&bctl->raid, &disk_bargs);
 	btrfs_balance_sys(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
 
@@ -4550,7 +4578,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_chunk_size;
 	u64 stripe_size;
 	u64 num_bytes;
-	u64 raid_stripe_len = BTRFS_STRIPE_LEN;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
+	u64 raid_stripe_len = ((sz_stripe) * (stripe_width));
 	int ndevs;
 	int i;
 	int j;
@@ -4648,7 +4678,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (ret == 0)
 			max_avail = max_stripe_size * dev_stripes;
 
-		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
+		if (max_avail < ((sz_stripe) * (stripe_width)) * dev_stripes)
 			continue;
 
 		if (ndevs == fs_devices->rw_devices) {
@@ -4693,13 +4723,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	data_stripes = num_stripes / ncopies;
 
 	if (type & BTRFS_BLOCK_GROUP_RAID5) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
-						extent_root->stripesize);
+		raid_stripe_len = find_raid56_stripe_len(ndevs - 1, sz_stripe);
 		data_stripes = num_stripes - 1;
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID6) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 2,
-						extent_root->stripesize);
+		raid_stripe_len = find_raid56_stripe_len(ndevs - 2, sz_stripe);
 		data_stripes = num_stripes - 2;
 	}
 
@@ -6269,6 +6297,8 @@ static int btrfs_check_chunk_valid(struct btrfs_root *root,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
+	extern u32 sz_stripe;
+	extern u32 stripe_width;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -6296,7 +6326,7 @@ static int btrfs_check_chunk_valid(struct btrfs_root *root,
 			"invalid chunk length %llu", length);
 		return -EIO;
 	}
-	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
+	if (!is_power_of_2(stripe_len) || stripe_len != ((sz_stripe) * (stripe_width))) {
 		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
 			  stripe_len);
 		return -EIO;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0ac90f8..f383d26 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -26,8 +26,6 @@
 
 extern struct mutex uuid_mutex;
 
-#define BTRFS_STRIPE_LEN	SZ_64K
-
 struct buffer_head;
 struct btrfs_pending_bios {
 	struct bio *head;
@@ -364,6 +362,7 @@ struct btrfs_balance_control {
 
 	struct btrfs_balance_args data;
 	struct btrfs_balance_args meta;
+	struct btrfs_balance_args raid;
 	struct btrfs_balance_args sys;
 
 	u64 flags;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e90e82a..7295ae7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -56,6 +56,7 @@ struct btrfs_qgroup_extent_record;
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
+	{ BTRFS_BLOCK_GROUP_RAID,	"RAID"},	\
 	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
 	{ BTRFS_BLOCK_GROUP_METADATA,	"METADATA"},	\
 	{ BTRFS_BLOCK_GROUP_RAID0,	"RAID0"}, 	\
@@ -622,6 +623,7 @@ DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
 #define show_chunk_type(type)					\
 	__print_flags(type, "|",				\
 		{ BTRFS_BLOCK_GROUP_DATA, 	"DATA"	},	\
+		{ BTRFS_BLOCK_GROUP_RAID, 	"RAID"},	\
 		{ BTRFS_BLOCK_GROUP_SYSTEM, 	"SYSTEM"},	\
 		{ BTRFS_BLOCK_GROUP_METADATA, 	"METADATA"},	\
 		{ BTRFS_BLOCK_GROUP_RAID0, 	"RAID0" },	\
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 2bdd1e3..3c62b84 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -316,8 +316,10 @@ struct btrfs_balance_args {
 	 */
 	__le32 stripes_min;
 	__le32 stripes_max;
+	__le32 sz_stripes;
 
-	__u64 unused[6];
+	/* pad to 128 bytes */
+	__u32 unused[9];
 } __attribute__ ((__packed__));
 
 /* report balance progress to userspace */
@@ -340,8 +342,10 @@ struct btrfs_balance_progress {
 #define BTRFS_BALANCE_DATA		(1ULL << 0)
 #define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
 #define BTRFS_BALANCE_METADATA		(1ULL << 2)
+#define BTRFS_BALANCE_RAID		(1ULL << 5)
 
 #define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_RAID |	    \
 					 BTRFS_BALANCE_SYSTEM |	    \
 					 BTRFS_BALANCE_METADATA)
 
@@ -365,6 +369,7 @@ struct btrfs_balance_progress {
 #define BTRFS_BALANCE_ARGS_LIMIT_RANGE	(1ULL << 6)
 #define BTRFS_BALANCE_ARGS_STRIPES_RANGE (1ULL << 7)
 #define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 10)
+#define BTRFS_BALANCE_ARGS_STRIPESIZE (1ULL << 11)
 
 #define BTRFS_BALANCE_ARGS_MASK			\
 	(BTRFS_BALANCE_ARGS_PROFILES |		\
@@ -375,6 +380,7 @@ struct btrfs_balance_progress {
 	 BTRFS_BALANCE_ARGS_LIMIT |		\
 	 BTRFS_BALANCE_ARGS_LIMIT_RANGE |	\
 	 BTRFS_BALANCE_ARGS_STRIPES_RANGE |	\
+	 BTRFS_BALANCE_ARGS_STRIPESIZE |	\
 	 BTRFS_BALANCE_ARGS_USAGE_RANGE)
 
 /*
@@ -402,11 +408,14 @@ struct btrfs_ioctl_balance_args {
 
 	struct btrfs_balance_args data;		/* in/out */
 	struct btrfs_balance_args meta;		/* in/out */
+	struct btrfs_balance_args raid;		/* in/out */
 	struct btrfs_balance_args sys;		/* in/out */
 
 	struct btrfs_balance_progress stat;	/* out */
 
-	__u64 unused[72];			/* pad to 1k */
+	/* pad to 1K bytes */
+	__u32 unused[(1024 - ((sizeof(struct btrfs_balance_args) * 4) + \
+			      (sizeof(struct btrfs_balance_progress)) + 16)) / 4];
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index d5ad15a..666f709a 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -707,8 +707,10 @@ struct btrfs_disk_balance_args {
 	 */
 	__le32 stripes_min;
 	__le32 stripes_max;
+	__le32 sz_stripe;
 
-	__le64 unused[6];
+	/* pad to 128 bytes */
+	__le32 unused[9];
 } __attribute__ ((__packed__));
 
 /*
@@ -721,9 +723,11 @@ struct btrfs_balance_item {
 
 	struct btrfs_disk_balance_args data;
 	struct btrfs_disk_balance_args meta;
+	struct btrfs_disk_balance_args raid;
 	struct btrfs_disk_balance_args sys;
 
-	__le64 unused[4];
+	/* pad to 1K bytes */
+	__u32 unused[(1024 - ((sizeof(struct btrfs_balance_args) * 4) + 8)) / 4];
 } __attribute__ ((__packed__));
 
 #define BTRFS_FILE_EXTENT_INLINE 0
@@ -823,6 +827,7 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
 #define BTRFS_BLOCK_GROUP_METADATA	(1ULL << 2)
+#define BTRFS_BLOCK_GROUP_RAID		(1ULL << 9)
 #define BTRFS_BLOCK_GROUP_RAID0		(1ULL << 3)
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
@@ -844,6 +849,7 @@ enum btrfs_raid_types {
 };
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
+					 BTRFS_BLOCK_GROUP_RAID |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
 					 BTRFS_BLOCK_GROUP_METADATA)
 
-- 
2.5.5

