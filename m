From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v8 7/8] btrfs: Replication-type information
Date: Sun, 26 Jun 2011 21:36:54 +0100
Message-ID: <1309120615-18104-8-git-send-email-hugo@carfax.org.uk>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

There are a few places in btrfs where knowledge of the various
parameters of a replication type is needed. Factor this out into a
single function which can supply all the relevant information.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/super.c   |   16 ++---
 fs/btrfs/volumes.c |  155 +++++++++++++++++++++++++---------------------------
 fs/btrfs/volumes.h |   17 ++++++
 3 files changed, 98 insertions(+), 90 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0bb4ebb..2ea4e01 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -965,12 +965,12 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
+	struct btrfs_replication_info repl_info;
 	u64 skip_space;
 	u64 type;
 	u64 avail_space;
 	u64 used_space;
 	u64 min_stripe_size;
-	int min_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
 
@@ -984,12 +984,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	/* calc min stripe number for data space alloction */
 	type = btrfs_get_alloc_profile(root, 1);
-	if (type & BTRFS_BLOCK_GROUP_RAID0)
-		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID1)
-		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID10)
-		min_stripes = 4;
+	btrfs_get_replication_info(&repl_info, type);
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
 		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
@@ -1057,14 +1052,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	i = nr_devices - 1;
 	avail_space = 0;
-	while (nr_devices >= min_stripes) {
+	while (nr_devices >= repl_info.devs_min) {
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * min_stripes;
+			avail_space += devices_info[i].max_avail
+				* repl_info.devs_min;
 			alloc_size = devices_info[i].max_avail;
-			for (j = i + 1 - min_stripes; j <= i; j++)
+			for (j = i + 1 - repl_info.devs_min; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
 		}
 		i--;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 828aa34..fb11550 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -117,6 +117,52 @@ static void requeue_list(struct btrfs_pending_bios *pending_bios,
 		pending_bios->tail = tail;
 }
 
+void btrfs_get_replication_info(struct btrfs_replication_info *info,
+								u64 type)
+{
+	info->sub_stripes = 1;
+	info->dev_stripes = 1;
+	info->devs_increment = 1;
+	info->num_copies = 1;
+	info->devs_max = 0;	/* 0 == as many as possible */
+	info->devs_min = 1;
+
+	if (type & BTRFS_BLOCK_GROUP_DUP) {
+		info->dev_stripes = 2;
+		info->num_copies = 2;
+		info->devs_max = 1;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID0) {
+		info->devs_min = 2;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
+		info->devs_increment = 2;
+		info->num_copies = 2;
+		info->devs_max = 2;
+		info->devs_min = 2;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
+		info->sub_stripes = 2;
+		info->devs_increment = 2;
+		info->num_copies = 2;
+		info->devs_min = 4;
+	}
+
+	if (type & BTRFS_BLOCK_GROUP_DATA) {
+		info->max_stripe_size = 1024 * 1024 * 1024;
+		info->min_stripe_size = 64 * 1024 * 1024;
+		info->max_chunk_size = 10 * info->max_stripe_size;
+	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
+		info->max_stripe_size = 256 * 1024 * 1024;
+		info->min_stripe_size = 32 * 1024 * 1024;
+		info->max_chunk_size = info->max_stripe_size;
+	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		info->max_stripe_size = 8 * 1024 * 1024;
+		info->min_stripe_size = 1 * 1024 * 1024;
+		info->max_chunk_size = 2 * info->max_stripe_size;
+	} else {
+		printk(KERN_ERR "Block group is of an unknown usage type: not data, metadata or system.\n");
+		BUG_ON(1);
+	}
+}
+
 /*
  * we try to collect pending bios for a device so we don't get a large
  * number of procs sending bios down to the same device.  This greatly
@@ -1216,6 +1262,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
+	struct btrfs_replication_info repl_info;
 	struct btrfs_fs_devices *cur_devices;
 	u64 all_avail;
 	u64 devid;
@@ -1231,18 +1278,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->avail_system_alloc_bits |
 		root->fs_info->avail_metadata_alloc_bits;
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->num_devices <= 4) {
-		printk(KERN_ERR "btrfs: unable to go below four devices "
-		       "on raid10\n");
-		ret = -EINVAL;
-		goto out;
-	}
+	btrfs_get_replication_info(&repl_info, all_avail);
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->num_devices <= 2) {
-		printk(KERN_ERR "btrfs: unable to go below two "
-		       "devices on raid1\n");
+	if (root->fs_info->fs_devices->num_devices <= repl_info.devs_min) {
+		if (all_avail & BTRFS_BLOCK_GROUP_RAID10) {
+			printk(KERN_ERR "btrfs: unable to go below four "
+				   "devices on raid10\n");
+		} else if (all_avail & BTRFS_BLOCK_GROUP_RAID1) {
+			printk(KERN_ERR "btrfs: unable to go below two "
+				   "devices on raid1\n");
+		}
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2446,16 +2491,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	struct btrfs_device_info *devices_info = NULL;
+	struct btrfs_replication_info repl_info;
 	u64 total_avail;
 	int num_stripes;	/* total number of stripes to allocate */
-	int sub_stripes;	/* sub_stripes info for map */
-	int dev_stripes;	/* stripes per dev */
-	int devs_max;		/* max devs to use */
-	int devs_min;		/* min devs needed */
-	int devs_increment;	/* ndevs has to be a multiple of this */
-	int ncopies;		/* how many copies to data has */
 	int ret;
-	u64 max_stripe_size;
 	u64 max_chunk_size;
 	u64 stripe_size;
 	u64 num_bytes;
@@ -2472,56 +2511,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
 
-	sub_stripes = 1;
-	dev_stripes = 1;
-	devs_increment = 1;
-	ncopies = 1;
-	devs_max = 0;	/* 0 == as many as possible */
-	devs_min = 1;
-
-	/*
-	 * define the properties of each RAID type.
-	 * FIXME: move this to a global table and use it in all RAID
-	 * calculation code
-	 */
-	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
-		dev_stripes = 2;
-		ncopies = 2;
-		devs_max = 1;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		devs_min = 2;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
-		devs_increment = 2;
-		ncopies = 2;
-		devs_max = 2;
-		devs_min = 2;
-	} else if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		sub_stripes = 2;
-		devs_increment = 2;
-		ncopies = 2;
-		devs_min = 4;
-	} else {
-		devs_max = 1;
-	}
-
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
-		max_stripe_size = 1024 * 1024 * 1024;
-		max_chunk_size = 10 * max_stripe_size;
-	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		max_stripe_size = 256 * 1024 * 1024;
-		max_chunk_size = max_stripe_size;
-	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		max_stripe_size = 8 * 1024 * 1024;
-		max_chunk_size = 2 * max_stripe_size;
-	} else {
-		printk(KERN_ERR "btrfs: invalid chunk type 0x%llx requested\n",
-		       type);
-		BUG_ON(1);
-	}
+	btrfs_get_replication_info(&repl_info, type);
 
 	/* we don't want a chunk larger than 10% of writeable space */
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
-			     max_chunk_size);
+			     repl_info.max_chunk_size);
 
 	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
 			       GFP_NOFS);
