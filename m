Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37793 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab3EFIxO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 04:53:14 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 04:53:13 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id CBFE2C9001A
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 04:53:11 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468rCGn38797520
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:12 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468rBJ5009158
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:12 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 3/5] btrfs: add one hot relocation kthread
Date: Mon,  6 May 2013 16:53:36 +0800
Message-Id: <1367830418-26865-4-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

   Add one private kthread for hot relocation. It will check
if there're some extents which is hotter than the threshold
and queue them at first, if no, it will return and wait for
its next turn; otherwise, it will check if SSD ratio is beyond
beyond its usage threshold, if no, it will directly relocate
those hot extents from HDD disk to SSD disk; otherwise it will
find the extents with low temperature and queue them, then
relocate those extents with low temperature and queue them,
and finally relocate the hot extents from from HDD disk to SSD
disk.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h        |   2 +
 fs/btrfs/hot_relocate.c | 720 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/hot_relocate.h |  21 ++
 fs/btrfs/super.c        |   1 +
 4 files changed, 742 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f4c4419..77d9b1c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1619,6 +1619,8 @@ struct btrfs_fs_info {
 	struct btrfs_dev_replace dev_replace;
 
 	atomic_t mutually_exclusive_operation_running;
+
+	void *hot_reloc;
 };
 
 /*
diff --git a/fs/btrfs/hot_relocate.c b/fs/btrfs/hot_relocate.c
index 1effd14..683e154 100644
--- a/fs/btrfs/hot_relocate.c
+++ b/fs/btrfs/hot_relocate.c
@@ -12,8 +12,46 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/writeback.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/module.h>
 #include "hot_relocate.h"
 
+/*
+ * Hot relocation strategy:
+ *
+ * The relocation code below operates on the heat map lists to identify
+ * hot or cold data logical file ranges that are candidates for relocation.
+ * The triggering mechanism for relocation is controlled by a global heat
+ * threshold integer value (HOT_RELOC_THRESHOLD). Ranges are
+ * queued for relocation by the periodically executing relocate kthread,
+ * which updates the global heat threshold and responds to space pressure
+ * on the SSDs.
+ *
+ * The heat map lists index logical ranges by heat and provide a constant-time
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
+ * The relocation code has introduced one new btrfs block group type:
+ * BTRFS_BLOCK_GROUP_DATA_SSD.
+ *
+ * When mkfs'ing a volume with the hot data relocation option, initial block
+ * groups are allocated to the proper disks. Runtime block group allocation
+ * only allocates BTRFS_BLOCK_GROUP_DATA BTRFS_BLOCK_GROUP_METADATA and
+ * BTRFS_BLOCK_GROUP_SYSTEM to HDD, and likewise only allocates
+ * BTRFS_BLOCK_GROUP_DATA_SSD to SSD.
+ * (assuming, critically, the HOT_MOVE option is set at mount time).
+ */
+
 static void hot_set_extent_bits(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached_state,
 		gfp_t mask, int storage_type, int flag)
@@ -26,10 +64,10 @@ static void hot_set_extent_bits(struct extent_io_tree *tree, u64 start,
 				EXTENT_DO_ACCOUNTING;
 	}
 
-	if (storage_type == ON_ROT_DISK) {
+	if (storage_type == TYPE_ROT) {
 		set_bits |= EXTENT_COLD;
 		clear_bits |= EXTENT_HOT;
-	} else if (storage_type == ON_NONROT_DISK) {
+	} else if (storage_type == TYPE_NONROT) {
 		set_bits |= EXTENT_HOT;
 		clear_bits |= EXTENT_COLD;
 	}
@@ -76,3 +114,681 @@ int hot_get_chunk_type(struct inode *inode, u64 start, u64 end)
 
 	return ret;
 }
