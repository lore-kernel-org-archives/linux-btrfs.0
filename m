Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:48763 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp1) (RZmta 30.22 OK)
	with ESMTP id X022c8oA6As7hE for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 20/26] Btrfs: change core code of btrfs to support the device replace operations
Date: Tue,  6 Nov 2012 17:38:38 +0100
Message-Id: <70e02d0c5bbdab2e80d0ebcda6910a1d933f86a5.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This commit contains all the essential changes to the core code
of Btrfs for support of the device replace procedure.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/Makefile      |   2 +-
 fs/btrfs/ctree.h       |   2 +
 fs/btrfs/disk-io.c     |  24 +++++-
 fs/btrfs/reada.c       |  17 +++++
 fs/btrfs/scrub.c       |   7 +-
 fs/btrfs/super.c       |  13 ++++
 fs/btrfs/transaction.c |   7 +-
 fs/btrfs/volumes.c     | 193 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h     |  11 ++-
 9 files changed, 261 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index d7fcdba..7df3e0f 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o qgroup.o send.o
+	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e17f211..7c9e4f7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -142,6 +142,8 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_EMPTY_SUBVOL_DIR_OBJECTID 2
 
+#define BTRFS_DEV_REPLACE_DEVID 0
+
 /*
  * the max metadata block size.  This limit is somewhat artificial,
  * but the memmove costs go through the roof for larger blocks.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dbe0434..509fce2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -45,6 +45,7 @@
 #include "inode-map.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "dev-replace.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2438,7 +2439,11 @@ int open_ctree(struct super_block *sb,
 		goto fail_tree_roots;
 	}
 
-	btrfs_close_extra_devices(fs_devices);
+	/*
+	 * keep the device that is marked to be the target device for the
+	 * dev_replace procedure
+	 */
+	btrfs_close_extra_devices(fs_info, fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
 		printk(KERN_CRIT "btrfs: failed to read devices on %s\n",
@@ -2510,6 +2515,14 @@ retry_root_backup:
 		goto fail_block_groups;
 	}
 
+	ret = btrfs_init_dev_replace(fs_info);
+	if (ret) {
+		pr_err("btrfs: failed to init dev_replace: %d\n", ret);
+		goto fail_block_groups;
+	}
+
+	btrfs_close_extra_devices(fs_info, fs_devices, 1);
+
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
 		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
@@ -2658,6 +2671,13 @@ retry_root_backup:
 		return ret;
 	}
 
+	ret = btrfs_resume_dev_replace_async(fs_info);
+	if (ret) {
+		pr_warn("btrfs: failed to resume dev_replace\n");
+		close_ctree(tree_root);
+		return ret;
+	}
+
 	return 0;
 
 fail_qgroup:
@@ -3300,6 +3320,8 @@ int close_ctree(struct btrfs_root *root)
 	/* pause restriper - we want to resume on mount */
 	btrfs_pause_balance(fs_info);
 
+	btrfs_dev_replace_suspend_for_unmount(fs_info);
+
 	btrfs_scrub_cancel(fs_info);
 
 	/* wait for any defraggers to finish */
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 9f363e1..c705a48 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -27,6 +27,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "dev-replace.h"
 
 #undef DEBUG
 
@@ -331,6 +332,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	int nzones = 0;
 	int i;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
+	int dev_replace_is_ongoing;
 
 	spin_lock(&fs_info->reada_lock);
 	re = radix_tree_lookup(&fs_info->reada_tree, index);
