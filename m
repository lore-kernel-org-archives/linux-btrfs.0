From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH V2] free space accounting redo
Date: Tue, 23 Sep 2008 09:38:03 -0400
Message-ID: <20080923133755.GB16621@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is basically the same patch as I sent before, just takes a kzalloc outside
of a spin_lock to get rid of a possible hang situation.  Thanks,

Josef

diff -r 639a8457eb97 Makefile
--- a/Makefile	Wed Sep 17 20:50:33 2008 -0400
+++ b/Makefile	Tue Sep 23 16:33:48 2008 -0400
@@ -7,7 +7,7 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   ref-cache.o export.o tree-log.o acl.o
+	   ref-cache.o export.o tree-log.o acl.o free-space-cache.o
 else
 
 # Normal Makefile
diff -r 639a8457eb97 ctree.c
--- a/ctree.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/ctree.c	Tue Sep 23 16:33:48 2008 -0400
@@ -2725,9 +2725,8 @@ int btrfs_insert_empty_items(struct btrf
 
 	total_size = total_data + (nr * sizeof(struct btrfs_item));
 	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
-	if (ret == 0) {
+	if (ret == 0)
 		return -EEXIST;
-	}
 	if (ret < 0)
 		goto out;
 
diff -r 639a8457eb97 ctree.h
--- a/ctree.h	Wed Sep 17 20:50:33 2008 -0400
+++ b/ctree.h	Tue Sep 23 16:33:48 2008 -0400
@@ -483,7 +483,6 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
 
-
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
@@ -498,17 +497,40 @@ struct btrfs_space_info {
 	int full;
 	int force_alloc;
 	struct list_head list;
+
+	/* for block groups in our same type */
+	struct list_head block_groups;
+	spinlock_t lock;
+};
+
+struct btrfs_free_space {
+	struct rb_node bytes_index;
+	struct rb_node offset_index;
+	u64 offset;
+	u64 bytes;
 };
 
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
-	struct btrfs_space_info *space_info;
 	spinlock_t lock;
 	u64 pinned;
 	u64 flags;
 	int cached;
 	int ro;
+	int dirty;
+
+	struct btrfs_space_info *space_info;
+
+	/* free space cache stuff */
+	struct rb_root free_space_bytes;
+	struct rb_root free_space_offset;
+
+	/* block group cache stuff */
+	struct rb_node cache_node;
+
+	/* for block groups in the same raid type */
+	struct list_head list;
 };
 
 struct btrfs_device;
@@ -525,8 +547,10 @@ struct btrfs_fs_info {
 	struct btrfs_root *log_root_tree;
 	struct radix_tree_root fs_roots_radix;
 
-	struct extent_io_tree free_space_cache;
-	struct extent_io_tree block_group_cache;
+	/* block group cache stuff */
+	spinlock_t block_group_cache_lock;
+	struct rb_root block_group_cache_tree;
+
 	struct extent_io_tree pinned_extents;
 	struct extent_io_tree pending_del;
 	struct extent_io_tree extent_ins;
@@ -1814,4 +1838,18 @@ int btrfs_check_acl(struct inode *inode,
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
+struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
+					       *block_group, u64 offset,
+					       u64 bytes);
+void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
+			   u64 bytes);
+u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group);
 #endif
