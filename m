From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: Remove offset field from struct btrfs_extent_ref
Date: Wed, 08 Oct 2008 15:54:29 +0800
Message-ID: <48EC6735.6020407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The offset field in struct btrfs_extent_ref records the position
inside file that file extent is referenced by. In the new back
reference system, which tree leaves hold reference to file extent
are recorded explicitly. we can scan these tree leaves, so the
offset field is not useful.

This patch also makes the back reference system check the objectid
when extents are in deleting.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---

diff --git a/btrfsck.c b/btrfsck.c
index c697aaf..494a7a7 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -42,7 +42,6 @@ struct extent_backref {
 	u64 root;
 	u64 generation;
 	u64 owner;
-	u64 offset;
 	u32 num_refs;
 	u32 found_ref;
 	int found_extent_tree;
@@ -159,14 +158,13 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 			if (!print_errs)
 				goto out;
 			fprintf(stderr, "Backref %llu parent %llu"
-				" [%llu %llu %llu %llu %lu]"
+				" [%llu %llu %llu %lu]"
 				" not found in extent tree\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)back->parent,
 				(unsigned long long)back->root,
 				(unsigned long long)back->generation,
 				(unsigned long long)back->owner,
-				(unsigned long long)back->offset,
 				(unsigned long)back->num_refs);
 		}
 		if (!back->found_ref) {
@@ -174,14 +172,13 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 			if (!print_errs)
 				goto out;
 			fprintf(stderr, "Backref %llu parent %llu"
-				" [%llu %llu %llu %llu %lu]"
+				" [%llu %llu %llu %lu]"
 				" not referenced\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)back->parent,
 				(unsigned long long)back->root,
 				(unsigned long long)back->generation,
 				(unsigned long long)back->owner,
-				(unsigned long long)back->offset,
 				(unsigned long)back->num_refs);
 		}
 		if (back->found_ref != back->num_refs) {
@@ -277,14 +274,13 @@ static struct extent_backref *find_backref(struct extent_record *rec,
 
 static struct extent_backref *alloc_backref(struct extent_record *rec,
 					    u64 parent, u64 root, u64 gen,
-					    u64 owner, u64 owner_offset)
+					    u64 owner)
 {
 	struct extent_backref *ref = malloc(sizeof(*ref));
 	ref->parent = parent;
 	ref->root = root;
 	ref->generation = gen;
 	ref->owner = owner;
-	ref->offset = owner_offset;
 	ref->num_refs = 0;
 	ref->found_extent_tree = 0;
 	ref->found_ref = 0;
@@ -370,7 +366,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 
 static int add_backref(struct cache_tree *extent_cache, u64 bytenr,
 		       u64 parent, u64 root, u64 gen, u64 owner,
-		       u64 owner_offset, u32 num_refs, int found_ref)
+		       u32 num_refs, int found_ref)
 {
 	struct extent_record *rec;
 	struct extent_backref *back;
@@ -390,21 +386,19 @@ static int add_backref(struct cache_tree *extent_cache, u64 bytenr,
 	}
 	back = find_backref(rec, parent, root, gen);
 	if (!back)
-		back = alloc_backref(rec, parent, root, gen, owner,
-				     owner_offset);
+		back = alloc_backref(rec, parent, root, gen, owner);
 
 	if (found_ref) {
 		if (back->found_ref > 0 &&
 		    back->owner < BTRFS_FIRST_FREE_OBJECTID) {
 			fprintf(stderr, "Extent back ref already exists "
 				"for %llu parent %llu root %llu gen %llu "
-				"owner %llu offset %llu num_refs %lu\n",
+				"owner %llu num_refs %lu\n",
 				(unsigned long long)parent,
 				(unsigned long long)bytenr,
 				(unsigned long long)root,
 				(unsigned long long)gen,
 				(unsigned long long)owner,
-				(unsigned long long)owner_offset,
 				(unsigned long)num_refs);
 		}
 		BUG_ON(num_refs != 1);
@@ -413,13 +407,12 @@ static int add_backref(struct cache_tree *extent_cache, u64 bytenr,
 		if (back->found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
 				"for %llu parent %llu root %llu gen %llu "
-				"owner %llu offset %llu num_refs %lu\n",
+				"owner %llu num_refs %lu\n",
 				(unsigned long long)parent,
 				(unsigned long long)bytenr,
 				(unsigned long long)root,
 				(unsigned long long)gen,
 				(unsigned long long)owner,
-				(unsigned long long)owner_offset,
 				(unsigned long)num_refs);
 		}
 		back->num_refs = num_refs;
@@ -620,7 +613,6 @@ static int run_next_block(struct btrfs_root *root,
 					btrfs_ref_root(buf, ref),
 					btrfs_ref_generation(buf, ref),
 					btrfs_ref_objectid(buf, ref),
-					btrfs_ref_offset(buf, ref),
 					btrfs_ref_num_refs(buf, ref), 0);
 				continue;
 			}
@@ -651,8 +643,7 @@ static int run_next_block(struct btrfs_root *root,
 				    buf->start,
 				    btrfs_header_owner(buf),
 				    btrfs_header_generation(buf),
-				    btrfs_disk_key_objectid(&disk_key),
-				    btrfs_disk_key_offset(&disk_key), 1, 1);
+				    btrfs_disk_key_objectid(&disk_key), 1, 1);
 			BUG_ON(ret);
 		}
 	} else {
@@ -671,7 +662,7 @@ static int run_next_block(struct btrfs_root *root,
 			add_backref(extent_cache, ptr, buf->start,
 				btrfs_header_owner(buf),
 				btrfs_header_generation(buf),
-				level - 1, 0, 1, 1);
+				level - 1, 1, 1);
 
 			if (level > 1) {
 				add_pending(nodes, seen, ptr, size);
@@ -705,7 +696,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 
 	add_backref(extent_cache, buf->start, buf->start, root_objectid,
 		    btrfs_header_generation(buf),
-		    btrfs_header_level(buf), 0, 1, 1);
+		    btrfs_header_level(buf), 1, 1);
 	return 0;
 }
 
