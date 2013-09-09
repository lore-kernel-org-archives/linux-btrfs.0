Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fau.xxx ([213.133.103.231]:54080 "EHLO om.goeswhere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab3IIWPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 18:15:12 -0400
Date: Mon, 9 Sep 2013 23:06:51 +0100
From: "Chris West (Faux)" <git@goeswhere.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: ctree: widen int->long due to PTR_ERR()
Message-ID: <20130909220651.GA10244@goeswhere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 ctree.c      | 74 ++++++++++++++++++++++++++++++------------------------------
 ctree.h      | 24 ++++++++++----------
 print-tree.c |  4 ++--
 3 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/ctree.c b/ctree.c
index 8b1fc07..bfcf3d1 100644
--- a/ctree.c
+++ b/ctree.c
@@ -21,9 +21,9 @@
 #include "print-tree.h"
 #include "repair.h"
 
-static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
+static long split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
-static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
+static long split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *ins_key,
 		      struct btrfs_path *path, int data_size, int extend);
 static int push_node_left(struct btrfs_trans_handle *trans,
@@ -71,7 +71,7 @@ void add_root_to_dirty_list(struct btrfs_root *root)
 	}
 }
 
-int btrfs_copy_root(struct btrfs_trans_handle *trans,
+long btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid)
@@ -252,7 +252,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int __btrfs_cow_block(struct btrfs_trans_handle *trans,
+long __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct extent_buffer *buf,
 			     struct extent_buffer *parent, int parent_slot,
@@ -337,13 +337,13 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
-int btrfs_cow_block(struct btrfs_trans_handle *trans,
+long btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
 		    struct extent_buffer *parent, int parent_slot,
 		    struct extent_buffer **cow_ret)
 {
 	u64 search_start;
-	int ret;
+	long ret;
 	/*
 	if (trans->transaction != root->fs_info->running_transaction) {
 		printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
@@ -612,7 +612,7 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 		       btrfs_node_ptr_generation(parent, slot));
 }
 
-static int balance_level(struct btrfs_trans_handle *trans,
+static long balance_level(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 struct btrfs_path *path, int level)
 {
@@ -620,8 +620,8 @@ static int balance_level(struct btrfs_trans_handle *trans,
 	struct extent_buffer *mid;
 	struct extent_buffer *left = NULL;
 	struct extent_buffer *parent = NULL;
-	int ret = 0;
-	int wret;
+	long ret = 0;
+	long wret;
 	int pslot;
 	int orig_slot = path->slots[level];
 	u64 orig_ptr;
@@ -808,7 +808,7 @@ enospc:
 }
 
 /* returns zero if the push worked, non-zero otherwise */
-static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
+static long noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path, int level)
 {
@@ -816,8 +816,8 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	struct extent_buffer *mid;
 	struct extent_buffer *left = NULL;
 	struct extent_buffer *parent = NULL;
-	int ret = 0;
-	int wret;
+	long ret = 0;
+	long wret;
 	int pslot;
 	int orig_slot = path->slots[level];
 
@@ -1010,13 +1010,13 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
  * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
  * possible)
  */
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
+long btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow)
 {
 	struct extent_buffer *b;
 	int slot;
-	int ret;
+	long ret;
 	int level;
 	int should_reada = p->reada;
 	u8 lowest_level = 0;
@@ -1033,7 +1033,7 @@ again:
 	while (b) {
 		level = btrfs_header_level(b);
 		if (cow) {
-			int wret;
+			long wret;
 			wret = btrfs_cow_block(trans, root, b,
 					       p->nodes[level + 1],
 					       p->slots[level + 1],
@@ -1059,14 +1059,14 @@ again:
 			if ((p->search_for_split || ins_len > 0) &&
 			    btrfs_header_nritems(b) >=
 			    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
-				int sret = split_node(trans, root, p, level);
+				long sret = split_node(trans, root, p, level);
 				BUG_ON(sret > 0);
 				if (sret)
 					return sret;
 				b = p->nodes[level];
 				slot = p->slots[level];
 			} else if (ins_len < 0) {
-				int sret = balance_level(trans, root, p,
+				long sret = balance_level(trans, root, p,
 							 level);
 				if (sret)
 					return sret;
@@ -1093,7 +1093,7 @@ again:
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
 			    ins_len > btrfs_leaf_free_space(root, b)) {
-				int sret = split_leaf(trans, root, key,
+				long sret = split_leaf(trans, root, key,
 						      p, ins_len, ret == 0);
 				BUG_ON(sret > 0);
 				if (sret)
@@ -1303,7 +1303,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
  *
  * returns zero on success or < 0 on failure.
  */
-static int noinline insert_new_root(struct btrfs_trans_handle *trans,
+static long noinline insert_new_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_path *path, int level)
 {
@@ -1414,15 +1414,15 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
  *
  * returns 0 on success and < 0 on failure
  */
-static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
+static long split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level)
 {
 	struct extent_buffer *c;
 	struct extent_buffer *split;
 	struct btrfs_disk_key disk_key;
 	int mid;
-	int ret;
-	int wret;
+	long ret;
+	long wret;
 	u32 c_nritems;
 
 	c = path->nodes[level];
@@ -1558,7 +1558,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	u32 right_nritems;
 	u32 data_end;
 	u32 this_item_size;
-	int ret;
+	long ret;
 
 	slot = path->slots[1];
 	if (!path->nodes[1]) {
@@ -1688,7 +1688,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
  * push some data in the path leaf to the left, trying to free up at
  * least data_size bytes.  returns zero if the push worked, nonzero otherwise
  */
-static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
+static long push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, struct btrfs_path *path, int data_size,
 			  int empty)
 {
@@ -1704,7 +1704,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	u32 old_left_nritems;
 	u32 right_nritems;
 	u32 nr;
-	int ret = 0;
+	long ret = 0;
 	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;
@@ -1921,7 +1921,7 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
  *
  * returns 0 if all went well and < 0 on failure.
  */
-static noinline int split_leaf(struct btrfs_trans_handle *trans,
+static noinline long split_leaf(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_key *ins_key,
 			       struct btrfs_path *path, int data_size,
@@ -1933,8 +1933,8 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	int mid;
 	int slot;
 	struct extent_buffer *right;
-	int ret = 0;
-	int wret;
+	long ret = 0;
+	long wret;
 	int split;
 	int num_doubles = 0;
 
@@ -2089,7 +2089,7 @@ again:
  * This allows us to split the item in place, keeping a lock on the
  * leaf the entire time.
  */
-int btrfs_split_item(struct btrfs_trans_handle *trans,
+long btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
 		     struct btrfs_key *new_key,
@@ -2100,7 +2100,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key orig_key;
 	struct btrfs_item *item;
 	struct btrfs_item *new_item;
-	int ret = 0;
+	long ret = 0;
 	int slot;
 	u32 nritems;
 	u32 orig_offset;
@@ -2352,7 +2352,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
  * Given a key and some data, insert an item into the tree.
  * This does all the path init required, making room in the tree if needed.
  */
-int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+long btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path,
 			    struct btrfs_key *cpu_key, u32 *data_size,
@@ -2360,7 +2360,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 {
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
-	int ret = 0;
+	long ret = 0;
 	int slot;
 	int i;
 	u32 nritems;
@@ -2464,11 +2464,11 @@ out:
  * Given a key and some data, insert an item into the tree.
  * This does all the path init required, making room in the tree if needed.
  */
-int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
+long btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *cpu_key, void *data, u32
 		      data_size)
 {
-	int ret = 0;
+	long ret = 0;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	unsigned long ptr;
@@ -2558,15 +2558,15 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
  * delete the item at the leaf level in path.  If that empties
  * the leaf, remove it from the tree
  */
-int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+long btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		    struct btrfs_path *path, int slot, int nr)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	int last_off;
 	int dsize = 0;
-	int ret = 0;
-	int wret;
+	long ret = 0;
+	long wret;
 	int i;
 	u32 nritems;
 
diff --git a/ctree.h b/ctree.h
index 35d1ba4..8c12419 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2058,7 +2058,7 @@ BTRFS_SETGET_FUNCS(qgroup_limit_rsv_exclusive, struct btrfs_qgroup_limit_item,
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
-static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
+static inline u64 btrfs_file_extent_inline_len(struct extent_buffer *eb,
 					struct btrfs_file_extent_item *e)
 {
        return btrfs_file_extent_ram_bytes(eb, e);
@@ -2069,7 +2069,7 @@ static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
  * size of any extent headers.  If a file is compressed on disk, this is
  * the compressed size
  */
-static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
+static inline u64 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 						    struct btrfs_item *e)
 {
        unsigned long offset;
@@ -2183,17 +2183,17 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-int btrfs_cow_block(struct btrfs_trans_handle *trans,
+long btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
 		    struct extent_buffer *parent, int parent_slot,
 		    struct extent_buffer **cow_ret);
-int __btrfs_cow_block(struct btrfs_trans_handle *trans,
+long __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct extent_buffer *buf,
 			     struct extent_buffer *parent, int parent_slot,
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size);
-int btrfs_copy_root(struct btrfs_trans_handle *trans,
+long btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
@@ -2203,12 +2203,12 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct btrfs_path *path,
 			u32 new_size, int from_end);
-int btrfs_split_item(struct btrfs_trans_handle *trans,
+long btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
 		     struct btrfs_key *new_key,
 		     unsigned long split_offset);
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
+long btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
 void btrfs_release_path(struct btrfs_path *p);
@@ -2216,24 +2216,24 @@ void add_root_to_dirty_list(struct btrfs_root *root);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
 void btrfs_init_path(struct btrfs_path *p);
-int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+long btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int slot, int nr);
 
-static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
+static inline long btrfs_del_item(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_path *path)
 {
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
-int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
+long btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
-int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
+long btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path,
 			     struct btrfs_key *cpu_key, u32 *data_size, int nr);
 
-static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
+static inline long btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path,
 					  struct btrfs_key *key,
diff --git a/print-tree.c b/print-tree.c
index 913b1bb..4e417a3 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -213,8 +213,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	int extent_type = btrfs_file_extent_type(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-		printf("\t\tinline extent data size %u "
-		       "ram %u compress %d\n",
+		printf("\t\tinline extent data size %llu "
+		       "ram %llu compress %d\n",
 		  btrfs_file_extent_inline_item_len(eb, item),
 		  btrfs_file_extent_inline_len(eb, fi),
 		  btrfs_file_extent_compression(eb, fi));
-- 
1.8.4.rc3