diff -r 639a8457eb97 disk-io.c
--- a/disk-io.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/disk-io.c	Tue Sep 23 16:33:49 2008 -0400
@@ -1410,10 +1410,9 @@ struct btrfs_root *open_ctree(struct sup
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
-	extent_io_tree_init(&fs_info->free_space_cache,
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
-	extent_io_tree_init(&fs_info->block_group_cache,
-			     fs_info->btree_inode->i_mapping, GFP_NOFS);
+	spin_lock_init(&fs_info->block_group_cache_lock);
+	fs_info->block_group_cache_tree.rb_node = NULL;
+
 	extent_io_tree_init(&fs_info->pinned_extents,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	extent_io_tree_init(&fs_info->pending_del,
diff -r 639a8457eb97 extent-tree.c
--- a/extent-tree.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/extent-tree.c	Tue Sep 23 16:33:49 2008 -0400
@@ -29,12 +29,6 @@
 #include "locking.h"
 #include "ref-cache.h"
 
-#define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
-#define BLOCK_GROUP_METADATA EXTENT_UPTODATE
-#define BLOCK_GROUP_SYSTEM   EXTENT_NEW
-
-#define BLOCK_GROUP_DIRTY EXTENT_DIRTY
-
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
@@ -62,6 +56,127 @@ void maybe_unlock_mutex(struct btrfs_roo
 	}
 }
 
+static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
+{
+	return (cache->flags & bits) == bits;
+}
+
+/*
+ * this adds the block group to the fs_info rb tree for the block group
+ * cache
+ */
+int btrfs_add_block_group_cache(struct btrfs_fs_info *info,
+				struct btrfs_block_group_cache *block_group)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct btrfs_block_group_cache *cache;
+
+	spin_lock(&info->block_group_cache_lock);
+	p = &info->block_group_cache_tree.rb_node;
+
+	while (*p) {
+		parent = *p;
+		cache = rb_entry(parent, struct btrfs_block_group_cache,
+				 cache_node);
+		if (block_group->key.objectid < cache->key.objectid) {
+			p = &(*p)->rb_left;
+		} else if (block_group->key.objectid > cache->key.objectid) {
+			p = &(*p)->rb_right;
+		} else {
+			spin_unlock(&info->block_group_cache_lock);
+			return -EEXIST;
+		}
+	}
+
+	rb_link_node(&block_group->cache_node, parent, p);
+	rb_insert_color(&block_group->cache_node,
+			&info->block_group_cache_tree);
+	spin_unlock(&info->block_group_cache_lock);
+
+	return 0;
+}
+
+/*
+ * This will return the block group at or after bytenr if contains is 0, else
+ * it will return the block group that contains the bytenr
+ */
+static struct btrfs_block_group_cache *
+block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
+			      int contains)
+{
+	struct btrfs_block_group_cache *cache, *ret = NULL;
+	struct rb_node *n;
+	u64 end, start;
+
+	spin_lock(&info->block_group_cache_lock);
+	n = info->block_group_cache_tree.rb_node;
+
+	while (n) {
+		cache = rb_entry(n, struct btrfs_block_group_cache,
+				 cache_node);
+		end = cache->key.objectid + cache->key.offset - 1;
+		start = cache->key.objectid;
+
+		if (bytenr < start) {
+			if (!contains && (!ret || start < ret->key.objectid))
+				ret = cache;
+			n = n->rb_left;
+		} else if (bytenr > start) {
+			if (contains && bytenr <= end) {
+				ret = cache;
+				break;
+			}
+			n = n->rb_right;
+		} else {
+			ret = cache;
+			break;
+		}
+	}
+	spin_unlock(&info->block_group_cache_lock);
+
+	return ret;
+}
+
+/*
+ * this is only called by cache_block_group, since we could have freed extents
+ * we need to check the pinned_extents for any extents that can't be used yet
+ * since their free space will be released as soon as the transaction commits.
+ */
+static int add_new_free_space(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_fs_info *info, u64 start, u64 end)
+{
+	u64 extent_start, extent_end, size;
+	int ret;
+
+	while (start < end) {
+		ret = find_first_extent_bit(&info->pinned_extents, start,
+					    &extent_start, &extent_end,
+					    EXTENT_DIRTY);
+		if (ret)
+			break;
+
+		if (extent_start == start) {
+			start = extent_end + 1;
+		} else if (extent_start > start && extent_start < end) {
+			size = extent_start - start;
+			ret = btrfs_add_free_space(block_group, start, size);
+			BUG_ON(ret);
+			start = extent_end + 1;
+		} else {
+			break;
+		}
+	}
+
+	if (start < end) {
+		size = end - start;
+		ret = btrfs_add_free_space(block_group, start, size);
+		BUG_ON(ret);
+	}
+
+	return 0;
+}
+
 static int cache_block_group(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *block_group)
 {
@@ -69,10 +184,8 @@ static int cache_block_group(struct btrf
 	int ret = 0;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct extent_io_tree *free_space_cache;
 	int slot;
 	u64 last = 0;
-	u64 hole_size;
 	u64 first_free;
 	int found = 0;
 
@@ -80,7 +193,6 @@ static int cache_block_group(struct btrf
 		return 0;
 
 	root = root->fs_info->extent_root;
-	free_space_cache = &root->fs_info->free_space_cache;
 
 	if (block_group->cached)
 		return 0;
@@ -96,7 +208,8 @@ static int cache_block_group(struct btrf
 	 * skip the locking here
 	 */
 	path->skip_locking = 1;
-	first_free = block_group->key.objectid;
+	first_free = max_t(u64, block_group->key.objectid,
+			   BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE);
 	key.objectid = block_group->key.objectid;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -119,32 +232,28 @@ static int cache_block_group(struct btrf
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
 				goto err;
-			if (ret == 0) {
+			if (ret == 0)
 				continue;
-			} else {
+			else
 				break;
-			}
 		}
 		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (key.objectid < block_group->key.objectid) {
+		if (key.objectid < block_group->key.objectid)
 			goto next;
-		}
+
 		if (key.objectid >= block_group->key.objectid +
-		    block_group->key.offset) {
+		    block_group->key.offset)
 			break;
-		}
 
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_ITEM_KEY) {
 			if (!found) {
 				last = first_free;
 				found = 1;
 			}
-			if (key.objectid > last) {
-				hole_size = key.objectid - last;
-				set_extent_dirty(free_space_cache, last,
-						 last + hole_size - 1,
-						 GFP_NOFS);
-			}
+
+			add_new_free_space(block_group, root->fs_info, last,
+					   key.objectid);
+
 			last = key.objectid + key.offset;
 		}
 next:
@@ -153,13 +262,11 @@ next:
 
 	if (!found)
 		last = first_free;
-	if (block_group->key.objectid +
-	    block_group->key.offset > last) {
-		hole_size = block_group->key.objectid +
-			block_group->key.offset - last;
-		set_extent_dirty(free_space_cache, last,
-				 last + hole_size - 1, GFP_NOFS);
-	}
+
+	add_new_free_space(block_group, root->fs_info, last,
+			   block_group->key.objectid +
+			   block_group->key.offset);
+
 	block_group->cached = 1;
 	ret = 0;
 err:
@@ -167,166 +274,79 @@ err:
 	return ret;
 }
 
+/*
+ * return the block group that starts at or after bytenr
+ */
 struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
 						       btrfs_fs_info *info,
 							 u64 bytenr)
 {
-	struct extent_io_tree *block_group_cache;
-	struct btrfs_block_group_cache *block_group = NULL;
-	u64 ptr;
-	u64 start;
-	u64 end;
-	int ret;
+	struct btrfs_block_group_cache *cache;
 
-	bytenr = max_t(u64, bytenr,
-		       BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE);
-	block_group_cache = &info->block_group_cache;
-	ret = find_first_extent_bit(block_group_cache,
-				    bytenr, &start, &end,
-				    BLOCK_GROUP_DATA | BLOCK_GROUP_METADATA |
-				    BLOCK_GROUP_SYSTEM);
-	if (ret) {
-		return NULL;
-	}
-	ret = get_state_private(block_group_cache, start, &ptr);
-	if (ret)
-		return NULL;
+	cache = block_group_cache_tree_search(info, bytenr, 0);
 
-	block_group = (struct btrfs_block_group_cache *)(unsigned long)ptr;
-	return block_group;
+	return cache;
 }
 
+/*
+ * return the block group that contains teh given bytenr
+ */
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr)
 {
-	struct extent_io_tree *block_group_cache;
-	struct btrfs_block_group_cache *block_group = NULL;
-	u64 ptr;
-	u64 start;
-	u64 end;
-	int ret;
+	struct btrfs_block_group_cache *cache;
 
-	bytenr = max_t(u64, bytenr,
-		       BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE);
-	block_group_cache = &info->block_group_cache;
-	ret = find_first_extent_bit(block_group_cache,
-				    bytenr, &start, &end,
-				    BLOCK_GROUP_DATA | BLOCK_GROUP_METADATA |
-				    BLOCK_GROUP_SYSTEM);
-	if (ret) {
-		return NULL;
-	}
-	ret = get_state_private(block_group_cache, start, &ptr);
-	if (ret)
-		return NULL;
+	cache = block_group_cache_tree_search(info, bytenr, 1);
 
-	block_group = (struct btrfs_block_group_cache *)(unsigned long)ptr;
-	if (block_group->key.objectid <= bytenr && bytenr <
-	    block_group->key.objectid + block_group->key.offset)
-		return block_group;
-	return NULL;
+	return cache;
 }
 
