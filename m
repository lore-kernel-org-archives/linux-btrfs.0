From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC][PATCH 2/2] Btrfs: change the calculation of available space
 since the data profile can be degenerated
Date: Tue, 17 Jan 2012 18:03:49 +0800
Message-ID: <4F154785.30304@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since the data profile can be degenerated(RAID10 -> RAID1 -> DUP, RAID0 ->
SINGLE), btrfs can utilize almost the whole disk space, we can simplify the
calculation of the available space in btrfs_statfs(). The new method just
ignore the disk space(one BTRFS_STRIPE_LEN at most) that can not be used to
allocate a DUP chunk, the other space will be considered as the available
space, and be count.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c |  105 +++++++++++------------------------------------------
 1 files changed, 22 insertions(+), 83 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 34a8b61..0284620 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1039,32 +1039,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
-/* Used to sort the devices by max_avail(descending sort) */
-static int btrfs_cmp_device_free_bytes(const void *dev_info1,
-				       const void *dev_info2)
-{
-	if (((struct btrfs_device_info *)dev_info1)->max_avail >
-	    ((struct btrfs_device_info *)dev_info2)->max_avail)
-		return -1;
-	else if (((struct btrfs_device_info *)dev_info1)->max_avail <
-		 ((struct btrfs_device_info *)dev_info2)->max_avail)
-		return 1;
-	else
-	return 0;
-}
-
-/*
- * sort the devices by max_avail, in which max free extent size of each device
- * is stored.(Descending Sort)
- */
-static inline void btrfs_descending_sort_devices(
-					struct btrfs_device_info *devices,
-					size_t nr_devices)
-{
-	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
-	     btrfs_cmp_device_free_bytes, NULL);
-}
-
 /*
  * The helper to calc the free space on the devices that can be used to store
  * file data.
@@ -1072,7 +1046,6 @@ static inline void btrfs_descending_sort_devices(
 static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 skip_space;
@@ -1080,31 +1053,12 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	u64 avail_space;
 	u64 used_space;
 	u64 min_stripe_size;
-	int min_stripes = 1, num_stripes = 1;
-	int i = 0, nr_devices;
 	int ret;
 
-	nr_devices = fs_info->fs_devices->open_devices;
-	BUG_ON(!nr_devices);
-
-	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
-			       GFP_NOFS);
-	if (!devices_info)
-		return -ENOMEM;
+	*free_bytes = 0;
 
 	/* calc min stripe number for data space alloction */
 	type = btrfs_get_alloc_profile(root, 1);
-	if (type & BTRFS_BLOCK_GROUP_RAID0) {
-		min_stripes = 2;
-		num_stripes = nr_devices;
-	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
-		min_stripes = 2;
-		num_stripes = 2;
-	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
-		min_stripes = 4;
-		num_stripes = 4;
-	}
-
 	if (type & BTRFS_BLOCK_GROUP_DUP)
 		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
 	else
@@ -1117,8 +1071,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		avail_space = device->total_bytes - device->bytes_used;
 
 		/* align with stripe_len */
-		do_div(avail_space, BTRFS_STRIPE_LEN);
-		avail_space *= BTRFS_STRIPE_LEN;
+		avail_space = round_down(avail_space, BTRFS_STRIPE_LEN);
 
 		/*
 		 * In order to avoid overwritting the superblock on the drive,
@@ -1139,10 +1092,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		 */
 		ret = btrfs_account_dev_extents_size(device, 0, skip_space - 1,
 						     &used_space);
-		if (ret) {
-			kfree(devices_info);
+		if (ret)
 			return ret;
-		}
 
 		/* calc the free space in [0, skip_space - 1] */
 		skip_space -= used_space;
@@ -1156,40 +1107,28 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		else
 			avail_space = 0;
 
-		if (avail_space < min_stripe_size)
-			continue;
-
-		devices_info[i].dev = device;
-		devices_info[i].max_avail = avail_space;
-
-		i++;
+		avail_space = round_down(avail_space, min_stripe_size);
+		*free_bytes += avail_space;
 	}
 
-	nr_devices = i;
-
-	btrfs_descending_sort_devices(devices_info, nr_devices);
-
-	i = nr_devices - 1;
-	avail_space = 0;
-	while (nr_devices >= min_stripes) {
-		if (num_stripes > nr_devices)
-			num_stripes = nr_devices;
-
-		if (devices_info[i].max_avail >= min_stripe_size) {
-			int j;
-			u64 alloc_size;
-
-			avail_space += devices_info[i].max_avail * num_stripes;
-			alloc_size = devices_info[i].max_avail;
-			for (j = i + 1 - num_stripes; j <= i; j++)
-				devices_info[j].max_avail -= alloc_size;
-		}
-		i--;
-		nr_devices--;
-	}
+	/*
+	 * If there is no enough disk space for new RAID chunk allocation,
+	 * the chunk allocator will degenerate the profile:
+	 *   RAID0 -> SINGLE
+	 *   RAID10 -> RAID1 -> DUP
+	 *
+	 * So if the profile is RAID0, the profile will be degenerated to
+	 * SINGLE at last, and we can utilize the whole free disk space.
+	 * Note: aligned with BTRFS_STRIPE_LEN, it is dealt with above, we
+	 * needn't do anything here.
+	 *
+	 * If the profile is RAID1 or RAID10, the profile will be DUP at last.
+	 * So the free size must be even times BTRFS_STRIPE_LEN.
+	 */
+	if (type & (BTRFS_BLOCK_GROUP_RAID1 |
+		    BTRFS_BLOCK_GROUP_RAID10))
+		*free_bytes = round_down(*free_bytes, 2 * BTRFS_STRIPE_LEN);
 
-	kfree(devices_info);
-	*free_bytes = avail_space;
 	return 0;
 }
 
-- 
1.7.6.5
