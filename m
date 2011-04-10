From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 7/8] btrfs: Replication-type information
Date: Sun, 10 Apr 2011 22:06:10 +0100
Message-ID: <1302469571-12605-8-git-send-email-hugo@carfax.org.uk>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

There are a few places in btrfs where knowledge of the various
parameters of a replication type is needed. Factor this out into a
single function which can supply all the relevant information.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/super.c   |   16 +++-----
 fs/btrfs/volumes.c |   97 +++++++++++++++++++++++++++++++++++-----------------
 fs/btrfs/volumes.h |   17 +++++++++
 3 files changed, 88 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d39a989..4341730 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -879,12 +879,12 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
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
 
@@ -898,12 +898,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
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
@@ -971,14 +966,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	i = nr_devices - 1;
 	avail_space = 0;
-	while (nr_devices >= min_stripes) {
+	while (nr_devices >= repl_info.devs_min) {
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * min_stripes;
+			avail_space += devices_info[i].max_avail
+			  * repl_info.devs_min;
 			alloc_size = devices_info[i].max_avail;
-			for (j = i + 1 - min_stripes; j <= i; j++)
+			for (j = i + 1 - repl_info.devs_min; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
 		}
 		i--;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 230d100..9216ad85 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -141,6 +141,52 @@ static void requeue_list(struct btrfs_pending_bios *pending_bios,
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
@@ -1248,6 +1294,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
+	struct btrfs_replication_info repl_info;
 	u64 all_avail;
 	u64 devid;
 	u64 num_devices;
@@ -1261,18 +1308,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
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
+			printk(KERN_ERR "btrfs: unable to go below four devices "
+				   "on raid10\n");
+		} else if (all_avail & BTRFS_BLOCK_GROUP_RAID1) {
+			printk(KERN_ERR "btrfs: unable to go below two "
+				   "devices on raid1\n");
+		}
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2037,6 +2082,7 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	struct extent_buffer *eb;
 	struct btrfs_chunk *chunk;
 	int i;
+	struct btrfs_replication_info replinfo;
 
 	/* No filter defined, everything matches */
 	if (!filter)
@@ -2050,6 +2096,8 @@ int balance_chunk_filter(struct btrfs_ioctl_balance_start *filter,
 	chunk = btrfs_item_ptr(eb, path->slots[0],
 						   struct btrfs_chunk);
 
+	btrfs_get_replication_info(&replinfo, btrfs_chunk_type(eb, chunk));
+
 	if (filter->flags & BTRFS_BALANCE_FILTER_CHUNK_TYPE) {
 		if ((btrfs_chunk_type(eb, chunk) & filter->chunk_type_mask)
 			!= filter->chunk_type)
@@ -2492,34 +2540,19 @@ static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
 				    u64 proposed_size, u64 type,
 				    int num_stripes, int small_stripe)
 {
-	int min_stripe_size = 1 * 1024 * 1024;
+	struct btrfs_replication_info repl_info;
 	u64 calc_size = proposed_size;
 	u64 max_chunk_size = calc_size;
-	int ncopies = 1;
 
-	if (type & (BTRFS_BLOCK_GROUP_RAID1 |
-		    BTRFS_BLOCK_GROUP_DUP |
-		    BTRFS_BLOCK_GROUP_RAID10))
-		ncopies = 2;
-
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
-		max_chunk_size = 10 * calc_size;
-		min_stripe_size = 64 * 1024 * 1024;
-	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		max_chunk_size = 256 * 1024 * 1024;
-		min_stripe_size = 32 * 1024 * 1024;
-	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		calc_size = 8 * 1024 * 1024;
-		max_chunk_size = calc_size * 2;
-		min_stripe_size = 1 * 1024 * 1024;
-	}
+	btrfs_get_replication_info(&repl_info, type);
+	max_chunk_size = repl_info.max_chunk_size;
 
 	/* we don't want a chunk larger than 10% of writeable space */
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-	if (calc_size * num_stripes > max_chunk_size * ncopies) {
-		calc_size = max_chunk_size * ncopies;
+	if (calc_size * num_stripes > max_chunk_size * repl_info.num_copies) {
+		calc_size = max_chunk_size * repl_info.num_copies;
 		do_div(calc_size, num_stripes);
 		do_div(calc_size, BTRFS_STRIPE_LEN);
 		calc_size *= BTRFS_STRIPE_LEN;
@@ -2527,7 +2560,7 @@ static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
 
 	/* we don't want tiny stripes */
 	if (!small_stripe)
-		calc_size = max_t(u64, min_stripe_size, calc_size);
+		calc_size = max_t(u64, repl_info.min_stripe_size, calc_size);
 
 	/*
 	 * we're about to do_div by the BTRFS_STRIPE_LEN so lets make sure
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 168771b..a94de82 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -146,6 +146,22 @@ struct btrfs_device_info {
 	u64 max_avail;
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
 /* Used to sort the devices by max_avail(descending sort) */
 int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
 
@@ -214,4 +230,5 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+void btrfs_get_replication_info(struct btrfs_replication_info *info, u64 type);
 #endif
-- 
1.7.2.5

