Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48317 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab3ENA7G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:06 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 20:59:05 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 02/12] VFS hot tracking: add i/o freq tracking hooks
Date: Tue, 14 May 2013 08:59:34 +0800
Message-Id: <1368493184-5939-3-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add i/o freq tracking hooks in real read/write code paths
which include read_pages(), do_writepages(), do_generic_file_read(),
and __blockdev_direct_IO().
  Currently whole FS has one RB tree to track i/o freqs for
all inodes which had real disk i/o, while every inode has its
own one RB tree to track i/o freqs for all of its extents.
  When real disk i/o for the inode are done, its own i/o freq will
be created or updated in the RB tree per FS, and the i/o freq for
all of its extents will also be done in the RB-tree per inode.
  Also, Each of the two structures hot_inode_item and hot_range_item
contains a hot_freq_data struct with its frequency of access metrics
(number of {reads, writes}, last {read,write} time, frequency of
{reads,writes}).
  Also, each hot_inode_item contains one hot_range_tree
struct which is keyed by {inode, offset, length}
and used to keep track of all the ranges in this file.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/direct-io.c               |   5 +
 fs/hot_tracking.c            | 284 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   4 +
 fs/namei.c                   |   2 +
 include/linux/hot_tracking.h |  17 +++
 mm/filemap.c                 |   6 +
 mm/page-writeback.c          |  12 ++
 mm/readahead.c               |   6 +
 8 files changed, 336 insertions(+)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7ab90f5..6cb0598 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -38,6 +38,7 @@
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
 #include <linux/aio.h>
+#include "hot_tracking.h"
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
@@ -1295,6 +1296,10 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
+	/* Hot data tracking */
+	hot_update_freqs(inode, offset, iov_length(iov, nr_segs),
+			rw & WRITE);
+
 	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
 				     nr_segs, get_block, end_io,
 				     submit_io, flags);
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 6bf4229..cc899f4 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -26,6 +26,26 @@ static struct kmem_cache *hot_range_item_cachep __read_mostly;
 
 static void hot_inode_item_free(struct kref *kref);
 
+static void hot_comm_item_init(struct hot_comm_item *ci, int type)
+{
+	kref_init(&ci->refs);
+	clear_bit(HOT_DELETING, &ci->delete_flag);
+	memset(&ci->hot_freq_data, 0, sizeof(struct hot_freq_data));
+	ci->hot_freq_data.avg_delta_reads = (u64) -1;
+	ci->hot_freq_data.avg_delta_writes = (u64) -1;
+	ci->hot_freq_data.flags = type;
+}
+
+static void hot_range_item_init(struct hot_range_item *hr,
+			struct hot_inode_item *he, loff_t start)
+{
+	hr->start = start;
+	hr->len = hot_shift(1, RANGE_BITS, true);
+	hr->hot_inode = he;
+	hr->storage_type = -1;
+	hot_comm_item_init(&hr->hot_range, TYPE_RANGE);
+}
+
 static void hot_comm_item_free_cb(struct rcu_head *head)
 {
 	struct hot_comm_item *ci = container_of(head,
@@ -65,10 +85,27 @@ void hot_comm_item_put(struct hot_comm_item *ci)
 }
 EXPORT_SYMBOL_GPL(hot_comm_item_put);
 
+/*
+ * root->t_lock or he->i_lock is acquired in this function
+ */
 static void hot_comm_item_unlink(struct hot_info *root,
 				struct hot_comm_item *ci)
 {
 	if (!test_and_set_bit(HOT_DELETING, &ci->delete_flag)) {
+		if (ci->hot_freq_data.flags == TYPE_RANGE) {
+			struct hot_range_item *hr = container_of(ci,
+					struct hot_range_item, hot_range);
+			struct hot_inode_item *he = hr->hot_inode;
+
+			spin_lock(&he->i_lock);
+			rb_erase(&ci->rb_node, &he->hot_range_tree);
+			spin_unlock(&he->i_lock);
+		} else {
+			spin_lock(&root->t_lock);
+			rb_erase(&ci->rb_node, &root->hot_inode_tree);
+			spin_unlock(&root->t_lock);
+		}
+
 		hot_comm_item_put(ci);
 	}
 }
@@ -94,6 +131,15 @@ static void hot_range_tree_free(struct hot_inode_item *he)
 
 }
 
