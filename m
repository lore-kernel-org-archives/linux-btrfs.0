From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs: New inode number allocator
Date: Wed, 26 Jan 2011 09:53:00 +0800
Message-ID: <4D3F7E7C.6080903@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(WARNING: this patch is not completed or well-tested)

We used to allocate inode number by searching through inode items, but 
it made the allocation slower and slower as more and more files created.

The current code just records the highest objectid in the btree without
reusing old inode numbers, which will make the filesystem run out of
inode number as we create/delete files.

In this patch, free inode numbers are stored in the fs tree with key:

	[start, BTRFS_INO_EXTENT_KEY, end]

@start is the first free inode number in the extent, while @end is the
last one.

To group those ino extents together, they are actually stored as:

	[start+OFFSET, BTRFS_INO_EXTENT_KEY, end+OFFSET]

(OFFSET == 263)

At start-up we read some of the ino extents from disk, so in most of the cases
we just manipulate the in-memory cache when creating/deleting files, and we
update (modify, del, insert) ino extents at transaction commit. We'll also
do the updates when the cache grows big.

Here comes the compatability issue. It's fine to mount old btrfs, because
we'll just use the original way to find free ino. But we can't mount new btrfs
in older kernels, because the OFFSET makes highest objectid overflow when it
is cast to unsigned long in 32bits system.

We can store ino extents to a seperate btree, and then the new btrfs can
be mounted in older kernels, but another problem will arise when remounting it
in new kernels - creating new files will probably fail (but not oops)
because the ino extent items are not consistent with inode items.

If the above behavior (failing to create files) is not acceptable, we'll
have to add an incompat flag.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   12 +-
 fs/btrfs/disk-io.c     |    5 +
 fs/btrfs/inode-map.c   |  610 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/inode-map.h   |   39 +++
 fs/btrfs/inode.c       |   67 ++++--
 fs/btrfs/ioctl.c       |    3 +-
 fs/btrfs/transaction.c |    5 +
 7 files changed, 714 insertions(+), 27 deletions(-)
 create mode 100644 fs/btrfs/inode-map.h

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af52f6d..bcf9150 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -31,6 +31,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "inode-map.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -1132,6 +1133,8 @@ struct btrfs_root {
 	/* red-black tree that keeps track of in-memory inodes */
 	struct rb_root inode_tree;
 
+	struct btrfs_ialloc_tree *ialloc_tree;
+
 	/*
 	 * right now this just gets used so that a root has its own devid
 	 * for stat.  It may be used for more later
@@ -1214,6 +1217,9 @@ struct btrfs_root {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_INO_EXTENT_KEY  230
+
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
@@ -2357,12 +2363,6 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 offset);
 int btrfs_find_orphan_item(struct btrfs_root *root, u64 offset);
 
-/* inode-map.c */
-int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *fs_root,
-			     u64 dirid, u64 *objectid);
-int btrfs_find_highest_inode(struct btrfs_root *fs_root, u64 *objectid);
-
 /* inode-item.c */
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a5d2249..9a4d7df 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2019,6 +2019,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_trans_kthread;
 	}
 
+	err = btrfs_ialloc_init(fs_info->fs_root);
+	if (err)
+		goto fail_trans_kthread;
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_read(&fs_info->cleanup_work_sem);
 		btrfs_orphan_cleanup(fs_info->fs_root);
