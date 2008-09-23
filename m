From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH] Btrfs-progs: Full back reference support
Date: Tue, 23 Sep 2008 23:38:50 +0800
Message-ID: <48D90D8A.3010206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

This is the corresponding full back reference patch for btrfs-progs.

This patch makes the back reference system to explicit record the
location of parent node for all types of extents. The location of
parent node is placed into the offset field of backref key. Every
time a tree block is balanced, the back references for the affected
lower level extents are updated.

Regards
Yan Zheng

---
diff -r 0efd1a540ea6 btrfsck.c
--- a/btrfsck.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/btrfsck.c	Tue Sep 23 22:29:02 2008 +0800
@@ -38,12 +38,14 @@
 
 struct extent_backref {
 	struct list_head list;
+	u64 parent;
 	u64 root;
 	u64 generation;
 	u64 owner;
 	u64 offset;
+	u32 num_refs;
+	u32 found_ref;
 	int found_extent_tree;
-	int found_ref;
 };
 
 struct extent_record {
@@ -156,34 +158,51 @@
 			err = 1;
 			if (!print_errs)
 				goto out;
-			fprintf(stderr, "Backref %llu [%llu %llu %llu %llu] "
-				"not found in extent tree\n",
+			fprintf(stderr, "Backref %llu parent %llu"
+				" [%llu %llu %llu %llu %lu]"
+				" not found in extent tree\n",
 				(unsigned long long)rec->start,
+				(unsigned long long)back->parent,
 				(unsigned long long)back->root,
 				(unsigned long long)back->generation,
 				(unsigned long long)back->owner,
-				(unsigned long long)back->offset);
+				(unsigned long long)back->offset,
+				(unsigned long)back->num_refs);
 		}
 		if (!back->found_ref) {
 			err = 1;
 			if (!print_errs)
 				goto out;
-			fprintf(stderr, "Backref %llu [%llu %llu %llu %llu] "
-				"not referenced\n",
+			fprintf(stderr, "Backref %llu parent %llu"
+				" [%llu %llu %llu %llu %lu]"
+				" not referenced\n",
 				(unsigned long long)rec->start,
+				(unsigned long long)back->parent,
 				(unsigned long long)back->root,
 				(unsigned long long)back->generation,
 				(unsigned long long)back->owner,
-				(unsigned long long)back->offset);
+				(unsigned long long)back->offset,
+				(unsigned long)back->num_refs);
 		}
-		found++;
+		if (back->found_ref != back->num_refs) {
+			err = 1;
+			if (!print_errs)
+				goto out;
+			fprintf(stderr, "Incorrect local backref count "
+				"on %llu parent %llu found %u wanted %u\n",
+				(unsigned long long)rec->start,
+				(unsigned long long)back->parent,
+				back->found_ref, back->num_refs);
+		}
+		found += back->found_ref;
 	}
 	if (found != rec->refs) {
 		err = 1;
 		if (!print_errs)
 			goto out;
-		fprintf(stderr, "Incorrect backref count on %llu found %u "
-			"wanted %u\n", (unsigned long long)rec->start,
+		fprintf(stderr, "Incorrect global backref count "
+			"on %llu found %u wanted %u\n",
+			(unsigned long long)rec->start,
 			found, rec->refs);
 	}
 out:
@@ -239,8 +258,7 @@
 }
 
 static struct extent_backref *find_backref(struct extent_record *rec,
-					   u64 root, u64 gen,
-					   u64 owner, u64 owner_offset)
+					   u64 parent, u64 root, u64 gen)
 {
 	struct list_head *cur = rec->backrefs.next;
 	struct extent_backref *back;
@@ -248,11 +266,9 @@
 	while(cur != &rec->backrefs) {
 		back = list_entry(cur, struct extent_backref, list);
 		cur = cur->next;
-		if (back->root != root || gen != back->generation)
+		if (back->parent != parent)
 			continue;
-		if (owner < BTRFS_FIRST_FREE_OBJECTID)
-			return back;
-		if (owner != back->owner || owner_offset != back->offset)
+		if (back->root != root || back->generation != gen)
 			continue;
 		return back;
 	}
@@ -260,14 +276,16 @@
 }
 
 static struct extent_backref *alloc_backref(struct extent_record *rec,
-					    u64 root, u64 gen, u64 owner,
-					    u64 owner_offset)
+					    u64 parent, u64 root, u64 gen,
+					    u64 owner, u64 owner_offset)
 {
 	struct extent_backref *ref = malloc(sizeof(*ref));
+	ref->parent = parent;
 	ref->root = root;
 	ref->generation = gen;
 	ref->owner = owner;
 	ref->offset = owner_offset;
+	ref->num_refs = 0;
 	ref->found_extent_tree = 0;
 	ref->found_ref = 0;
 	list_add_tail(&ref->list, &rec->backrefs);
@@ -351,15 +369,12 @@
 }
 
 static int add_backref(struct cache_tree *extent_cache, u64 bytenr,
-		       u64 root, u64 gen, u64 owner, u64 owner_offset,
-		       int found_ref)
+		       u64 parent, u64 root, u64 gen, u64 owner,
+		       u64 owner_offset, u32 num_refs, int found_ref)
 {
 	struct extent_record *rec;
 	struct extent_backref *back;
 	struct cache_extent *cache;
-
-	if (root < BTRFS_FS_TREE_OBJECTID)
-		gen = 0;
 
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
@@ -373,31 +388,41 @@
 	if (rec->start != bytenr) {
 		abort();
 	}
-	back = find_backref(rec, root, gen, owner, owner_offset);
+	back = find_backref(rec, parent, root, gen);
 	if (!back)
-		back = alloc_backref(rec, root, gen, owner, owner_offset);
+		back = alloc_backref(rec, parent, root, gen, owner,
+				     owner_offset);
 
 	if (found_ref) {
-		if (back->found_ref) {
-			fprintf(stderr, "Back ref already exists for %llu "
-				"root %llu gen %llu owner %llu offset %llu\n",
+		if (back->found_ref > 0 &&
+		    back->owner < BTRFS_FIRST_FREE_OBJECTID) {
+			fprintf(stderr, "Extent back ref already exists "
+				"for %llu parent %llu root %llu gen %llu "
+				"owner %llu offset %llu num_refs %lu\n",
+				(unsigned long long)parent,
 				(unsigned long long)bytenr,
 				(unsigned long long)root,
 				(unsigned long long)gen,
 				(unsigned long long)owner,
-				(unsigned long long)owner_offset);
+				(unsigned long long)owner_offset,
+				(unsigned long)num_refs);
 		}
-		back->found_ref = 1;
+		BUG_ON(num_refs != 1);
+		back->found_ref += 1;
 	} else {
 		if (back->found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
-				"for %llu root %llu gen %llu owner %llu "
-				"offset %llu\n", (unsigned long long)bytenr,
+				"for %llu parent %llu root %llu gen %llu "
+				"owner %llu offset %llu num_refs %lu\n",
+				(unsigned long long)parent,
+				(unsigned long long)bytenr,
 				(unsigned long long)root,
 				(unsigned long long)gen,
 				(unsigned long long)owner,
-				(unsigned long long)owner_offset);
+				(unsigned long long)owner_offset,
+				(unsigned long)num_refs);
 		}
+		back->num_refs = num_refs;
 		back->found_extent_tree = 1;
 	}
 	return 0;
@@ -589,13 +614,14 @@
 			    BTRFS_EXTENT_REF_KEY) {
 				ref = btrfs_item_ptr(buf, i,
 						     struct btrfs_extent_ref);
-
 				add_backref(extent_cache,
-					    btrfs_disk_key_objectid(&disk_key),
-					    btrfs_ref_root(buf, ref),
-					    btrfs_ref_generation(buf, ref),
-					    btrfs_ref_objectid(buf, ref),
-					    btrfs_ref_offset(buf, ref), 0);
+					btrfs_disk_key_objectid(&disk_key),
+					btrfs_disk_key_offset(&disk_key),
+					btrfs_ref_root(buf, ref),
+					btrfs_ref_generation(buf, ref),
+					btrfs_ref_objectid(buf, ref),
+					btrfs_ref_offset(buf, ref),
+					btrfs_ref_num_refs(buf, ref), 0);
 				continue;
 			}
 			if (btrfs_disk_key_type(&disk_key) !=
@@ -622,10 +648,11 @@
 				   0, 1, 1);
 			add_backref(extent_cache,
 				    btrfs_file_extent_disk_bytenr(buf, fi),
+				    buf->start,
 				    btrfs_header_owner(buf),
 				    btrfs_header_generation(buf),
 				    btrfs_disk_key_objectid(&disk_key),
-				    btrfs_disk_key_offset(&disk_key), 1);
+				    btrfs_disk_key_offset(&disk_key), 1, 1);
 			BUG_ON(ret);
 		}
 	} else {
@@ -641,11 +668,10 @@
 					     0, 1, 0);
 			BUG_ON(ret);
 
-			add_backref(extent_cache, ptr,
+			add_backref(extent_cache, ptr, buf->start,
 				btrfs_header_owner(buf),
 				btrfs_header_generation(buf),
-				level - 1,
-			        btrfs_disk_key_objectid(&disk_key), 1);
+				level - 1, 0, 1, 1);
 
 			if (level > 1) {
 				add_pending(nodes, seen, ptr, size);
@@ -677,9 +703,9 @@
 	add_extent_rec(extent_cache, NULL, 0, buf->start, buf->len,
 		       0, 1, 0);
 
-	add_backref(extent_cache, buf->start, root_objectid,
+	add_backref(extent_cache, buf->start, buf->start, root_objectid,
 		    btrfs_header_generation(buf),
-		    btrfs_header_level(buf), 0, 1);
+		    btrfs_header_level(buf), 0, 1, 1);
 	return 0;
 }
 
diff -r 0efd1a540ea6 convert.c
--- a/convert.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/convert.c	Tue Sep 23 22:29:02 2008 +0800
@@ -317,6 +317,8 @@
 	int ret;
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_root *extent_root = info->extent_root;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
 	struct btrfs_key ins_key;
 	struct btrfs_path path;
 	struct btrfs_extent_item extent_item;
@@ -324,13 +326,15 @@
 	u64 nblocks;
 	u64 bytes_used;
 
-	ret = btrfs_insert_file_extent(trans, root, objectid, file_pos,
-				       disk_bytenr, num_bytes, num_bytes);
-	if (ret || disk_bytenr == 0)
+	if (disk_bytenr == 0) {
+		ret = btrfs_insert_file_extent(trans, root, objectid,
+						file_pos, disk_bytenr,
+						num_bytes, num_bytes);
 		return ret;
+	}
 
-	nblocks = btrfs_stack_inode_nblocks(inode) + num_bytes / 512;
-	btrfs_set_stack_inode_nblocks(inode, nblocks);
+	btrfs_init_path(&path);
+
 	if (checksum) {
 		u64 offset;
 		char *buffer;
@@ -355,36 +359,53 @@
 			goto fail;
 	}
 
