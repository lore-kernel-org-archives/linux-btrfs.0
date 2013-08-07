Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3HGBDf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 21:03:35 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7713ZuY009557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Aug 2013 21:03:35 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7713Xvf008363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Aug 2013 21:03:34 -0400
Message-ID: <52019CE5.4060605@redhat.com>
Date: Tue, 06 Aug 2013 20:03:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: mark static & remove unused from shared
 kernel code
References: <52019C6D.9050308@redhat.com>
In-Reply-To: <52019C6D.9050308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In files copied from the kernel, mark many functions as static,
and remove any resulting dead code.

Some functions are left unmarked if they aren't static in the
kernel tree.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 ctree.c            |    2 
 ctree.h            |   43 -------------------
 dir-item.c         |   97 ++------------------------------------------
 disk-io.c          |   14 +++---
 disk-io.h          |    4 -
 extent-tree.c      |  115 +++--------------------------------------------------
 extent_io.c        |   10 ----
 extent_io.h        |    2 
 file-item.c        |   32 ++------------
 free-space-cache.c |    2 
 inode-item.c       |   73 ---------------------------------
 inode-map.c        |   32 --------------
 qgroup.c           |    4 -
 qgroup.h           |    2 
 root-tree.c        |   27 ------------
 volumes.c          |   69 ++-----------------------------
 volumes.h          |    7 ---
 17 files changed, 38 insertions(+), 497 deletions(-)

diff --git a/ctree.c b/ctree.c
index 66b146b..a79ed13 100644
--- a/ctree.c
+++ b/ctree.c
@@ -371,7 +371,7 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 /*
  * compare two keys in a memcmp fashion
  */
-int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
 {
 	struct btrfs_key k1;
 
diff --git a/ctree.h b/ctree.h
index 257396d..16914a4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2097,23 +2097,17 @@ static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 /* extent-tree.c */
 int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
-int btrfs_check_block_accounting(struct btrfs_root *root);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
 void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 			u64 bytenr, u64 num_bytes);
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root);
-int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr);
 struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
 						       btrfs_fs_info *info,
 						       u64 bytenr);
-struct btrfs_block_group_cache *btrfs_find_block_group(struct btrfs_root *root,
-						 struct btrfs_block_group_cache
-						 *hint, u64 search_start,
-						 int data, int owner);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					u32 blocksize, u64 root_objectid,
@@ -2184,7 +2178,6 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2);
 int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
 		    struct extent_buffer *parent, int parent_slot,
@@ -2257,8 +2250,6 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 		       u64 root_id, u8 type, u64 ref_id,
 		       u64 dirid, u64 sequence,
 		       const char *name, int name_len);
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_root_item
 		      *item);
@@ -2276,46 +2267,20 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_path *path, u64 dir,
 					     const char *name, int name_len,
 					     int mod);
-struct btrfs_dir_item *
-btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
-			    int mod);
-struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len);
-int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      struct btrfs_dir_item *di);
 int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, const char *name,
 			    u16 name_len, const void *data, u16 data_len,
 			    u64 dir);
-struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 dir,
-					  const char *name, u16 name_len,
-					  int mod);
 /* inode-map.c */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *fs_root,
 			     u64 dirid, u64 *objectid);
-int btrfs_find_highest_inode(struct btrfs_root *fs_root, u64 *objectid);
 
 /* inode-item.c */
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 index);
-int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid);
-int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid);
 int btrfs_insert_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, u64 objectid, struct btrfs_inode_item
 		       *inode_item);
@@ -2334,17 +2299,9 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_insert_inline_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, u64 objectid,
 				u64 offset, char *buffer, size_t size);
-int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
-			     u64 bytenr, int mod);
 int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 alloc_end,
 			  u64 bytenr, char *data, size_t len);
-struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, int cow);
 int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
diff --git a/dir-item.c b/dir-item.c
index 6558320..edb290a 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -21,6 +21,10 @@
 #include "hash.h"
 #include "transaction.h"
 
+static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+			      struct btrfs_path *path,
+			      const char *name, int name_len);
+
 static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 						   *trans,
 						   struct btrfs_root *root,
@@ -213,67 +217,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
 
