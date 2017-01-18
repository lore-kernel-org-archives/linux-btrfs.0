Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34947 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdARHbZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 02:31:25 -0500
Received: by mail-pf0-f176.google.com with SMTP id f144so2276038pfa.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 23:31:25 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: constify struct btrfs_{,disk_}key wherever possible
Date: Tue, 17 Jan 2017 23:24:37 -0800
Message-Id: <28e17c356a456cd03635e6c6f2c7a46c82de45ac.1484724045.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In a lot of places, it's unclear when it's safe to reuse a struct
btrfs_key after it has been passed to a helper function. Constify these
arguments wherever possible to make it obvious.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
This applies to Dave's for-next branch. If it's too intrusive of a
change, it can wait, but I think it's a nice cleanup.

 fs/btrfs/ctree.c       | 58 +++++++++++++++++++++++++-----------------------
 fs/btrfs/ctree.h       | 60 ++++++++++++++++++++++++++------------------------
 fs/btrfs/extent-tree.c |  9 ++++----
 fs/btrfs/root-tree.c   |  6 ++---
 4 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 146b2dc0d2cf..72dd200f0478 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -28,9 +28,9 @@
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
-static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *ins_key,
-		      struct btrfs_path *path, int data_size, int extend);
+static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *ins_key, struct btrfs_path *path,
+		      int data_size, int extend);
 static int push_node_left(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info,
 			  struct extent_buffer *dst,
@@ -1580,7 +1580,8 @@ static int close_blocks(u64 blocknr, u64 other, u32 blocksize)
 /*
  * compare two keys in a memcmp fashion
  */
-static int comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+static int comp_keys(const struct btrfs_disk_key *disk,
+		     const struct btrfs_key *k2)
 {
 	struct btrfs_key k1;
 
@@ -1592,7 +1593,7 @@ static int comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
 /*
  * same as comp_keys only with two btrfs_key's
  */
-int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
+int btrfs_comp_cpu_keys(const struct btrfs_key *k1, const struct btrfs_key *k2)
 {
 	if (k1->objectid > k2->objectid)
 		return 1;
@@ -1732,8 +1733,8 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
  * slot may point to max if the key is bigger than all of the keys
  */
 static noinline int generic_bin_search(struct extent_buffer *eb,
-				       unsigned long p,
-				       int item_size, struct btrfs_key *key,
+				       unsigned long p, int item_size,
+				       const struct btrfs_key *key,
 				       int max, int *slot)
 {
 	int low = 0;
@@ -1802,7 +1803,7 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+static int bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
 		      int level, int *slot)
 {
 	if (level == 0)
@@ -1819,7 +1820,7 @@ static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 					  slot);
 }
 
-int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
 		     int level, int *slot)
 {
 	return bin_search(eb, key, level, slot);
@@ -2440,7 +2441,7 @@ static int
 read_block_for_search(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *p,
 		       struct extent_buffer **eb_ret, int level, int slot,
-		       struct btrfs_key *key, u64 time_seq)
+		       const struct btrfs_key *key, u64 time_seq)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 blocknr;
@@ -2587,7 +2588,7 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 }
 
 static void key_search_validate(struct extent_buffer *b,
-				struct btrfs_key *key,
+				const struct btrfs_key *key,
 				int level)
 {
 #ifdef CONFIG_BTRFS_ASSERT
@@ -2606,7 +2607,7 @@ static void key_search_validate(struct extent_buffer *b,
 #endif
 }
 
-static int key_search(struct extent_buffer *b, struct btrfs_key *key,
+static int key_search(struct extent_buffer *b, const struct btrfs_key *key,
 		      int level, int *prev_cmp, int *slot)
 {
 	if (*prev_cmp != 0) {
@@ -2668,9 +2669,9 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
  * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
  * possible)
  */
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow)
+int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *key, struct btrfs_path *p,
+		      int ins_len, int cow)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
@@ -2953,7 +2954,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
  * The resulting path and return value will be set up as if we called
  * btrfs_search_slot at that point in time with ins_len and cow both set to 0.
  */
-int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
+int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 			  struct btrfs_path *p, u64 time_seq)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -3067,8 +3068,9 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
  * < 0 on error
  */
 int btrfs_search_slot_for_read(struct btrfs_root *root,
-			       struct btrfs_key *key, struct btrfs_path *p,
-			       int find_higher, int return_any)
+			       const struct btrfs_key *key,
+			       struct btrfs_path *p, int find_higher,
+			       int return_any)
 {
 	int ret;
 	struct extent_buffer *leaf;
@@ -3166,7 +3168,7 @@ static void fixup_low_keys(struct btrfs_fs_info *fs_info,
  */
 void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path,
-			     struct btrfs_key *new_key)
+			     const struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *eb;
@@ -4180,7 +4182,7 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
  */
 static noinline int split_leaf(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
-			       struct btrfs_key *ins_key,
+			       const struct btrfs_key *ins_key,
 			       struct btrfs_path *path, int data_size,
 			       int extend)
 {
@@ -4415,7 +4417,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 static noinline int split_item(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_path *path,
-			       struct btrfs_key *new_key,
+			       const struct btrfs_key *new_key,
 			       unsigned long split_offset)
 {
 	struct extent_buffer *leaf;
@@ -4501,7 +4503,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
 int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
-		     struct btrfs_key *new_key,
+		     const struct btrfs_key *new_key,
 		     unsigned long split_offset)
 {
 	int ret;
@@ -4525,7 +4527,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 struct btrfs_path *path,
-			 struct btrfs_key *new_key)
+			 const struct btrfs_key *new_key)
 {
 	struct extent_buffer *leaf;
 	int ret;
@@ -4726,7 +4728,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
  * that doesn't call btrfs_search_slot
  */
 void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
+			    const struct btrfs_key *cpu_key, u32 *data_size,
 			    u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4820,7 +4822,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
+			    const struct btrfs_key *cpu_key, u32 *data_size,
 			    int nr)
 {
 	int ret = 0;
@@ -4851,9 +4853,9 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
  * Given a key and some data, insert an item into the tree.
  * This does all the path init required, making room in the tree if needed.
  */
-int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *cpu_key, void *data, u32
-		      data_size)
+int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *cpu_key, void *data,
+		      u32 data_size)
 {
 	int ret = 0;
 	struct btrfs_path *path;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c5d14a74ec2d..17d7ea3307f0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1968,7 +1968,7 @@ BTRFS_SETGET_STACK_FUNCS(disk_key_offset, struct btrfs_disk_key, offset, 64);
 BTRFS_SETGET_STACK_FUNCS(disk_key_type, struct btrfs_disk_key, type, 8);
 
 static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
-					 struct btrfs_disk_key *disk)
+					 const struct btrfs_disk_key *disk)
 {
 	cpu->offset = le64_to_cpu(disk->offset);
 	cpu->type = disk->type;
@@ -1976,7 +1976,7 @@ static inline void btrfs_disk_key_to_cpu(struct btrfs_key *cpu,
 }
 
 static inline void btrfs_cpu_key_to_disk(struct btrfs_disk_key *disk,
-					 struct btrfs_key *cpu)
+					 const struct btrfs_key *cpu)
 {
 	disk->offset = cpu_to_le64(cpu->offset);
 	disk->type = cpu->type;
@@ -2008,8 +2008,7 @@ static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
 
-
-static inline u8 btrfs_key_type(struct btrfs_key *key)
+static inline u8 btrfs_key_type(const struct btrfs_key *key)
 {
 	return key->type;
 }
@@ -2602,10 +2601,11 @@ void btrfs_get_block_group(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int get_block_group_index(struct btrfs_block_group_cache *cache);
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root, u64 parent,
-					u64 root_objectid,
-					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size);
+					     struct btrfs_root *root,
+					     u64 parent, u64 root_objectid,
+					     const struct btrfs_disk_key *key,
+					     int level, u64 hint,
+					     u64 empty_size);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
@@ -2769,9 +2769,9 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
 
 /* ctree.c */
