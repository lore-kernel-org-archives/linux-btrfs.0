From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 1/4] btrfs: introduce a function btrfs_insert_dir_index_item()
Date: Wed, 01 Dec 2010 16:09:25 +0800
Message-ID: <4CF602B5.50404@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

restructure btrfs_insert_dir_item() and introduce a function
btrfs_insert_dir_index_item() to insert dir index item.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |    6 ++++
 fs/btrfs/dir-item.c |   69 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af52f6d..5c44cf4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2313,6 +2313,12 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 int btrfs_set_root_node(struct btrfs_root_item *item,
 			struct extent_buffer *node);
 /* dir-item.c */
+int btrfs_insert_dir_index_item(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_key *key,
+				struct btrfs_path *path,
+				struct btrfs_dir_item *dir_item,
+				int data_len);
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
 			  int name_len, u64 dir,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index f0cad5a..d2d23b6 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -117,6 +117,44 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * btrfs_insert_dir_index_item - insert a dir index item into the b-tree
+ * @trans:	pointer of the transcation handle
+ * @root:	pointer used to return the address of the btrfs root
+ * @rootid:	id of the btrfs root that the dir index item is inserted to
+ * @key:	key the dir index item
+ * @path:	pointer of the b-tree path
+ * @dir_item:	pointer of dir item
+ * @data_len:	lenght of the data
+ *
+ * Return value:
+ * 0  - successed
+ * <0 - error happened
+ */
+int btrfs_insert_dir_index_item(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_key *key,
+				struct btrfs_path *path,
+				struct btrfs_dir_item *dir_item,
+				int data_len)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_dir_item *dir_item_ptr;
+
+	dir_item_ptr = insert_with_overflow(trans, root, path, key, data_len,
+					    (char *)(dir_item + 1),
+					    le16_to_cpu(dir_item->name_len));
+	if (IS_ERR(dir_item_ptr))
+		return PTR_ERR(dir_item_ptr);
+
+	leaf = path->nodes[0];
+	write_extent_buffer(leaf, dir_item, (unsigned long)dir_item_ptr,
+			    data_len);
+	btrfs_mark_buffer_dirty(leaf);
+
+	return 0;
+}
+
+/*
  * insert a directory item in the tree, doing all the magic for
  * both indexes. 'dir' indicates which objectid to insert it into,
  * 'location' is the key to stuff into the directory item, 'type' is the
@@ -174,24 +212,25 @@ second_insert:
 	}
 	btrfs_release_path(root, path);
 
-	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = index;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
-					name, name_len);
-	if (IS_ERR(dir_item)) {
-		ret2 = PTR_ERR(dir_item);
+	dir_item = kmalloc(sizeof(*dir_item) + name_len, GFP_KERNEL | GFP_NOFS);
+	if (!dir_item) {
+		ret2 = -ENOMEM;
 		goto out;
 	}
-	leaf = path->nodes[0];
+
+	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
+	key.offset = index;
+
 	btrfs_cpu_key_to_disk(&disk_key, location);
-	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
-	btrfs_set_dir_type(leaf, dir_item, type);
-	btrfs_set_dir_data_len(leaf, dir_item, 0);
-	btrfs_set_dir_name_len(leaf, dir_item, name_len);
-	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
-	name_ptr = (unsigned long)(dir_item + 1);
-	write_extent_buffer(leaf, name, name_ptr, name_len);
-	btrfs_mark_buffer_dirty(leaf);
+	dir_item->location = disk_key;
+	dir_item->transid = cpu_to_le64(trans->transid);
+	dir_item->data_len = 0;
+	dir_item->name_len = cpu_to_le16(name_len);
+	dir_item->type = type;
+	memcpy((char *)(dir_item + 1), name, name_len);
+	ret2 = btrfs_insert_dir_index_item(trans, root, &key, path, dir_item,
+					   sizeof(*dir_item) + name_len);
+	kfree(dir_item);
 out:
 	btrfs_free_path(path);
 	if (ret)
-- 
1.7.0.1