+	ins_key.objectid = objectid;
+	ins_key.offset = file_pos;
+	btrfs_set_key_type(&ins_key, BTRFS_EXTENT_DATA_KEY);
+	ret = btrfs_insert_empty_item(trans, root, &path, &ins_key,
+				      sizeof(*fi));
+	if (ret)
+		goto fail;
+	leaf = path.nodes[0];
+	fi = btrfs_item_ptr(leaf, path.slots[0],
+			    struct btrfs_file_extent_item);
+	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_disk_bytenr(leaf, fi, disk_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_offset(leaf, fi, 0);
+	btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
+	btrfs_mark_buffer_dirty(leaf);
+
+	nblocks = btrfs_stack_inode_nblocks(inode) + num_bytes / 512;
+	btrfs_set_stack_inode_nblocks(inode, nblocks);
+
 	bytes_used = btrfs_root_used(&root->root_item);
 	btrfs_set_root_used(&root->root_item, bytes_used + num_bytes);
+
 	ins_key.objectid = disk_bytenr;
 	ins_key.offset = num_bytes;
 	btrfs_set_key_type(&ins_key, BTRFS_EXTENT_ITEM_KEY);
-	btrfs_set_stack_extent_refs(&extent_item, 1);
+	btrfs_set_stack_extent_refs(&extent_item, 0);
 	ret = btrfs_insert_item(trans, extent_root, &ins_key,
 				&extent_item, sizeof(extent_item));
 	if (ret == 0) {
 		bytes_used = btrfs_super_bytes_used(&info->super_copy);
 		btrfs_set_super_bytes_used(&info->super_copy, bytes_used +
 					   num_bytes);
-		btrfs_init_path(&path);
-		ret = btrfs_insert_extent_backref(trans, extent_root, &path,
-					disk_bytenr, root->root_key.objectid,
-					trans->transid, objectid, file_pos);
-		if (ret)
-			goto fail;
-		ret = btrfs_update_block_group(trans, root, disk_bytenr,
-					       num_bytes, 1, 0);
-	} else if (ret == -EEXIST) {
-		ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes,
-					   root->root_key.objectid,
-					   trans->transid, objectid, file_pos);
+	} else if (ret != -EEXIST) {
+		goto fail;
 	}
+	btrfs_extent_post_op(trans, extent_root);
+
+	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes,
+				   leaf->start, root->root_key.objectid,
+				   trans->transid, objectid, file_pos);
 	if (ret)
 		goto fail;
-	btrfs_extent_post_op(trans, extent_root);
-	return 0;
+	ret = 0;
 fail:
+	btrfs_release_path(root, &path);
 	return ret;
 }
 
@@ -1795,6 +1816,13 @@
 	ret = btrfs_del_item(trans, root, &path);
 	if (ret)
 		goto fail;
+
+	ret = btrfs_free_extent(trans, root, extent_start, extent_size,
+				leaf->start, root_owner, root_gen, objectid,
+				offset, 0);
+	if (ret)
+		goto fail;
+
 	btrfs_release_path(root, &path);
 
 	key.objectid = objectid;
@@ -1887,8 +1915,6 @@
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(root, &path);
 
-	ret = btrfs_free_extent(trans, root, extent_start, extent_size,
-				root_owner, root_gen, objectid, offset, 0);
 fail:
 	btrfs_release_path(root, &path);
 	return ret;
diff -r 0efd1a540ea6 ctree.c
--- a/ctree.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/ctree.c	Tue Sep 23 22:29:02 2008 +0800
@@ -82,10 +82,8 @@
 		      struct extent_buffer **cow_ret, u64 new_root_objectid)
 {
 	struct extent_buffer *cow;
-	u32 nritems;
 	int ret = 0;
 	int level;
-	struct btrfs_key first_key;
 	struct btrfs_root *new_root;
 
 	new_root = kmalloc(sizeof(*new_root), GFP_NOFS);
@@ -100,19 +98,9 @@
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
-	nritems = btrfs_header_nritems(buf);
-	if (nritems) {
-		if (level == 0)
-			btrfs_item_key_to_cpu(buf, &first_key, 0);
-		else
-			btrfs_node_key_to_cpu(buf, &first_key, 0);
-	} else {
-		first_key.objectid = 0;
-	}
-	cow = __btrfs_alloc_free_block(trans, new_root, buf->len,
-				       new_root_objectid,
-				       trans->transid, first_key.objectid,
-				       level, buf->start, 0);
+	cow = btrfs_alloc_free_block(trans, new_root, buf->len, 0,
+				     new_root_objectid, trans->transid,
+				     level, buf->start, 0);
 	if (IS_ERR(cow)) {
 		kfree(new_root);
 		return PTR_ERR(cow);
@@ -125,7 +113,7 @@
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	ret = btrfs_inc_ref(trans, new_root, buf);
+	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
 	kfree(new_root);
 
 	if (ret)
@@ -143,38 +131,27 @@
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size)
 {
-	u64 root_gen;
+	u64 parent_start;
 	struct extent_buffer *cow;
 	u32 nritems;
 	int ret = 0;
 	int different_trans = 0;
 	int level;
-	struct btrfs_key first_key;
-
-	if (root->ref_cows) {
-		root_gen = trans->transid;
-	} else {
-		root_gen = 0;
-	}
 
 	WARN_ON(root->ref_cows && trans->transid !=
 		root->fs_info->running_transaction->transid);
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
+	if (parent)
+		parent_start = parent->start;
+	else
+		parent_start = 0;
+
 	level = btrfs_header_level(buf);
 	nritems = btrfs_header_nritems(buf);
-	if (nritems) {
-		if (level == 0)
-			btrfs_item_key_to_cpu(buf, &first_key, 0);
-		else
-			btrfs_node_key_to_cpu(buf, &first_key, 0);
-	} else {
-		first_key.objectid = 0;
-	}
-	cow = __btrfs_alloc_free_block(trans, root, buf->len,
-				     root->root_key.objectid,
-				     root_gen, first_key.objectid, level,
-				     search_start, empty_size);
+	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
+				     root->root_key.objectid, trans->transid,
+				     level, search_start, empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -187,26 +164,29 @@
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
 		different_trans = 1;
-		ret = btrfs_inc_ref(trans, root, buf);
+		ret = btrfs_inc_ref(trans, root, buf, cow, NULL);
 		if (ret)
 			return ret;
 	} else {
+		ret = btrfs_update_ref(trans, root, buf, cow, 0, nritems);
+		if (ret)
+			return ret;
 		clean_tree_block(trans, root, buf);
 	}
 
 	if (buf == root->node) {
-		root_gen = btrfs_header_generation(buf);
 		root->node = cow;
 		extent_buffer_get(cow);
 		if (buf != root->commit_root) {
 			btrfs_free_extent(trans, root, buf->start,
-					  buf->len, root->root_key.objectid,
-					  root_gen, 0, 0, 1);
+					  buf->len, buf->start,
+					  root->root_key.objectid,
+					  btrfs_header_generation(buf),
+					  0, 0, 1);
 		}
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
-		root_gen = btrfs_header_generation(parent);
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
 		WARN_ON(trans->transid == 0);
@@ -215,8 +195,8 @@
 		btrfs_mark_buffer_dirty(parent);
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 		btrfs_free_extent(trans, root, buf->start, buf->len,
-				  btrfs_header_owner(parent), root_gen,
-				  0, 0, 1);
+				  parent_start, btrfs_header_owner(parent),
+				  btrfs_header_generation(parent), 0, 0, 1);
 	}
 	free_extent_buffer(buf);
 	btrfs_mark_buffer_dirty(cow);
@@ -710,6 +690,14 @@
 		BUG_ON(ret);
 
 		root->node = child;
+
+		ret = btrfs_update_extent_ref(trans, root, child->start,
+					      mid->start, child->start,
+					      root->root_key.objectid,
+					      trans->transid,
+					      level - 1, 0);
+		BUG_ON(ret);
+
 		add_root_to_dirty_list(root);
 		path->nodes[level] = NULL;
 		clean_tree_block(trans, root, mid);
@@ -717,7 +705,7 @@
 		/* once for the path */
 		free_extent_buffer(mid);
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
-					root->root_key.objectid,
+					mid->start, root->root_key.objectid,
 					btrfs_header_generation(mid), 0, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
@@ -780,7 +768,7 @@
 			if (wret)
 				ret = wret;
 			wret = btrfs_free_extent(trans, root, bytenr,
-						 blocksize,
+						 blocksize, parent->start,
 						 btrfs_header_owner(parent),
 						 generation, 0, 0, 1);
 			if (wret)
@@ -828,6 +816,7 @@
 		if (wret)
 			ret = wret;
 		wret = btrfs_free_extent(trans, root, bytenr, blocksize,
+					 parent->start,
 					 btrfs_header_owner(parent),
 					 root_gen, 0, 0, 1);
 		if (wret)
@@ -1195,6 +1184,41 @@
 }
 
 /*
+ * update item key.
+ *
+ * This function isn't completely safe. It's the caller's responsibility
+ * that the new key won't break the order
+ */
+int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *new_key)
+{
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *eb;
+	int slot;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	if (slot > 0) {
+		btrfs_item_key(eb, &disk_key, slot - 1);
+		if (comp_keys(&disk_key, new_key) >= 0)
+			return -1;
+	}
+	if (slot < btrfs_header_nritems(eb) - 1) {
+		btrfs_item_key(eb, &disk_key, slot + 1);
+		if (comp_keys(&disk_key, new_key) <= 0)
+			return -1;
+	}
+
+	btrfs_cpu_key_to_disk(&disk_key, new_key);
+	btrfs_set_item_key(eb, &disk_key, slot);
+	btrfs_mark_buffer_dirty(eb);
+	if (slot == 0)
+		fixup_low_keys(trans, root, path, &disk_key, 1);
+	return 0;
+}
+
+/*
  * try to push data from one node into the next node left in the
  * tree.
  *
@@ -1253,6 +1277,9 @@
 	btrfs_set_header_nritems(dst, dst_nritems + push_items);
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
+
+	ret = btrfs_update_ref(trans, root, src, dst, dst_nritems, push_items);
+	BUG_ON(ret);
 	return ret;
 }
 
@@ -1314,6 +1341,9 @@
 
 	btrfs_mark_buffer_dirty(src);
 	btrfs_mark_buffer_dirty(dst);
+
+	ret = btrfs_update_ref(trans, root, src, dst, 0, push_items);
+	BUG_ON(ret);
 	return ret;
 }
 
@@ -1328,19 +1358,15 @@
 			   struct btrfs_root *root,
 			   struct btrfs_path *path, int level)
 {
-	u64 root_gen;
 	u64 lower_gen;
 	struct extent_buffer *lower;
 	struct extent_buffer *c;
+	struct extent_buffer *old;
 	struct btrfs_disk_key lower_key;
+	int ret;
 
 	BUG_ON(path->nodes[level]);
 	BUG_ON(path->nodes[level-1] != root->node);
-
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
 	lower = path->nodes[level-1];
 	if (level == 1)
@@ -1348,12 +1374,13 @@
 	else
 		btrfs_node_key(lower, &lower_key, 0);
 
-	c = __btrfs_alloc_free_block(trans, root, root->nodesize,
+	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				   root->root_key.objectid,
-				   root_gen, lower_key.objectid, level,
+				   trans->transid, level,
 				   root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
+
 	memset_extent_buffer(c, 0, 0, root->nodesize);
 	btrfs_set_header_nritems(c, 1);
 	btrfs_set_header_level(c, level);
@@ -1372,31 +1399,28 @@
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
 	lower_gen = btrfs_header_generation(lower);
-	WARN_ON(lower_gen == 0);
+	WARN_ON(lower_gen != trans->transid);
 
 	btrfs_set_node_ptr_generation(c, 0, lower_gen);
 
 	btrfs_mark_buffer_dirty(c);
 
+	old = root->node;
+	root->node = c;
+
+	ret = btrfs_update_extent_ref(trans, root, lower->start,
+				      lower->start, c->start,
+				      root->root_key.objectid,
+				      trans->transid, level - 1, 0);
+	BUG_ON(ret);
+
 	/* the super has an extra ref to root->node */
