From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 4/4] btrfs: implement delayed dir index insertion and
 deletion
Date: Wed, 01 Dec 2010 16:09:35 +0800
Message-ID: <4CF602BF.7010805@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Compare with Ext3/4, the performance of file creation and deletion on btrfs
is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
such as inode item, directory name item, directory name index and so on.

If we can do some delayed b+ tree insertion or deletion, we can improve the
performance, so we made this patch which implemented delayed directory name
index insertion and deletion.

Implementation:
- Every transaction has two rb-tree, one is used to manage the directory name
  index which is going to be inserted into b+ tree, and the other is used to
  manage the directory name index which is going to be deleted from b+ tree.
- When we want to insert a directory name index into b+ tree, we just add the
  information into the inserting rb-tree.
  And when the number of directory name index touches the upper limit (The max
  number of the directory name index that can be stored in a leaf), we start
  inserting manipulation and insert those directory name index into the b+ tree.
- When we want to delete a directory name index from the b+ tree, we search it
  in the inserting rb-tree at first. If we look it up, just drop it. If not,
  add the key of it into the deleting rb-tree.
  Similar to the inserting rb-tree, the number of directory name index touches
  the upper limit, we start deleting manipulation and delete those directory
  name index from the b+ tree.
- If we want to commit transaction, we do inserting/deleting manipulation and
  insert/delete all the directory name indexs which are in the rb-tree
  into/from the b+ tree.
- when we want to read directory entry, we will do deleting manipulation and
  delete all the directory name indexs of the file/directory it contains from
  the b+ tree. And then read directory entries in the b+ tree. At the end read
  directory entries which is in the inserting rb-tree.

I did a quick test by the benchmark tool[1] and found we can improve the
performance of file creation by ~9%, and file deletion by ~13%.

Before applying this patch:
Create files:
	Total files: 50000
	Total time: 1.188547
	Average time: 0.000024
Delete files:
	Total files: 50000
	Total time: 1.662012
	Average time: 0.000033

After applying this patch:
Create files:
	Total files: 50000
	Total time: 1.083526
	Average time: 0.000022
Delete files:
	Total files: 50000
	Total time: 1.439360
	Average time: 0.000029

[1] http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 +
 fs/btrfs/ctree.c             |   13 +-
 fs/btrfs/ctree.h             |   15 +-
 fs/btrfs/delayed-dir-index.c |  790 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-dir-index.h |   92 +++++
 fs/btrfs/dir-item.c          |   24 +-
 fs/btrfs/extent-tree.c       |   21 ++
 fs/btrfs/inode.c             |   80 +++--
 fs/btrfs/transaction.c       |    9 +
 fs/btrfs/transaction.h       |    2 +
 11 files changed, 995 insertions(+), 55 deletions(-)
 create mode 100644 fs/btrfs/delayed-dir-index.c
 create mode 100644 fs/btrfs/delayed-dir-index.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..1f7696a 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o delayed-dir-index.o
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6ad63f1..3d03a17 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -162,6 +162,8 @@ struct btrfs_inode {
 	struct inode vfs_inode;
 };
 
+extern unsigned char btrfs_filetype_table[];
+
 static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 {
 	return container_of(inode, struct btrfs_inode, vfs_inode);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9ac1715..08f4339 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,10 +38,6 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *src_buf);
 static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
-static int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct btrfs_path *path,
-			struct btrfs_key *cpu_key, u32 *data_size,
-			u32 total_data, u32 total_size, int nr);
 
 
 struct btrfs_path *btrfs_alloc_path(void)