-struct btrfs_dir_item *
-btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
-			    int mod)
-{
-	int ret;
-	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
-
-	key.objectid = dir;
-	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = objectid;
-
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
-		return ERR_PTR(-ENOENT);
-	return btrfs_match_dir_item_name(root, path, name, name_len);
-}
-
-struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 dir,
-					  const char *name, u16 name_len,
-					  int mod)
-{
-	int ret;
-	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
-	struct btrfs_key found_key;
-	struct extent_buffer *leaf;
-
-	key.objectid = dir;
-	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	key.offset = btrfs_name_hash(name, name_len);
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0) {
-		if (path->slots[0] == 0)
-			return NULL;
-		path->slots[0]--;
-	}
-
-	leaf = path->nodes[0];
-	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-
-	if (found_key.objectid != dir ||
-	    btrfs_key_type(&found_key) != BTRFS_XATTR_ITEM_KEY ||
-	    found_key.offset != key.offset)
-		return NULL;
-
-	return btrfs_match_dir_item_name(root, path, name, name_len);
-}
-
-struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
+static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 			      struct btrfs_path *path,
 			      const char *name, int name_len)
 {
@@ -303,34 +247,3 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 	}
 	return NULL;
 }
-
-int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      struct btrfs_dir_item *di)
-{
-
-	struct extent_buffer *leaf;
-	u32 sub_item_len;
-	u32 item_len;
-	int ret = 0;
-
-	leaf = path->nodes[0];
-	sub_item_len = sizeof(*di) + btrfs_dir_name_len(leaf, di) +
-		btrfs_dir_data_len(leaf, di);
-	item_len = btrfs_item_size_nr(leaf, path->slots[0]);
-	if (sub_item_len == item_len) {
-		ret = btrfs_del_item(trans, root, path);
-	} else {
-		/* MARKER */
-		unsigned long ptr = (unsigned long)di;
-		unsigned long start;
-
-		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
-		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
-			item_len - (ptr + sub_item_len - start));
-		ret = btrfs_truncate_item(trans, root, path,
-					  item_len - sub_item_len, 1);
-	}
-	return ret;
-}
diff --git a/disk-io.c b/disk-io.c
index 473f7c1..6fb57be 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -112,8 +112,8 @@ int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size)
 	return __csum_tree_block_size(buf, csum_size, 1, 1);
 }
 
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-		    int verify)
+static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+			   int verify)
 {
 	u16 csum_size =
 		btrfs_super_csum_size(root->fs_info->super_copy);
@@ -305,8 +305,9 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	return NULL;
 }
 
-int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		     struct extent_buffer *eb)
+static int write_tree_block(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct extent_buffer *eb)
 {
 	int ret;
 	int dev_nr;
@@ -1179,8 +1180,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	return transid > 0 ? 0 : -1;
 }
 
-int write_dev_supers(struct btrfs_root *root, struct btrfs_super_block *sb,
-		     struct btrfs_device *device)
+static int write_dev_supers(struct btrfs_root *root,
+			    struct btrfs_super_block *sb,
+			    struct btrfs_device *device)
 {
 	u64 bytenr;
 	u32 crc;
diff --git a/disk-io.h b/disk-io.h
index effaa9f..7ebb188 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -40,8 +40,6 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid);
-int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		     struct extent_buffer *eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 
@@ -99,8 +97,6 @@ int btrfs_open_device(struct btrfs_device *dev);
 int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 			 int verify);
 int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size);
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 #endif
 
diff --git a/extent-tree.c b/extent-tree.c
index 828f7e3..9fa596b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -57,6 +57,9 @@ static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 			       btrfs_root *extent_root);
+static struct btrfs_block_group_cache *
+btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
+		       *hint, u64 search_start, int data, int owner);
 
 static int remove_sb_from_cache(struct btrfs_root *root,
 				struct btrfs_block_group_cache *cache)
@@ -314,10 +317,9 @@ static int block_group_state_bits(u64 flags)
 	return bits;
 }
 
-struct btrfs_block_group_cache *btrfs_find_block_group(struct btrfs_root *root,
-						 struct btrfs_block_group_cache
-						 *hint, u64 search_start,
-						 int data, int owner)
+static struct btrfs_block_group_cache *
+btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
+		       *hint, u64 search_start, int data, int owner)
 {
 	struct btrfs_block_group_cache *cache;
 	struct extent_io_tree *block_group_cache;
@@ -2012,25 +2014,6 @@ next:
 	return 0;
 }
 
-int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
-{
-	u64 last = 0;
-	u64 start;
-	u64 end;
-	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
-	int ret;
-
-	while(1) {
-		ret = find_first_extent_bit(pinned_extents, last,
-					    &start, &end, EXTENT_DIRTY);
-		if (ret)
-			break;
-		set_extent_dirty(copy, start, end, GFP_NOFS);
-		last = end + 1;
-	}
-	return 0;
-}
-
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct extent_io_tree *unpin)
@@ -3135,8 +3118,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	return 0;
 }
 
