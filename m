Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50803 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab2EPQut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:50:49 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id C1510239
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:50:47 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/3] Btrfs: read device stats on mount, write modified ones during commit
Date: Wed, 16 May 2012 18:50:47 +0200
Message-Id: <f7e60650b3463d028f86b38ef3e6aaf77efa665b.1337185201.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1337185201.git.sbehrens@giantdisaster.de>
References: <cover.1337185201.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1337185201.git.sbehrens@giantdisaster.de>
References: <cover.1337185201.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The device statistics are written into the device tree with each
transaction commit. Only modified statistics are written.
When a filesystem is mounted, the device statistics for each involved
device are read from the device tree and used to initialize the
counters.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       |   51 ++++++++++++
 fs/btrfs/disk-io.c     |    7 ++
 fs/btrfs/print-tree.c  |    3 +
 fs/btrfs/transaction.c |    4 +
 fs/btrfs/volumes.c     |  205 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |    9 +++
 6 files changed, 279 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ec42a24..1dd7651 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -823,6 +823,26 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+struct btrfs_device_stats_item {
+	/*
+	 * grow this item struct at the end for future enhancements and keep
+	 * the existing values unchanged
+	 */
+	__le64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__le64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
+	__le64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
+
+	/* stats for indirect indications for I/O failures */
+	__le64 cnt_corruption_errs; /* checksum error, bytenr error or
+				     * contents is illegal: this is an
+				     * indication that the block was damaged
+				     * during read or write, or written to
+				     * wrong location or read from wrong
+				     * location */
+	__le64 cnt_generation_errs; /* an indication that blocks have not
+				     * been written */
+} __attribute__ ((__packed__));
+
 /* different types of block groups (and chunks) */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1508,6 +1528,12 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
+ * Persistantly stores the io stats in the device tree.
+ * One key for all stats, (0, BTRFS_DEVICE_STATS_KEY, devid).
+ */
+#define BTRFS_DEVICE_STATS_KEY	249
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -2415,6 +2441,31 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 	return btrfs_item_size(eb, e) - offset;
 }
 
+/* btrfs_device_stats_item */
+BTRFS_SETGET_FUNCS(device_stats_cnt_write_io_errs,
+		   struct btrfs_device_stats_item, cnt_write_io_errs, 64);
+BTRFS_SETGET_FUNCS(device_stats_cnt_read_io_errs,
+		   struct btrfs_device_stats_item, cnt_read_io_errs, 64);
+BTRFS_SETGET_FUNCS(device_stats_cnt_flush_io_errs,
+		   struct btrfs_device_stats_item, cnt_flush_io_errs, 64);
+BTRFS_SETGET_FUNCS(device_stats_cnt_corruption_errs,
+		   struct btrfs_device_stats_item, cnt_corruption_errs, 64);
+BTRFS_SETGET_FUNCS(device_stats_cnt_generation_errs,
+		   struct btrfs_device_stats_item, cnt_generation_errs, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_device_stats_cnt_write_io_errs,
+			 struct btrfs_device_stats_item, cnt_write_io_errs, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_stats_cnt_read_io_errs,
+			 struct btrfs_device_stats_item, cnt_read_io_errs, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_stats_cnt_flush_io_errs,
+			 struct btrfs_device_stats_item, cnt_flush_io_errs, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_stats_cnt_corruption_errs,
+			 struct btrfs_device_stats_item, cnt_corruption_errs,
+			 64);
+BTRFS_SETGET_STACK_FUNCS(stack_device_stats_cnt_generation_errs,
+			 struct btrfs_device_stats_item, cnt_generation_errs,
+			 64);
+
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e123629..7ba08f7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2353,6 +2353,13 @@ retry_root_backup:
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
+	ret = btrfs_init_device_stats(fs_info);
+	if (ret) {
+		printk(KERN_ERR "btrfs: failed to init device_stats: %d\n",
+		       ret);
+		goto fail_block_groups;
+	}
+
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
 		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index f38e452..a9e45e4 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -294,6 +294,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
+		case BTRFS_DEVICE_STATS_KEY:
+			printk(KERN_INFO "\t\tdevice stats\n");
+			break;
 		};
 	}
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3642225..1722af0 100644
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
 
+	ret = btrfs_run_device_stats(trans, root->fs_info);
+	BUG_ON(ret);
+
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5f5a6ce..80d1a50 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -40,6 +40,8 @@ static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
+static void __btrfs_reset_device_stats(struct btrfs_device *dev);
+static void btrfs_device_stat_print_on_load(struct btrfs_device *device);
 
 static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
