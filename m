From: bchociej@gmail.com
Subject: [RFC v2 PATCH 1/6] Btrfs: Add experimental hot data hash list index
Date: Thu, 12 Aug 2010 17:22:01 -0500
Message-ID: <1281651726-23501-2-git-send-email-bchociej@gmail.com>
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

Adds a hash table structure to efficiently lookup the data temperature
of a file. Also adds a function to calculate that temperature based on
some metrics kept in custom frequency data structs (in the next patch).

Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Signed-off-by: Conor Scott <conscott@vt.edu>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/btrfs/hotdata_hash.c |  338 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_hash.h |  155 ++++++++++++++++++++++
 2 files changed, 493 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/hotdata_hash.c
 create mode 100644 fs/btrfs/hotdata_hash.h

diff --git a/fs/btrfs/hotdata_hash.c b/fs/btrfs/hotdata_hash.c
new file mode 100644
index 0000000..b789edd
--- /dev/null
+++ b/fs/btrfs/hotdata_hash.c
@@ -0,0 +1,338 @@
+/*
+ * fs/btrfs/hotdata_hash.c
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
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/hash.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
+#include "hotdata_relocate.h"
+#include "async-thread.h"
+#include "ctree.h"
+
+struct heat_hashlist_node *alloc_heat_hashlist_node(gfp_t mask)
+{
+	struct heat_hashlist_node *node;
+
+	node = kmalloc(sizeof(struct heat_hashlist_node), mask);
+	if (!node || IS_ERR(node))
+		return node;
+	INIT_HLIST_NODE(&node->hashnode);
+	node->freq_data = NULL;
+	node->hlist = NULL;
+	node->location = BTRFS_ON_ROTATING;
+	spin_lock_init(&node->lock);
+	spin_lock_init(&node->location_lock);
+	atomic_set(&node->refs, 1);
+
+	return node;
+}
+
+void free_heat_hashlists(struct btrfs_root *root)
+{
+	int i;
+
+	/* Free node/range heat hash lists */
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		struct hlist_node *pos = NULL, *pos2 = NULL;
+		struct heat_hashlist_node *heatnode = NULL;
+
+		hlist_for_each_safe(pos, pos2,
+			&root->heat_inode_hl[i].hashhead) {
+			heatnode = hlist_entry(pos, struct heat_hashlist_node,
+				hashnode);
+			hlist_del(pos);
+			kfree(heatnode);
+		}
+		hlist_for_each_safe(pos, pos2,
+			&root->heat_range_hl[i].hashhead) {
+			heatnode = hlist_entry(pos, struct heat_hashlist_node,
+				hashnode);
+			hlist_del(pos);
+			kfree(heatnode);
+		}
+	}
+}
+
+/*
+ * btrfs_get_temp is responsible for distilling the six heat criteria, which
+ * are described in detail in hotdata_hash.h) down into a single temperature
+ * value for the data, which is an integer between 0 and HEAT_MAX_VALUE.
+ *
+ * To accomplish this, the raw values from the btrfs_freq_data structure
+ * are shifted various ways in order to make the temperature calculation more
+ * or less sensitive to each value.
+ *
+ * Once this calibration has happened, we do some additional normalization and
+ * make sure that everything fits nicely in a u32. From there, we take a very
+ * rudimentary kind of "average" of each of the values, where the *_COEFF_POWER
+ * values act as weights for the average.
+ *
+ * Finally, we use the HEAT_HASH_BITS value, which determines the size of the
+ * heat hash list, to normalize the temperature to the proper granularity.
+ */
+int btrfs_get_temp(struct btrfs_freq_data *fdata)
+{
+	u32 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+
+	u32 nrr_heat = fdata->nr_reads << NRR_MULTIPLIER_POWER;
+	u32 nrw_heat = fdata->nr_writes << NRW_MULTIPLIER_POWER;
+
+	u64 ltr_heat = (cur_time - timespec_to_ns(&fdata->last_read_time))
+			>> LTR_DIVIDER_POWER;
+	u64 ltw_heat = (cur_time - timespec_to_ns(&fdata->last_write_time))
+			>> LTW_DIVIDER_POWER;
+
+	u64 avr_heat = (((u64) -1) - fdata->avg_delta_reads)
+			>> AVR_DIVIDER_POWER;
+	u64 avw_heat = (((u64) -1) - fdata->avg_delta_writes)
+			>> AVR_DIVIDER_POWER;
+
+	if (ltr_heat >= ((u64) 1 << 32))
+		ltr_heat = 0;
+	else
+		ltr_heat = ((u64) 1 << 32) - ltr_heat;
+	/* ltr_heat is now guaranteed to be u32 safe */
+
+	if (ltw_heat >= ((u64) 1 << 32))
+		ltw_heat = 0;
+	else
+		ltw_heat = ((u64) 1 << 32) - ltw_heat;
+	/* ltw_heat is now guaranteed to be u32 safe */
+
+	if (avr_heat >= ((u64) 1 << 32))
+		avr_heat = (u32) -1;
+	/* avr_heat is now guaranteed to be u32 safe */
+
+	if (avw_heat >= ((u64) 1 << 32))
+		avr_heat = (u32) -1;
+	/* avw_heat is now guaranteed to be u32 safe */
+
+	nrr_heat = nrr_heat >> (3 - NRR_COEFF_POWER);
+	nrw_heat = nrw_heat >> (3 - NRW_COEFF_POWER);
+	ltr_heat = ltr_heat >> (3 - LTR_COEFF_POWER);
+	ltw_heat = ltw_heat >> (3 - LTW_COEFF_POWER);
+	avr_heat = avr_heat >> (3 - AVR_COEFF_POWER);
+	avw_heat = avw_heat >> (3 - AVW_COEFF_POWER);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		 (u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result >> (32 - HEAT_HASH_BITS);
+}
+
+static int is_old(struct btrfs_freq_data *freq_data)
+{
+	int ret = 0;
+	struct timespec ckt = current_kernel_time();
+
+	u64 cur_time = timespec_to_ns(&ckt);
+	u64 last_read_ns = (cur_time -
+			    timespec_to_ns(&freq_data->last_read_time));
+	u64 last_write_ns = (cur_time -
+			     timespec_to_ns(&freq_data->last_write_time));
+	u64 kick_ns = TIME_TO_KICK * (u64)1000000000;
+	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+		ret = 1;
+	return ret;
+}
+
+
+/* update temps for each range item for aging purposes */
+static void btrfs_update_range_data(struct hot_inode_item *hot_inode,
+				    struct btrfs_root *root)
+{
+	struct hot_range_tree *inode_range_tree;
+	struct rb_node *node;
+	struct rb_node *old_node;
+	struct hot_range_item *current_range;
+	int location, range_is_old;
+
+	inode_range_tree = &hot_inode->hot_range_tree;
+	write_lock(&inode_range_tree->lock);
+	node = rb_first(&inode_range_tree->map);
+	/* Walk the hot_range_tree for inode */
+	while (node) {
+		current_range = rb_entry(node, struct hot_range_item, rb_node);
+		btrfs_update_heat_index(&current_range->freq_data, root);
+		old_node = node;
+		node = rb_next(node);
+		/* if the inode is cold and off ssd, quit keeping track of it */
+		spin_lock(&current_range->heat_node->location_lock);
+		location = current_range->heat_node->location;
+		spin_unlock(&current_range->heat_node->location_lock);
+
+		spin_lock(&current_range->lock);
+		range_is_old = is_old(&current_range->freq_data);
+		spin_unlock(&current_range->lock);
+
+		if (range_is_old && location == BTRFS_ON_ROTATING) {
+			if (atomic_read(&current_range->heat_node->refs) <= 1)
+				btrfs_remove_range_from_heat_index(hot_inode,
+							current_range, root);
+		}
+	}
+	write_unlock(&inode_range_tree->lock);
+}
+
+/* update temps for each hot inode item and hot range item for aging purposes */
+static void iterate_and_update_heat(struct btrfs_root *root)
+{
+	struct btrfs_root *fs_root;
+	struct hot_inode_item *current_hot_inode;
+	struct hot_inode_tree *hot_inode_tree;
+	unsigned long inode_num;
+
+	hot_inode_tree = &root->hot_inode_tree;
+
+	fs_root = root->fs_info->fs_root;
+	/* walk the inode tree */
+	current_hot_inode = find_next_hot_inode(fs_root, 0);
+	while (current_hot_inode) {
+		btrfs_update_heat_index(&current_hot_inode->freq_data, root);
+		btrfs_update_range_data(current_hot_inode, fs_root);
+		inode_num = current_hot_inode->i_ino;
+		free_hot_inode_item(current_hot_inode);
+		current_hot_inode = find_next_hot_inode(fs_root,
+				inode_num + 1);
+	}
+}
+
+/*
+ * kthread iterates each hot_inode_item and hot_range_item
+ * and update temperatures to be shifted in heat hash table
+ * for purposes of relocation and such hot file detection
+ */
+static int update_inode_kthread(void *arg)
+{
+	struct btrfs_root *root = arg;
+	unsigned long delay;
+	do {
+		delay = HZ * HEAT_UPDATE_DELAY;
+		if (mutex_trylock(&root->fs_info->
+			hot_data_update_kthread_mutex)) {
+			iterate_and_update_heat(root);
+			mutex_unlock(&root->fs_info->
+				     hot_data_update_kthread_mutex);
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
+/* init the kthread to do temp updates */
+void init_hash_list_kthread(struct btrfs_root *root)
+{
+	root->fs_info->hot_data_update_kthread =
+					kthread_run(update_inode_kthread,
+					root,
+					"update_hot_inode_kthread");
+	if (IS_ERR(root->fs_info->hot_data_update_kthread))
+		kthread_stop(root->fs_info->hot_data_update_kthread);
+}
+
+/*
+ * take hot inode that is now cold and remove from indexes and clean up
+ * any memory associted, involves removing hot inode from rb tree, and
+ * heat hash lists, and freeing up all memory and range memory.
+ */
+void btrfs_remove_inode_from_heat_index(struct hot_inode_item *hot_inode,
+				  struct btrfs_root *root)
+{
+	struct rb_node *node2;
+	struct hot_range_item *hr;
+
+	/* remove hot inode item from rb tree */
+	write_lock(&root->hot_inode_tree.lock);
+	remove_hot_inode_item(&root->hot_inode_tree, hot_inode);
+	write_unlock(&root->hot_inode_tree.lock);
+
+	/* remove the hot inode item from hash table */
+	write_lock(&hot_inode->heat_node->hlist->rwlock);
+	hlist_del(&hot_inode->heat_node->hashnode);
+	write_unlock(&hot_inode->heat_node->hlist->rwlock);
+
+	/* remove ranges in inode from rb-tree and heat table first */
+	write_lock(&hot_inode->hot_range_tree.lock);
+	node2 = rb_first(&hot_inode->hot_range_tree.map);
+	while (node2) {
+		hr = rb_entry(node2, struct hot_range_item,
+			rb_node);
+
+		/* remove range from range tree */
+		remove_hot_range_item(&hot_inode->hot_range_tree, hr);
+
+		/* remove range from hash list */
+		write_lock(&hr->heat_node->hlist->rwlock);
+		hlist_del(&hr->heat_node->hashnode);
+		write_unlock(&hr->heat_node->hlist->rwlock);
+
+		/*free up memory */
+		kfree(hr->heat_node);
+		free_hot_range_item(hr);
+
+		node2 = rb_first(&hot_inode->hot_range_tree.map);
+	}
+	write_unlock(&hot_inode->hot_range_tree.lock);
+
+	/* free up associated inode memory */
+	kfree(hot_inode->heat_node);
+	free_hot_inode_item(hot_inode);
+}
+
+/*
+ * take hot range that is now cold and remove from indexes and clean up
+ * any memory associted, involves removing hot range from rb tree, and
+ * heat hash lists, and freeing up all memory.
+ */
+void btrfs_remove_range_from_heat_index(struct hot_inode_item *hot_inode,
+					struct hot_range_item *hr,
+					struct btrfs_root *root)
+{
+	/* remove range from rb tree */
+	remove_hot_range_item(&hot_inode->hot_range_tree, hr);
+
+	/* remove range from hash list */
+	spin_lock(&hr->heat_node->lock);
+	write_lock(&hr->heat_node->hlist->rwlock);
+	hlist_del(&hr->heat_node->hashnode);
+	write_unlock(&hr->heat_node->hlist->rwlock);
+	spin_unlock(&hr->heat_node->lock);
+
+	/*free up memory */
+	kfree(hr->heat_node);
+	free_hot_range_item(hr);
+}
diff --git a/fs/btrfs/hotdata_hash.h b/fs/btrfs/hotdata_hash.h
new file mode 100644
index 0000000..10d28ee
--- /dev/null
+++ b/fs/btrfs/hotdata_hash.h
@@ -0,0 +1,155 @@
+/*
+ * fs/btrfs/hotdata_hash.h
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
+#ifndef __HOTDATAHASH__
+#define __HOTDATAHASH__
+
+#include <linux/list.h>
+#include <linux/hash.h>
+
+#define HEAT_HASH_BITS 8
+#define HEAT_HASH_SIZE (1 << HEAT_HASH_BITS)
+#define HEAT_HASH_MASK (HEAT_HASH_SIZE - 1)
+#define HEAT_MIN_VALUE 0
+#define HEAT_MAX_VALUE (HEAT_HASH_SIZE - 1)
+#define HEAT_NO_MIGRATE HEAT_HASH_SIZE
+
+/* time to quit keeping track of tracking data (seconds)*/
+#define TIME_TO_KICK 400
+
+/* set how often to update temps (seconds) */
+#define HEAT_UPDATE_DELAY 400
+
+/* initial heat threshold temperature */
+#define HEAT_INITIAL_THRESH 150
+
+/*
+ * The following comments explain what exactly comprises a unit of heat.
+ *
+ * Each of six values of heat are calculated and combined in order to form an
+ * overall temperature for the data:
+ *
+ * NRR - number of reads since mount
+ * NRW - number of writes since mount
+ * LTR - time elapsed since last read (ns)
+ * LTW - time elapsed since last write (ns)
+ * AVR - average delta between recent reads (ns)
+ * AVW - average delta between recent writes (ns)
+ *
+ * These values are divided (right-shifted) according to the *_DIVIDER_POWER
+ * values defined below to bring the numbers into a reasonable range. You can
+ * modify these values to fit your needs. However, each heat unit is a u32 and
+ * thus maxes out at 2^32 - 1. Therefore, you must choose your dividers quite
+ * carefully or else they could max out or be stuck at zero quite easily.
+ *
+ * (E.g., if you chose AVR_DIVIDER_POWER = 0, nothing less than 4s of atime
+ * delta would bring the temperature above zero, ever.)
+ *
+ * Finally, each value is added to the overall temperature between 0 and 8
+ * times, depending on its *_COEFF_POWER value. Note that the coefficients are
+ * also actually implemented with shifts, so take care to treat these values
+ * as powers of 2. (I.e., 0 means we'll add it to the temp once; 1 = 2x, etc.)
+ */
+
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ *
+ * E.g., data with an average delta between 0 and 2^X ns will have a cold value
+ * of 0, which means a heat value equal to HEAT_MAX_VALUE.
+ */
+#define AVR_DIVIDER_POWER 40
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40
+#define AVW_COEFF_POWER 0
+
+struct btrfs_root;
+
+/* Hash list heads for heat hash table */
+struct heat_hashlist_entry {
+	struct hlist_head hashhead;
+	rwlock_t rwlock;
+	u32 temperature;
+};
+
+/* Nodes stored in each hash list of hash table */
+struct heat_hashlist_node {
+	struct hlist_node hashnode;
+	struct list_head node;
+	struct btrfs_freq_data *freq_data;
+	struct heat_hashlist_entry *hlist;
+
+	/*
+	 * number of references to this node
+	 * equals 1 (hashlist entry) + number
+	 * of private relocation lists it is on
+	 */
+	atomic_t refs;
+
+	spinlock_t lock; /* protects hlist */
+	spinlock_t location_lock; /* protects location */
+	u8 location; /*flag for whether or not on rotating*/
+};
+
+struct heat_hashlist_node *alloc_heat_hashlist_node(gfp_t mask);
+void free_heat_hashlists(struct btrfs_root *root);
+
+/*
+ * Returns a value from 0 to HEAT_MAX_VALUE indicating the temperature of the
+ * file (and consequently its bucket number in hashlist) (see hotdata_hash.c)
+ */
+int btrfs_get_temp(struct btrfs_freq_data *fdata);
+
+/*
+ * initialize kthread for each new mount point that
+ * periodically goes through hot inodes and hot ranges and ages them
+ * based on frequency of access
+ */
+void init_hash_list_kthread(struct btrfs_root *root);
+
+/*
+ * recalculates temperatures for inode or range
+ * and moves around in heat hash table based on temp
+ */
+void btrfs_update_heat_index(struct btrfs_freq_data *fdata,
+			       struct btrfs_root *root);
+
+/* remove from index and clean up all memory associated with hot range */
+void btrfs_remove_range_from_heat_index(struct hot_inode_item *hot_inode,
+					struct hot_range_item *hr,
+					struct btrfs_root *root);
+
+/* remove form index and clean up all memory associated with hot inode */
+void btrfs_remove_inode_from_heat_index(struct hot_inode_item *hot_inode,
+				  struct btrfs_root *root);
+
+#endif /* __HOTDATAHASH__ */
-- 
1.7.1