diff --git a/ctree.c b/ctree.c
index 925cafa..84ebf2b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -182,7 +182,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 					  buf->len, buf->start,
 					  root->root_key.objectid,
 					  btrfs_header_generation(buf),
-					  0, 0, 1);
+					  level, 1);
 		}
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
@@ -196,7 +196,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 		btrfs_free_extent(trans, root, buf->start, buf->len,
 				  parent_start, btrfs_header_owner(parent),
-				  btrfs_header_generation(parent), 0, 0, 1);
+				  btrfs_header_generation(parent), level, 1);
 	}
 	free_extent_buffer(buf);
 	btrfs_mark_buffer_dirty(cow);
@@ -694,8 +694,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_extent_ref(trans, root, child->start,
 					      mid->start, child->start,
 					      root->root_key.objectid,
-					      trans->transid,
-					      level - 1, 0);
+					      trans->transid, level - 1);
 		BUG_ON(ret);
 
 		add_root_to_dirty_list(root);
@@ -706,7 +705,8 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
 					mid->start, root->root_key.objectid,
-					btrfs_header_generation(mid), 0, 0, 1);
+					btrfs_header_generation(mid),
+					level, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
 		return ret;
@@ -770,7 +770,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 			wret = btrfs_free_extent(trans, root, bytenr,
 						 blocksize, parent->start,
 						 btrfs_header_owner(parent),
-						 generation, 0, 0, 1);
+						 generation, level, 1);
 			if (wret)
 				ret = wret;
 		} else {
@@ -818,7 +818,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
 					 parent->start,
 					 btrfs_header_owner(parent),
-					 root_gen, 0, 0, 1);
+					 root_gen, level, 1);
 		if (wret)
 			ret = wret;
 	} else {
@@ -1411,7 +1411,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_extent_ref(trans, root, lower->start,
 				      lower->start, c->start,
 				      root->root_key.objectid,
-				      trans->transid, level - 1, 0);
+				      trans->transid, level - 1);
 	BUG_ON(ret);
 
 	/* the super has an extra ref to root->node */