-static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
-{
-	return (cache->flags & bits) == bits;
-}
-
-static int noinline find_search_start(struct btrfs_root *root,
-			      struct btrfs_block_group_cache **cache_ret,
-			      u64 *start_ret, u64 num, int data)
+static int noinline find_free_space(struct btrfs_root *root,
+				    struct btrfs_block_group_cache **cache_ret,
+				    u64 *start_ret, u64 num, int data)
 {
 	int ret;
 	struct btrfs_block_group_cache *cache = *cache_ret;
-	struct extent_io_tree *free_space_cache;
-	struct extent_state *state;
+	struct btrfs_free_space *info = NULL;
 	u64 last;
-	u64 start = 0;
-	u64 cache_miss = 0;
 	u64 total_fs_bytes;
 	u64 search_start = *start_ret;
-	int wrapped = 0;
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
-	free_space_cache = &root->fs_info->free_space_cache;
 
 	if (!cache)
 		goto out;
 
+	last = max(search_start, cache->key.objectid);
+
 again:
 	ret = cache_block_group(root, cache);
-	if (ret) {
+	if (ret)
 		goto out;
-	}
 
-	last = max(search_start, cache->key.objectid);
-	if (!block_group_bits(cache, data) || cache->ro)
+	if (cache->ro || !block_group_bits(cache, data))
 		goto new_group;
 
-	spin_lock_irq(&free_space_cache->lock);
-	state = find_first_extent_bit_state(free_space_cache, last, EXTENT_DIRTY);
-	while(1) {
-		if (!state) {
-			if (!cache_miss)
-				cache_miss = last;
-			spin_unlock_irq(&free_space_cache->lock);
-			goto new_group;
-		}
-
-		start = max(last, state->start);
-		last = state->end + 1;
-		if (last - start < num) {
-			do {
-				state = extent_state_next(state);
-			} while(state && !(state->state & EXTENT_DIRTY));
-			continue;
-		}
-		spin_unlock_irq(&free_space_cache->lock);
-		if (cache->ro) {
-			goto new_group;
-		}
-		if (start + num > cache->key.objectid + cache->key.offset)
-			goto new_group;
-		if (!block_group_bits(cache, data)) {
-			printk("block group bits don't match %Lu %d\n", cache->flags, data);
-		}
-		*start_ret = start;
+	info = btrfs_find_free_space(cache, last, num);
+	if (info) {
+		*start_ret = info->offset;
 		return 0;
 	}
-out:
-	cache = btrfs_lookup_block_group(root->fs_info, search_start);
-	if (!cache) {
-		printk("Unable to find block group for %Lu\n", search_start);
-		WARN_ON(1);
-	}
-	return -ENOSPC;
 
 new_group:
 	last = cache->key.objectid + cache->key.offset;
-wrapped:
+
 	cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	if (!cache || cache->key.objectid >= total_fs_bytes) {
-no_cache:
-		if (!wrapped) {
-			wrapped = 1;
-			last = search_start;
-			goto wrapped;
-		}
+	if (!cache || cache->key.objectid >= total_fs_bytes)
 		goto out;
-	}
-	if (cache_miss && !cache->cached) {
-		cache_block_group(root, cache);
-		last = cache_miss;
-		cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	}
-	cache_miss = 0;
-	cache = btrfs_find_block_group(root, cache, last, data, 0);
-	if (!cache)
-		goto no_cache;
+
 	*cache_ret = cache;
 	goto again;
+
+out:
+	return -ENOSPC;
 }
 
 static u64 div_factor(u64 num, int factor)
@@ -338,16 +358,19 @@ static u64 div_factor(u64 num, int facto
 	return num;
 }
 
-static int block_group_state_bits(u64 flags)
+static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
+						  u64 flags)
 {
-	int bits = 0;
-	if (flags & BTRFS_BLOCK_GROUP_DATA)
-		bits |= BLOCK_GROUP_DATA;
-	if (flags & BTRFS_BLOCK_GROUP_METADATA)
-		bits |= BLOCK_GROUP_METADATA;
-	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-		bits |= BLOCK_GROUP_SYSTEM;
-	return bits;
+	struct list_head *head = &info->space_info;
+	struct list_head *cur;
+	struct btrfs_space_info *found;
+	list_for_each(cur, head) {
+		found = list_entry(cur, struct btrfs_space_info, list);
+		if (found->flags == flags)
+			return found;
+	}
+	return NULL;
+
 }
 
 static struct btrfs_block_group_cache *
