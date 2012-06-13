Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab2FMOGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 10:06:01 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5DE60Pr017052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 10:06:00 -0400
Received: from localhost.localdomain.com (vpn-11-249.rdu.redhat.com [10.11.11.249])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q5DE5xwY007337
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 10:06:00 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use rcu to protect device->name V3
Date: Wed, 13 Jun 2012 10:05:59 -0400
Message-Id: <1339596359-5514-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Al pointed out that we can just toss out the old name on a device and add a
new one arbitrarily, so anybody who uses device->name in printk could
possibly use free'd memory.  Instead of adding locking around all of this he
suggested doing it with RCU, so I've introduced a struct rcu_string that
does just that and have gone through and protected all accesses to
device->name that aren't under the uuid_mutex with rcu_read_lock().  This
protects us and I will use it for dealing with removing the device that we
used to mount the file system in a later patch.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V2->V3:
-fixed rcu_string_strdup to get the null character
-fixed __VA_ARGS__ usage
-undid 80 char line wrapping
-moved some rcu_strings into blocks
 fs/btrfs/check-integrity.c |   16 ++++---
 fs/btrfs/disk-io.c         |   10 +++--
 fs/btrfs/extent_io.c       |    7 ++-
 fs/btrfs/ioctl.c           |   13 +++++-
 fs/btrfs/rcu-string.h      |   56 ++++++++++++++++++++++++++
 fs/btrfs/scrub.c           |   30 +++++++++------
 fs/btrfs/volumes.c         |   92 +++++++++++++++++++++++++++----------------
 fs/btrfs/volumes.h         |    2 +-
 8 files changed, 162 insertions(+), 64 deletions(-)
 create mode 100644 fs/btrfs/rcu-string.h

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 9cebb1f..da6e936 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -93,6 +93,7 @@
 #include "print-tree.h"
 #include "locking.h"
 #include "check-integrity.h"
+#include "rcu-string.h"
 
 #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
 #define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