@@ -3680,11 +3676,10 @@ out:
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-static noinline_for_stack int
-setup_items_for_insert(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
-		      struct btrfs_key *cpu_key, u32 *data_size,
-		      u32 total_data, u32 total_size, int nr)
+int setup_items_for_insert(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_key *cpu_key, u32 *data_size,
+			   u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_item *item;
 	int i;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5c44cf4..84eab48 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -870,7 +870,10 @@ struct btrfs_fs_info {
 	/* logical->physical extent mapping */
 	struct btrfs_mapping_tree mapping_tree;
 
-	/* block reservation for extent, checksum and root tree */
+	/*
+	 * block reservation for extent, checksum, root tree and
+	 * delayed dir index item
+	 */
 	struct btrfs_block_rsv global_block_rsv;
 	/* block reservation for delay allocation */
 	struct btrfs_block_rsv delalloc_block_rsv;
@@ -2163,6 +2166,12 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
+int btrfs_delayed_dir_index_reserve_metadata(struct btrfs_trans_handle *trans,
+					     struct btrfs_root *root,
+					     int num_items);
+void btrfs_delayed_dir_index_release_metadata(struct btrfs_trans_handle *trans,
+					      struct btrfs_root *root,
+					      int num_items);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
 void btrfs_free_block_rsv(struct btrfs_root *root,
@@ -2254,6 +2263,10 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
+int setup_items_for_insert(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_key *cpu_key, u32 *data_size,
+			   u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-dir-index.c b/fs/btrfs/delayed-dir-index.c
new file mode 100644
index 0000000..ae3cc2e
--- /dev/null
+++ b/fs/btrfs/delayed-dir-index.c
@@ -0,0 +1,790 @@
+#include "ctree.h"
+#include "disk-io.h"
+#include "transaction.h"
+
+struct btrfs_delayed_node *btrfs_alloc_delayed_node(int data_len)
+{
+	struct btrfs_delayed_node *node;
+	node = kmalloc(sizeof(*node) + data_len, GFP_NOFS | __GFP_NOFAIL);
+	if (node)
+		node->data_len = data_len;
+	return node;
+}
+
+void btrfs_release_delayed_node(struct btrfs_delayed_node *node)
+{
+	kfree(node);
+}
+
+void btrfs_init_delayed_dir_index_root(
+		struct btrfs_delayed_dir_index_root *delayed_dir_index_root)
+{
+	delayed_dir_index_root->delayed_ins_root.count = 0;
+	delayed_dir_index_root->delayed_ins_root.rb_root = RB_ROOT;
+	delayed_dir_index_root->delayed_del_root.count = 0;
+	delayed_dir_index_root->delayed_del_root.rb_root = RB_ROOT;
+	mutex_init(&delayed_dir_index_root->mutex);
+}
+
+static int comp_nodes(struct btrfs_delayed_key *key1,
+		      struct btrfs_delayed_key *key2)
+{
+	if (key1->root_id > key2->root_id)
+		return 1;
+	else if (key1->root_id < key2->root_id)
+		return -1;
+
+	return btrfs_comp_cpu_keys(&key1->item_key, &key2->item_key);
+}
+
+/*
+ * __btrfs_lookup_delayed_node - look up the delayed tree operation node by key
+ * @delayed_root: pointer of the delayed tree operation root
+ * @key:	  the key to search
+ * @prev:	  used to store the prev node if the right node isn't found
+ * @next:	  used to store the next node if the right node isn't found
+ *
+ * Note: if we don't find the right node, we will return the prev node and
+ *       next node.
+ */
+static struct btrfs_delayed_node *__btrfs_lookup_delayed_node(
+				struct btrfs_delayed_root *delayed_root,
+				struct btrfs_delayed_key *key,
+				struct btrfs_delayed_node **prev,
+				struct btrfs_delayed_node **next)
+{
+	struct rb_node *node, *prev_node = NULL;
+	struct btrfs_delayed_node *delayed_node = NULL;
+	int ret = 0;
+
+	node = delayed_root->rb_root.rb_node;
+
+	while (node) {
+		delayed_node = rb_entry(node, struct btrfs_delayed_node,
+				   rb_node);
+		prev_node = node;
+		ret = comp_nodes(&delayed_node->key, key);
+		if (ret < 0)
+			node = node->rb_right;
+		else if (ret > 0)
+			node = node->rb_left;
+		else
+			return delayed_node;
+	}
+
+	if (prev) {
+		if (!prev_node)
+			*prev = NULL;
+		else if (ret < 0)
+			*prev = delayed_node;
+		else if ((node = rb_prev(prev_node)) != NULL) {
+			*prev = rb_entry(node, struct btrfs_delayed_node,
+					 rb_node);
+		} else
+			*prev = NULL;
+	}
+	if (next) {
+		if (!prev_node)
+			*next = NULL;
+		else if (ret > 0)
+			*next = delayed_node;
+		else if ((node = rb_next(prev_node)) != NULL) {
+			*next = rb_entry(node, struct btrfs_delayed_node,
+					 rb_node);
+		} else
+			*next = NULL;
+	}
+	return NULL;
+}
+
+struct btrfs_delayed_node *btrfs_lookup_delayed_node(
+					struct btrfs_delayed_root *root,
+					struct btrfs_delayed_key *key)
+{
+	return __btrfs_lookup_delayed_node(root, key, NULL, NULL);
+}
+
+struct btrfs_delayed_node *btrfs_search_delayed_node(
+		struct btrfs_delayed_root *delayed_root,
+		struct btrfs_delayed_key *key)
+{
+	struct btrfs_delayed_node *node, *next;
+
+	node = __btrfs_lookup_delayed_node(delayed_root, key, NULL, &next);
+	if (!node)
+		return next;
+	else
+		return node;
+}
+
+static int __btrfs_add_delayed_node(struct btrfs_delayed_root *root,
+			 struct btrfs_delayed_node *ins)
+{
+	struct rb_node **p, *node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_delayed_node *entry;
+	int cmp;
+
+	p = &root->rb_root.rb_node;
+	node = &ins->rb_node;
+
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_delayed_node,
+				 rb_node);
+
+		cmp = comp_nodes(&entry->key, &ins->key);
+		if (cmp < 0)
+			p = &(*p)->rb_right;
+		else if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(node, parent_node, p);
+	rb_insert_color(node, &root->rb_root);
+	root->count++;
+	return 0;
+}
+
+static struct btrfs_delayed_node *__btrfs_delete_delayed_node(
+						struct btrfs_delayed_root *root,
+						struct btrfs_delayed_node *node)
+{
+	struct btrfs_delayed_node *next;
+
+	BUG_ON(!node);
+
+	next = btrfs_next_delayed_node(node);
+	rb_erase(&node->rb_node, &root->rb_root);
+	root->count--;
+
+	btrfs_release_delayed_node(node);
+	return next;
+}
+
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, const char *name,
+				   int name_len, u64 dir,
+				   struct btrfs_disk_key *disk_key, u8 type,
+				   u64 index)
+{
+	struct btrfs_delayed_dir_index_root *delayed_dir_index;
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_dir_item *dir_item;
+	int ret;
+
+	delayed_dir_index = &trans->transaction->delayed_dir_index;
+	delayed_root = &delayed_dir_index->delayed_ins_root;
+
+	if (delayed_root->count >= root->leafsize / sizeof(*dir_item))
+		btrfs_run_delayed_dir_index(trans, root, NULL,
+					    BTRFS_DELAYED_INSERT_ITEM, 0);
+
+	ret = btrfs_delayed_dir_index_reserve_metadata(trans, root, 1);
+	if (ret)
+		return ret;
+
+	/* we use __GFP_NOFAIL to get the memory, so... */
+	delayed_node = btrfs_alloc_delayed_node(sizeof(*dir_item) + name_len);
+
+	delayed_node->key.root_id = root->objectid;
+	delayed_node->key.item_key.objectid = dir;
+	btrfs_set_key_type(&delayed_node->key.item_key, BTRFS_DIR_INDEX_KEY);
+	delayed_node->key.item_key.offset = index;
+
+	dir_item = (struct btrfs_dir_item *)delayed_node->data;
+	dir_item->location = *disk_key;
+	dir_item->transid = cpu_to_le64(trans->transid);
+	dir_item->data_len = 0;
+	dir_item->name_len = cpu_to_le16(name_len);
+	dir_item->type = type;
+	memcpy((char *)(dir_item + 1), name, name_len);
+
+	mutex_lock(&delayed_dir_index->mutex);
+	ret = __btrfs_add_delayed_node(delayed_root, delayed_node);
+	mutex_unlock(&delayed_dir_index->mutex);
+	if (ret) {
+		btrfs_delayed_dir_index_release_metadata(trans, root, 1);
+		btrfs_release_delayed_node(delayed_node);
+	}
+
+	return ret;
+}
+
+int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, u64 dir,
+				   u64 index)
+{
+	struct btrfs_delayed_dir_index_root *delayed_dir_index;
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *node;
+	struct btrfs_delayed_key delayed_key;
+	int ret;
+
+	delayed_dir_index = &trans->transaction->delayed_dir_index;;
+	delayed_root = &delayed_dir_index->delayed_del_root;
+	if (delayed_root->count >=
+	    root->leafsize / sizeof(struct btrfs_dir_item))
+		btrfs_run_delayed_dir_index(trans, root, NULL,
+					    BTRFS_DELAYED_DELETE_ITEM, 0);
+
+	delayed_key.root_id = root->objectid;
+	delayed_key.item_key.objectid = dir;
+	btrfs_set_key_type(&delayed_key.item_key, BTRFS_DIR_INDEX_KEY);
+	delayed_key.item_key.offset = index;
+
+	delayed_root = &delayed_dir_index->delayed_ins_root;
+
+	mutex_lock(&delayed_dir_index->mutex);
+	node = btrfs_lookup_delayed_node(delayed_root, &delayed_key);
+	if (node) {
+		__btrfs_delete_delayed_node(delayed_root, node);
+		mutex_unlock(&delayed_dir_index->mutex);
+		btrfs_delayed_dir_index_release_metadata(trans, root, 1);
+		return 0;
+	}
+
+	ret = btrfs_delayed_dir_index_reserve_metadata(trans, root, 1);
+	if (ret) {
+		mutex_unlock(&delayed_dir_index->mutex);
+		return ret;
+	}
+
+	/* we use __GFP_NOFAIL to get the memory, so... */
+	node = btrfs_alloc_delayed_node(0);
+
+	node->key = delayed_key;
+
+	delayed_root = &delayed_dir_index->delayed_del_root;
+	ret = __btrfs_add_delayed_node(delayed_root, node);
+	mutex_unlock(&delayed_dir_index->mutex);
+	if (ret) {
+		btrfs_delayed_dir_index_release_metadata(trans, root, 1);
+		btrfs_release_delayed_node(node);
+	}
+
+	return ret;
+}
+
+struct btrfs_delayed_node *btrfs_first_delayed_node(
+			struct btrfs_delayed_root *root)
+{
+	struct rb_node *p;
+
+	p = rb_first(&root->rb_root);
+	if (p)
+		return rb_entry(p, struct btrfs_delayed_node, rb_node);
+
+	return NULL;
+}
+
+struct btrfs_delayed_node *btrfs_next_delayed_node(
+			struct btrfs_delayed_node *node)
+{
+	struct rb_node *p;
+
+	p = rb_next(&node->rb_node);
+	if (p)
+		return rb_entry(p, struct btrfs_delayed_node,
+				rb_node);
+
+	return NULL;
+}
+
+int btrfs_inode_delayed_dir_index_count(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_delayed_key delayed_key;
+	struct btrfs_transaction *cur_trans;
+	struct btrfs_delayed_node *delayed_node, *prev_node;
+	struct btrfs_delayed_root *delayed_root;
+	int ret = 0;
+
+	delayed_key.root_id = root->objectid;
+	delayed_key.item_key.objectid = inode->i_ino;
+	btrfs_set_key_type(&delayed_key.item_key, BTRFS_DIR_INDEX_KEY);
+	delayed_key.item_key.offset = (u64)-1;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	cur_trans = root->fs_info->running_transaction;
+	if (!cur_trans) {
+		mutex_unlock(&root->fs_info->trans_mutex);;
+		return -1;
+	}
+
+	delayed_root = &cur_trans->delayed_dir_index.delayed_ins_root;
+	mutex_lock(&cur_trans->delayed_dir_index.mutex);
+	delayed_node = __btrfs_lookup_delayed_node(delayed_root, &delayed_key,
+						   &prev_node, NULL);
+	if (delayed_node)
+		goto out;
+
+	if (!prev_node) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (prev_node->key.root_id != root->objectid ||
+	    prev_node->key.item_key.objectid != inode->i_ino ||
+	    prev_node->key.item_key.type != BTRFS_DIR_INDEX_KEY) {
+		BTRFS_I(inode)->index_cnt = 2;
+		goto out;
+	}
+
+	BTRFS_I(inode)->index_cnt = prev_node->key.item_key.offset + 1;
+out:
+	mutex_unlock(&cur_trans->delayed_dir_index.mutex);
+	mutex_unlock(&root->fs_info->trans_mutex);
+	return ret;
+}
+
+static inline struct btrfs_delayed_node *btrfs_get_delayed_node(
+					struct btrfs_delayed_root *delayed_root,
+					struct btrfs_key *key,
+					u64 root_id)
+{
+	if (key) {
+		struct btrfs_delayed_key delayed_key;
+		delayed_key.root_id = root_id;
+		delayed_key.item_key = *key;
+		return btrfs_search_delayed_node(delayed_root, &delayed_key);
+	} else
+		return btrfs_first_delayed_node(delayed_root);
+}
+
+static inline struct btrfs_root *btrfs_get_fs_root(struct btrfs_root *root,
+						   u64 root_id)
+{
+	struct btrfs_key root_key;
+
+	root_key.objectid = root_id;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	return btrfs_read_fs_root_no_name(root->fs_info, &root_key);
+}
+
+/*
+ * btrfs_batch_insert_dir_index_items - batch insert some continuous dir index
+ *					items into the same leaf
+ * @trans: pointer of the transcation handler
+ * @node:  pointer of the delayed tree operation node's address
+ * @path:  path that points to the leaf
+ *
+ * This function will insert some dir index items into the same leaf according
+ * to the free space of the leaf.
+ *
+ * Must be called in delayed_root->mutex
+ */
+static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_delayed_root *delayed_root,
+				struct btrfs_delayed_node *node,
+				struct btrfs_path *path)
+{
+	struct btrfs_delayed_node *curr, *next;
+	int free_space;
+	int total_data_size = 0, total_size = 0;
+	int tmp_size = 0;	/* used to compare with the free_space */
+	struct extent_buffer *leaf;
+	char *data_ptr;
+	struct btrfs_key *keys;
+	u32 *data_size;
+	int slot;
+	int nitems = 0;
+	int i;
+	int ret = 0;
+
+	BUG_ON(!path->nodes[0]);
+
+	leaf = path->nodes[0];
+	free_space = btrfs_leaf_free_space(root, leaf);
+	next = node;
+	tmp_size = next->data_len + sizeof(struct btrfs_item);
+
+	/*
+	 * count the number of the dir index items that we can insert them in
+	 * batch
+	 */
+	while (tmp_size <= free_space) {
+		total_data_size += next->data_len;
+		total_size = tmp_size;
+		nitems++;
+
+		curr = next;
+		next = btrfs_next_delayed_node(curr);
+		if (!next || !btrfs_is_continuous_delayed_node(curr, next))
+			break;
+
+		tmp_size += next->data_len + sizeof(struct btrfs_item);
+	}
+
+	if (!nitems)
+		return 0;
+
+	keys = kmalloc(sizeof(struct btrfs_key) * nitems, GFP_NOFS);
+	if (!keys)
+		return -ENOMEM;
+
+	data_size = kmalloc(sizeof(u32) * nitems, GFP_NOFS);
+	if (!data_size) {
+		kfree(keys);
+		return -ENOMEM;
+	}
+
+	/* get keys of all the dir index items */
+	next = node;
+	for (i = 0; i < nitems; i++) {
+		keys[i] = next->key.item_key;
+		data_size[i] = next->data_len;
+		next = btrfs_next_delayed_node(next);
+	}
+
+	/* insert the keys of the items */
+	ret = setup_items_for_insert(trans, root, path, keys, data_size,
+				     total_data_size, total_size, nitems);
+	if (ret)
+		goto error;
+
+	/* insert the dir index items */
+	next = node;
+	for (i = 0; i < nitems; i++) {
+		slot = path->slots[0] + i;
+
+		/*
+		 * we needn't check the return value of btrfs_item_ptr()
+		 * because this function guarantees it can return a valid
+		 * value.
+		 */
+		data_ptr = btrfs_item_ptr(leaf, slot, char);
+
+		write_extent_buffer(leaf, &next->data, (unsigned long)data_ptr,
+				    next->data_len);
+		next = __btrfs_delete_delayed_node(delayed_root, next);
+	}
+	btrfs_delayed_dir_index_release_metadata(trans, root, nitems);
+
+error:
+	kfree(data_size);
+	kfree(keys);
+	return ret;
+}
+
+/*
+ * we insert a item first, then if there are some continuous items, we try
+ * to insert those items into the same leaf.
+ */
+static int btrfs_insert_delayed_items(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_delayed_dir_index_root *dir_index_root,
+			struct btrfs_path *path,
+			struct btrfs_key *key,
+			int insert_all)
+{
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *node, *prev_node;
+	int ret = 0;
+
+	delayed_root = &dir_index_root->delayed_ins_root;
+
+	if (!delayed_root->count)
+		return 0;
+
+	node = btrfs_get_delayed_node(delayed_root, key, root->objectid);
+do_again:
+	if (!node)
+		return 0;
+
+	/*
+	 * check root, if root is not the one which the delayed item wants to be
+	 * inserted to, we get the right root.
+	 */
+	if (unlikely(!root || root->objectid != node->key.root_id)) {
+		root = btrfs_get_fs_root(root, node->key.root_id);
+		BUG_ON(IS_ERR_OR_NULL(root) ||
+		       root == root->fs_info->tree_root);
+	}
+
+	ret = btrfs_insert_dir_index_item(trans, root, &node->key.item_key,
+				path, (struct btrfs_dir_item *)node->data,
+				node->data_len);
+	if (ret)
+		goto insert_fail;
+
+	prev_node = node;
+	node = btrfs_next_delayed_node(prev_node);
+	if (node && btrfs_is_continuous_delayed_node(prev_node, node)) {
+		/* insert the coninuous items into the same leaf */
+		path->slots[0]++;
+		btrfs_batch_insert_items(trans, root, delayed_root, node,
+					 path);
+	}
+	node = __btrfs_delete_delayed_node(delayed_root, prev_node);
+	btrfs_delayed_dir_index_release_metadata(trans, root, 1);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	if (insert_all && node) {
+		btrfs_release_path(root, path);
+		goto do_again;
+	}
+
+insert_fail:
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static int btrfs_batch_delete_items(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_delayed_root *delayed_root,
+				struct btrfs_delayed_node **node,
+				struct btrfs_path *path)
+{
+	struct btrfs_delayed_node *curr, *next;
+	struct extent_buffer *leaf;
+	struct btrfs_key last_key;
+	int nitems, i;
+	int ret = 0;
+
+	BUG_ON(!path->nodes[0]);
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &last_key, btrfs_header_nritems(leaf) - 1);
+
+	next = *node;
+again:
+	nitems = 0;
+	/*
+	 * count the number of the dir index items that we can delete them in
+	 * batch
+	 */
+	while (btrfs_comp_cpu_keys(&next->key.item_key, &last_key) <= 0) {
+		nitems++;
+		curr = next;
+		next = btrfs_next_delayed_node(curr);
+		if (!next || !btrfs_is_continuous_delayed_node(curr, next))
+			break;
+	}
+
+	if (!nitems)
+		return 0;
+
+	ret = btrfs_del_items(trans, root, path, path->slots[0], nitems);
+	BUG_ON(ret);
+
+	/* drop the delayed nodes */
+	next = *node;
+	for (i = 0; i < nitems; i++)
+		next = __btrfs_delete_delayed_node(delayed_root, next);
+	btrfs_delayed_dir_index_release_metadata(trans, root, nitems);
+
+	if (!path->locks[0] || leaf != path->nodes[0])
+		goto out;
+
+	btrfs_item_key_to_cpu(leaf, &last_key, btrfs_header_nritems(leaf) - 1);
+	while (next && next->key.root_id == root->objectid
+	       && btrfs_comp_cpu_keys(&next->key.item_key, &last_key) <= 0) {
+		ret = btrfs_bin_search(leaf, &next->key.item_key, 0,
+					&path->slots[0]);
+		/* if we can't find the item, it means the node is invalid. */
+		if (!ret) {
+			*node = next;
+			goto again;
+		} else {
+			next = __btrfs_delete_delayed_node(delayed_root, next);
+			btrfs_delayed_dir_index_release_metadata(trans, root,
+								 1);
+		}
+	}
+
+out:
+	*node = next;
+
+	return 0;
+}
+
+static int btrfs_delete_delayed_items(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_delayed_dir_index_root *dir_index_root,
+			struct btrfs_path *path,
+			struct btrfs_key *key,
+			int delete_all)
+{
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *node;
+	int ret;
+
+	delayed_root = &dir_index_root->delayed_del_root;
+
+	if (!delayed_root->count)
+		return 0;
+
+	node = btrfs_get_delayed_node(delayed_root, key, root->objectid);
+do_again:
+	if (!node)
+		return 0;
+
+	/*
+	 * check root, if root is not the one which the delayed item wants to be
+	 * inserted to, we get the right root.
+	 */
+	if (unlikely(!root || root->objectid != node->key.root_id)) {
+		root = btrfs_get_fs_root(root, node->key.root_id);
+		BUG_ON(!root || root == root->fs_info->tree_root);
+	}
+
+	ret = btrfs_search_slot(trans, root, &node->key.item_key,
+				path, -1, 1);
+	if (ret < 0)
+		goto delete_fail;
+	else if (ret > 0) {
+		/*
+		 * can't find the item which the node points to, so this node
+		 * is invalid, just drop it.
+		 */
+		node = __btrfs_delete_delayed_node(delayed_root, node);
+		btrfs_delayed_dir_index_release_metadata(trans, root, 1);
+		ret = 0;
+		btrfs_release_path(root, path);
+		goto do_again;
+	}
+
+	btrfs_batch_delete_items(trans, root, delayed_root, &node, path);
+
+	if (!node)
+		goto delete_fail;
+
+	if (delete_all
+	    || (key && node->key.root_id == root->objectid
+		&& node->key.item_key.objectid == key->objectid)) {
+		btrfs_release_path(root, path);
+		goto do_again;
+	}
+
+delete_fail:
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+int btrfs_run_delayed_dir_index(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_key *key,
+				int action,
+				int run_all)
+{
+	struct btrfs_delayed_dir_index_root *delayed_dir_index;
+	struct btrfs_path *path;
+	struct btrfs_block_rsv *block_rsv;
+	int ret = 0;
+
+	BUG_ON(key && run_all);
+
+	delayed_dir_index = &trans->transaction->delayed_dir_index;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &root->fs_info->global_block_rsv;
+
+	mutex_lock(&delayed_dir_index->mutex);
+
+	if (action == BTRFS_DELAYED_INSERT_ITEM)
+		ret = btrfs_insert_delayed_items(trans, root, delayed_dir_index,
+						 path, key, run_all);
+	else if (action == BTRFS_DELAYED_DELETE_ITEM)
+		ret = btrfs_delete_delayed_items(trans, root, delayed_dir_index,
+						 path, key, run_all);
+	else if (action == BTRFS_DELAYED_INS_AND_DEL_ITEM) {
+		ret = btrfs_insert_delayed_items(trans, root, delayed_dir_index,
+						 path, key, run_all);
+		if (!ret)
+			ret = btrfs_delete_delayed_items(trans, root,
+							 delayed_dir_index,
+							 path, key, run_all);
+	} else
+		BUG();
+
+	mutex_unlock(&delayed_dir_index->mutex);
+	trans->block_rsv = block_rsv;
+	btrfs_free_path(path);
+	return ret;
+}
+
+void btrfs_lock_delayed_dir_index_root(struct btrfs_trans_handle *trans)
+{
+	mutex_lock(&trans->transaction->delayed_dir_index.mutex);
+}
+
+void btrfs_unlock_delayed_dir_index_root(struct btrfs_trans_handle *trans)
+{
+	mutex_unlock(&trans->transaction->delayed_dir_index.mutex);
+}
+
+/*
+ * btrfs_readdir_delayed_dir_index - read dir info stored in the delayed tree
+ *
+ * Must be called when holding delayed_dir_index->mutex
+ */
+int btrfs_readdir_delayed_dir_index(struct btrfs_trans_handle *trans,
+				    struct file *filp, void *dirent,
+				    filldir_t filldir)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_delayed_node *node;
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_dir_item *di;
+	struct btrfs_delayed_key delayed_key, *key;
+	struct btrfs_key location;
+	char *name;
+	int name_len;
+	int over = 0;
+	unsigned char d_type;
+
+	/* FIXME, use a real flag for deciding about the key type */
+	if (root->fs_info->tree_root == root)
+		return 0;
+
+	BUG_ON(!trans);
+
+	delayed_root = &trans->transaction->delayed_dir_index.delayed_ins_root;
+
+	delayed_key.root_id = root->objectid;
+	btrfs_set_key_type(&delayed_key.item_key, BTRFS_DIR_INDEX_KEY);
+	delayed_key.item_key.offset = filp->f_pos;
+	delayed_key.item_key.objectid = inode->i_ino;
+
+	node = btrfs_search_delayed_node(delayed_root, &delayed_key);
+	while (node) {
+		key = &node->key;
+		if (key->root_id != delayed_key.root_id)
+			break;
+		if (key->item_key.objectid != delayed_key.item_key.objectid)
+			break;
+		if (btrfs_key_type(&key->item_key) != BTRFS_DIR_INDEX_KEY)
+			break;
+		if (key->item_key.offset < filp->f_pos)
+			goto skip;
+
+		filp->f_pos = key->item_key.offset;
+
+		di = (struct btrfs_dir_item *)node->data;
+		name = (char *)(di + 1);
+		name_len = le16_to_cpu(di->name_len);
+
+		d_type = btrfs_filetype_table[di->type];
+		btrfs_disk_key_to_cpu(&location, &di->location);
+
+		over = filldir(dirent, name, name_len, key->item_key.offset,
+			       location.objectid, d_type);
+		if (over)
+			return 1;
+skip:
+		node = btrfs_next_delayed_node(node);
+	}
+	return 0;
+}
diff --git a/fs/btrfs/delayed-dir-index.h b/fs/btrfs/delayed-dir-index.h
new file mode 100644
index 0000000..40e722d
--- /dev/null
+++ b/fs/btrfs/delayed-dir-index.h
@@ -0,0 +1,92 @@
+#ifndef __DELAYED_TREE_OPERATION_H
+#define __DELAYED_TREE_OPERATION_H
+
+#include "ctree.h"
+
+#define BTRFS_DELAYED_INS_AND_DEL_ITEM	0
+#define BTRFS_DELAYED_INSERT_ITEM	1
+#define BTRFS_DELAYED_DELETE_ITEM	2
+
+struct btrfs_delayed_key {
+	u64 root_id;
+	struct btrfs_key item_key;
+};
+
+struct btrfs_delayed_node {
+	struct rb_node rb_node;
+	struct btrfs_delayed_key key;
+	int data_len;
+	char data[0];
+};
+
+struct btrfs_delayed_root {
+	struct rb_root rb_root;
+	int count;
+};
+
+struct btrfs_delayed_dir_index_root {
+	struct btrfs_delayed_root delayed_ins_root;
+	struct btrfs_delayed_root delayed_del_root;
+	struct mutex mutex;
+};
+
+static inline int btrfs_is_continuous_delayed_node(
+					struct btrfs_delayed_node *node1,
+					struct btrfs_delayed_node *node2)
+{
+	if (node1->key.root_id == node2->key.root_id
+	    && node1->key.item_key.objectid == node2->key.item_key.objectid
+	    && node1->key.item_key.type == node2->key.item_key.type
+	    && node1->key.item_key.offset + 1 == node2->key.item_key.offset)
+		return 1;
+	return 0;
+}
+
+void btrfs_lock_delayed_dir_index_root(struct btrfs_trans_handle *trans);
+void btrfs_unlock_delayed_dir_index_root(struct btrfs_trans_handle *trans);
+
+void btrfs_init_delayed_dir_index_root(
+			struct btrfs_delayed_dir_index_root *delayed_dir_index);
+struct btrfs_delayed_node *btrfs_alloc_delayed_node(int data_len);
+void btrfs_release_delayed_node(struct btrfs_delayed_node *node);
+
+struct btrfs_delayed_node *btrfs_lookup_delayed_node(
+						struct btrfs_delayed_root *root,
+						struct btrfs_delayed_key *key);
+
+/* This function may return the next node if don't find the right node */
+struct btrfs_delayed_node *btrfs_search_delayed_node(
+		struct btrfs_delayed_root *delayed_root,
+		struct btrfs_delayed_key *key);
+
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, const char *name,
+				   int name_len, u64 dir,
+				   struct btrfs_disk_key *disk_key, u8 type,
+				   u64 index);
+
+int btrfs_delete_delayed_node(struct btrfs_trans_handle *trans,
+			      u64 root_id, struct btrfs_key *key, int action);
+
+int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, u64 dir,
+				   u64 index);
+
+int btrfs_inode_delayed_dir_index_count(struct inode *inode);
+
+struct btrfs_delayed_node *btrfs_first_delayed_node(
+			struct btrfs_delayed_root *root);
+
+struct btrfs_delayed_node *btrfs_next_delayed_node(
+			struct btrfs_delayed_node *node);
+
+int btrfs_run_delayed_dir_index(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_key *key,
+				int action,
+				int run_all);
+
+int btrfs_readdir_delayed_dir_index(struct btrfs_trans_handle *trans,
+				    struct file *filp, void *dirent,
+				    filldir_t filldir);
+#endif
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index d2d23b6..588e1fb 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -182,6 +182,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	path = btrfs_alloc_path();
 	path->leave_spinning = 1;
 
