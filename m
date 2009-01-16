From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH resend] Btrfs: simplify iteration codes
Date: Fri, 16 Jan 2009 23:32:14 +0800
Message-ID: <4970a883.160d6e0a.0a43.ffffd857@mx.google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Merge list_for_each* and list_entry to list_for_each_entry*

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..aedfcec 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1136,7 +1136,6 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 {
 	struct btrfs_fs_info *info = (struct btrfs_fs_info *)congested_data;
 	int ret = 0;
-	struct list_head *cur;
 	struct btrfs_device *device;
 	struct backing_dev_info *bdi;
 #if 0
@@ -1144,8 +1143,7 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 	    btrfs_congested_async(info, 0))
 		return 1;
 #endif
-	list_for_each(cur, &info->fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
 		bdi = blk_get_backing_dev_info(device->bdev);
@@ -1163,13 +1161,11 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
  */
 static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
-	struct list_head *cur;
 	struct btrfs_device *device;
 	struct btrfs_fs_info *info;
 
 	info = (struct btrfs_fs_info *)bdi->unplug_io_data;
-	list_for_each(cur, &info->fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
 		if (!device->bdev)
 			continue;
 
@@ -1995,7 +1991,6 @@ static int write_dev_supers(struct btrfs_device *device,
 
 int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
-	struct list_head *cur;
 	struct list_head *head = &root->fs_info->fs_devices->devices;
 	struct btrfs_device *dev;
 	struct btrfs_super_block *sb;
@@ -2011,8 +2006,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 
 	sb = &root->fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (!dev->bdev) {
 			total_errors++;
 			continue;
@@ -2045,8 +2039,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	}
 
 	total_errors = 0;
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (!dev->bdev)
 			continue;
 		if (!dev->in_fs_metadata || !dev->writeable)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 293da65..c8815c1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -326,10 +326,8 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
 	struct list_head *head = &info->space_info;
-	struct list_head *cur;
 	struct btrfs_space_info *found;
-	list_for_each(cur, head) {
-		found = list_entry(cur, struct btrfs_space_info, list);
+	list_for_each_entry(found, head, list) {
 		if (found->flags == flags)
 			return found;
 	}
@@ -3014,7 +3012,6 @@ loop_check:
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 {
 	struct btrfs_block_group_cache *cache;
-	struct list_head *l;
 
 	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
@@ -3022,8 +3019,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 	       (info->full) ? "" : "not ");
 
 	down_read(&info->groups_sem);
-	list_for_each(l, &info->block_groups) {
-		cache = list_entry(l, struct btrfs_block_group_cache, list);
+	list_for_each_entry(cache, &info->block_groups, list) {
 		spin_lock(&cache->lock);
 		printk(KERN_INFO "block group %llu has %llu bytes, %llu used "
 		       "%llu pinned %llu reserved\n",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8adfe05..72c9277 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1324,12 +1324,11 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 			     struct inode *inode, u64 file_offset,
 			     struct list_head *list)
 {
-	struct list_head *cur;
 	struct btrfs_ordered_sum *sum;
 
 	btrfs_set_trans_block_group(trans, inode);
-	list_for_each(cur, list) {
-		sum = list_entry(cur, struct btrfs_ordered_sum, list);
+
+	list_for_each_entry(sum, list, list) {
 		btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a209401..77c2411 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -613,7 +613,6 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	struct btrfs_sector_sum *sector_sums;
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
-	struct list_head *cur;
 	unsigned long num_sectors;
 	unsigned long i;
 	u32 sectorsize = BTRFS_I(inode)->root->sectorsize;
@@ -624,8 +623,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 		return 1;
 
 	mutex_lock(&tree->mutex);
-	list_for_each_prev(cur, &ordered->list) {
-		ordered_sum = list_entry(cur, struct btrfs_ordered_sum, list);
+	list_for_each_entry_reverse(ordered_sum, &ordered->list, list) {
 		if (disk_bytenr >= ordered_sum->bytenr) {
 			num_sectors = ordered_sum->len / sectorsize;
 			sector_sums = ordered_sum->sums;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8a08f94..919172d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -852,11 +852,9 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_pending_snapshot *pending;
 	struct list_head *head = &trans->transaction->pending_snapshots;
-	struct list_head *cur;
 	int ret;
 
-	list_for_each(cur, head) {
-		pending = list_entry(cur, struct btrfs_pending_snapshot, list);
+	list_for_each_entry(pending, head, list) {
 		ret = create_pending_snapshot(trans, fs_info, pending);
 		BUG_ON(ret);
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..df88c91 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -104,10 +104,8 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 						   u64 devid, u8 *uuid)
 {
 	struct btrfs_device *dev;
-	struct list_head *cur;
 
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid &&
 		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
 			return dev;
@@ -118,11 +116,9 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 
 static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
-	struct list_head *cur;
 	struct btrfs_fs_devices *fs_devices;
 
-	list_for_each(cur, &fs_uuids) {
-		fs_devices = list_entry(cur, struct btrfs_fs_devices, list);
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
 		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
 	}
@@ -345,13 +341,11 @@ error:
 int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct list_head *tmp;
-	struct list_head *cur;
-	struct btrfs_device *device;
+	struct btrfs_device *device, *next;
 
 	mutex_lock(&uuid_mutex);
 again:
-	list_for_each_safe(cur, tmp, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (device->in_fs_metadata)
 			continue;
 
@@ -382,14 +376,12 @@ again:
 
 static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct list_head *cur;
 	struct btrfs_device *device;
 
 	if (--fs_devices->opened > 0)
 		return 0;
 
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		if (device->bdev) {
 			close_bdev_exclusive(device->bdev, device->mode);
 			fs_devices->open_devices--;
@@ -438,7 +430,6 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 {
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
-	struct list_head *cur;
 	struct btrfs_device *device;
 	struct block_device *latest_bdev = NULL;
 	struct buffer_head *bh;
@@ -449,8 +440,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	int seeding = 1;
 	int ret = 0;
 
-	list_for_each(cur, head) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, head, dev_list) {
 		if (device->bdev)
 			continue;
 		if (!device->name)
@@ -1016,14 +1006,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (strcmp(device_path, "missing") == 0) {
-		struct list_head *cur;
 		struct list_head *devices;
 		struct btrfs_device *tmp;
 
 		device = NULL;
 		devices = &root->fs_info->fs_devices->devices;
-		list_for_each(cur, devices) {
-			tmp = list_entry(cur, struct btrfs_device, dev_list);
+		list_for_each_entry(tmp, devices, dev_list) {
 			if (tmp->in_fs_metadata && !tmp->bdev) {
 				device = tmp;
 				break;
@@ -1279,7 +1267,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct block_device *bdev;
-	struct list_head *cur;
 	struct list_head *devices;
 	struct super_block *sb = root->fs_info->sb;
 	u64 total_bytes;
@@ -1303,8 +1290,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	mutex_lock(&root->fs_info->volume_mutex);
 
 	devices = &root->fs_info->fs_devices->devices;
-	list_for_each(cur, devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, devices, dev_list) {
 		if (device->bdev == bdev) {
 			ret = -EEXIST;
 			goto error;
@@ -1703,7 +1689,6 @@ static u64 div_factor(u64 num, int factor)
 int btrfs_balance(struct btrfs_root *dev_root)
 {
 	int ret;
-	struct list_head *cur;
 	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
 	struct btrfs_device *device;
 	u64 old_size;
@@ -1722,8 +1707,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	dev_root = dev_root->fs_info->dev_root;
 
 	/* step one make some room on all the devices */
-	list_for_each(cur, devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(device, devices, dev_list) {
 		old_size = device->total_bytes;
 		size_to_free = div_factor(old_size, 1);
 		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);