@@ -843,13 +844,14 @@ static int btrfsic_process_superblock_dev_mirror(
 		superblock_tmp->never_written = 0;
 		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
-			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
-			       " @%llu (%s/%llu/%d)\n",
-			       superblock_bdev, device->name,
-			       (unsigned long long)dev_bytenr,
-			       dev_state->name,
-			       (unsigned long long)dev_bytenr,
-			       superblock_mirror_num);
+			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p, %s)"
+				     " @%llu (%s/%llu/%d)\n",
+				     superblock_bdev,
+				     rcu_str_deref(device->name),
+				     (unsigned long long)dev_bytenr,
+				     dev_state->name,
+				     (unsigned long long)dev_bytenr,
+				     superblock_mirror_num);
 		list_add(&superblock_tmp->all_blocks_node,
 			 &state->all_blocks_list);
 		btrfsic_block_hashtable_add(superblock_tmp,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e39a3b9..43bd7b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -44,6 +44,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "check-integrity.h"
+#include "rcu-string.h"
 
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -2575,8 +2576,9 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 		struct btrfs_device *device = (struct btrfs_device *)
 			bh->b_private;
 
-		printk_ratelimited(KERN_WARNING "lost page write due to "
-				   "I/O error on %s\n", device->name);
+		printk_ratelimited_in_rcu(KERN_WARNING "lost page write due to "
+					  "I/O error on %s\n",
+					  rcu_str_deref(device->name));
 		/* note, we dont' set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
@@ -2749,8 +2751,8 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 		wait_for_completion(&device->flush_wait);
 
 		if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
-			printk("btrfs: disabling barriers on dev %s\n",
-			       device->name);
+			printk_in_rcu("btrfs: disabling barriers on dev %s\n",
+				      rcu_str_deref(device->name));
 			device->nobarriers = 1;
 		}
 		if (!bio_flagged(bio, BIO_UPTODATE)) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2c8f7b2..aaa12c1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -20,6 +20,7 @@
 #include "volumes.h"
 #include "check-integrity.h"
 #include "locking.h"
+#include "rcu-string.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -1917,9 +1918,9 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 		return -EIO;
 	}
 
-	printk(KERN_INFO "btrfs read error corrected: ino %lu off %llu (dev %s "
-			"sector %llu)\n", page->mapping->host->i_ino, start,
-			dev->name, sector);
+	printk_in_rcu(KERN_INFO "btrfs read error corrected: ino %lu off %llu "
+		      "(dev %s sector %llu)\n", page->mapping->host->i_ino,
+		      start, rcu_str_deref(dev->name), sector);
 
 	bio_put(bio);
 	return 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24b776c..c5254dd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -52,6 +52,7 @@
 #include "locking.h"
 #include "inode-map.h"
 #include "backref.h"
+#include "rcu-string.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -1345,8 +1346,9 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	do_div(new_size, root->sectorsize);
 	new_size *= root->sectorsize;
 
-	printk(KERN_INFO "btrfs: new size for %s is %llu\n",
-		device->name, (unsigned long long)new_size);
+	printk_in_rcu(KERN_INFO "btrfs: new size for %s is %llu\n",
+		      rcu_str_deref(device->name),
+		      (unsigned long long)new_size);
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 0);
@@ -2264,7 +2266,12 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->total_bytes = dev->total_bytes;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
 	if (dev->name) {
-		strncpy(di_args->path, dev->name, sizeof(di_args->path));
+		struct rcu_string *name;
+
+		rcu_read_lock();
+		name = rcu_dereference(dev->name);
+		strncpy(di_args->path, name->str, sizeof(di_args->path));
+		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
new file mode 100644
index 0000000..9e111e4
--- /dev/null
+++ b/fs/btrfs/rcu-string.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2012 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+struct rcu_string {
+	struct rcu_head rcu;
+	char str[0];
+};
+
+static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
+{
+	size_t len = strlen(src) + 1;
+	struct rcu_string *ret = kzalloc(sizeof(struct rcu_string) +
+					 (len * sizeof(char)), mask);
+	if (!ret)
+		return ret;
+	strncpy(ret->str, src, len);
+	return ret;
+}
+
+static inline void rcu_string_free(struct rcu_string *str)
+{
+	if (str)
+		kfree_rcu(str, rcu);
+}
+
+#define printk_in_rcu(fmt, ...) do {	\
+	rcu_read_lock();		\
+	printk(fmt, __VA_ARGS__);	\
+	rcu_read_unlock();		\
+} while (0)
+
+#define printk_ratelimited_in_rcu(fmt, ...) do {	\
+	rcu_read_lock();				\
+	printk_ratelimited(fmt, __VA_ARGS__);		\
+	rcu_read_unlock();				\
+} while (0)
+
+#define rcu_str_deref(rcu_str) ({				\
+	struct rcu_string *__str = rcu_dereference(rcu_str);	\
+	__str->str;						\
+})
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a38cfa4..b223620 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -26,6 +26,7 @@
 #include "backref.h"
 #include "extent_io.h"
 #include "check-integrity.h"
+#include "rcu-string.h"
 
 /*
  * This is only the first step towards a full-features scrub. It reads all
@@ -320,10 +321,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	 * hold all of the paths here
 	 */
 	for (i = 0; i < ipath->fspath->elem_cnt; ++i)
-		printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
+		printk_in_rcu(KERN_WARNING "btrfs: %s at logical %llu on dev "
 			"%s, sector %llu, root %llu, inode %llu, offset %llu, "
 			"length %llu, links %u (path: %s)\n", swarn->errstr,
-			swarn->logical, swarn->dev->name,
+			swarn->logical, rcu_str_deref(swarn->dev->name),
 			(unsigned long long)swarn->sector, root, inum, offset,
 			min(isize - offset, (u64)PAGE_SIZE), nlink,
 			(char *)(unsigned long)ipath->fspath->val[i]);
@@ -332,10 +333,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	return 0;
 
 err:
-	printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
+	printk_in_rcu(KERN_WARNING "btrfs: %s at logical %llu on dev "
 		"%s, sector %llu, root %llu, inode %llu, offset %llu: path "
 		"resolving failed with ret=%d\n", swarn->errstr,
-		swarn->logical, swarn->dev->name,
+		swarn->logical, rcu_str_deref(swarn->dev->name),
 		(unsigned long long)swarn->sector, root, inum, offset, ret);
 
 	free_ipath(ipath);
@@ -390,10 +391,11 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 		do {
 			ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
 							&ref_root, &ref_level);
-			printk(KERN_WARNING
+			printk_in_rcu(KERN_WARNING
 				"btrfs: %s at logical %llu on dev %s, "
 				"sector %llu: metadata %s (level %d) in tree "
-				"%llu\n", errstr, swarn.logical, dev->name,
+				"%llu\n", errstr, swarn.logical,
+				rcu_str_deref(dev->name),
 				(unsigned long long)swarn.sector,
 				ref_level ? "node" : "leaf",
 				ret < 0 ? -1 : ref_level,
@@ -580,9 +582,11 @@ out:
 		spin_lock(&sdev->stat_lock);
 		++sdev->stat.uncorrectable_errors;
 		spin_unlock(&sdev->stat_lock);
-		printk_ratelimited(KERN_ERR
+
+		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
-			(unsigned long long)fixup->logical, sdev->dev->name);
+			(unsigned long long)fixup->logical,
+			rcu_str_deref(sdev->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -936,18 +940,20 @@ corrected_error:
 			spin_lock(&sdev->stat_lock);
 			sdev->stat.corrected_errors++;
 			spin_unlock(&sdev->stat_lock);
-			printk_ratelimited(KERN_ERR
+			printk_ratelimited_in_rcu(KERN_ERR
 				"btrfs: fixed up error at logical %llu on dev %s\n",
-				(unsigned long long)logical, sdev->dev->name);
+				(unsigned long long)logical,
+				rcu_str_deref(sdev->dev->name));
 		}
 	} else {
 did_not_correct_error:
 		spin_lock(&sdev->stat_lock);
 		sdev->stat.uncorrectable_errors++;
 		spin_unlock(&sdev->stat_lock);
-		printk_ratelimited(KERN_ERR
+		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (regular) error at logical %llu on dev %s\n",
-			(unsigned long long)logical, sdev->dev->name);
+			(unsigned long long)logical,
+			rcu_str_deref(sdev->dev->name));
 	}
 
 out:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7782020..8a3d259 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -35,6 +35,7 @@
 #include "volumes.h"
 #include "async-thread.h"
 #include "check-integrity.h"
+#include "rcu-string.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -64,7 +65,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 		device = list_entry(fs_devices->devices.next,
 				    struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
-		kfree(device->name);
+		rcu_string_free(device->name);
 		kfree(device);
 	}
 	kfree(fs_devices);
