From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH][RFC] change how we account for free space
Date: Fri, 8 Aug 2008 16:30:33 -0400
Message-ID: <20080808203033.GA20416@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This thing doesn't work, I'm mostly just throwing it out here to make sure I'm
taking this in the right direction.  I've replaced the extent io tree for free
space with two rb trees that are indexed via bytenr and size.  ATM the only
thing that really matters is the bytenr rb tree, but I'm sure once this is
completely done there will be some use for the size indexed rb tree.  Again this
is just what I have so far, to just make sure that I'm not making some big
mistake.  Thanks much,

Josef

diff -r 401378fbac2a Makefile
--- a/Makefile	Fri Aug 08 22:53:31 2008 -0400
+++ b/Makefile	Fri Aug 08 23:16:45 2008 -0400
@@ -7,7 +7,7 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   ref-cache.o
+	   ref-cache.o free-space-cache.o
 
 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff -r 401378fbac2a ctree.h
--- a/ctree.h	Fri Aug 08 22:53:31 2008 -0400
+++ b/ctree.h	Fri Aug 08 23:16:45 2008 -0400
@@ -485,10 +485,22 @@ struct btrfs_space_info {
 	struct list_head list;
 };
 
+struct btrfs_free_space {
+	struct rb_node size_index;
+	struct rb_node bytenr_index;
+	struct list_head list;
+	u64 bytenr;
+	u64 size;
+};
+
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	struct btrfs_space_info *space_info;
+	struct rb_root free_space_size;	/* free space indexed by size */
+	struct rb_root free_space_bytenr; /* free space indexed by start
+					     byte */
+	struct list_head free_space_list; /* list of free space for freeing */
 	spinlock_t lock;
 	u64 pinned;
 	u64 flags;
@@ -507,7 +519,6 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct radix_tree_root fs_roots_radix;
 
-	struct extent_io_tree free_space_cache;
 	struct extent_io_tree block_group_cache;
 	struct extent_io_tree pinned_extents;
 	struct extent_io_tree pending_del;
@@ -1743,4 +1754,16 @@ int btrfs_check_acl(struct inode *inode,
 int btrfs_check_acl(struct inode *inode, int mask);
 int btrfs_init_acl(struct inode *inode, struct inode *dir);
 int btrfs_acl_chmod(struct inode *inode);
+
+/* free-space-cache.c */
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 bytenr, u64 size);
+int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			    u64 bytenr, u64 size);
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
+				   *block_group);
+struct btrfs_free_space *btrfs_find_free_space_start(struct
+						     btrfs_block_group_cache
+						     *block_group, u64 bytenr,
+						     u64 size);
 #endif