-int find_first_block_group(struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *key)
+static int find_first_block_group(struct btrfs_root *root,
+		struct btrfs_path *path, struct btrfs_key *key)
 {
 	int ret;
 	struct btrfs_key found_key;
@@ -3422,88 +3405,6 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 				  alloc, mark_free);
 }
 
-static int btrfs_count_extents_in_block_group(struct btrfs_root *root,
-					      struct btrfs_path *path, u64 start,
-					      u64 len,
-					      u64 *total)
-{
-	struct btrfs_key key;
-	struct extent_buffer *leaf;
-	u64 bytes_used = 0;
-	int ret;
-	int slot;
-
-	key.offset = 0;
-	key.objectid = start;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
-				&key, path, 0, 0);
-	if (ret < 0)
-		return ret;
-	while(1) {
-		leaf = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret < 0)
-				return ret;
-			if (ret > 0)
-				break;
-			leaf = path->nodes[0];
-			slot = path->slots[0];
-		}
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (key.objectid > start + len)
-			break;
-		if (key.type == BTRFS_EXTENT_ITEM_KEY)
-			bytes_used += key.offset;
-		if (key.type == BTRFS_METADATA_ITEM_KEY)
-			bytes_used += root->leafsize;
-		path->slots[0]++;
-	}
-	*total = bytes_used;
-	btrfs_release_path(path);
-	return 0;
-}
-
-int btrfs_check_block_accounting(struct btrfs_root *root)
-{
-	int ret;
-	u64 start = 0;
-	u64 bytes_used = 0;
-	struct btrfs_path path;
-	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-
-	btrfs_init_path(&path);
-
-	while(1) {
-		cache = btrfs_lookup_block_group(fs_info, start);
-		if (!cache)
-			break;
-
-		ret = btrfs_count_extents_in_block_group(root, &path,
-							 cache->key.objectid,
-							 cache->key.offset,
-							 &bytes_used);
-
-		if (ret == 0) {
-			u64 on_disk = btrfs_block_group_used(&cache->item);
-			if (on_disk != bytes_used) {
-				fprintf(stderr, "bad block group accounting found %llu "
-					"expected %llu block group %llu\n",
-					(unsigned long long)bytes_used,
-					(unsigned long long)on_disk,
-					(unsigned long long)cache->key.objectid);
-			}
-		}
-		start = cache->key.objectid + cache->key.offset;
-
-		cache->space_info->bytes_used = 0;
-	}
-	return 0;
-}
-
 /*
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
diff --git a/extent_io.c b/extent_io.c
index 62c05fe..acc4702 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -30,8 +30,8 @@
 #include "ctree.h"
 #include "volumes.h"
 
-u64 cache_soft_max = 1024 * 1024 * 256;
-u64 cache_hard_max = 1 * 1024 * 1024 * 1024;
+static u64 cache_soft_max = 1024 * 1024 * 256;
+static u64 cache_hard_max = 1 * 1024 * 1024 * 1024;
 
 void extent_io_tree_init(struct extent_io_tree *tree)
 {
@@ -906,12 +906,6 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 	memcpy(dst->data + dst_offset, src->data + src_offset, len);
 }
 
-void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
-			  unsigned long src_offset, unsigned long len)
-{
-	memcpy(dst->data + dst_offset, dst->data + src_offset, len);
-}
-
 void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len)
 {
diff --git a/extent_io.h b/extent_io.h
index 2604dce..ad283cd 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -122,8 +122,6 @@ void write_extent_buffer(struct extent_buffer *eb, const void *src,
 void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 			unsigned long dst_offset, unsigned long src_offset,
 			unsigned long len);
-void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
-			  unsigned long src_offset, unsigned long len);
 void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
diff --git a/file-item.c b/file-item.c
index c2909dc..515df32 100644
--- a/file-item.c
+++ b/file-item.c
@@ -29,12 +29,6 @@
 #define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
 			       sizeof(struct btrfs_item) * 2) / \
 			       size) - 1))
-int btrfs_create_file(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, u64 dirid, u64 *objectid)
-{
-	return 0;
-}
-
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos, u64 offset,
@@ -122,10 +116,11 @@ fail:
 	return err;
 }
 
-struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path,
-					  u64 bytenr, int cow)
+static struct btrfs_csum_item *
+btrfs_lookup_csum(struct btrfs_trans_handle *trans,
+		  struct btrfs_root *root,
+		  struct btrfs_path *path,
+		  u64 bytenr, int cow)
 {
 	int ret;
 	struct btrfs_key file_key;
@@ -172,23 +167,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid,
-			     u64 offset, int mod)
-{
-	int ret;
-	struct btrfs_key file_key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
-
-	file_key.objectid = objectid;
-	file_key.offset = offset;
-	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
-	ret = btrfs_search_slot(trans, root, &file_key, path, ins_len, cow);
-	return ret;
-}
-
 int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 alloc_end,
 			  u64 bytenr, char *data, size_t len)
diff --git a/free-space-cache.c b/free-space-cache.c
index 6c2e189..35edac2 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -257,7 +257,7 @@ static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
 }
 
 
-int __load_free_space_cache(struct btrfs_root *root,
+static int __load_free_space_cache(struct btrfs_root *root,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_path *path, u64 offset)
 {
diff --git a/inode-item.c b/inode-item.c
index 28865f7..8cc98c6 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -20,7 +20,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 
-int find_name_in_backref(struct btrfs_path *path, const char * name,
+static int find_name_in_backref(struct btrfs_path *path, const char * name,
 			 int name_len, struct btrfs_inode_ref **ref_ret)
 {
 	struct extent_buffer *leaf;
@@ -49,60 +49,6 @@ int find_name_in_backref(struct btrfs_path *path, const char * name,
 	return 0;
 }
 
-int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid)
-{
-	struct btrfs_path *path;
-	struct btrfs_key key;
-	struct btrfs_inode_ref *ref;
-	struct extent_buffer *leaf;
-	unsigned long ptr;
-	unsigned long item_start;
-	u32 item_size;
-	u32 sub_item_len;
-	int ret;
-	int del_len = name_len + sizeof(*ref);
-
-	key.objectid = inode_objectid;
-	key.offset = ref_objectid;
-	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret > 0) {
-		ret = -ENOENT;
-		goto out;
-	} else if (ret < 0) {
-		goto out;
-	}
-	if (!find_name_in_backref(path, name, name_len, &ref)) {
-		ret = -ENOENT;
-		goto out;
-	}
-	leaf = path->nodes[0];
-	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	if (del_len == item_size) {
-		ret = btrfs_del_item(trans, root, path);
-		goto out;
-	}
-	ptr = (unsigned long)ref;
-	sub_item_len = name_len + sizeof(*ref);
-	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
-	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
-			      item_size - (ptr + sub_item_len - item_start));
-	ret = btrfs_truncate_item(trans, root, path,
-				  item_size - sub_item_len, 1);
-	BUG_ON(ret);
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
@@ -158,23 +104,6 @@ out:
 	return ret;
 }
 
-int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct btrfs_path *path, u64 objectid)
-{
-	struct btrfs_key key;
-	int ret;
-	key.objectid = objectid;
-	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
-	key.offset = 0;
-
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(struct btrfs_inode_item));
-	if (ret == 0 && objectid > root->highest_inode)
-		root->highest_inode = objectid;
-	return ret;
-}
-
 int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
 		       *root, struct btrfs_path *path,
 		       struct btrfs_key *location, int mod)
diff --git a/inode-map.c b/inode-map.c
index f901109..3e138b5 100644
--- a/inode-map.c
+++ b/inode-map.c
@@ -20,38 +20,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 
-int btrfs_find_highest_inode(struct btrfs_root *root, u64 *objectid)
-{
-	struct btrfs_path *path;
-	int ret;
-	struct extent_buffer *l;
-	struct btrfs_key search_key;
-	struct btrfs_key found_key;
-	int slot;
-
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
-	search_key.objectid = (u64)-1;
-	search_key.offset = (u64)-1;
-	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
-	if (ret < 0)
-		goto error;
-	BUG_ON(ret == 0);
-	if (path->slots[0] > 0) {
-		slot = path->slots[0] - 1;
-		l = path->nodes[0];
-		btrfs_item_key_to_cpu(l, &found_key, slot);
-		*objectid = found_key.objectid;
-	} else {
-		*objectid = BTRFS_FIRST_FREE_OBJECTID;
-	}
-	ret = 0;
-error:
-	btrfs_free_path(path);
-	return ret;
-}
-
 /*
  * walks the btree of allocated inodes and find a hole.
  */
