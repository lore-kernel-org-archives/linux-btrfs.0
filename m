From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 3/5] btrfs: initial readahead code and prototypes
Date: Mon, 23 May 2011 14:59:06 +0200
Message-ID: <320563549be689389d99d47d396290547db94982.1306154794.git.sensille@gmx.net>
References: <cover.1306154794.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This is the implementation for the generic read ahead framework.

To trigger a readahead, btrfs_reada_add must be called. It will start
a read ahead for the given range [start, end) on tree root. The returned
handle can either be used to wait on the readahead to finish
(btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).

The read ahead works as follows:
On btrfs_reada_add, the root of the tree is inserted into a radix_tree.
reada_start_machine will then search for extents to prefetch and trigger
some reads. When a read finishes for a node, all contained node/leaf
pointers that lie in the given range will also be enqueued. The reads will
be triggered in sequential order, thus giving a big win over a naive
enumeration. It will also make use of multi-device layouts. Each disk
will have its on read pointer and all disks will by utilized in parallel.
Also will no two disks read both sides of a mirror simultaneously, as this
would waste seeking capacity. Instead both disks will read different parts
of the filesystem.
Any number of readaheads can be started in parallel. The read order will be
determined globally, i.e. 2 parallel readaheads will normally finish faster
than the 2 started one after another.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/Makefile |    2 +-
 fs/btrfs/ctree.h  |    9 +
 fs/btrfs/reada.c  |  963 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 973 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 31610ea..3e9ed71 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o reada.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4a33e30..0de44a5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2641,4 +2641,13 @@ void btrfs_reloc_pre_snapshot(struct btrfs_trans_handle *trans,
 			      u64 *bytes_to_reserve);
 void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending);