+	btrfs_cpu_key_to_disk(&disk_key, location);
+
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
@@ -193,7 +195,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 
 	leaf = path->nodes[0];
-	btrfs_cpu_key_to_disk(&disk_key, location);
 	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
 	btrfs_set_dir_type(leaf, dir_item, type);
 	btrfs_set_dir_data_len(leaf, dir_item, 0);
@@ -212,25 +213,8 @@ second_insert:
 	}
 	btrfs_release_path(root, path);
 
-	dir_item = kmalloc(sizeof(*dir_item) + name_len, GFP_KERNEL | GFP_NOFS);
-	if (!dir_item) {
-		ret2 = -ENOMEM;
-		goto out;
-	}
-
-	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = index;
-
-	btrfs_cpu_key_to_disk(&disk_key, location);
-	dir_item->location = disk_key;
-	dir_item->transid = cpu_to_le64(trans->transid);
-	dir_item->data_len = 0;
-	dir_item->name_len = cpu_to_le16(name_len);
-	dir_item->type = type;
-	memcpy((char *)(dir_item + 1), name, name_len);
-	ret2 = btrfs_insert_dir_index_item(trans, root, &key, path, dir_item,
-					   sizeof(*dir_item) + name_len);
-	kfree(dir_item);
+	ret2 = btrfs_insert_delayed_dir_index(trans, root, name, name_len,
+					      dir, &disk_key, type, index);
 out:
 	btrfs_free_path(path);
 	if (ret)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ddaf634..70c4c34 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4043,6 +4043,27 @@ void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes)
 	btrfs_free_reserved_data_space(inode, num_bytes);
 }
 