@@ -392,6 +394,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	}
 
 	/* insert extent in reada_tree + all per-device trees, all or nothing */
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
@@ -399,13 +402,17 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		BUG_ON(!re_exist);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
+		btrfs_dev_replace_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
+		btrfs_dev_replace_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	prev_dev = NULL;
+	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(
+			&fs_info->dev_replace);
 	for (i = 0; i < nzones; ++i) {
 		dev = bbio->stripes[i].dev;
 		if (dev == prev_dev) {
@@ -422,6 +429,14 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			/* cannot read ahead on missing device */
 			continue;
 		}
+		if (dev_replace_is_ongoing &&
+		    dev == fs_info->dev_replace.tgtdev) {
+			/*
+			 * as this device is selected for reading only as
+			 * a last resort, skip it for read ahead.
+			 */
+			continue;
+		}
 		prev_dev = dev;
 		ret = radix_tree_insert(&dev->reada_extents, index, re);
 		if (ret) {
@@ -434,10 +449,12 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			BUG_ON(fs_info == NULL);
 			radix_tree_delete(&fs_info->reada_tree, index);
 			spin_unlock(&fs_info->reada_lock);
+			btrfs_dev_replace_unlock(&fs_info->dev_replace);
 			goto error;
 		}
 	}
 	spin_unlock(&fs_info->reada_lock);
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
 
 	kfree(bbio);
 	return re;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 59c69e0..8bfe782 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2841,12 +2841,17 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EIO;
 	}
 