diff -r 401378fbac2a disk-io.c
--- a/disk-io.c	Fri Aug 08 22:53:31 2008 -0400
+++ b/disk-io.c	Fri Aug 08 23:16:45 2008 -0400
@@ -1284,8 +1284,6 @@ struct btrfs_root *open_ctree(struct sup
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
-	extent_io_tree_init(&fs_info->free_space_cache,
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	extent_io_tree_init(&fs_info->block_group_cache,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	extent_io_tree_init(&fs_info->pinned_extents,
diff -r 401378fbac2a extent-tree.c
--- a/extent-tree.c	Fri Aug 08 22:53:31 2008 -0400
+++ b/extent-tree.c	Fri Aug 08 23:16:45 2008 -0400
@@ -68,10 +68,9 @@ static int cache_block_group(struct btrf
 	int ret = 0;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct extent_io_tree *free_space_cache;
 	int slot;
 	u64 last = 0;
-	u64 hole_size;
+	u64 size;
 	u64 first_free;
 	int found = 0;
 
@@ -79,7 +78,6 @@ static int cache_block_group(struct btrf
 		return 0;
 
 	root = root->fs_info->extent_root;
-	free_space_cache = &root->fs_info->free_space_cache;
 
 	if (block_group->cached)
 		return 0;
@@ -139,10 +137,11 @@ static int cache_block_group(struct btrf
 				found = 1;
 			}
 			if (key.objectid > last) {
-				hole_size = key.objectid - last;
-				set_extent_dirty(free_space_cache, last,
-						 last + hole_size - 1,
-						 GFP_NOFS);
+				size = key.objectid - last;
+				ret = btrfs_add_free_space(block_group, last,
+							   size);
+				if (ret)
+					goto err;
 			}
 			last = key.objectid + key.offset;
 		}
@@ -154,10 +153,11 @@ next:
 		last = first_free;
 	if (block_group->key.objectid +
 	    block_group->key.offset > last) {
-		hole_size = block_group->key.objectid +
+		size = block_group->key.objectid +
 			block_group->key.offset - last;
-		set_extent_dirty(free_space_cache, last,
-				 last + hole_size - 1, GFP_NOFS);
+		ret = btrfs_add_free_space(block_group, last, size);
+		if (ret)
+			goto err;
 	}
 	block_group->cached = 1;
 	ret = 0;
@@ -238,10 +238,8 @@ static int noinline find_search_start(st
 {
 	int ret;
 	struct btrfs_block_group_cache *cache = *cache_ret;
-	struct extent_io_tree *free_space_cache;
-	struct extent_state *state;
+	struct btrfs_free_space *info = NULL;
 	u64 last;
-	u64 start = 0;
 	u64 cache_miss = 0;
 	u64 total_fs_bytes;
 	u64 search_start = *start_ret;
@@ -249,21 +247,25 @@ static int noinline find_search_start(st
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
-	free_space_cache = &root->fs_info->free_space_cache;
 
 	if (!cache)
 		goto out;
 
 again:
 	ret = cache_block_group(root, cache);
-	if (ret) {
+	if (ret)
 		goto out;
-	}
 
 	last = max(search_start, cache->key.objectid);
 	if (!block_group_bits(cache, data) || cache->ro)
 		goto new_group;
 
+	info = btrfs_find_free_space_start(cache, last, num);
+	if (info) {
+		*start_ret = info->bytenr;
+		return 0;
+	}
+#if 0
 	spin_lock_irq(&free_space_cache->lock);
 	state = find_first_extent_bit_state(free_space_cache, last, EXTENT_DIRTY);
 	while(1) {
@@ -294,6 +296,7 @@ again:
 		*start_ret = start;
 		return 0;
 	}
+#endif
 out:
 	cache = btrfs_lookup_block_group(root->fs_info, search_start);
 	if (!cache) {
@@ -1383,9 +1386,12 @@ static int update_block_group(struct btr
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
 			if (mark_free) {
-				set_extent_dirty(&info->free_space_cache,
-						 bytenr, bytenr + num_bytes - 1,
-						 GFP_NOFS);
+				int ret;
+				u64 size = bytenr + num_bytes - 1;
+				ret = btrfs_add_free_space(cache, bytenr,
+							   size);
+				if (ret)
+					return -1;
 			}
 		}
 		total -= num_bytes;
@@ -1483,8 +1489,7 @@ int btrfs_finish_extent_commit(struct bt
 	u64 start;
 	u64 end;
 	int ret;
-	struct extent_io_tree *free_space_cache;
-	free_space_cache = &root->fs_info->free_space_cache;
+	struct btrfs_block_group_cache *cache;
 
 	mutex_lock(&root->fs_info->alloc_mutex);
 	while(1) {
@@ -1494,7 +1499,8 @@ int btrfs_finish_extent_commit(struct bt
 			break;
 		update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
-		set_extent_dirty(free_space_cache, start, end, GFP_NOFS);
+		cache = btrfs_lookup_block_group(root->fs_info, start);
+		btrfs_add_free_space(cache, start, end - start);
 		if (need_resched()) {
 			mutex_unlock(&root->fs_info->alloc_mutex);
 			cond_resched();
@@ -2060,6 +2066,7 @@ static int __btrfs_reserve_extent(struct
 	u64 search_start = 0;
 	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_block_group_cache *cache;
 
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
@@ -2111,17 +2118,28 @@ again:
 		printk("allocation failed flags %Lu\n", data);
 		BUG();
 	}
-	clear_extent_dirty(&root->fs_info->free_space_cache,
-			   ins->objectid, ins->objectid + ins->offset - 1,
-			   GFP_NOFS);
+	cache = btrfs_lookup_block_group(root->fs_info, ins->objectid);
+	if (!cache) {
+		printk("Unable to find block group for %Lu\n", ins->objectid);
+		return -ENOSPC;
+	}
+	btrfs_remove_free_space(cache, ins->objectid, ins->objectid +
+				ins->offset - 1);
+
 	return 0;
 }
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 {
+	struct btrfs_block_group_cache *cache;
+
 	maybe_lock_mutex(root);
-	set_extent_dirty(&root->fs_info->free_space_cache,
-			 start, start + len - 1, GFP_NOFS);
+	cache = btrfs_lookup_block_group(root->fs_info, start);
+	if (!cache) {
+		printk("Unable to find block group for %Lu\n", start);
+		return -ENOSPC;
+	}
+	btrfs_add_free_space(cache, start, len);
 	maybe_unlock_mutex(root);
 	return 0;
 }
@@ -2735,6 +2753,7 @@ out:
 
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
+	struct btrfs_block_group_cache *block_group;
 	u64 start;
 	u64 end;
 	u64 ptr;
@@ -2747,18 +2766,14 @@ int btrfs_free_block_groups(struct btrfs
 		if (ret)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
-		if (!ret)
-			kfree((void *)(unsigned long)ptr);
+		if (!ret) {
+			block_group = (struct btrfs_block_group_cache *)
+				(unsigned long)ptr;
+			btrfs_remove_free_space_cache(block_group);
+			kfree(block_group);
+		}
 		clear_extent_bits(&info->block_group_cache, start,
 				  end, (unsigned int)-1, GFP_NOFS);
-	}
-	while(1) {
-		ret = find_first_extent_bit(&info->free_space_cache, 0,
-					    &start, &end, EXTENT_DIRTY);
-		if (ret)
-			break;
-		clear_extent_dirty(&info->free_space_cache, start,
-				   end, GFP_NOFS);
 	}
 	mutex_unlock(&info->alloc_mutex);
 	return 0;
@@ -3439,10 +3454,12 @@ next:
 			  (unsigned int)-1, GFP_NOFS);
 
 
-	clear_extent_bits(&info->free_space_cache,
-			   key.objectid, key.objectid + key.offset - 1,
-			   (unsigned int)-1, GFP_NOFS);
-
+	ret = btrfs_remove_free_space(shrink_block_group, key.objectid,
+				      key.offset);
+	if (ret) {
+		btrfs_end_transaction(trans, root);
+		goto out;
+	}
 	/*
 	memset(shrink_block_group, 0, sizeof(*shrink_block_group));
 	kfree(shrink_block_group);
@@ -3458,9 +3475,9 @@ next:
 	/* the code to unpin extents might set a few bits in the free
 	 * space cache for this range again
 	 */
-	clear_extent_bits(&info->free_space_cache,
-			   key.objectid, key.objectid + key.offset - 1,
-			   (unsigned int)-1, GFP_NOFS);
+	/* XXX? */
+	ret = btrfs_remove_free_space(shrink_block_group, key.objectid,
+				      key.offset);
 out:
 	btrfs_free_path(path);
 	mutex_unlock(&root->fs_info->alloc_mutex);
@@ -3545,6 +3562,7 @@ int btrfs_read_block_groups(struct btrfs
 		}
 
 		spin_lock_init(&cache->lock);
+		INIT_LIST_HEAD(&cache->free_space_list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
 				   sizeof(cache->item));
@@ -3609,6 +3627,7 @@ int btrfs_make_block_group(struct btrfs_
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
+	INIT_LIST_HEAD(&cache->free_space_list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
diff -r 401378fbac2a free-space-cache.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/free-space-cache.c	Fri Aug 08 23:16:45 2008 -0400
@@ -0,0 +1,213 @@
+/*
+ * Copyright (C) 2008 Red Hat.  All rights reserved.
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
+#include "ctree.h"
+
+#define TREE_INSERT_FUNC(name)						\
+static int tree_insert_##name(struct rb_root *root, u64 index,		\
+			      struct rb_node *node)			\
+{									\
+	struct rb_node **p = &root->rb_node;				\
+	struct rb_node *parent = NULL;					\
+	struct btrfs_free_space *info;					\
+									\
+	while (*p) {							\
+		parent = *p;						\
+		info = rb_entry(parent, struct btrfs_free_space,	\
+				name##_index);				\
+									\
+		if (index < info->name)					\
+			p = &(*p)->rb_left;				\
+		else if (index > info->name)				\
+			p = &(*p)->rb_right;				\
+		else							\
+			return -EEXIST;					\
+	}								\
+									\
+	rb_link_node(node, parent, p);					\
+	rb_insert_color(node, root);					\
+	return 0;							\
+}
+
+TREE_INSERT_FUNC(size)
+TREE_INSERT_FUNC(bytenr)
+
+/*
+ * search for free space as indexed by the starting bytenr, and make sure
+ * it is at least size big.  If we don't find an exact match this will return a
+ * free space area that is after bytenr and of the proper size, NULL if it
+ * could'nt find one.
+ */
+static struct btrfs_free_space *tree_search_bytenr(struct rb_root *root,
+						   u64 bytenr, u64 size)
+{
+	struct rb_node *n = root->rb_node;
+	struct btrfs_free_space *entry, *ret = NULL;
+
+	while (n) {
+		entry = rb_entry(n, struct btrfs_free_space, size_index);
+
+		if (bytenr < entry->bytenr) {
+			n = n->rb_left;
+		} else if (bytenr > entry->bytenr) {
+			if ((!ret || bytenr < ret->bytenr) &&
+			    size <= entry->size)
+				ret = entry;
+			n = n->rb_right;
+		} else {
+			if (size > entry->size)
+				continue;
+			ret = entry;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 bytenr, u64 size)
+{
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	spin_lock(&block_group->lock);
+	info = tree_search_bytenr(&block_group->free_space_bytenr,
+				  bytenr+size, 0);
+	spin_unlock(&block_group->lock);
+
+	if (info && info->bytenr == (bytenr+size)) {
+		size += info->size;
+		btrfs_remove_free_space(block_group, info->bytenr, info->size);
+	}
+
+	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	if (info) {
+		info->bytenr = bytenr;
+		info->size = size;
+		INIT_LIST_HEAD(&info->list);
+		spin_lock(&block_group->lock);
+		ret = tree_insert_bytenr(&block_group->free_space_bytenr,
+					 bytenr, &info->bytenr_index);
+		if (ret) {
+err:
+			spin_unlock(&block_group->lock);
+			printk(KERN_ERR "Umm, duplicate free space info found"
+			       " in block group cache\n");
+			dump_stack();
+			kfree(info);
+			return 0;
+		}
+
+		ret = tree_insert_size(&block_group->free_space_size, size,
+				       &info->size_index);
+		if (ret)
+			goto err;
+		list_add_tail(&info->list, &block_group->free_space_list);
+		spin_unlock(&block_group->lock);
+	} else {
+		ret = -ENOMEM;
+	}
+
+	return ret;
+}
+
+int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			    u64 bytenr, u64 size)
+{
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	spin_lock(&block_group->lock);
+	info = tree_search_bytenr(&block_group->free_space_bytenr, bytenr, 0);
+	if (info) {
+		u64 new_bytenr, new_size;
+
+		if (unlikely(info->bytenr != bytenr)) {
+			spin_unlock(&block_group->lock);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (info->size < size) {
+			spin_unlock(&block_group->lock);
+			BUG();
+			ret = -EINVAL;
+			goto out;
+		}
+
+		rb_erase(&info->bytenr_index, &block_group->free_space_bytenr);
+		rb_erase(&info->size_index, &block_group->free_space_size);
+		list_del_init(&info->list);
+
+		spin_unlock(&block_group->lock);
+
+		if (info->size == size) {
+			kfree(info);
+			goto out;
+		}
+
+		new_bytenr = bytenr + size;
+		new_size = info->size - size;
+		ret = btrfs_add_free_space(block_group, new_bytenr, new_size);
+		kfree(info);
+	} else {
+		spin_unlock(&block_group->lock);
+		WARN_ON(1);
+	}
+out:
+	return ret;
+}
+
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space *info;
+
+	spin_lock(&block_group->lock);
+	while (!list_empty(&block_group->free_space_list)) {
+		info = list_entry(block_group->free_space_list.next,
+				  struct btrfs_free_space, list);
+
+		list_del_init(&info->list);
+		rb_erase(&info->bytenr_index, &block_group->free_space_bytenr);
+		rb_erase(&info->size_index, &block_group->free_space_size);
+		kfree(info);
+		if (need_resched()) {
+			spin_unlock(&block_group->lock);
+			cond_resched();
+			spin_lock(&block_group->lock);
+		}
+	}
+	spin_unlock(&block_group->lock);
+}
+
+struct btrfs_free_space *btrfs_find_free_space_start(struct
+						     btrfs_block_group_cache
+						     *block_group, u64 bytenr,
+						     u64 size)
+{
+	struct btrfs_free_space *ret;
+
+	spin_lock(&block_group->lock);
+	ret = tree_search_bytenr(&block_group->free_space_bytenr, bytenr,
+				 size);
+	spin_unlock(&block_group->lock);
+
+	return ret;
+}