+int btrfs_delayed_dir_index_reserve_metadata(struct btrfs_trans_handle *trans,
+					     struct btrfs_root *root,
+					     int num_items)
+{
+	struct btrfs_block_rsv *src_rsv = get_block_rsv(trans, root);
+	struct btrfs_block_rsv *dst_rsv = &root->fs_info->global_block_rsv;
+	u64 num_bytes = calc_trans_metadata_size(root, num_items);
+
+	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
+}
+
+void btrfs_delayed_dir_index_release_metadata(struct btrfs_trans_handle *trans,
+					      struct btrfs_root *root,
+					      int num_items)
+{
+	u64 num_bytes = calc_trans_metadata_size(root, num_items);
+
+	btrfs_block_rsv_release(root, &root->fs_info->global_block_rsv,
+				num_bytes);
+}
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2f0c742..9fa7328 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2672,18 +2672,9 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 index, name, name_len, -1);
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
-		goto err;
-	}
-	if (!di) {
-		ret = -ENOENT;
+	ret = btrfs_delete_delayed_dir_index(trans, root, dir->i_ino, index);
+	if (ret)
 		goto err;
-	}
-	ret = btrfs_delete_one_dir_name(trans, root, path, di);
-	btrfs_release_path(root, path);
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
 					 inode, dir->i_ino);