-	free_extent_buffer(root->node);
-	root->node = c;
+	free_extent_buffer(old);
+
 	add_root_to_dirty_list(root);
 	extent_buffer_get(c);
 	path->nodes[level] = c;
 	path->slots[level] = 0;
-
-	if (root->ref_cows && lower_gen != trans->transid) {
-		struct btrfs_path *back_path = btrfs_alloc_path();
-		int ret;
-		ret = btrfs_insert_extent_backref(trans,
-						  root->fs_info->extent_root,
-						  path, lower->start,
-						  root->root_key.objectid,
-						  trans->transid, 0, 0);
-		BUG_ON(ret);
-		btrfs_free_path(back_path);
-	}
 	return 0;
 }
 
@@ -1450,7 +1474,6 @@
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level)
 {
-	u64 root_gen;
 	struct extent_buffer *c;
 	struct extent_buffer *split;
 	struct btrfs_disk_key disk_key;
@@ -1477,17 +1500,12 @@
 	}
 
 	c_nritems = btrfs_header_nritems(c);
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
 	btrfs_node_key(c, &disk_key, 0);
-	split = __btrfs_alloc_free_block(trans, root, root->nodesize,
+	split = btrfs_alloc_free_block(trans, root, root->nodesize,
+					 path->nodes[level + 1]->start,
 					 root->root_key.objectid,
-					 root_gen,
-					 btrfs_disk_key_objectid(&disk_key),
-					 level, c->start, 0);
+					 trans->transid, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -1523,6 +1541,9 @@
 			  level + 1);
 	if (wret)
 		ret = wret;
+
+	ret = btrfs_update_ref(trans, root, c, split, 0, c_nritems - mid);
+	BUG_ON(ret);
 
 	if (path->slots[level] >= mid) {
 		path->slots[level] -= mid;
@@ -1714,6 +1735,9 @@
 	btrfs_set_node_key(upper, &disk_key, slot + 1);
 	btrfs_mark_buffer_dirty(upper);
 
+	ret = btrfs_update_ref(trans, root, left, right, 0, push_items);
+	BUG_ON(ret);
+
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
@@ -1874,6 +1898,10 @@
 	if (wret)
 		ret = wret;
 
+	ret = btrfs_update_ref(trans, root, right, left,
+			       old_left_nritems, push_items);
+	BUG_ON(ret);
+
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
 		path->slots[0] += old_left_nritems;
@@ -1898,7 +1926,6 @@
 		      *root, struct btrfs_key *ins_key,
 		      struct btrfs_path *path, int data_size, int extend)
 {
-	u64 root_gen;
 	struct extent_buffer *l;
 	u32 nritems;
 	int mid;
@@ -1916,11 +1943,6 @@
 
 	if (extend)
 		space_needed = data_size;
-
-	if (root->ref_cows)
-		root_gen = trans->transid;
-	else
-		root_gen = 0;
 
 	/* first try to make some room by pushing left and right */
 	if (ins_key->type != BTRFS_DIR_ITEM_KEY) {
@@ -1952,12 +1974,10 @@
 	nritems = btrfs_header_nritems(l);
 	mid = (nritems + 1)/ 2;
 
-	btrfs_item_key(l, &disk_key, 0);
-
-	right = __btrfs_alloc_free_block(trans, root, root->leafsize,
-					 root->root_key.objectid,
-					 root_gen, disk_key.objectid, 0,
-					 l->start, 0);
+	right = btrfs_alloc_free_block(trans, root, root->leafsize,
+					path->nodes[1]->start,
+					root->root_key.objectid,
+					trans->transid, 0, l->start, 0);
 	if (IS_ERR(right)) {
 		BUG_ON(1);
 		return PTR_ERR(right);
@@ -2067,6 +2087,9 @@
 	btrfs_mark_buffer_dirty(right);
 	btrfs_mark_buffer_dirty(l);
 	BUG_ON(path->slots[0] != slot);
+
+	ret = btrfs_update_ref(trans, root, l, right, 0, nritems);
+	BUG_ON(ret);
 
 	if (mid <= slot) {
 		free_extent_buffer(path->nodes[0]);
@@ -2495,6 +2518,7 @@
 				ret = wret;
 			wret = btrfs_free_extent(trans, root,
 					 leaf->start, leaf->len,
+					 path->nodes[1]->start,
 					 btrfs_header_owner(path->nodes[1]),
 					 root_gen, 0, 0, 1);
 			if (wret)
@@ -2549,7 +2573,7 @@
 
 				free_extent_buffer(leaf);
 				wret = btrfs_free_extent(trans, root, bytenr,
-					     blocksize,
+					     blocksize, path->nodes[1]->start,
 					     btrfs_header_owner(path->nodes[1]),
 					     root_gen, 0, 0, 1);
 				if (wret)
diff -r 0efd1a540ea6 ctree.h
--- a/ctree.h	Fri Sep 05 16:15:58 2008 -0400
+++ b/ctree.h	Tue Sep 23 22:29:02 2008 +0800
@@ -60,12 +60,22 @@
 
 /* does write ahead logging to speed up fsyncs */
 #define BTRFS_TREE_LOG_OBJECTID -6ULL
+#define BTRFS_TREE_LOG_FIXUP_OBJECTID -7ULL
+
+/* space balancing */
+#define BTRFS_TREE_RELOC_OBJECTID -8ULL
+#define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL
+
+/* dummy objectid represents multiple objectids */
+#define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
 /*
- * All files have objectids higher than this.
+ * All files have objectids in this range.
  */
 #define BTRFS_FIRST_FREE_OBJECTID 256ULL
+#define BTRFS_LAST_FREE_OBJECTID -256ULL
 #define BTRFS_FIRST_CHUNK_TREE_OBJECTID 256ULL
+
 
 
 /*
@@ -342,6 +352,7 @@
 	__le64 generation;
 	__le64 objectid;
 	__le64 offset;
+	__le32 num_refs;
 } __attribute__ ((__packed__));
 
 /* dev extents record free space on individual devices.  The owner
@@ -906,22 +917,25 @@
 	return (u8 *)((unsigned long)dev + ptr);
 }
 
-/* struct btrfs_extent_item */
-BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
-
 /* struct btrfs_extent_ref */
 BTRFS_SETGET_FUNCS(ref_root, struct btrfs_extent_ref, root, 64);
 BTRFS_SETGET_FUNCS(ref_generation, struct btrfs_extent_ref, generation, 64);
 BTRFS_SETGET_FUNCS(ref_objectid, struct btrfs_extent_ref, objectid, 64);
 BTRFS_SETGET_FUNCS(ref_offset, struct btrfs_extent_ref, offset, 64);
+BTRFS_SETGET_FUNCS(ref_num_refs, struct btrfs_extent_ref, num_refs, 32);
 
 BTRFS_SETGET_STACK_FUNCS(stack_ref_root, struct btrfs_extent_ref, root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_generation, struct btrfs_extent_ref,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_ref_objectid, struct btrfs_extent_ref,
 			 objectid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref, offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_offset, struct btrfs_extent_ref,
+			 offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_ref_num_refs, struct btrfs_extent_ref,
+			 num_refs, 32);
 
+/* struct btrfs_extent_item */
+BTRFS_SETGET_FUNCS(extent_refs, struct btrfs_extent_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_extent_refs, struct btrfs_extent_item,
 			 refs, 32);
 
@@ -1291,9 +1305,6 @@
 	btrfs_item_offset_nr(leaf, slot)))
 
 /* extent-tree.c */
-u32 btrfs_count_snapshots_in_path(struct btrfs_root *root,
-				  struct btrfs_path *count_path,
-				  u64 first_extent);
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root);
 int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
@@ -1304,18 +1315,11 @@
 						 struct btrfs_block_group_cache
 						 *hint, u64 search_start,
 						 int data, int owner);
-int btrfs_inc_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, u64 owner_objectid);
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					    struct btrfs_root *root, u32 size,
-					    u64 root_objectid,
-					    u64 hint, u64 empty_size);
-struct extent_buffer *__btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     u32 blocksize,
+					     u32 blocksize, u64 parent,
 					     u64 root_objectid,
 					     u64 ref_generation,
-					     u64 first_objectid,
 					     int level,
 					     u64 hint,
 					     u64 empty_size);
@@ -1324,19 +1328,25 @@
 int btrfs_shrink_extent_tree(struct btrfs_root *root, u64 new_size);
 int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
-				 struct btrfs_path *path, u64 bytenr,
+				 struct btrfs_path *path,
+				 u64 bytenr, u64 parent,
 				 u64 root_objectid, u64 ref_generation,
 				 u64 owner, u64 owner_offset);
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       u64 num_bytes, u64 root_objectid, u64 ref_generation,
+		       u64 num_bytes, u64 parent,
+		       u64 root_objectid, u64 ref_generation,
 		       u64 owner, u64 owner_offset,
 		       u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, int data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf);
+		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
+		  u32 *nr_extents);
+int btrfs_update_ref(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root, struct extent_buffer *orig_buf,
+		     struct extent_buffer *buf, int start_slot, int nr);
 int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, u64 bytenr, u64 num_bytes,
+		      *root, u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
 		      u64 owner_objectid, u64 owner_offset, int pin);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
@@ -1344,9 +1354,14 @@
 			       struct extent_io_tree *unpin);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes,
+				u64 bytenr, u64 num_bytes, u64 parent,
 				u64 root_objectid, u64 ref_generation,
 				u64 owner, u64 owner_offset);