diff --git a/qgroup.c b/qgroup.c
index dafde12..038c4dc 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -54,8 +54,8 @@ int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
 			     2 * p->num_excl_copies);
 }
 
-int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n,
-			   int pos)
+static int
+qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
 {
 	struct btrfs_qgroup_inherit *out;
 	int nitems = 0;
diff --git a/qgroup.h b/qgroup.h
index ad14c88..da6d113 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -24,8 +24,6 @@
 
 u64 parse_qgroupid(char *p);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
-int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit,
-			   int incgroups, int inccopies);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
 int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
 			    int type);
diff --git a/root-tree.c b/root-tree.c
index 9e5f35f..f8ae8e0 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -138,33 +138,6 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	return ret;
 }
 
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   struct btrfs_key *key)
-{
-	struct btrfs_path *path;
-	int ret;
-	u32 refs;
-	struct btrfs_root_item *ri;
-	struct extent_buffer *leaf;
-
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret != 0);
-	leaf = path->nodes[0];
-	ri = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_item);
-
-	refs = btrfs_disk_root_refs(leaf, ri);
-	BUG_ON(refs != 0);
-	ret = btrfs_del_item(trans, root, path);
-out:
-	btrfs_release_path(path);
-	btrfs_free_path(path);
-	return ret;
-}
-
 /*
  * add a btrfs_root_ref item.  type is either BTRFS_ROOT_REF_KEY
  * or BTRFS_ROOT_BACKREF_KEY.
diff --git a/volumes.c b/volumes.c
index afc0abc..48f5f71 100644
--- a/volumes.c
+++ b/volumes.c
@@ -379,11 +379,11 @@ error:
 	return ret;
 }
 
-int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-			   struct btrfs_device *device,
-			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset,
-			   u64 num_bytes, u64 *start)
+static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+				  struct btrfs_device *device,
+				  u64 chunk_tree, u64 chunk_objectid,
+				  u64 chunk_offset,
+				  u64 num_bytes, u64 *start)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1000,11 +1000,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-void btrfs_mapping_init(struct btrfs_mapping_tree *tree)
-{
-	cache_tree_init(&tree->cache_tree);
-}
-
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 {
 	struct cache_extent *ce;
@@ -1401,60 +1396,6 @@ btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
 	return NULL;
 }
 
-int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
-			      struct btrfs_fs_devices *fs_devices)
-{
-	struct map_lookup *map;
-	u64 logical = BTRFS_SUPER_INFO_OFFSET;
-	u64 length = BTRFS_SUPER_INFO_SIZE;
-	int num_stripes = 0;
-	int sub_stripes = 0;
-	int ret;
-	int i;
-	struct list_head *cur;
-
-	list_for_each(cur, &fs_devices->devices) {
-		num_stripes++;
-	}
-	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
-	if (!map)
-		return -ENOMEM;
-
-	map->ce.start = logical;
-	map->ce.size = length;
-	map->num_stripes = num_stripes;
-	map->sub_stripes = sub_stripes;
-	map->io_width = length;
-	map->io_align = length;
-	map->sector_size = length;
-	map->stripe_len = length;
-	map->type = BTRFS_BLOCK_GROUP_RAID1;
-
-	i = 0;
-	list_for_each(cur, &fs_devices->devices) {
-		struct btrfs_device *device = list_entry(cur,
-							 struct btrfs_device,
-							 dev_list);
-		map->stripes[i].physical = logical;
-		map->stripes[i].dev = device;
-		i++;
-	}
-	ret = insert_cache_extent(&map_tree->cache_tree, &map->ce);
-	if (ret == -EEXIST) {
-		struct cache_extent *old;
-		struct map_lookup *old_map;
-		old = lookup_cache_extent(&map_tree->cache_tree,
-					  logical, length);
-		old_map = container_of(old, struct map_lookup, ce);
-		remove_cache_extent(&map_tree->cache_tree, old);
-		kfree(old_map);
-		ret = insert_cache_extent(&map_tree->cache_tree,
-						   &map->ce);
-	}
-	BUG_ON(ret);
-	return 0;
-}
-
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 {
 	struct cache_extent *ce;
diff --git a/volumes.h b/volumes.h
index e36f2f5..2802cb0 100644
--- a/volumes.h
+++ b/volumes.h
@@ -141,11 +141,6 @@ struct map_lookup {
 #define BTRFS_RAID6_Q_STRIPE ((u64)-1)
 
 
-int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-			   struct btrfs_device *device,
-			   u64 chunk_tree, u64 chunk_objectid,
-			   u64 chunk_offset,
-			   u64 num_bytes, u64 *start);
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      u64 logical, u64 *length, u64 *type,
 		      struct btrfs_multi_bio **multi_ret, int mirror_num,
@@ -183,8 +178,6 @@ int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
 			  u64 *total_devs, u64 super_offset);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
-int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
-			      struct btrfs_fs_devices *fs_devices);
 struct list_head *btrfs_scanned_uuids(void);
 int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,