@@ -2563,15 +2557,15 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		 */
 
 		ret = find_free_dev_extent(trans, device,
-					   max_stripe_size * dev_stripes,
+					   repl_info.max_stripe_size * repl_info.dev_stripes,
 					   &dev_offset, &max_avail);
 		if (ret && ret != -ENOSPC)
 			goto error;
 
 		if (ret == 0)
-			max_avail = max_stripe_size * dev_stripes;
+			max_avail = repl_info.max_stripe_size * repl_info.dev_stripes;
 
-		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
+		if (max_avail < BTRFS_STRIPE_LEN * repl_info.dev_stripes)
 			continue;
 
 		devices_info[ndevs].dev_offset = dev_offset;
@@ -2588,28 +2582,29 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	     btrfs_cmp_device_info, NULL);
 
 	/* round down to number of usable stripes */
-	ndevs -= ndevs % devs_increment;
+	ndevs -= ndevs % repl_info.devs_increment;
 
-	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
+	if (ndevs < repl_info.devs_increment * repl_info.sub_stripes
+		|| ndevs < repl_info.devs_min) {
 		ret = -ENOSPC;
 		goto error;
 	}
 
-	if (devs_max && ndevs > devs_max)
-		ndevs = devs_max;
+	if (repl_info.devs_max && ndevs > repl_info.devs_max)
+		ndevs = repl_info.devs_max;
 	/*
 	 * the primary goal is to maximize the number of stripes, so use as many
 	 * devices as possible, even if the stripes are not maximum sized.
 	 */
 	stripe_size = devices_info[ndevs-1].max_avail;
-	num_stripes = ndevs * dev_stripes;
+	num_stripes = ndevs * repl_info.dev_stripes;
 
-	if (stripe_size * num_stripes > max_chunk_size * ncopies) {
-		stripe_size = max_chunk_size * ncopies;
+	if (stripe_size * num_stripes > max_chunk_size * repl_info.num_copies) {
+		stripe_size = max_chunk_size * repl_info.num_copies;
 		do_div(stripe_size, num_stripes);
 	}
 
-	do_div(stripe_size, dev_stripes);
+	do_div(stripe_size, repl_info.dev_stripes);
 	do_div(stripe_size, BTRFS_STRIPE_LEN);
 	stripe_size *= BTRFS_STRIPE_LEN;
 
@@ -2621,8 +2616,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	map->num_stripes = num_stripes;
 
 	for (i = 0; i < ndevs; ++i) {
-		for (j = 0; j < dev_stripes; ++j) {
-			int s = i * dev_stripes + j;
+		for (j = 0; j < repl_info.dev_stripes; ++j) {
+			int s = i * repl_info.dev_stripes + j;
 			map->stripes[s].dev = devices_info[i].dev;
 			map->stripes[s].physical = devices_info[i].dev_offset +
 						   j * stripe_size;
@@ -2633,10 +2628,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	map->io_align = BTRFS_STRIPE_LEN;
 	map->io_width = BTRFS_STRIPE_LEN;
 	map->type = type;
-	map->sub_stripes = sub_stripes;
+	map->sub_stripes = repl_info.sub_stripes;
 
 	*map_ret = map;
-	num_bytes = stripe_size * (num_stripes / ncopies);
+	num_bytes = stripe_size * (num_stripes / repl_info.num_copies);
 
 	*stripe_size_out = stripe_size;
 	*num_bytes_out = num_bytes;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 08ec502..4fe9580 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -164,6 +164,22 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+/*
+ * Information about a the parameters of a replication strategy (RAID
+ * level)
+ */
+struct btrfs_replication_info {
+	u32 sub_stripes;
+	u32 dev_stripes;
+	u32 devs_increment;
+	u32 num_copies;
+	u32 devs_max;
+	u32 devs_min;
+	u64 max_stripe_size;
+	u64 min_stripe_size;
+	u64 max_chunk_size;
+};
+
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -217,4 +233,5 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+void btrfs_get_replication_info(struct btrfs_replication_info *info, u64 type);
 #endif
-- 
1.7.2.5