@@ -2858,6 +2849,14 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	index = btrfs_inode_ref_index(path->nodes[0], ref);
 	btrfs_release_path(root, path);
 
+	/*
+	 * This is a commit root search, if we can lookup inode item and other
+	 * relative items in the commit root, it means the transaction of
+	 * dir/file creation has been committed, and the dir index item that we
+	 * delay to insert has also been inserted into the commit root. So
+	 * we needn't worry about the delayed insertion of the dir index item
+	 * here.
+	 */
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino, index,
 				dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
@@ -2963,24 +2962,16 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		btrfs_release_path(root, path);
 		index = key.offset;
 	}
+	btrfs_free_path(path);
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 index, name, name_len, -1);
-	BUG_ON(!di || IS_ERR(di));
-
-	leaf = path->nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, di, &key);
-	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
-	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	ret = btrfs_delete_delayed_dir_index(trans, root, dir->i_ino, index);
 	BUG_ON(ret);
-	btrfs_release_path(root, path);
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	btrfs_free_path(path);
 	return 0;
 }
 
@@ -4169,7 +4160,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-static unsigned char btrfs_filetype_table[] = {
+unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
@@ -4305,6 +4296,7 @@ static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans = NULL;
 	int key_type = BTRFS_DIR_INDEX_KEY;
 	int ret;
 	int over = 0;
@@ -4332,9 +4324,31 @@ static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		filp->f_pos = 2;
 	}
 
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		struct btrfs_key key;
+
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
+		btrfs_set_key_type(&key, key_type);
+		key.offset = 0;
+		key.objectid = inode->i_ino;
+
+		ret = btrfs_run_delayed_dir_index(trans, root, &key,
+						  BTRFS_DELAYED_DELETE_ITEM, 0);
+		if (ret) {
+			btrfs_end_transaction(trans, root);
+			return ret;
+		}
+		btrfs_lock_delayed_dir_index_root(trans);
+	}
+
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto alloc_fail;
+	}
 	path->reada = 2;
 
 	ret = btrfs_real_readdir(filp, dirent, filldir, root, key_type, path);