+static void hot_inode_item_init(struct hot_inode_item *he,
+			struct hot_info *hot_root, u64 ino)
+{
+	he->i_ino = ino;
+	he->hot_root = hot_root;
+	spin_lock_init(&he->i_lock);
+	hot_comm_item_init(&he->hot_inode, TYPE_INODE);
+}
+
 static void hot_inode_item_free(struct kref *kref)
 {
 	struct hot_comm_item *ci = container_of(kref,
@@ -107,6 +153,195 @@ static void hot_inode_item_free(struct kref *kref)
 	call_rcu(&he->hot_inode.c_rcu, hot_comm_item_free_cb);
 }
 
+/* root->t_lock is acquired in this function. */
+struct hot_inode_item
+*hot_inode_item_lookup(struct hot_info *root, u64 ino, int alloc)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *he, *he_new = NULL;
+
+	/* walk tree to find insertion point */
+redo:
+	spin_lock(&root->t_lock);
+	p = &root->hot_inode_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		ci = rb_entry(parent, struct hot_comm_item, rb_node);
+		he = container_of(ci, struct hot_inode_item, hot_inode);
+		if (ino < he->i_ino)
+			p = &(*p)->rb_left;
+		else if (ino > he->i_ino)
+			p = &(*p)->rb_right;
+		else {
+			hot_comm_item_get(&he->hot_inode);
+			spin_unlock(&root->t_lock);
+			if (he_new)
+				/*
+				 * Lost the race. Somebody else inserted
+				 * the item for the inode. Free the
+				 * newly allocated item.
+				 */
+				kmem_cache_free(hot_inode_item_cachep, he_new);
+
+			if (test_bit(HOT_DELETING, &he->hot_inode.delete_flag))
+				return ERR_PTR(-ENOENT);
+
+			return he;
+		}
+	}
+
+	if (he_new) {
+		rb_link_node(&he_new->hot_inode.rb_node, parent, p);
+		rb_insert_color(&he_new->hot_inode.rb_node,
+				&root->hot_inode_tree);
+		hot_comm_item_get(&he_new->hot_inode);
+		spin_unlock(&root->t_lock);
+		return he_new;
+	}
+	spin_unlock(&root->t_lock);
+
+	if (!alloc)
+		return ERR_PTR(-ENOENT);
+
+	he_new = kmem_cache_zalloc(hot_inode_item_cachep, GFP_NOFS);
+	if (!he_new)
+		return ERR_PTR(-ENOMEM);
+
+	hot_inode_item_init(he_new, root, ino);
+
+	goto redo;
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_lookup);
+
+void hot_inode_item_delete(struct inode *inode)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+
+	if (!root || !S_ISREG(inode->i_mode))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino, 0);
+	if (IS_ERR(he))
+		return;
+
+	hot_comm_item_put(&he->hot_inode); /* for lookup */
+	hot_comm_item_unlink(root, &he->hot_inode);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_delete);
+
+/* he->i_lock is acquired in this function. */
+struct hot_range_item
+*hot_range_item_lookup(struct hot_inode_item *he, loff_t start, int alloc)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct hot_comm_item *ci;
+	struct hot_range_item *hr, *hr_new = NULL;
+
+	start = hot_shift(start, RANGE_BITS, true);
+
+	/* walk tree to find insertion point */
+redo:
+	spin_lock(&he->i_lock);
+	p = &he->hot_range_tree.rb_node;
+	while (*p) {
+		parent = *p;
+		ci = rb_entry(parent, struct hot_comm_item, rb_node);
+		hr = container_of(ci, struct hot_range_item, hot_range);
+		if (start < hr->start)
+			p = &(*p)->rb_left;
+		else if (start > (hr->start + hr->len - 1))
+			p = &(*p)->rb_right;
+		else {
+			hot_comm_item_get(&hr->hot_range);
+			spin_unlock(&he->i_lock);
+			if(hr_new)
+				/*
+				 * Lost the race. Somebody else inserted
+				 * the item for the range. Free the
+				 * newly allocated item.
+				 */
+				kmem_cache_free(hot_range_item_cachep, hr_new);
+
+			if (test_bit(HOT_DELETING, &hr->hot_range.delete_flag))
+				return ERR_PTR(-ENOENT);
+
+			return hr;
+		}
+	}
+
+	if (hr_new) {
+		rb_link_node(&hr_new->hot_range.rb_node, parent, p);
+		rb_insert_color(&hr_new->hot_range.rb_node,
+				&he->hot_range_tree);
+		hot_comm_item_get(&hr_new->hot_range);
+		spin_unlock(&he->i_lock);
+		return hr_new;
+	}
+	spin_unlock(&he->i_lock);
+
+	if (!alloc)
+		return ERR_PTR(-ENOENT);
+
+	hr_new = kmem_cache_zalloc(hot_range_item_cachep, GFP_NOFS);
+	if (!hr_new)
+		return ERR_PTR(-ENOMEM);
+
+	hot_range_item_init(hr_new, he, start);
+
+	goto redo;
+}
+EXPORT_SYMBOL_GPL(hot_range_item_lookup);
+
+/*
+ * This function does the actual work of updating
+ * the frequency numbers.
+ *
+ * avg_delta_{reads,writes} are indeed a kind of simple moving
+ * average of the time difference between each of the last
+ * 2^(FREQ_POWER) reads/writes. If there have not yet been that
+ * many reads or writes, it's likely that the values will be very
+ * large; They are initialized to the largest possible value for the
+ * data type. Simply, we don't want a few fast access to a file to
+ * automatically make it appear very hot.
+ */
+static void hot_freq_calc(struct timespec old_atime,
+		struct timespec cur_time, u64 *avg)
+{
+	struct timespec delta_ts;
+	u64 new_delta;
+
+	delta_ts = timespec_sub(cur_time, old_atime);
+	new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
+
+	*avg = (*avg << FREQ_POWER) - *avg + new_delta;
+	*avg = *avg >> FREQ_POWER;
+}
+
+static void hot_freq_update(struct hot_info *root,
+		struct hot_comm_item *ci, bool write)
+{
+	struct timespec cur_time = current_kernel_time();
+	struct hot_freq_data *freq_data = &ci->hot_freq_data;
+
+	if (write) {
+		freq_data->nr_writes += 1;
+		hot_freq_calc(freq_data->last_write_time,
+				cur_time,
+				&freq_data->avg_delta_writes);
+		freq_data->last_write_time = cur_time;
+	} else {
+		freq_data->nr_reads += 1;
+		hot_freq_calc(freq_data->last_read_time,
+				cur_time,
+				&freq_data->avg_delta_reads);
+		freq_data->last_read_time = cur_time;
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -128,6 +363,55 @@ void __init hot_cache_init(void)
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
+/*
+ * Main function to update i/o access frequencies, and it will be called
+ * from read/writepages() hooks, which are read_pages(), do_writepages(),
+ * do_generic_file_read(), and __blockdev_direct_IO().
+ */
+void hot_update_freqs(struct inode *inode, loff_t start,
+			size_t len, int rw)
+{
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u64 range_size;
+	loff_t cur, end;
+
+	if (!root || (len == 0) || !S_ISREG(inode->i_mode))
+		return;
+
+	he = hot_inode_item_lookup(root, inode->i_ino, 1);
+	if (IS_ERR(he))
+		return;
+
+	hot_freq_update(root, &he->hot_inode, rw);
+
+	/*
+	 * Align ranges on range size boundary
+	 * to prevent proliferation of range structs
+	 */
+	range_size  = hot_shift(1, RANGE_BITS, true);
+	end = hot_shift((start + len + range_size - 1),
+			RANGE_BITS, false);
+	cur = hot_shift(start, RANGE_BITS, false);
+	for (; cur < end; cur++) {
+		hr = hot_range_item_lookup(he, cur, 1);
+		if (IS_ERR(hr)) {
+			WARN(1, "hot_range_item_lookup returns %ld\n",
+				PTR_ERR(hr));
+			hot_comm_item_put(&he->hot_inode);
+			return;
+		}
+
+		hot_freq_update(root, &hr->hot_range, rw);
+
+		hot_comm_item_put(&hr->hot_range);
+	}
+
+	hot_comm_item_put(&he->hot_inode);
+}
+EXPORT_SYMBOL_GPL(hot_update_freqs);
+
 static struct hot_info *hot_tree_init(struct super_block *sb)
 {
 	struct hot_info *root;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index a2ee95f..bb4cb16 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -14,4 +14,8 @@
 
 #include <linux/hot_tracking.h>
 
+/* size of sub-file ranges */
+#define RANGE_BITS 20
+#define FREQ_POWER 4
+
 #endif /* __HOT_TRACKING__ */
diff --git a/fs/namei.c b/fs/namei.c
index 85e40d1..2eec542 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3394,6 +3394,8 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (!dir->i_op->unlink)
 		return -EPERM;
 
+	hot_inode_item_delete(dentry->d_inode);
+
 	mutex_lock(&dentry->d_inode->i_mutex);
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index fa99439..3c0cf57 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -67,6 +67,8 @@ struct hot_inode_item {
 	struct hot_comm_item hot_inode; /* node in hot_inode_tree */
 	struct rb_root hot_range_tree;	/* tree of ranges */
 	spinlock_t i_lock;		/* protect above tree */
+	struct hot_info *hot_root;	/* associated hot_info */
+	u64 i_ino;			/* inode number from inode */
 };
 
 /*
@@ -76,6 +78,9 @@ struct hot_inode_item {
 struct hot_range_item {
 	struct hot_comm_item hot_range;
 	struct hot_inode_item *hot_inode;	/* associated hot_inode_item */
+	loff_t start;				/* offset in bytes */
+	size_t len;				/* length in bytes */
+	int storage_type;			/* type of storage */
 };
 
 struct hot_info {
@@ -89,6 +94,13 @@ extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
 extern void hot_comm_item_put(struct hot_comm_item *ci);
+extern void hot_update_freqs(struct inode *inode, loff_t start,
+				size_t len, int rw);
+extern struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root,
+						u64 ino, int alloc);
+extern struct hot_range_item *hot_range_item_lookup(struct hot_inode_item *he,
+						loff_t start, int alloc);
+extern void hot_inode_item_delete(struct inode *inode);
 
 static inline u64 hot_shift(u64 counter, u32 bits, bool dir)
 {
@@ -98,6 +110,11 @@ static inline u64 hot_shift(u64 counter, u32 bits, bool dir)
 		return counter >> bits;
 }
 
+static inline void hot_comm_item_get(struct hot_comm_item *ci)
+{
+	kref_get(&ci->refs);
+}
+
 #endif /* __KERNEL__ */
 
 #endif  /* _LINUX_HOTTRACK_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index 7905fe7..eb64c49 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1242,6 +1243,11 @@ readpage:
 		 * PG_error will be set again if readpage fails.
 		 */
 		ClearPageError(page);
+
+		/* Hot data tracking */
+		hot_update_freqs(inode, (loff_t)page->index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, 0);
+
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 4514ad7..4bbca3a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -36,6 +36,7 @@
 #include <linux/pagevec.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
+#include <linux/hot_tracking.h>
 #include <trace/events/writeback.h>
 
 /*
@@ -1921,13 +1922,24 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	loff_t start = 0;
+	size_t count = 0;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+
+	start = mapping->writeback_index << PAGE_CACHE_SHIFT;
+	count = wbc->nr_to_write;
+
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/* Hot data tracking */
+	hot_update_freqs(mapping->host, start,
+			(count - wbc->nr_to_write) * PAGE_CACHE_SIZE, 1);
+
 	return ret;
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index daed28d..901396b 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/hot_tracking.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -115,6 +116,11 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 	unsigned page_idx;
 	int ret;
 
+	/* Hot data tracking */
+	hot_update_freqs(mapping->host,
+			list_to_page(pages)->index << PAGE_CACHE_SHIFT,
+			(size_t)nr_pages * PAGE_CACHE_SIZE, 0);
+
 	blk_start_plug(&plug);
 
 	if (mapping->a_ops->readpages) {
-- 
1.7.11.7