@@ -2357,6 +2361,7 @@ static void free_fs_root(struct btrfs_root *root)
 	}
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
+	btrfs_ialloc_destroy(root);
 	kfree(root->name);
 	kfree(root);
 }
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index c56eb59..6d10150 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -16,10 +16,584 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/slab.h>
+#include <linux/rbtree.h>
+#include <linux/pagemap.h>
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 
+/*
+ * ino_extent items are stored in file tree, and in order to group
+ * those items together, we add a really big offset to the actual
+ * inode number.
+ */
+
+static inline u64 __objectid(u64 ino)
+{
+	return ino + (1ULL << 63);
+}
+
+static inline u64 __ino(u64 objectid)
+{
+	return objectid - (1ULL << 63);
+}
+
+struct tree_entry {
+	struct rb_node rb_node;
+	u64 start;
+	u64 end;
+};
+
+#define MAX_ITEMS(r)	(BTRFS_LEAF_DATA_SIZE(r) / sizeof(struct btrfs_item))
+
+/*
+ * tree_lookup - find out the entry that contains the specified ino
+ * @root: search from which rb-tree
+ * @ino: the ino in question
+ */
+static struct tree_entry *tree_lookup(struct rb_root *root, u64 ino)
+{
+	struct rb_node *n = root->rb_node;
+	struct tree_entry *entry;
+
+	while (n) {
+		entry = rb_entry(n, struct tree_entry, rb_node);
+
+		if (ino < entry->start)
+			n = n->rb_left;
+		else if (ino > entry->end)
+			n = n->rb_right;
+		else
+			return entry;
+	}
+	return NULL;
+}
+
+/*
+ * The parent must be the left-most or right-most item of [start, end],
+ * and the merge algorithm bases on this fact.
+ */
+static int merge_entry(struct rb_root *root, struct rb_node *parent,
+		       u64 start, u64 end)
+{
+	struct tree_entry *prev = NULL;
+	struct tree_entry *next = NULL;
+	struct tree_entry *entry;
+	struct rb_node *n;
+	int merged = 0;
+
+	if (!parent)
+		return 0;
+	entry = rb_entry(parent, struct tree_entry, rb_node);
+
+	if (entry->start < start) {
+		prev = entry;
+		n = rb_next(&prev->rb_node);
+		if (n)
+			next = rb_entry(n, struct tree_entry, rb_node);
+	} else {
+		next = entry;
+		n = rb_prev(&next->rb_node);
+		if (n)
+			prev = rb_entry(n, struct tree_entry, rb_node);
+	}
+
+	if (prev && prev->end + 1 == start) {
+		prev->end = end;
+		merged++;
+	}
+
+	if (next && end + 1 == next->start) {
+		if (merged) {
+			prev->end = next->end;
+			rb_erase(&next->rb_node, root);
+			kfree(next);
+		} else
+			next->start = start;
+		merged++;
+	}
+
+	return merged;
+}
+
+/*
+ * We'll firstly try to merge the extent into existing items in the tree.
+ *
+ * The return value means the change in number of items in the tree.
+ */
+static int tree_add_entry(struct rb_root *root, u64 start, u64 end)
+{
+	struct tree_entry *entry;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct tree_entry, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	ret = merge_entry(root, parent, start, end);
+	if (ret == 1)
+		return 0;
+	else if (ret == 2)
+		return -1;
+
+	entry = kmalloc(sizeof(*entry), GFP_NOFS | __GFP_NOFAIL);
+	entry->start = start;
+	entry->end = end;
+
+	rb_link_node(&entry->rb_node, parent, p);
+	rb_insert_color(&entry->rb_node, root);
+
+	return 1;
+}
+
+static int __btrfs_ialloc_run_updates(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *fs_root);
+static int __btrfs_ialloc_read_extents(struct btrfs_root *root);
+
+static int find_free_inode(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct btrfs_ialloc_tree *tree, u64 *ino)
+{
+	struct tree_entry *entry;
+	struct rb_node *n;
+	bool flag = false;
+	int ret;
+
+	mutex_lock(&tree->mutex);
+
+	n = rb_first(&tree->freed);
+again:
+	if (n) {
+		entry = rb_entry(n, struct tree_entry, rb_node);
+		*ino = entry->start;
+
+		if (entry->start != entry->end)
+			entry->start++;
+		else {
+			if (!flag) {
+				rb_erase(n, &tree->freed);
+				tree->num_freed_items -= 1;
+			} else {
+				rb_erase(n, &tree->cache);
+				tree->num_cache_items -= 1;
+			}
+			kfree(entry);
+		}
+
+		if (flag) {
+			ret = tree_add_entry(&tree->allocated, *ino, *ino);
+			tree->num_allocated_items += ret;
+
+			if (tree->num_allocated_items > MAX_ITEMS(root))
+				__btrfs_ialloc_run_updates(trans, root);
+		}
+
+		mutex_unlock(&tree->mutex);
+		return 0;
+	}
+
+	if (!flag) {
+		flag = true;
+		n = rb_first(&tree->cache);
+		goto again;
+	}
+
+	__btrfs_ialloc_run_updates(trans, root);
+	ret = __btrfs_ialloc_read_extents(root);
+	if (!ret) {
+		BUG_ON(RB_EMPTY_ROOT(&tree->cache));
+		n = rb_first(&tree->cache);
+		goto again;
+	}
+
+	mutex_unlock(&tree->mutex);
+	return ret;
+}
+
+static int release_ino(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       struct btrfs_ialloc_tree *tree, u64 ino)
+{
+	struct tree_entry *entry;
+	int ret;
+
+	mutex_lock(&tree->mutex);
+
+	entry = tree_lookup(&tree->allocated, ino);
+	if (!entry) {
+		ret = tree_add_entry(&tree->freed, ino, ino);
+		tree->num_freed_items += ret;
+		goto out;
+	}
+
+	ret = tree_add_entry(&tree->cache, ino, ino);
+
+	tree->num_cache_items += ret;
+
+	if (ino == entry->start && ino == entry->end) {
+		rb_erase(&entry->rb_node, &tree->allocated);
+		kfree(entry);
+		tree->num_allocated_items--;
+	} else if (ino == entry->start) {
+		entry->start++;
+	}
+	else if (ino == entry->end) {
+		entry->end--;
+	}
+	else {
+		u64 end = entry->end;
+
+		entry->end = ino - 1;
+		ret = tree_add_entry(&tree->allocated, ino + 1, end);
+		tree->num_allocated_items += ret;
+	}
+
+out:
+	if (tree->num_freed_items > MAX_ITEMS(root) ||
+	    tree->num_allocated_items > MAX_ITEMS(root))
+		__btrfs_ialloc_run_updates(trans, root);
+
+	mutex_unlock(&tree->mutex);
+	return 0;
+}
+
+static void tree_free(struct rb_root *root)
+{
+	struct tree_entry *entry;
+	struct rb_node *n;
+
+	while (1) {
+		n = rb_first(root);
+		if (!n)
+			break;
+		entry = rb_entry(n, struct tree_entry, rb_node);
+		rb_erase(n, root);
+		kfree(entry);
+	}
+}
+
+int btrfs_ialloc_init(struct btrfs_root *root)
+{
+	struct btrfs_ialloc_tree *tree;
+
+	tree = kzalloc(sizeof(*tree), GFP_NOFS);
+	if (!tree)
+		return -ENOMEM;
+
+	tree->cache = RB_ROOT;
+	tree->allocated = RB_ROOT;
+	tree->freed = RB_ROOT;
+	mutex_init(&tree->mutex);
+
+	root->ialloc_tree = tree;
+
+	return 0;
+}
+
+static int __btrfs_ialloc_read_extents(struct btrfs_root *root)
+{
+	struct btrfs_ialloc_tree *tree = root->ialloc_tree;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	int ret;
+	struct extent_buffer *l;
+	int slot;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		kfree(tree);
+		return -ENOMEM;
+	}
+
+	key.objectid = __objectid(BTRFS_FIRST_FREE_OBJECTID);
+	key.type = BTRFS_INO_EXTENT_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(!ret);
+
+	while (1) {
+		l = path->nodes[0];
+		slot = path->slots[0];
+
+		if (path->slots[0] >= btrfs_header_nritems(l)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret == 0)
+				continue;
+			if (ret < 0) {
+				ret = 0;
+				goto out;
+			}
+			break;
+		}
+
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (key.type != BTRFS_INO_EXTENT_KEY)
+			break;
+
+		ret = tree_add_entry(&tree->cache, __ino(key.objectid),
+				     __ino(key.offset));
+		if (ret < 0) {
+			tree_free(&tree->cache);
+			goto out;
+		}
+
+		tree->num_cache_items += ret;
+
+		if (tree->num_cache_items > MAX_ITEMS(root))
+			break;
+
+		path->slots[0]++;
+	}
+	ret = 0;
+
+	if (tree->num_cache_items == 0)
+		ret = -ENOSPC;
+
+	btrfs_free_path(path);
+	return 0;
+out:
+	btrfs_free_path(path);
+	kfree(tree);
+	return ret;
+}
+
+int btrfs_ialloc_read_extents(struct btrfs_root *root)
+{
+	int ret;
+
+	mutex_lock(&root->ialloc_tree->mutex);
+	ret = __btrfs_ialloc_read_extents(root);
+	mutex_unlock(&root->ialloc_tree->mutex);
+
+	return ret;
+}
+
+void btrfs_ialloc_destroy(struct btrfs_root *fs_root)
+{
+	struct btrfs_ialloc_tree *tree = fs_root->ialloc_tree;
+
+	if (!tree)
+		return;
+
+	WARN_ON(!RB_EMPTY_ROOT(&tree->freed));
+	WARN_ON(!RB_EMPTY_ROOT(&tree->allocated));
+
+	tree_free(&tree->cache);
+	kfree(tree);
+}
+
+static int update_allocated_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *fs_root,
+				 struct tree_entry *entry)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found;
+	struct extent_buffer *l;
+	int slot;
+	int ret;
+
+	key.objectid = __objectid(entry->start);
+	key.offset = -1ULL;
+	key.type = BTRFS_INO_EXTENT_KEY;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = -1;
+
+	ret = btrfs_search_slot(trans, fs_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = btrfs_previous_item(fs_root, path, 0, key.type);
+	if (ret < 0)
+		goto out;
+	else if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	l = path->nodes[0];
+	slot = path->slots[0];
+
+	btrfs_item_key_to_cpu(l, &found, slot);
+	BUG_ON(found.type != BTRFS_INO_EXTENT_KEY);
+
+	if (__objectid(entry->start) == found.objectid &&
+	    __objectid(entry->end) == found.offset) {
+		ret = btrfs_del_item(trans, fs_root, path);
+		BUG_ON(ret);
+	} else if (__objectid(entry->start) == found.objectid) {
+		BUG_ON(found.offset < entry->end);
+		found.objectid = __objectid(entry->end + 1);
+		btrfs_set_item_key_safe(trans, fs_root, path, &found);
+	} else if (__objectid(entry->end) == found.offset) {
+		BUG_ON(entry->start > found.objectid);
+		found.offset = __objectid(entry->start - 1);
+		btrfs_set_item_key_safe(trans, fs_root, path, &found);
+	} else {
+		key.objectid = __objectid(entry->end + 1);
+		key.offset = found.offset;
+
+		found.offset = __objectid(entry->start - 1);
+		btrfs_set_item_key_safe(trans, fs_root, path, &found);
+		btrfs_release_path(fs_root, path);
+
+		ret = btrfs_insert_empty_item(trans, fs_root, path, &key, 0);
+		BUG_ON(ret);
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int write_freed_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *fs_root,
+			     struct tree_entry *entry)
+{
+	int ret;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key prev_key;
+	struct extent_buffer *l;
+	int slot;
+	bool merged = false;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = __objectid(entry->start);
+	key.type = BTRFS_INO_EXTENT_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, fs_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+
+	l = path->nodes[0];
+	slot = path->slots[0];
+
+	/* Try to merge the entry into the item that is bigger than it */
+	if (slot < btrfs_header_nritems(l)) {
+		btrfs_item_key_to_cpu(l, &key, slot);
+		if (key.type == BTRFS_INO_EXTENT_KEY &&
+		    key.objectid == __objectid(entry->end + 1)) {
+			merged = true;
+			key.objectid = __objectid(entry->start);
+			btrfs_set_item_key_safe(trans, fs_root, path, &key);
+		}
+	}
+
+	/* Try to merge the entry into the item that is smaller than it */
+	if (slot > 0) {
+		btrfs_item_key_to_cpu(l, &prev_key, slot - 1);
+		if (prev_key.type == BTRFS_INO_EXTENT_KEY &&
+		    prev_key.offset == __objectid(entry->start - 1)) {
+			if (!merged) {
+				merged = true;
+				path->slots[0]--;
+				prev_key.offset = __objectid(entry->end);
+				btrfs_set_item_key_safe(trans, fs_root, path,
+							&prev_key);
+			} else {
+				path->slots[0]--;
+				prev_key.offset = key.offset;
+				btrfs_set_item_key_safe(trans, fs_root, path,
+							&prev_key);
+				path->slots[0]++;
+				ret = btrfs_del_item(trans, fs_root, path);
+				BUG_ON(ret);
+			}
+		}
+	}
+
+	if (!merged) {
+		btrfs_release_path(fs_root, path);
+
+		key.objectid = __objectid(entry->start);
+		key.type = BTRFS_INO_EXTENT_KEY;
+		key.offset = __objectid(entry->end);
+		ret = btrfs_insert_empty_item(trans, fs_root, path, &key, 0);
+		BUG_ON(ret);
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int __btrfs_ialloc_run_updates(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *fs_root)
+{
+	struct btrfs_ialloc_tree *tree = fs_root->ialloc_tree;
+	struct rb_node *n;
+	struct tree_entry *entry;
+	struct btrfs_key key;
+	int ret = 0;
+
+	while (1) {
+		n = rb_first(&tree->allocated);
+		if (!n)
+			break;
+		entry = rb_entry(n, struct tree_entry, rb_node);
+
+		update_allocated_item(trans, fs_root, entry);
+
+		rb_erase(n, &tree->allocated);
+		kfree(entry);
+	}
+
+	while (1) {
+		n = rb_first(&tree->freed);
+		if (!n)
+			break;
+		entry = rb_entry(n, struct tree_entry, rb_node);
+
+		key.objectid = __objectid(entry->start);
+		key.offset = __objectid(entry->end);
+		key.type = BTRFS_INO_EXTENT_KEY;
+
+		write_freed_item(trans, fs_root, entry);
+
+		rb_erase(n, &tree->freed);
+		kfree(entry);
+	}
+
+	tree->num_allocated_items = 0;
+	tree->num_freed_items = 0;
+
+	return ret;
+}
+
+int btrfs_ialloc_run_updates(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *fs_root)
+{
+	if (!fs_root->ialloc_tree)
+		return 0;
+
+	mutex_lock(&fs_root->ialloc_tree->mutex);
+	__btrfs_ialloc_run_updates(trans, fs_root);
+	mutex_unlock(&fs_root->ialloc_tree->mutex);
+	return 0;
+}
+
 int btrfs_find_highest_inode(struct btrfs_root *root, u64 *objectid)
 {
 	struct btrfs_path *path;
@@ -54,11 +628,18 @@ error:
 	return ret;
 }
 
-int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     u64 dirid, u64 *objectid)
+int btrfs_ialloc_release_ino(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, unsigned long ino)
+{
+	return release_ino(trans, root, root->ialloc_tree, ino);
+}
+
+static int __btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 dirid, u64 *objectid)
 {
 	int ret;
+
 	mutex_lock(&root->objectid_mutex);
 
 	if (unlikely(root->highest_objectid < BTRFS_FIRST_FREE_OBJECTID)) {
@@ -78,3 +659,26 @@ out:
 	mutex_unlock(&root->objectid_mutex);
 	return ret;
 }
+
+int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     u64 dirid, u64 *objectid)
+{
+	if (!root->ialloc_tree)
+		return __btrfs_find_free_objectid(trans, root, dirid,
+						  objectid);
+
+	return find_free_inode(trans, root, root->ialloc_tree, objectid);
+}
+
+int btrfs_ialloc_insert_init_extent(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *fs_root)
+{
+	struct btrfs_key key;
+
+	key.objectid = __objectid(BTRFS_FIRST_FREE_OBJECTID + 1);
+	key.type = BTRFS_INO_EXTENT_KEY;
+	key.offset = BTRFS_LAST_FREE_OBJECTID;
+
+	return btrfs_insert_item(trans, fs_root, &key, NULL, 0);
+}
diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
new file mode 100644
index 0000000..56225c5
--- /dev/null
+++ b/fs/btrfs/inode-map.h
@@ -0,0 +1,39 @@
+#ifndef __INODE_MAP__
+#define __INODE_MAP__
+
+#include <linux/rbtree.h>
+#include <linux/mutex.h>
+
+struct btrfs_ialloc_tree {
+	struct rb_root cache;
+	struct rb_root allocated;
+	struct rb_root freed;
+	struct mutex mutex;
+
+	int num_cache_items;
+	int num_allocated_items;
+	int num_freed_items;
+
+	int num_metadata_reserved;
+};
+
+struct btrfs_root;
+struct btrfs_trans_handle;
+
+int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *fs_root,
+			     u64 dirid, u64 *objectid);
+int btrfs_find_highest_inode(struct btrfs_root *fs_root, u64 *objectid);
+int btrfs_ialloc_release_ino(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, unsigned long ino);
+
+int btrfs_ialloc_init(struct btrfs_root *fs_root);
+void btrfs_ialloc_destroy(struct btrfs_root *fs_root);
+
+int btrfs_ialloc_run_updates(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *fs_root);
+
+int btrfs_ialloc_insert_init_extent(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *fs_root);
+
+#endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f91944..cd51fa1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3751,6 +3751,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 	}
 