@@ -362,6 +364,7 @@ static noinline int device_list_add(const char *path,
 			return -ENOMEM;
 		}
 		device->devid = devid;
+		device->device_stats_valid = 0;
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -4626,8 +4629,194 @@ error:
 	return ret;
 }
 
+static void __btrfs_reset_device_stats(struct btrfs_device *device)
+{
+	btrfs_device_stat_reset(&device->cnt_write_io_errs);
+	btrfs_device_stat_reset(&device->cnt_read_io_errs);
+	btrfs_device_stat_reset(&device->cnt_flush_io_errs);
+	btrfs_device_stat_reset(&device->cnt_corruption_errs);
+	btrfs_device_stat_reset(&device->cnt_generation_errs);
+}
+
+int btrfs_init_device_stats(struct btrfs_fs_info *fs_info)
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
+		struct btrfs_device_stats_item *ptr;
+
+		key.objectid = 0;
+		key.type = BTRFS_DEVICE_STATS_KEY;
+		key.offset = device->devid;
+		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
+		if (ret) {
+			printk(KERN_WARNING "btrfs: no device_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
+			       device->name, (unsigned long long)device->devid);
+			__btrfs_reset_device_stats(device);
+			device->device_stats_valid = 1;
+			device->device_stats_dirty = 1;
+			btrfs_release_path(path);
+			continue;
+		}
+		slot = path->slots[0];
+		eb = path->nodes[0];
+		btrfs_item_key_to_cpu(eb, &found_key, slot);
+		item_size = btrfs_item_size_nr(eb, slot);
+
+		ptr = btrfs_item_ptr(eb, slot,
+				     struct btrfs_device_stats_item);
+
+		if (item_size >= 1 * sizeof(__le64))
+			btrfs_device_stat_set(&device->cnt_write_io_errs,
+				btrfs_device_stats_cnt_write_io_errs(eb, ptr));
+		else
+			btrfs_device_stat_reset(&device->cnt_write_io_errs);
+		if (item_size >= 2 * sizeof(__le64))
+			btrfs_device_stat_set(&device->cnt_read_io_errs,
+				btrfs_device_stats_cnt_read_io_errs(eb, ptr));
+		else
+			btrfs_device_stat_reset(&device->cnt_read_io_errs);
+		if (item_size >= 3 * sizeof(__le64))
+			btrfs_device_stat_set(&device->cnt_flush_io_errs,
+				btrfs_device_stats_cnt_flush_io_errs(eb, ptr));
+		else
+			btrfs_device_stat_reset(&device->cnt_flush_io_errs);
+		if (item_size >= 4 * sizeof(__le64))
+			btrfs_device_stat_set(&device->cnt_corruption_errs,
+				btrfs_device_stats_cnt_corruption_errs(eb,
+								       ptr));
+		else
+			btrfs_device_stat_reset(&device->cnt_corruption_errs);
+		if (item_size >= 5 * sizeof(__le64))
+			btrfs_device_stat_set(&device->cnt_generation_errs,
+				btrfs_device_stats_cnt_generation_errs(eb,
+								       ptr));
+		else
+			btrfs_device_stat_reset(&device->cnt_generation_errs);
+
+		btrfs_device_stat_print_on_load(device);
+		device->device_stats_valid = 1;
+		btrfs_release_path(path);
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+out:
+	btrfs_free_path(path);
+	return ret < 0 ? ret : 0;
+}
+
+static int update_device_stat_item(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *dev_root,
+				   struct btrfs_device *device)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	struct btrfs_device_stats_item *ptr;
+	int ret;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEVICE_STATS_KEY;
+	key.offset = device->devid;
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+	ret = btrfs_search_slot(trans, dev_root, &key, path, 0, 1);
+	if (ret < 0) {
+		printk(KERN_WARNING "btrfs: error %d while searching for device_stats item for device %s!\n",
+		       ret, device->name);
+		goto out;
+	}
+
+	if (0 == ret &&
+	    btrfs_item_size_nr(path->nodes[0], path->slots[0]) < sizeof(*ptr)) {
+		/* need to delete old one and insert a new one */
+		ret = btrfs_del_item(trans, dev_root, path);
+		if (0 != ret) {
+			printk(KERN_WARNING "btrfs: delete too small device_stats item for device %s failed %d!\n",
+			       device->name, ret);
+			goto out;
+		}
+		ret = 1;
+	}
+
+	if (1 == ret) {
+		/* need to insert a new item */
+		btrfs_release_path(path);
+		ret = btrfs_insert_empty_item(trans, dev_root, path,
+					      &key, sizeof(*ptr));
+		if (ret < 0) {
+			printk(KERN_WARNING "btrfs: insert device_stats item for device %s failed %d!\n",
+			       device->name, ret);
+			goto out;
+		}
+	}
+
+	eb = path->nodes[0];
+	ptr = btrfs_item_ptr(eb, path->slots[0],
+			     struct btrfs_device_stats_item);
+	btrfs_set_device_stats_cnt_write_io_errs(eb, ptr,
+		btrfs_device_stat_read(&device->cnt_write_io_errs));
+	btrfs_set_device_stats_cnt_read_io_errs(eb, ptr,
+		btrfs_device_stat_read(&device->cnt_read_io_errs));
+	btrfs_set_device_stats_cnt_flush_io_errs(eb, ptr,
+		btrfs_device_stat_read(&device->cnt_flush_io_errs));
+	btrfs_set_device_stats_cnt_corruption_errs(eb, ptr,
+		btrfs_device_stat_read(&device->cnt_corruption_errs));
+	btrfs_set_device_stats_cnt_generation_errs(eb, ptr,
+		btrfs_device_stat_read(&device->cnt_generation_errs));
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
+int btrfs_run_device_stats(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	int ret = 0;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (!device->device_stats_valid || !device->device_stats_dirty)
+			continue;
+
+		ret = update_device_stat_item(trans, dev_root, device);
+		if (!ret)
+			device->device_stats_dirty = 0;
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
+}
+
 void btrfs_device_stat_print_on_error(struct btrfs_device *device)
 {
+	if (!device->device_stats_valid)
+		return;
 	printk_ratelimited(KERN_ERR
 			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
 			   device->name,
@@ -4639,6 +4828,18 @@ void btrfs_device_stat_print_on_error(struct btrfs_device *device)
 				&device->cnt_generation_errs));
 }
 
