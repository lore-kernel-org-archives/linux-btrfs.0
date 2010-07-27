From: bchociej@gmail.com
Subject: [RFC PATCH 2/5] Btrfs: Add data structures for hot data tracking
Date: Tue, 27 Jul 2010 17:00:20 -0500
Message-ID: <1280268023-18408-3-git-send-email-bchociej@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bcchocie@us.ibm.com>

Adds hot_inode_tree and hot_range_tree structs to keep track of
frequently accessed files and ranges within files. Trees contain
hot_{inode,range}_items representing those files and ranges, each of
which contains a btrfs_freq_data struct with its frequency of access
metrics (number of {reads, writes}, last {read,write} time, frequency of
{reads,writes}.

Having these trees means that Btrfs can quickly determine the
temperature of some data by doing some calculations on the
btrfs_freq_data struct that hangs off of the tree item.

Also, since it isn't entirely obvious, the "frequency" or reads or
writes is determined by taking a kind of generalized average of the last
few (2^N for some tunable N) reads or writes.

Signed-off-by: Ben Chociej <bcchocie@us.ibm.com>
Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Signed-off-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
---
 fs/btrfs/hotdata_map.c |  660 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_map.h |  118 +++++++++
 2 files changed, 778 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/hotdata_map.c
 create mode 100644 fs/btrfs/hotdata_map.h

diff --git a/fs/btrfs/hotdata_map.c b/fs/btrfs/hotdata_map.c
new file mode 100644
index 0000000..77a560e
--- /dev/null
+++ b/fs/btrfs/hotdata_map.c
@@ -0,0 +1,660 @@
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include "ctree.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
+#include "btrfs_inode.h"
+
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cache;
+static struct kmem_cache *hot_range_item_cache;
+
+struct hot_inode_item *btrfs_update_inode_freq(struct btrfs_inode *inode,
+					       int create);
+struct hot_range_item *btrfs_update_range_freq(struct hot_inode_item *he,
+					       u64 off, u64 len, int create,
+					       struct btrfs_root *root);
+/* init hot_inode_item kmem cache */
+int __init hot_inode_item_init(void)
+{
+	hot_inode_item_cache = kmem_cache_create("hot_inode_item",
+			sizeof(struct hot_inode_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!hot_inode_item_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+/* init hot_range_item kmem cache */
+int __init hot_range_item_init(void)
+{
+	hot_range_item_cache = kmem_cache_create("hot_range_item",
+			sizeof(struct hot_range_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!hot_range_item_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void hot_inode_item_exit(void)
+{
+	if (hot_inode_item_cache)
+		kmem_cache_destroy(hot_inode_item_cache);
+}
+
+void hot_range_item_exit(void)
+{
+	if (hot_range_item_cache)
+		kmem_cache_destroy(hot_range_item_cache);
+}
+
+
+/* Initialize the inode tree */
+void hot_inode_tree_init(struct hot_inode_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
+
+/* Initialize the hot range tree tree */
+void hot_range_tree_init(struct hot_range_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
+
+/* Allocate a new hot_inode_item structure.  The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_inode_item() */
+struct hot_inode_item *alloc_hot_inode_item(unsigned long ino)
+{
+	struct hot_inode_item *he;
+	he = kmem_cache_alloc(hot_inode_item_cache, GFP_KERNEL | GFP_NOFS);
+	if (!he || IS_ERR(he))
+		return he;
+
+	atomic_set(&he->refs, 1);
+	he->in_tree = 0;
+	he->i_ino = ino;
+	he->heat_node = alloc_heat_hashlist_node(GFP_KERNEL | GFP_NOFS);
+	he->freq_data.avg_delta_reads = (u64) -1;
+	he->freq_data.avg_delta_writes = (u64) -1;
+	he->freq_data.nr_reads = 0;
+	he->freq_data.nr_writes = 0;
+	he->freq_data.flags = FREQ_DATA_TYPE_INODE;
+	hot_range_tree_init(&he->hot_range_tree);
+
+	spin_lock_init(&he->lock);
+
+	return he;
+}
+
+/* Allocate a new hot_range_item structure.  The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_range_item() */
+struct hot_range_item *alloc_hot_range_item(u64 start, u64 len)
+{
+	struct hot_range_item *hr;
+	hr = kmem_cache_alloc(hot_range_item_cache, GFP_KERNEL | GFP_NOFS);
+	if (!hr || IS_ERR(hr))
+		return hr;
+	atomic_set(&hr->refs, 1);
+	hr->in_tree = 0;
+	hr->start = start & RANGE_SIZE_MASK;
+	hr->len = len;
+	hr->heat_node = alloc_heat_hashlist_node(GFP_KERNEL | GFP_NOFS);
+	hr->heat_node->freq_data = &hr->freq_data;
+	hr->freq_data.avg_delta_reads = (u64) -1;
+	hr->freq_data.avg_delta_writes = (u64) -1;
+	hr->freq_data.nr_reads = 0;
+	hr->freq_data.nr_writes = 0;
+	hr->freq_data.flags = FREQ_DATA_TYPE_RANGE;
+
+	spin_lock_init(&hr->lock);
+
+	return hr;
+}
+
+/* Drops the reference out on hot_inode_item by one and free the structure
+ * if the reference count hits zero */
+void free_hot_inode_item(struct hot_inode_item *he)
+{
+	if (!he)
+		return;
+	if (atomic_dec_and_test(&he->refs)) {
+		WARN_ON(he->in_tree);
+		kmem_cache_free(hot_inode_item_cache, he);
+	}
+}
+
+/* Drops the reference out on hot_range_item by one and free the structure
+ * if the reference count hits zero */
+void free_hot_range_item(struct hot_range_item *hr)
+{
+	if (!hr)
+		return;
+	if (atomic_dec_and_test(&hr->refs)) {
+		WARN_ON(hr->in_tree);
+		kmem_cache_free(hot_range_item_cache, hr);
+	}
+}
+
+/* Frees the entire hot_inode_tree. Called by free_fs_root */
+void free_hot_inode_tree(struct btrfs_root *root)
+{
+	struct rb_node *node, *node2;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+
+	/* Free hot inode and range trees on fs root */
+	node = rb_first(&root->hot_inode_tree.map);
+
+	while (node) {
+		he = rb_entry(node, struct hot_inode_item,
+			rb_node);
+
+		node2 = rb_first(&he->hot_range_tree.map);
+
+		while (node2) {
+			hr = rb_entry(node2, struct hot_range_item,
+				rb_node);
+			remove_hot_range_item(&he->hot_range_tree, hr);
+			free_hot_range_item(hr);
+			node2 = rb_first(&he->hot_range_tree.map);
+		}
+
+		remove_hot_inode_item(&root->hot_inode_tree, he);
+		free_hot_inode_item(he);
+		node = rb_first(&root->hot_inode_tree.map);
+	}
+}
+
+static struct rb_node *tree_insert_inode_item(struct rb_root *root,
+					unsigned long inode_num,
+					struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_inode_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static u64 range_map_end(struct hot_range_item *hr)
+{
+	if (hr->start + hr->len < hr->start)
+		return (u64)-1;
+	return hr->start + hr->len;
+}
+
+static struct rb_node *tree_insert_range_item(struct rb_root *root,
+					      u64 start,
+					      struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+
+	/* walk tree to find insertion point */
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start >= range_map_end(entry))
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct hot_range_item, rb_node);
+	entry->in_tree = 1;
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+/* Add a hot_inode_item to a hot_inode_tree. If the tree already contains
+ * an item with the index given, return -EEXIST */
+int add_hot_inode_item(struct hot_inode_tree *tree,
+		       struct hot_inode_item *he)
+{
+	int ret = 0;
+	struct rb_node *rb;
+	struct hot_inode_item *exist;
+
+	exist = lookup_hot_inode_item(tree, he->i_ino);
+	if (exist) {
+		free_hot_inode_item(exist);
+		ret = -EEXIST;
+		goto out;
+	}
+	rb = tree_insert_inode_item(&tree->map, he->i_ino, &he->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+	atomic_inc(&he->refs);
+out:
+	return ret;
+}
+
+/* Add a hot_range_item to a hot_range_tree. If the tree already contains
+ * an item with the index given, return -EEXIST
+ * Also optionally aggressively merge ranges (currently disabled) */
+int add_hot_range_item(struct hot_range_tree *tree,
+		       struct hot_range_item *hr)
+{
+	int ret = 0;
+	struct rb_node *rb;
+	struct hot_range_item *exist;
+	/* struct hot_range_item *merge = NULL; */
+
+	exist = lookup_hot_range_item(tree, hr->start);
+	if (exist) {
+		free_hot_range_item(exist);
+		ret = -EEXIST;
+		goto out;
+	}
+	rb = tree_insert_range_item(&tree->map, hr->start, &hr->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	atomic_inc(&hr->refs);
+
+out:
+	return ret;
+}
+
+/* Lookup a hot_inode_item in the hot_inode_tree with the given index
+ * (inode_num) */
+struct hot_inode_item *lookup_hot_inode_item(struct hot_inode_tree *tree,
+					 unsigned long inode_num)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_inode_item *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_inode_item, rb_node);
+
+		if (inode_num < entry->i_ino)
+			p = &(*p)->rb_left;
+		else if (inode_num > entry->i_ino)
+			p = &(*p)->rb_right;
+		else {
+			atomic_inc(&entry->refs);
+			return entry;
+		}
+	}
+
+	return NULL;
+}
+
+/* Lookup a hot_range_item in a hot_range_tree with the given index
+ * (start, offset) */
+struct hot_range_item *lookup_hot_range_item(struct hot_range_tree *tree,
+					     u64 start)
+{
+	struct rb_node **p = &(tree->map.rb_node);
+	struct rb_node *parent = NULL;
+	struct hot_range_item *entry;
+
+	/* ensure start is on a range boundary */
+	start = start & RANGE_SIZE_MASK;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct hot_range_item, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start >= range_map_end(entry))
+			p = &(*p)->rb_right;
+		else {
+			atomic_inc(&entry->refs);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+int remove_hot_inode_item(struct hot_inode_tree *tree,
+			  struct hot_inode_item *he)
+{
+	int ret = 0;
+	rb_erase(&he->rb_node, &tree->map);
+	he->in_tree = 0;
+	return ret;
+}
+
+int remove_hot_range_item(struct hot_range_tree *tree,
+			  struct hot_range_item *hr)
+{
+	int ret = 0;
+	rb_erase(&hr->rb_node, &tree->map);
+	hr->in_tree = 0;
+	return ret;
+}
+
+/* main function to update access frequency from read/writepage(s) hooks */
+inline void btrfs_update_freqs(struct inode *inode, u64 start,
+	u64 len, int create)
+{
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
+
+	he = btrfs_update_inode_freq(btrfs_inode, create);
+
+	WARN_ON(!he || IS_ERR(he));
+
+	if (he && !IS_ERR(he)) {
+		hr = btrfs_update_range_freq(he, start, len,
+			create, btrfs_inode->root);
+		WARN_ON(!hr || IS_ERR(hr));
+
+
+		/*
+		 * drop refcounts on inode/range items:
+		 */
+
+		free_hot_inode_item(he);
+
+		if (hr && !IS_ERR(hr))
+			free_hot_range_item(hr);
+	}
+
+}
+
+/* Update inode frequency struct */
+struct hot_inode_item *btrfs_update_inode_freq(struct btrfs_inode *inode,
+					       int create)
+{
+	struct hot_inode_tree *hitree = &inode->root->hot_inode_tree;
+	struct hot_inode_item *he;
+	struct btrfs_root *root = inode->root;
+
+	read_lock(&hitree->lock);
+	he = lookup_hot_inode_item(hitree, inode->vfs_inode.i_ino);
+	read_unlock(&hitree->lock);
+
+	if (!he) {
+		he = alloc_hot_inode_item(inode->vfs_inode.i_ino);
+
+		if (!he || IS_ERR(he))
+			goto out;
+
+		write_lock(&hitree->lock);
+		add_hot_inode_item(hitree, he);
+		write_unlock(&hitree->lock);
+	}
+
+	spin_lock(&he->lock);
+	btrfs_update_freq(&he->freq_data, create);
+	/*
+	 * printk(KERN_DEBUG "btrfs_update_inode_freq avd_r: %llu,"
+	 *	" avd_w: %llu\n",
+	 *	he->freq_data.avg_delta_reads,
+	 *	he->freq_data.avg_delta_writes);
+	 */
+	spin_unlock(&he->lock);
+
+	/* will get its own lock(s) */
+	btrfs_update_heat_index(&he->freq_data, root);
+
+out:
+	return he;
+}
+
+/* Update range frequency struct */
+struct hot_range_item *btrfs_update_range_freq(struct hot_inode_item *he,
+					       u64 off, u64 len, int create,
+					       struct btrfs_root *root)
+{
+	struct hot_range_tree *hrtree = &he->hot_range_tree;
+	struct hot_range_item *hr = NULL;
+	u64 start_off = off & RANGE_SIZE_MASK;
+	u64 end_off = (off + len - 1) & RANGE_SIZE_MASK;
+	u64 cur;
+
+	/*
+	 * Align ranges on RANGE_SIZE boundary to prevent proliferation
+	 * of range structs
+	 */
+	for (cur = start_off; cur <= end_off; cur += RANGE_SIZE) {
+		read_lock(&hrtree->lock);
+		hr = lookup_hot_range_item(hrtree, cur);
+		read_unlock(&hrtree->lock);
+
+		if (!hr) {
+			hr = alloc_hot_range_item(cur, RANGE_SIZE);
+
+			if (!hr || IS_ERR(hr))
+				goto out;
+
+			write_lock(&hrtree->lock);
+			add_hot_range_item(hrtree, hr);
+			write_unlock(&hrtree->lock);
+		}
+
+		spin_lock(&hr->lock);
+		btrfs_update_freq(&hr->freq_data, create);
+		/*
+		 * printk(KERN_DEBUG "btrfs_update_range_freq avd_r: %llu,"
+		 *	" avd_w: %llu\n",
+		 *	he->freq_data.avg_delta_reads,
+		 *	he->freq_data.avg_delta_writes);
+		 */
+		spin_unlock(&hr->lock);
+
+
+		/* will get its own locks */
+		btrfs_update_heat_index(&hr->freq_data, root);
+	}
+out:
+	return hr;
+}
+
+/*
+ * This function does the actual work of updating the frequency numbers,
+ * whatever they turn out to be. BTRFS_FREQ_POWER determines how many atime
+ * deltas we keep track of (as a power of 2). So, setting it to anything above
+ * 16ish is probably overkill. Also, the higher the power, the more bits get
+ * right shifted out of the timestamp, reducing precision, so take note of that
+ * as well.
+ *
+ * The caller (which is probably btrfs_update_freq) should have already locked
+ * fdata's parent's spinlock.
+ */
+#define BTRFS_FREQ_POWER 4
+void btrfs_update_freq(struct btrfs_freq_data *fdata, int create)
+{
+	struct timespec old_atime;
+	struct timespec current_time;
+	struct timespec delta_ts;
+	u64 new_avg;
+	u64 new_delta;
+
+	if (unlikely(create)) {
+		old_atime = fdata->last_write_time;
+		fdata->nr_writes += 1;
+		new_avg = fdata->avg_delta_writes;
+	} else {
+		old_atime = fdata->last_read_time;
+		fdata->nr_reads += 1;
+		new_avg = fdata->avg_delta_reads;
+	}
+
+	current_time = current_kernel_time();
+	delta_ts = timespec_sub(current_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> BTRFS_FREQ_POWER;
+
+	new_avg = (new_avg << BTRFS_FREQ_POWER) - new_avg + new_delta;
+	new_avg = new_avg >> BTRFS_FREQ_POWER;
+
+	if (unlikely(create)) {
+		fdata->last_write_time = current_time;
+		fdata->avg_delta_writes = new_avg;
+	} else {
+		fdata->last_read_time = current_time;
+		fdata->avg_delta_reads = new_avg;
+	}
+
+}
+
+/*
+ * Get a new temperature and, if necessary, move the heat_node corresponding
+ * to this inode or range to the proper hashlist with the new temperature
+ */
+void btrfs_update_heat_index(struct btrfs_freq_data *fdata,
+			       struct btrfs_root *root)
+{
+	int temp = 0;
+	int moved = 0;
+	struct heat_hashlist_entry *buckets, *current_bucket = NULL;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+
+	if (fdata->flags & FREQ_DATA_TYPE_INODE) {
+		he = freq_data_get_he(fdata);
+		buckets = root->heat_inode_hl;
+
+		spin_lock(&he->lock);
+		temp = btrfs_get_temp(fdata);
+		spin_unlock(&he->lock);
+
+		if (he == NULL)
+			return;
+
+		if (he->heat_node->hlist == NULL) {
+			current_bucket = buckets +
+					temp;
+			moved = 1;
+		} else {
+			current_bucket = he->heat_node->hlist;
+			if (current_bucket->temperature != temp) {
+				write_lock(&current_bucket->rwlock);
+				hlist_del(&he->heat_node->hashnode);
+				write_unlock(&current_bucket->rwlock);
+				current_bucket = buckets + temp;
+				moved = 1;
+			}
+		}
+
+		if (moved) {
+			write_lock(&current_bucket->rwlock);
+			hlist_add_head(&he->heat_node->hashnode,
+				&current_bucket->hashhead);
+			he->heat_node->hlist = current_bucket;
+			write_unlock(&current_bucket->rwlock);
+		}
+
+	} else if (fdata->flags & FREQ_DATA_TYPE_RANGE) {
+		hr = freq_data_get_hr(fdata);
+		buckets = root->heat_range_hl;
+
+		spin_lock(&hr->lock);
+		temp = btrfs_get_temp(fdata);
+		spin_unlock(&hr->lock);
+
+		if (hr == NULL)
+			return;
+
+		if (hr->heat_node->hlist == NULL) {
+			current_bucket = buckets +
+					temp;
+			moved = 1;
+		} else {
+			current_bucket = hr->heat_node->hlist;
+			if (current_bucket->temperature != temp) {
+				write_lock(&current_bucket->rwlock);
+				hlist_del(&hr->heat_node->hashnode);
+				write_unlock(&current_bucket->rwlock);
+				current_bucket = buckets + temp;
+				moved = 1;
+			}
+		}
+
+		if (moved) {
+			write_lock(&current_bucket->rwlock);
+			hlist_add_head(&hr->heat_node->hashnode,
+				&current_bucket->hashhead);
+			hr->heat_node->hlist = current_bucket;
+			write_unlock(&current_bucket->rwlock);
+		}
+	}
+}
+
+/* Walk the hot_inode_tree, locking as necessary */
+struct hot_inode_item *find_next_hot_inode(struct btrfs_root *root,
+						  u64 objectid)
+{
+	struct rb_node *node;
+	struct rb_node *prev;
+	struct hot_inode_item *entry;
+
+	read_lock(&root->hot_inode_tree.lock);
+
+	node = root->hot_inode_tree.map.rb_node;
+	prev = NULL;
+	while (node) {
+		prev = node;
+		entry = rb_entry(node, struct hot_inode_item, rb_node);
+
+		if (objectid < entry->i_ino)
+			node = node->rb_left;
+		else if (objectid > entry->i_ino)
+			node = node->rb_right;
+		else
+			break;
+	}
+	if (!node) {
+		while (prev) {
+			entry = rb_entry(prev, struct hot_inode_item, rb_node);
+			if (objectid <= entry->i_ino) {
+				node = prev;
+				break;
+			}
+			prev = rb_next(prev);
+		}
+	}
+	if (node) {
+		entry = rb_entry(node, struct hot_inode_item, rb_node);
+		/* increase reference count to prevent pruning while
+		 * caller is using the hot_inode_item */
+		atomic_inc(&entry->refs);
+
+		read_unlock(&root->hot_inode_tree.lock);
+		return entry;
+	}
+
+	read_unlock(&root->hot_inode_tree.lock);
+	return NULL;
+}
+
diff --git a/fs/btrfs/hotdata_map.h b/fs/btrfs/hotdata_map.h
new file mode 100644
index 0000000..46ae1d6
--- /dev/null
+++ b/fs/btrfs/hotdata_map.h
@@ -0,0 +1,118 @@
+#ifndef __HOTDATAMAP__
+#define __HOTDATAMAP__
+
+#include <linux/rbtree.h>
+
+/* values for btrfs_freq_data flags */
+#define FREQ_DATA_TYPE_INODE 1		/* freq data struct is for an inode */
+#define FREQ_DATA_TYPE_RANGE (1 << 1)	/* freq data struct is for a range */
+#define FREQ_DATA_HEAT_HOT (1 << 2)	/* freq data struct is for hot data */
+					/* (not implemented) */
+#define RANGE_SIZE (1<<12)
+#define RANGE_SIZE_MASK (~((u64)(RANGE_SIZE - 1)))
+
+/* macros to wrap container_of()'s for hot data structs */
+#define freq_data_get_he(x) (struct hot_inode_item *) container_of(x, \
+					struct hot_inode_item, freq_data)
+#define freq_data_get_hr(x) (struct hot_range_item *) container_of(x, \
+					struct hot_range_item, freq_data)
+#define rb_node_get_he(x) (struct hot_inode_item *) container_of(x, \
+					struct hot_inode_item, rb_node)
+#define rb_node_get_hr(x) (struct hot_range_item *) container_of(x, \
+					struct hot_range_item, rb_node)
+
+/* A frequency data struct holds values that are used to
+ * determine temperature of files and file ranges. These structs
+ * are members of hot_inode_item and hot_range_item */
+struct btrfs_freq_data {
+	struct timespec last_read_time;
+	struct timespec last_write_time;
+	u32 nr_reads;
+	u32 nr_writes;
+	u64 avg_delta_reads;
+	u64 avg_delta_writes;
+	u8 flags;
+};
+
+/* A tree that sits on the fs_root */
+struct hot_inode_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
+/* A tree of ranges for each inode in the hot_inode_tree */
+struct hot_range_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	struct rb_node rb_node; /* node for hot_inode_tree rb_tree */
+	unsigned long i_ino; /* inode number, copied from vfs_inode */
+	struct hot_range_tree hot_range_tree; /* tree of ranges in this
+						 inode */
+	struct btrfs_freq_data freq_data; /* frequency data for this inode */
+	spinlock_t lock; /* protects freq_data, i_no, in_tree */
+	atomic_t refs; /* prevents kfree */
+	u8 in_tree; /* used to check for errors in ref counting */
+	struct heat_hashlist_node *heat_node; /* hashlist node for this
+						 inode */
+};
+
+/* An item representing a range inside of an inode whose frequency
+ * is being tracked */
+struct hot_range_item {
+	struct rb_node rb_node; /* node for hot_range_tree rb_tree */
+	u64 start; /* starting offset of this range */
+	u64 len; /* length of this range */
+	struct btrfs_freq_data freq_data; /* frequency data for this range */
+	spinlock_t lock; /* protects freq_data, start, len, in_tree */
+	atomic_t refs; /* prevents kfree */
+	u8 in_tree; /* used to check for errors in ref counting */
+	struct heat_hashlist_node *heat_node; /* hashlist node for this
+						 range */
+};
+
+struct btrfs_root;
+struct inode;
+
+void hot_inode_tree_init(struct hot_inode_tree *tree);
+void hot_range_tree_init(struct hot_range_tree *tree);
+
+struct hot_range_item *lookup_hot_range_item(struct hot_range_tree *tree,
+					    u64 start);
+
+struct hot_inode_item *lookup_hot_inode_item(struct hot_inode_tree *tree,
+					    unsigned long inode_num);
+
+int add_hot_inode_item(struct hot_inode_tree *tree,
+		       struct hot_inode_item *he);
+int add_hot_range_item(struct hot_range_tree *tree,
+		       struct hot_range_item *hr);
+
+int remove_hot_inode_item(struct hot_inode_tree *tree,
+			struct hot_inode_item *he);
+int remove_hot_range_item(struct hot_range_tree *tree,
+			 struct hot_range_item *hr);
+
+struct hot_inode_item *alloc_hot_inode_item(unsigned long ino);
+struct hot_range_item *alloc_hot_range_item(u64 start, u64 len);
+
+void free_hot_inode_item(struct hot_inode_item *he);
+void free_hot_range_item(struct hot_range_item *hr);
+void free_hot_inode_tree(struct btrfs_root *root);
+
+int __init hot_inode_item_init(void);
+int __init hot_range_item_init(void);
+
+void hot_inode_item_exit(void);
+void hot_range_item_exit(void);
+
+struct hot_inode_item *find_next_hot_inode(struct btrfs_root *root,
+						  u64 objectid);
+void btrfs_update_freq(struct btrfs_freq_data *fdata, int create);
+void btrfs_update_freqs(struct inode *inode, u64 start, u64 len,
+	int create);
+
+#endif
-- 
1.7.1