@@ -2520,7 +2520,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					 leaf->start, leaf->len,
 					 path->nodes[1]->start,
 					 btrfs_header_owner(path->nodes[1]),
-					 root_gen, 0, 0, 1);
+					 root_gen, 0, 1);
 			if (wret)
 				ret = wret;
 		}
@@ -2575,7 +2575,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 				wret = btrfs_free_extent(trans, root, bytenr,
 					     blocksize, path->nodes[1]->start,
 					     btrfs_header_owner(path->nodes[1]),
-					     root_gen, 0, 0, 1);
+					     root_gen, 0, 1);
 				if (wret)
 					ret = wret;
 			} else {
diff --git a/ctree.h b/ctree.h
index fe5f2bf..90bd940 100644
--- a/ctree.h
+++ b/ctree.h
@@ -351,7 +351,6 @@ struct btrfs_extent_ref {
 	__le64 root;
 	__le64 generation;
 	__le64 objectid;
-	__le64 offset;
 	__le32 num_refs;
 } __attribute__ ((__packed__));
 
@@ -921,7 +920,6 @@ static inline u8 *btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
 BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
 BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
-BTRFS_SETGET_FUNCS(ref_offset, struct btrfs_extent_ref, offset, 64);
 BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
 
 BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
@@ -929,8 +927,6 @@ BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
 			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref,
-			 offset, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
 			 num_refs, 32);
 
@@ -1323,21 +1319,11 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					     int level,
 					     u64 hint,
 					     u64 empty_size);
-int btrfs_grow_extent_tree(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 new_size);
-int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 new_size);
-int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path,
-				 u64 bytenr, u64 parent,
-				 u64 root_objectid, u64 ref_generation,
-				 u64 owner, u64 owner_offset);
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       u64 num_bytes, u64 parent,
 		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 owner_offset,
-		       u64 empty_size, u64 hint_byte,
+		       u64 owner, u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, int data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
@@ -1348,7 +1334,7 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, u64 owner_offset, int pin);
+		      u64 owner_objectid, int pin);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct extent_io_tree *unpin);
@@ -1356,12 +1342,12 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
 				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset);
+				u64 owner_objectid);
 int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 bytenr,
 			    u64 orig_parent, u64 parent,
 			    u64 root_objectid, u64 ref_generation,
-			    u64 owner_objectid, u64 owner_offset);
+			    u64 owner_objectid);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
diff --git a/debug-tree.c b/debug-tree.c
index de295df..885962b 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -58,13 +58,12 @@ static void print_extent_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printf("%llu %llu extent back ref root %llu gen %llu "
-			       "owner %llu offset %llu num_refs %lu\n",
+			       "owner %llu num_refs %lu\n",
 			       (unsigned long long)last,
 			       (unsigned long long)last_len,
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref),
 			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 		};
diff --git a/extent-tree.c b/extent-tree.c
index a329803..e5c304c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -474,13 +474,15 @@ found:
 
 static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
 					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 bytenr,
