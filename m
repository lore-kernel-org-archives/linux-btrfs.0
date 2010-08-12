From: bchociej@gmail.com
Subject: [RFC v2 PATCH 3/6] Btrfs: Add hot data relocation facilities
Date: Thu, 12 Aug 2010 17:22:03 -0500
Message-ID: <1281651726-23501-4-git-send-email-bchociej@gmail.com>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bchociej@gmail.com>

The relocation code operates on the heat hash lists to identify hot or
cold data logical file ranges that are candidates for relocation. The
triggering mechanism for relocation is controlled by a global heat
threshold integer value (fs_root->heat_threshold). Ranges are queued for
relocation by the periodically-executing relocate kthread, which updates
the global heat threshold and responds to space pressure on the SSDs.

The heat hash lists index logical ranges by heat and provide a
constant-time access path to hot or cold range items. The relocation
kthread uses this path to find hot or cold items to move to/from SSD. To
ensure that the relocation kthread has a chance to sleep, and to prevent
thrashing between SSD and HDD, there is a configurable limit to how many
ranges are moved per iteration of the kthread. This limit may be overrun
in the case where space pressure requires that items be aggressively
moved from SSD back to HDD.

This needs still more resistance to thrashing and stronger (read:
actual) guarantees that relocation operations won't -ENOSPC.

The relocation code has introduced two new btrfs block group types:
BTRFS_BLOCK_GROUP_DATA_SSD and BTRFS_BLOCK_GROUP_METADATA_SSD. The later
is not currently implemented; to wit, this implementation does not move
any metadata, including inlined extents, to SSD.

When mkfs'ing a volume with the hot data relocation option, initial
block groups are allocated to the proper disks. Runtime block group
allocation only allocates BTRFS_BLOCK_GROUP_DATA
BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_SYSTEM to HDD, and
likewise only allocates BTRFS_BLOCK_GROUP_DATA_SSD and
BTRFS_BLOCK_GROUP_METADATA_SSD to SSD (assuming, critically, the
HOTDATAMOVE option is set at mount time).

Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Signed-off-by: Conor Scott <conscott@vt.edu>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/btrfs/hotdata_relocate.c |  783 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_relocate.h |   73 ++++
 2 files changed, 856 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/hotdata_relocate.c
 create mode 100644 fs/btrfs/hotdata_relocate.h