-int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
+int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
 		     int level, int *slot);
-int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
+int btrfs_comp_cpu_keys(const struct btrfs_key *k1, const struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
@@ -2779,7 +2779,7 @@ int btrfs_previous_extent_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid);
 void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path,
-			     struct btrfs_key *new_key);
+			     const struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
@@ -2821,22 +2821,23 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
-		     struct btrfs_key *new_key,
+		     const struct btrfs_key *new_key,
 		     unsigned long split_offset);
 int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 struct btrfs_path *path,
-			 struct btrfs_key *new_key);
+			 const struct btrfs_key *new_key);
 int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
 		u64 inum, u64 ioff, u8 key_type, struct btrfs_key *found_key);
-int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_path *p, int
-		      ins_len, int cow);
-int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
+int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *key, struct btrfs_path *p,
+		      int ins_len, int cow);
+int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 			  struct btrfs_path *p, u64 time_seq);
 int btrfs_search_slot_for_read(struct btrfs_root *root,
-			       struct btrfs_key *key, struct btrfs_path *p,
-			       int find_higher, int return_any);
+			       const struct btrfs_key *key,
+			       struct btrfs_path *p, int find_higher,
+			       int return_any);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
 		       int start_slot, u64 *last_ret,
@@ -2859,19 +2860,20 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 }
 
 void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
+			    const struct btrfs_key *cpu_key, u32 *data_size,
 			    u32 total_data, u32 total_size, int nr);
-int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, void *data, u32 data_size);
+int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path,
-			     struct btrfs_key *cpu_key, u32 *data_size, int nr);
+			     const struct btrfs_key *cpu_key, u32 *data_size,
+			     int nr);
 
 static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
 					  struct btrfs_path *path,
-					  struct btrfs_key *key,
+					  const struct btrfs_key *key,
 					  u32 data_size)
 {
 	return btrfs_insert_empty_items(trans, root, path, key, &data_size, 1);
@@ -2960,15 +2962,15 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_key *key);
-int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_root_item
-		      *item);
+		   const struct btrfs_key *key);
+int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      const struct btrfs_key *key,
+		      struct btrfs_root_item *item);
 int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_key *key,
 				   struct btrfs_root_item *item);
-int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
+int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key);
 int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa55a4bf3e68..c11e3e5d97eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8372,10 +8372,11 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
  * returns the tree buffer or an ERR_PTR on error.
  */
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root,
-					u64 parent, u64 root_objectid,
-					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size)
+					     struct btrfs_root *root,
+					     u64 parent, u64 root_objectid,
+					     const struct btrfs_disk_key *key,
+					     int level, u64 hint,
+					     u64 empty_size)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key ins;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 4c6735491ee0..a08224eab8b4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -74,7 +74,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
  *
  * If we find something return 0, otherwise > 0, < 0 on error.
  */
-int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
+int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key)
 {
@@ -207,7 +207,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 }
 
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		      struct btrfs_key *key, struct btrfs_root_item *item)
+		      const struct btrfs_key *key, struct btrfs_root_item *item)
 {
 	/*
 	 * Make sure generation v1 and v2 match. See update_root for details.
@@ -337,7 +337,7 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 
 /* drop the root item for 'key' from 'root' */
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_key *key)
+		   const struct btrfs_key *key)
 {
 	struct btrfs_path *path;
 	int ret;
-- 
2.11.0