-	if (dev->scrub_device) {
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
+	if (dev->scrub_device ||
+	    (!is_dev_replace &&
+	     btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
+		btrfs_dev_replace_unlock(&fs_info->dev_replace);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		scrub_workers_put(fs_info);
 		return -EINPROGRESS;
 	}
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
 	sctx = scrub_setup_ctx(dev, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8ad5f15..9a89423 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -55,6 +55,7 @@
 #include "export.h"
 #include "compression.h"
 #include "rcu-string.h"
+#include "dev-replace.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1233,8 +1234,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		return 0;
 
 	if (*flags & MS_RDONLY) {
+		/*
+		 * this also happens on 'umount -rf' or on shutdown, when
+		 * the filesystem is busy.
+		 */
 		sb->s_flags |= MS_RDONLY;
 
+		btrfs_dev_replace_suspend_for_unmount(fs_info);
+		btrfs_scrub_cancel(fs_info);
+
 		ret = btrfs_commit_super(root);
 		if (ret)
 			goto restore;
@@ -1271,6 +1279,11 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (ret)
 			goto restore;
 
+		ret = btrfs_resume_dev_replace_async(fs_info);
+		if (ret) {
+			pr_warn("btrfs: failed to resume dev_replace\n");
+			goto restore;
+		}
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 259f74e..063e49e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -30,6 +30,7 @@
 #include "tree-log.h"
 #include "inode-map.h"
 #include "volumes.h"
+#include "dev-replace.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -848,7 +849,9 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_run_dev_stats(trans, root->fs_info);
-	BUG_ON(ret);
+	WARN_ON(ret);
+	ret = btrfs_run_dev_replace(trans, root->fs_info);
+	WARN_ON(ret);
 
 	ret = btrfs_run_qgroups(trans, root->fs_info);
 	BUG_ON(ret);
@@ -871,6 +874,8 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	switch_commit_root(fs_info->extent_root);
 	up_write(&fs_info->extent_commit_sem);
 
+	btrfs_after_dev_replace_commit(fs_info);
+
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9233219..3ef0df2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -36,6 +36,7 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "math.h"
+#include "dev-replace.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -467,7 +468,8 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
+void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
+			       struct btrfs_fs_devices *fs_devices, int step)
 {
 	struct btrfs_device *device, *next;
 
@@ -490,6 +492,21 @@ again:
 			continue;
 		}
 
+		if (device->devid == BTRFS_DEV_REPLACE_DEVID) {
+			/*
+			 * In the first step, keep the device which has
+			 * the correct fsid and the devid that is used
+			 * for the dev_replace procedure.
+			 * In the second step, the dev_replace state is
+			 * read from the device tree and it is known
+			 * whether the procedure is really active or
+			 * not, which means whether this device is
+			 * used or whether it should be removed.
+			 */
+			if (step == 0 || device->is_tgtdev_for_dev_replace) {
+				continue;
+			}
+		}
 		if (device->bdev) {
 			blkdev_put(device->bdev, device->mode);
 			device->bdev = NULL;
@@ -498,7 +515,8 @@ again:
 		if (device->writeable) {
 			list_del_init(&device->dev_alloc_list);
 			device->writeable = 0;
-			fs_devices->rw_devices--;
+			if (!device->is_tgtdev_for_dev_replace)
+				fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
 		fs_devices->num_devices--;
@@ -556,7 +574,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		if (device->bdev)
 			fs_devices->open_devices--;
 
-		if (device->writeable) {
+		if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 			list_del_init(&device->dev_alloc_list);
 			fs_devices->rw_devices--;
 		}
@@ -688,7 +706,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			fs_devices->rotating = 1;
 
 		fs_devices->open_devices++;
-		if (device->writeable) {
+		if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 			fs_devices->rw_devices++;
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
@@ -1332,16 +1350,22 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		root->fs_info->avail_system_alloc_bits |
 		root->fs_info->avail_metadata_alloc_bits;
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->num_devices <= 4) {
+	num_devices = root->fs_info->fs_devices->num_devices;
+	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace)) {
+		WARN_ON(num_devices < 1);
+		num_devices--;
+	}
+	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
 		printk(KERN_ERR "btrfs: unable to go below four devices "
 		       "on raid10\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->num_devices <= 2) {
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
 		printk(KERN_ERR "btrfs: unable to go below two "
 		       "devices on raid1\n");
 		ret = -EINVAL;
@@ -1527,6 +1551,53 @@ error_undo:
 	goto error_brelse;
 }
 
+void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
+				 struct btrfs_device *srcdev)
+{
+	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
+	list_del_rcu(&srcdev->dev_list);
+	list_del_rcu(&srcdev->dev_alloc_list);
+	fs_info->fs_devices->num_devices--;
+	if (srcdev->missing) {
+		fs_info->fs_devices->missing_devices--;
+		fs_info->fs_devices->rw_devices++;
+	}
+	if (srcdev->can_discard)
+		fs_info->fs_devices->num_can_discard--;
+	if (srcdev->bdev)
+		fs_info->fs_devices->open_devices--;
+
+	call_rcu(&srcdev->rcu, free_device);
+}
+
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
+				      struct btrfs_device *tgtdev)
+{
+	struct btrfs_device *next_device;
+
+	WARN_ON(!tgtdev);
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	if (tgtdev->bdev) {
+		btrfs_scratch_superblock(tgtdev);
+		fs_info->fs_devices->open_devices--;
+	}
+	fs_info->fs_devices->num_devices--;
+	if (tgtdev->can_discard)
+		fs_info->fs_devices->num_can_discard++;
+
+	next_device = list_entry(fs_info->fs_devices->devices.next,
+				 struct btrfs_device, dev_list);
+	if (tgtdev->bdev == fs_info->sb->s_bdev)
+		fs_info->sb->s_bdev = next_device->bdev;
+	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
+		fs_info->fs_devices->latest_bdev = next_device->bdev;
+	list_del_rcu(&tgtdev->dev_list);
+
+	call_rcu(&tgtdev->rcu, free_device);
+
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+}
+
 int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
 			      struct btrfs_device **device)
 {
@@ -1935,6 +2006,98 @@ error:
 	return ret;
 }
 
+int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
+				  struct btrfs_device **device_out)
+{
+	struct request_queue *q;
+	struct btrfs_device *device;
+	struct block_device *bdev;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct list_head *devices;
+	struct rcu_string *name;
+	int ret = 0;
+
+	*device_out = NULL;
+	if (fs_info->fs_devices->seeding)
+		return -EINVAL;
+
+	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
+				  fs_info->bdev_holder);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	filemap_write_and_wait(bdev->bd_inode->i_mapping);
+
+	devices = &fs_info->fs_devices->devices;
+	list_for_each_entry(device, devices, dev_list) {
+		if (device->bdev == bdev) {
+			ret = -EEXIST;
+			goto error;
+		}
+	}
+
+	device = kzalloc(sizeof(*device), GFP_NOFS);
+	if (!device) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	name = rcu_string_strdup(device_path, GFP_NOFS);
+	if (!name) {
+		kfree(device);
+		ret = -ENOMEM;
+		goto error;
+	}
+	rcu_assign_pointer(device->name, name);
+
+	q = bdev_get_queue(bdev);
+	if (blk_queue_discard(q))
+		device->can_discard = 1;
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	device->writeable = 1;
+	device->work.func = pending_bios_fn;
+	generate_random_uuid(device->uuid);
+	device->devid = BTRFS_DEV_REPLACE_DEVID;
+	spin_lock_init(&device->io_lock);
+	device->generation = 0;
+	device->io_width = root->sectorsize;
+	device->io_align = root->sectorsize;
+	device->sector_size = root->sectorsize;
+	device->total_bytes = i_size_read(bdev->bd_inode);
+	device->disk_total_bytes = device->total_bytes;
+	device->dev_root = fs_info->dev_root;
+	device->bdev = bdev;
+	device->in_fs_metadata = 1;
+	device->is_tgtdev_for_dev_replace = 1;
+	device->mode = FMODE_EXCL;
+	set_blocksize(device->bdev, 4096);
+	device->fs_devices = fs_info->fs_devices;
+	list_add(&device->dev_list, &fs_info->fs_devices->devices);
+	fs_info->fs_devices->num_devices++;
+	fs_info->fs_devices->open_devices++;
+	if (device->can_discard)
+		fs_info->fs_devices->num_can_discard++;
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+
+	*device_out = device;
+	return ret;
+
+error:
+	blkdev_put(bdev, FMODE_EXCL);
+	return ret;
+}
+
+void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
+					      struct btrfs_device *tgtdev)
+{
+	WARN_ON(fs_info->fs_devices->rw_devices == 0);
+	tgtdev->io_width = fs_info->dev_root->sectorsize;
+	tgtdev->io_align = fs_info->dev_root->sectorsize;
+	tgtdev->sector_size = fs_info->dev_root->sectorsize;
+	tgtdev->dev_root = fs_info->dev_root;
+	tgtdev->in_fs_metadata = 1;
+}
+
 static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
 					struct btrfs_device *device)
 {
@@ -2800,6 +2963,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	u64 allowed;
 	int mixed = 0;
 	int ret;
+	u64 num_devices;
 
 	if (btrfs_fs_closing(fs_info) ||
 	    atomic_read(&fs_info->balance_pause_req) ||
@@ -2828,10 +2992,17 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	}
 
+	num_devices = fs_info->fs_devices->num_devices;
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		BUG_ON(num_devices < 1);
+		num_devices--;
+	}
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-	if (fs_info->fs_devices->num_devices == 1)
+	if (num_devices == 1)
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
-	else if (fs_info->fs_devices->num_devices < 4)
+	else if (num_devices < 4)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
 	else
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
@@ -3457,6 +3628,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		devices_info[ndevs].total_avail = total_avail;
 		devices_info[ndevs].dev = device;
 		++ndevs;
+		WARN_ON(ndevs > fs_devices->rw_devices);
 	}
 
 	/*
@@ -4639,6 +4811,7 @@ static void fill_device_from_item(struct extent_buffer *leaf,
 	device->io_align = btrfs_device_io_align(leaf, dev_item);
 	device->io_width = btrfs_device_io_width(leaf, dev_item);
 	device->sector_size = btrfs_device_sector_size(leaf, dev_item);
+	WARN_ON(device->devid == BTRFS_DEV_REPLACE_DEVID);
 	device->is_tgtdev_for_dev_replace = 0;
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8fd5a4d..37d0157 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -268,7 +268,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices);
+void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
+			       struct btrfs_fs_devices *fs_devices, int step);
 int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 					 char *device_path,
 					 struct btrfs_device **device);
@@ -286,6 +287,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
+int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
+				  struct btrfs_device **device_out);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
@@ -302,6 +305,12 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
+void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
+				 struct btrfs_device *srcdev);
+void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
+				      struct btrfs_device *tgtdev);
+void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
+					      struct btrfs_device *tgtdev);
 int btrfs_scratch_superblock(struct btrfs_device *device);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
-- 
1.8.0