diff --git a/fs/btrfs/hotdata_relocate.c b/fs/btrfs/hotdata_relocate.c
new file mode 100644
index 0000000..c5060c4
--- /dev/null
+++ b/fs/btrfs/hotdata_relocate.c
@@ -0,0 +1,783 @@
+/*
+ * fs/btrfs/hotdata_relocate.c
+ *
+ * Copyright (C) 2010 International Business Machines Corp.
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
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/freezer.h>
+#include <linux/spinlock.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include "hotdata_map.h"
+#include "hotdata_relocate.h"
+#include "btrfs_inode.h"
+#include "ctree.h"
+#include "volumes.h"
+
+/*
+ * Hot data relocation strategy:
+ *
+ * The relocation code below operates on the heat hash lists to identify
+ * hot or cold data logical file ranges that are candidates for relocation.
+ * The triggering mechanism for relocation is controlled by a global heat
+ * threshold integer value (fs_root->heat_threshold). Ranges are queued
+ * for relocation by the periodically executing relocate kthread, which
+ * updates the global heat threshold and responds to space pressure on the
+ * SSDs.
+ *
+ * The heat hash lists index logical ranges by heat and provide a constant-time
+ * access path to hot or cold range items. The relocation kthread uses this
+ * path to find hot or cold items to move to/from SSD. To ensure that the
+ * relocation kthread has a chance to sleep, and to prevent thrashing between
+ * SSD and HDD, there is a configurable limit to how many ranges are moved per
+ * iteration of the kthread. This limit may be overrun in the case where space
+ * pressure requires that items be aggressively moved from SSD back to HDD.
+ *
+ * This needs still more resistance to thrashing and stronger (read: actual)
+ * guarantees that relocation operations won't -ENOSPC.
+ *
+ * The relocation code has introduced two new btrfs block group types:
+ * BTRFS_BLOCK_GROUP_DATA_SSD and BTRFS_BLOCK_GROUP_METADATA_SSD. The later is
+ * not currently implemented; to wit, this implementation does not move any
+ * metadata *including inlined extents* to SSD.
+ *
+ * When mkfs'ing a volume with the hot data relocation option, initial block
+ * groups are allocated to the proper disks. Runtime block group allocation
+ * only allocates BTRFS_BLOCK_GROUP_DATA BTRFS_BLOCK_GROUP_METADATA and
+ * BTRFS_BLOCK_GROUP_SYSTEM to HDD, and likewise only allocates
+ * BTRFS_BLOCK_GROUP_DATA_SSD and BTRFS_BLOCK_GROUP_METADATA_SSD to SSD
+ * (assuming, critically, the HOTDATAMOVE option is set at mount time).
+ */
+
+/*
+ * prepares hot or cold nodes to be moved to the location specified,
+ * sets up range args based on whether moving entire inode or range
+ */
+static int move_item(struct heat_hashlist_node *heatnode,
+		     struct btrfs_root *fs_root,
+		     int location)
+{
+	struct hot_inode_item *hot_inode_item;
+	struct hot_range_item *hot_range_item;
+	struct btrfs_relocate_range_args range_args;
+	int ret = 0;
+
+	if (heatnode->freq_data->flags & FREQ_DATA_TYPE_INODE) {
+
+		hot_inode_item = container_of(heatnode->freq_data,
+					      struct hot_inode_item,
+					      freq_data);
+		range_args.start = 0;
+		/* (u64)-1 moves the whole inode */
+		range_args.len = (u64)-1;
+		range_args.flags = 0;
+		range_args.extent_thresh = 1;
+		ret = btrfs_relocate_inode(hot_inode_item->i_ino,
+				     &range_args,
+				     fs_root,
+				     location);
+	} else if (heatnode->freq_data->flags & FREQ_DATA_TYPE_RANGE) {
+		hot_range_item = container_of(heatnode->freq_data,
+					      struct hot_range_item,
+					      freq_data);
+		range_args.start = hot_range_item->start;
+		range_args.len = hot_range_item->len;
+		range_args.flags = 0;
+		range_args.extent_thresh = 1;
+		ret = btrfs_relocate_inode(hot_range_item->hot_inode->i_ino,
+				     &range_args,
+				     fs_root,
+				     location);
+		}
+	return ret;
+}
+
+/*
+ * thread iterates through heat hash table and finds hot
+ * and cold data to move based on ssd pressure.
+ *
+ * first iterates through cold items below the heat
+ * threshold, if the item is on
+ * ssd and is now cold, we queue it up for relocation
+ * back to spinning disk. After scanning these items
+ * we call relocation code on all ranges that have been
+ * queued up for moving back to hdd.
+ *
+ * we then iterate through items above the heat threshold
+ * and if they are on hdd we que them up to be moved to
+ * ssd. We then iterate through queue and move hot ranges
+ * to ssd if they are not already
+ */
+static void __do_relocate_kthread(struct btrfs_root *root)
+{
+	int i;
+	int counter;
+	int heat_threshold;
+	int location;
+	int percent_ssd = 0;
+	struct btrfs_root *fs_root;
+	struct list_head *relocate_pos, *relocate_pos2;
+	struct heat_hashlist_node *relocate_heatnode = NULL;
+	struct list_head relocate_queue_to_rot;
+	struct list_head relocate_queue_to_nonrot;
+	static u32 run_count = 1;
+
+	run_count++;
+
+	fs_root = root->fs_info->fs_root;
+	percent_ssd = btrfs_update_threshold(fs_root, !(run_count % 15));
+	heat_threshold = fs_root->heat_threshold;
+
+do_cold:
+	INIT_LIST_HEAD(&relocate_queue_to_rot);
+
+	/* Don't move cold data to HDD unless there's space pressure */
+	if (percent_ssd < HIGH_WATER_LEVEL)
+		goto do_hot;
+
+	counter = 0;
+
+	/*
+	 * Move up to RELOCATE_MAX_ITEMS cold ranges back to spinning.
+	 * First, queue up items to move on the relocate_queue_to_rot.
+	 * Using (heat_threshold - 5) to control relocation hopefully
+	 * prevents some thrashing between SSD and HDD.
+	 */
+	for (i = 0; i <  heat_threshold - 5; i++) {
+		struct hlist_node *pos = NULL, *pos2 = NULL;
+		struct heat_hashlist_node *heatnode = NULL;
+		struct hlist_head *hashhead;
+		rwlock_t *lock;
+
+		hashhead = &fs_root->heat_range_hl[i].hashhead;
+		lock = &fs_root->heat_range_hl[i].rwlock;
+		read_lock(lock);
+
+		hlist_for_each_safe(pos, pos2, hashhead) {
+			heatnode = hlist_entry(pos,
+					struct heat_hashlist_node,
+					hashnode);
+
+			/* queue up on relocate list */
+			spin_lock(&heatnode->location_lock);
+			location = heatnode->location;
+			spin_unlock(&heatnode->location_lock);
+
+			if (location != BTRFS_ON_ROTATING) {
+				atomic_inc(&heatnode->refs);
+				list_add(&heatnode->node,
+					 &relocate_queue_to_rot);
+				counter++;
+			}
+
+			if (counter >= RELOCATE_MAX_ITEMS)
+				break;
+		}
+
+		read_unlock(lock);
+	}
+
+	/* Second, do the relocation */
+	list_for_each_safe(relocate_pos, relocate_pos2,
+		&relocate_queue_to_rot) {
+
+		relocate_heatnode = list_entry(relocate_pos,
+			struct heat_hashlist_node, node);
+
+		spin_lock(&relocate_heatnode->location_lock);
+		location = relocate_heatnode->location;
+		spin_unlock(&relocate_heatnode->location_lock);
+
+		if (location != BTRFS_ON_ROTATING) {
+			move_item(relocate_heatnode, fs_root,
+				BTRFS_ON_ROTATING);
+			relocate_heatnode->location = BTRFS_ON_ROTATING;
+		}
+
+		list_del(relocate_pos);
+		atomic_dec(&relocate_heatnode->refs);
+
+		if (kthread_should_stop())
+			return;
+	}
+
+	/*
+	 * Move up to RELOCATE_MAX_ITEMS ranges to SSD. Periodically check
+	 * for space pressure on SSD and goto do_cold if we've exceeded
+	 * the SSD capacity high water mark.
+	 * First, queue up items to move on relocate_queue_to_nonrot.
+	 */
+do_hot:
+	INIT_LIST_HEAD(&relocate_queue_to_nonrot);
+	counter = 0;
+
+	for (i = HEAT_MAX_VALUE; i >= heat_threshold; i--) {
+		struct hlist_node *pos = NULL, *pos2 = NULL;
+		struct heat_hashlist_node *heatnode = NULL;
+		struct hlist_head *hashhead;
+		rwlock_t *lock;
+
+		/* move hot ranges */
+		hashhead = &fs_root->heat_range_hl[i].hashhead;
+		lock =  &fs_root->heat_range_hl[i].rwlock;
+		read_lock(lock);
+
+		hlist_for_each_safe(pos, pos2, hashhead) {
+			heatnode = hlist_entry(pos,
+					struct heat_hashlist_node,
+					hashnode);
+
+			/* queue up on relocate list */
+			spin_lock(&heatnode->location_lock);
+			location = heatnode->location;
+			spin_unlock(&heatnode->location_lock);
+
+			if (location != BTRFS_ON_NONROTATING) {
+				atomic_inc(&heatnode->refs);
+				list_add(&heatnode->node,
+					 &relocate_queue_to_nonrot);
+				counter++;
+			}
+
+			if (counter >= RELOCATE_MAX_ITEMS)
+				break;
+		}
+
+		read_unlock(lock);
+	}
+
+	counter = 0;
+
+	/* Second, do the relocation */
+	list_for_each_safe(relocate_pos, relocate_pos2,
+		&relocate_queue_to_nonrot) {
+
+		relocate_heatnode = list_entry(relocate_pos,
+			struct heat_hashlist_node, node);
+
+		spin_lock(&relocate_heatnode->location_lock);
+		location = relocate_heatnode->location;
+		spin_unlock(&relocate_heatnode->location_lock);
+
+		if (location != BTRFS_ON_NONROTATING) {
+			move_item(relocate_heatnode, fs_root,
+				BTRFS_ON_NONROTATING);
+			relocate_heatnode->location = BTRFS_ON_NONROTATING;
+		}
+
+		list_del(relocate_pos);
+		atomic_dec(&relocate_heatnode->refs);
+
+		if (kthread_should_stop())
+			return;
+
+		/*
+		 * If we've exceeded the SSD capacity high water mark,
+		 * goto do_cold to relieve the pressure
+		 */
+		if (counter % 50 == 0) {
+			percent_ssd = btrfs_update_threshold(fs_root, 0);
+			heat_threshold = fs_root->heat_threshold;
+
+			if (percent_ssd >= HIGH_WATER_LEVEL)
+				goto do_cold;
+		}
+
+		counter++;
+	}
+}
+
+/* main loop for running relcation thread */
+static int do_relocate_kthread(void *arg)
+{
+	struct btrfs_root *root = arg;
+	unsigned long delay;
+	do {
+		delay = HZ * RELOCATE_TIME_DELAY;
+		if (mutex_trylock(
+			&root->fs_info->hot_data_relocate_kthread_mutex)) {
+			if (btrfs_test_opt(root, HOTDATA_MOVE))
+				__do_relocate_kthread(root);
+			mutex_unlock(
+				&root->fs_info->
+				hot_data_relocate_kthread_mutex);
+		}
+		if (freezing(current)) {
+			refrigerator();
+		} else {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!kthread_should_stop())
+				schedule_timeout(delay);
+			__set_current_state(TASK_RUNNING);
+		}
+	} while (!kthread_should_stop());
+	return 0;
+}
+
+/* kick off the relocate kthread */
+void init_hot_data_relocate_kthread(struct btrfs_root *root)
+{
+	root->fs_info->hot_data_relocate_kthread =
+					kthread_run(do_relocate_kthread,
+					root,
+					"hot_data_relocate_kthread");
+	if (IS_ERR(root->fs_info->hot_data_relocate_kthread))
+		kthread_stop(root->fs_info->hot_data_relocate_kthread);
+}
+
+/*
+ * placeholder for function to scan SSDs on startup with HOTDATAMOVE to bring
+ * access frequency structs into memory to allow that data to be eligible for
+ * relocation to spinning disk
+ */
+static inline void __do_ssd_scan(struct btrfs_device *device)
+{
+	return;
+}
+
+static int do_ssd_scan_kthread(void *arg)
+{
+	struct btrfs_root *root = arg;
+	struct btrfs_root *dev_root;
+	struct btrfs_device *device;
+	struct list_head *devices = &root->fs_info->fs_devices->devices;
+	int ret = 0;
+
+	mutex_lock(&root->fs_info->ssd_scan_kthread_mutex);
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY) {
+		ret = -EROFS;
+		goto out;
+	}
+
+	dev_root = root->fs_info->dev_root;
+	mutex_lock(&dev_root->fs_info->volume_mutex);
+
+	list_for_each_entry(device, devices, dev_list) {
+		int device_rotating;
+		if (!device->writeable)
+			continue;
+
+		device_rotating =
+			!blk_queue_nonrot(bdev_get_queue(device->bdev));
+
+		if (!device_rotating)
+			__do_ssd_scan(device);
+
+		if (ret == -ENOSPC)
+			break;
+		BUG_ON(ret);
+
+	}
+	mutex_unlock(&dev_root->fs_info->volume_mutex);
+
+	do {
+		break;
+	} while (!kthread_should_stop());
+
+out:
+	mutex_unlock(&root->fs_info->ssd_scan_kthread_mutex);
+
+	return ret;
+}
+
+void init_ssd_scan_kthread(struct btrfs_root *root)
+{
+	root->fs_info->ssd_scan_kthread =
+					kthread_run(do_ssd_scan_kthread,
+					root,
+					"ssd_scan_kthread");
+	if (IS_ERR(root->fs_info->ssd_scan_kthread))
+		kthread_stop(root->fs_info->ssd_scan_kthread);
+}
+
+/* returns non-zero if any part of the range is on rotating disk */
+int btrfs_range_on_rotating(struct btrfs_root *root,
+			    struct hot_inode_item *hot_inode,
+			    u64 start, u64 len)
+{
+	struct inode *inode;
+	struct btrfs_key key;
+	struct extent_map *em = NULL;
+	struct btrfs_multi_bio *multi_ret = NULL;
+	struct btrfs_inode *btrfs_inode;
+	struct btrfs_bio_stripe *bio_stripe;
+	struct btrfs_multi_bio *multi_bio;
+	struct block_device *bdev;
+	int rotating = 0;
+	int ret_val = 0;
+	u64 length = 0;
+	u64 pos = 0, pos2 = 0;
+	int new = 0;
+	int i;
+	unsigned long inode_size = 0;
+
+	spin_lock(&hot_inode->lock);
+	key.objectid = hot_inode->i_ino;
+	spin_unlock(&hot_inode->lock);
+
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	inode = btrfs_iget(root->fs_info->sb, &key, root, &new);
+
+	if (IS_ERR(inode)) {
+		ret_val = -ENOENT;
+		goto out;
+	} else if (is_bad_inode(inode)) {
+		iput(inode);
+		ret_val = -ENOENT;
+		goto out;
+	}
+
+	btrfs_inode = BTRFS_I(inode);
+	inode_size = (unsigned long) i_size_read(inode);
+
+	if (start >= inode_size) {
+		iput(inode);
+		ret_val = -ENOENT;
+		goto out;
+	}
+
+	if (len == (u64) -1 || start + len > inode_size)
+		len = inode_size - start;
+	else
+		len = start + len;
+
+	for (pos = start; pos < len - 1; pos += length) {
+		em = btrfs_get_extent(inode, NULL, 0, pos, pos + 1, 0);
+
+		length = em->block_len;
+
+		/* Location of delayed allocation and inline extents
+		 * can't be determined */
+		if (em->block_start == EXTENT_MAP_INLINE ||
+			em->block_start == EXTENT_MAP_DELALLOC ||
+			em->block_start == EXTENT_MAP_HOLE) {
+			ret_val = -1;
+			iput(inode);
+			goto out_free_em;
+		}
+
+		for (pos2 = 0; pos2 < em->block_len; pos2 += length) {
+			btrfs_map_block((struct btrfs_mapping_tree *)
+				&root->fs_info->mapping_tree, READ,
+				em->block_start + pos2,
+				&length, &multi_ret, 0);
+
+			multi_bio = multi_ret;
+
+			/* Each range may have more than one stripe */
+			for (i = 0; i < multi_bio->num_stripes; i++) {
+				bio_stripe = &multi_bio->stripes[i];
+				bdev  = bio_stripe->dev->bdev;
+				if (!blk_queue_nonrot(bdev_get_queue(bdev)))
+					rotating = 1;
+			}
+		}
+		pos += em->block_len;
+		free_extent_map(em);
+	}
+
+	ret_val = rotating;
+	iput(inode);
+	goto out;
+
+out_free_em:
+	free_extent_map(em);
+out:
+	kfree(multi_ret);
+	return ret_val;
+}
+
+static int should_relocate_range(struct inode *inode, u64 start, u64 len,
+			       int thresh, u64 *last_len, u64 *skip,
+			       u64 *relocate_end)
+{
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map *em = NULL;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	int ret = 1;
+
+
+	if (thresh == 0)
+		thresh = 256 * 1024;
+
+	/*
+	 * make sure that once we start relocating and extent, we keep on
+	 * relocating it
+	 */
+	if (start < *relocate_end)
+		return 1;
+
+	*skip = 0;
+
+	/*
+	 * hopefully we have this extent in the tree already, try without
+	 * the full extent lock
+	 */
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, start, len);
+	read_unlock(&em_tree->lock);
+
+	if (!em) {
+		/* get the big lock and read metadata off disk */
+		lock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
+
+		if (IS_ERR(em))
+			return 0;
+	}
+
+	/* this will cover holes, and inline extents */
+	if (em->block_start >= EXTENT_MAP_LAST_BYTE)
+		ret = 0;
+
+	if (ret) {
+		*last_len += len;
+		*relocate_end = extent_map_end(em);
+	} else {
+		*last_len = 0;
+		*skip = extent_map_end(em);
+		*relocate_end = 0;
+	}
+
+	free_extent_map(em);
+	return ret;
+}
+
+/*
+ * take and inode and range args (sub file range) and
+ * relocate to sdd or spinning based on past location.
+ *
+ * loads range into page cache and marks pages as dirty,
+ * range arg can pass whether or not this should be
+ * flushed immediately, or whether btrfs workers should
+ * flush later
+ *
+ * based on defrag ioctl
+ */
+int btrfs_relocate_inode(unsigned long inode_num,
+			     struct btrfs_relocate_range_args *range,
+			     struct btrfs_root *root,
+			     int location)
+{
+	struct inode *inode;
+	struct extent_io_tree *io_tree;
+	struct btrfs_ordered_extent *ordered;
+	struct page *page;
+	struct btrfs_key key;
+	struct file_ra_state *ra;
+	unsigned long last_index;
+	unsigned long ra_pages = root->fs_info->bdi.ra_pages;
+	unsigned long total_read = 0;
+	u64 page_start;
+	u64 page_end;
+	u64 last_len = 0;
+	u64 skip = 0;
+	u64 relocate_end = 0;
+	unsigned long i;
+	int new = 0;
+	int ret;
+
+	key.objectid = inode_num;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(root->fs_info->sb, &key, root, &new);
+	if (IS_ERR(inode)) {
+		ret = -ENOENT;
+		goto out;
+	} else if (is_bad_inode(inode)) {
+		iput(inode);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	io_tree = &BTRFS_I(inode)->io_tree;
+
+	if (inode->i_size == 0)
+		return 0;
+
+	if (range->start + range->len > range->start) {
+		last_index = min_t(u64, inode->i_size - 1,
+			 range->start + range->len - 1) >> PAGE_CACHE_SHIFT;
+	} else {
+		last_index = (inode->i_size - 1) >> PAGE_CACHE_SHIFT;
+	}
+
+	i = range->start >> PAGE_CACHE_SHIFT;
+	ra  = kzalloc(sizeof(*ra), GFP_NOFS);
+
+	while (i <= last_index) {
+		if (!should_relocate_range(inode, (u64)i << PAGE_CACHE_SHIFT,
+					PAGE_CACHE_SIZE,
+					range->extent_thresh,
+					&last_len, &skip,
+					&relocate_end)) {
+			unsigned long next;
+			/*
+			 * the should_relocate function tells us how much to
+			 * skip
+			 * bump our counter by the suggested amount
+			 */
+			next = (skip + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+			i = max(i + 1, next);
+			continue;
+		}
+
+		if (total_read % ra_pages == 0) {
+			btrfs_force_ra(inode->i_mapping, ra, NULL, i,
+			min(last_index, i + ra_pages - 1));
+		}
+		total_read++;
+		mutex_lock(&inode->i_mutex);
+		if (range->flags & BTRFS_RELOCATE_RANGE_COMPRESS)
+			BTRFS_I(inode)->force_compress = 1;
+
+		ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+		if (ret)
+			goto err_unlock;
+again:
+		if (inode->i_size == 0 ||
+		    i > ((inode->i_size - 1) >> PAGE_CACHE_SHIFT)) {
+			ret = 0;
+			goto err_reservations;
+		}
+
+		page = grab_cache_page(inode->i_mapping, i);
+		if (!page) {
+			ret = -ENOMEM;
+			goto err_reservations;
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EIO;
+				goto err_reservations;
+			}
+		}
+
+		if (page->mapping != inode->i_mapping) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto again;
+		}
+
+		wait_on_page_writeback(page);
+
+		if (PageDirty(page)) {
+			btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+			goto loop_unlock;
+		}
+
+		page_start = (u64)page->index << PAGE_CACHE_SHIFT;
+		page_end = page_start + PAGE_CACHE_SIZE - 1;
+		lock_extent(io_tree, page_start, page_end, GFP_NOFS);
+
+		ordered = btrfs_lookup_ordered_extent(inode, page_start);
+		if (ordered) {
+			unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+			unlock_page(page);
+			page_cache_release(page);
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			goto again;
+		}
+		set_page_extent_mapped(page);
+
+		/*
+		 * this makes sure page_mkwrite is called on the
+		 * page if it is dirtied again later
+		 */
+		clear_page_dirty_for_io(page);
+		clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start,
+				  page_end, EXTENT_DIRTY | EXTENT_DELALLOC |
+				  EXTENT_DO_ACCOUNTING, GFP_NOFS);
+
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+
+		if (location == BTRFS_ON_NONROTATING) {
+			btrfs_set_extent_prefer_nonrotating(inode, page_start,
+							page_end, NULL);
+			clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start,
+				  page_end, EXTENT_PREFER_ROTATING, GFP_NOFS);
+		} else if (location == BTRFS_ON_ROTATING) {
+			btrfs_set_extent_prefer_rotating(inode, page_start,
+							page_end, NULL);
+			clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start,
+				page_end, EXTENT_PREFER_NONROTATING, GFP_NOFS);
+		}
+
+		ClearPageChecked(page);
+		set_page_dirty(page);
+		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+
+loop_unlock:
+		unlock_page(page);
+		page_cache_release(page);
+		mutex_unlock(&inode->i_mutex);
+
+		balance_dirty_pages_ratelimited_nr(inode->i_mapping, 1);
+		i++;
+	}
+	kfree(ra);
+
+	if ((range->flags & BTRFS_RELOCATE_RANGE_START_IO))
+		filemap_flush(inode->i_mapping);
+
+	if ((range->flags & BTRFS_RELOCATE_RANGE_COMPRESS)) {
+		/* the filemap_flush will queue IO into the worker threads, but
+		 * we have to make sure the IO is actually started and that
+		 * ordered extents get created before we return
+		 */
+		atomic_inc(&root->fs_info->async_submit_draining);
+		while (atomic_read(&root->fs_info->nr_async_submits) ||
+		      atomic_read(&root->fs_info->async_delalloc_pages)) {
+			wait_event(root->fs_info->async_submit_wait,
+			   (atomic_read(&root->fs_info->
+					nr_async_submits) == 0 &&
+			    atomic_read(&root->fs_info->
+					async_delalloc_pages) == 0));
+		}
+		atomic_dec(&root->fs_info->async_submit_draining);
+
+		mutex_lock(&inode->i_mutex);
+		BTRFS_I(inode)->force_compress = 0;
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	ret = 0;
+	goto put_inode;
+
+err_reservations:
+	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+err_unlock:
+	mutex_unlock(&inode->i_mutex);
+put_inode:
+	iput(inode);
+out:
+	return ret;
+}
+
diff --git a/fs/btrfs/hotdata_relocate.h b/fs/btrfs/hotdata_relocate.h
new file mode 100644
index 0000000..e3235d1
--- /dev/null
+++ b/fs/btrfs/hotdata_relocate.h
@@ -0,0 +1,73 @@
+/*
+ * fs/btrfs/hotdata_relocate.h
+ *
+ * Copyright (C) 2010 International Business Machines Corp.
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
+#ifndef __HOTDATARELOCATE__
+#define __HOTDATARELOCATE__
+
+#include "ctree.h"
+#include "hotdata_map.h"
+
+/* flags for the defrag range ioctl */
+#define BTRFS_RELOCATE_RANGE_COMPRESS 1
+#define BTRFS_RELOCATE_RANGE_START_IO 2
+
+/* where data is located */
+#define BTRFS_ON_ROTATING	0
+#define BTRFS_ON_NONROTATING	1
+#define BTRFS_ON_BOTH		2
+#define BTRFS_ON_UNKNOWN	3
+
+/* run relocation thread every X seconds */
+#define RELOCATE_TIME_DELAY 1
+/* maximum number of ranges to move in relocation thread run */
+#define RELOCATE_MAX_ITEMS 250
+
+struct btrfs_relocate_range_args {
+	/* start of the relocate operation */
+	u64 start;
+	/* number of bytes to relocate, use (u64)-1 to say all */
+	u64 len;
+	/*
+	 * flags for the operation, which can include turning
+	 * on compression for this one relocate
+	 */
+	u64 flags;
+	 /*
+	 * Use 1 to say every single extent must be rewritten
+	 */
+	u32 extent_thresh;
+};
+
+struct btrfs_root;
+/*
+ * initialization of relocation kthread,
+ * called if hotdatamove mount option is passed
+ */
+void init_hot_data_relocate_kthread(struct btrfs_root *root);
+void init_ssd_scan_kthread(struct btrfs_root *root);
+/* returns 1 if any part of range is on rotating disk (HDD) */
+int btrfs_range_on_rotating(struct btrfs_root *root,
+	struct hot_inode_item *hot_inode, u64 start, u64 len);
+/* relocate inode range to spinning or ssd based on range args */
+int btrfs_relocate_inode(unsigned long inode_num,
+			     struct btrfs_relocate_range_args *range,
+			     struct btrfs_root *root,
+			     int location);
+#endif /* __HOTDATARELOCATE__ */
-- 
1.7.1