-					  u64 parent, u64 ref_root,
-					  u64 ref_generation, int del)
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 ref_root, u64 ref_generation,
+					  u64 owner_objectid, int del)
 {
 	struct btrfs_key key;
 	struct btrfs_extent_ref *ref;
 	struct extent_buffer *leaf;
+	u64 ref_objectid;
 	int ret;
 
 	key.objectid = bytenr;
@@ -497,8 +499,11 @@ static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	ref_objectid = btrfs_ref_objectid(leaf, ref);
 	if (btrfs_ref_root(leaf, ref) != ref_root ||
-	    btrfs_ref_generation(leaf, ref) != ref_generation) {
+	    btrfs_ref_generation(leaf, ref) != ref_generation ||
+	    (ref_objectid != owner_objectid &&
+	     ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
 		ret = -EIO;
 		WARN_ON(1);
 		goto out;
@@ -513,7 +518,7 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 ref_root, u64 ref_generation,
-					  u64 owner_objectid, u64 owner_offset)
+					  u64 owner_objectid)
 {
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -533,7 +538,6 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 		btrfs_set_ref_root(leaf, ref, ref_root);
 		btrfs_set_ref_generation(leaf, ref, ref_generation);
 		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
-		btrfs_set_ref_offset(leaf, ref, owner_offset);
 		btrfs_set_ref_num_refs(leaf, ref, 1);
 	} else if (ret == -EEXIST) {
 		u64 existing_owner;
@@ -553,14 +557,10 @@ static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
 		btrfs_set_ref_num_refs(leaf, ref, num_refs + 1);
 
 		existing_owner = btrfs_ref_objectid(leaf, ref);
-		if (existing_owner == owner_objectid &&
-		    btrfs_ref_offset(leaf, ref) > owner_offset) {
-			btrfs_set_ref_offset(leaf, ref, owner_offset);
-		} else if (existing_owner != owner_objectid &&
-			   existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
+		if (existing_owner != owner_objectid &&
+		    existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
 			btrfs_set_ref_objectid(leaf, ref,
 					BTRFS_MULTIPLE_OBJECTIDS);
-			btrfs_set_ref_offset(leaf, ref, 0);
 		}
 		ret = 0;
 	} else {
@@ -601,7 +601,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 				     u64 orig_parent, u64 parent,
 				     u64 orig_root, u64 ref_root,
 				     u64 orig_generation, u64 ref_generation,
-				     u64 owner_objectid, u64 owner_offset)
+				     u64 owner_objectid)
 {
 	int ret;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
@@ -652,7 +652,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	ret = lookup_extent_backref(trans, extent_root, path,
 				    bytenr, orig_parent, orig_root,
-				    orig_generation, 1);
+				    orig_generation, owner_objectid, 1);
 	if (ret)
 		goto out;
 	ret = remove_extent_backref(trans, extent_root, path);
@@ -660,7 +660,7 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 		goto out;
 	ret = insert_extent_backref(trans, extent_root, path, bytenr,
 				    parent, ref_root, ref_generation,
-				    owner_objectid, owner_offset);
+				    owner_objectid);
 	BUG_ON(ret);
 	finish_current_insert(trans, extent_root);
 	del_pending_extents(trans, extent_root);
@@ -673,7 +673,7 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 bytenr,
 			    u64 orig_parent, u64 parent,
 			    u64 ref_root, u64 ref_generation,
-			    u64 owner_objectid, u64 owner_offset)
+			    u64 owner_objectid)
 {
 	int ret;
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
@@ -683,7 +683,7 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
 					parent, ref_root, ref_root,
 					ref_generation, ref_generation,
-					owner_objectid, owner_offset);
+					owner_objectid);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -693,7 +693,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 orig_parent, u64 parent,
 				  u64 orig_root, u64 ref_root,
 				  u64 orig_generation, u64 ref_generation,
-				  u64 owner_objectid, u64 owner_offset)
+				  u64 owner_objectid)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -735,7 +735,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
 				    path, bytenr, parent,
 				    ref_root, ref_generation,
-				    owner_objectid, owner_offset);
+				    owner_objectid);
 	BUG_ON(ret);
 	finish_current_insert(trans, root->fs_info->extent_root);
 	del_pending_extents(trans, root->fs_info->extent_root);
@@ -748,7 +748,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 ref_root, u64 ref_generation,
-			 u64 owner_objectid, u64 owner_offset)
+			 u64 owner_objectid)
 {
 	int ret;
 	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
@@ -757,7 +757,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	maybe_lock_mutex(root);
 	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
 				     0, ref_root, 0, ref_generation,
-				     owner_objectid, owner_offset);
+				     owner_objectid);
 	maybe_unlock_mutex(root);
 	return ret;
 }
@@ -821,7 +821,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret = 0;
 	int faili = 0;
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64, u64, u64, u64);
+			    u64, u64, u64, u64, u64, u64, u64, u64);
 
 	ref_root = btrfs_header_owner(buf);
 	ref_generation = btrfs_header_generation(buf);
