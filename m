From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfsck: check root back/forward references
Date: Tue, 25 Aug 2009 22:39:24 +0800
Message-ID: <4A93F79C.7030801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch contains two things.

add semantic checks for links to snapshot/subvol and root
back/forward references.

make btrfs be able to find unreferenced fs trees and add
orphan items for them.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2009-06-12 21:33:43.467764155 +0800
+++ btrfs-progs/btrfsck.c	2009-08-21 14:35:46.240699301 +0800
@@ -21,11 +21,13 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
+#include <unistd.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
+#include "utils.h"
 #include "list.h"
 #include "version.h"
 
@@ -36,7 +38,8 @@ static u64 total_fs_tree_bytes = 0;
 static u64 btree_space_waste = 0;
 static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
-int found_old_backref = 0;
+static int found_old_backref = 0;
+static int found_orphan_root = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -100,7 +103,11 @@ struct inode_backref {
 #define REF_ERR_DUP_INODE_REF		(1 << 5)
 #define REF_ERR_INDEX_UNMATCH		(1 << 6)
 #define REF_ERR_FILETYPE_UNMATCH	(1 << 7)
-#define REF_ERR_NAME_TOO_LONG		(1 << 8)
+#define REF_ERR_NAME_TOO_LONG		(1 << 8) // 100
+#define REF_ERR_NO_ROOT_REF		(1 << 9)
+#define REF_ERR_NO_ROOT_BACKREF		(1 << 10)
+#define REF_ERR_DUP_ROOT_REF		(1 << 11)
+#define REF_ERR_DUP_ROOT_BACKREF	(1 << 12)
 
 struct inode_record {
 	struct list_head backrefs;
@@ -144,6 +151,29 @@ struct inode_record {
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
 #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
 
+struct root_backref {
+	struct list_head list;
+	unsigned int found_dir_item:1;
+	unsigned int found_dir_index:1;
+	unsigned int found_back_ref:1;
+	unsigned int found_forward_ref:1;
+	unsigned int reachable:1;
+	int errors;
+	u64 ref_root;
+	u64 dir;
+	u64 index;
+	u16 namelen;
+	char name[0];
+};
+
+struct root_record {
+	struct list_head backrefs;
+	struct cache_extent cache;
+	unsigned int found_root_item:1;
+	u64 objectid;
+	u32 found_ref;
+};
+
 struct ptr_node {
 	struct cache_extent cache;
 	void *data;
@@ -151,6 +181,7 @@ struct ptr_node {
 
 struct shared_node {
 	struct cache_extent cache;
+	struct cache_tree root_cache;
 	struct cache_tree inode_cache;
 	struct inode_record *current;
 	u32 refs;
@@ -258,6 +289,14 @@ static void free_inode_rec(struct inode_
 	free(rec);
 }
 
+static int can_free_inode_rec(struct inode_record *rec)
+{
+	if (!rec->errors && rec->checked && rec->found_inode_item &&
+	    rec->nlink == rec->found_link && list_empty(&rec->backrefs))
+		return 1;
+	return 0;
+}
+
 static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 				 struct inode_record *rec)
 {
@@ -309,8 +348,7 @@ static void maybe_free_inode_rec(struct 
 	}
 
 	BUG_ON(rec->refs != 1);
-	if (!rec->errors && rec->nlink == rec->found_link &&
-	    list_empty(&rec->backrefs)) {
+	if (can_free_inode_rec(rec)) {
 		cache = find_cache_extent(inode_cache, rec->ino, 1);
 		node = container_of(cache, struct ptr_node, cache);
 		BUG_ON(node->data != rec);
@@ -338,14 +376,30 @@ static int check_orphan_item(struct btrf
 	return ret;
 }
 
-static int process_inode_item(struct btrfs_root *root,
-			      struct extent_buffer *eb,
+static int mark_orphan_object(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, u64 objectid)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = objectid;
+
+	btrfs_init_path(&path);
+	ret = btrfs_insert_empty_item(trans, root, &path, &key, 0);
+
+	btrfs_release_path(root, &path);
+	return ret;
+}
+
+static int process_inode_item(struct extent_buffer *eb,
 			      int slot, struct btrfs_key *key,
 			      struct shared_node *active_node)
 {
 	struct inode_record *rec;
 	struct btrfs_inode_item *item;
-	int ret;
 
 	rec = active_node->current;
 	BUG_ON(rec->ino != key->objectid || rec->refs > 1);
@@ -361,11 +415,8 @@ static int process_inode_item(struct btr
 	if (btrfs_inode_flags(eb, item) & BTRFS_INODE_NODATASUM)
 		rec->nodatasum = 1;
 	rec->found_inode_item = 1;
-	if (rec->nlink == 0) {
-		ret = check_orphan_item(root, rec->ino);
-		if (ret == -ENOENT)
-			rec->errors |= I_ERR_NO_ORPHAN_ITEM;
-	}
+	if (rec->nlink == 0)
+		rec->errors |= I_ERR_NO_ORPHAN_ITEM;
 	maybe_free_inode_rec(&active_node->inode_cache, rec);
 	return 0;
 }
@@ -443,10 +494,9 @@ static int add_inode_backref(struct cach
 }
 
 static int merge_inode_recs(struct inode_record *src, struct inode_record *dst,
-			    struct shared_node *dst_node)
+			    struct cache_tree *dst_cache)
 {
 	struct inode_backref *backref;
-	struct cache_tree *dst_cache = &dst_node->inode_cache;
 
 	dst->merging = 1;
 	list_for_each_entry(backref, &src->backrefs, list) {
@@ -510,14 +560,8 @@ static int merge_inode_recs(struct inode
 			dst->errors |= I_ERR_DUP_INODE_ITEM;
 		}
 	}
-
-	if (src->checked) {
-		dst->checked = 1;
-		if (dst_node->current == dst)
-			dst_node->current = NULL;
-	}
 	dst->merging = 0;
-	maybe_free_inode_rec(dst_cache, dst);
+
 	return 0;
 }
 
@@ -537,8 +581,9 @@ static int splice_shared_node(struct sha
 	if (src_node->current)
 		current_ino = src_node->current->ino;
 
-	src = &src_node->inode_cache;
-	dst = &dst_node->inode_cache;
+	src = &src_node->root_cache;
+	dst = &dst_node->root_cache;
+again:
 	cache = find_first_cache_extent(src, 0);
 	while (cache) {
 		node = container_of(cache, struct ptr_node, cache);
@@ -557,14 +602,28 @@ static int splice_shared_node(struct sha
 		}
 		ret = insert_existing_cache_extent(dst, &ins->cache);
 		if (ret == -EEXIST) {
+			WARN_ON(src == &src_node->root_cache);
 			conflict = get_inode_rec(dst, rec->ino, 1);
-			merge_inode_recs(rec, conflict, dst_node);
+			merge_inode_recs(rec, conflict, dst);
+			if (rec->checked) {
+				conflict->checked = 1;
+				if (dst_node->current == conflict)
+					dst_node->current = NULL;
+			}
+			maybe_free_inode_rec(dst, conflict);
 			free_inode_rec(rec);
 			free(ins);
 		} else {
 			BUG_ON(ret);
 		}
 	}
+
+	if (src == &src_node->root_cache) {
+		src = &src_node->inode_cache;
+		dst = &dst_node->inode_cache;
+		goto again;
+	}
+
 	if (current_ino > 0 && (!dst_node->current ||
 	    current_ino > dst_node->current->ino)) {
 		if (dst_node->current) {
@@ -616,6 +675,7 @@ static int add_shared_node(struct cache_
 	node = calloc(1, sizeof(*node));
 	node->cache.start = bytenr;
 	node->cache.size = 1;
+	cache_tree_init(&node->root_cache);
 	cache_tree_init(&node->inode_cache);
 	node->refs = refs;
 
@@ -646,6 +706,7 @@ static int enter_shared_node(struct btrf
 	if (wc->root_level == wc->active_node &&
 	    btrfs_root_refs(&root->root_item) == 0) {
 		if (--node->refs == 0) {
+			free_inode_recs(&node->root_cache);
 			free_inode_recs(&node->inode_cache);
 			remove_cache_extent(&wc->shared, &node->cache);
 			free(node);
@@ -708,10 +769,12 @@ static int process_dir_item(struct exten
 	int filetype;
 	struct btrfs_dir_item *di;
 	struct inode_record *rec;
+	struct cache_tree *root_cache;
 	struct cache_tree *inode_cache;
 	struct btrfs_key location;
 	char namebuf[BTRFS_NAME_LEN];
 
+	root_cache = &active_node->root_cache;
 	inode_cache = &active_node->inode_cache;
 	rec = active_node->current;
 	rec->found_dir_item = 1;
@@ -740,7 +803,9 @@ static int process_dir_item(struct exten
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
 		} else if (location.type == BTRFS_ROOT_ITEM_KEY) {
-			/* fixme: check root back & forward references */
+			add_inode_backref(root_cache, location.objectid,
+					  key->objectid, key->offset, namebuf,
+					  len, filetype, key->type, error);
 		} else {
 			fprintf(stderr, "warning line %d\n", __LINE__);
 		}
@@ -977,8 +1042,7 @@ static int process_one_leaf(struct btrfs
 			ret = process_inode_ref(eb, i, &key, active_node);
 			break;
 		case BTRFS_INODE_ITEM_KEY:
-			ret = process_inode_item(root, eb, i, &key,
-						 active_node);
+			ret = process_inode_item(eb, i, &key, active_node);
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
 			ret = process_file_extent(root, eb, i, &key,
@@ -1176,13 +1240,23 @@ static int check_inode_recs(struct btrfs
 		node = container_of(cache, struct ptr_node, cache);
 		rec = node->data;
 		remove_cache_extent(inode_cache, &node->cache);
+		free(node);
 		if (rec->ino == root_dirid ||
 		    rec->ino == BTRFS_ORPHAN_OBJECTID) {
-			free(node);
 			free_inode_rec(rec);
 			continue;
 		}
 
+		if (rec->errors & I_ERR_NO_ORPHAN_ITEM) {
+			ret = check_orphan_item(root, rec->ino);
+			if (ret == 0)
+				rec->errors &= ~I_ERR_NO_ORPHAN_ITEM;
+			if (can_free_inode_rec(rec)) {
+				free_inode_rec(rec);
+				continue;
+			}
+		}
+
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
@@ -1205,13 +1279,397 @@ static int check_inode_recs(struct btrfs
 				backref->namelen, backref->name,
 				backref->filetype, backref->errors);
 		}
-		free(node);
 		free_inode_rec(rec);
 	}
 	return (error > 0) ? -1 : 0;
 }
 
+static struct root_record *get_root_rec(struct cache_tree *root_cache,
+					u64 objectid)
+{
+	struct cache_extent *cache;
+	struct root_record *rec = NULL;
+	int ret;
+
+	cache = find_cache_extent(root_cache, objectid, 1);
+	if (cache) {
+		rec = container_of(cache, struct root_record, cache);
+	} else {
+		rec = calloc(1, sizeof(*rec));
+		rec->objectid = objectid;
+		INIT_LIST_HEAD(&rec->backrefs);
+		rec->cache.start = objectid;
+		rec->cache.size = 1;
+
+		ret = insert_existing_cache_extent(root_cache, &rec->cache);
+		BUG_ON(ret);
+	}
+	return rec;
+}
+
+static struct root_backref *get_root_backref(struct root_record *rec,
+					     u64 ref_root, u64 dir, u64 index,
+					     const char *name, int namelen)
+{
+	struct root_backref *backref;
+
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (backref->ref_root != ref_root || backref->dir != dir ||
+		    backref->namelen != namelen)
+			continue;
+		if (memcmp(name, backref->name, namelen))
+			continue;
+		return backref;
+	}
+
+	backref = malloc(sizeof(*backref) + namelen + 1);
+	memset(backref, 0, sizeof(*backref));
+	backref->ref_root = ref_root;
+	backref->dir = dir;
+	backref->index = index;
+	backref->namelen = namelen;
+	memcpy(backref->name, name, namelen);
+	backref->name[namelen] = '\0';
+	list_add_tail(&backref->list, &rec->backrefs);
+	return backref;
+}
+
+static void free_root_recs(struct cache_tree *root_cache)
+{
+	struct cache_extent *cache;
+	struct root_record *rec;
+	struct root_backref *backref;
+
+	while (1) {
+		cache = find_first_cache_extent(root_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct root_record, cache);
+		remove_cache_extent(root_cache, &rec->cache);
+
+		while (!list_empty(&rec->backrefs)) {
+			backref = list_entry(rec->backrefs.next,
+					     struct root_backref, list);
+			list_del(&backref->list);
+			free(backref);
+		}
+		kfree(rec);
+	}
+}
+
+static int add_root_backref(struct cache_tree *root_cache,
+			    u64 root_id, u64 ref_root, u64 dir, u64 index,
+			    const char *name, int namelen,
+			    int item_type, int errors)
+{
+	struct root_record *rec;
+	struct root_backref *backref;
+
+	rec = get_root_rec(root_cache, root_id);
+	backref = get_root_backref(rec, ref_root, dir, index, name, namelen);
+
+	backref->errors |= errors;
+
+	if (item_type != BTRFS_DIR_ITEM_KEY) {
+		if (backref->found_dir_index || backref->found_back_ref ||
+		    backref->found_forward_ref) {
+			if (backref->index != index)
+				backref->errors |= REF_ERR_INDEX_UNMATCH;
+		} else {
+			backref->index = index;
+		}
+	}
+
+	if (item_type == BTRFS_DIR_ITEM_KEY) {
+		backref->found_dir_item = 1;
+		backref->reachable = 1;
+		rec->found_ref++;
+	} else if (item_type == BTRFS_DIR_INDEX_KEY) {
+		backref->found_dir_index = 1;
+	} else if (item_type == BTRFS_ROOT_REF_KEY) {
+		if (backref->found_forward_ref)
+			backref->errors |= REF_ERR_DUP_ROOT_REF;
+		backref->found_forward_ref = 1;
+	} else if (item_type == BTRFS_ROOT_BACKREF_KEY) {
+		if (backref->found_back_ref)
+			backref->errors |= REF_ERR_DUP_ROOT_BACKREF;
+		backref->found_back_ref = 1;
+	} else {
+		BUG_ON(1);
+	}
+
+	return 0;
+}
+
+static int merge_root_recs(struct btrfs_root *root,
+			   struct cache_tree *src_cache,
+			   struct cache_tree *dst_cache)
+{
+	struct cache_extent *cache;
+	struct ptr_node *node;
+	struct inode_record *rec;
+	struct inode_backref *backref;
+
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		free_inode_recs(src_cache);
+		return 0;
+	}
+
+	while (1) {
+		cache = find_first_cache_extent(src_cache, 0);
+		if (!cache)
+			break;
+		node = container_of(cache, struct ptr_node, cache);
+		rec = node->data;
+		remove_cache_extent(src_cache, &node->cache);
+		free(node);
+
+		list_for_each_entry(backref, &rec->backrefs, list) {
+			BUG_ON(backref->found_inode_ref);
+			if (backref->found_dir_item)
+				add_root_backref(dst_cache, rec->ino,
+					root->root_key.objectid, backref->dir,
+					backref->index, backref->name,
+					backref->namelen, BTRFS_DIR_ITEM_KEY,
+					backref->errors);
+			if (backref->found_dir_index)
+				add_root_backref(dst_cache, rec->ino,
+					root->root_key.objectid, backref->dir,
+					backref->index, backref->name,
+					backref->namelen, BTRFS_DIR_INDEX_KEY,
+					backref->errors);
+		}
+		free_inode_rec(rec);
+	}
+	return 0;
+}
+
+static int check_root_refs(struct btrfs_root *root,
+			   struct cache_tree *root_cache)
+{
+	struct root_record *rec;
+	struct root_record *ref_root;
+	struct root_backref *backref;
+	struct cache_extent *cache;
+	int loop = 1;
+	int ret;
+	int error;
+	int errors = 0;
+
+	rec = get_root_rec(root_cache, BTRFS_FS_TREE_OBJECTID);
+	rec->found_ref = 1;
+
+	/* fixme: this can not detect circular references */
+	while (loop) {
+		loop = 0;
+		cache = find_first_cache_extent(root_cache, 0);
+		while (1) {
+			if (!cache)
+				break;
+			rec = container_of(cache, struct root_record, cache);
+			cache = next_cache_extent(cache);
+
+			if (rec->found_ref == 0)
+				continue;
+
+			list_for_each_entry(backref, &rec->backrefs, list) {
+				if (!backref->reachable)
+					continue;
+
+				ref_root = get_root_rec(root_cache,
+							backref->ref_root);
+				if (ref_root->found_ref > 0)
+					continue;
+
+				backref->reachable = 0;
+				rec->found_ref--;
+				if (rec->found_ref == 0)
+					loop = 1;
+			}
+		}
+	}
+
+	cache = find_first_cache_extent(root_cache, 0);
+	while (1) {
+		if (!cache)
+			break;
+		rec = container_of(cache, struct root_record, cache);
+		cache = next_cache_extent(cache);
+
+		if (rec->found_ref == 0 &&
+		    rec->objectid >= BTRFS_FIRST_FREE_OBJECTID &&
+		    rec->objectid <= BTRFS_LAST_FREE_OBJECTID) {
+			ret = check_orphan_item(root->fs_info->tree_root,
+						rec->objectid);
+			if (ret == 0)
+				continue;
+			errors++;
+			found_orphan_root++;
+			fprintf(stderr, "fs tree %llu not referenced\n",
+				(unsigned long long)rec->objectid);
+		}
+
+		error = 0;
+		if (rec->found_ref > 0 && !rec->found_root_item)
+			error = 1;
+		list_for_each_entry(backref, &rec->backrefs, list) {
+			if (!backref->found_dir_item)
+				backref->errors |= REF_ERR_NO_DIR_ITEM;
+			if (!backref->found_dir_index)
+				backref->errors |= REF_ERR_NO_DIR_INDEX;
+			if (!backref->found_back_ref)
+				backref->errors |= REF_ERR_NO_ROOT_BACKREF;
+			if (!backref->found_forward_ref)
+				backref->errors |= REF_ERR_NO_ROOT_REF;
+			if (backref->reachable && backref->errors)
+				error = 1;
+		}
+		if (!error)
+			continue;
+
+		errors++;
+		fprintf(stderr, "fs tree %llu refs %u %s\n",
+			(unsigned long long)rec->objectid, rec->found_ref,
+			 rec->found_root_item ? "" : "not found");
+
+		list_for_each_entry(backref, &rec->backrefs, list) {
+			if (!backref->reachable)
+				continue;
+			if (!backref->errors && rec->found_root_item)
+				continue;
+			fprintf(stderr, "\tunresolved ref root %llu dir %llu"
+				" index %llu namelen %u name %s error %x\n",
+				(unsigned long long)backref->ref_root,
+				(unsigned long long)backref->dir,
+				(unsigned long long)backref->index,
+				backref->namelen, backref->name,
+				backref->errors);
+		}
+	}
+	return errors > 0 ? 1 : 0;
+}
+
+static int del_root_refs(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct root_record *rec)
+{
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
+	struct root_backref *backref;
+	int ret;
+
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		if (backref->found_back_ref) {
+			ret = btrfs_del_root_ref(trans, tree_root,
+						rec->objectid,
+						BTRFS_ROOT_BACKREF_KEY,
+						backref->ref_root);
+			BUG_ON(ret);
+		}
+		if (backref->found_forward_ref) {
+			ret = btrfs_del_root_ref(trans, tree_root,
+						backref->ref_root,
+						BTRFS_ROOT_REF_KEY,
+						rec->objectid);
+			BUG_ON(ret);
+		}
+	}
+	return 0;
+}
+
+static int mark_orphan_roots(struct btrfs_root *root,
+			     struct cache_tree *root_cache)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *dest;
+	struct root_record *rec;
+	struct cache_extent *cache;
+	struct btrfs_key root_key;
+	int ret;
+
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+
+	trans = btrfs_start_transaction(root, 1);
+
+	cache = find_first_cache_extent(root_cache, 0);
+	while (1) {
+		if (!cache)
+			break;
+		rec = container_of(cache, struct root_record, cache);
+		cache = next_cache_extent(cache);
+
+		if (rec->found_ref > 0 ||
+		    rec->objectid < BTRFS_FIRST_FREE_OBJECTID ||
+		    rec->objectid > BTRFS_LAST_FREE_OBJECTID)
+			continue;
+		ret = check_orphan_item(root->fs_info->tree_root,
+					rec->objectid);
+		if (ret == 0)
+			continue;
+		BUG_ON(ret != -ENOENT);
+
+		root_key.objectid = rec->objectid;
+		dest = btrfs_read_fs_root(root->fs_info, &root_key);
+		BUG_ON(IS_ERR(dest));
+
+		ret = del_root_refs(trans, root, rec);
+		BUG_ON(ret);
+
+		btrfs_set_root_refs(&dest->root_item, 0);
+		ret = btrfs_update_root(trans, root->fs_info->tree_root,
+					&dest->root_key, &dest->root_item);
+		BUG_ON(ret);
+
+		ret = mark_orphan_object(trans, root->fs_info->tree_root,
+					 rec->objectid);
+		BUG_ON(ret);
+		fprintf(stderr, "add orphan item for fs tree %llu\n",
+			(unsigned long long)rec->objectid);
+	}
+
+	btrfs_commit_transaction(trans, root);
+	return 0;
+}
+
+static int process_root_ref(struct extent_buffer *eb, int slot,
+			    struct btrfs_key *key,
+			    struct cache_tree *root_cache)
+{
+	u64 dirid;
+	u64 index;
+	u32 len;
+	u32 name_len;
+	struct btrfs_root_ref *ref;
+	char namebuf[BTRFS_NAME_LEN];
+	int error;
+
+	ref = btrfs_item_ptr(eb, slot, struct btrfs_root_ref);
+
+	dirid = btrfs_root_ref_dirid(eb, ref);
+	index = btrfs_root_ref_sequence(eb, ref);
+	name_len = btrfs_root_ref_name_len(eb, ref);
+
+	if (name_len <= BTRFS_NAME_LEN) {
+		len = name_len;
+		error = 0;
+	} else {
+		len = BTRFS_NAME_LEN;
+		error = REF_ERR_NAME_TOO_LONG;
+	}
+	read_extent_buffer(eb, namebuf, (unsigned long)(ref + 1), len);
+
+	if (key->type == BTRFS_ROOT_REF_KEY) {
+		add_root_backref(root_cache, key->offset, key->objectid, dirid,
+				 index, namebuf, len, key->type, error);
+	} else {
+		add_root_backref(root_cache, key->objectid, key->offset, dirid,
+				 index, namebuf, len, key->type, error);
+	}
+	return 0;
+}
+
 static int check_fs_root(struct btrfs_root *root,
+			 struct cache_tree *root_cache,
 			 struct walk_control *wc)
 {
 	int ret = 0;
@@ -1219,10 +1677,18 @@ static int check_fs_root(struct btrfs_ro
 	int level;
 	struct btrfs_path path;
 	struct shared_node root_node;
+	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
 
+	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+		rec = get_root_rec(root_cache, root->root_key.objectid);
+		if (btrfs_root_refs(root_item) > 0)
+			rec->found_root_item = 1;
+	}
+
 	btrfs_init_path(&path);
 	memset(&root_node, 0, sizeof(root_node));
+	cache_tree_init(&root_node.root_cache);
 	cache_tree_init(&root_node.inode_cache);
 
 	level = btrfs_header_level(root->node);
@@ -1266,6 +1732,8 @@ static int check_fs_root(struct btrfs_ro
 	}
 	btrfs_release_path(root, &path);
 
+	merge_root_recs(root, &root_node.root_cache, root_cache);
+
 	if (root_node.current) {
 		root_node.current->checked = 1;
 		maybe_free_inode_rec(&root_node.inode_cache,
@@ -1280,13 +1748,15 @@ static int fs_root_objectid(u64 objectid
 {
 	if (objectid == BTRFS_FS_TREE_OBJECTID ||
 	    objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	    objectid == BTRFS_DATA_RELOC_TREE_OBJECTID ||
 	    (objectid >= BTRFS_FIRST_FREE_OBJECTID &&
-	     objectid < BTRFS_LAST_FREE_OBJECTID))
+	     objectid <= BTRFS_LAST_FREE_OBJECTID))
 		return 1;
 	return 0;
 }
 
-static int check_fs_roots(struct btrfs_root *root)
+static int check_fs_roots(struct btrfs_root *root,
+			  struct cache_tree *root_cache)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -1319,10 +1789,14 @@ static int check_fs_roots(struct btrfs_r
 		    fs_root_objectid(key.objectid)) {
 			tmp_root = btrfs_read_fs_root_no_cache(root->fs_info,
 							       &key);
-			ret = check_fs_root(tmp_root, &wc);
+			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
 			btrfs_free_fs_root(root->fs_info, tmp_root);
+		} else if (key.type == BTRFS_ROOT_REF_KEY ||
+			   key.type == BTRFS_ROOT_BACKREF_KEY) {
+			process_root_ref(leaf, path.slots[0], &key,
+					 root_cache);
 		}
 		path.slots[0]++;
 	}
@@ -1895,7 +2369,6 @@ static int add_data_backref(struct cache
 	return 0;
 }
 
-
 static int add_pending(struct cache_tree *pending,
 		       struct cache_tree *seen, u64 bytenr, u32 size)
 {
@@ -2436,21 +2909,51 @@ static int check_extents(struct btrfs_ro
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfsck dev\n");
+	fprintf(stderr, "usage: btrfsck [-r] dev\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
 int main(int ac, char **av)
 {
+	struct cache_tree root_cache;
 	struct btrfs_root *root;
+	char *dev;
+	int repair = 0;
 	int ret;
 
-	if (ac < 2)
+	while (1) {
+		int c = getopt(ac, av, "r");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'r':
+			repair = 1;
+			break;
+		default:
+			print_usage();
+		}
+	}
+
+	ac = ac - optind;
+	if (ac != 1)
 		print_usage();
 
+	dev = av[optind];
+
+	ret = check_mounted(dev);
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s mount status\n", dev);
+		exit(1);
+	}
+	if (ret == 1) {
+		fprintf(stderr, "%s is mounted\n", dev);
+		exit(1);
+	}
+
 	radix_tree_init();
-	root = open_ctree(av[1], 0, 0);
+	cache_tree_init(&root_cache);
+	root = open_ctree(dev, 0, 0);
 
 	if (root == NULL)
 		return 1;
@@ -2458,10 +2961,22 @@ int main(int ac, char **av)
 	ret = check_extents(root);
 	if (ret)
 		goto out;
-	ret = check_fs_roots(root);
+	ret = check_fs_roots(root, &root_cache);
+	if (ret)
+		goto out;
 
+	ret = check_root_refs(root, &root_cache);
 out:
 	close_ctree(root);
+
+	if (repair && found_orphan_root) {
+		root = open_ctree(dev, 0, 1);
+		mark_orphan_roots(root, &root_cache);
+		close_ctree(root);
+	}
+
+	free_root_recs(&root_cache);
+
 	if (found_old_backref) {
 		/*
 		 * there was a disk format change when mixed
diff -urp btrfs-progs-unstable/ctree.h btrfs-progs/ctree.h
--- btrfs-progs-unstable/ctree.h	2009-08-13 13:52:55.325194298 +0800
+++ btrfs-progs/ctree.h	2009-08-17 15:03:12.399207699 +0800
@@ -1786,6 +1786,9 @@ int btrfs_add_root_ref(struct btrfs_tran
 		       u64 root_id, u8 type, u64 ref_id,
 		       u64 dirid, u64 sequence,
 		       const char *name, int name_len);
+int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *tree_root,
+		       u64 root_id, u8 type, u64 ref_id);
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
diff -urp btrfs-progs-unstable/root-tree.c btrfs-progs/root-tree.c
--- btrfs-progs-unstable/root-tree.c	2008-12-18 08:09:27.582093884 +0800
+++ btrfs-progs/root-tree.c	2009-08-17 15:14:27.604208580 +0800
@@ -202,6 +202,30 @@ out:
 	return ret;
 }
 
+
+int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *tree_root,
+		       u64 root_id, u8 type, u64 ref_id)
+{
+	struct btrfs_key key;
+	int ret;
+	struct btrfs_path path;
+
+	btrfs_init_path(&path);
+	key.objectid = root_id;
+	key.type = type;
+	key.offset = ref_id;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
+	BUG_ON(ret);
+
+	ret = btrfs_del_item(trans, tree_root, &path);
+	BUG_ON(ret);
+
+	btrfs_release_path(tree_root, &path);
+	return ret;
+}
+
 /*
  * add a btrfs_root_ref item.  type is either BTRFS_ROOT_REF_KEY
  * or BTRFS_ROOT_BACKREF_KEY.
