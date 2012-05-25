Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:47887 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2EYOGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:06:12 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id B49AE3D8
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 16:06:10 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 3/3] Btrfs: read device stats on mount, write modified ones during commit
Date: Fri, 25 May 2012 16:06:10 +0200
Message-Id: <1337954770-10086-4-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337954770-10086-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The device statistics are written into the device tree with each
transaction commit. Only modified statistics are written.
When a filesystem is mounted, the device statistics for each involved
device are read from the device tree and used to initialize the
counters.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       |   38 +++++++++++
 fs/btrfs/disk-io.c     |    7 ++
 fs/btrfs/print-tree.c  |    3 +
 fs/btrfs/transaction.c |    4 ++
 fs/btrfs/volumes.c     |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |    4 ++
 6 files changed, 232 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ec42a24..3e5ab89 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -823,6 +823,14 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+struct btrfs_dev_stats_item {
+	/*
+	 * grow this item struct at the end for future enhancements and keep
+	 * the existing values unchanged
+	 */
+	__le64 values[BTRFS_DEV_STAT_VALUES_MAX];
+} __attribute__ ((__packed__));
+
 /* different types of block groups (and chunks) */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1508,6 +1516,12 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
+ * Persistantly stores the io stats in the device tree.
+ * One key for all stats, (0, BTRFS_DEV_STATS_KEY, devid).
+ */
+#define BTRFS_DEV_STATS_KEY	249
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -2415,6 +2429,30 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 	return btrfs_item_size(eb, e) - offset;
 }
 
+/* btrfs_dev_stats_item */
+static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
+					struct btrfs_dev_stats_item *ptr,
+					int index)
+{
+	u64 val;
+
+	read_extent_buffer(eb, &val,
+			   offsetof(struct btrfs_dev_stats_item, values) +
+			    ((unsigned long)ptr) + (index * sizeof(u64)),
+			   sizeof(val));
+	return val;
+}
+
+static inline void btrfs_set_dev_stats_value(struct extent_buffer *eb,
+					     struct btrfs_dev_stats_item *ptr,
+					     int index, u64 val)
+{
+	write_extent_buffer(eb, &val,
+			    offsetof(struct btrfs_dev_stats_item, values) +
+			     ((unsigned long)ptr) + (index * sizeof(u64)),
+			    sizeof(val));
+}
+
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index da4d33f..00f541a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2353,6 +2353,13 @@ retry_root_backup:
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
+	ret = btrfs_init_dev_stats(fs_info);
+	if (ret) {
+		printk(KERN_ERR "btrfs: failed to init dev_stats: %d\n",
+		       ret);
+		goto fail_block_groups;
+	}
+
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
 		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index f38e452..5e23684 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -294,6 +294,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
+		case BTRFS_DEV_STATS_KEY:
+			printk(KERN_INFO "\t\tdevice stats\n");
+			break;
 		};
 	}
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3642225..82b03af 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -28,6 +28,7 @@
 #include "locking.h"
 #include "tree-log.h"
 #include "inode-map.h"
+#include "volumes.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -758,6 +759,9 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
+	ret = btrfs_run_dev_stats(trans, root->fs_info);
+	BUG_ON(ret);
+
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b9138b7..e7a1d2a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -40,6 +40,8 @@ static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
+static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
+static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
 static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
@@ -362,6 +364,7 @@ static noinline int device_list_add(const char *path,
 			return -ENOMEM;
 		}
 		device->devid = devid;
+		device->dev_stats_valid = 0;
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -4654,6 +4657,162 @@ error:
 	return ret;
 }
 