+
+/* reada.c */
+void *btrfs_reada_add(struct btrfs_root *root, struct btrfs_key *start,
+		      struct btrfs_key *end);
+int btrfs_reada_wait(void *handle);
+void btrfs_reada_detach(void *handle);
+int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
+			 u64 start, int err);
+
 #endif
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
new file mode 100644
index 0000000..1801dd3
--- /dev/null
+++ b/fs/btrfs/reada.c
@@ -0,0 +1,963 @@
+/*
+ * Copyright (C) 2011 STRATO.  All rights reserved.
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
+#include <linux/sched.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/blkdev.h>
+#include <linux/rbtree.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include "ctree.h"
+#include "volumes.h"
+#include "disk-io.h"
+
+/*
+ * This is the implementation for the generic read ahead framework.
+ *
+ * To trigger a readahead, btrfs_reada_add must be called. It will start
+ * a read ahead for the given range [start, end) on tree root. The returned
+ * handle can either be used to wait on the readahead to finish
+ * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
+ *
+ * The read ahead works as follows:
+ * On btrfs_reada_add, the root of the tree is inserted into a radix_tree.
+ * reada_start_machine will then search for extents to prefetch and trigger
+ * some reads. When a read finishes for a node, all contained node/leaf
+ * pointers that lie in the given range will also be enqueued. The reads will
+ * be triggered in sequential order, thus giving a big win over a naive
+ * enumeration. It will also make use of multi-device layouts. Each disk
+ * will have its on read pointer and all disks will by utilized in parallel.
+ * Also will no two disks read both sides of a mirror simultaneously, as this
+ * would waste seeking capacity. Instead both disks will read different parts
+ * of the filesystem.
+ * Any number of readaheads can be started in parallel. The read order will be
+ * determined globally, i.e. 2 parallel readaheads will normally finish faster
+ * than the 2 started one after another.
+ */
+
+#define MAX_MIRRORS 2
+#define MAX_IN_FLIGHT 6
+
+struct reada_control {
+	struct btrfs_root	*root;		/* tree to prefetch */
+	struct btrfs_key	key_start;
+	struct btrfs_key	key_end;	/* exclusive */
+	spinlock_t		lock;
+	u64			elems;
+	u64			read_total;
+	struct kref		refcnt;
+	wait_queue_head_t	wait;
+};
+
+struct reada_extctl {
+	struct list_head	list;
+	struct reada_control	*rc;
+	u64			generation;
+};
+
+struct reada_extent {
+	u64			logical;
+	u32			blocksize;
+	int			err;
+	struct list_head	extctl;
+	struct kref		refcnt;
+	spinlock_t		lock;
+	struct reada_zone	*zones[MAX_MIRRORS];
+	int			nzones;
+	struct btrfs_device	*scheduled_for;
+};
+
+struct reada_zone {
+	u64			start;
+	u64			end;
+	u64			elems;
+	struct list_head	list;
+	spinlock_t		lock;
+	int			locked;
+	struct btrfs_device	*device;
+	struct btrfs_device	*devs[MAX_MIRRORS]; /* full list, incl self */
+	int			ndevs;
+	struct kref		refcnt;
+};
+
+struct reada_machine_work {
+	struct btrfs_work	work;
+	struct btrfs_fs_info	*fs_info;
+};
+
+static void reada_extent_put(struct btrfs_fs_info *, struct reada_extent *);
+static void reada_zone_put(struct reada_zone *);
+static void reada_control_put(struct reada_control *rc);
+static void reada_start_machine(struct btrfs_fs_info *fs_info);
+
+static int reada_key_cmp(struct btrfs_key *a, struct btrfs_key *b)
+{
+	if (a->objectid > b->objectid)
+		return 1;
+	if (a->objectid < b->objectid)
+		return -1;
+	if (a->type > b->type)
+		return 1;
+	if (a->type < b->type)
+		return -1;
+	if (a->offset > b->offset)
+		return 1;
+	if (a->offset < b->offset)
+		return -1;
+	return 0;
+}
+
+static int reada_add_block(struct reada_control *rc, u64 logical,
+			   int level, u64 generation);
+
+/* recurses */
+/* in case of err, eb might be NULL */
+static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
+			    u64 start, int err)
+{
+	int level = 0;
+	int nritems;
+	int i;
+	struct btrfs_key key;
+	u64 bytenr;
+	u64 generation;
+	struct reada_extent *re;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct list_head list;
+	unsigned long index = start >> PAGE_CACHE_SHIFT;
+	struct btrfs_device *for_dev;
+
+	if (eb)
+		level = btrfs_header_level(eb);
+
+	/* find extent */
+	spin_lock(&fs_info->reada_lock);
+	re = radix_tree_lookup(&fs_info->reada_tree, index);
+	if (re)
+		kref_get(&re->refcnt);
+	spin_unlock(&fs_info->reada_lock);
+
+	if (!re)
+		return -1;
+
+	spin_lock(&re->lock);
+	/*
+	 * just take the full list from the extent. afterwards we
+	 * don't need the lock anymore
+	 */
+	list_replace_init(&re->extctl, &list);
+	for_dev = re->scheduled_for;
+	re->scheduled_for = NULL;
+	spin_unlock(&re->lock);
+
+	if (err == 0) {
+		nritems = level ? btrfs_header_nritems(eb) : 0;
+		generation = btrfs_header_generation(eb);
+		/*
+		 * FIXME: currently we just set nritems to 0 if this is a leaf,
+		 * effectively ignoring the content. In a next step we could
+		 * trigger more readahead depending from the content, e.g.
+		 * fetch the checksums for the extents in the leaf.
+		 */
+	} else {
+		/*
+		 * this is the error case, the extent buffer has not been
+		 * read correctly. We won't access anything from it and
+		 * just cleanup our data structures. Effectively this will
+		 * cut the branch below this node from read ahead.
+		 */
+		nritems = 0;
+		generation = 0;
+	}
+
+	for (i = 0; i < nritems; i++) {
+		struct reada_extctl *rec;
+		u64 n_gen;
+
+		btrfs_node_key_to_cpu(eb, &key, i);
+		bytenr = btrfs_node_blockptr(eb, i);
+		n_gen = btrfs_node_ptr_generation(eb, i);
+
+		list_for_each_entry(rec, &list, list) {
+			struct reada_control *rc = rec->rc;
+
+			/*
+			 * if the generation doesn't match, just ignore this
+			 * extctl. This will probably cut off a branch from
+			 * prefetch. Alternatively one could start a new (sub-)
+			 * prefetch for this branch, starting again from root.
+			 * FIXME: move the generation check out of this loop
+			 */
+			if (rec->generation == generation &&
+			    reada_key_cmp(&key, &rc->key_start) >= 0 &&
+			    reada_key_cmp(&key, &rc->key_end) < 0) {
+				reada_add_block(rc, bytenr, level - 1, n_gen);
+			}
+		}
+	}
+	/*
+	 * free extctl records
+	 */
+	while (!list_empty(&list)) {
+		struct reada_control *rc;
+		struct reada_extctl *rec;
+
+		rec = list_first_entry(&list, struct reada_extctl,
+				       list);
+		list_del(&rec->list);
+		rc = rec->rc;
+		kfree(rec);
+
+		kref_get(&rc->refcnt);
+		spin_lock(&rc->lock);
+		--rc->elems;
+		if (rc->elems == 0) {
+			reada_control_put(rc);
+			wake_up(&rc->wait);
+		}
+		spin_unlock(&rc->lock);
+		reada_control_put(rc);
+
+		reada_extent_put(fs_info, re);	/* one ref for each entry */
+	}
+	reada_extent_put(fs_info, re);	/* our ref */
+	if (for_dev)
+		atomic_dec(&for_dev->reada_in_flight);
+
+	return 0;
+}
+
+/*
+ * start is passed separately in case eb in NULL, which may be the case with
+ * failed I/O
+ */
+int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
+			 u64 start, int err)
+{
+	int ret;
+
+	ret = __readahead_hook(root, eb, start, err);
+
+	reada_start_machine(root->fs_info);
+
+	return ret;
+}
+
+static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
+					  struct btrfs_device *dev, u64 logical,
+					  struct btrfs_multi_bio *multi)
+{
+	int ret;
+	int looped = 0;
+	struct reada_zone *zone;
+	struct btrfs_block_group_cache *cache = NULL;
+	u64 start;
+	u64 end;
+	int i;
+
+again:
+	zone = NULL;
+	spin_lock(&fs_info->reada_lock);
+	ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
+				     logical >> PAGE_CACHE_SHIFT, 1);
+	if (ret == 1)
+		kref_get(&zone->refcnt);
+	spin_unlock(&fs_info->reada_lock);
+
+	if (ret == 1) {
+		if (logical >= zone->start && logical < zone->end)
+			return zone;
+		spin_lock(&fs_info->reada_lock);
+		reada_zone_put(zone);
+		spin_unlock(&fs_info->reada_lock);
+	}
+
+	if (looped)
+		return NULL;
+
+	cache = btrfs_lookup_block_group(fs_info, logical);
+	if (!cache)
+		return NULL;
+
+	start = cache->key.objectid;
+	end = start + cache->key.offset - 1;
+	btrfs_put_block_group(cache);
+
+	zone = kzalloc(sizeof(*zone), GFP_NOFS);
+	if (!zone)
+		return NULL;
+
+	zone->start = start;
+	zone->end = end;
+	INIT_LIST_HEAD(&zone->list);
+	spin_lock_init(&zone->lock);
+	zone->locked = 0;
+	kref_init(&zone->refcnt);
+	zone->elems = 0;
+	zone->device = dev; /* our device always sits at index 0 */
+	for (i = 0; i < multi->num_stripes; ++i) {
+		/* bounds have already been checked */
+		zone->devs[i] = multi->stripes[i].dev;
+	}
+	zone->ndevs = multi->num_stripes;
+
+	spin_lock(&fs_info->reada_lock);
+	ret = radix_tree_insert(&dev->reada_zones,
+				(unsigned long)zone->end >> PAGE_CACHE_SHIFT,
+				zone);
+	spin_unlock(&fs_info->reada_lock);
+
+	if (ret) {
+		kfree(zone);
+		looped = 1;
+		goto again;
+	}
+
+	return zone;
+}
+
+static struct reada_extent *reada_find_extent(struct btrfs_root *root,
+					      u64 logical, int level)
+{
+	int ret;
+	int looped = 0;
+	struct reada_extent *re = NULL;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_device *dev;
+	u32 blocksize;
+	u64 length;
+	int nzones = 0;
+	int i;
+	unsigned long index = logical >> PAGE_CACHE_SHIFT;
+
+again:
+	spin_lock(&fs_info->reada_lock);
+	re = radix_tree_lookup(&fs_info->reada_tree, index);
+	if (re)
+		kref_get(&re->refcnt);
+	spin_unlock(&fs_info->reada_lock);
+
+	if (re || looped)
+		return re;
+
+	re = kzalloc(sizeof(*re), GFP_NOFS);
+	if (!re)
+		return NULL;
+
+	blocksize = btrfs_level_size(root, level);
+	re->logical = logical;
+	re->blocksize = blocksize;
+	INIT_LIST_HEAD(&re->extctl);
+	spin_lock_init(&re->lock);
+	kref_init(&re->refcnt);
+
+	/*
+	 * map block
+	 */
+	length = blocksize;
+	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length, &multi, 0);
+	if (ret || !multi || length < blocksize)
+		goto error;
+
+	if (multi->num_stripes > MAX_MIRRORS) {
+		printk(KERN_ERR "btrfs readahead: more than %d copies not "
+				"supported", MAX_MIRRORS);
+		goto error;
+	}
+
+	for (nzones = 0; nzones < multi->num_stripes; ++nzones) {
+		struct reada_zone *zone;
+
+		dev = multi->stripes[nzones].dev;
+		zone = reada_find_zone(fs_info, dev, logical, multi);
+		if (!zone)
+			break;
+
+		re->zones[nzones] = zone;
+		spin_lock(&zone->lock);
+		if (!zone->elems)
+			kref_get(&zone->refcnt);
+		++zone->elems;
+		spin_unlock(&zone->lock);
+		spin_lock(&fs_info->reada_lock);
+		reada_zone_put(zone);
+		spin_unlock(&fs_info->reada_lock);
+	}
+	re->nzones = nzones;
+	if (nzones == 0) {
+		/* not a single zone found, error and out */
+		goto error;
+	}
+
+	/* insert extent in reada_tree + all per-device trees, all or nothing */
+	spin_lock(&fs_info->reada_lock);
+	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
+	if (ret) {
+		spin_unlock(&fs_info->reada_lock);
+		if (ret != -ENOMEM) {
+			/* someone inserted the extent in the meantime */
+			looped = 1;
+		}
+		goto error;
+	}
+	for (i = 0; i < nzones; ++i) {
+		dev = multi->stripes[i].dev;
+		ret = radix_tree_insert(&dev->reada_extents, index, re);
+		if (ret) {
+			while (--i >= 0) {
+				dev = multi->stripes[i].dev;
+				BUG_ON(dev == NULL);
+				radix_tree_delete(&dev->reada_extents, index);
+			}
+			BUG_ON(fs_info == NULL);
+			radix_tree_delete(&fs_info->reada_tree, index);
+			spin_unlock(&fs_info->reada_lock);
+			goto error;
+		}
+	}
+	spin_unlock(&fs_info->reada_lock);
+
+	return re;
+
+error:
+	while (nzones) {
+		struct reada_zone *zone;
+
+		--nzones;
+		zone = re->zones[nzones];
+		kref_get(&zone->refcnt);
+		spin_lock(&zone->lock);
+		--zone->elems;
+		if (zone->elems == 0) {
+			/*
+			 * no fs_info->reada_lock needed, as this can't be
+			 * the last ref
+			 */
+			reada_zone_put(zone);
+		}
+		spin_unlock(&zone->lock);
+
+		spin_lock(&fs_info->reada_lock);
+		reada_zone_put(zone);
+		spin_unlock(&fs_info->reada_lock);
+	}
+	kfree(re);
+	if (looped)
+		goto again;
+	return NULL;
+}
+
+static void reada_kref_dummy(struct kref *kr)
+{
+}
+
+static void reada_extent_put(struct btrfs_fs_info *fs_info,
+			     struct reada_extent *re)
+{
+	int i;
+	unsigned long index = re->logical >> PAGE_CACHE_SHIFT;
+
+	spin_lock(&fs_info->reada_lock);
+	if (!kref_put(&re->refcnt, reada_kref_dummy)) {
+		spin_unlock(&fs_info->reada_lock);
+		return;
+	}
+
+	radix_tree_delete(&fs_info->reada_tree, index);
+	for (i = 0; i < re->nzones; ++i) {
+		struct reada_zone *zone = re->zones[i];
+
+		radix_tree_delete(&zone->device->reada_extents, index);
+	}
+
+	spin_unlock(&fs_info->reada_lock);
+
+	for (i = 0; i < re->nzones; ++i) {
+		struct reada_zone *zone = re->zones[i];
+
+		kref_get(&zone->refcnt);
+		spin_lock(&zone->lock);
+		--zone->elems;
+		if (zone->elems == 0) {
+			/* no fs_info->reada_lock needed, as this can't be
+			 * the last ref */
+			reada_zone_put(zone);
+		}
+		spin_unlock(&zone->lock);
+
+		spin_lock(&fs_info->reada_lock);
+		reada_zone_put(zone);
+		spin_unlock(&fs_info->reada_lock);
+	}
+	if (re->scheduled_for)
+		atomic_dec(&re->scheduled_for->reada_in_flight);
+
+	kfree(re);
+}
+
+/* call it with fs_info->reada_lock held */
+static void reada_zone_put(struct reada_zone *zone)
+{
+	if (!kref_put(&zone->refcnt, reada_kref_dummy))
+		return;
+
+	radix_tree_delete(&zone->device->reada_zones,
+			  zone->end >> PAGE_CACHE_SHIFT);
+
+	kfree(zone);
+
+	return;
+}
+
+static void reada_control_put(struct reada_control *rc)
+{
+	if (kref_put(&rc->refcnt, reada_kref_dummy)) {
+		kfree(rc);
+		return;
+	}
+}
+
+static int reada_add_block(struct reada_control *rc, u64 logical, int level,
+			   u64 generation)
+{
+	struct btrfs_root *root = rc->root;
+	struct reada_extent *re;
+	struct reada_extctl *rec;
+
+	re = reada_find_extent(root, logical, level);	/* takes one ref */
+	if (!re)
+		return -1;
+
+	rec = kzalloc(sizeof(*rec), GFP_NOFS);
+	if (!rec) {
+		reada_extent_put(root->fs_info, re);
+		return -1;
+	}
+
+	rec->rc = rc;
+	rec->generation = generation;
+	spin_lock(&rc->lock);
+	++rc->elems;
+	spin_unlock(&rc->lock);
+
+	spin_lock(&re->lock);
+	list_add_tail(&rec->list, &re->extctl);
+	spin_unlock(&re->lock);
+
+	/* leave the ref on the extent */
+
+	return 0;
+}
+
+/*
+ * called with fs_info->reada_lock held
+ */
+static void reada_peer_zones_set_lock(struct reada_zone *zone, int lock)
+{
+	int i;
+	unsigned long index = zone->end >> PAGE_CACHE_SHIFT;
+
+	for (i = 0; i < zone->ndevs; ++i) {
+		struct reada_zone *peer;
+		peer = radix_tree_lookup(&zone->devs[i]->reada_zones, index);
+		if (peer && peer->device != zone->device)
+			peer->locked = lock;
+	}
+}
+
+/*
+ * called with fs_info->reada_lock held
+ */
+static int reada_pick_zone(struct btrfs_device *dev)
+{
+	struct reada_zone *top_zone = NULL;
+	struct reada_zone *top_locked_zone = NULL;
+	u64 top_elems = 0;
+	u64 top_locked_elems = 0;
+	unsigned long index = 0;
+	int ret;
+
+	if (dev->reada_curr_zone) {
+		reada_peer_zones_set_lock(dev->reada_curr_zone, 0);
+		reada_zone_put(dev->reada_curr_zone);
+		dev->reada_curr_zone = NULL;
+	}
+	/* pick the zone with the most elements */
+	while (1) {
+		struct reada_zone *zone;
+
+		ret = radix_tree_gang_lookup(&dev->reada_zones,
+					     (void **)&zone, index, 1);
+		if (ret == 0)
+			break;
+		index = (zone->end >> PAGE_CACHE_SHIFT) + 1;
+		if (zone->locked) {
+			if (zone->elems > top_locked_elems) {
+				top_locked_elems = zone->elems;
+				top_locked_zone = zone;
+			}
+		} else {
+			if (zone->elems > top_elems) {
+				top_elems = zone->elems;
+				top_zone = zone;
+			}
+		}
+	}
+	if (top_zone)
+		dev->reada_curr_zone = top_zone;
+	else if (top_locked_zone)
+		dev->reada_curr_zone = top_locked_zone;
+	else
+		return 0;
+
+	dev->reada_next = dev->reada_curr_zone->start;
+	kref_get(&dev->reada_curr_zone->refcnt);
+	reada_peer_zones_set_lock(dev->reada_curr_zone, 1);
+
+	return 1;
+}
+
+static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
+				   struct btrfs_device *dev)
+{
+	struct reada_extent *re = NULL;
+	int mirror_num = 0;
+	struct extent_buffer *eb = NULL;
+	u64 logical;
+	u32 blocksize;
+	int ret;
+	int i;
+	int need_kick = 0;
+
+	spin_lock(&fs_info->reada_lock);
+	if (dev->reada_curr_zone == NULL) {
+		ret = reada_pick_zone(dev);
+		if (!ret) {
+			spin_unlock(&fs_info->reada_lock);
+			return 0;
+		}
+	}
+	/*
+	 * FIXME currently we issue the reads one extent at a time. If we have
+	 * a contiguous block of extents, we could also coagulate them or use
+	 * plugging to speed things up
+	 */
+	ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
+				     dev->reada_next >> PAGE_CACHE_SHIFT, 1);
+	if (ret == 0 || re->logical >= dev->reada_curr_zone->end) {
+		ret = reada_pick_zone(dev);
+		if (!ret) {
+			spin_unlock(&fs_info->reada_lock);
+			return 0;
+		}
+		re = NULL;
+		ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
+					dev->reada_next >> PAGE_CACHE_SHIFT, 1);
+	}
+	if (ret == 0) {
+		spin_unlock(&fs_info->reada_lock);
+		return 0;
+	}
+	dev->reada_next = re->logical + re->blocksize;
+	kref_get(&re->refcnt);
+
+	spin_unlock(&fs_info->reada_lock);
+
+	/*
+	 * find mirror num
+	 */
+	for (i = 0; i < re->nzones; ++i) {
+		if (re->zones[i]->device == dev) {
+			mirror_num = i + 1;
+			break;
+		}
+	}
+	logical = re->logical;
+	blocksize = re->blocksize;
+
+	spin_lock(&re->lock);
+	if (re->scheduled_for == NULL) {
+		re->scheduled_for = dev;
+		need_kick = 1;
+	}
+	spin_unlock(&re->lock);
+
+	reada_extent_put(fs_info, re);
+
+	if (!need_kick)
+		return 0;
+
+	atomic_inc(&dev->reada_in_flight);
+	ret = reada_tree_block_flagged(fs_info->extent_root, logical, blocksize,
+			 mirror_num, &eb);
+	if (eb) {
+		__readahead_hook(fs_info->extent_root, eb, eb->start, ret);
+		free_extent_buffer(eb);
+	}
+
+	return 1;
+
+}
+
+static void reada_start_machine_worker(struct btrfs_work *work)
+{
+	struct reada_machine_work *rmw;
+	struct btrfs_fs_info *fs_info;
+
+	rmw = container_of(work, struct reada_machine_work, work);
+	fs_info = rmw->fs_info;
+
+	kfree(rmw);
+
+	reada_start_machine(fs_info);
+}
+
+static void reada_start_machine(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	u64 enqueued;
+	u64 total = 0;
+	int i;
+
+again:
+	do {
+		enqueued = 0;
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+			if (atomic_read(&device->reada_in_flight) <
+			    MAX_IN_FLIGHT)
+				enqueued += reada_start_machine_dev(fs_info,
+								    device);
+		}
+		total += enqueued;
+	} while (enqueued && total < 10000);
+
+	if (enqueued == 0)
+		return;
+
+	/*
+	 * If everything is already in the cache, this is effectively single
+	 * threaded. To a) not hold the caller for too long and b) to utilize
+	 * more cores, we broke the loop above after 10000 iterations and now
+	 * enqueue to workers to finish it. This will distribute the load to
+	 * the cores.
+	 * FIXME we might need our own workqueue here, with an idle threshold
+	 * of one. Also these worker are relatively long-running.
+	 */
+	for (i = 0; i < 2; ++i) {
+		struct reada_machine_work *rmw;
+
+		rmw = kzalloc(sizeof(*rmw), GFP_NOFS);
+		if (!rmw) {
+			/*
+			 * no memory to kick it off to worker, so just do the
+			 * rest of the work from here
+			 */
+			goto again;
+		}
+		rmw->work.func = reada_start_machine_worker;
+		rmw->fs_info = fs_info;
+		btrfs_queue_worker(&fs_info->endio_meta_workers, &rmw->work);
+	}
+}
+
+static void dump_devs(struct btrfs_fs_info *fs_info, int all)
+{
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	unsigned long index;
+	int ret;
+	int i;
+	int j;
+	int cnt;
+
+	spin_lock(&fs_info->reada_lock);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		printk(KERN_DEBUG "dev %lld has %d in flight\n", device->devid,
+			atomic_read(&device->reada_in_flight));
+		index = 0;
+		while (1) {
+			struct reada_zone *zone;
+			ret = radix_tree_gang_lookup(&device->reada_zones,
+						     (void **)&zone, index, 1);
+			if (ret == 0)
+				break;
+			printk(KERN_DEBUG "  zone %llu-%llu elems %llu locked "
+				"%d devs", zone->start, zone->end, zone->elems,
+				zone->locked);
+			for (j = 0; j < zone->ndevs; ++j) {
+				printk(KERN_DEBUG " %lld",
+					zone->devs[j]->devid);
+			}
+			if (device->reada_curr_zone == zone)
+				printk(KERN_DEBUG " curr off %llu",
+					device->reada_next - zone->start);
+			printk(KERN_DEBUG "\n");
+			index = (zone->end >> PAGE_CACHE_SHIFT) + 1;
+		}
+		cnt = 0;
+		index = 0;
+		while (all) {
+			struct reada_extent *re = NULL;
+
+			ret = radix_tree_gang_lookup(&device->reada_extents,
+						     (void **)&re, index, 1);
+			if (ret == 0)
+				break;
+			printk(KERN_DEBUG
+				"  re: logical %llu size %u empty %d for %lld",
+				re->logical, re->blocksize,
+				list_empty(&re->extctl), re->scheduled_for ?
+				re->scheduled_for->devid : -1);
+
+			for (i = 0; i < re->nzones; ++i) {
+				printk(KERN_DEBUG " zone %llu-%llu devs",
+					re->zones[i]->start,
+					re->zones[i]->end);
+				for (j = 0; j < re->zones[i]->ndevs; ++j) {
+					printk(KERN_DEBUG " %lld",
+						re->zones[i]->devs[j]->devid);
+				}
+			}
+			printk(KERN_DEBUG "\n");
+			index = (re->logical >> PAGE_CACHE_SHIFT) + 1;
+			if (++cnt > 15)
+				break;
+		}
+	}
+
+	index = 0;
+	cnt = 0;
+	while (all) {
+		struct reada_extent *re = NULL;
+
+		ret = radix_tree_gang_lookup(&fs_info->reada_tree, (void **)&re,
+					     index, 1);
+		if (ret == 0)
+			break;
+		printk(KERN_DEBUG
+			"re: logical %llu size %u list empty %d for %lld",
+			re->logical, re->blocksize, list_empty(&re->extctl),
+			re->scheduled_for ? re->scheduled_for->devid : -1);
+		for (i = 0; i < re->nzones; ++i) {
+			printk(KERN_DEBUG " zone %llu-%llu devs",
+				re->zones[i]->start,
+				re->zones[i]->end);
+			for (i = 0; i < re->nzones; ++i) {
+				printk(KERN_DEBUG " zone %llu-%llu devs",
+					re->zones[i]->start,
+					re->zones[i]->end);
+				for (j = 0; j < re->zones[i]->ndevs; ++j) {
+					printk(KERN_DEBUG " %lld",
+						re->zones[i]->devs[j]->devid);
+				}
+			}
+		}
+		printk(KERN_DEBUG "\n");
+		index = (re->logical >> PAGE_CACHE_SHIFT) + 1;
+		if (!all && ++cnt > 25)
+			break;
+	}
+	spin_unlock(&fs_info->reada_lock);
+}
+
+/*
+ * interface
+ */
+void *btrfs_reada_add(struct btrfs_root *root, struct btrfs_key *key_start,
+		      struct btrfs_key *key_end)
+{
+	struct reada_control *rc;
+	u64 start;
+	u64 generation;
+	int level;
+
+	rc = kzalloc(sizeof(*rc), GFP_NOFS);
+	if (!rc)
+		return ERR_PTR(-ENOMEM);
+
+	rc->root = root;
+	rc->key_start = *key_start;
+	rc->key_end = *key_end;
+	spin_lock_init(&rc->lock);
+	rc->elems = 0;
+	rc->read_total = 0;
+	init_waitqueue_head(&rc->wait);
+	kref_init(&rc->refcnt);
+	kref_get(&rc->refcnt); /* one ref for having elements */
+
+	spin_lock(&root->node_lock);
+	start = root->node->start;
+	level = btrfs_header_level(root->node);
+	generation = btrfs_header_generation(root->node);
+	spin_unlock(&root->node_lock);
+
+	reada_add_block(rc, start, level, generation);
+
+	reada_start_machine(root->fs_info);
+
+	return rc;
+}
+
+int btrfs_reada_wait(void *handle)
+{
+	struct reada_control *rc = handle;
+
+	spin_lock(&rc->lock);
+	while (rc->elems) {
+		spin_unlock(&rc->lock);
+		wait_event(rc->wait, rc->elems == 0);
+		spin_lock(&rc->lock);
+	}
+	spin_unlock(&rc->lock);
+
+	reada_control_put(rc);
+
+	return 0;
+}
+
+int btrfs_reada_wait_debug(void *handle)
+{
+	struct reada_control *rc = handle;
+
+	spin_lock(&rc->lock);
+	while (rc->elems) {
+		spin_unlock(&rc->lock);
+		wait_event_timeout(rc->wait, rc->elems == 0, 2 * HZ);
+		spin_lock(&rc->lock);
+		printk(KERN_DEBUG "timeout: elems=%lld\n", rc->elems);
+		dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+	}
+	spin_unlock(&rc->lock);
+
+	dump_devs(rc->root->fs_info, rc->elems < 10 ? 1 : 0);
+
+	reada_control_put(rc);
+
+	return 0;
+}
+
+void btrfs_reada_detach(void *handle)
+{
+	struct reada_control *rc = handle;
+
+	reada_control_put(rc);
+}
-- 
1.7.3.4