@@ -862,7 +862,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
-					   key.objectid, key.offset);
+					   key.objectid);
 			maybe_unlock_mutex(root);
 
 			if (ret) {
@@ -877,7 +877,7 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					   orig_buf->start, buf->start,
 					   orig_root, ref_root,
 					   orig_generation, ref_generation,
-					   level - 1, 0);
+					   level - 1);
 			maybe_unlock_mutex(root);
 			if (ret) {
 				faili = i;
@@ -978,7 +978,7 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
-					    key.objectid, key.offset);
+					    key.objectid);
 			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
@@ -989,7 +989,7 @@ int btrfs_update_ref(struct btrfs_trans_handle *trans,
 					    orig_buf->start, buf->start,
 					    orig_root, ref_root,
 					    orig_generation, ref_generation,
-					    level - 1, 0);
+					    level - 1);
 			maybe_unlock_mutex(root);
 			if (ret)
 				goto fail;
@@ -1344,13 +1344,14 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						start, extent_op->parent,
 						extent_root->root_key.objectid,
 						extent_op->generation,
-						extent_op->level, 0);
+						extent_op->level);
 			BUG_ON(err);
 		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
 			err = lookup_extent_backref(trans, extent_root, path,
 						start, extent_op->orig_parent,
 						extent_root->root_key.objectid,
-						extent_op->orig_generation, 0);
+						extent_op->orig_generation,
+						extent_op->level, 0);
 			BUG_ON(err);
 
 			clear_extent_bits(&info->extent_ins, start, end,
@@ -1422,8 +1423,7 @@ pinit:
 static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 			 *root, u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 ref_generation,
-			 u64 owner_objectid, u64 owner_offset, int pin,
-			 int mark_free)
+			 u64 owner_objectid, int pin, int mark_free)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -1446,8 +1446,9 @@ static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (!path)
 		return -ENOMEM;
 
-	ret = lookup_extent_backref(trans, extent_root, path, bytenr, parent,
-				    root_objectid, ref_generation, 1);
+	ret = lookup_extent_backref(trans, extent_root, path,
+				    bytenr, parent, root_objectid,
+				    ref_generation, owner_objectid, 1);
 	if (ret == 0) {
 		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
@@ -1477,12 +1478,11 @@ static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 	} else {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		printk("Unable to find ref byte nr %llu root %llu "
-		       " gen %llu owner %llu offset %llu\n",
+		       " gen %llu owner %llu\n",
 		       (unsigned long long)bytenr,
 		       (unsigned long long)root_objectid,
 		       (unsigned long long)ref_generation,
-		       (unsigned long long)owner_objectid,
-		       (unsigned long long)owner_offset);
+		       (unsigned long long)owner_objectid);
 		BUG_ON(1);
 	}
 
@@ -1602,7 +1602,7 @@ free_extent:
 					    extent_op->orig_parent,
 					    extent_root->root_key.objectid,
 					    extent_op->orig_generation,
-					    extent_op->level, 0, 0, mark_free);
+					    extent_op->level, 0, mark_free);
 			kfree(extent_op);
 		} else {
 			kfree(extent_op);
@@ -1634,7 +1634,7 @@ free_extent:
 int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
-		      u64 owner_objectid, u64 owner_offset, int pin)
+		      u64 owner_objectid, int pin)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	int pending_ret;
@@ -1665,7 +1665,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
 			    root_objectid, ref_generation,
-			    owner_objectid, owner_offset, pin, pin == 0);
+			    owner_objectid, pin, pin == 0);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
 	return ret ? ret : pending_ret;
 }
@@ -1809,8 +1809,7 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       u64 num_bytes, u64 parent,
 		       u64 root_objectid, u64 ref_generation,