+int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 orig_parent, u64 parent,
+			    u64 root_objectid, u64 ref_generation,
+			    u64 owner_objectid, u64 owner_offset);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
@@ -1357,8 +1372,6 @@
 			   u64 size);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
-u64 btrfs_hash_extent_ref(u64 root_objectid, u64 ref_generation,
-			  u64 owner, u64 owner_offset);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr, u64 num,
 			     int alloc, int mark_free);
@@ -1429,7 +1442,9 @@
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
 			*root);
-
+int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *new_key);
 
 /* root-item.c */
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff -r 0efd1a540ea6 debug-tree.c
--- a/debug-tree.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/debug-tree.c	Tue Sep 23 22:29:02 2008 +0800
@@ -58,13 +58,14 @@
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printf("%llu %llu extent back ref root %llu gen %llu "
-			       "owner %llu offset %llu\n",
+			       "owner %llu offset %llu num_refs %lu\n",
 			       (unsigned long long)last,
 			       (unsigned long long)last_len,
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref));
+			       (unsigned long long)btrfs_ref_offset(l, ref),
+			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 		};
 		fflush(stdout);
diff -r 0efd1a540ea6 extent-tree.c
--- a/extent-tree.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/extent-tree.c	Tue Sep 23 22:29:02 2008 +0800
@@ -33,10 +33,33 @@
 
 #define BLOCK_GROUP_DIRTY EXTENT_DIRTY
 
+#define PENDING_EXTENT_INSERT 0
+#define PENDING_EXTENT_DELETE 1
+#define PENDING_BACKREF_UPDATE 2
+
+struct pending_extent_op {
+	int type;
+	u64 bytenr;
+	u64 num_bytes;
+	u64 parent;
+	u64 orig_parent;
+	u64 generation;
+	u64 orig_generation;
+	int level;
+};
+
 static int finish_current_insert(struct btrfs_trans_handle *trans, struct
 				 btrfs_root *extent_root);
 static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 			       btrfs_root *extent_root);
+
+void maybe_lock_mutex(struct btrfs_root *root)
+{
+}
+
+void maybe_unlock_mutex(struct btrfs_root *root)
+{
+}
 
 static int cache_block_group(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *block_group)
@@ -367,108 +390,6 @@
 	return found_group;
 }
 
-static u64 hash_extent_ref(u64 root_objectid, u64 ref_generation,
-			   u64 owner, u64 owner_offset)
-{
-	u32 high_crc = ~(u32)0;
-	u32 low_crc = ~(u32)0;
-	__le64 lenum;
-
-	lenum = cpu_to_le64(root_objectid);
-	high_crc = crc32c(high_crc, &lenum, sizeof(lenum));
-	lenum = cpu_to_le64(ref_generation);
-	low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
-	if (owner >= BTRFS_FIRST_FREE_OBJECTID) {
-		lenum = cpu_to_le64(owner);
-		low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
-		lenum = cpu_to_le64(owner_offset);
-		low_crc = crc32c(low_crc, &lenum, sizeof(lenum));
-	}
-	return ((u64)high_crc << 32) | (u64)low_crc;
-}
-
-static int match_extent_ref(struct extent_buffer *leaf,
-			    struct btrfs_extent_ref *disk_ref,
-			    struct btrfs_extent_ref *cpu_ref)
-{
-	int ret;
-	int len;
-
-	if (cpu_ref->objectid)
-		len = sizeof(*cpu_ref);
-	else
-		len = 2 * sizeof(u64);
-	ret = memcmp_extent_buffer(leaf, cpu_ref, (unsigned long)disk_ref,
-				   len);
-	return ret == 0;
-}
-
-static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
-					  struct btrfs_path *path, u64 bytenr,
-					  u64 root_objectid,
-					  u64 ref_generation, u64 owner,
-					  u64 owner_offset, int del)
-{
-	u64 hash;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct btrfs_extent_ref ref;
-	struct extent_buffer *leaf;
-	struct btrfs_extent_ref *disk_ref;
-	int ret;
-	int ret2;
-
-	btrfs_set_stack_ref_root(&ref, root_objectid);
-	btrfs_set_stack_ref_generation(&ref, ref_generation);
-	btrfs_set_stack_ref_objectid(&ref, owner);
-	btrfs_set_stack_ref_offset(&ref, owner_offset);
-
-	hash = hash_extent_ref(root_objectid, ref_generation, owner,
-			       owner_offset);
-	key.offset = hash;
-	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_REF_KEY;
-
-	while (1) {
-		ret = btrfs_search_slot(trans, root, &key, path,
-					del ? -1 : 0, del);
-		if (ret < 0)
-			goto out;
-		leaf = path->nodes[0];
-		if (ret != 0) {
-			u32 nritems = btrfs_header_nritems(leaf);
-			if (path->slots[0] >= nritems) {
-				ret2 = btrfs_next_leaf(root, path);
-				if (ret2)
-					goto out;
-				leaf = path->nodes[0];
-			}
-			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-			if (found_key.objectid != bytenr ||
-			    found_key.type != BTRFS_EXTENT_REF_KEY)
-				goto out;
-			key.offset = found_key.offset;
-			if (del) {
-				btrfs_release_path(root, path);
-				continue;
-			}
-		}
-		disk_ref = btrfs_item_ptr(path->nodes[0],
-					  path->slots[0],
-					  struct btrfs_extent_ref);
-		if (match_extent_ref(path->nodes[0], disk_ref, &ref)) {
-			ret = 0;
-			goto out;
-		}
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		key.offset = found_key.offset + 1;
-		btrfs_release_path(root, path);
-	}
-out:
-	return ret;
-}
-
 /*
  * Back reference rules.  Back refs have three main goals:
  *
@@ -486,7 +407,7 @@
  * File extents can be referenced by:
  *
  * - multiple snapshots, subvolumes, or different generations in one subvol
- * - different files inside a single subvolume (in theory, not implemented yet)
+ * - different files inside a single subvolume
  * - different offsets inside a file (bookend extents in file.c)
  *
  * The extent ref structure has fields for:
@@ -495,119 +416,284 @@
  * - Generation number of the tree holding the reference
  * - objectid of the file holding the reference
  * - offset in the file corresponding to the key holding the reference
+ * - number of references holding by parent node (alway 1 for tree blocks)
+ *
+ * Btree leaf may hold multiple references to a file extent. In most cases,
+ * these references are from same file and the corresponding offsets inside
+ * the file are close together. So inode objectid and offset in file are
+ * just hints, they provide hints about where in the btree the references
+ * can be found and when we can stop searching.
  *
  * When a file extent is allocated the fields are filled in:
- *     (root_key.objectid, trans->transid, inode objectid, offset in file)
+ *     (root_key.objectid, trans->transid, inode objectid, offset in file, 1)
  *
  * When a leaf is cow'd new references are added for every file extent found
- * in the leaf.  It looks the same as the create case, but trans->transid
- * will be different when the block is cow'd.
+ * in the leaf.  It looks similar to the create case, but trans->transid will
+ * be different when the block is cow'd.
  *
- *     (root_key.objectid, trans->transid, inode objectid, offset in file)
+ *     (root_key.objectid, trans->transid, inode objectid, offset in file,
+ *      number of references in the leaf)
  *
- * When a file extent is removed either during snapshot deletion or file
- * truncation, the corresponding back reference is found
- * by searching for:
+ * Because inode objectid and offset in file are just hints, they are not
+ * used when backrefs are deleted. When a file extent is removed either
+ * during snapshot deletion or file truncation, we find the corresponding
+ * back back reference and check the following fields.
  *
- *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf),
- *      inode objectid, offset in file)
+ *     (btrfs_header_owner(leaf), btrfs_header_generation(leaf))
  *
  * Btree extents can be referenced by:
  *
  * - Different subvolumes
  * - Different generations of the same subvolume
  *
- * Storing sufficient information for a full reverse mapping of a btree
- * block would require storing the lowest key of the block in the backref,
- * and it would require updating that lowest key either before write out or
- * every time it changed.  Instead, the objectid of the lowest key is stored
- * along with the level of the tree block.  This provides a hint
- * about where in the btree the block can be found.  Searches through the
- * btree only need to look for a pointer to that block, so they stop one
- * level higher than the level recorded in the backref.
- *
- * Some btrees do not do reference counting on their extents.  These
- * include the extent tree and the tree of tree roots.  Backrefs for these
- * trees always have a generation of zero.
- *
  * When a tree block is created, back references are inserted:
  *
- * (root->root_key.objectid, trans->transid or zero, level, lowest_key_objectid)
+ * (root->root_key.objectid, trans->transid, level, 0, 1)
  *
- * When a tree block is cow'd in a reference counted root,
- * new back references are added for all the blocks it points to.
- * These are of the form (trans->transid will have increased since creation):
+ * When a tree block is cow'd, new back references are added for all the
+ * blocks it points to. If the tree block isn't in reference counted root,
+ * the old back references are removed. These new back references are of
+ * the form (trans->transid will have increased since creation):
  *
- * (root->root_key.objectid, trans->transid, level, lowest_key_objectid)
+ * (root->root_key.objectid, trans->transid, level, 0, 1)
  *
- * Because the lowest_key_objectid and the level are just hints
- * they are not used when backrefs are deleted.  When a backref is deleted:
+ * When a backref is in deleting, the following fields are checked:
  *
  * if backref was for a tree root:
- *     root_objectid = root->root_key.objectid
+ *     (btrfs_header_owner(itself), btrfs_header_generation(itself))
  * else
- *     root_objectid = btrfs_header_owner(parent)
+ *     (btrfs_header_owner(parent), btrfs_header_generation(parent))
  *
- * (root_objectid, btrfs_header_generation(parent) or zero, 0, 0)
+ * Back Reference Key composing:
  *
- * Back Reference Key hashing:
- *
- * Back references have four fields, each 64 bits long.  Unfortunately,
- * This is hashed into a single 64 bit number and placed into the key offset.
- * The key objectid corresponds to the first byte in the extent, and the
- * key type is set to BTRFS_EXTENT_REF_KEY
+ * The key objectid corresponds to the first byte in the extent, the key
+ * type is set to BTRFS_EXTENT_REF_KEY, and the key offset is the first
+ * byte of parent extent. If a extent is tree root, the key offset is set
+ * to the key objectid.
  */