@@ -356,27 +379,18 @@ __btrfs_find_block_group(struct btrfs_ro
 			 u64 search_start, int data, int owner)
 {
 	struct btrfs_block_group_cache *cache;
-	struct extent_io_tree *block_group_cache;
 	struct btrfs_block_group_cache *found_group = NULL;
 	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *sinfo;
 	u64 used;
 	u64 last = 0;
-	u64 start;
-	u64 end;
 	u64 free_check;
-	u64 ptr;
-	int bit;
-	int ret;
 	int full_search = 0;
 	int factor = 10;
 	int wrapped = 0;
 
-	block_group_cache = &info->block_group_cache;
-
 	if (data & BTRFS_BLOCK_GROUP_METADATA)
 		factor = 9;
-
-	bit = block_group_state_bits(data);
 
 	if (search_start) {
 		struct btrfs_block_group_cache *shint;
@@ -408,20 +422,30 @@ __btrfs_find_block_group(struct btrfs_ro
 		else
 			last = search_start;
 	}
+	sinfo = __find_space_info(root->fs_info, data);
+	if (!sinfo)
+		goto found;
 again:
 	while(1) {
-		ret = find_first_extent_bit(block_group_cache, last,
-					    &start, &end, bit);
-		if (ret)
+		struct list_head *l;
+
+		cache = NULL;
+
+		spin_lock(&sinfo->lock);
+		list_for_each(l, &sinfo->block_groups) {
+			struct btrfs_block_group_cache *entry;
+			entry = list_entry(l, struct btrfs_block_group_cache,
+					   list);
+			if ((entry->key.objectid >= last) &&
+			    (!cache || (entry->key.objectid <
+					cache->key.objectid)))
+				cache = entry;
+		}
+		spin_unlock(&sinfo->lock);
+
+		if (!cache)
 			break;
 
-		ret = get_state_private(block_group_cache, start, &ptr);
-		if (ret) {
-			last = end + 1;
-			continue;
-		}
-
-		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
 		spin_lock(&cache->lock);
 		last = cache->key.objectid + cache->key.offset;
 		used = btrfs_block_group_used(&cache->item);
@@ -462,6 +486,7 @@ struct btrfs_block_group_cache *btrfs_fi
 	ret = __btrfs_find_block_group(root, hint, search_start, data, owner);
 	return ret;
 }
+
 static u64 hash_extent_ref(u64 root_objectid, u64 ref_generation,
 			   u64 owner, u64 owner_offset)
 {
@@ -1175,34 +1200,37 @@ int btrfs_write_dirty_block_groups(struc
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	struct extent_io_tree *block_group_cache;
-	struct btrfs_block_group_cache *cache;
-	int ret;
+	struct btrfs_block_group_cache *cache, *entry;
+	struct rb_node *n;
 	int err = 0;
 	int werr = 0;
 	struct btrfs_path *path;
 	u64 last = 0;
-	u64 start;
-	u64 end;
-	u64 ptr;
 
-	block_group_cache = &root->fs_info->block_group_cache;
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	mutex_lock(&root->fs_info->alloc_mutex);
 	while(1) {
-		ret = find_first_extent_bit(block_group_cache, last,
-					    &start, &end, BLOCK_GROUP_DIRTY);
-		if (ret)
+		cache = NULL;
+		spin_lock(&root->fs_info->block_group_cache_lock);
+		for (n = rb_first(&root->fs_info->block_group_cache_tree);
+		     n; n = rb_next(n)) {
+			entry = rb_entry(n, struct btrfs_block_group_cache,
+					 cache_node);
+			if (entry->dirty) {
+				cache = entry;
+				break;
+			}
+		}
+		spin_unlock(&root->fs_info->block_group_cache_lock);
+
+		if (!cache)
 			break;
 
-		last = end + 1;
-		ret = get_state_private(block_group_cache, start, &ptr);
-		if (ret)
-			break;
-		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
+		last += cache->key.offset;
+
 		err = write_one_cache_group(trans, root,
 					    path, cache);
 		/*
@@ -1214,27 +1242,12 @@ int btrfs_write_dirty_block_groups(struc
 			werr = err;
 			continue;
 		}
-		clear_extent_bits(block_group_cache, start, end,
-				  BLOCK_GROUP_DIRTY, GFP_NOFS);
+
+		cache->dirty = 0;
 	}
 	btrfs_free_path(path);
 	mutex_unlock(&root->fs_info->alloc_mutex);
 	return werr;
-}
-
-static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
-						  u64 flags)
-{
-	struct list_head *head = &info->space_info;
-	struct list_head *cur;
-	struct btrfs_space_info *found;
-	list_for_each(cur, head) {
-		found = list_entry(cur, struct btrfs_space_info, list);
-		if (found->flags == flags)
-			return found;
-	}
-	return NULL;
-
 }
 
 static int update_space_info(struct btrfs_fs_info *info, u64 flags,
@@ -1256,6 +1269,8 @@ static int update_space_info(struct btrf
 		return -ENOMEM;
 
 	list_add(&found->list, &info->space_info);
+	INIT_LIST_HEAD(&found->block_groups);
+	spin_lock_init(&found->lock);
 	found->flags = flags;
 	found->total_bytes = total_bytes;
 	found->bytes_used = bytes_used;
@@ -1318,7 +1333,7 @@ static int do_chunk_alloc(struct btrfs_t
 	u64 thresh;
 	u64 start;
 	u64 num_bytes;
-	int ret;
+	int ret = 0;
 
 	flags = reduce_alloc_profile(extent_root, flags);
 
@@ -1355,10 +1370,11 @@ printk("space info full %Lu\n", flags);
 	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
+
 out_unlock:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 out:
-	return 0;
+	return ret;
 }
 
 static int update_block_group(struct btrfs_trans_handle *trans,
@@ -1371,8 +1387,6 @@ static int update_block_group(struct btr
 	u64 total = num_bytes;
 	u64 old_val;
 	u64 byte_in_group;
-	u64 start;
-	u64 end;
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	while(total) {
@@ -1382,12 +1396,9 @@ static int update_block_group(struct btr
 		}
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
-		start = cache->key.objectid;
-		end = start + cache->key.offset - 1;
-		set_extent_bits(&info->block_group_cache, start, end,
-				BLOCK_GROUP_DIRTY, GFP_NOFS);
 
 		spin_lock(&cache->lock);
+		cache->dirty = 1;
 		old_val = btrfs_block_group_used(&cache->item);
 		num_bytes = min(total, cache->key.offset - byte_in_group);
 		if (alloc) {
@@ -1401,9 +1412,11 @@ static int update_block_group(struct btr
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
 			if (mark_free) {
-				set_extent_dirty(&info->free_space_cache,
-						 bytenr, bytenr + num_bytes - 1,
-						 GFP_NOFS);
+				int ret;
+				ret = btrfs_add_free_space(cache, bytenr,
+							   num_bytes);
+				if (ret)
+					return -1;
 			}
 		}
 		total -= num_bytes;
@@ -1414,16 +1427,13 @@ static int update_block_group(struct btr
 
 static u64 first_logical_byte(struct btrfs_root *root, u64 search_start)
 {
-	u64 start;
-	u64 end;
-	int ret;
-	ret = find_first_extent_bit(&root->fs_info->block_group_cache,
-				    search_start, &start, &end,
-				    BLOCK_GROUP_DATA | BLOCK_GROUP_METADATA |
-				    BLOCK_GROUP_SYSTEM);
-	if (ret)
+	struct btrfs_block_group_cache *cache;
+
+	cache = btrfs_lookup_first_block_group(root->fs_info, search_start);
+	if (!cache)
 		return 0;
-	return start;
+
+	return cache->key.objectid;
 }
 
 
@@ -1501,8 +1511,7 @@ int btrfs_finish_extent_commit(struct bt
 	u64 start;
 	u64 end;
 	int ret;
-	struct extent_io_tree *free_space_cache;
-	free_space_cache = &root->fs_info->free_space_cache;
+	struct btrfs_block_group_cache *cache;
 
 	mutex_lock(&root->fs_info->alloc_mutex);
 	while(1) {
@@ -1512,7 +1521,9 @@ int btrfs_finish_extent_commit(struct bt
 			break;
 		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
-		set_extent_dirty(free_space_cache, start, end, GFP_NOFS);
+		cache = btrfs_lookup_block_group(root->fs_info, start);
+		if (cache->cached)
+			btrfs_add_free_space(cache, start, end - start + 1);
 		if (need_resched()) {
 			mutex_unlock(&root->fs_info->alloc_mutex);
 			cond_resched();
@@ -1875,9 +1886,12 @@ static int __btrfs_free_extent(struct bt
 	/* if metadata always pin */
 	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
 		if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+			struct btrfs_block_group_cache *cache;
+
 			/* btrfs_free_reserved_extent */
-			set_extent_dirty(&root->fs_info->free_space_cache,
-				 bytenr, bytenr + num_bytes - 1, GFP_NOFS);
+			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
+			BUG_ON(!cache);
+			btrfs_add_free_space(cache, bytenr, num_bytes);
 			return 0;
 		}
 		pin = 1;
@@ -1942,8 +1956,6 @@ static int noinline find_free_extent(str
 	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group;
-	int full_scan = 0;
-	int wrapped = 0;
 	int chunk_alloc_done = 0;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
@@ -1959,9 +1971,9 @@ static int noinline find_free_extent(str
 		empty_cluster = 256 * 1024;
 	}
 
-	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD)) {
+	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD))
 		last_ptr = &root->fs_info->last_data_alloc;
-	}
+
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
 		last_ptr = &root->fs_info->last_log_alloc;
 		if (!last_ptr == 0 && root->fs_info->last_alloc) {
@@ -1972,9 +1984,8 @@ static int noinline find_free_extent(str
 	if (last_ptr) {
 		if (*last_ptr)
 			hint_byte = *last_ptr;
-		else {
+		else
 			empty_size += empty_cluster;
-		}
 	}
 
 	search_start = max(search_start, first_logical_byte(root, 0));
@@ -1983,96 +1994,125 @@ static int noinline find_free_extent(str
 	if (search_end == (u64)-1)
 		search_end = btrfs_super_total_bytes(&info->super_copy);
 
-	if (hint_byte) {
-		block_group = btrfs_lookup_first_block_group(info, hint_byte);
-		if (!block_group)
-			hint_byte = search_start;
-		block_group = btrfs_find_block_group(root, block_group,
-						     hint_byte, data, 1);
-		if (last_ptr && *last_ptr == 0 && block_group)
-			hint_byte = block_group->key.objectid;
-	} else {
-		block_group = btrfs_find_block_group(root,
-						     trans->block_group,
-						     search_start, data, 1);
-	}
 	search_start = max(search_start, hint_byte);
-
 	total_needed += empty_size;
 
-check_failed:
-	if (!block_group) {
-		block_group = btrfs_lookup_first_block_group(info,
-							     search_start);
-		if (!block_group)
-			block_group = btrfs_lookup_first_block_group(info,
-						       orig_search_start);
+new_group:
+	block_group = btrfs_lookup_block_group(info, search_start);
+
+	/*
+	 * Ok this looks a little tricky, buts its really simple.  First if we
+	 * didn't find a block group obviously we want to start over.
+	 * Secondly, if the block group we found does not match the type we
+	 * need, and we have a last_ptr and its not 0, chances are the last
+	 * allocation we made was at the end of the block group, so lets go
+	 * ahead and skip the looking through the rest of the block groups and
+	 * start at the beginning.  This helps with metadata allocations,
+	 * since you are likely to have a bunch of data block groups to search
+	 * through first before you realize that you need to start over, so go
+	 * ahead and start over and save the time.
+	 */
+	if (!block_group || (!block_group_bits(block_group, data) &&
+			     last_ptr && *last_ptr)) {
+		if (search_start != orig_search_start) {
+			if (last_ptr && *last_ptr)
+				*last_ptr = 0;
+			search_start = orig_search_start;
+			goto new_group;
+		} else if (!chunk_alloc_done && allowed_chunk_alloc) {
+			ret = do_chunk_alloc(trans, root,
+					     num_bytes + 2 * 1024 * 1024,
+					     data, 1);
+			if (ret < 0) {
+				struct btrfs_space_info *info;
+
+				info = __find_space_info(root->fs_info, data);
+				goto error;
+			}
+			BUG_ON(ret);
+			chunk_alloc_done = 1;
+			search_start = orig_search_start;
+			goto new_group;
+		} else {
+			ret = -ENOSPC;
+			goto error;
+		}
 	}
-	if (full_scan && !chunk_alloc_done) {
-		if (allowed_chunk_alloc) {
-			do_chunk_alloc(trans, root,
-				     num_bytes + 2 * 1024 * 1024, data, 1);
-			allowed_chunk_alloc = 0;
-		} else if (block_group && block_group_bits(block_group, data)) {
+
+	/*
+	 * this is going to seach through all of the existing block groups it
+	 * can find, so if we don't find something we need to see if we can
+	 * allocate what we need.
+	 */
+	ret = find_free_space(root, &block_group, &search_start,
+			      total_needed, data);
+	if (ret == -ENOSPC) {
+		/*
+		 * instead of allocating, start at the original search start
+		 * and see if there is something to be found, if not then we
+		 * allocate
+		 */
+		if (search_start != orig_search_start) {
+			if (last_ptr && *last_ptr) {
+				*last_ptr = 0;
+				total_needed += empty_cluster;
+			}
+			search_start = orig_search_start;
+			goto new_group;
+		}
+
+		/*
+		 * we've already allocated, we're pretty screwed
+		 */
+		if (chunk_alloc_done) {
+			goto error;
+		} else if (!allowed_chunk_alloc && block_group &&
+			   block_group_bits(block_group, data)) {
 			block_group->space_info->force_alloc = 1;
+			goto error;
+		} else if (!allowed_chunk_alloc) {
+			goto error;
 		}
+
+		ret = do_chunk_alloc(trans, root, num_bytes + 2 * 1024 * 1024,
+				     data, 1);
+		if (ret < 0)
+			goto error;
+
+		BUG_ON(ret);
 		chunk_alloc_done = 1;
+		if (block_group)
+			search_start = block_group->key.objectid +
+				block_group->key.offset;
+		else
+			search_start = orig_search_start;
+		goto new_group;
 	}
-	ret = find_search_start(root, &block_group, &search_start,
-				total_needed, data);
-	if (ret == -ENOSPC && last_ptr && *last_ptr) {
-		*last_ptr = 0;
-		block_group = btrfs_lookup_first_block_group(info,
-							     orig_search_start);
-		search_start = orig_search_start;
-		ret = find_search_start(root, &block_group, &search_start,
-					total_needed, data);
-	}
-	if (ret == -ENOSPC)
-		goto enospc;
+
 	if (ret)
 		goto error;
-
-	if (last_ptr && *last_ptr && search_start != *last_ptr) {
-		*last_ptr = 0;
-		if (!empty_size) {
-			empty_size += empty_cluster;
-			total_needed += empty_size;
-		}
-		block_group = btrfs_lookup_first_block_group(info,
-						       orig_search_start);
-		search_start = orig_search_start;
-		ret = find_search_start(root, &block_group,
-					&search_start, total_needed, data);
-		if (ret == -ENOSPC)
-			goto enospc;
-		if (ret)
-			goto error;
-	}
 
 	search_start = stripe_align(root, search_start);
 	ins->objectid = search_start;
 	ins->offset = num_bytes;
 
-	if (ins->objectid + num_bytes >= search_end)
-		goto enospc;
+	if (ins->objectid + num_bytes >= search_end) {
+		search_start = orig_search_start;
+		if (chunk_alloc_done) {
+			ret = -ENOSPC;
+			goto error;
+		}
+		goto new_group;
+	}
 
 	if (ins->objectid + num_bytes >
 	    block_group->key.objectid + block_group->key.offset) {
+		if (search_start == orig_search_start && chunk_alloc_done) {
+			ret = -ENOSPC;
+			goto error;
+		}
 		search_start = block_group->key.objectid +
 			block_group->key.offset;
-		goto new_group;
-	}
-
-	if (test_range_bit(&info->extent_ins, ins->objectid,
-			   ins->objectid + num_bytes -1, EXTENT_LOCKED, 0)) {
-		search_start = ins->objectid + num_bytes;
-		goto new_group;
-	}
-
-	if (test_range_bit(&info->pinned_extents, ins->objectid,
-			   ins->objectid + num_bytes -1, EXTENT_DIRTY, 0)) {
-		search_start = ins->objectid + num_bytes;
 		goto new_group;
 	}
 
@@ -2082,46 +2122,44 @@ check_failed:
 		goto new_group;
 	}
 
-	if (!(data & BTRFS_BLOCK_GROUP_DATA)) {
-		block_group = btrfs_lookup_block_group(info, ins->objectid);
-		if (block_group)
-			trans->block_group = block_group;
-	}
+	if (!(data & BTRFS_BLOCK_GROUP_DATA))
+		trans->block_group = block_group;
+
 	ins->offset = num_bytes;
 	if (last_ptr) {
 		*last_ptr = ins->objectid + ins->offset;
 		if (*last_ptr ==
-		    btrfs_super_total_bytes(&root->fs_info->super_copy)) {
+		    btrfs_super_total_bytes(&root->fs_info->super_copy))
 			*last_ptr = 0;
-		}
 	}
-	return 0;
 
-new_group:
-	if (search_start + num_bytes >= search_end) {
-enospc:
-		search_start = orig_search_start;
-		if (full_scan) {
-			ret = -ENOSPC;
-			goto error;
-		}
-		if (wrapped) {
-			if (!full_scan)
-				total_needed -= empty_size;
-			full_scan = 1;
-		} else
-			wrapped = 1;
-	}
-	block_group = btrfs_lookup_first_block_group(info, search_start);
-	cond_resched();
-	block_group = btrfs_find_block_group(root, block_group,
-					     search_start, data, 0);
-	goto check_failed;
-
+	ret = 0;
 error:
 	return ret;
 }
 
+static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
+{
+	struct btrfs_block_group_cache *cache;
+	struct list_head *l;
+
+	printk(KERN_INFO "space_info has %Lu free, is %sfull\n",
+	       info->total_bytes - info->bytes_used - info->bytes_pinned,
+	       (info->full) ? "" : "not ");
+
+	spin_lock(&info->lock);
+	list_for_each(l, &info->block_groups) {
+		cache = list_entry(l, struct btrfs_block_group_cache, list);
+		spin_lock(&cache->lock);
+		printk(KERN_INFO "block group %Lu has %Lu bytes, %Lu used "
+		       "%Lu pinned\n",
+		       cache->key.objectid, cache->key.offset,
+		       btrfs_block_group_used(&cache->item), cache->pinned);
+		btrfs_dump_free_space(cache, bytes);
+		spin_unlock(&cache->lock);
+	}
+	spin_unlock(&info->lock);
+}
 static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
@@ -2133,6 +2171,7 @@ static int __btrfs_reserve_extent(struct
 	u64 search_start = 0;
 	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_block_group_cache *cache;
 
 	if (data) {
 		alloc_profile = info->avail_data_alloc_bits &
@@ -2160,11 +2199,9 @@ again:
 				     BTRFS_BLOCK_GROUP_METADATA |
 				     (info->metadata_alloc_profile &
 				      info->avail_metadata_alloc_bits), 0);
-			BUG_ON(ret);
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 				     num_bytes + 2 * 1024 * 1024, data, 0);
-		BUG_ON(ret);
 	}
 
 	WARN_ON(num_bytes < root->sectorsize);
@@ -2175,26 +2212,44 @@ again:
 
 	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
+		num_bytes = num_bytes & ~(root->sectorsize - 1);
 		num_bytes = max(num_bytes, min_alloc_size);
 		do_chunk_alloc(trans, root->fs_info->extent_root,
 			       num_bytes, data, 1);
 		goto again;
 	}
 	if (ret) {
-		printk("allocation failed flags %Lu\n", data);
+		struct btrfs_space_info *sinfo;
+
+		sinfo = __find_space_info(root->fs_info, data);
+		printk("allocation failed flags %Lu, wanted %Lu\n",
+		       data, num_bytes);
+		dump_space_info(sinfo, num_bytes);
 		BUG();
 	}
-	clear_extent_dirty(&root->fs_info->free_space_cache,
-			   ins->objectid, ins->objectid + ins->offset - 1,
-			   GFP_NOFS);
-	return 0;
+	cache = btrfs_lookup_block_group(root->fs_info, ins->objectid);
+	if (!cache) {
+		printk(KERN_ERR "Unable to find block group for %Lu\n", ins->objectid);
+		return -ENOSPC;
+	}
+
+	ret = btrfs_remove_free_space(cache, ins->objectid, ins->offset);
+
+	return ret;
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
+		printk(KERN_ERR "Unable to find block group for %Lu\n", start);
+		maybe_unlock_mutex(root);
+		return -ENOSPC;
+	}
+	btrfs_add_free_space(cache, start, len);
 	maybe_unlock_mutex(root);
 	return 0;
 }
