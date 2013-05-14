Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34724 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3ENA66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:58:58 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:58:58 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 01/12] VFS hot tracking: introduce some data structures
Date: Tue, 14 May 2013 08:59:33 +0800
Message-Id: <1368493184-5939-2-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  One root structure hot_info is defined, is hooked
up in super_block, and will be used to hold radix tree
root, hash list root and some other information, etc.
  Adds hot_inode_tree struct to keep track of
frequently accessed files, and be keyed by {inode, offset}.
Trees contain hot_inode_items representing those files
and ranges.
  Having these trees means that vfs can quickly determine the
temperature of some data by doing some calculations on the
hot_freq_data struct that hangs off of the tree item.
  Define two items hot_inode_item and hot_range_item,
one of them represents one tracked file
to keep track of its access frequency and the tree of
ranges in this file, while the latter represents
a file range of one inode.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile                  |   2 +-
 fs/dcache.c                  |   2 +
 fs/hot_tracking.c            | 209 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |  17 ++++
 include/linux/fs.h           |   4 +
 include/linux/hot_tracking.h | 103 +++++++++++++++++++++
 6 files changed, 336 insertions(+), 1 deletion(-)
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

diff --git a/fs/Makefile b/fs/Makefile
index 199c880..d0fc704 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -13,7 +13,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o hot_tracking.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..9d7c2af 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -37,6 +37,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -3094,4 +3095,5 @@ void __init vfs_caches_init(unsigned long mempages)
 	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