-int btrfs_insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path, u64 bytenr,
-				 u64 root_objectid, u64 ref_generation,
-				 u64 owner, u64 owner_offset)
+
+static int noinline lookup_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path, u64 bytenr,
+					  u64 parent, u64 ref_root,
+					  u64 ref_generation, int del)
 {
-	u64 hash;
 	struct btrfs_key key;
-	struct btrfs_extent_ref ref;
-	struct btrfs_extent_ref *disk_ref;
+	struct btrfs_extent_ref *ref;
+	struct extent_buffer *leaf;
 	int ret;
 
-	btrfs_set_stack_ref_root(&ref, root_objectid);
-	btrfs_set_stack_ref_generation(&ref, ref_generation);
-	btrfs_set_stack_ref_objectid(&ref, owner);
-	btrfs_set_stack_ref_offset(&ref, owner_offset);
-
-	hash = hash_extent_ref(root_objectid, ref_generation, owner,
-			       owner_offset);
-	key.offset = hash;
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_REF_KEY;
+	key.offset = parent;
 
-	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(ref));
-	while (ret == -EEXIST) {
-		disk_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					  struct btrfs_extent_ref);
-		if (match_extent_ref(path->nodes[0], disk_ref, &ref))
+	ret = btrfs_search_slot(trans, root, &key, path, del ? -1 : 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	if (btrfs_ref_root(leaf, ref) != ref_root ||
+	    btrfs_ref_generation(leaf, ref) != ref_generation) {
+		ret = -EIO;
+		WARN_ON(1);
+		goto out;
+	}
+	ret = 0;
+out:
+	return ret;
+}
+
+static int noinline insert_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  u64 bytenr, u64 parent,
+					  u64 ref_root, u64 ref_generation,
+					  u64 owner_objectid, u64 owner_offset)
+{
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_ref *ref;
+	u32 num_refs;
+	int ret;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_REF_KEY;
+	key.offset = parent;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*ref));
+	if (ret == 0) {
+		leaf = path->nodes[0];
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		btrfs_set_ref_root(leaf, ref, ref_root);
+		btrfs_set_ref_generation(leaf, ref, ref_generation);
+		btrfs_set_ref_objectid(leaf, ref, owner_objectid);
+		btrfs_set_ref_offset(leaf, ref, owner_offset);
+		btrfs_set_ref_num_refs(leaf, ref, 1);
+	} else if (ret == -EEXIST) {
+		u64 existing_owner;
+		BUG_ON(owner_objectid < BTRFS_FIRST_FREE_OBJECTID);
+		leaf = path->nodes[0];
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		if (btrfs_ref_root(leaf, ref) != ref_root ||
+		    btrfs_ref_generation(leaf, ref) != ref_generation) {
+			ret = -EIO;
+			WARN_ON(1);
 			goto out;
-		key.offset++;
-		btrfs_release_path(root, path);
-		ret = btrfs_insert_empty_item(trans, root, path, &key,
-					      sizeof(ref));
+		}
+
+		num_refs = btrfs_ref_num_refs(leaf, ref);
+		BUG_ON(num_refs == 0);
+		btrfs_set_ref_num_refs(leaf, ref, num_refs + 1);
+
+		existing_owner = btrfs_ref_objectid(leaf, ref);
+		if (existing_owner == owner_objectid &&
+		    btrfs_ref_offset(leaf, ref) > owner_offset) {
+			btrfs_set_ref_offset(leaf, ref, owner_offset);
+		} else if (existing_owner != owner_objectid &&
+			   existing_owner != BTRFS_MULTIPLE_OBJECTIDS) {
+			btrfs_set_ref_objectid(leaf, ref,
+					BTRFS_MULTIPLE_OBJECTIDS);
+			btrfs_set_ref_offset(leaf, ref, 0);
+		}
+		ret = 0;
+	} else {
+		goto out;
 	}
-	if (ret)
-		goto out;
-	disk_ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				  struct btrfs_extent_ref);
-	write_extent_buffer(path->nodes[0], &ref, (unsigned long)disk_ref,
-			    sizeof(ref));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
 	btrfs_release_path(root, path);
 	return ret;
 }
 
-int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes,
-				u64 root_objectid, u64 ref_generation,
-				u64 owner, u64 owner_offset)
+static int noinline remove_extent_backref(struct btrfs_trans_handle *trans,
+					  struct btrfs_root *root,
+					  struct btrfs_path *path)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_extent_ref *ref;
+	u32 num_refs;
+	int ret = 0;
+
+	leaf = path->nodes[0];
+	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_ref);
+	num_refs = btrfs_ref_num_refs(leaf, ref);
+	BUG_ON(num_refs == 0);
+	num_refs -= 1;
+	if (num_refs == 0) {
+		ret = btrfs_del_item(trans, root, path);
+	} else {
+		btrfs_set_ref_num_refs(leaf, ref, num_refs);
+		btrfs_mark_buffer_dirty(leaf);
+	}
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root, u64 bytenr,
+				     u64 orig_parent, u64 parent,
+				     u64 orig_root, u64 ref_root,
+				     u64 orig_generation, u64 ref_generation,
+				     u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_path *path;
+
+	if (root == root->fs_info->extent_root) {
+		struct pending_extent_op *extent_op;
+		u64 num_bytes;
+
+		BUG_ON(owner_objectid >= BTRFS_MAX_LEVEL);
+		num_bytes = btrfs_level_size(root, (int)owner_objectid);
+		if (test_range_bit(&root->fs_info->extent_ins, bytenr,
+				bytenr + num_bytes - 1, EXTENT_LOCKED, 0)) {
+			u64 priv;
+			ret = get_state_private(&root->fs_info->extent_ins,
+						bytenr, &priv);
+			BUG_ON(ret);
+			extent_op = (struct pending_extent_op *)
+							(unsigned long)priv;
+			BUG_ON(extent_op->parent != orig_parent);
+			BUG_ON(extent_op->generation != orig_generation);
+			extent_op->parent = parent;
+			extent_op->generation = ref_generation;
+		} else {
+			extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+			BUG_ON(!extent_op);
+
+			extent_op->type = PENDING_BACKREF_UPDATE;
+			extent_op->bytenr = bytenr;
+			extent_op->num_bytes = num_bytes;
+			extent_op->parent = parent;
+			extent_op->orig_parent = orig_parent;
+			extent_op->generation = ref_generation;
+			extent_op->orig_generation = orig_generation;
+			extent_op->level = (int)owner_objectid;
+
+			set_extent_bits(&root->fs_info->extent_ins,
+					bytenr, bytenr + num_bytes - 1,
+					EXTENT_LOCKED, GFP_NOFS);
+			set_state_private(&root->fs_info->extent_ins,
+					  bytenr, (unsigned long)extent_op);
+		}
+		return 0;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	ret = lookup_extent_backref(trans, extent_root, path,
+				    bytenr, orig_parent, orig_root,
+				    orig_generation, 1);
+	if (ret)
+		goto out;
+	ret = remove_extent_backref(trans, extent_root, path);
+	if (ret)
+		goto out;
+	ret = insert_extent_backref(trans, extent_root, path, bytenr,
+				    parent, ref_root, ref_generation,
+				    owner_objectid, owner_offset);
+	BUG_ON(ret);
+	finish_current_insert(trans, extent_root);
+	del_pending_extents(trans, extent_root);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 orig_parent, u64 parent,
+			    u64 ref_root, u64 ref_generation,
+			    u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
+	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return 0;
+	maybe_lock_mutex(root);
+	ret = __btrfs_update_extent_ref(trans, root, bytenr, orig_parent,
+					parent, ref_root, ref_root,
+					ref_generation, ref_generation,
+					owner_objectid, owner_offset);
+	maybe_unlock_mutex(root);
+	return ret;
+}
+
+static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root, u64 bytenr,
+				  u64 orig_parent, u64 parent,
+				  u64 orig_root, u64 ref_root,
+				  u64 orig_generation, u64 ref_generation,
+				  u64 owner_objectid, u64 owner_offset)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -616,23 +702,28 @@
 	struct btrfs_extent_item *item;
 	u32 refs;
 
-	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	path->reada = 1;
 	key.objectid = bytenr;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	key.offset = num_bytes;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = (u64)-1;
+
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
 				0, 1);
 	if (ret < 0)
 		return ret;
-	if (ret != 0) {
-		BUG();
-	}
-	BUG_ON(ret != 0);
+	BUG_ON(ret == 0 || path->slots[0] == 0);
+
+	path->slots[0]--;
 	l = path->nodes[0];
+
+	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
+	BUG_ON(key.objectid != bytenr);
+	BUG_ON(key.type != BTRFS_EXTENT_ITEM_KEY);
+
 	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(l, item);
 	btrfs_set_extent_refs(l, item, refs + 1);
@@ -640,15 +731,35 @@
 
 	btrfs_release_path(root->fs_info->extent_root, path);
 
-	ret = btrfs_insert_extent_backref(trans, root->fs_info->extent_root,
-					  path, bytenr, root_objectid,
-					  ref_generation, owner, owner_offset);
+	path->reada = 1;
+	ret = insert_extent_backref(trans, root->fs_info->extent_root,
+				    path, bytenr, parent,
+				    ref_root, ref_generation,
+				    owner_objectid, owner_offset);
 	BUG_ON(ret);
 	finish_current_insert(trans, root->fs_info->extent_root);
 	del_pending_extents(trans, root->fs_info->extent_root);
 
 	btrfs_free_path(path);
 	return 0;
+}
+
+int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 u64 bytenr, u64 num_bytes, u64 parent,
+			 u64 ref_root, u64 ref_generation,
+			 u64 owner_objectid, u64 owner_offset)
+{
+	int ret;
+	if (ref_root == BTRFS_TREE_LOG_OBJECTID &&
+	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return 0;
+	maybe_lock_mutex(root);
+	ret = __btrfs_inc_extent_ref(trans, root, bytenr, 0, parent,
+				     0, ref_root, 0, ref_generation,
+				     owner_objectid, owner_offset);
+	maybe_unlock_mutex(root);
+	return ret;
 }
 
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
@@ -659,9 +770,9 @@
 	return 0;
 }
 
-static int lookup_extent_ref(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u32 *refs)
+int lookup_extent_ref(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, u64 bytenr,
+		      u64 num_bytes, u32 *refs)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -671,6 +782,7 @@
 
 	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
+	path->reada = 1;
 	key.objectid = bytenr;
 	key.offset = num_bytes;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -680,8 +792,7 @@
 		goto out;
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk("failed to find block number %llu\n",
-			(unsigned long long)bytenr);
+		printk("failed to find block number %Lu\n", bytenr);
 		BUG();
 	}
 	l = path->nodes[0];
@@ -692,142 +803,46 @@
 	return 0;
 }
 