+
+/*
+ * Returns SSD ratio that is full.
+ * If no SSD is found, returns THRESH_MAX_VALUE + 1.
+ */
+static int hot_calc_ssd_ratio(struct hot_reloc *hot_reloc)
+{
+	struct btrfs_space_info *info;
+	struct btrfs_device *device, *next;
+	struct btrfs_fs_info *fs_info = hot_reloc->fs_info;
+	u64 total_bytes = 0, bytes_used = 0;
+
+	/*
+	 * Iterate through devices, if they're nonrot,
+	 * add their bytes to the total_bytes.
+	 */
+	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	list_for_each_entry_safe(device, next,
+		&fs_info->fs_devices->devices, dev_list) {
+		if (blk_queue_nonrot(bdev_get_queue(device->bdev)))
+			total_bytes += device->total_bytes;
+	}
+	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+	if (total_bytes == 0)
+		return THRESH_MAX_VALUE + 1;
+
+	/*
+	 * Iterate through space_info. if the SSD data block group
+	 * is found, add the bytes used by that group bytes_used
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(info, &fs_info->space_info, list) {
+		if (info->flags & BTRFS_BLOCK_GROUP_DATA_SSD)
+			bytes_used += info->bytes_used;
+	}
+	rcu_read_unlock();
+
+	/* Finish up, return ratio of SSD filled. */
+	BUG_ON(bytes_used >= total_bytes);
+
+	return (int) div64_u64(bytes_used * 100, total_bytes);
+}
+
+/*
+ * Update heat threshold for hot relocation
+ * based on how full SSD drives are.
+ */
+static int hot_update_threshold(struct hot_reloc *hot_reloc,
+				int update)
+{
+	int thresh = hot_reloc->thresh;
+	int ratio = hot_calc_ssd_ratio(hot_reloc);
+
+	/* Sometimes update global threshold, others not */
+	if (!update && ratio < HIGH_WATER_LEVEL)
+		return ratio;
+
+	if (unlikely(ratio > THRESH_MAX_VALUE))
+		thresh = HEAT_MAX_VALUE + 1;
+	else {
+		WARN_ON(HIGH_WATER_LEVEL > THRESH_MAX_VALUE
+			|| LOW_WATER_LEVEL < 0);
+
+		if (ratio >= HIGH_WATER_LEVEL)
+			thresh += THRESH_UP_SPEED;
+		else if (ratio <= LOW_WATER_LEVEL)
+			thresh -= THRESH_DOWN_SPEED;
+
+		if (thresh > HEAT_MAX_VALUE)
+			thresh = HEAT_MAX_VALUE + 1;
+		else if (thresh < 0)
+			thresh = 0;
+	}
+
+	hot_reloc->thresh = thresh;
+	return ratio;
+}
+
+static bool hot_can_relocate(struct inode *inode, u64 start,
+			u64 len, u64 *skip, u64 *end)
+{
+	struct extent_map *em = NULL;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	bool ret = true;
+
+	/*
+	 * Make sure that once we start relocating an extent,
+	 * we keep on relocating it
+	 */
+	if (start < *end)
+		return true;
+
+	*skip = 0;
+
+	/*
+	 * Hopefully we have this extent in the tree already,
+	 * try without the full extent lock
+	 */
+	read_lock(&em_tree->lock);
+	em = lookup_extent_mapping(em_tree, start, len);
+	read_unlock(&em_tree->lock);
+	if (!em) {
+		/* Get the big lock and read metadata off disk */
+		lock_extent(io_tree, start, start + len - 1);
+		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+		unlock_extent(io_tree, start, start + len - 1);
+		if (IS_ERR(em))
+			return false;
+	}
+
+	/* This will cover holes, and inline extents */
+	if (em->block_start >= EXTENT_MAP_LAST_BYTE)
+		ret = false;
+
+	if (ret) {
+		*end = extent_map_end(em);
+	} else {
+		*skip = extent_map_end(em);
+		*end = 0;
+	}
+
+	free_extent_map(em);
+	return ret;
+}
+
+static void hot_cleanup_relocq(struct list_head *bucket) {
+	struct hot_range_item *hr;
+	struct hot_comm_item *ci, *ci_next;
+
+	list_for_each_entry_safe(ci, ci_next, bucket, reloc_list) {
+		hr = container_of(ci, struct hot_range_item, hot_range);
+		list_del_init(&hr->hot_range.reloc_list);
+		hot_comm_item_put(ci);
+	}
+}
+
+static int hot_queue_extent(struct hot_reloc *hot_reloc,
+			struct list_head *bucket,
+			u64 *counter, int storage_type)
+{
+	struct hot_comm_item *ci;
+	struct hot_range_item *hr;
+	struct hot_inode_item *he;
+	int st, ret = 0;
+
+	/* Queue hot_ranges */
+	list_for_each_entry_rcu(ci, bucket, track_list) {
+		hot_comm_item_get(ci);
+		hr = container_of(ci, struct hot_range_item, hot_range);
+		he = hr->hot_inode;
+
+		/* Queue up on relocate list */
+		st = hr->storage_type;
+		if (st != storage_type) {
+			list_add_tail(&ci->reloc_list,
+				&hot_reloc->hot_relocq[storage_type]);
+			hot_comm_item_get(ci);
+			*counter = *counter + 1;
+		}
+
+		spin_lock(&he->i_lock);
+		hot_comm_item_put(ci);
+		spin_unlock(&he->i_lock);
+
+		if (*counter >= HOT_RELOC_MAX_ITEMS)
+			break;
+
+		if (kthread_should_stop()) {
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static u64 hot_search_extent(struct hot_reloc *hot_reloc,
+			int thresh, int storage_type)
+{
+	struct hot_info *root;
+	u64 counter = 0;
+	int i, ret = 0;
+
+	root = hot_reloc->fs_info->sb->s_hot_root;
+	for (i = HEAT_MAX_VALUE; i >= thresh; i--) {
+		rcu_read_lock();
+		if (!list_empty(&root->hot_map[TYPE_RANGE][i]))
+			ret = hot_queue_extent(hot_reloc,
+					&root->hot_map[TYPE_RANGE][i],
+					&counter, storage_type);
+		rcu_read_unlock();
+		if (ret) {
+			counter = 0;
+			break;
+		}
+	}
+
+	if (ret)
+		hot_cleanup_relocq(&hot_reloc->hot_relocq[storage_type]);
+
+	return counter;
+}
+
+static int hot_load_file_extent(struct inode *inode,
+			    struct page **pages,
+			    unsigned long start_index,
+			    int num_pages, int storage_type)
+{
+	unsigned long file_end;
+	int ret, i, i_done;
+	u64 isize = i_size_read(inode), page_start, page_end, page_cnt;
+	struct btrfs_ordered_extent *ordered;
+	struct extent_state *cached_state = NULL;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
+
+	file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
+	if (!isize || start_index > file_end)
+		return 0;
+
+	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
+
+	if (storage_type == TYPE_NONROT)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_HOT;
+	ret = btrfs_delalloc_reserve_space(inode, page_cnt << PAGE_CACHE_SHIFT);
+	if (storage_type == TYPE_NONROT)
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+	if (ret)
+		return ret;
+
+	i_done = 0;
+	/* step one, lock all the pages */
+	for (i = 0; i < page_cnt; i++) {
+		struct page *page;
+again:
+		page = find_or_create_page(inode->i_mapping,
+					   start_index + i, mask);
+		if (!page)
+			break;
+
+		page_start = page_offset(page);
+		page_end = page_start + PAGE_CACHE_SIZE - 1;
+		while (1) {
+			lock_extent(tree, page_start, page_end);
+			ordered = btrfs_lookup_ordered_extent(inode,
+							page_start);
+			unlock_extent(tree, page_start, page_end);
+			if (!ordered)
+				break;
+
+			unlock_page(page);
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			lock_page(page);
+			/*
+			 * we unlocked the page above, so we need check if
+			 * it was released or not.
+			 */
+			if (page->mapping != inode->i_mapping) {
+				unlock_page(page);
+				page_cache_release(page);
+				goto again;
+			}
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EIO;
+				break;
+			}
+		}
+
+		if (page->mapping != inode->i_mapping) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto again;
+		}
+
+		pages[i] = page;
+		i_done++;
+	}
+	if (!i_done || ret)
+		goto out;
+
+	if (!(inode->i_sb->s_flags & MS_ACTIVE))
+		goto out;
+
+	page_start = page_offset(pages[0]);
+	page_end = page_offset(pages[i_done - 1]) + PAGE_CACHE_SIZE - 1;
+
+	lock_extent_bits(tree, page_start, page_end, 0, &cached_state);
+
+	if (i_done != page_cnt) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->lock);
+
+		if (storage_type == TYPE_NONROT)
+			btrfs_delalloc_release_ssd_space(inode,
+				(page_cnt - i_done) << PAGE_CACHE_SHIFT);
+		else if (storage_type == TYPE_ROT)
+			btrfs_delalloc_release_space(inode,
+				(page_cnt - i_done) << PAGE_CACHE_SHIFT);
+	}
+
+	hot_set_extent_bits(tree, page_start, page_end,
+			&cached_state, GFP_NOFS, storage_type, 1);
+	unlock_extent_cached(tree, page_start, page_end,
+			&cached_state, GFP_NOFS);
+
+	for (i = 0; i < i_done; i++) {
+		clear_page_dirty_for_io(pages[i]);
+		ClearPageChecked(pages[i]);
+		set_page_extent_mapped(pages[i]);
+		set_page_dirty(pages[i]);
+		unlock_page(pages[i]);
+		page_cache_release(pages[i]);
+	}
+
+	/*
+	 * so now we have a nice long stream of locked
+	 * and up to date pages, lets wait on them
+	 */
+	for (i = 0; i < i_done; i++)
+		wait_on_page_writeback(pages[i]);
+
+	return i_done;
+out:
+	for (i = 0; i < i_done; i++) {
+		unlock_page(pages[i]);
+		page_cache_release(pages[i]);
+	}
+
+	if (storage_type == TYPE_NONROT)
+		btrfs_delalloc_release_ssd_space(inode,
+				page_cnt << PAGE_CACHE_SHIFT);
+	else if (storage_type == TYPE_ROT)
+		btrfs_delalloc_release_space(inode,
+				page_cnt << PAGE_CACHE_SHIFT);
+
+	return ret;
+}
+
+/*
+ * Relocate data to SSD or spinning drive based on past location
+ * and load the file into page cache and marks pages as dirty.
+ *
+ * based on defrag ioctl
+ */
+static int hot_relocate_extent(struct hot_range_item *hr,
+			struct hot_reloc *hot_reloc,
+			int storage_type)
+{
+	struct hot_inode_item *he = hr->hot_inode;
+	struct btrfs_root *root = hot_reloc->fs_info->fs_root;
+	struct inode *inode;
+	struct file_ra_state *ra = NULL;
+	struct btrfs_key key;
+	u64 isize, last_len = 0, skip = 0, end = 0;
+	unsigned long i, last, ra_index = 0;
+	int ret = -ENOENT, count = 0, new = 0;
+	int max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
+	int cluster = max_cluster;
+	struct page **pages = NULL;
+
+	hot_comm_item_get(&hr->hot_range);
+
+	key.objectid = hr->hot_inode->i_ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	inode = btrfs_iget(root->fs_info->sb, &key, root, &new);
+	if (IS_ERR(inode))
+		goto out;
+	else if (is_bad_inode(inode))
+		goto out_inode;
+
+	isize = i_size_read(inode);
+	if (isize == 0) {
+		ret = 0;
+		goto out_inode;
+	}
+
+	ra = kzalloc(sizeof(*ra), GFP_NOFS);
+	if (!ra) {
+		ret = -ENOMEM;
+		goto out_inode;
+	} else {
+		file_ra_state_init(ra, inode->i_mapping);
+	}
+
+	pages = kmalloc(sizeof(struct page *) * max_cluster,
+			GFP_NOFS);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out_ra;
+	}
+
+	/* find the last page */
+	if (hr->start + hr->len > hr->start) {
+		last = min_t(u64, isize - 1,
+			 hr->start + hr->len - 1) >> PAGE_CACHE_SHIFT;
+	} else {
+		last = (isize - 1) >> PAGE_CACHE_SHIFT;
+	}
+
+	i = hr->start >> PAGE_CACHE_SHIFT;
+
+	/*
+	 * make writeback starts from i, so the range can be
+	 * written sequentially.
+	 */
+	if (i < inode->i_mapping->writeback_index)
+		inode->i_mapping->writeback_index = i;
+
+	while (i <= last && count < last + 1 &&
+	       (i < (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+		PAGE_CACHE_SHIFT)) {
+		/*
+		 * make sure we stop running if someone unmounts
+		 * the FS
+		 */
+		if (!(inode->i_sb->s_flags & MS_ACTIVE))
+			break;
+
+		if (signal_pending(current)) {
+			printk(KERN_DEBUG "btrfs: hot relocation cancelled\n");
+			break;
+		}
+
+		if (!hot_can_relocate(inode, (u64)i << PAGE_CACHE_SHIFT,
+				 PAGE_CACHE_SIZE, &skip, &end)) {
+			unsigned long next;
+			/*
+			 * the function tells us how much to skip
+			 * bump our counter by the suggested amount
+			 */
+			next = (skip + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+			i = max(i + 1, next);
+			continue;
+		}
+
+		cluster = (PAGE_CACHE_ALIGN(end) >> PAGE_CACHE_SHIFT) - i;
+		cluster = min(cluster, max_cluster);
+
+		if (i + cluster > ra_index) {
+			ra_index = max(i, ra_index);
+			btrfs_force_ra(inode->i_mapping, ra, NULL, ra_index,
+				       cluster);
+			ra_index += max_cluster;
+		}
+
+		mutex_lock(&inode->i_mutex);
+		ret = hot_load_file_extent(inode, pages,
+					i, cluster, storage_type);
+		if (ret < 0) {
+			mutex_unlock(&inode->i_mutex);
+			goto out_ra;
+		}
+
+		count += ret;
+		balance_dirty_pages_ratelimited(inode->i_mapping);
+		mutex_unlock(&inode->i_mutex);
+
+		if (ret > 0) {
+			i += ret;
+			last_len += ret << PAGE_CACHE_SHIFT;
+		} else {
+			i++;
+			last_len = 0;
+		}
+	}
+
+	ret = count;
+	if (ret > 0)
+		hr->storage_type = storage_type;
+
+out_ra:
+	kfree(ra);
+	kfree(pages);
+out_inode:
+	iput(inode);
+out:
+	spin_lock(&he->i_lock);
+	hot_comm_item_put(&hr->hot_range);
+	spin_unlock(&he->i_lock);
+
+	list_del_init(&hr->hot_range.reloc_list);
+
+	spin_lock(&he->i_lock);
+	hot_comm_item_put(&hr->hot_range);
+	spin_unlock(&he->i_lock);
+
+	return ret;
+}
+
+/*
+ * Main function iterates through heat map table and
+ * finds hot and cold data to move based on SSD pressure.
+ *
+ * First iterates through cold items below the heat
+ * threshold, if the item is on SSD and is now cold,
+ * we queue it up for relocation back to spinning disk.
+ * After scanning these items, we call relocation code
+ * on all ranges that have been queued up for moving
+ * to HDD.
+ *
+ * We then iterate through items above the heat threshold
+ * and if they are on HDD we queue them up to be moved to
+ * SSD. We then iterate through queue and move hot ranges
+ * to SSD if they are not already.
+ */
+void hot_do_relocate(struct hot_reloc *hot_reloc)
+{
+	struct hot_info *root;
+	struct hot_range_item *hr;
+	struct hot_comm_item *ci, *ci_next;
+	int i, ret = 0, thresh, ratio = 0;
+	u64 count, count_to_cold, count_to_hot;
+	static u32 run = 1;
+
+	run++;
+	ratio = hot_update_threshold(hot_reloc, !(run % 15));
+	thresh = hot_reloc->thresh;
+
+	INIT_LIST_HEAD(&hot_reloc->hot_relocq[TYPE_NONROT]);
+
+	/* Check and queue hot extents */
+	count_to_hot = hot_search_extent(hot_reloc,
+					thresh, TYPE_NONROT);
+	if (count_to_hot == 0)
+		return;
+
+	count_to_cold = HOT_RELOC_MAX_ITEMS;
+
+	/* Don't move cold data to HDD unless there's space pressure */
+	if (ratio < HIGH_WATER_LEVEL)
+		goto do_hot_reloc;
+
+	INIT_LIST_HEAD(&hot_reloc->hot_relocq[TYPE_ROT]);
+
+	/*
+	 * Move up to RELOCATE_MAX_ITEMS cold ranges back to spinning
+	 * disk. First, queue up items to move on the hot_relocq[TYPE_ROT].
+	 */
+	root = hot_reloc->fs_info->sb->s_hot_root;
+	for (count = 0, count_to_cold = 0; (count < thresh) &&
+		(count_to_cold < count_to_hot); count++) {
+		rcu_read_lock();
+		if (!list_empty(&root->hot_map[TYPE_RANGE][count]))
+			ret = hot_queue_extent(hot_reloc,
+					&root->hot_map[TYPE_RANGE][count],
+					&count_to_cold, TYPE_ROT);
+		rcu_read_unlock();
+		if (ret) {
+			goto relocq_clean;
+		}
+	}
+
+	/* Do the hot -> cold relocation */
+	count_to_cold = 0;
+	list_for_each_entry_safe(ci, ci_next,
+			&hot_reloc->hot_relocq[TYPE_ROT], reloc_list) {
+        	hr = container_of(ci, struct hot_range_item, hot_range);
+		ret = hot_relocate_extent(hr, hot_reloc, TYPE_ROT);
+		if ((ret == -ENOSPC) || kthread_should_stop())
+			goto relocq_clean;
+		else if (ret > 0)
+			count_to_cold++;
+	}
+
+	/*
+	 * Move up to RELOCATE_MAX_ITEMS ranges to SSD. Periodically check
+	 * for space pressure on SSD and directly return if we've exceeded
+	 * the SSD capacity high water mark.
+	 * First, queue up items to move on hot_relocq[TYPE_NONROT].
+	 */
+do_hot_reloc:
+	/* Do the cold -> hot relocation */
+	count_to_hot = 0;
+	list_for_each_entry_safe(ci, ci_next,
+			&hot_reloc->hot_relocq[TYPE_NONROT], reloc_list) {
+		hr = container_of(ci, struct hot_range_item, hot_range);
+		ret = hot_relocate_extent(hr, hot_reloc, TYPE_NONROT);
+		if ((ret == -ENOSPC) || (count_to_hot >= count_to_cold) ||
+			kthread_should_stop())
+			goto relocq_clean;
+		else if (ret > 0)
+			count_to_hot++;
+
+		/*
+		 * If we've exceeded the SSD capacity high water mark,
+		 * directly return.
+		 */
+		if ((count_to_hot != 0) && count_to_hot % 30 == 0) {
+			ratio = hot_update_threshold(hot_reloc, 1);
+			if (ratio >= HIGH_WATER_LEVEL)
+				goto relocq_clean;
+		}
+	}
+
+	return;
+
+relocq_clean:
+	for (i = 0; i < MAX_RELOC_TYPES; i++)
+		hot_cleanup_relocq(&hot_reloc->hot_relocq[i]);
+}
+
+/* Main loop for running relcation thread */
+static int hot_relocate_kthread(void *arg)
+{
+	struct hot_reloc *hot_reloc = arg;
+	unsigned long delay;
+
+	do {
+		delay = HZ * HOT_RELOC_INTERVAL;
+		if (mutex_trylock(&hot_reloc->hot_reloc_mutex)) {
+			hot_do_relocate(hot_reloc);
+			mutex_unlock(&hot_reloc->hot_reloc_mutex);
+		}
+
+		if (!try_to_freeze()) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!kthread_should_stop())
+				schedule_timeout(delay);
+			__set_current_state(TASK_RUNNING);
+		}
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/* Kick off the relocation kthread */
+int hot_relocate_init(struct btrfs_fs_info *fs_info)
+{
+	int i, ret = 0;
+	struct hot_reloc *hot_reloc;
+
+	hot_reloc = kzalloc(sizeof(*hot_reloc), GFP_NOFS);
+	if (!hot_reloc) {
+		printk(KERN_ERR "%s: Failed to allocate memory for "
+				"hot_reloc\n", __func__);
+		return -ENOMEM;
+	}
+
+	fs_info->hot_reloc = hot_reloc;
+	hot_reloc->fs_info = fs_info;
+	hot_reloc->thresh = HOT_RELOC_THRESHOLD;
+	for (i = 0; i < MAX_RELOC_TYPES; i++)
+		INIT_LIST_HEAD(&hot_reloc->hot_relocq[i]);
+	mutex_init(&hot_reloc->hot_reloc_mutex);
+
+	hot_reloc->hot_reloc_kthread = kthread_run(hot_relocate_kthread,
+				hot_reloc, "hot_relocate_kthread");
+	ret = IS_ERR(hot_reloc->hot_reloc_kthread);
+	if (ret) {
+		kthread_stop(hot_reloc->hot_reloc_kthread);
+		kfree(hot_reloc);
+	}
+
+	return ret;
+}
+
+void hot_relocate_exit(struct btrfs_fs_info *fs_info)
+{
+	struct hot_reloc *hot_reloc = fs_info->hot_reloc;
+
+	if (hot_reloc->hot_reloc_kthread)
+		kthread_stop(hot_reloc->hot_reloc_kthread);
+
+	kfree(hot_reloc);
+	fs_info->hot_reloc = NULL;
+}
diff --git a/fs/btrfs/hot_relocate.h b/fs/btrfs/hot_relocate.h
index b8427ba..077d9b3 100644
--- a/fs/btrfs/hot_relocate.h
+++ b/fs/btrfs/hot_relocate.h
@@ -24,8 +24,29 @@ enum {
 	MAX_RELOC_TYPES
 };
 
+#define HOT_RELOC_INTERVAL  120
+#define HOT_RELOC_THRESHOLD 150
+#define HOT_RELOC_MAX_ITEMS 250
+
+#define HEAT_MAX_VALUE    (MAP_SIZE - 1)
+#define HIGH_WATER_LEVEL  75 /* when to raise the threshold */
+#define LOW_WATER_LEVEL   50 /* when to lower the threshold */
+#define THRESH_UP_SPEED   10 /* how much to raise it by */
+#define THRESH_DOWN_SPEED 1  /* how much to lower it by */
+#define THRESH_MAX_VALUE  100
+
+struct hot_reloc {
+	struct btrfs_fs_info *fs_info;
+	struct list_head hot_relocq[MAX_RELOC_TYPES];
+	int thresh;
+	struct task_struct *hot_reloc_kthread;
+	struct mutex hot_reloc_mutex;
+};
+
 void hot_set_extent(struct inode *inode, u64 start, u64 end,
 		struct extent_state **cached_state, int flag);
 int hot_get_chunk_type(struct inode *inode, u64 start, u64 end);
+int hot_relocate_init(struct btrfs_fs_info *fs_info);
+void hot_relocate_exit(struct btrfs_fs_info *fs_info);
 
 #endif /* __HOT_RELOCATE__ */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bdd8850..4cbd0de 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -57,6 +57,7 @@
 #include "compression.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
+#include "hot_relocate.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
-- 
1.7.11.7