@@ -4343,6 +4357,15 @@ static int btrfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	else if (ret > 0)
 		goto nopos;
 
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		ret = btrfs_readdir_delayed_dir_index(trans, filp, dirent,
+						      filldir);
+		if (ret < 0)
+			goto err;
+		else if (ret > 0)
+			goto nopos;
+	}
+
 	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
 		/*
@@ -4356,6 +4379,11 @@ nopos:
 	ret = 0;
 err:
 	btrfs_free_path(path);
+alloc_fail:
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		btrfs_unlock_delayed_dir_index_root(trans);
+		btrfs_end_transaction(trans, root);
+	}
 	return ret;
 }
 
@@ -4444,6 +4472,10 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	struct extent_buffer *leaf;
 	int ret;
 
+	ret = btrfs_inode_delayed_dir_index_count(inode);
+	if (!ret)
+		return 0;
+
 	key.objectid = inode->i_ino;
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
 	key.offset = (u64)-1;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f50e931..9d16181 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -78,6 +78,8 @@ static noinline int join_transaction(struct btrfs_root *root)
 		cur_trans->delayed_refs.run_delayed_start = 0;
 		spin_lock_init(&cur_trans->delayed_refs.lock);
 
+		btrfs_init_delayed_dir_index_root(
+					&cur_trans->delayed_dir_index);
 		INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 		list_add_tail(&cur_trans->list, &root->fs_info->trans_list);
 		extent_io_tree_init(&cur_trans->dirty_pages,
@@ -1286,9 +1288,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	} while (cur_trans->num_writers > 1 ||
 		 (should_grow && cur_trans->num_joined != joined));
 
+	btrfs_run_delayed_dir_index(trans, root, NULL,
+				    BTRFS_DELAYED_INS_AND_DEL_ITEM, 1);
+
 	ret = create_pending_snapshots(trans, root->fs_info);
 	BUG_ON(ret);
 
+	ret = btrfs_run_delayed_dir_index(trans, root, NULL,
+					  BTRFS_DELAYED_INS_AND_DEL_ITEM, 1);
+	BUG_ON(ret);
+
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f104b57..b8ddfe3 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -20,6 +20,7 @@
 #define __BTRFS_TRANSACTION__
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
+#include "delayed-dir-index.h"
 
 struct btrfs_transaction {
 	u64 transid;
@@ -41,6 +42,7 @@ struct btrfs_transaction {
 	wait_queue_head_t commit_wait;
 	struct list_head pending_snapshots;
 	struct btrfs_delayed_ref_root delayed_refs;
+	struct btrfs_delayed_dir_index_root delayed_dir_index;
 };
 
 struct btrfs_trans_handle {
-- 
1.7.0.1