-u32 btrfs_count_snapshots_in_path(struct btrfs_root *root,
-				  struct btrfs_path *count_path,
-				  u64 first_extent)
-{
-	struct btrfs_root *extent_root = root->fs_info->extent_root;
-	struct btrfs_path *path;
-	u64 bytenr;
-	u64 found_objectid;
-	u64 root_objectid = root->root_key.objectid;
-	u32 total_count = 0;
-	u32 cur_count;
-	u32 refs;
-	u32 nritems;
-	int ret;
-	struct btrfs_key key;
-	struct btrfs_key found_key;
-	struct extent_buffer *l;
-	struct btrfs_extent_item *item;
-	struct btrfs_extent_ref *ref_item;
-	int level = -1;
-
-	path = btrfs_alloc_path();
-again:
-	if (level == -1)
-		bytenr = first_extent;
-	else
-		bytenr = count_path->nodes[level]->start;
-
-	cur_count = 0;
-	key.objectid = bytenr;
-	key.offset = 0;
-
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
-	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
-	BUG_ON(ret == 0);
-
-	l = path->nodes[0];
-	btrfs_item_key_to_cpu(l, &found_key, path->slots[0]);
-
-	if (found_key.objectid != bytenr ||
-	    found_key.type != BTRFS_EXTENT_ITEM_KEY) {
-		goto out;
-	}
-
-	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
-	refs = btrfs_extent_refs(l, item);
-	while (1) {
-		nritems = btrfs_header_nritems(l);
-		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(extent_root, path);
-			if (ret == 0)
-				continue;
-			break;
-		}
-		btrfs_item_key_to_cpu(l, &found_key, path->slots[0]);
-		if (found_key.objectid != bytenr)
-			break;
-		if (found_key.type != BTRFS_EXTENT_REF_KEY) {
-			path->slots[0]++;
-			continue;
-		}
-
-		cur_count++;
-		ref_item = btrfs_item_ptr(l, path->slots[0],
-					  struct btrfs_extent_ref);
-		found_objectid = btrfs_ref_root(l, ref_item);
-
-		if (found_objectid != root_objectid) {
-			total_count = 2;
-			goto out;
-		}
-		total_count = 1;
-		path->slots[0]++;
-	}
-	if (cur_count == 0) {
-		total_count = 0;
-		goto out;
-	}
-	if (level >= 0 && root->node == count_path->nodes[level])
-		goto out;
-	level++;
-	btrfs_release_path(root, path);
-	goto again;
-
-out:
-	btrfs_free_path(path);
-	return total_count;
-}
-int btrfs_inc_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, u64 owner_objectid)
-{
-	u64 generation;
-	u64 key_objectid;
-	u64 level;
-	u32 nritems;
-	struct btrfs_disk_key disk_key;
-
-	level = btrfs_header_level(root->node);
-	generation = trans->transid;
-	nritems = btrfs_header_nritems(root->node);
-	if (nritems > 0) {
-		if (level == 0)
-			btrfs_item_key(root->node, &disk_key, 0);
-		else
-			btrfs_node_key(root->node, &disk_key, 0);
-		key_objectid = btrfs_disk_key_objectid(&disk_key);
-	} else {
-		key_objectid = 0;
-	}
-	return btrfs_inc_extent_ref(trans, root, root->node->start,
-				    root->node->len, owner_objectid,
-				    generation, level, key_objectid);
-}
-
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf)
+		  struct extent_buffer *orig_buf, struct extent_buffer *buf,
+		  u32 *nr_extents)
 {
 	u64 bytenr;
+	u64 ref_root;
+	u64 orig_root;
+	u64 ref_generation;
+	u64 orig_generation;
 	u32 nritems;
+	u32 nr_file_extents = 0;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	int i;
 	int level;
-	int ret;
-	int faili;
+	int ret = 0;
+	int faili = 0;
+	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
+			    u64, u64, u64, u64, u64, u64, u64, u64, u64);
 
-	if (!root->ref_cows)
-		return 0;
+	ref_root = btrfs_header_owner(buf);
+	ref_generation = btrfs_header_generation(buf);
+	orig_root = btrfs_header_owner(orig_buf);
+	orig_generation = btrfs_header_generation(orig_buf);
 
+	nritems = btrfs_header_nritems(buf);
 	level = btrfs_header_level(buf);