@@ -2264,8 +2319,8 @@ static int __btrfs_alloc_reserved_extent
 
 	ret = btrfs_insert_empty_items(trans, extent_root, path, keys,
 				       sizes, 2);
+	BUG_ON(ret);
 
-	BUG_ON(ret);
 	extent_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_extent_item);
 	btrfs_set_extent_refs(path->nodes[0], extent_item, 1);
@@ -2336,9 +2391,9 @@ int btrfs_alloc_logged_extent(struct btr
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
 	cache_block_group(root, block_group);
 
-	clear_extent_dirty(&root->fs_info->free_space_cache,
-			   ins->objectid, ins->objectid + ins->offset - 1,
-			   GFP_NOFS);
+	ret = btrfs_remove_free_space(block_group, ins->objectid, ins->offset);
+	BUG_ON(ret);
+
 	ret = __btrfs_alloc_reserved_extent(trans, root, root_objectid,
 					    ref_generation, owner,
 					    owner_offset, ins);
@@ -2843,31 +2898,24 @@ out:
 
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
-	u64 start;
-	u64 end;
-	u64 ptr;
-	int ret;
+	struct btrfs_block_group_cache *block_group;
+	struct rb_node *n;
 
 	mutex_lock(&info->alloc_mutex);
-	while(1) {
-		ret = find_first_extent_bit(&info->block_group_cache, 0,
-					    &start, &end, (unsigned int)-1);
-		if (ret)
-			break;
-		ret = get_state_private(&info->block_group_cache, start, &ptr);
-		if (!ret)
-			kfree((void *)(unsigned long)ptr);
-		clear_extent_bits(&info->block_group_cache, start,
-				  end, (unsigned int)-1, GFP_NOFS);
+	spin_lock(&info->block_group_cache_lock);
+	while ((n = rb_last(&info->block_group_cache_tree)) != NULL) {
+		block_group = rb_entry(n, struct btrfs_block_group_cache,
+				       cache_node);
+
+		btrfs_remove_free_space_cache(block_group);
+		rb_erase(&block_group->cache_node,
+			 &info->block_group_cache_tree);
+		spin_lock(&block_group->space_info->lock);
+		list_del(&block_group->list);
+		spin_unlock(&block_group->space_info->lock);
+		kfree(block_group);
 	}
-	while(1) {
-		ret = find_first_extent_bit(&info->free_space_cache, 0,
-					    &start, &end, EXTENT_DIRTY);
-		if (ret)
-			break;
-		clear_extent_dirty(&info->free_space_cache, start,
-				   end, GFP_NOFS);
-	}
+	spin_unlock(&info->block_group_cache_lock);
 	mutex_unlock(&info->alloc_mutex);
 	return 0;
 }
@@ -3386,7 +3434,6 @@ int btrfs_shrink_extent_tree(struct btrf
 	u64 total_found;
 	u64 shrink_last_byte;
 	struct btrfs_block_group_cache *shrink_block_group;
-	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
@@ -3542,15 +3589,17 @@ next:
 		goto out;
 	}
 
-	clear_extent_bits(&info->block_group_cache, key.objectid,
-			  key.objectid + key.offset - 1,
-			  (unsigned int)-1, GFP_NOFS);
+	spin_lock(&root->fs_info->block_group_cache_lock);
+	rb_erase(&shrink_block_group->cache_node,
+		 &root->fs_info->block_group_cache_tree);
+	spin_unlock(&root->fs_info->block_group_cache_lock);
 
-
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
@@ -3566,9 +3615,9 @@ next:
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
@@ -3616,16 +3665,13 @@ int btrfs_read_block_groups(struct btrfs
 {
 	struct btrfs_path *path;
 	int ret;
-	int bit;
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *space_info;
-	struct extent_io_tree *block_group_cache;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
 
-	block_group_cache = &info->block_group_cache;
 	root = info->extent_root;
 	key.objectid = 0;
 	key.offset = 0;
@@ -3653,6 +3699,7 @@ int btrfs_read_block_groups(struct btrfs
 		}
 
 		spin_lock_init(&cache->lock);
+		INIT_LIST_HEAD(&cache->list);
 		read_extent_buffer(leaf, &cache->item,
 				   btrfs_item_ptr_offset(leaf, path->slots[0]),
 				   sizeof(cache->item));
@@ -3661,31 +3708,19 @@ int btrfs_read_block_groups(struct btrfs
 		key.objectid = found_key.objectid + found_key.offset;
 		btrfs_release_path(root, path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
-		bit = 0;
-		if (cache->flags & BTRFS_BLOCK_GROUP_DATA) {
-			bit = BLOCK_GROUP_DATA;
-		} else if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			bit = BLOCK_GROUP_SYSTEM;
-		} else if (cache->flags & BTRFS_BLOCK_GROUP_METADATA) {
-			bit = BLOCK_GROUP_METADATA;
-		}
-		set_avail_alloc_bits(info, cache->flags);
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
+		spin_lock(&space_info->lock);
+		list_add(&cache->list, &space_info->block_groups);
+		spin_unlock(&space_info->lock);
 
-		/* use EXTENT_LOCKED to prevent merging */
-		set_extent_bits(block_group_cache, found_key.objectid,
-				found_key.objectid + found_key.offset - 1,
-				EXTENT_LOCKED, GFP_NOFS);
-		set_state_private(block_group_cache, found_key.objectid,
-				  (unsigned long)cache);
-		set_extent_bits(block_group_cache, found_key.objectid,
-				found_key.objectid + found_key.offset - 1,
-				bit | EXTENT_LOCKED, GFP_NOFS);
+		ret = btrfs_add_block_group_cache(root->fs_info, cache);
+		BUG_ON(ret);
+
 		if (key.objectid >=
 		    btrfs_super_total_bytes(&info->super_copy))
 			break;
@@ -3703,22 +3738,22 @@ int btrfs_make_block_group(struct btrfs_
 			   u64 size)
 {
 	int ret;
-	int bit = 0;
 	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
-	struct extent_io_tree *block_group_cache;
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
 	extent_root = root->fs_info->extent_root;
-	block_group_cache = &root->fs_info->block_group_cache;
 
 	root->fs_info->last_trans_new_blockgroup = trans->transid;
 
 	cache = kzalloc(sizeof(*cache), GFP_NOFS);
-	BUG_ON(!cache);
+	if (!cache)
+		return -ENOMEM;
+
 	cache->key.objectid = chunk_offset;
 	cache->key.offset = size;
 	spin_lock_init(&cache->lock);
+	INIT_LIST_HEAD(&cache->list);
 	btrfs_set_key_type(&cache->key, BTRFS_BLOCK_GROUP_ITEM_KEY);
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
@@ -3729,16 +3764,12 @@ int btrfs_make_block_group(struct btrfs_
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
+	spin_lock(&cache->space_info->lock);
+	list_add(&cache->list, &cache->space_info->block_groups);
+	spin_unlock(&cache->space_info->lock);
 
-	bit = block_group_state_bits(type);
-	set_extent_bits(block_group_cache, chunk_offset,
-			chunk_offset + size - 1,
-			EXTENT_LOCKED, GFP_NOFS);
-	set_state_private(block_group_cache, chunk_offset,
-			  (unsigned long)cache);
-	set_extent_bits(block_group_cache, chunk_offset,
-			chunk_offset + size - 1,
-			bit | EXTENT_LOCKED, GFP_NOFS);
+	ret = btrfs_add_block_group_cache(root->fs_info, cache);
+	BUG_ON(ret);
 
 	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
 				sizeof(cache->item));
diff -r 639a8457eb97 extent_io.c
--- a/extent_io.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/extent_io.c	Tue Sep 23 16:33:49 2008 -0400
@@ -2634,6 +2634,7 @@ struct extent_buffer *alloc_extent_buffe
 	if (eb) {
 		atomic_inc(&eb->refs);
 		spin_unlock(&tree->buffer_lock);
+		mark_page_accessed(eb->first_page);
 		return eb;
 	}
 	spin_unlock(&tree->buffer_lock);
@@ -2712,6 +2713,9 @@ struct extent_buffer *find_extent_buffer
 	if (eb)
 		atomic_inc(&eb->refs);
 	spin_unlock(&tree->buffer_lock);
+
+	if (eb)
+		mark_page_accessed(eb->first_page);
 
 	return eb;
 }
diff -r 639a8457eb97 free-space-cache.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/free-space-cache.c	Tue Sep 23 16:33:49 2008 -0400
@@ -0,0 +1,410 @@
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
+static int tree_insert_offset(struct rb_root *root, u64 offset,
+			      struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_free_space *info;
+
+	while (*p) {
+		parent = *p;
+		info = rb_entry(parent, struct btrfs_free_space, offset_index);
+
+		if (offset < info->offset)
+			p = &(*p)->rb_left;
+		else if (offset > info->offset)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return 0;
+}
+
+static int tree_insert_bytes(struct rb_root *root, u64 bytes,
+			     struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_free_space *info;
+
+	while (*p) {
+		parent = *p;
+		info = rb_entry(parent, struct btrfs_free_space, bytes_index);
+
+		if (bytes < info->bytes)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return 0;
+}
+
+/*
+ * searches the tree for the given offset.  If contains is set we will return
+ * the free space that contains the given offset.  If contains is not set we
+ * will return the free space that starts at or after the given offset and is
+ * at least bytes long.
+ */
+static struct btrfs_free_space *tree_search_offset(struct rb_root *root,
+						   u64 offset, u64 bytes,
+						   int contains)
+{
+	struct rb_node *n = root->rb_node;
+	struct btrfs_free_space *entry, *ret = NULL;
+
+	while (n) {
+		entry = rb_entry(n, struct btrfs_free_space, offset_index);
+
+		if (offset < entry->offset) {
+			if (!contains &&
+			    (!ret || entry->offset < ret->offset) &&
+			    (bytes <= entry->bytes))
+				ret = entry;
+			n = n->rb_left;
+		} else if (offset > entry->offset) {
+			if (contains &&
+			    (entry->offset + entry->bytes - 1) >= offset) {
+				ret = entry;
+				break;
+			}
+			n = n->rb_right;
+		} else {
+			if (bytes > entry->bytes) {
+				n = n->rb_right;
+				continue;
+			}
+			ret = entry;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * return a chunk at least bytes size, as close to offset that we can get.
+ */
+static struct btrfs_free_space *tree_search_bytes(struct rb_root *root,
+						  u64 offset, u64 bytes)
+{
+	struct rb_node *n = root->rb_node;
+	struct btrfs_free_space *entry, *ret = NULL;
+
+	while (n) {
+		entry = rb_entry(n, struct btrfs_free_space, bytes_index);
+
+		if (bytes < entry->bytes) {
+			/*
+			 * We prefer to get a hole size as close to the size we
+			 * are asking for so we don't take small slivers out of
+			 * huge holes, but we also want to get as close to the
+			 * offset as possible so we don't have a whole lot of
+			 * fragmentation.
+			 */
+			if (offset <= entry->offset) {
+				if (!ret)
+					ret = entry;
+				else if (entry->bytes < ret->bytes)
+					ret = entry;
+				else if (entry->offset < ret->offset)
+					ret = entry;
+			}
+			n = n->rb_left;
+		} else if (bytes > entry->bytes) {
+			n = n->rb_right;
+		} else {
+			/*
+			 * Ok we may have multiple chunks of the wanted size,
+			 * so we don't want to take the first one we find, we
+			 * want to take the one closest to our given offset, so
+			 * keep searching just in case theres a better match.
+			 */
+			n = n->rb_right;
+			if (offset > entry->offset)
+				continue;
+			else if (!ret || entry->offset < ret->offset)
+				ret = entry;
+		}
+	}
+
+	return ret;
+}
+
+static void unlink_free_space(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *info)
+{
+	rb_erase(&info->offset_index, &block_group->free_space_offset);
+	rb_erase(&info->bytes_index, &block_group->free_space_bytes);
+}
+
+static int link_free_space(struct btrfs_block_group_cache *block_group,
+			   struct btrfs_free_space *info)
+{
+	int ret = 0;
+
+
+	ret = tree_insert_offset(&block_group->free_space_offset, info->offset,
+				 &info->offset_index);
+	if (ret)
+		return ret;
+
+	ret = tree_insert_bytes(&block_group->free_space_bytes, info->bytes,
+				&info->bytes_index);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 offset, u64 bytes)
+{
+	struct btrfs_free_space *right_info, *left_info, *info = NULL;
+	int ret = 0;
+
+	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	if (!info)
+		return -ENOMEM;
+
+	/*
+	 * first we want to see if there is free space adjacent to the range we
+	 * are adding, if there is remove that struct and add a new one to
+	 * cover the entire range
+	 */
+	spin_lock(&block_group->lock);
+
+	right_info = tree_search_offset(&block_group->free_space_offset,
+					offset+bytes, 0, 1);
+	left_info = tree_search_offset(&block_group->free_space_offset,
+				       offset-1, 0, 1);
+
+	if (right_info && right_info->offset == offset+bytes) {
+		unlink_free_space(block_group, right_info);
+		info = right_info;
+		info->offset = offset;
+		info->bytes += bytes;
+	} else if (right_info && right_info->offset != offset+bytes) {
+		printk(KERN_ERR "adding space in the middle of an existing "
+		       "free space area. existing: offset=%Lu, bytes=%Lu. "
+		       "new: offset=%Lu, bytes=%Lu\n", right_info->offset,
+		       right_info->bytes, offset, bytes);
+		BUG();
+	}
+
+	if (left_info) {
+		unlink_free_space(block_group, left_info);
+
+		if (unlikely((left_info->offset + left_info->bytes) !=
+			     offset)) {
+			printk(KERN_ERR "free space to the left of new free "
+			       "space isn't quite right. existing: offset=%Lu,"
+			       " bytes=%Lu. new: offset=%Lu, bytes=%Lu\n",
+			       left_info->offset, left_info->bytes, offset,
+			       bytes);
+			BUG();
+		}
+
+		if (info) {
+			info->offset = left_info->offset;
+			info->bytes += left_info->bytes;
+			kfree(left_info);
+		} else {
+			info = left_info;
+			info->bytes += bytes;
+		}
+	}
+
+	if (info) {
+		ret = link_free_space(block_group, info);
+		if (!ret)
+			info = NULL;
+		goto out;
+	}
+
+	info->offset = offset;
+	info->bytes = bytes;
+
+	ret = link_free_space(block_group, info);
+	if (!ret)
+		info = NULL;
+out:
+	spin_unlock(&block_group->lock);
+	if (ret) {
+		printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
+		if (ret == -EEXIST)
+			BUG();
+	}
+
+	if (info)
+		kfree(info);
+
+	return ret;
+}
+
+int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
+			    u64 offset, u64 bytes)
+{
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	spin_lock(&block_group->lock);
+	info = tree_search_offset(&block_group->free_space_offset, offset, 0,
+				  1);
+
+	if (info && info->offset == offset) {
+		if (info->bytes < bytes) {
+			printk(KERN_ERR "Found free space at %Lu, size %Lu,"
+			       "trying to use %Lu\n",
+			       info->offset, info->bytes, bytes);
+			WARN_ON(1);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		unlink_free_space(block_group, info);
+
+		if (info->bytes == bytes) {
+			kfree(info);
+			goto out;
+		}
+
+		info->offset += bytes;
+		info->bytes -= bytes;
+
+		ret = link_free_space(block_group, info);
+		BUG_ON(ret);
+	} else {
+		WARN_ON(1);
+	}
+out:
+	spin_unlock(&block_group->lock);
+	return ret;
+}
+
+void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
+			   u64 bytes)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *n;
+	int count = 0;
+
+	for (n = rb_first(&block_group->free_space_offset); n; n = rb_next(n)) {
+		info = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (info->bytes >= bytes)
+			count++;
+		//printk(KERN_INFO "offset=%Lu, bytes=%Lu\n", info->offset,
+		//       info->bytes);
+	}
+	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
+	       "\n", count);
+}
+
+u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *n;
+	u64 ret = 0;
+
+	for (n = rb_first(&block_group->free_space_offset); n;
+	     n = rb_next(n)) {
+		info = rb_entry(n, struct btrfs_free_space, offset_index);
+		ret += info->bytes;
+	}
+
+	return ret;
+}
+
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *node;
+
+	spin_lock(&block_group->lock);
+	while ((node = rb_last(&block_group->free_space_bytes)) != NULL) {
+		info = rb_entry(node, struct btrfs_free_space, bytes_index);
+		unlink_free_space(block_group, info);
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
+struct btrfs_free_space *btrfs_find_free_space_offset(struct
+						      btrfs_block_group_cache
+						      *block_group, u64 offset,
+						      u64 bytes)
+{
+	struct btrfs_free_space *ret;
+
+	spin_lock(&block_group->lock);
+	ret = tree_search_offset(&block_group->free_space_offset, offset,
+				 bytes, 0);
+	spin_unlock(&block_group->lock);
+
+	return ret;
+}
+
+struct btrfs_free_space *btrfs_find_free_space_bytes(struct
+						     btrfs_block_group_cache
+						     *block_group, u64 offset,
+						     u64 bytes)
+{
+	struct btrfs_free_space *ret;
+
+	spin_lock(&block_group->lock);
+
+	ret = tree_search_bytes(&block_group->free_space_bytes, offset, bytes);
+	spin_unlock(&block_group->lock);
+
+	return ret;
+}
+
+struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
+					       *block_group, u64 offset,
+					       u64 bytes)
+{
+	struct btrfs_free_space *ret;
+
+	spin_lock(&block_group->lock);
+	ret = tree_search_offset(&block_group->free_space_offset, offset,
+				 bytes, 0);
+	if (!ret)
+		ret = tree_search_bytes(&block_group->free_space_bytes,
+					offset, bytes);
+
+	spin_unlock(&block_group->lock);
+
+	return ret;
+}
diff -r 639a8457eb97 inode.c
--- a/inode.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/inode.c	Tue Sep 23 16:33:49 2008 -0400
@@ -141,7 +141,7 @@ static int cow_file_range(struct inode *
 	while(num_bytes > 0) {
 		cur_alloc_size = min(num_bytes, root->fs_info->max_extent);
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
-					   root->sectorsize, 0, 0,
+					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
 			WARN_ON(1);
@@ -558,7 +558,6 @@ static int btrfs_finish_ordered_io(struc
 					  trans->transid, inode->i_ino,
 					  ordered_extent->file_offset, &ins);
 	BUG_ON(ret);
-
 	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 
 	ret = btrfs_drop_extents(trans, root, inode,
diff -r 639a8457eb97 volumes.c
--- a/volumes.c	Wed Sep 17 20:50:33 2008 -0400
+++ b/volumes.c	Tue Sep 23 16:33:49 2008 -0400
@@ -64,8 +64,8 @@ static void lock_chunks(struct btrfs_roo
 
 static void unlock_chunks(struct btrfs_root *root)
 {
+	mutex_unlock(&root->fs_info->chunk_mutex);
 	mutex_unlock(&root->fs_info->alloc_mutex);
-	mutex_unlock(&root->fs_info->chunk_mutex);
 }
 
 int btrfs_cleanup_fs_uuids(void)
@@ -1668,8 +1668,13 @@ again:
 	else
 		min_free = calc_size;
 
-	/* we add 1MB because we never use the first 1MB of the device */
-	min_free += 1024 * 1024;
+	/*
+	 * we add 1MB because we never use the first 1MB of the device, unless
+	 * we've looped, then we are likely allocating the maximum amount of
+	 * space left already
+	 */
+	if (!looped)
+		min_free += 1024 * 1024;
 
 	/* build a private list of devices we will allocate from */
 	while(index < num_stripes) {