+static void __btrfs_reset_dev_stats(struct btrfs_device *dev)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
+		btrfs_dev_stat_reset(dev, i);
+}
+
+int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct extent_buffer *eb;
+	int slot;
+	int ret = 0;
+	struct btrfs_device *device;
+	struct btrfs_path *path = NULL;
+	int i;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		int item_size;
+		struct btrfs_dev_stats_item *ptr;
+
+		key.objectid = 0;
+		key.type = BTRFS_DEV_STATS_KEY;
+		key.offset = device->devid;
+		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
+		if (ret) {
+			printk(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
+			       device->name, (unsigned long long)device->devid);
+			__btrfs_reset_dev_stats(device);
+			device->dev_stats_valid = 1;
+			btrfs_release_path(path);
+			continue;
+		}
+		slot = path->slots[0];
+		eb = path->nodes[0];
+		btrfs_item_key_to_cpu(eb, &found_key, slot);
+		item_size = btrfs_item_size_nr(eb, slot);
+
+		ptr = btrfs_item_ptr(eb, slot,
+				     struct btrfs_dev_stats_item);
+
+		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
+			if (item_size >= (1 + i) * sizeof(__le64))
+				btrfs_dev_stat_set(device, i,
+					btrfs_dev_stats_value(eb, ptr, i));
+			else
+				btrfs_dev_stat_reset(device, i);
+		}
+
+		device->dev_stats_valid = 1;
+		btrfs_dev_stat_print_on_load(device);
+		btrfs_release_path(path);
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+out:
+	btrfs_free_path(path);
+	return ret < 0 ? ret : 0;
+}
+
+static int update_dev_stat_item(struct btrfs_trans_handle *trans,
+				struct btrfs_root *dev_root,
+				struct btrfs_device *device)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	struct btrfs_dev_stats_item *ptr;
+	int ret;
+	int i;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEV_STATS_KEY;
+	key.offset = device->devid;
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
+	if (ret < 0) {
+		printk(KERN_WARNING "btrfs: error %d while searching for dev_stats item for device %s!\n",
+		       ret, device->name);
+		goto out;
+	}
+
+	if (ret == 0 &&
+	    btrfs_item_size_nr(path->nodes[0], path->slots[0]) < sizeof(*ptr)) {
+		/* need to delete old one and insert a new one */
+		ret = btrfs_del_item(trans, dev_root, path);
+		if (ret != 0) {
+			printk(KERN_WARNING "btrfs: delete too small dev_stats item for device %s failed %d!\n",
+			       device->name, ret);
+			goto out;
+		}
+		ret = 1;
+	}
+
+	if (ret == 1) {
+		/* need to insert a new item */
+		btrfs_release_path(path);
+		ret = btrfs_insert_empty_item(trans, dev_root, path,
+					      &key, sizeof(*ptr));
+		if (ret < 0) {
+			printk(KERN_WARNING "btrfs: insert dev_stats item for device %s failed %d!\n",
+			       device->name, ret);
+			goto out;
+		}
+	}
+
+	eb = path->nodes[0];
+	ptr = btrfs_item_ptr(eb, path->slots[0], struct btrfs_dev_stats_item);
+	for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
+		btrfs_set_dev_stats_value(eb, ptr, i,
+					  btrfs_dev_stat_read(device, i));
+	btrfs_mark_buffer_dirty(eb);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * called from commit_transaction. Writes all changed device stats to disk.
+ */
+int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	int ret = 0;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (!device->dev_stats_valid || !device->dev_stats_dirty)
+			continue;
+
+		ret = update_dev_stat_item(trans, dev_root, device);
+		if (!ret)
+			device->dev_stats_dirty = 0;
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
+}
+
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index)
 {
 	btrfs_dev_stat_inc(dev, index);
@@ -4662,6 +4821,8 @@ void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index)
 
 void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 {
+	if (!dev->dev_stats_valid)
+		return;
 	printk_ratelimited(KERN_ERR
 			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
 			   dev->name,
@@ -4674,6 +4835,17 @@ void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 					       BTRFS_DEV_STAT_GENERATION_ERRS));
 }
 
+static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
+{
+	printk(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
+	       dev->name,
+	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
+	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
+	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
+	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
+	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_GENERATION_ERRS));
+}
+
 int btrfs_get_dev_stats(struct btrfs_root *root,
 			struct btrfs_ioctl_get_dev_stats *stats,
 			int reset_after_read)
@@ -4690,6 +4862,10 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 		printk(KERN_WARNING
 		       "btrfs: get dev_stats failed, device not found\n");
 		return -ENODEV;
+	} else if (!dev->dev_stats_valid) {
+		printk(KERN_WARNING
+		       "btrfs: get dev_stats failed, not yet valid\n");
+		return -ENODEV;
 	} else if (reset_after_read) {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
 			if (stats->nr_items > i)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6798f86..3406a88 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -109,6 +109,7 @@ struct btrfs_device {
 
 	/* disk I/O failure stats. For detailed description refer to
 	 * enum btrfs_dev_stat_values in ioctl.h */
+	int dev_stats_valid;
 	int dev_stats_dirty; /* counters need to be written to disk */
 	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
 };
@@ -293,6 +294,9 @@ void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,
 			struct btrfs_ioctl_get_dev_stats *stats,
 			int reset_after_read);
+int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
+int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
+			struct btrfs_fs_info *fs_info);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
1.7.10.2

