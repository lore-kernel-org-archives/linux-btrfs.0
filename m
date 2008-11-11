From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 2/2] Seed device support
Date: Tue, 11 Nov 2008 21:25:10 +0800
Message-ID: <491987B6.7030907@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Seed device is a special btrfs with SEEDING super flag
set and can only be mounted in read-only mode. Seed
device allows peoples create new btrfs on top of it.
The new FS contain the same contents as the seed device,
but it can be mounted in read-write mode.

This patch has following things.

1) split code in btrfs_alloc_chunk into two parts. The
first part does all required works that make the new
allocated chunk useable, but not do any operation that
modifies the chunk tree. The second part does the left
works that need modify the chunk tree. This division is
for the bootstrap step of adding storage to the seed
device.

2) Update device management code to handle seed device.
Most changes in this patch falls within this category.
The basic idea is: For a FS grown from seed devices, its
seed devices are putted into a list. Seed devices are
opened on demand at mounting time. If any seed device is
missing or has been changed, btrfs kernel module will
refuse to mount the FS.

3) make btrfs_find_block_group not return NULL when all
block groups are read-only.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/ctree.c 4/fs/btrfs/ctree.c
--- 3/fs/btrfs/ctree.c	2008-10-31 04:15:01.000000000 +0800
+++ 4/fs/btrfs/ctree.c	2008-11-11 10:46:21.000000000 +0800
@@ -185,6 +185,10 @@ int btrfs_copy_root(struct btrfs_trans_h
 	btrfs_set_header_owner(cow, new_root_objectid);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
 
+	write_extent_buffer(cow, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(cow),
+			    BTRFS_FSID_SIZE);
+
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
 	kfree(new_root);
@@ -274,6 +278,10 @@ int noinline __btrfs_cow_block(struct bt
 	btrfs_set_header_owner(cow, root->root_key.objectid);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
 
+	write_extent_buffer(cow, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(cow),
+			    BTRFS_FSID_SIZE);
+
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
 		u32 nr_extents;
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2008-11-11 10:46:08.000000000 +0800
+++ 4/fs/btrfs/ctree.h	2008-11-11 10:46:21.000000000 +0800
@@ -177,6 +177,9 @@ struct btrfs_dev_item {
 	/* type and info about this device */
 	__le64 type;
 
+	/* expected generation for this device */
+	__le64 generation;
+
 	/* grouping information for allocation decisions */
 	__le32 dev_group;
 
@@ -188,6 +191,9 @@ struct btrfs_dev_item {
 
 	/* btrfs generated uuid for this device */
 	u8 uuid[BTRFS_UUID_SIZE];
+
+	/* uuid of FS who owns this device */
+	u8 fsid[BTRFS_UUID_SIZE];
 } __attribute__ ((__packed__));
 
 struct btrfs_stripe {
@@ -263,6 +269,7 @@ struct btrfs_header {
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
 
+#define BTRFS_SUPER_FLAG_SEEDING (1ULL << 32)
 
 /*
  * this is a very generous portion of the super block, giving us
@@ -278,7 +285,7 @@ struct btrfs_header {
 struct btrfs_super_block {
 	u8 csum[BTRFS_CSUM_SIZE];
 	/* the first 4 fields must match struct btrfs_header */
-	u8 fsid[16];    /* FS specific uuid */
+	u8 fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
 	__le64 bytenr; /* this block number */
 	__le64 flags;
 
@@ -941,6 +948,7 @@ BTRFS_SETGET_FUNCS(device_id, struct btr
 BTRFS_SETGET_FUNCS(device_group, struct btrfs_dev_item, dev_group, 32);
 BTRFS_SETGET_FUNCS(device_seek_speed, struct btrfs_dev_item, seek_speed, 8);
 BTRFS_SETGET_FUNCS(device_bandwidth, struct btrfs_dev_item, bandwidth, 8);
+BTRFS_SETGET_FUNCS(device_generation, struct btrfs_dev_item, generation, 64);
 
 BTRFS_SETGET_STACK_FUNCS(stack_device_type, struct btrfs_dev_item, type, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_device_total_bytes, struct btrfs_dev_item,
@@ -960,12 +968,19 @@ BTRFS_SETGET_STACK_FUNCS(stack_device_se
 			 seek_speed, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_device_bandwidth, struct btrfs_dev_item,
 			 bandwidth, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_device_generation, struct btrfs_dev_item,
+			 generation, 64);
 
 static inline char *btrfs_device_uuid(struct btrfs_dev_item *d)
 {
 	return (char *)d + offsetof(struct btrfs_dev_item, uuid);
 }
 
+static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
+{
+	return (char *)d + offsetof(struct btrfs_dev_item, fsid);
+}
+
 BTRFS_SETGET_FUNCS(chunk_length, struct btrfs_chunk, length, 64);
 BTRFS_SETGET_FUNCS(chunk_owner, struct btrfs_chunk, owner, 64);
 BTRFS_SETGET_FUNCS(chunk_stripe_len, struct btrfs_chunk, stripe_len, 64);
@@ -1661,6 +1676,7 @@ int btrfs_reloc_tree_cache_ref(struct bt
 			       struct extent_buffer *buf, u64 orig_start);
 int btrfs_add_dead_reloc_root(struct btrfs_root *root);
 int btrfs_cleanup_reloc_trees(struct btrfs_root *root);
+u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
diff -urp 3/fs/btrfs/disk-io.c 4/fs/btrfs/disk-io.c
--- 3/fs/btrfs/disk-io.c	2008-11-11 10:46:08.000000000 +0800
+++ 4/fs/btrfs/disk-io.c	2008-11-11 10:46:21.000000000 +0800
@@ -345,6 +345,25 @@ out:
 	return 0;
 }
 
+static int check_tree_block_fsid(struct btrfs_root *root,
+				 struct extent_buffer *eb)
+{
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	u8 fsid[BTRFS_UUID_SIZE];
+	int ret = 1;
+
+	read_extent_buffer(eb, fsid, (unsigned long)btrfs_header_fsid(eb),
+			   BTRFS_FSID_SIZE);
+	while (fs_devices) {
+		if (!memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE)) {
+			ret = 0;
+			break;
+		}
+		fs_devices = fs_devices->seed;
+	}
+	return ret;
+}
+
 int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state)
 {
@@ -382,9 +401,7 @@ int btree_readpage_end_io_hook(struct pa
 		ret = -EIO;
 		goto err;
 	}
-	if (memcmp_extent_buffer(eb, root->fs_info->fsid,
-				 (unsigned long)btrfs_header_fsid(eb),
-				 BTRFS_FSID_SIZE)) {
+	if (check_tree_block_fsid(root, eb)) {
 		printk("bad fsid on block %Lu\n", eb->start);
 		ret = -EIO;
 		goto err;
@@ -1558,9 +1575,11 @@ struct btrfs_root *open_ctree(struct sup
 	if (!btrfs_super_root(disk_super))
 		goto fail_sb_buffer;
 
-	err = btrfs_parse_options(tree_root, options);
-	if (err)
+	ret = btrfs_parse_options(tree_root, options);
+	if (ret) {
+		err = ret;
 		goto fail_sb_buffer;
+	}
 
 	/*
 	 * we need to start all the end_io workers up front because the
@@ -1610,18 +1629,6 @@ struct btrfs_root *open_ctree(struct sup
 	btrfs_start_workers(&fs_info->endio_write_workers,
 			    fs_info->thread_pool_size);
 
-	err = -EINVAL;
-	if (btrfs_super_num_devices(disk_super) > fs_devices->open_devices) {
-		printk("Btrfs: wanted %llu devices, but found %llu\n",
-		       (unsigned long long)btrfs_super_num_devices(disk_super),
-		       (unsigned long long)fs_devices->open_devices);
-		if (btrfs_test_opt(tree_root, DEGRADED))
-			printk("continuing in degraded mode\n");
-		else {
-			goto fail_sb_buffer;
-		}
-	}
-
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
 				    4 * 1024 * 1024 / PAGE_CACHE_SIZE);
@@ -1672,7 +1679,10 @@ struct btrfs_root *open_ctree(struct sup
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_chunk_tree(chunk_root);
 	mutex_unlock(&fs_info->chunk_mutex);
-	BUG_ON(ret);
+	if (ret) {
+		printk("btrfs: failed to read chunk tree on %s\n", sb->s_id);
+		goto fail_chunk_root;
+	}
 
 	btrfs_close_extra_devices(fs_devices);
 
@@ -1684,7 +1694,7 @@ struct btrfs_root *open_ctree(struct sup
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
 	if (!tree_root->node)
-		goto fail_sb_buffer;
+		goto fail_chunk_root;
 
 
 	ret = find_and_setup_root(tree_root, fs_info,
@@ -1753,6 +1763,8 @@ fail_extent_root:
 	free_extent_buffer(extent_root->node);
 fail_tree_root:
 	free_extent_buffer(tree_root->node);
+fail_chunk_root:
+	free_extent_buffer(chunk_root->node);
 fail_sys_array:
 fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->fixup_workers);
@@ -1823,9 +1835,10 @@ int write_all_supers(struct btrfs_root *
 			total_errors++;
 			continue;
 		}
-		if (!dev->in_fs_metadata)
+		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
+		btrfs_set_stack_device_generation(dev_item, 0);
 		btrfs_set_stack_device_type(dev_item, dev->type);
 		btrfs_set_stack_device_id(dev_item, dev->devid);
 		btrfs_set_stack_device_total_bytes(dev_item, dev->total_bytes);
@@ -1834,6 +1847,7 @@ int write_all_supers(struct btrfs_root *
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
@@ -1881,7 +1895,7 @@ int write_all_supers(struct btrfs_root *
 		dev = list_entry(cur, struct btrfs_device, dev_list);
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata)
+		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
 		BUG_ON(!dev->pending_io);
diff -urp 3/fs/btrfs/extent-tree.c 4/fs/btrfs/extent-tree.c
--- 3/fs/btrfs/extent-tree.c	2008-11-11 10:46:08.000000000 +0800
+++ 4/fs/btrfs/extent-tree.c	2008-11-11 11:33:34.000000000 +0800
@@ -346,7 +346,7 @@ __btrfs_find_block_group(struct btrfs_ro
 	if (search_start) {
 		struct btrfs_block_group_cache *shint;
 		shint = btrfs_lookup_first_block_group(info, search_start);
-		if (shint && block_group_bits(shint, data) && !shint->ro) {
+		if (shint && block_group_bits(shint, data)) {
 			spin_lock(&shint->lock);
 			used = btrfs_block_group_used(&shint->item);
 			if (used + shint->pinned + shint->reserved <
@@ -357,7 +357,7 @@ __btrfs_find_block_group(struct btrfs_ro
 			spin_unlock(&shint->lock);
 		}
 	}
-	if (hint && !hint->ro && block_group_bits(hint, data)) {
+	if (hint && block_group_bits(hint, data)) {
 		spin_lock(&hint->lock);
 		used = btrfs_block_group_used(&hint->item);
 		if (used + hint->pinned + hint->reserved <
@@ -383,7 +383,7 @@ again:
 		last = cache->key.objectid + cache->key.offset;
 		used = btrfs_block_group_used(&cache->item);
 
-		if (!cache->ro && block_group_bits(cache, data)) {
+		if (block_group_bits(cache, data)) {
 			free_check = div_factor(cache->key.offset, factor);
 			if (used + cache->pinned + cache->reserved <
 			    free_check) {
@@ -1326,9 +1326,9 @@ static void set_block_group_readonly(str
 	spin_unlock(&cache->space_info->lock);
 }
 
-static u64 reduce_alloc_profile(struct btrfs_root *root, u64 flags)
+u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
-	u64 num_devices = root->fs_info->fs_devices->num_devices;
+	u64 num_devices = root->fs_info->fs_devices->rw_devices;
 
 	if (num_devices == 1)
 		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0);
@@ -1360,13 +1360,11 @@ static int do_chunk_alloc(struct btrfs_t
 {
 	struct btrfs_space_info *space_info;
 	u64 thresh;
-	u64 start;
-	u64 num_bytes;
 	int ret = 0;
 
 	mutex_lock(&extent_root->fs_info->chunk_mutex);
 
-	flags = reduce_alloc_profile(extent_root, flags);
+	flags = btrfs_reduce_alloc_profile(extent_root, flags);
 
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
@@ -1396,16 +1394,11 @@ static int do_chunk_alloc(struct btrfs_t
 	}
 	spin_unlock(&space_info->lock);
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, flags);
 	if (ret) {
 printk("space info full %Lu\n", flags);
 		space_info->full = 1;
-		goto out;
 	}
-
-	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
-		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
-	BUG_ON(ret);
 out:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 	return ret;
@@ -2400,7 +2393,7 @@ static int __btrfs_reserve_extent(struct
 		data = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
 again:
-	data = reduce_alloc_profile(root, data);
+	data = btrfs_reduce_alloc_profile(root, data);
 	/*
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
@@ -4735,7 +4728,7 @@ static u64 update_block_group_flags(stru
 	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
-	num_devices = root->fs_info->fs_devices->num_devices;
+	num_devices = root->fs_info->fs_devices->rw_devices;
 	if (num_devices == 1) {
 		stripped |= BTRFS_BLOCK_GROUP_DUP;
 		stripped = flags & ~stripped;
@@ -5159,6 +5152,8 @@ int btrfs_read_block_groups(struct btrfs
 		BUG_ON(ret);
 
 		set_avail_alloc_bits(root->fs_info, cache->flags);
+		if (btrfs_chunk_readonly(root, cache->key.objectid))
+			set_block_group_readonly(cache);
 	}
 	ret = 0;
 error:
diff -urp 3/fs/btrfs/ioctl.c 4/fs/btrfs/ioctl.c
--- 3/fs/btrfs/ioctl.c	2008-11-11 10:46:08.000000000 +0800
+++ 4/fs/btrfs/ioctl.c	2008-11-11 10:46:21.000000000 +0800
@@ -405,7 +405,7 @@ static int btrfs_ioctl_resize(struct btr
 		devid = simple_strtoull(devstr, &end, 10);
 		printk(KERN_INFO "resizing devid %llu\n", devid);
 	}
-	device = btrfs_find_device(root, devid, NULL);
+	device = btrfs_find_device(root, devid, NULL, NULL);
 	if (!device) {
 		printk(KERN_INFO "resizer unable to find device %llu\n", devid);
 		ret = -EINVAL;
diff -urp 3/fs/btrfs/super.c 4/fs/btrfs/super.c
--- 3/fs/btrfs/super.c	2008-11-11 10:46:08.000000000 +0800
+++ 4/fs/btrfs/super.c	2008-11-11 10:46:21.000000000 +0800
@@ -431,6 +431,11 @@ static int btrfs_get_sb(struct file_syst
 	if (error)
 		goto error_free_subvol_name;
 
+	if (!(flags & MS_RDONLY) && fs_devices->rw_devices == 0) {
+		error = -EACCES;
+		goto error_close_devices;
+	}
+
 	bdev = fs_devices->latest_bdev;
 	s = sget(fs_type, btrfs_test_super, set_anon_super, fs_devices);
 	if (IS_ERR(s))
@@ -444,6 +449,7 @@ static int btrfs_get_sb(struct file_syst
 			goto error_close_devices;
 		}
 
+		btrfs_close_devices(fs_devices);
 	} else {
 		char b[BDEVNAME_SIZE];
 
@@ -512,6 +518,9 @@ static int btrfs_remount(struct super_bl
 		ret =  btrfs_commit_super(root);
 		WARN_ON(ret);
 	} else {
+		if (root->fs_info->fs_devices->rw_devices == 0)
+			return -EACCES;
+
 		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
 			return -EINVAL;
 
diff -urp 3/fs/btrfs/volumes.c 4/fs/btrfs/volumes.c
--- 3/fs/btrfs/volumes.c	2008-10-31 04:15:01.000000000 +0800
+++ 4/fs/btrfs/volumes.c	2008-11-11 14:01:21.000000000 +0800
@@ -40,6 +40,12 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+static int init_first_rw_device(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_device *device);
+static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
+
+
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -69,25 +75,31 @@ static void unlock_chunks(struct btrfs_r
 int btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
-	struct list_head *uuid_cur;
-	struct list_head *devices_cur;
 	struct btrfs_device *dev;
 
-	list_for_each(uuid_cur, &fs_uuids) {
-		fs_devices = list_entry(uuid_cur, struct btrfs_fs_devices,
-					list);
+	while (!list_empty(&fs_uuids)) {
+		fs_devices = list_entry(fs_uuids.next,
+					struct btrfs_fs_devices, list);
+		list_del(&fs_devices->list);
 		while(!list_empty(&fs_devices->devices)) {
-			devices_cur = fs_devices->devices.next;
-			dev = list_entry(devices_cur, struct btrfs_device,
-					 dev_list);
+			dev = list_entry(fs_devices->devices.next,
+					 struct btrfs_device, dev_list);
 			if (dev->bdev) {
 				close_bdev_excl(dev->bdev);
 				fs_devices->open_devices--;
 			}
+			fs_devices->num_devices--;
+			if (dev->writeable)
+				fs_devices->rw_devices--;
 			list_del(&dev->dev_list);
+			list_del(&dev->dev_alloc_list);
 			kfree(dev->name);
 			kfree(dev);
 		}
+		WARN_ON(fs_devices->num_devices);
+		WARN_ON(fs_devices->open_devices);
+		WARN_ON(fs_devices->rw_devices);
+		kfree(fs_devices);
 	}
 	return 0;
 }
@@ -256,6 +268,9 @@ static noinline int device_list_add(cons
 				       disk_super->dev_item.uuid);
 	}
 	if (!device) {
+		if (fs_devices->opened)
+			return -EBUSY;
+
 		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device) {
 			/* we can safely leave the fs_devices entry around */
@@ -272,8 +287,9 @@ static noinline int device_list_add(cons
 			kfree(device);
 			return -ENOMEM;
 		}
+		INIT_LIST_HEAD(&device->dev_alloc_list);
 		list_add(&device->dev_list, &fs_devices->devices);
-		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
 
@@ -287,58 +303,94 @@ static noinline int device_list_add(cons
 
 int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct list_head *head = &fs_devices->devices;
+	struct list_head *tmp;
 	struct list_head *cur;
 	struct btrfs_device *device;
+	int seed_devices = 0;
 
 	mutex_lock(&uuid_mutex);
 again:
-	list_for_each(cur, head) {
+	list_for_each_safe(cur, tmp, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		if (!device->in_fs_metadata) {
-			struct block_device *bdev;
-			list_del(&device->dev_list);
-			list_del(&device->dev_alloc_list);
+		if (device->in_fs_metadata)
+			continue;
+
+		if (device->bdev) {
+			close_bdev_excl(device->bdev);
+			device->bdev = NULL;
+			fs_devices->open_devices--;
+		}
+		if (device->writeable) {
+			list_del_init(&device->dev_alloc_list);
+			device->writeable = 0;
+			fs_devices->rw_devices--;
+		}
+		if (!seed_devices) {
+			list_del_init(&device->dev_list);
 			fs_devices->num_devices--;
-			if (device->bdev) {
-				bdev = device->bdev;
-				fs_devices->open_devices--;
-				mutex_unlock(&uuid_mutex);
-				close_bdev_excl(bdev);
-				mutex_lock(&uuid_mutex);
-			}
 			kfree(device->name);
 			kfree(device);
-			goto again;
 		}
 	}
+
+	if (fs_devices->seed) {
+		fs_devices = fs_devices->seed;
+		seed_devices = 1;
+		goto again;
+	}
+
 	mutex_unlock(&uuid_mutex);
 	return 0;
 }
 
-int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
+static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct list_head *head = &fs_devices->devices;
+	struct btrfs_fs_devices *seed_devices;
 	struct list_head *cur;
 	struct btrfs_device *device;
+again:
+	if (--fs_devices->opened > 0)
+		return 0;
 
-	mutex_lock(&uuid_mutex);
-	list_for_each(cur, head) {
+	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		if (device->bdev) {
 			close_bdev_excl(device->bdev);
 			fs_devices->open_devices--;
 		}
+		if (device->writeable) {
+			list_del_init(&device->dev_alloc_list);
+			fs_devices->rw_devices--;
+		}
+
 		device->bdev = NULL;
+		device->writeable = 0;
 		device->in_fs_metadata = 0;
 	}
-	fs_devices->mounted = 0;
-	mutex_unlock(&uuid_mutex);
+	fs_devices->opened = 0;
+	fs_devices->seeding = 0;
+	fs_devices->sprouted = 0;
+
+	seed_devices = fs_devices->seed;
+	fs_devices->seed = NULL;
+	if (seed_devices) {
+		fs_devices = seed_devices;
+		goto again;
+	}
 	return 0;
 }
 
-int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
-		       int flags, void *holder)
+int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
+{
+	int ret;
+
+	mutex_lock(&uuid_mutex);
+	ret = __btrfs_close_devices(fs_devices);
+	mutex_unlock(&uuid_mutex);
+	return ret;
+}
+
+int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices, void *holder)
 {
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
@@ -349,24 +401,18 @@ int btrfs_open_devices(struct btrfs_fs_d
 	struct btrfs_super_block *disk_super;
 	u64 latest_devid = 0;
 	u64 latest_transid = 0;
-	u64 transid;
 	u64 devid;
+	int seeding = 1;
 	int ret = 0;
 
-	mutex_lock(&uuid_mutex);
-	if (fs_devices->mounted)
-		goto out;
-
 	list_for_each(cur, head) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		if (device->bdev)
 			continue;
-
 		if (!device->name)
 			continue;
 
-		bdev = open_bdev_excl(device->name, flags, holder);
-
+		bdev = open_bdev_excl(device->name, MS_RDONLY, holder);
 		if (IS_ERR(bdev)) {
 			printk("open %s failed\n", device->name);
 			goto error;
@@ -386,16 +432,32 @@ int btrfs_open_devices(struct btrfs_fs_d
 		if (devid != device->devid)
 			goto error_brelse;
 
-		transid = btrfs_super_generation(disk_super);
-		if (!latest_transid || transid > latest_transid) {
+		if (memcmp(device->uuid, disk_super->dev_item.uuid,
+			   BTRFS_UUID_SIZE))
+			goto error_brelse;
+
+		device->generation = btrfs_super_generation(disk_super);
+		if (!latest_transid || device->generation > latest_transid) {
 			latest_devid = devid;
-			latest_transid = transid;
+			latest_transid = device->generation;
 			latest_bdev = bdev;
 		}
 
+		if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
+			device->writeable = 0;
+		} else {
+			device->writeable = !bdev_read_only(bdev);
+			seeding = 0;
+		}
+
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
 		fs_devices->open_devices++;
+		if (device->writeable) {
+			fs_devices->rw_devices++;
+			list_add(&device->dev_alloc_list,
+				 &fs_devices->alloc_list);
+		}
 		continue;
 
 error_brelse:
@@ -409,11 +471,32 @@ error:
 		ret = -EIO;
 		goto out;
 	}
-	fs_devices->mounted = 1;
+	fs_devices->seeding = seeding;
+	fs_devices->opened = 1;
 	fs_devices->latest_bdev = latest_bdev;
 	fs_devices->latest_devid = latest_devid;
 	fs_devices->latest_trans = latest_transid;
+	fs_devices->total_rw_bytes = 0;
 out:
+	return ret;
+}
+
+int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
+		       int flags, void *holder)
+{
+	int ret;
+
+	mutex_lock(&uuid_mutex);
+	if (fs_devices->opened) {
+		if (fs_devices->sprouted) {
+			ret = -EBUSY;
+		} else {
+			fs_devices->opened++;
+			ret = 0;
+		}
+	} else {
+		ret = __btrfs_open_devices(fs_devices, holder);
+	}
 	mutex_unlock(&uuid_mutex);
 	return ret;
 }
@@ -480,12 +563,12 @@ error:
  */
 static noinline int find_free_dev_extent(struct btrfs_trans_handle *trans,
 					 struct btrfs_device *device,
-					 struct btrfs_path *path,
 					 u64 num_bytes, u64 *start)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root = device->dev_root;
 	struct btrfs_dev_extent *dev_extent = NULL;
+	struct btrfs_path *path;
 	u64 hole_size = 0;
 	u64 last_byte = 0;
 	u64 search_start = 0;
@@ -495,8 +578,11 @@ static noinline int find_free_dev_extent
 	int start_found;
 	struct extent_buffer *l;
 
-	start_found = 0;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 2;
+	start_found = 0;
 
 	/* FIXME use last free of some kind */
 
@@ -580,7 +666,7 @@ check_pending:
 	/* we have to make sure we didn't find an extent that has already
 	 * been allocated by the map tree or the original allocation
 	 */
-	btrfs_release_path(root, path);
+	btrfs_free_path(path);
 	BUG_ON(*start < search_start);
 
 	if (*start + num_bytes > search_end) {
@@ -591,7 +677,7 @@ check_pending:
 	return 0;
 
 error:
-	btrfs_release_path(root, path);
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -643,11 +729,10 @@ int btrfs_free_dev_extent(struct btrfs_t
 	return ret;
 }
 
-int noinline btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset,
-			   u64 num_bytes, u64 *start)
+			   u64 chunk_offset, u64 start, u64 num_bytes)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -661,13 +746,8 @@ int noinline btrfs_alloc_dev_extent(stru
 	if (!path)
 		return -ENOMEM;
 
-	ret = find_free_dev_extent(trans, device, path, num_bytes, start);
-	if (ret) {
-		goto err;
-	}
-
 	key.objectid = device->devid;
-	key.offset = *start;
+	key.offset = start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
@@ -686,7 +766,6 @@ int noinline btrfs_alloc_dev_extent(stru
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
 	btrfs_mark_buffer_dirty(leaf);
-err:
 	btrfs_free_path(path);
 	return ret;
 }
@@ -734,12 +813,18 @@ error:
 	return ret;
 }
 
-static noinline int find_next_devid(struct btrfs_root *root,
-				    struct btrfs_path *path, u64 *objectid)
+static noinline int find_next_devid(struct btrfs_root *root, u64 *objectid)
 {
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
+	struct btrfs_path *path;
+
+	root = root->fs_info->chunk_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
@@ -762,7 +847,7 @@ static noinline int find_next_devid(stru
 	}
 	ret = 0;
 error:
-	btrfs_release_path(root, path);
+	btrfs_free_path(path);
 	return ret;
 }
 
@@ -780,7 +865,6 @@ int btrfs_add_device(struct btrfs_trans_
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	unsigned long ptr;
-	u64 free_devid = 0;
 
 	root = root->fs_info->chunk_root;
 
@@ -788,13 +872,9 @@ int btrfs_add_device(struct btrfs_trans_
 	if (!path)
 		return -ENOMEM;
 
-	ret = find_next_devid(root, path, &free_devid);
-	if (ret)
-		goto out;
-
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
-	key.offset = free_devid;
+	key.offset = device->devid;
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*dev_item));
@@ -804,8 +884,8 @@ int btrfs_add_device(struct btrfs_trans_
 	leaf = path->nodes[0];
 	dev_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dev_item);
 
-	device->devid = free_devid;
 	btrfs_set_device_id(leaf, dev_item, device->devid);
+	btrfs_set_device_generation(leaf, dev_item, 0);
 	btrfs_set_device_type(leaf, dev_item, device->type);
 	btrfs_set_device_io_align(leaf, dev_item, device->io_align);
 	btrfs_set_device_io_width(leaf, dev_item, device->io_width);
@@ -818,9 +898,11 @@ int btrfs_add_device(struct btrfs_trans_
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
+	ptr = (unsigned long)btrfs_device_fsid(dev_item);
+	write_extent_buffer(leaf, root->fs_info->fsid, ptr, BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
-	ret = 0;
 
+	ret = 0;
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -831,11 +913,7 @@ static int btrfs_rm_dev_item(struct btrf
 {
 	int ret;
 	struct btrfs_path *path;
-	struct block_device *bdev = device->bdev;
-	struct btrfs_device *next_dev;
 	struct btrfs_key key;
-	u64 total_bytes;
-	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_trans_handle *trans;
 
 	root = root->fs_info->chunk_root;
@@ -862,25 +940,6 @@ static int btrfs_rm_dev_item(struct btrf
 	ret = btrfs_del_item(trans, root, path);
 	if (ret)
 		goto out;
-
-	/*
-	 * at this point, the device is zero sized.  We want to
-	 * remove it from the devices list and zero out the old super
-	 */
-	list_del_init(&device->dev_list);
-	list_del_init(&device->dev_alloc_list);
-	fs_devices = root->fs_info->fs_devices;
-
-	next_dev = list_entry(fs_devices->devices.next, struct btrfs_device,
-			      dev_list);
-	if (bdev == root->fs_info->sb->s_bdev)
-		root->fs_info->sb->s_bdev = next_dev->bdev;
-	if (bdev == fs_devices->latest_bdev)
-		fs_devices->latest_bdev = next_dev->bdev;
-
-	total_bytes = btrfs_super_num_devices(&root->fs_info->super_copy);
-	btrfs_set_super_num_devices(&root->fs_info->super_copy,
-				    total_bytes - 1);
 out:
 	btrfs_free_path(path);
 	unlock_chunks(root);
@@ -891,11 +950,14 @@ out:
 int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_device *device;
+	struct btrfs_device *next_device;
 	struct block_device *bdev;
 	struct buffer_head *bh = NULL;
 	struct btrfs_super_block *disk_super;
 	u64 all_avail;
 	u64 devid;
+	u64 num_devices;
+	u8 *dev_uuid;
 	int ret = 0;
 
 	mutex_lock(&uuid_mutex);
@@ -906,14 +968,14 @@ int btrfs_rm_device(struct btrfs_root *r
 		root->fs_info->avail_metadata_alloc_bits;
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    btrfs_super_num_devices(&root->fs_info->super_copy) <= 4) {
+	    root->fs_info->fs_devices->rw_devices <= 4) {
 		printk("btrfs: unable to go below four devices on raid10\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    btrfs_super_num_devices(&root->fs_info->super_copy) <= 2) {
+	    root->fs_info->fs_devices->rw_devices <= 2) {
 		printk("btrfs: unable to go below two devices on raid1\n");
 		ret = -EINVAL;
 		goto out;
@@ -940,15 +1002,15 @@ int btrfs_rm_device(struct btrfs_root *r
 			printk("btrfs: no missing devices found to remove\n");
 			goto out;
 		}
-
 	} else {
-		bdev = open_bdev_excl(device_path, 0,
+		bdev = open_bdev_excl(device_path, MS_RDONLY,
 				      root->fs_info->bdev_holder);
 		if (IS_ERR(bdev)) {
 			ret = PTR_ERR(bdev);
 			goto out;
 		}
 
+		set_blocksize(bdev, 4096);
 		bh = __bread(bdev, BTRFS_SUPER_INFO_OFFSET / 4096, 4096);
 		if (!bh) {
 			ret = -EIO;
@@ -956,45 +1018,97 @@ int btrfs_rm_device(struct btrfs_root *r
 		}
 		disk_super = (struct btrfs_super_block *)bh->b_data;
 		if (strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
-		    sizeof(disk_super->magic))) {
-			ret = -ENOENT;
-			goto error_brelse;
-		}
-		if (memcmp(disk_super->fsid, root->fs_info->fsid,
-			   BTRFS_FSID_SIZE)) {
+			    sizeof(disk_super->magic))) {
 			ret = -ENOENT;
 			goto error_brelse;
 		}
 		devid = le64_to_cpu(disk_super->dev_item.devid);
-		device = btrfs_find_device(root, devid, NULL);
+		dev_uuid = disk_super->dev_item.uuid;
+		device = btrfs_find_device(root, devid, dev_uuid,
+					   disk_super->fsid);
 		if (!device) {
 			ret = -ENOENT;
 			goto error_brelse;
 		}
+	}
+
+	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
+		printk("btrfs: unable to remove the only writeable device\n");
+		ret = -EINVAL;
+		goto error_brelse;
+	}
 
+	if (device->writeable) {
+		list_del_init(&device->dev_alloc_list);
+		root->fs_info->fs_devices->rw_devices--;
 	}
-	root->fs_info->fs_devices->num_devices--;
-	root->fs_info->fs_devices->open_devices--;
 
 	ret = btrfs_shrink_device(device, 0);
 	if (ret)
 		goto error_brelse;
 
-
 	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);
 	if (ret)
 		goto error_brelse;
 
-	if (bh) {
+	device->in_fs_metadata = 0;
+	if (device->fs_devices == root->fs_info->fs_devices) {
+		list_del_init(&device->dev_list);
+		root->fs_info->fs_devices->num_devices--;
+		if (device->bdev)
+			device->fs_devices->open_devices--;
+	}
+
+	next_device = list_entry(root->fs_info->fs_devices->devices.next,
+				 struct btrfs_device, dev_list);
+	if (device->bdev == root->fs_info->sb->s_bdev)
+		root->fs_info->sb->s_bdev = next_device->bdev;
+	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
+		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
+
+	num_devices = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
+	btrfs_set_super_num_devices(&root->fs_info->super_copy, num_devices);
+
+	if (device->fs_devices != root->fs_info->fs_devices) {
+		BUG_ON(device->writeable);
+		brelse(bh);
+		if (bdev)
+			close_bdev_excl(bdev);
+
+		if (device->bdev) {
+			close_bdev_excl(device->bdev);
+			device->bdev = NULL;
+			device->fs_devices->open_devices--;
+		}
+		if (device->fs_devices->open_devices == 0) {
+			struct btrfs_fs_devices *fs_devices;
+			fs_devices = root->fs_info->fs_devices;
+			while (fs_devices) {
+				if (fs_devices->seed == device->fs_devices)
+					break;
+				fs_devices = fs_devices->seed;
+			}
+			fs_devices->seed = device->fs_devices->seed;
+			device->fs_devices->seed = NULL;
+			__btrfs_close_devices(device->fs_devices);
+		}
+		ret = 0;
+		goto out;
+	}
+
+	/*
+	 * at this point, the device is zero sized.  We want to
+	 * remove it from the devices list and zero out the old super
+	 */
+	if (device->writeable) {
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
 		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
 		set_buffer_dirty(bh);
 		sync_dirty_buffer(bh);
-
-		brelse(bh);
 	}
+	brelse(bh);
 
 	if (device->bdev) {
 		/* one close for the device struct or super_block */
@@ -1020,6 +1134,129 @@ out:
 	return ret;
 }
 
+/*
+ * does all the dirty work required for changing file system's UUID.
+ */
+static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root)
+{
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	struct btrfs_fs_devices *old_devices;
+	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
+	struct btrfs_device *device;
+	u64 super_flags;
+
+	BUG_ON(!mutex_is_locked(&uuid_mutex));
+	if (!fs_devices->seeding || fs_devices->opened != 1)
+		return -EINVAL;
+
+	old_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
+	if (!old_devices)
+		return -ENOMEM;
+
+	memcpy(old_devices, fs_devices, sizeof(*old_devices));
+	old_devices->opened = 1;
+	old_devices->sprouted = 1;
+	INIT_LIST_HEAD(&old_devices->devices);
+	INIT_LIST_HEAD(&old_devices->alloc_list);
+	list_splice_init(&fs_devices->devices, &old_devices->devices);
+	list_splice_init(&fs_devices->alloc_list, &old_devices->alloc_list);
+	list_for_each_entry(device, &old_devices->devices, dev_list) {
+		device->fs_devices = old_devices;
+	}
+	list_add(&old_devices->list, &fs_uuids);
+
+	fs_devices->seeding = 0;
+	fs_devices->num_devices = 0;
+	fs_devices->open_devices = 0;
+	fs_devices->seed = old_devices;
+
+	generate_random_uuid(fs_devices->fsid);
+	memcpy(root->fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	super_flags = btrfs_super_flags(disk_super) &
+		      ~BTRFS_SUPER_FLAG_SEEDING;
+	btrfs_set_super_flags(disk_super, super_flags);
+
+	return 0;
+}
+
+/*
+ * strore the expected generation for seed devices in device items.
+ */
+static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_dev_item *dev_item;
+	struct btrfs_device *device;
+	struct btrfs_key key;
+	u8 fs_uuid[BTRFS_UUID_SIZE];
+	u8 dev_uuid[BTRFS_UUID_SIZE];
+	u64 devid;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	root = root->fs_info->chunk_root;
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_DEV_ITEM_KEY;
+
+	while (1) {
+		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		if (ret < 0)
+			goto error;
+
+		leaf = path->nodes[0];
+next_slot:
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret > 0)
+				break;
+			if (ret < 0)
+				goto error;
+			leaf = path->nodes[0];
+			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+			btrfs_release_path(root, path);
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != BTRFS_DEV_ITEMS_OBJECTID ||
+		    key.type != BTRFS_DEV_ITEM_KEY)
+			break;
+
+		dev_item = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_dev_item);
+		devid = btrfs_device_id(leaf, dev_item);
+		read_extent_buffer(leaf, dev_uuid,
+				   (unsigned long)btrfs_device_uuid(dev_item),
+				   BTRFS_UUID_SIZE);
+		read_extent_buffer(leaf, fs_uuid,
+				   (unsigned long)btrfs_device_fsid(dev_item),
+				   BTRFS_UUID_SIZE);
+		device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
+		BUG_ON(!device);
+
+		if (device->fs_devices->seeding) {
+			btrfs_set_device_generation(leaf, dev_item,
+						    device->generation);
+			btrfs_mark_buffer_dirty(leaf);
+		}
+
+		path->slots[0]++;
+		goto next_slot;
+	}
+	ret = 0;
+error:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 {
 	struct btrfs_trans_handle *trans;
@@ -1027,26 +1264,34 @@ int btrfs_init_new_device(struct btrfs_r
 	struct block_device *bdev;
 	struct list_head *cur;
 	struct list_head *devices;
+	struct super_block *sb = root->fs_info->sb;
 	u64 total_bytes;
+	int seeding_dev = 0;
 	int ret = 0;
 
+	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
+		return -EINVAL;
 
 	bdev = open_bdev_excl(device_path, 0, root->fs_info->bdev_holder);
 	if (!bdev) {
 		return -EIO;
 	}
 
-	filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	if (root->fs_info->fs_devices->seeding) {
+		seeding_dev = 1;
+		down_write(&sb->s_umount);
+		mutex_lock(&uuid_mutex);
+	}
+
+	invalidate_inode_pages2(bdev->bd_inode->i_mapping);
 	mutex_lock(&root->fs_info->volume_mutex);
 
-	trans = btrfs_start_transaction(root, 1);
-	lock_chunks(root);
 	devices = &root->fs_info->fs_devices->devices;
 	list_for_each(cur, devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		if (device->bdev == bdev) {
 			ret = -EEXIST;
-			goto out;
+			goto error;
 		}
 	}
 
@@ -1054,18 +1299,31 @@ int btrfs_init_new_device(struct btrfs_r
 	if (!device) {
 		/* we can safely leave the fs_devices entry around */
 		ret = -ENOMEM;
-		goto out_close_bdev;
+		goto error;
 	}
 
-	device->barriers = 1;
-	device->work.func = pending_bios_fn;
-	generate_random_uuid(device->uuid);
-	spin_lock_init(&device->io_lock);
 	device->name = kstrdup(device_path, GFP_NOFS);
 	if (!device->name) {
 		kfree(device);
-		goto out_close_bdev;
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ret = find_next_devid(root, &device->devid);
+	if (ret) {
+		kfree(device);
+		goto error;
 	}
+
+	trans = btrfs_start_transaction(root, 1);
+	lock_chunks(root);
+
+	device->barriers = 1;
+	device->writeable = 1;
+	device->work.func = pending_bios_fn;
+	generate_random_uuid(device->uuid);
+	spin_lock_init(&device->io_lock);
+	device->generation = trans->transid;
 	device->io_width = root->sectorsize;
 	device->io_align = root->sectorsize;
 	device->sector_size = root->sectorsize;
@@ -1073,12 +1331,22 @@ int btrfs_init_new_device(struct btrfs_r
 	device->dev_root = root->fs_info->dev_root;
 	device->bdev = bdev;
 	device->in_fs_metadata = 1;
+	set_blocksize(device->bdev, 4096);
 
-	ret = btrfs_add_device(trans, root, device);
-	if (ret)
-		goto out_close_bdev;
+	if (seeding_dev) {
+		sb->s_flags &= ~MS_RDONLY;
+		ret = btrfs_prepare_sprout(trans, root);
+		BUG_ON(ret);
+	}
 
-	set_blocksize(device->bdev, 4096);
+	device->fs_devices = root->fs_info->fs_devices;
+	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
+	list_add(&device->dev_alloc_list,
+		 &root->fs_info->fs_devices->alloc_list);
+	root->fs_info->fs_devices->num_devices++;
+	root->fs_info->fs_devices->open_devices++;
+	root->fs_info->fs_devices->rw_devices++;
+	root->fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
 	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	btrfs_set_super_total_bytes(&root->fs_info->super_copy,
@@ -1088,20 +1356,34 @@ int btrfs_init_new_device(struct btrfs_r
 	btrfs_set_super_num_devices(&root->fs_info->super_copy,
 				    total_bytes + 1);
 
-	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
-	list_add(&device->dev_alloc_list,
-		 &root->fs_info->fs_devices->alloc_list);
-	root->fs_info->fs_devices->num_devices++;
-	root->fs_info->fs_devices->open_devices++;
-out:
+	if (seeding_dev) {
+		ret = init_first_rw_device(trans, root, device);
+		BUG_ON(ret);
+		ret = btrfs_finish_sprout(trans, root);
+		BUG_ON(ret);
+	} else {
+		ret = btrfs_add_device(trans, root, device);
+	}
+
 	unlock_chunks(root);
-	btrfs_end_transaction(trans, root);
-	mutex_unlock(&root->fs_info->volume_mutex);
+	btrfs_commit_transaction(trans, root);
 
-	return ret;
+	if (seeding_dev) {
+		mutex_unlock(&uuid_mutex);
+		up_write(&sb->s_umount);
 
-out_close_bdev:
+		ret = btrfs_relocate_sys_chunks(root);
+		BUG_ON(ret);
+	}
+out:
+	mutex_unlock(&root->fs_info->volume_mutex);
+	return ret;
+error:
 	close_bdev_excl(bdev);
+	if (seeding_dev) {
+		mutex_unlock(&uuid_mutex);
+		up_write(&sb->s_umount);
+	}
 	goto out;
 }
 
@@ -1159,7 +1441,15 @@ static int __btrfs_grow_device(struct bt
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 diff = new_size - device->total_bytes;
 
+	if (!device->writeable)
+		return -EACCES;
+	if (new_size <= device->total_bytes)
+		return -EINVAL;
+
 	btrfs_set_super_total_bytes(super_copy, old_total + diff);
+	device->fs_devices->total_rw_bytes += diff;
+
+	device->total_bytes = new_size;
 	return btrfs_update_device(trans, device);
 }
 
@@ -1247,7 +1537,6 @@ int btrfs_del_sys_chunk(struct btrfs_roo
 	return ret;
 }
 
-
 int btrfs_relocate_chunk(struct btrfs_root *root,
 			 u64 chunk_tree, u64 chunk_objectid,
 			 u64 chunk_offset)
@@ -1302,29 +1591,87 @@ int btrfs_relocate_chunk(struct btrfs_ro
 
 	BUG_ON(ret);
 
-	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_del_sys_chunk(root, chunk_objectid, chunk_offset);
-		BUG_ON(ret);
-	}
+	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		ret = btrfs_del_sys_chunk(root, chunk_objectid, chunk_offset);
+		BUG_ON(ret);
+	}
+
+	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
+	BUG_ON(ret);
+
+	spin_lock(&em_tree->lock);
+	remove_extent_mapping(em_tree, em);
+	spin_unlock(&em_tree->lock);
+
+	kfree(map);
+	em->bdev = NULL;
+
+	/* once for the tree */
+	free_extent_map(em);
+	/* once for us */
+	free_extent_map(em);
+
+	unlock_chunks(root);
+	btrfs_end_transaction(trans, root);
+	return 0;
+}
+
+static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
+{
+	struct btrfs_root *chunk_root = root->fs_info->chunk_root;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_chunk *chunk;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	u64 chunk_tree = chunk_root->root_key.objectid;
+	u64 chunk_type;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	while (1) {
+		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
+		if (ret < 0)
+			goto error;
+		BUG_ON(ret == 0);
 
-	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset);
-	BUG_ON(ret);
+		ret = btrfs_previous_item(chunk_root, path, key.objectid,
+					  key.type);
+		if (ret < 0)
+			goto error;
+		if (ret > 0)
+			break;
 
-	spin_lock(&em_tree->lock);
-	remove_extent_mapping(em_tree, em);
-	spin_unlock(&em_tree->lock);
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-	kfree(map);
-	em->bdev = NULL;
+		chunk = btrfs_item_ptr(leaf, path->slots[0],
+				       struct btrfs_chunk);
+		chunk_type = btrfs_chunk_type(leaf, chunk);
+		btrfs_release_path(chunk_root, path);
 
-	/* once for the tree */
-	free_extent_map(em);
-	/* once for us */
-	free_extent_map(em);
+		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
+			ret = btrfs_relocate_chunk(chunk_root, chunk_tree,
+						   found_key.objectid,
+						   found_key.offset);
+			BUG_ON(ret);
+		}
 
-	unlock_chunks(root);
-	btrfs_end_transaction(trans, root);
-	return 0;
+		if (found_key.offset == 0)
+			break;
+		key.offset = found_key.offset - 1;
+	}
+	ret = 0;
+error:
+	btrfs_free_path(path);
+	return ret;
 }
 
 static u64 div_factor(u64 num, int factor)
@@ -1336,7 +1683,6 @@ static u64 div_factor(u64 num, int facto
 	return num;
 }
 
-
 int btrfs_balance(struct btrfs_root *dev_root)
 {
 	int ret;
@@ -1352,6 +1698,8 @@ int btrfs_balance(struct btrfs_root *dev
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
 
+	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
 
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
@@ -1362,7 +1710,8 @@ int btrfs_balance(struct btrfs_root *dev
 		old_size = device->total_bytes;
 		size_to_free = div_factor(old_size, 1);
 		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);
-		if (device->total_bytes - device->bytes_used > size_to_free)
+		if (!device->writeable ||
+		    device->total_bytes - device->bytes_used > size_to_free)
 			continue;
 
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
@@ -1452,6 +1801,8 @@ int btrfs_shrink_device(struct btrfs_dev
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 diff = device->total_bytes - new_size;
 
+	if (new_size >= device->total_bytes)
+		return -EINVAL;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1468,6 +1819,8 @@ int btrfs_shrink_device(struct btrfs_dev
 	lock_chunks(root);
 
 	device->total_bytes = new_size;
+	if (device->writeable)
+		device->fs_devices->total_rw_bytes -= diff;
 	ret = btrfs_update_device(trans, device);
 	if (ret) {
 		unlock_chunks(root);
@@ -1560,32 +1913,26 @@ static u64 noinline chunk_bytes_by_type(
 		return calc_size * num_stripes;
 }
 
-
-int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type)
+static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *extent_root,
+			       struct map_lookup **map_ret,
+			       u64 *num_bytes, u64 *stripe_size,
+			       u64 start, u64 type)
 {
-	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
-	struct btrfs_path *path;
-	struct btrfs_stripe *stripes;
 	struct btrfs_device *device = NULL;
-	struct btrfs_chunk *chunk;
-	struct list_head private_devs;
-	struct list_head *dev_list;
+	struct btrfs_fs_devices *fs_devices = info->fs_devices;
 	struct list_head *cur;
+	struct map_lookup *map = NULL;
 	struct extent_map_tree *em_tree;
-	struct map_lookup *map;
 	struct extent_map *em;
 	int min_stripe_size = 1 * 1024 * 1024;
-	u64 physical;
 	u64 calc_size = 1024 * 1024 * 1024;
 	u64 max_chunk_size = calc_size;
 	u64 min_free;
 	u64 avail;
 	u64 max_avail = 0;
-	u64 percent_max;
+	u64 dev_offset;
 	int num_stripes = 1;
 	int min_stripes = 1;
 	int sub_stripes = 0;
@@ -1593,19 +1940,17 @@ int btrfs_alloc_chunk(struct btrfs_trans
 	int ret;
 	int index;
 	int stripe_len = 64 * 1024;
-	struct btrfs_key key;
 
 	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
 	    (type & BTRFS_BLOCK_GROUP_DUP)) {
 		WARN_ON(1);
 		type &= ~BTRFS_BLOCK_GROUP_DUP;
 	}
-	dev_list = &extent_root->fs_info->fs_devices->alloc_list;
-	if (list_empty(dev_list))
+	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
 
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		num_stripes = extent_root->fs_info->fs_devices->open_devices;
+		num_stripes = fs_devices->rw_devices;
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
@@ -1613,14 +1958,13 @@ int btrfs_alloc_chunk(struct btrfs_trans
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
-		num_stripes = min_t(u64, 2,
-			    extent_root->fs_info->fs_devices->open_devices);
+		num_stripes = min_t(u64, 2, fs_devices->rw_devices);
 		if (num_stripes < 2)
 			return -ENOSPC;
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		num_stripes = extent_root->fs_info->fs_devices->open_devices;
+		num_stripes = fs_devices->rw_devices;
 		if (num_stripes < 4)
 			return -ENOSPC;
 		num_stripes &= ~(u32)1;
@@ -1640,15 +1984,19 @@ int btrfs_alloc_chunk(struct btrfs_trans
 		min_stripe_size = 1 * 1024 * 1024;
 	}
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	/* we don't want a chunk larger than 10% of the FS */
-	percent_max = div_factor(btrfs_super_total_bytes(&info->super_copy), 1);
-	max_chunk_size = min(percent_max, max_chunk_size);
+	/* we don't want a chunk larger than 10% of writeable space */
+	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
+			     max_chunk_size);
 
 again:
+	if (!map || map->num_stripes != num_stripes) {
+		kfree(map);
+		map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+		if (!map)
+			return -ENOMEM;
+		map->num_stripes = num_stripes;
+	}
+
 	if (calc_size * num_stripes > max_chunk_size) {
 		calc_size = max_chunk_size;
 		do_div(calc_size, num_stripes);
@@ -1661,8 +2009,7 @@ again:
 	do_div(calc_size, stripe_len);
 	calc_size *= stripe_len;
 
-	INIT_LIST_HEAD(&private_devs);
-	cur = dev_list->next;
+	cur = fs_devices->alloc_list.next;
 	index = 0;
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
@@ -1678,10 +2025,9 @@ again:
 	if (!looped)
 		min_free += 1024 * 1024;
 
-	/* build a private list of devices we will allocate from */
 	while(index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
-
+		BUG_ON(!device->writeable);
 		if (device->total_bytes > device->bytes_used)
 			avail = device->total_bytes - device->bytes_used;
 		else
@@ -1689,24 +2035,27 @@ again:
 		cur = cur->next;
 
 		if (device->in_fs_metadata && avail >= min_free) {
-			u64 ignored_start = 0;
-			ret = find_free_dev_extent(trans, device, path,
-						   min_free,
-						   &ignored_start);
+			ret = find_free_dev_extent(trans, device,
+						   min_free, &dev_offset);
 			if (ret == 0) {
 				list_move_tail(&device->dev_alloc_list,
-					       &private_devs);
+					       &fs_devices->alloc_list);
+				map->stripes[index].dev = device;
+				map->stripes[index].physical = dev_offset;
 				index++;
-				if (type & BTRFS_BLOCK_GROUP_DUP)
+				if (type & BTRFS_BLOCK_GROUP_DUP) {
+					map->stripes[index].dev = device;
+					map->stripes[index].physical =
+						dev_offset + calc_size;
 					index++;
+				}
 			}
 		} else if (device->in_fs_metadata && avail > max_avail)
 			max_avail = avail;
-		if (cur == dev_list)
+		if (cur == &fs_devices->alloc_list)
 			break;
 	}
 	if (index < num_stripes) {
-		list_splice(&private_devs, dev_list);
 		if (index >= min_stripes) {
 			num_stripes = index;
 			if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
@@ -1721,115 +2070,246 @@ again:
 			calc_size = max_avail;
 			goto again;
 		}
-		btrfs_free_path(path);
+		kfree(map);
 		return -ENOSPC;
 	}
-	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	key.type = BTRFS_CHUNK_ITEM_KEY;
-	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &key.offset);
-	if (ret) {
-		btrfs_free_path(path);
-		return ret;
-	}
+	map->sector_size = extent_root->sectorsize;
+	map->stripe_len = stripe_len;
+	map->io_align = stripe_len;
+	map->io_width = stripe_len;
+	map->type = type;
+	map->num_stripes = num_stripes;
+	map->sub_stripes = sub_stripes;
 
-	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
-	if (!chunk) {
-		btrfs_free_path(path);
-		return -ENOMEM;
-	}
+	*map_ret = map;
+	*stripe_size = calc_size;
+	*num_bytes = chunk_bytes_by_type(type, calc_size,
+					 num_stripes, sub_stripes);
 
-	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
-	if (!map) {
-		kfree(chunk);
-		btrfs_free_path(path);
+	em = alloc_extent_map(GFP_NOFS);
+	if (!em) {
+		kfree(map);
 		return -ENOMEM;
 	}
-	btrfs_free_path(path);
-	path = NULL;
+	em->bdev = (struct block_device *)map;
+	em->start = start;
+	em->len = *num_bytes;
+	em->block_start = 0;
+	em->block_len = em->len;
 
-	stripes = &chunk->stripe;
-	*num_bytes = chunk_bytes_by_type(type, calc_size,
-					 num_stripes, sub_stripes);
+	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
+	spin_lock(&em_tree->lock);
+	ret = add_extent_mapping(em_tree, em);
+	spin_unlock(&em_tree->lock);
+	BUG_ON(ret);
+	free_extent_map(em);
 
-	index = 0;
-	while(index < num_stripes) {
-		struct btrfs_stripe *stripe;
-		BUG_ON(list_empty(&private_devs));
-		cur = private_devs.next;
-		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
+	ret = btrfs_make_block_group(trans, extent_root, 0, type,
+				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     start, *num_bytes);
+	BUG_ON(ret);
 
-		/* loop over this device again if we're doing a dup group */
-		if (!(type & BTRFS_BLOCK_GROUP_DUP) ||
-		    (index == num_stripes - 1))
-			list_move_tail(&device->dev_alloc_list, dev_list);
+	index = 0;
+	while (index < map->num_stripes) {
+		device = map->stripes[index].dev;
+		dev_offset = map->stripes[index].physical;
 
 		ret = btrfs_alloc_dev_extent(trans, device,
-			     info->chunk_root->root_key.objectid,
-			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
-			     calc_size, &dev_offset);
+				info->chunk_root->root_key.objectid,
+				BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				start, dev_offset, calc_size);
 		BUG_ON(ret);
-		device->bytes_used += calc_size;
+		index++;
+	}
+
+	return 0;
+}
+
+static int __finish_chunk_alloc(struct btrfs_trans_handle *trans,
+				struct btrfs_root *extent_root,
+				struct map_lookup *map, u64 chunk_offset,
+				u64 chunk_size, u64 stripe_size)
+{
+	u64 dev_offset;
+	struct btrfs_key key;
+	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
+	struct btrfs_device *device;
+	struct btrfs_chunk *chunk;
+	struct btrfs_stripe *stripe;
+	size_t item_size = btrfs_chunk_item_size(map->num_stripes);
+	int index = 0;
+	int ret;
+
+	chunk = kzalloc(item_size, GFP_NOFS);
+	if (!chunk)
+		return -ENOMEM;
+
+	index = 0;
+	while (index < map->num_stripes) {
+		device = map->stripes[index].dev;
+		device->bytes_used += stripe_size;
 		ret = btrfs_update_device(trans, device);
 		BUG_ON(ret);
+		index++;
+	}
+
+	index = 0;
+	stripe = &chunk->stripe;
+	while (index < map->num_stripes) {
+		device = map->stripes[index].dev;
+		dev_offset = map->stripes[index].physical;
 
-		map->stripes[index].dev = device;
-		map->stripes[index].physical = dev_offset;
-		stripe = stripes + index;
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		physical = dev_offset;
+		stripe++;
 		index++;
 	}
-	BUG_ON(!list_empty(&private_devs));
 
-	/* key was set above */
-	btrfs_set_stack_chunk_length(chunk, *num_bytes);
+	btrfs_set_stack_chunk_length(chunk, chunk_size);
 	btrfs_set_stack_chunk_owner(chunk, extent_root->root_key.objectid);
-	btrfs_set_stack_chunk_stripe_len(chunk, stripe_len);
-	btrfs_set_stack_chunk_type(chunk, type);
-	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
-	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
-	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
+	btrfs_set_stack_chunk_stripe_len(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_type(chunk, map->type);
+	btrfs_set_stack_chunk_num_stripes(chunk, map->num_stripes);
+	btrfs_set_stack_chunk_io_align(chunk, map->stripe_len);
+	btrfs_set_stack_chunk_io_width(chunk, map->stripe_len);
 	btrfs_set_stack_chunk_sector_size(chunk, extent_root->sectorsize);
-	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
-	map->sector_size = extent_root->sectorsize;
-	map->stripe_len = stripe_len;
-	map->io_align = stripe_len;
-	map->io_width = stripe_len;
-	map->type = type;
-	map->num_stripes = num_stripes;
-	map->sub_stripes = sub_stripes;
+	btrfs_set_stack_chunk_sub_stripes(chunk, map->sub_stripes);
 
-	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
-				btrfs_chunk_item_size(num_stripes));
-	BUG_ON(ret);
-	*start = key.offset;;
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = chunk_offset;
 
-	em = alloc_extent_map(GFP_NOFS);
-	if (!em)
-		return -ENOMEM;
-	em->bdev = (struct block_device *)map;
-	em->start = key.offset;
-	em->len = *num_bytes;
-	em->block_start = 0;
-	em->block_len = em->len;
+	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
+	BUG_ON(ret);
 
-	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_add_system_chunk(trans, chunk_root, &key,
-				    chunk, btrfs_chunk_item_size(num_stripes));
+	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		ret = btrfs_add_system_chunk(trans, chunk_root, &key, chunk,
+					     item_size);
 		BUG_ON(ret);
 	}
 	kfree(chunk);
+	return 0;
+}
 
-	em_tree = &extent_root->fs_info->mapping_tree.map_tree;
-	spin_lock(&em_tree->lock);
-	ret = add_extent_mapping(em_tree, em);
-	spin_unlock(&em_tree->lock);
+/*
+ * Chunk allocation falls into two parts. The first part does works
+ * that make the new allocated chunk useable, but not do any operation
+ * that modifies the chunk tree. The second part does the works that
+ * require modifying the chunk tree. This division is important for the
+ * bootstrap process of adding storage to a seed btrfs.
+ */
+int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *extent_root, u64 type)
+{
+	u64 chunk_offset;
+	u64 chunk_size;
+	u64 stripe_size;
+	struct map_lookup *map;
+	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
+	int ret;
+
+	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+			      &chunk_offset);
+	if (ret)
+		return ret;
+
+	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
+				  &stripe_size, chunk_offset, type);
+	if (ret)
+		return ret;
+
+	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
+				   chunk_size, stripe_size);
+	BUG_ON(ret);
+	return 0;
+}
+
+static int noinline init_first_rw_device(struct btrfs_trans_handle *trans,
+					 struct btrfs_root *root,
+					 struct btrfs_device *device)
+{
+	u64 chunk_offset;
+	u64 sys_chunk_offset;
+	u64 chunk_size;
+	u64 sys_chunk_size;
+	u64 stripe_size;
+	u64 sys_stripe_size;
+	u64 alloc_profile;
+	struct map_lookup *map;
+	struct map_lookup *sys_map;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	int ret;
+
+	ret = find_next_chunk(fs_info->chunk_root,
+			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
+	BUG_ON(ret);
+
+	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
+			(fs_info->metadata_alloc_profile &
+			 fs_info->avail_metadata_alloc_bits);
+	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
+
+	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
+				  &stripe_size, chunk_offset, alloc_profile);
+	BUG_ON(ret);
+
+	sys_chunk_offset = chunk_offset + chunk_size;
+
+	alloc_profile = BTRFS_BLOCK_GROUP_SYSTEM |
+			(fs_info->system_alloc_profile &
+			 fs_info->avail_system_alloc_bits);
+	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
+
+	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
+				  &sys_chunk_size, &sys_stripe_size,
+				  sys_chunk_offset, alloc_profile);
+	BUG_ON(ret);
+
+	ret = btrfs_add_device(trans, fs_info->chunk_root, device);
+	BUG_ON(ret);
+
+	/*
+	 * Modifying chunk tree needs allocating new blocks from both
+	 * system block group and metadata block group. So we only can
+	 * do operations require modifying the chunk tree after both
+	 * block groups were created.
+	 */
+	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
+				   chunk_size, stripe_size);
+	BUG_ON(ret);
+
+	ret = __finish_chunk_alloc(trans, extent_root, sys_map,
+				   sys_chunk_offset, sys_chunk_size,
+				   sys_stripe_size);
 	BUG_ON(ret);
+	return 0;
+}
+
+int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
+{
+	struct extent_map *em;
+	struct map_lookup *map;
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	int readonly = 0;
+	int i;
+
+	spin_lock(&map_tree->map_tree.lock);
+	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
+	spin_unlock(&map_tree->map_tree.lock);
+	if (!em)
+		return 1;
+
+	map = (struct map_lookup *)em->bdev;
+	for (i = 0; i < map->num_stripes; i++) {
+		if (!map->stripes[i].dev->writeable) {
+			readonly = 1;
+			break;
+		}
+	}
 	free_extent_map(em);
-	return ret;
+	return readonly;
 }
 
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
@@ -2226,6 +2706,7 @@ int btrfs_map_bio(struct btrfs_root *roo
 		}
 		bio->bi_sector = multi->stripes[dev_nr].physical >> 9;
 		dev = multi->stripes[dev_nr].dev;
+		BUG_ON(rw == WRITE && !dev->writeable);
 		if (dev && dev->bdev) {
 			bio->bi_bdev = dev->bdev;
 			if (async_submit)
@@ -2245,11 +2726,23 @@ int btrfs_map_bio(struct btrfs_root *roo
 }
 
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-				       u8 *uuid)
+				       u8 *uuid, u8 *fsid)
 {
-	struct list_head *head = &root->fs_info->fs_devices->devices;
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *cur_devices;
 
-	return __find_device(head, devid, uuid);
+	cur_devices = root->fs_info->fs_devices;
+	while (cur_devices) {
+		if (!fsid ||
+		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+			device = __find_device(&cur_devices->devices,
+					       devid, uuid);
+			if (device)
+				return device;
+		}
+		cur_devices = cur_devices->seed;
+	}
+	return NULL;
 }
 
 static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
@@ -2261,8 +2754,6 @@ static struct btrfs_device *add_missing_
 	device = kzalloc(sizeof(*device), GFP_NOFS);
 	list_add(&device->dev_list,
 		 &fs_devices->devices);
-	list_add(&device->dev_alloc_list,
-		 &fs_devices->alloc_list);
 	device->barriers = 1;
 	device->dev_root = root->fs_info->dev_root;
 	device->devid = devid;
@@ -2273,7 +2764,6 @@ static struct btrfs_device *add_missing_
 	return device;
 }
 
-
 static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -2338,8 +2828,8 @@ static int read_one_chunk(struct btrfs_r
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(root, devid, uuid);
-
+		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
+							NULL);
 		if (!map->stripes[i].dev && !btrfs_test_opt(root, DEGRADED)) {
 			kfree(map);
 			free_extent_map(em);
@@ -2386,6 +2876,50 @@ static int fill_device_from_item(struct 
 	return 0;
 }
 
+static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
+{
+	struct btrfs_fs_devices *fs_devices;
+	int ret;
+
+	mutex_lock(&uuid_mutex);
+
+	fs_devices = root->fs_info->fs_devices->seed;
+	while (fs_devices) {
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+			ret = 0;
+			goto out;
+		}
+		fs_devices = fs_devices->seed;
+	}
+
+	fs_devices = find_fsid(fsid);
+	if (!fs_devices) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (fs_devices->opened) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = __btrfs_open_devices(fs_devices, root->fs_info->bdev_holder);
+	if (ret)
+		goto out;
+
+	if (!fs_devices->seeding) {
+		__btrfs_close_devices(fs_devices);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	fs_devices->seed = root->fs_info->fs_devices->seed;
+	root->fs_info->fs_devices->seed = fs_devices;
+	fs_devices->sprouted = 1;
+out:
+	mutex_unlock(&uuid_mutex);
+	return ret;
+}
+
 static int read_one_dev(struct btrfs_root *root,
 			struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
@@ -2393,23 +2927,50 @@ static int read_one_dev(struct btrfs_roo
 	struct btrfs_device *device;
 	u64 devid;
 	int ret;
+	int seed_devices = 0;
+	u8 fs_uuid[BTRFS_UUID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
 	devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid,
 			   (unsigned long)btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
-	device = btrfs_find_device(root, devid, dev_uuid);
-	if (!device) {
-		printk("warning devid %Lu missing\n", devid);
-		device = add_missing_dev(root, devid, dev_uuid);
-		if (!device)
-			return -ENOMEM;
+	read_extent_buffer(leaf, fs_uuid,
+			   (unsigned long)btrfs_device_fsid(dev_item),
+			   BTRFS_UUID_SIZE);
+
+	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
+		ret = open_seed_devices(root, fs_uuid);
+		if (ret)
+			return ret;
+		seed_devices = 1;
+	}
+
+	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
+	if (!device || !device->bdev) {
+		if (!btrfs_test_opt(root, DEGRADED) || seed_devices)
+			return -EIO;
+
+		if (!device) {
+			printk("warning devid %Lu missing\n", devid);
+			device = add_missing_dev(root, devid, dev_uuid);
+			if (!device)
+				return -ENOMEM;
+		}
+	}
+
+	if (device->fs_devices != root->fs_info->fs_devices) {
+		BUG_ON(device->writeable);
+		if (device->generation !=
+		    btrfs_device_generation(leaf, dev_item))
+			return -EINVAL;
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
 	device->dev_root = root->fs_info->dev_root;
 	device->in_fs_metadata = 1;
+	if (device->writeable)
+		device->fs_devices->total_rw_bytes += device->total_bytes;
 	ret = 0;
 #if 0
 	ret = btrfs_open_device(device);
@@ -2527,12 +3088,15 @@ again:
 				dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
 				ret = read_one_dev(root, leaf, dev_item);
-				BUG_ON(ret);
+				if (ret)
+					goto error;
 			}
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 			ret = read_one_chunk(root, &found_key, leaf, chunk);
+			if (ret)
+				goto error;
 		}
 		path->slots[0]++;
 	}
@@ -2541,9 +3105,8 @@ again:
 		btrfs_release_path(root, path);
 		goto again;
 	}
-
-	btrfs_free_path(path);
 	ret = 0;
 error:
+	btrfs_free_path(path);
 	return ret;
 }
diff -urp 3/fs/btrfs/volumes.h 4/fs/btrfs/volumes.h
--- 3/fs/btrfs/volumes.h	2008-10-31 04:15:01.000000000 +0800
+++ 4/fs/btrfs/volumes.h	2008-11-11 10:46:21.000000000 +0800
@@ -26,6 +26,7 @@ struct buffer_head;
 struct btrfs_device {
 	struct list_head dev_list;
 	struct list_head dev_alloc_list;
+	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_root *dev_root;
 	struct buffer_head *pending_io;
 	struct bio *pending_bios;
@@ -34,6 +35,7 @@ struct btrfs_device {
 	u64 generation;
 
 	int barriers;
+	int writeable;
 	int in_fs_metadata;
 
 	spinlock_t io_lock;
@@ -77,6 +79,8 @@ struct btrfs_fs_devices {
 	u64 latest_trans;
 	u64 num_devices;
 	u64 open_devices;
+	u64 rw_devices;
+	u64 total_rw_bytes;
 	struct block_device *latest_bdev;
 	/* all of the devices in the FS */
 	struct list_head devices;
@@ -84,7 +88,12 @@ struct btrfs_fs_devices {
 	/* devices not currently being allocated */
 	struct list_head alloc_list;
 	struct list_head list;
-	int mounted;
+
+	struct btrfs_fs_devices *seed;
+	int seeding;
+	int sprouted;
+
+	int opened;
 };
 
 struct btrfs_bio_stripe {
@@ -109,16 +118,14 @@ struct btrfs_multi_bio {
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset,
-			   u64 num_bytes, u64 *start);
+			   u64 chunk_offset, u64 start, u64 num_bytes);
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num);
 int btrfs_read_sys_array(struct btrfs_root *root);
 int btrfs_read_chunk_tree(struct btrfs_root *root);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type);
+		      struct btrfs_root *extent_root, u64 type);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
@@ -141,10 +148,11 @@ int btrfs_unplug_page(struct btrfs_mappi
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-				       u8 *uuid);
+				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
 void btrfs_unlock_volumes(void);
 void btrfs_lock_volumes(void);
+int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 #endif