@@ -334,8 +335,8 @@ static noinline int device_list_add(const char *path,
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
+	struct rcu_string *name;
 	u64 found_transid = btrfs_super_generation(disk_super);
-	char *name;
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
@@ -369,11 +370,13 @@ static noinline int device_list_add(const char *path,
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
 		spin_lock_init(&device->io_lock);
-		device->name = kstrdup(path, GFP_NOFS);
-		if (!device->name) {
+
+		name = rcu_string_strdup(path, GFP_NOFS);
+		if (!name) {
 			kfree(device);
 			return -ENOMEM;
 		}
+		rcu_assign_pointer(device->name, name);
 		INIT_LIST_HEAD(&device->dev_alloc_list);
 
 		/* init readahead state */
@@ -390,12 +393,12 @@ static noinline int device_list_add(const char *path,
 
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
-	} else if (!device->name || strcmp(device->name, path)) {
-		name = kstrdup(path, GFP_NOFS);
+	} else if (!device->name || strcmp(device->name->str, path)) {
+		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
 			return -ENOMEM;
-		kfree(device->name);
-		device->name = name;
+		rcu_string_free(device->name);
+		rcu_assign_pointer(device->name, name);
 		if (device->missing) {
 			fs_devices->missing_devices--;
 			device->missing = 0;
@@ -430,15 +433,22 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 
 	/* We have held the volume lock, it is safe to get the devices. */
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
+		struct rcu_string *name;
+
 		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
 			goto error;
 
-		device->name = kstrdup(orig_dev->name, GFP_NOFS);
-		if (!device->name) {
+		/*
+		 * This is ok to do without rcu read locked because we hold the
+		 * uuid mutex so nothing we touch in here is going to disappear.
+		 */
+		name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
+		if (!name) {
 			kfree(device);
 			goto error;
 		}
+		rcu_assign_pointer(device->name, name);
 
 		device->devid = orig_dev->devid;
 		device->work.func = pending_bios_fn;
@@ -491,7 +501,7 @@ again:
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
-		kfree(device->name);
+		rcu_string_free(device->name);
 		kfree(device);
 	}
 
@@ -516,7 +526,7 @@ static void __free_device(struct work_struct *work)
 	if (device->bdev)
 		blkdev_put(device->bdev, device->mode);
 
-	kfree(device->name);
+	rcu_string_free(device->name);
 	kfree(device);
 }
 
@@ -540,6 +550,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		struct btrfs_device *new_device;
+		struct rcu_string *name;
 
 		if (device->bdev)
 			fs_devices->open_devices--;
@@ -555,8 +566,11 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
 		BUG_ON(!new_device); /* -ENOMEM */
 		memcpy(new_device, device, sizeof(*new_device));
-		new_device->name = kstrdup(device->name, GFP_NOFS);
-		BUG_ON(device->name && !new_device->name); /* -ENOMEM */
+
+		/* Safe because we are under uuid_mutex */
+		name = rcu_string_strdup(device->name->str, GFP_NOFS);
+		BUG_ON(device->name && !name); /* -ENOMEM */
+		rcu_assign_pointer(new_device->name, name);
 		new_device->bdev = NULL;
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
@@ -621,9 +635,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		if (!device->name)
 			continue;
 
-		bdev = blkdev_get_by_path(device->name, flags, holder);
+		bdev = blkdev_get_by_path(device->name->str, flags, holder);
 		if (IS_ERR(bdev)) {
-			printk(KERN_INFO "open %s failed\n", device->name);
+			printk(KERN_INFO "open %s failed\n", device->name->str);
 			goto error;
 		}
 		filemap_write_and_wait(bdev->bd_inode->i_mapping);
@@ -1632,6 +1646,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	struct block_device *bdev;
 	struct list_head *devices;
 	struct super_block *sb = root->fs_info->sb;
+	struct rcu_string *name;
 	u64 total_bytes;
 	int seeding_dev = 0;
 	int ret = 0;
@@ -1671,23 +1686,24 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		goto error;
 	}
 
-	device->name = kstrdup(device_path, GFP_NOFS);
-	if (!device->name) {
+	name = rcu_string_strdup(device_path, GFP_NOFS);
+	if (!name) {
 		kfree(device);
 		ret = -ENOMEM;
 		goto error;
 	}
+	rcu_assign_pointer(device->name, name);
 
 	ret = find_next_devid(root, &device->devid);
 	if (ret) {
-		kfree(device->name);
+		rcu_string_free(device->name);
 		kfree(device);
 		goto error;
 	}
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		kfree(device->name);
+		rcu_string_free(device->name);
 		kfree(device);
 		ret = PTR_ERR(trans);
 		goto error;
@@ -1796,7 +1812,7 @@ error_trans:
 	unlock_chunks(root);
 	btrfs_abort_transaction(trans, root, ret);
 	btrfs_end_transaction(trans, root);
-	kfree(device->name);
+	rcu_string_free(device->name);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
@@ -4204,10 +4220,17 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
 		dev = bbio->stripes[dev_nr].dev;
 		if (dev && dev->bdev && (rw != WRITE || dev->writeable)) {
+#ifdef DEBUG
+			struct rcu_string *name;
+
+			rcu_read_lock();
+			name = rcu_dereference(dev->name);
 			pr_debug("btrfs_map_bio: rw %d, secor=%llu, dev=%lu "
 				 "(%s id %llu), size=%u\n", rw,
 				 (u64)bio->bi_sector, (u_long)dev->bdev->bd_dev,
-				 dev->name, dev->devid, bio->bi_size);
+				 name->str, dev->devid, bio->bi_size);
+			rcu_read_unlock();
+#endif
 			bio->bi_bdev = dev->bdev;
 			if (async_submit)
 				schedule_bio(root, dev, rw, bio);
@@ -4694,8 +4717,9 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 		key.offset = device->devid;
 		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
 		if (ret) {
-			printk(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
-			       device->name, (unsigned long long)device->devid);
+			printk_in_rcu(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
+				      rcu_str_deref(device->name),
+				      (unsigned long long)device->devid);
 			__btrfs_reset_dev_stats(device);
 			device->dev_stats_valid = 1;
 			btrfs_release_path(path);
@@ -4747,8 +4771,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 	BUG_ON(!path);
 	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
 	if (ret < 0) {
-		printk(KERN_WARNING "btrfs: error %d while searching for dev_stats item for device %s!\n",
-		       ret, device->name);
+		printk_in_rcu(KERN_WARNING "btrfs: error %d while searching for dev_stats item for device %s!\n",
+			      ret, rcu_str_deref(device->name));
 		goto out;
 	}
 
@@ -4757,8 +4781,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 		/* need to delete old one and insert a new one */
 		ret = btrfs_del_item(trans, dev_root, path);
 		if (ret != 0) {
-			printk(KERN_WARNING "btrfs: delete too small dev_stats item for device %s failed %d!\n",
-			       device->name, ret);
+			printk_in_rcu(KERN_WARNING "btrfs: delete too small dev_stats item for device %s failed %d!\n",
+				      rcu_str_deref(device->name), ret);
 			goto out;
 		}
 		ret = 1;
@@ -4770,8 +4794,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 		ret = btrfs_insert_empty_item(trans, dev_root, path,
 					      &key, sizeof(*ptr));
 		if (ret < 0) {
-			printk(KERN_WARNING "btrfs: insert dev_stats item for device %s failed %d!\n",
-			       device->name, ret);
+			printk_in_rcu(KERN_WARNING "btrfs: insert dev_stats item for device %s failed %d!\n",
+				      rcu_str_deref(device->name), ret);
 			goto out;
 		}
 	}
@@ -4823,9 +4847,9 @@ void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 {
 	if (!dev->dev_stats_valid)
 		return;
-	printk_ratelimited(KERN_ERR
+	printk_ratelimited_in_rcu(KERN_ERR
 			   "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
-			   dev->name,
+			   rcu_str_deref(dev->name),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
@@ -4837,8 +4861,8 @@ void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 {
-	printk(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
-	       dev->name,
+	printk_in_rcu(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
+	       rcu_str_deref(dev->name),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3406a88..74366f2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -58,7 +58,7 @@ struct btrfs_device {
 	/* the mode sent to blkdev_get */
 	fmode_t mode;
 
-	char *name;
+	struct rcu_string *name;
 
 	/* the internal btrfs device id */
 	u64 devid;
-- 
1.7.7.6