-		       u64 owner, u64 owner_offset,
-		       u64 empty_size, u64 hint_byte,
+		       u64 owner, u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, int data)
 {
 	int ret;
@@ -1935,7 +1934,6 @@ found:
 	btrfs_set_ref_root(path->nodes[0], ref, root_objectid);
 	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
 	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
-	btrfs_set_ref_offset(path->nodes[0], ref, owner_offset);
 	btrfs_set_ref_num_refs(path->nodes[0], ref, 1);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -1983,7 +1981,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_alloc_extent(trans, root, blocksize, parent,
 				 root_objectid, ref_generation,
-				 level, 0, empty_size, hint,
+				 level, empty_size, hint,
 				 (u64)-1, &ins, 0);
 	if (ret) {
 		BUG_ON(ret > 0);
@@ -1995,7 +1993,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 			parent = ins.objectid;
 		btrfs_free_extent(trans, root, ins.objectid, blocksize,
 				  parent, root->root_key.objectid,
-				  ref_generation, 0, 0, 0);
+				  ref_generation, level, 0);
 		BUG_ON(1);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -2041,7 +2039,7 @@ static int noinline drop_leaf_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_free_extent(trans, root, disk_bytenr,
 				btrfs_file_extent_disk_num_bytes(leaf, fi),
 				leaf->start, leaf_owner, leaf_generation,
-				key.objectid, key.offset, 0);
+				key.objectid, 0);
 		BUG_ON(ret);
 	}
 	return 0;
@@ -2153,7 +2151,7 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			path->slots[*level]++;
 			ret = btrfs_free_extent(trans, root, bytenr, blocksize,
 						parent->start, root_owner,
-						root_gen, 0, 0, 1);
+						root_gen, *level - 1, 1);
 			BUG_ON(ret);
 			continue;
 		}
@@ -2165,24 +2163,6 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			next = read_tree_block(root, bytenr, blocksize,
 					       ptr_gen);
 			mutex_lock(&root->fs_info->fs_mutex);
-
-			/* we dropped the lock, check one more time */
-			ret = lookup_extent_ref(trans, root, bytenr,
-						blocksize, &refs);
-			BUG_ON(ret);
-			if (refs != 1) {
-				parent = path->nodes[*level];
-				root_owner = btrfs_header_owner(parent);
-				root_gen = btrfs_header_generation(parent);
-
-				path->slots[*level]++;
-				free_extent_buffer(next);
-				ret = btrfs_free_extent(trans, root, bytenr,
-						blocksize, parent->start,
-						root_owner, root_gen, 0, 0, 1);
-				BUG_ON(ret);
-				continue;
-			}
 		}
 		WARN_ON(*level <= 0);
 		if (path->nodes[*level-1])
@@ -2206,7 +2186,7 @@ out:
 	root_gen = btrfs_header_generation(parent);
 	ret = btrfs_free_extent(trans, root, path->nodes[*level]->start,
 				path->nodes[*level]->len, parent->start,
-				root_owner, root_gen, 0, 0, 1);
+				root_owner, root_gen, *level, 1);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
 	*level += 1;
@@ -2257,7 +2237,7 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
 						parent->start, root_owner,
-						root_gen, 0, 0, 1);
+						root_gen, *level, 1);
 			BUG_ON(ret);
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
diff --git a/print-tree.c b/print-tree.c
index ef85ef9..6c82c8a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -213,11 +213,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printf("\t\textent back ref root %llu gen %llu "
-			       "owner %llu offset %llu, num_refs %lu\n",
+			       "owner %llu num_refs %lu\n",
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref),
 			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
diff --git a/utils.c b/utils.c
index 99223fb..d2cbebc 100644
--- a/utils.c
+++ b/utils.c
@@ -225,7 +225,6 @@ int make_btrfs(int fd, const char *device, const char *label,
 		btrfs_set_ref_root(buf, extent_ref, ref_root);
 		btrfs_set_ref_generation(buf, extent_ref, 1);
 		btrfs_set_ref_objectid(buf, extent_ref, 0);
-		btrfs_set_ref_offset(buf, extent_ref, 0);
 		btrfs_set_ref_num_refs(buf, extent_ref, 1);
 		nritems++;
 	}