-	nritems = btrfs_header_nritems(buf);
+
+	if (root->ref_cows) {
+		process_func = __btrfs_inc_extent_ref;
+	} else {
+		if (level == 0 &&
+		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+			goto out;
+		process_func = __btrfs_update_extent_ref;
+	}
+
 	for (i = 0; i < nritems; i++) {
+		cond_resched();
 		if (level == 0) {
-			u64 disk_bytenr;
 			btrfs_item_key_to_cpu(buf, &key, i);
 			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
 				continue;
@@ -836,30 +851,47 @@
 			if (btrfs_file_extent_type(buf, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE)
 				continue;
-			disk_bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			if (disk_bytenr == 0)
+			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			if (bytenr == 0)
 				continue;
-			ret = btrfs_inc_extent_ref(trans, root, disk_bytenr,
-				    btrfs_file_extent_disk_num_bytes(buf, fi),
-				    root->root_key.objectid, trans->transid,
-				    key.objectid, key.offset);
+
+			nr_file_extents++;
+
+			maybe_lock_mutex(root);
+			ret = process_func(trans, root, bytenr,
+					   orig_buf->start, buf->start,
+					   orig_root, ref_root,
+					   orig_generation, ref_generation,
+					   key.objectid, key.offset);
+			maybe_unlock_mutex(root);
+
 			if (ret) {
 				faili = i;
+				WARN_ON(1);
 				goto fail;
 			}
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			btrfs_node_key_to_cpu(buf, &key, i);
-			ret = btrfs_inc_extent_ref(trans, root, bytenr,
-					   btrfs_level_size(root, level - 1),
-					   root->root_key.objectid,
-					   trans->transid,
-					   level - 1, key.objectid);
+			maybe_lock_mutex(root);
+			ret = process_func(trans, root, bytenr,
+					   orig_buf->start, buf->start,
+					   orig_root, ref_root,
+					   orig_generation, ref_generation,
+					   level - 1, 0);
+			maybe_unlock_mutex(root);
 			if (ret) {
 				faili = i;
+				WARN_ON(1);
 				goto fail;
 			}
 		}
+	}
+out:
+	if (nr_extents) {
+		if (level == 0)
+			*nr_extents = nr_file_extents;
+		else
+			*nr_extents = nritems;
 	}
 	return 0;
 fail:
@@ -892,6 +924,81 @@
 	}
 #endif
 	return ret;
+}
+
+int btrfs_update_ref(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root, struct extent_buffer *orig_buf,
+		     struct extent_buffer *buf, int start_slot, int nr)
+
+{
+	u64 bytenr;
+	u64 ref_root;
+	u64 orig_root;
+	u64 ref_generation;
+	u64 orig_generation;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	int i;
+	int ret;
+	int slot;
+	int level;
+
+	BUG_ON(start_slot < 0);
+	BUG_ON(start_slot + nr > btrfs_header_nritems(buf));
+
+	ref_root = btrfs_header_owner(buf);
+	ref_generation = btrfs_header_generation(buf);
+	orig_root = btrfs_header_owner(orig_buf);
+	orig_generation = btrfs_header_generation(orig_buf);
+	level = btrfs_header_level(buf);
+
+	if (!root->ref_cows) {
+		if (level == 0 &&
+		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+			return 0;
+	}
+
+	for (i = 0, slot = start_slot; i < nr; i++, slot++) {
+		cond_resched();
+		if (level == 0) {
+			btrfs_item_key_to_cpu(buf, &key, slot);
+			if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
+				continue;
+			fi = btrfs_item_ptr(buf, slot,
+					    struct btrfs_file_extent_item);
+			if (btrfs_file_extent_type(buf, fi) ==
+			    BTRFS_FILE_EXTENT_INLINE)
+				continue;
+			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			if (bytenr == 0)
+				continue;
+
+			maybe_lock_mutex(root);
+			ret = __btrfs_update_extent_ref(trans, root, bytenr,
+					    orig_buf->start, buf->start,
+					    orig_root, ref_root,
+					    orig_generation, ref_generation,
+					    key.objectid, key.offset);
+			maybe_unlock_mutex(root);
+			if (ret)
+				goto fail;
+		} else {
+			bytenr = btrfs_node_blockptr(buf, slot);
+			maybe_lock_mutex(root);
+			ret = __btrfs_update_extent_ref(trans, root, bytenr,
+					    orig_buf->start, buf->start,
+					    orig_root, ref_root,
+					    orig_generation, ref_generation,
+					    level - 1, 0);
+			maybe_unlock_mutex(root);
+			if (ret)
+				goto fail;
+		}
+	}
+	return 0;
+fail:
+	WARN_ON(1);
+	return -1;
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -1199,18 +1306,17 @@
 {
 	u64 start;
 	u64 end;
+	u64 priv;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct extent_buffer *eb;
 	struct btrfs_path *path;
-	struct btrfs_key ins;
-	struct btrfs_disk_key first;
+	struct btrfs_extent_ref *ref;
+	struct pending_extent_op *extent_op;
+	struct btrfs_key key;
 	struct btrfs_extent_item extent_item;
 	int ret;
-	int level;
 	int err = 0;
 
 	btrfs_set_stack_extent_refs(&extent_item, 1);
-	btrfs_set_key_type(&ins, BTRFS_EXTENT_ITEM_KEY);
 	path = btrfs_alloc_path();
 
 	while(1) {
@@ -1219,58 +1325,93 @@
 		if (ret)
 			break;
 
-		ins.objectid = start;
-		ins.offset = end + 1 - start;
-		err = btrfs_insert_item(trans, extent_root, &ins,
+		ret = get_state_private(&info->extent_ins, start, &priv);
+		BUG_ON(ret);
+		extent_op = (struct pending_extent_op *)(unsigned long)priv;
+
+		if (extent_op->type == PENDING_EXTENT_INSERT) {
+			key.objectid = start;
+			key.offset = end + 1 - start;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			err = btrfs_insert_item(trans, extent_root, &key,
 					&extent_item, sizeof(extent_item));
-		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED,
-				  GFP_NOFS);
-		eb = read_tree_block(extent_root, ins.objectid, ins.offset,
-				     trans->transid);
-		level = btrfs_header_level(eb);
-		if (level == 0) {
-			btrfs_item_key(eb, &first, 0);
+			BUG_ON(err);
+
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			err = insert_extent_backref(trans, extent_root, path,
+						start, extent_op->parent,
+						extent_root->root_key.objectid,
+						extent_op->generation,
+						extent_op->level, 0);
+			BUG_ON(err);
+		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
+			err = lookup_extent_backref(trans, extent_root, path,
+						start, extent_op->orig_parent,
+						extent_root->root_key.objectid,
+						extent_op->orig_generation, 0);
+			BUG_ON(err);
+
+			clear_extent_bits(&info->extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			key.objectid = start;
+			key.offset = extent_op->parent;
+			key.type = BTRFS_EXTENT_REF_KEY;
+			err = btrfs_set_item_key_safe(trans, extent_root, path,
+						      &key);
+			BUG_ON(err);
+			ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					     struct btrfs_extent_ref);
+			btrfs_set_ref_generation(path->nodes[0], ref,
+						 extent_op->generation);
+			btrfs_mark_buffer_dirty(path->nodes[0]);
+			btrfs_release_path(extent_root, path);
 		} else {
-			btrfs_node_key(eb, &first, 0);
+			BUG_ON(1);
 		}
-		err = btrfs_insert_extent_backref(trans, extent_root, path,
-					  start, extent_root->root_key.objectid,
-					  0, level,
-					  btrfs_disk_key_objectid(&first));
-		BUG_ON(err);
-		free_extent_buffer(eb);
+		kfree(extent_op);
 	}
 	btrfs_free_path(path);
 	return 0;
 }
 
-static int pin_down_bytes(struct btrfs_root *root, u64 bytenr, u32 num_bytes,
-			  int pending)
+static int pin_down_bytes(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  u64 bytenr, u64 num_bytes, int is_data)
 {
 	int err = 0;
 	struct extent_buffer *buf;
 
-	if (!pending) {
-		buf = btrfs_find_tree_block(root, bytenr, num_bytes);
-		if (buf) {
-			if (btrfs_buffer_uptodate(buf, 0)) {
-				u64 transid =
-				    root->fs_info->running_transaction->transid;
-				if (btrfs_header_generation(buf) ==
-				    transid && !btrfs_header_flag(buf,
-					       BTRFS_HEADER_FLAG_WRITTEN)) {
-					free_extent_buffer(buf);
-					return 1;
-				}
-			}
+	if (is_data)
+		goto pinit;
+
+	buf = btrfs_find_tree_block(root, bytenr, num_bytes);
+	if (!buf)
+		goto pinit;
+
+	/* we can reuse a block if it hasn't been written
+	 * and it is from this transaction.  We can't
+	 * reuse anything from the tree log root because
+	 * it has tiny sub-transactions.
+	 */
+	if (btrfs_buffer_uptodate(buf, 0)) {
+		u64 header_owner = btrfs_header_owner(buf);
+		u64 header_transid = btrfs_header_generation(buf);
+		if (header_owner != BTRFS_TREE_LOG_OBJECTID &&
+		    header_owner != BTRFS_TREE_RELOC_OBJECTID &&
+		    header_transid == trans->transid &&
+		    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
+			clean_tree_block(NULL, root, buf);
 			free_extent_buffer(buf);
+			return 1;
 		}
-		update_pinned_extents(root, bytenr, num_bytes, 1);
-	} else {
-		set_extent_bits(&root->fs_info->pending_del,
-				bytenr, bytenr + num_bytes - 1,
-				EXTENT_LOCKED, GFP_NOFS);
 	}
+	free_extent_buffer(buf);
+pinit:
+	update_pinned_extents(root, bytenr, num_bytes, 1);
+
 	BUG_ON(err < 0);
 	return 0;
 }
@@ -1279,7 +1420,7 @@
  * remove an extent from the root, returns 0 on success
  */
 static int __free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-			 *root, u64 bytenr, u64 num_bytes,
+			 *root, u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 ref_generation,
 			 u64 owner_objectid, u64 owner_offset, int pin,
 			 int mark_free)
@@ -1305,10 +1446,8 @@
 	if (!path)
 		return -ENOMEM;
 
-	ret = lookup_extent_backref(trans, extent_root, path,
-				    bytenr, root_objectid,
-				    ref_generation,
-				    owner_objectid, owner_offset, 1);
+	ret = lookup_extent_backref(trans, extent_root, path, bytenr, parent,
+				    root_objectid, ref_generation, 1);
 	if (ret == 0) {
 		struct btrfs_key found_key;
 		extent_slot = path->slots[0];
@@ -1326,11 +1465,17 @@
 			if (path->slots[0] - extent_slot > 5)
 				break;
 		}
-		if (!found_extent)
-			ret = btrfs_del_item(trans, extent_root, path);
+		if (!found_extent) {
+			ret = remove_extent_backref(trans, extent_root, path);
+			BUG_ON(ret);
+			btrfs_release_path(extent_root, path);
+			ret = btrfs_search_slot(trans, extent_root,
+						&key, path, -1, 1);
+			BUG_ON(ret);
+			extent_slot = path->slots[0];
+		}
 	} else {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
-		WARN_ON(1);
 		printk("Unable to find ref byte nr %llu root %llu "
 		       " gen %llu owner %llu offset %llu\n",
 		       (unsigned long long)bytenr,
@@ -1338,14 +1483,7 @@
 		       (unsigned long long)ref_generation,
 		       (unsigned long long)owner_objectid,
 		       (unsigned long long)owner_offset);
-	}
-	if (!found_extent) {
-		btrfs_release_path(extent_root, path);
-		ret = btrfs_search_slot(trans, extent_root, &key, path, -1, 1);
-		if (ret < 0)
-			return ret;
-		BUG_ON(ret);
-		extent_slot = path->slots[0];
+		BUG_ON(1);
 	}
 
 	leaf = path->nodes[0];
@@ -1359,6 +1497,10 @@
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (refs == 0 && found_extent && path->slots[0] == extent_slot + 1) {
+		struct btrfs_extent_ref *ref;
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_extent_ref);
+		BUG_ON(btrfs_ref_num_refs(leaf, ref) != 1);
 		/* if the back ref and the extent are next to each other
 		 * they get deleted below in one shot
 		 */
@@ -1366,7 +1508,7 @@
 		num_to_del = 2;
 	} else if (found_extent) {
 		/* otherwise delete the extent back ref */
-		ret = btrfs_del_item(trans, extent_root, path);
+		ret = remove_extent_backref(trans, extent_root, path);
 		BUG_ON(ret);
 		/* if refs are 0, we need to setup the path for deletion */
 		if (refs == 0) {
@@ -1384,7 +1526,7 @@
 		u64 root_used;
 
 		if (pin) {
-			ret = pin_down_bytes(root, bytenr, num_bytes, 0);
+			ret = pin_down_bytes(trans, root, bytenr, num_bytes, 0);
 			if (ret > 0)
 				mark_free = 1;
 			BUG_ON(ret < 0);
@@ -1425,26 +1567,61 @@
 {
 	int ret;
 	int err = 0;
+	int mark_free = 0;
 	u64 start;
 	u64 end;
+	u64 priv;
 	struct extent_io_tree *pending_del;
-	struct extent_io_tree *pinned_extents;
+	struct extent_io_tree *extent_ins;
+	struct pending_extent_op *extent_op;
 
+	extent_ins = &extent_root->fs_info->extent_ins;
 	pending_del = &extent_root->fs_info->pending_del;
-	pinned_extents = &extent_root->fs_info->pinned_extents;
 
 	while(1) {
 		ret = find_first_extent_bit(pending_del, 0, &start, &end,
 					    EXTENT_LOCKED);
 		if (ret)
 			break;
-		update_pinned_extents(extent_root, start, end + 1 - start, 1);
+
+		ret = get_state_private(pending_del, start, &priv);
+		BUG_ON(ret);
+		extent_op = (struct pending_extent_op *)(unsigned long)priv;
+
 		clear_extent_bits(pending_del, start, end, EXTENT_LOCKED,
 				  GFP_NOFS);
-		ret = __free_extent(trans, extent_root,
-				     start, end + 1 - start,
-				     extent_root->root_key.objectid,
-				     0, 0, 0, 0, 0);
+
+		ret = pin_down_bytes(trans, extent_root, start,
+				     end + 1 - start, 0);
+		mark_free = ret > 0;
+		if (!test_range_bit(extent_ins, start, end,
+				    EXTENT_LOCKED, 0)) {
+free_extent:
+			ret = __free_extent(trans, extent_root,
+					    start, end + 1 - start,
+					    extent_op->orig_parent,
+					    extent_root->root_key.objectid,
+					    extent_op->orig_generation,
+					    extent_op->level, 0, 0, mark_free);
+			kfree(extent_op);
+		} else {
+			kfree(extent_op);
+			ret = get_state_private(extent_ins, start, &priv);
+			BUG_ON(ret);
+			extent_op = (struct pending_extent_op *)
+							(unsigned long)priv;
+
+			clear_extent_bits(extent_ins, start, end,
+					  EXTENT_LOCKED, GFP_NOFS);
+
+			if (extent_op->type == PENDING_BACKREF_UPDATE)
+				goto free_extent;
+
+			ret = update_block_group(trans, extent_root, start,
+						end + 1 - start, 0, mark_free);
+			BUG_ON(ret);
+			kfree(extent_op);
+		}
 		if (ret)
 			err = ret;
 	}
@@ -1455,7 +1632,7 @@
  * remove an extent from the root, returns 0 on success
  */
 int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, u64 bytenr, u64 num_bytes,
+		      *root, u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 ref_generation,
 		      u64 owner_objectid, u64 owner_offset, int pin)
 {
@@ -1464,16 +1641,31 @@
 	int ret;
 
 	WARN_ON(num_bytes < root->sectorsize);
-	if (!root->ref_cows)
-		ref_generation = 0;
+	if (root == extent_root) {
+		struct pending_extent_op *extent_op;
 
-	if (root == extent_root) {
-		pin_down_bytes(root, bytenr, num_bytes, 1);
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+
+		extent_op->type = PENDING_EXTENT_DELETE;
+		extent_op->bytenr = bytenr;
+		extent_op->num_bytes = num_bytes;
+		extent_op->parent = parent;
+		extent_op->orig_parent = parent;
+		extent_op->generation = ref_generation;
+		extent_op->orig_generation = ref_generation;
+		extent_op->level = (int)owner_objectid;
+
+		set_extent_bits(&root->fs_info->pending_del,
+				bytenr, bytenr + num_bytes - 1,
+				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&root->fs_info->pending_del,
+				  bytenr, (unsigned long)extent_op);
 		return 0;
 	}
-	ret = __free_extent(trans, root, bytenr, num_bytes, root_objectid,
-			    ref_generation, owner_objectid, owner_offset,
-			    pin, pin == 0);
+	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
+			    root_objectid, ref_generation,
+			    owner_objectid, owner_offset, pin, pin == 0);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root);
 	return ret ? ret : pending_ret;
 }
@@ -1615,7 +1807,8 @@
  */
 int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
-		       u64 num_bytes, u64 root_objectid, u64 ref_generation,
+		       u64 num_bytes, u64 parent,
+		       u64 root_objectid, u64 ref_generation,
 		       u64 owner, u64 owner_offset,
 		       u64 empty_size, u64 hint_byte,
 		       u64 search_end, struct btrfs_key *ins, int data)
@@ -1677,6 +1870,9 @@
 	if (ret)
 		return ret;
 
+	if (parent == 0)
+		parent = ins->objectid;
+
 	/* block accounting for super block */
 	super_used = btrfs_super_bytes_used(&info->super_copy);
 	btrfs_set_super_bytes_used(&info->super_copy, super_used + num_bytes);
@@ -1690,9 +1886,25 @@
 			   GFP_NOFS);
 
 	if (root == extent_root) {
+		struct pending_extent_op *extent_op;
+
+		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
+		BUG_ON(!extent_op);
+
+		extent_op->type = PENDING_EXTENT_INSERT;
+		extent_op->bytenr = ins->objectid;
+		extent_op->num_bytes = ins->offset;
+		extent_op->parent = parent;
+		extent_op->orig_parent = 0;
+		extent_op->generation = ref_generation;
+		extent_op->orig_generation = 0;
+		extent_op->level = (int)owner;
+
 		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
 				ins->objectid + ins->offset - 1,
 				EXTENT_LOCKED, GFP_NOFS);
+		set_state_private(&root->fs_info->extent_ins,
+				  ins->objectid, (unsigned long)extent_op);
 		goto update_block;
 	}
 
@@ -1701,10 +1913,9 @@
 	trans->alloc_exclude_nr = ins->offset;
 
 	memcpy(&keys[0], ins, sizeof(*ins));
-	keys[1].offset = hash_extent_ref(root_objectid, ref_generation,
-					 owner, owner_offset);
 	keys[1].objectid = ins->objectid;
 	keys[1].type = BTRFS_EXTENT_REF_KEY;
+	keys[1].offset = parent;
 	sizes[0] = sizeof(*extent_item);
 	sizes[1] = sizeof(*ref);
 
@@ -1725,6 +1936,7 @@
 	btrfs_set_ref_generation(path->nodes[0], ref, ref_generation);
 	btrfs_set_ref_objectid(path->nodes[0], ref, owner);
 	btrfs_set_ref_offset(path->nodes[0], ref, owner_offset);
+	btrfs_set_ref_num_refs(path->nodes[0], ref, 1);
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 
@@ -1758,32 +1970,9 @@
  */
 struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
-					     u32 blocksize,
-					     u64 root_objectid, u64 hint,
-					     u64 empty_size)
-{
-	u64 ref_generation;
-
-	if (root->ref_cows)
-		ref_generation = trans->transid;
-	else
-		ref_generation = 0;
-
-
-	return __btrfs_alloc_free_block(trans, root, blocksize, root_objectid,
-					ref_generation, 0, 0, hint, empty_size);
-}
-
-/*
- * helper function to allocate a block for a given tree
- * returns the tree buffer or NULL.
- */
-struct extent_buffer *__btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					     struct btrfs_root *root,
-					     u32 blocksize,
+					     u32 blocksize, u64 parent,
 					     u64 root_objectid,
 					     u64 ref_generation,