+	hot_cache_init();
 }
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
new file mode 100644
index 0000000..6bf4229
--- /dev/null
+++ b/fs/hot_tracking.c
@@ -0,0 +1,209 @@
+/*
+ * fs/hot_tracking.c
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/list_sort.h>
+#include <linux/limits.h>
+#include "hot_tracking.h"
+
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cachep __read_mostly;
+static struct kmem_cache *hot_range_item_cachep __read_mostly;
+
+static void hot_inode_item_free(struct kref *kref);
+
+static void hot_comm_item_free_cb(struct rcu_head *head)
+{
+	struct hot_comm_item *ci = container_of(head,
+				struct hot_comm_item, c_rcu);
+
+	if (ci->hot_freq_data.flags == TYPE_RANGE) {
+		struct hot_range_item *hr = container_of(ci,
+				struct hot_range_item, hot_range);
+		kmem_cache_free(hot_range_item_cachep, hr);
+	} else {
+		struct hot_inode_item *he = container_of(ci,
+				struct hot_inode_item, hot_inode);
+		kmem_cache_free(hot_inode_item_cachep, he);
+	}
+}
+
+static void hot_range_item_free(struct kref *kref)
+{
+	struct hot_comm_item *ci = container_of(kref,
+		struct hot_comm_item, refs);
+	struct hot_range_item *hr = container_of(ci,
+		struct hot_range_item, hot_range);
+
+	hr->hot_inode = NULL;
+
+	call_rcu(&hr->hot_range.c_rcu, hot_comm_item_free_cb);
+}
+
+/*
+ * Drops the reference out on hot_comm_item by one
+ * and free the structure if the reference count hits zero
+ */
+void hot_comm_item_put(struct hot_comm_item *ci)
+{
+	kref_put(&ci->refs, (ci->hot_freq_data.flags == TYPE_RANGE) ?
+			hot_range_item_free : hot_inode_item_free);
+}
+EXPORT_SYMBOL_GPL(hot_comm_item_put);
+
+static void hot_comm_item_unlink(struct hot_info *root,
+				struct hot_comm_item *ci)
+{
+	if (!test_and_set_bit(HOT_DELETING, &ci->delete_flag)) {
+		hot_comm_item_put(ci);
+	}
+}
+
+/*
+ * Frees the entire hot_range_tree.
+ */
+static void hot_range_tree_free(struct hot_inode_item *he)
+{
+	struct hot_info *root = he->hot_root;
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+
+	/* Free hot inode and range trees on fs root */
+	rcu_read_lock();
+	node = rb_first(&he->hot_range_tree);
+	while (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		node = rb_next(node);
+		hot_comm_item_unlink(root, ci);
+	}
+	rcu_read_unlock();
+
+}
+
+static void hot_inode_item_free(struct kref *kref)
+{
+	struct hot_comm_item *ci = container_of(kref,
+			struct hot_comm_item, refs);
+	struct hot_inode_item *he = container_of(ci,
+			struct hot_inode_item, hot_inode);
+
+	hot_range_tree_free(he);
+	he->hot_root = NULL;
+
+	call_rcu(&he->hot_inode.c_rcu, hot_comm_item_free_cb);
+}
+
+/*
+ * Initialize kmem cache for hot_inode_item and hot_range_item.
+ */
+void __init hot_cache_init(void)
+{
+	hot_inode_item_cachep = kmem_cache_create("hot_inode_item",
+			sizeof(struct hot_inode_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			NULL);
+	if (!hot_inode_item_cachep)
+		return;
+
+	hot_range_item_cachep = kmem_cache_create("hot_range_item",
+			sizeof(struct hot_range_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			NULL);
+	if (!hot_range_item_cachep)
+		kmem_cache_destroy(hot_inode_item_cachep);
+}
+EXPORT_SYMBOL_GPL(hot_cache_init);
+
+static struct hot_info *hot_tree_init(struct super_block *sb)
+{
+	struct hot_info *root;
+	int i, j;
+
+	root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
+	if (!root) {
+		printk(KERN_ERR "%s: Failed to malloc memory for "
+				"hot_info\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	root->hot_inode_tree = RB_ROOT;
+	spin_lock_init(&root->t_lock);
+	spin_lock_init(&root->m_lock);
+
+	for (i = 0; i < MAP_SIZE; i++) {
+		for (j = 0; j < MAX_TYPES; j++)
+			INIT_LIST_HEAD(&root->hot_map[j][i]);
+	}
+
+	return root;
+}
+
+/*
+ * Frees the entire hot tree.
+ */
+static void hot_tree_exit(struct hot_info *root)
+{
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+
+	rcu_read_lock();
+	node = rb_first(&root->hot_inode_tree);
+	while (node) {
+		struct hot_inode_item *he;
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		he = container_of(ci, struct hot_inode_item, hot_inode);
+		node = rb_next(node);
+		hot_comm_item_unlink(root, &he->hot_inode);
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * Initialize the data structures for hot tracking.
+ * This function will be called by *_fill_super()
+ * when filesystem is mounted.
+ */
+int hot_track_init(struct super_block *sb)
+{
+	struct hot_info *root;
+
+	root = hot_tree_init(sb);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	sb->s_hot_root = root;
+
+	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hot_track_init);
+
+/*
+ * This function will be called by *_put_super()
+ * when filesystem is umounted, or also by *_fill_super()
+ * in some exceptional cases.
+ */
+void hot_track_exit(struct super_block *sb)
+{
+	struct hot_info *root = sb->s_hot_root;
+
+	hot_tree_exit(root);
+	sb->s_hot_root = NULL;
+	kfree(root);
+}
+EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
new file mode 100644
index 0000000..a2ee95f
--- /dev/null
+++ b/fs/hot_tracking.h
@@ -0,0 +1,17 @@
+/*
+ * fs/hot_tracking.h
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_TRACKING__
+#define __HOT_TRACKING__
+
+#include <linux/hot_tracking.h>
+
+#endif /* __HOT_TRACKING__ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 43db02e..ee2c54f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -27,6 +27,7 @@
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1322,6 +1323,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking*/
+	struct hot_info *s_hot_root;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
new file mode 100644
index 0000000..fa99439
--- /dev/null
+++ b/include/linux/hot_tracking.h
@@ -0,0 +1,103 @@
+/*
+ *  include/linux/hot_tracking.h
+ *
+ * This file has definitions for VFS hot data tracking
+ * structures etc.
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_HOTTRACK_H
+#define _LINUX_HOTTRACK_H
+
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+#include <linux/rbtree.h>
+#include <linux/kref.h>
+#include <linux/fs.h>
+
+#define MAP_BITS 8
+#define MAP_SIZE (1 << MAP_BITS)
+
+/* values for hot_freq_data flags */
+enum {
+	TYPE_INODE = 0,
+	TYPE_RANGE,
+	MAX_TYPES
+};
+
+enum {
+	HOT_DELETING,
+};
+
+/*
+ * A frequency data struct holds values that are used to
+ * determine temperature of files and file ranges. These structs
+ * are members of hot_inode_item and hot_range_item
+ */
+struct hot_freq_data {
+	struct timespec last_read_time;
+	struct timespec last_write_time;
+	u32 nr_reads;
+	u32 nr_writes;
+	u64 avg_delta_reads;
+	u64 avg_delta_writes;
+	u32 flags;
+	u32 last_temp;
+};
+
+/* The common info for both following structures */
+struct hot_comm_item {
+	struct hot_freq_data hot_freq_data;	/* frequency data */
+	struct kref refs;
+	struct rb_node rb_node;			/* rbtree index */
+	unsigned long delete_flag;
+	struct rcu_head c_rcu;
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	struct hot_comm_item hot_inode; /* node in hot_inode_tree */
+	struct rb_root hot_range_tree;	/* tree of ranges */
+	spinlock_t i_lock;		/* protect above tree */
+};
+
+/*
+ * An item representing a range inside of
+ * an inode whose frequency is being tracked
+ */
+struct hot_range_item {
+	struct hot_comm_item hot_range;
+	struct hot_inode_item *hot_inode;	/* associated hot_inode_item */
+};
+
+struct hot_info {
+	struct rb_root hot_inode_tree;
+	spinlock_t t_lock;				/* protect above tree */
+	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
+	spinlock_t m_lock;
+};
+
+extern void __init hot_cache_init(void);
+extern int hot_track_init(struct super_block *sb);
+extern void hot_track_exit(struct super_block *sb);
+extern void hot_comm_item_put(struct hot_comm_item *ci);
+
+static inline u64 hot_shift(u64 counter, u32 bits, bool dir)
+{
+	if (dir)
+		return counter << bits;
+	else
+		return counter >> bits;
+}
+
+#endif /* __KERNEL__ */
+
+#endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.11.7

