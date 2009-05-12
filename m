From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 2/2] btrfs-progs: update fsck for the mixed back ref
Date: Tue, 12 May 2009 14:05:36 +0800
Message-ID: <4A0911B0.2060201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds check that verifies the correctness of
mixed back ref to btrfsck. The check verifies if all tree
blocks that use the new back ref format are referenced by
their owner trees.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs-2/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2009-01-23 06:01:44.064370471 +0800
+++ btrfs-progs-2/btrfsck.c	2009-05-06 13:16:50.000000000 +0800
@@ -32,19 +32,35 @@
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
 static u64 total_btree_bytes = 0;
+static u64 total_fs_tree_bytes = 0;
 static u64 btree_space_waste = 0;
 static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
 
 struct extent_backref {
 	struct list_head list;
-	u64 parent;
-	u64 root;
-	u64 generation;
+	unsigned int is_data:1;
+	unsigned int found_extent_tree:1;
+	unsigned int full_backref:1;
+	unsigned int found_ref:1;
+};
+
+struct data_backref {
+	struct extent_backref node;
+	union {
+		u64 parent;
+		u64 root;
+	};
 	u64 owner;
+	u64 offset;
 	u32 num_refs;
 	u32 found_ref;
-	int found_extent_tree;
+};
+
+struct tree_backref {
+	struct extent_backref node;
+	u64 parent;
+	u64 root;
 };
 
 struct extent_record {
@@ -53,9 +69,12 @@ struct extent_record {
 	struct btrfs_disk_key parent_key;
 	u64 start;
 	u64 nr;
-	u32 refs;
-	u32 extent_item_refs;
-	int checked;
+	u64 refs;
+	u64 extent_item_refs;
+	u64 block_owner;
+	unsigned int content_checked:1;
+	unsigned int owner_ref_checked:1;
+	unsigned int is_root:1;
 };
 
 struct inode_backref {
@@ -84,6 +103,7 @@ struct inode_backref {
 struct inode_record {
 	struct list_head backrefs;
 	unsigned int checked:1;
+	unsigned int merging:1;
 	unsigned int found_inode_item:1;
 	unsigned int found_dir_item:1;
 	unsigned int found_file_extent:1;
@@ -120,6 +140,7 @@ struct inode_record {
 #define I_ERR_FILE_NBYTES_WRONG		(1 << 10)
 #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
+#define I_ERR_LINK_COUNT_WRONG		(1 << 13)
 
 struct ptr_node {
 	struct cache_extent cache;
@@ -258,7 +279,7 @@ static void maybe_free_inode_rec(struct 
 		}
 	}
 
-	if (!rec->checked)
+	if (!rec->checked || rec->merging)
 		return;
 
 	if (S_ISDIR(rec->imode)) {
@@ -425,6 +446,7 @@ static int merge_inode_recs(struct inode
 	struct inode_backref *backref;
 	struct cache_tree *dst_cache = &dst_node->inode_cache;
 
+	dst->merging = 1;
 	list_for_each_entry(backref, &src->backrefs, list) {
 		if (backref->found_dir_index) {
 			add_inode_backref(dst_cache, dst->ino, backref->dir,
@@ -492,6 +514,7 @@ static int merge_inode_recs(struct inode
 		if (dst_node->current == dst)
 			dst_node->current = NULL;
 	}
+	dst->merging = 0;
 	maybe_free_inode_rec(dst_cache, dst);
 	return 0;
 }
@@ -1001,13 +1024,13 @@ static int walk_down_tree(struct btrfs_r
 	struct extent_buffer *cur;
 	u32 blocksize;
 	int ret;
-	u32 refs;
+	u64 refs;
 
 	WARN_ON(*level < 0);
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
-	ret = btrfs_lookup_extent_ref(NULL, root,
-				      path->nodes[*level]->start,
-				      path->nodes[*level]->len, &refs);
+	ret = btrfs_lookup_extent_info(NULL, root,
+				       path->nodes[*level]->start,
+				       path->nodes[*level]->len, &refs, NULL);
 	BUG_ON(ret);
 	if (refs > 1) {
 		ret = enter_shared_node(root, path->nodes[*level]->start,
@@ -1033,8 +1056,8 @@ static int walk_down_tree(struct btrfs_r
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
 		blocksize = btrfs_level_size(root, *level - 1);
-		ret = btrfs_lookup_extent_ref(NULL, root, bytenr, blocksize,
-					      &refs);
+		ret = btrfs_lookup_extent_info(NULL, root, bytenr, blocksize,
+					       &refs, NULL);
 		BUG_ON(ret);
 
 		if (refs > 1) {
@@ -1159,6 +1182,8 @@ static int check_inode_recs(struct btrfs
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
+		if (rec->found_link != rec->nlink)
+			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		fprintf(stderr, "root %llu inode %llu errors %x\n",
 			root->root_key.objectid, rec->ino, rec->errors);
 		list_for_each_entry(backref, &rec->backrefs, list) {
@@ -1385,7 +1410,9 @@ static int all_backpointers_checked(stru
 {
 	struct list_head *cur = rec->backrefs.next;
 	struct extent_backref *back;
-	u32 found = 0;
+	struct tree_backref *tback;
+	struct data_backref *dback;
+	u64 found = 0;
 	int err = 0;
 
 	while(cur != &rec->backrefs) {
@@ -1395,50 +1422,76 @@ static int all_backpointers_checked(stru
 			err = 1;
 			if (!print_errs)
 				goto out;
-			fprintf(stderr, "Backref %llu parent %llu"
-				" [%llu %llu %llu %lu]"
-				" not found in extent tree\n",
-				(unsigned long long)rec->start,
-				(unsigned long long)back->parent,
-				(unsigned long long)back->root,
-				(unsigned long long)back->generation,
-				(unsigned long long)back->owner,
-				(unsigned long)back->num_refs);
+			if (back->is_data) {
+				dback = (struct data_backref *)back;
+				fprintf(stderr, "Backref %llu %s %llu"
+					" owner %llu offset %llu num_refs %lu"
+					" not found in extent tree\n",
+					(unsigned long long)rec->start,
+					back->full_backref ?
+					"parent" : "root",
+					back->full_backref ?
+					(unsigned long long)dback->parent:
+					(unsigned long long)dback->root,
+					(unsigned long long)dback->owner,
+					(unsigned long long)dback->offset,
+					(unsigned long)dback->num_refs);
+			} else {
+				tback = (struct tree_backref *)back;
+				fprintf(stderr, "Backref %llu parent %llu"
+					" root %llu not found in extent tree\n",
+					(unsigned long long)rec->start,
+					(unsigned long long)tback->parent,
+					(unsigned long long)tback->root);
+			}
 		}
-		if (!back->found_ref) {
+		if (!back->is_data && !back->found_ref) {
 			err = 1;
 			if (!print_errs)
 				goto out;
+			tback = (struct tree_backref *)back;
 			fprintf(stderr, "Backref %llu parent %llu"
-				" [%llu %llu %llu %lu]"
-				" not referenced\n",
+				" root %llu not referenced\n",
 				(unsigned long long)rec->start,
-				(unsigned long long)back->parent,
-				(unsigned long long)back->root,
-				(unsigned long long)back->generation,
-				(unsigned long long)back->owner,
-				(unsigned long)back->num_refs);
+				(unsigned long long)tback->parent,
+				(unsigned long long)tback->root);
 		}
-		if (back->found_ref != back->num_refs) {
-			err = 1;
-			if (!print_errs)
-				goto out;
-			fprintf(stderr, "Incorrect local backref count "
-				"on %llu parent %llu found %u wanted %u\n",
-				(unsigned long long)rec->start,
-				(unsigned long long)back->parent,
-				back->found_ref, back->num_refs);
+		if (back->is_data) {
+			dback = (struct data_backref *)back;
+			if (dback->found_ref != dback->num_refs) {
+				err = 1;
+				if (!print_errs)
+					goto out;
+				fprintf(stderr, "Incorrect local backref count"
+					" on %llu %s %llu owner %llu"
+					" offset %llu found %u wanted %u\n",
+					(unsigned long long)rec->start,
+					back->full_backref ?
+					"parent" : "root",
+					back->full_backref ? 
+					(unsigned long long)dback->parent:
+					(unsigned long long)dback->root,
+					(unsigned long long)dback->owner,
+					(unsigned long long)dback->offset,
+					dback->found_ref, dback->num_refs);
+			}
+		}
+		if (!back->is_data) {
+			found += 1;
+		} else {
+			dback = (struct data_backref *)back;
+			found += dback->found_ref;
 		}
-		found += back->found_ref;
 	}
 	if (found != rec->refs) {
 		err = 1;
 		if (!print_errs)
 			goto out;
 		fprintf(stderr, "Incorrect global backref count "
-			"on %llu found %u wanted %u\n",
+			"on %llu found %llu wanted %llu\n",
 			(unsigned long long)rec->start,
-			found, rec->refs);
+			(unsigned long long)found,
+			(unsigned long long)rec->refs);
 	}
 out:
 	return err;
@@ -1460,8 +1513,9 @@ static int free_all_extent_backrefs(stru
 static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 				 struct extent_record *rec)
 {
-	if (rec->checked && rec->extent_item_refs == rec->refs &&
-	    rec->refs > 0 && !all_backpointers_checked(rec, 0)) {
+	if (rec->content_checked && rec->owner_ref_checked &&
+	    rec->extent_item_refs == rec->refs && rec->refs > 0 &&
+	    !all_backpointers_checked(rec, 0)) {
 		remove_cache_extent(extent_cache, &rec->cache);
 		free_all_extent_backrefs(rec);
 		free(rec);
@@ -1469,9 +1523,27 @@ static int maybe_free_extent_rec(struct 
 	return 0;
 }
 
+static void check_owner_ref(struct extent_record *rec)
+{
+	struct extent_backref *node;
+	struct tree_backref *back;
+
+	list_for_each_entry(node, &rec->backrefs, list) {
+		if (node->is_data)
+			continue;
+		if (!node->found_ref)
+			continue;
+		back = (struct tree_backref *)node;
+		if (rec->block_owner == back->root) {
+			rec->owner_ref_checked = 1;
+			return;
+		}
+	}
+}
+
 static int check_block(struct btrfs_root *root,
 		       struct cache_tree *extent_cache,
-		       struct extent_buffer *buf)
+		       struct extent_buffer *buf, u64 flags)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
@@ -1486,50 +1558,124 @@ static int check_block(struct btrfs_root
 	} else {
 		ret = check_node(root, &rec->parent_key, buf);
 	}
-	rec->checked = 1;
+	if (!ret)
+		rec->content_checked = 1;
+
+	if (flags & BTRFS_BLOCK_NO_OWNER_REF) {
+		rec->owner_ref_checked = 1;
+	} else {
+		rec->block_owner = btrfs_header_owner(buf);
+		check_owner_ref(rec);
+	}
+
 	if (!ret)
 		maybe_free_extent_rec(extent_cache, rec);
 	return ret;
 }
 
-static struct extent_backref *find_extent_backref(struct extent_record *rec,
-					   u64 parent, u64 root, u64 gen)
+static struct tree_backref *find_tree_backref(struct extent_record *rec,
+						u64 parent, u64 root)
 {
 	struct list_head *cur = rec->backrefs.next;
-	struct extent_backref *back;
+	struct extent_backref *node;
+	struct tree_backref *back;
 
 	while(cur != &rec->backrefs) {
-		back = list_entry(cur, struct extent_backref, list);
+		node = list_entry(cur, struct extent_backref, list);
 		cur = cur->next;
-		if (back->parent != parent)
-			continue;
-		if (back->root != root || back->generation != gen)
+		if (node->is_data)
 			continue;
-		return back;
+		back = (struct tree_backref *)node;
+		if (parent > 0) {
+			if (!node->full_backref)
+				continue;
+			if (parent == back->parent)
+				return back;
+		} else {
+			if (node->full_backref)
+				continue;
+			if (back->root == root)
+				return back;
+		}
 	}
 	return NULL;
 }
 
-static struct extent_backref *alloc_extent_backref(struct extent_record *rec,
-						   u64 parent, u64 root,
-						   u64 gen, u64 owner)
+static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
+						u64 parent, u64 root)
 {
-	struct extent_backref *ref = malloc(sizeof(*ref));
-	ref->parent = parent;
+	struct tree_backref *ref = malloc(sizeof(*ref));
+	memset(&ref->node, 0, sizeof(ref->node));
+	if (parent > 0) {
+		ref->parent = parent;
+		ref->node.full_backref = 1;
+	} else {
+		ref->parent = 0;
+		ref->node.full_backref = 0;
+	}
 	ref->root = root;
-	ref->generation = gen;
-	ref->owner = owner;
-	ref->num_refs = 0;
-	ref->found_extent_tree = 0;
+	list_add_tail(&ref->node.list, &rec->backrefs);
+	return ref;
+}
+
+static struct data_backref *find_data_backref(struct extent_record *rec,
+						u64 parent, u64 root,
+						u64 owner, u64 offset)
+{
+	struct list_head *cur = rec->backrefs.next;
+	struct extent_backref *node;
+	struct data_backref *back;
+
+	while(cur != &rec->backrefs) {
+		node = list_entry(cur, struct extent_backref, list);
+		cur = cur->next;
+		if (!node->is_data)
+			continue;
+		back = (struct data_backref *)node;
+		if (parent > 0) { 
+			if (!node->full_backref)
+				continue;
+			if (parent == back->parent)
+				return back;
+		} else {
+			if (node->full_backref)
+				continue;
+			if (back->root == root && back->owner == owner &&
+			    back->offset == offset)
+				return back;
+		}
+	}
+	return NULL;
+}
+
+static struct data_backref *alloc_data_backref(struct extent_record *rec,
+						u64 parent, u64 root,
+						u64 owner, u64 offset)
+{
+	struct data_backref *ref = malloc(sizeof(*ref));
+	memset(&ref->node, 0, sizeof(ref->node));
+	ref->node.is_data = 1;
+	if (parent > 0) {
+		ref->parent = parent;
+		ref->owner = 0;
+		ref->offset = 0;
+		ref->node.full_backref = 1;
+	} else {
+		ref->root = root;
+		ref->owner = owner;
+		ref->offset = offset;
+		ref->node.full_backref = 0;
+	}
 	ref->found_ref = 0;
-	list_add_tail(&ref->list, &rec->backrefs);
+	ref->num_refs = 0;
+	list_add_tail(&ref->node.list, &rec->backrefs);
 	return ref;
 }
 
 static int add_extent_rec(struct cache_tree *extent_cache,
 			  struct btrfs_disk_key *parent_key,
-			  u64 ref, u64 start, u64 nr,
-			  u32 extent_item_refs, int inc_ref, int set_checked)
+			  u64 start, u64 nr, u64 extent_item_refs,
+			  int is_root, int inc_ref, int set_checked)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
@@ -1552,15 +1698,20 @@ static int add_extent_rec(struct cache_t
 		if (extent_item_refs) {
 			if (rec->extent_item_refs) {
 				fprintf(stderr, "block %llu rec "
-					"extent_item_refs %u, passed %u\n",
+					"extent_item_refs %llu, passed %llu\n",
 					(unsigned long long)start,
-					rec->extent_item_refs,
-					extent_item_refs);
+					(unsigned long long)
+							rec->extent_item_refs,
+					(unsigned long long)extent_item_refs);
 			}
 			rec->extent_item_refs = extent_item_refs;
 		}
-		if (set_checked)
-			rec->checked = 1;
+		if (is_root)
+			rec->is_root = 1;
+		if (set_checked) {
+			rec->content_checked = 1;
+			rec->owner_ref_checked = 1;
+		}
 
 		if (parent_key)
 			memcpy(&rec->parent_key, parent_key,
@@ -1570,13 +1721,18 @@ static int add_extent_rec(struct cache_t
 		return ret;
 	}
 	rec = malloc(sizeof(*rec));
-	if (start == 0)
-		extent_item_refs = 0;
 	rec->start = start;
 	rec->nr = nr;
-	rec->checked = 0;
+	rec->block_owner = 0;
+	rec->content_checked = 0;
+	rec->owner_ref_checked = 0;
 	INIT_LIST_HEAD(&rec->backrefs);
 
+	if (is_root)
+		rec->is_root = 1;
+	else
+		rec->is_root = 0;
+
 	if (inc_ref)
 		rec->refs = 1;
 	else
@@ -1597,22 +1753,23 @@ static int add_extent_rec(struct cache_t
 	ret = insert_existing_cache_extent(extent_cache, &rec->cache);
 	BUG_ON(ret);
 	bytes_used += nr;
-	if (set_checked)
-		rec->checked = 1;
+	if (set_checked) {
+		rec->content_checked = 1;
+		rec->owner_ref_checked = 1;
+	}
 	return ret;
 }
 
-static int add_extent_backref(struct cache_tree *extent_cache, u64 bytenr,
-			      u64 parent, u64 root, u64 gen, u64 owner,
-			      u32 num_refs, int found_ref)
+static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
+			    u64 parent, u64 root, int found_ref)
 {
 	struct extent_record *rec;
-	struct extent_backref *back;
+	struct tree_backref *back;
 	struct cache_extent *cache;
 
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
-		add_extent_rec(extent_cache, NULL, 0, bytenr, 1, 0, 0, 0);
+		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0);
 		cache = find_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
@@ -1622,39 +1779,82 @@ static int add_extent_backref(struct cac
 	if (rec->start != bytenr) {
 		abort();
 	}
-	back = find_extent_backref(rec, parent, root, gen);
+
+	back = find_tree_backref(rec, parent, root);
 	if (!back)
-		back = alloc_extent_backref(rec, parent, root, gen, owner);
+		back = alloc_tree_backref(rec, parent, root);
 
 	if (found_ref) {
-		if (back->found_ref > 0 &&
-		    back->owner < BTRFS_FIRST_FREE_OBJECTID) {
+		if (back->node.found_ref) {
 			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu gen %llu "
-				"owner %llu num_refs %lu\n",
+				"for %llu parent %llu root %llu \n",
+				(unsigned long long)bytenr,
 				(unsigned long long)parent,
+				(unsigned long long)root);
+		}
+		back->root = root;
+		back->node.found_ref = 1;
+		if (rec->content_checked && !rec->owner_ref_checked) {
+			if (back->root == rec->block_owner) {
+				rec->owner_ref_checked = 1;
+				maybe_free_extent_rec(extent_cache, rec);
+			}
+		}
+	} else {
+		if (back->node.found_extent_tree) {
+			fprintf(stderr, "Extent back ref already exists "
+				"for %llu parent %llu root %llu \n",
 				(unsigned long long)bytenr,
-				(unsigned long long)root,
-				(unsigned long long)gen,
-				(unsigned long long)owner,
-				(unsigned long)num_refs);
+				(unsigned long long)parent,
+				(unsigned long long)root);
 		}
+		back->node.found_extent_tree = 1;
+	}
+	return 0;
+}
+
+static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
+			    u64 parent, u64 root, u64 owner, u64 offset,
+			    u32 num_refs, int found_ref)
+{
+	struct extent_record *rec;
+	struct data_backref *back;
+	struct cache_extent *cache;
+
+	cache = find_cache_extent(extent_cache, bytenr, 1);
+	if (!cache) {
+		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0);
+		cache = find_cache_extent(extent_cache, bytenr, 1);
+		if (!cache)
+			abort();
+	}
+
+	rec = container_of(cache, struct extent_record, cache);
+	if (rec->start != bytenr) {
+		abort();
+	}
+	back = find_data_backref(rec, parent, root, owner, offset);
+	if (!back)
+		back = alloc_data_backref(rec, parent, root, owner, offset);
+
+	if (found_ref) {
 		BUG_ON(num_refs != 1);
+		back->node.found_ref = 1;
 		back->found_ref += 1;
 	} else {
-		if (back->found_extent_tree) {
+		if (back->node.found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu gen %llu "
-				"owner %llu num_refs %lu\n",
-				(unsigned long long)parent,
+				"for %llu parent %llu root %llu"
+				"owner %llu offset %llu num_refs %lu\n",
 				(unsigned long long)bytenr,
+				(unsigned long long)parent,
 				(unsigned long long)root,
-				(unsigned long long)gen,
 				(unsigned long long)owner,
+				(unsigned long long)offset,
 				(unsigned long)num_refs);
 		}
 		back->num_refs = num_refs;
-		back->found_extent_tree = 1;
+		back->node.found_extent_tree = 1;
 	}
 	return 0;
 }
@@ -1670,6 +1870,7 @@ static int add_pending(struct cache_tree
 	insert_cache_extent(pending, bytenr, size);
 	return 0;
 }
+
 static int pick_next_pending(struct cache_tree *pending,
 			struct cache_tree *reada,
 			struct cache_tree *nodes,
@@ -1751,10 +1952,12 @@ static int run_next_block(struct btrfs_r
 	struct extent_buffer *buf;
 	u64 bytenr;
 	u32 size;
+	u64 parent;
+	u64 owner;
+	u64 flags;
 	int ret;
 	int i;
 	int nritems;
-	struct btrfs_extent_ref *ref;
 	struct btrfs_disk_key disk_key;
 	struct cache_extent *cache;
 	int reada_bits;
@@ -1797,7 +2000,25 @@ static int run_next_block(struct btrfs_r
 	/* fixme, get the real parent transid */
 	buf = read_tree_block(root, bytenr, size, 0);
 	nritems = btrfs_header_nritems(buf);
-	ret = check_block(root, extent_cache, buf);
+
+	ret = btrfs_lookup_extent_info(NULL, root, bytenr, size, NULL, &flags);
+	if (flags & BTRFS_BLOCK_NO_OWNER_REF) {
+		owner = 0;
+		if (!(flags & BTRFS_BLOCK_FULL_BACKREF)) {
+			fprintf(stderr, "Bad extent flags %llu bytenr %llu\n",
+				(unsigned long long)flags,
+				(unsigned long long)bytenr);
+		}
+	} else {
+		owner = btrfs_header_owner(buf);
+	}
+
+	if (flags & BTRFS_BLOCK_FULL_BACKREF)
+		parent = bytenr;
+	else
+		parent = 0;
+
+	ret = check_block(root, extent_cache, buf, flags);
 	if (ret) {
 		fprintf(stderr, "bad block %llu\n",
 			(unsigned long long)bytenr);
@@ -1814,11 +2035,11 @@ static int run_next_block(struct btrfs_r
 				btrfs_disk_key_to_cpu(&found, &disk_key);
 				ei = btrfs_item_ptr(buf, i,
 						    struct btrfs_extent_item);
-				add_extent_rec(extent_cache, NULL, 0,
+				add_extent_rec(extent_cache, NULL,
 					       found.objectid,
 					       found.offset,
 					       btrfs_extent_refs(buf, ei),
-					       0, 0);
+					       0, 0, 0);
 				continue;
 			}
 			if (btrfs_disk_key_type(&disk_key) ==
@@ -1842,16 +2063,46 @@ static int run_next_block(struct btrfs_r
 				continue;
 			}
 			if (btrfs_disk_key_type(&disk_key) ==
-			    BTRFS_EXTENT_REF_KEY) {
+			    BTRFS_TREE_BLOCK_REF_KEY) {
+				add_tree_backref(extent_cache,
+					btrfs_disk_key_objectid(&disk_key), 0,
+					btrfs_disk_key_offset(&disk_key), 0);
+				continue;
+			}
+			if (btrfs_disk_key_type(&disk_key) ==
+			    BTRFS_SHARED_BLOCK_REF_KEY) {
+				add_tree_backref(extent_cache,
+					btrfs_disk_key_objectid(&disk_key),
+					btrfs_disk_key_offset(&disk_key),
+					0, 0);
+				continue;
+			}
+			if (btrfs_disk_key_type(&disk_key) ==
+			    BTRFS_EXTENT_DATA_REF_KEY) {
+				struct btrfs_extent_data_ref *ref;
+				ref = btrfs_item_ptr(buf, i,
+						struct btrfs_extent_data_ref);
+				add_data_backref(extent_cache,
+					btrfs_disk_key_objectid(&disk_key),
+					0, btrfs_extent_data_ref_root(buf, ref),
+					btrfs_extent_data_ref_objectid(buf,
+								       ref),
+					btrfs_extent_data_ref_offset(buf, ref),
+					btrfs_extent_data_ref_count(buf, ref),
+					0);
+				continue;
+			}
+			if (btrfs_disk_key_type(&disk_key) ==
+			    BTRFS_SHARED_DATA_REF_KEY) {
+				struct btrfs_shared_data_ref *ref;
 				ref = btrfs_item_ptr(buf, i,
-						     struct btrfs_extent_ref);
-				add_extent_backref(extent_cache,
+						struct btrfs_shared_data_ref);
+				add_data_backref(extent_cache,
 					btrfs_disk_key_objectid(&disk_key),
 					btrfs_disk_key_offset(&disk_key),
-					btrfs_ref_root(buf, ref),
-					btrfs_ref_generation(buf, ref),
-					btrfs_ref_objectid(buf, ref),
-					btrfs_ref_num_refs(buf, ref), 0);
+					0, 0, 0, 
+					btrfs_shared_data_ref_count(buf, ref),
+					0);
 				continue;
 			}
 			if (btrfs_disk_key_type(&disk_key) !=
@@ -1872,15 +2123,16 @@ static int run_next_block(struct btrfs_r
 			}
 			data_bytes_referenced +=
 				btrfs_file_extent_num_bytes(buf, fi);
-			ret = add_extent_rec(extent_cache, NULL, bytenr,
+			ret = add_extent_rec(extent_cache, NULL,
 				   btrfs_file_extent_disk_bytenr(buf, fi),
 				   btrfs_file_extent_disk_num_bytes(buf, fi),
-				   0, 1, 1);
-			add_extent_backref(extent_cache,
+				   0, 0, 1, 1);
+			add_data_backref(extent_cache,
 				btrfs_file_extent_disk_bytenr(buf, fi),
-				buf->start, btrfs_header_owner(buf),
-				btrfs_header_generation(buf),
-				btrfs_disk_key_objectid(&disk_key), 1, 1);
+				parent, owner,
+				btrfs_disk_key_objectid(&disk_key),
+				btrfs_disk_key_offset(&disk_key) -
+				btrfs_file_extent_offset(buf, fi), 1, 1);
 			BUG_ON(ret);
 		}
 	} else {
@@ -1890,16 +2142,12 @@ static int run_next_block(struct btrfs_r
 			u64 ptr = btrfs_node_blockptr(buf, i);
 			u32 size = btrfs_level_size(root, level - 1);
 			btrfs_node_key(buf, &disk_key, i);
-			ret = add_extent_rec(extent_cache,
-					     &disk_key,
-					     bytenr, ptr, size,
-					     0, 1, 0);
+			ret = add_extent_rec(extent_cache, &disk_key,
+					     ptr, size, 0, 0, 1, 0);
 			BUG_ON(ret);
 
-			add_extent_backref(extent_cache, ptr,
-				buf->start, btrfs_header_owner(buf),
-				btrfs_header_generation(buf),
-				level - 1, 1, 1);
+			add_tree_backref(extent_cache, ptr, parent, 
+					 owner, 1);
 
 			if (level > 1) {
 				add_pending(nodes, seen, ptr, size);
@@ -1911,6 +2159,8 @@ static int run_next_block(struct btrfs_r
 				      nritems) * sizeof(struct btrfs_key_ptr);
 	}
 	total_btree_bytes += buf->len;
+	if (fs_root_objectid(btrfs_header_owner(buf)))
+		total_fs_tree_bytes += buf->len;
 	free_extent_buffer(buf);
 	return 0;
 }
@@ -1922,18 +2172,26 @@ static int add_root_to_pending(struct ex
 			       struct cache_tree *pending,
 			       struct cache_tree *seen,
 			       struct cache_tree *reada,
-			       struct cache_tree *nodes, u64 root_objectid)
+			       struct cache_tree *nodes,
+			       struct btrfs_key *root_key)
 {
+	u64 parent;
+	u64 ref_root;
 	if (btrfs_header_level(buf) > 0)
 		add_pending(nodes, seen, buf->start, buf->len);
 	else
 		add_pending(pending, seen, buf->start, buf->len);
-	add_extent_rec(extent_cache, NULL, 0, buf->start, buf->len,
-		       0, 1, 0);
+	add_extent_rec(extent_cache, NULL, buf->start, buf->len,
+		       0, 0, 1, 0);
 
-	add_extent_backref(extent_cache, buf->start, buf->start,
-			root_objectid, btrfs_header_generation(buf),
-			btrfs_header_level(buf), 1, 1);
+	if (root_key->objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		parent = buf->start;
+		ref_root = root_key->offset;
+	} else {
+		parent = 0;
+		ref_root = root_key->objectid;
+	}
+	add_tree_backref(extent_cache, buf->start, parent, ref_root, 1);
 	return 0;
 }
 
@@ -1953,9 +2211,9 @@ static int check_extent_refs(struct btrf
 			fprintf(stderr, "ref mismatch on [%llu %llu] ",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
-			fprintf(stderr, "extent item %u, found %u\n",
-				rec->extent_item_refs,
-				rec->refs);
+			fprintf(stderr, "extent item %llu, found %llu\n",
+				(unsigned long long)rec->extent_item_refs,
+				(unsigned long long)rec->refs);
 			err = 1;
 		}
 		if (all_backpointers_checked(rec, 1)) {
@@ -1965,6 +2223,13 @@ static int check_extent_refs(struct btrf
 
 			err = 1;
 		}
+		if (!rec->owner_ref_checked) {
+			fprintf(stderr, "owner ref check failed [%llu %llu]\n",
+				(unsigned long long)rec->start,
+				(unsigned long long)rec->nr);
+			err = 1;
+		}
+
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
 		free(rec);
@@ -2005,11 +2270,11 @@ static int check_extents(struct btrfs_ro
 
 	add_root_to_pending(root->fs_info->tree_root->node, bits, bits_nr,
 			    &extent_cache, &pending, &seen, &reada, &nodes,
-			    root->fs_info->tree_root->root_key.objectid);
+			    &root->fs_info->tree_root->root_key);
 
 	add_root_to_pending(root->fs_info->chunk_root->node, bits, bits_nr,
 			    &extent_cache, &pending, &seen, &reada, &nodes,
-			    root->fs_info->chunk_root->root_key.objectid);
+			    &root->fs_info->chunk_root->root_key);
 
 	btrfs_init_path(&path);
 	key.offset = 0;
@@ -2041,7 +2306,7 @@ static int check_extents(struct btrfs_ro
 					       btrfs_root_level(&ri)), 0);
 			add_root_to_pending(buf, bits, bits_nr, &extent_cache,
 					    &pending, &seen, &reada, &nodes,
-					    found_key.objectid);
+					    &found_key);
 			free_extent_buffer(buf);
 		}
 		path.slots[0]++;
@@ -2091,6 +2356,8 @@ out:
 	printf("total csum bytes: %llu\n",(unsigned long long)total_csum_bytes);
 	printf("total tree bytes: %llu\n",
 	       (unsigned long long)total_btree_bytes);
+	printf("total fs tree bytes: %llu\n",
+	       (unsigned long long)total_fs_tree_bytes);
 	printf("btree space waste bytes: %llu\n",
 	       (unsigned long long)btree_space_waste);
 	printf("file data blocks allocated: %llu\n referenced %llu\n",