+static void btrfs_device_stat_print_on_load(struct btrfs_device *device)
+{
+	printk(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u,"
+	       " corrupt %u, gen %u\n",
+	       device->name,
+	       btrfs_device_stat_read(&device->cnt_write_io_errs),
+	       btrfs_device_stat_read(&device->cnt_read_io_errs),
+	       btrfs_device_stat_read(&device->cnt_flush_io_errs),
+	       btrfs_device_stat_read(&device->cnt_corruption_errs),
+	       btrfs_device_stat_read(&device->cnt_generation_errs));
+}
+
 int btrfs_get_device_stats(struct btrfs_root *root,
 			   struct btrfs_ioctl_get_device_stats *stats,
 			   int reset_after_read)
@@ -4654,6 +4855,10 @@ int btrfs_get_device_stats(struct btrfs_root *root,
 		printk(KERN_WARNING
 		       "btrfs: get device_stats failed, device not found\n");
 		return -ENODEV;
+	} else if (!dev->device_stats_valid) {
+		printk(KERN_WARNING
+		       "btrfs: get device_stats failed, not yet valid\n");
+		return -ENODEV;
 	} else if (reset_after_read) {
 		if (stats->nr_items >= 1)
 			stats->cnt_write_io_errs =
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index e0b31f1..3134662 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -108,6 +108,7 @@ struct btrfs_device {
 
 	/* disk I/O failure stats. For detailed description refer to
 	 * struct btrfs_device_stats_item in ctree.h */
+	int device_stats_valid;
 	int device_stats_dirty; /* counters need to be written to disk */
 	atomic_t cnt_write_io_errs;
 	atomic_t cnt_read_io_errs;
@@ -291,6 +292,9 @@ int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
 struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
 						   u64 logical, int mirror_num);
+int btrfs_init_device_stats(struct btrfs_fs_info *fs_info);
+int btrfs_run_device_stats(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info);
 void btrfs_device_stat_print_on_error(struct btrfs_device *device);
 int btrfs_get_device_stats(struct btrfs_root *root,
 			   struct btrfs_ioctl_get_device_stats *stats,
@@ -315,4 +319,9 @@ static inline void btrfs_device_stat_reset(atomic_t *cnt)
 {
 	atomic_set(cnt, 0);
 }
+
+static inline void btrfs_device_stat_set(atomic_t *cnt, unsigned long val)
+{
+	atomic_set(cnt, val);
+}
 #endif
-- 
1.7.10.2