-					     u64 first_objectid,
 					     int level,
 					     u64 hint,
 					     u64 empty_size)
@@ -1792,9 +1981,9 @@
 	int ret;
 	struct extent_buffer *buf;
 
-	ret = btrfs_alloc_extent(trans, root, blocksize,
+	ret = btrfs_alloc_extent(trans, root, blocksize, parent,
 				 root_objectid, ref_generation,
-				 level, first_objectid, empty_size, hint,
+				 level, 0, empty_size, hint,
 				 (u64)-1, &ins, 0);
 	if (ret) {
 		BUG_ON(ret > 0);
@@ -1802,9 +1991,11 @@
 	}
 	buf = btrfs_find_create_tree_block(root, ins.objectid, blocksize);
 	if (!buf) {
+		if (parent == 0)
+			parent = ins.objectid;
 		btrfs_free_extent(trans, root, ins.objectid, blocksize,
-				  root->root_key.objectid, ref_generation,
-				  0, 0, 0);
+				  parent, root->root_key.objectid,
+				  ref_generation, 0, 0, 0);
 		BUG_ON(1);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1849,7 +2040,7 @@
 			continue;
 		ret = btrfs_free_extent(trans, root, disk_bytenr,
 				btrfs_file_extent_disk_num_bytes(leaf, fi),
-				leaf_owner, leaf_generation,
+				leaf->start, leaf_owner, leaf_generation,
 				key.objectid, key.offset, 0);
 		BUG_ON(ret);
 	}
@@ -1960,8 +2151,8 @@
 			root_owner = btrfs_header_owner(parent);
 			root_gen = btrfs_header_generation(parent);
 			path->slots[*level]++;
-			ret = btrfs_free_extent(trans, root, bytenr,
-						blocksize, root_owner,
+			ret = btrfs_free_extent(trans, root, bytenr, blocksize,
+						parent->start, root_owner,
 						root_gen, 0, 0, 1);
 			BUG_ON(ret);
 			continue;
@@ -1987,9 +2178,8 @@
 				path->slots[*level]++;
 				free_extent_buffer(next);
 				ret = btrfs_free_extent(trans, root, bytenr,
-							blocksize,
-							root_owner,
-							root_gen, 0, 0, 1);
+						blocksize, parent->start,
+						root_owner, root_gen, 0, 0, 1);
 				BUG_ON(ret);
 				continue;
 			}
@@ -2015,7 +2205,7 @@
 
 	root_gen = btrfs_header_generation(parent);
 	ret = btrfs_free_extent(trans, root, path->nodes[*level]->start,
-				path->nodes[*level]->len,
+				path->nodes[*level]->len, parent->start,
 				root_owner, root_gen, 0, 0, 1);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
@@ -2055,20 +2245,19 @@
 			root_item->drop_level = i;
 			return 0;
 		} else {
-			if (path->nodes[*level] == root->node) {
-				root_owner = root->root_key.objectid;
-				root_gen =
-				   btrfs_header_generation(path->nodes[*level]);
-			} else {
-				struct extent_buffer *node;
-				node = path->nodes[*level + 1];
-				root_owner = btrfs_header_owner(node);
-				root_gen = btrfs_header_generation(node);
-			}
+			struct extent_buffer *parent;
+			if (path->nodes[*level] == root->node)
+				parent = path->nodes[*level];
+			else
+				parent = path->nodes[*level + 1];
+
+			root_owner = btrfs_header_owner(parent);
+			root_gen = btrfs_header_generation(parent);
 			ret = btrfs_free_extent(trans, root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
-						root_owner, root_gen, 0, 0, 1);
+						parent->start, root_owner,
+						root_gen, 0, 0, 1);
 			BUG_ON(ret);
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
@@ -2443,13 +2632,6 @@
 	return 0;
 }
 
-u64 btrfs_hash_extent_ref(u64 root_objectid, u64 ref_generation,
-			  u64 owner, u64 owner_offset)
-{
-	return hash_extent_ref(root_objectid, ref_generation,
-			       owner, owner_offset);
-}
-
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 bytenr, u64 num_bytes, int alloc,
diff -r 0efd1a540ea6 mkfs.c
--- a/mkfs.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/mkfs.c	Tue Sep 23 22:29:02 2008 +0800
@@ -69,8 +69,8 @@
 	return atol(s) * mult;
 }
 
-static int make_root_dir(int fd, const char *device_name) {
-	struct btrfs_root *root;
+static int make_root_dir(struct btrfs_root *root)
+{
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key location;
 	u64 bytes_used;
@@ -78,12 +78,6 @@
 	u64 chunk_size = 0;
 	int ret;
 
-	root = open_ctree_fd(fd, device_name, 0, O_RDWR);
-
-	if (!root) {
-		fprintf(stderr, "ctree init failed\n");
-		return -1;
-	}
 	trans = btrfs_start_transaction(root, 1);
 	bytes_used = btrfs_super_bytes_used(&root->fs_info->super_copy);
 
@@ -119,7 +113,6 @@
 				     chunk_start, chunk_size);
 	BUG_ON(ret);
 
-	// ret = btrfs_make_block_group(trans, root, 0, 1);
 	ret = btrfs_make_root_dir(trans, root->fs_info->tree_root,
 			      BTRFS_ROOT_TREE_DIR_OBJECTID);
 	if (ret)
@@ -143,7 +136,6 @@
 		goto err;
 
 	btrfs_commit_transaction(trans, root);
-	ret = close_ctree(root);
 err:
 	return ret;
 }
@@ -405,13 +397,15 @@
 		fprintf(stderr, "error during mkfs %d\n", ret);
 		exit(1);
 	}
-	ret = make_root_dir(fd, file);
+	root = open_ctree(file, 0, O_RDWR);
+	root->fs_info->alloc_start = alloc_start;
+
+	ret = make_root_dir(root);
 	if (ret) {
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
 	}
-	root = open_ctree(file, 0, O_RDWR);
-	root->fs_info->alloc_start = alloc_start;
+
 	trans = btrfs_start_transaction(root, 1);
 
 	if (ac == 0)
@@ -463,6 +457,7 @@
 raid_groups:
 	ret = create_raid_groups(trans, root, data_profile,
 				 metadata_profile);
+	BUG_ON(ret);
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
diff -r 0efd1a540ea6 print-tree.c
--- a/print-tree.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/print-tree.c	Tue Sep 23 22:29:02 2008 +0800
@@ -213,11 +213,12 @@
 		case BTRFS_EXTENT_REF_KEY:
 			ref = btrfs_item_ptr(l, i, struct btrfs_extent_ref);
 			printf("\t\textent back ref root %llu gen %llu "
-			       "owner %llu offset %llu\n",
+			       "owner %llu offset %llu, num_refs %lu\n",
 			       (unsigned long long)btrfs_ref_root(l, ref),
 			       (unsigned long long)btrfs_ref_generation(l, ref),
 			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long long)btrfs_ref_offset(l, ref));
+			       (unsigned long long)btrfs_ref_offset(l, ref),
+			       (unsigned long)btrfs_ref_num_refs(l, ref));
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
 			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
diff -r 0efd1a540ea6 utils.c
--- a/utils.c	Fri Sep 05 16:15:58 2008 -0400
+++ b/utils.c	Tue Sep 23 22:29:02 2008 +0800
@@ -74,9 +74,7 @@
 	int ret;
 	u32 itemoff;
 	u32 nritems = 0;
-	u64 hash;
 	u64 first_free;
-	u64 ref_gen;
 	u64 ref_root;
 	u32 array_size;
 	u32 item_size;
@@ -213,15 +211,9 @@
 
 		/* create extent ref */
 		ref_root = reference_root_table[i];
-		if (ref_root == BTRFS_FS_TREE_OBJECTID)
-			ref_gen = 1;
-		else
-			ref_gen = 0;
-
-		hash = btrfs_hash_extent_ref(ref_root, ref_gen, 0, 0);
 		itemoff = itemoff - sizeof(struct btrfs_extent_ref);
 		btrfs_set_disk_key_objectid(&disk_key, blocks[i]);
-		btrfs_set_disk_key_offset(&disk_key, hash);
+		btrfs_set_disk_key_offset(&disk_key, blocks[i]);
 		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
@@ -231,9 +223,10 @@
 		extent_ref = btrfs_item_ptr(buf, nritems,
 					     struct btrfs_extent_ref);
 		btrfs_set_ref_root(buf, extent_ref, ref_root);
-		btrfs_set_ref_generation(buf, extent_ref, ref_gen);
+		btrfs_set_ref_generation(buf, extent_ref, 1);
 		btrfs_set_ref_objectid(buf, extent_ref, 0);
 		btrfs_set_ref_offset(buf, extent_ref, 0);
+		btrfs_set_ref_num_refs(buf, extent_ref, 1);
 		nritems++;
 	}
 	btrfs_set_header_bytenr(buf, blocks[2]);