+	btrfs_ialloc_release_ino(trans, root, inode->i_ino);
+
 	if (ret == 0) {
 		ret = btrfs_orphan_del(trans, inode);
 		BUG_ON(ret);
@@ -4486,6 +4488,12 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * we have to initialize this here, so if we fail afterwards
+	 * we'll able to reclaim this inode number.
+	 */
+	inode->i_ino = objectid;
+
 	if (dir) {
 		ret = btrfs_set_inode_index(dir, index);
 		if (ret) {
@@ -4493,6 +4501,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 			return ERR_PTR(ret);
 		}
 	}
+
 	/*
 	 * index_cnt is ignored for everything but a dir,
 	 * btrfs_get_inode_index_count has an explanation for the magic
@@ -4528,7 +4537,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		goto fail;
 
 	inode_init_owner(inode, dir, mode);
-	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -4653,10 +4661,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
-
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
@@ -4666,6 +4670,12 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
+	if (err) {
+		btrfs_end_transaction(trans, root);
+		return err;
+	}
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
@@ -4715,9 +4725,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
@@ -4727,6 +4734,12 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
+	if (err) {
+		btrfs_end_transaction(trans, root);
+		return err;
+	}
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
@@ -4763,6 +4776,7 @@ out_unlock:
 		iput(inode);
 	}
 	btrfs_btree_balance_dirty(root, nr);
+
 	return err;
 }
 
@@ -4839,10 +4853,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
-
 	/*
 	 * 2 items for inode and ref
 	 * 2 items for dir items
@@ -4851,6 +4861,13 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
+
+	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
+	if (err) {
+		btrfs_end_transaction(trans, root);
+		return err;
+	}
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
@@ -6419,10 +6436,20 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	int err;
 	u64 index = 0;
 
+	err = btrfs_ialloc_init(new_root);
+	if (err)
+		return err;
+
+	err = btrfs_ialloc_insert_init_extent(trans, new_root);
+	if (err)
+		goto fail;
+
 	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
 				new_dirid, alloc_hint, S_IFDIR | 0700, &index);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto fail;
+	}
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
 
@@ -6434,6 +6461,9 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 
 	iput(inode);
 	return 0;
+fail:
+	btrfs_ialloc_destroy(new_root);
+	return err;
 }
 
 /* helper function for file defrag and space balancing.  This
@@ -6917,9 +6947,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_find_free_objectid(NULL, root, dir->i_ino, &objectid);
-	if (err)
-		return err;
 	/*
 	 * 2 items for inode item and ref
 	 * 2 items for dir items
@@ -6929,6 +6956,12 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
+	if (err) {
+		btrfs_end_transaction(trans, root);
+		return err;
+	}
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f87552a..a59cabf 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -255,8 +255,9 @@ static noinline int create_subvol(struct btrfs_root *root,
 	 * 2 - refs
 	 * 1 - root item
 	 * 2 - dir items
+	 * 1 - ino_extent item
 	 */
-	trans = btrfs_start_transaction(root, 6);
+	trans = btrfs_start_transaction(root, 7);
 	if (IS_ERR(trans)) {
 		dput(parent);
 		return PTR_ERR(trans);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f50e931..5043a83 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -748,6 +748,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			btrfs_update_reloc_root(trans, root);
 			btrfs_orphan_commit_root(trans, root);
 
+			btrfs_ialloc_run_updates(trans, root);
+
 			if (root->commit_root != root->node) {
 				switch_commit_root(root);
 				btrfs_set_root_node(&root->root_item,
@@ -997,6 +999,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
 	BUG_ON(IS_ERR(pending->snap));
 
+	ret = btrfs_ialloc_init(pending->snap);
+	BUG_ON(ret);
+
 	btrfs_reloc_post_snapshot(trans, pending);
 	btrfs_orphan_post_snapshot(trans, pending);
 fail:
-- 1.6.3 
