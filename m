From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 10/10] Btrfs: new backref walking code
Date: Wed,  4 Jan 2012 18:35:48 +0100
Message-ID: <2f0329c789a65af7fa9adc72a721996f1c7b7772.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

The old backref iteration code could only safely be used on commit roots.
Besides this limitation, it had bugs in finding the roots for these
references. This commit replaces large parts of it by btrfs_find_all_roots()
which a) really finds all roots and the correct roots, b) works correctly
under heavy file system load, c) considers delayed refs.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |  354 +++++++++++++++-------------------------------------
 fs/btrfs/ioctl.c   |    8 +-
 fs/btrfs/scrub.c   |    7 +-
 3 files changed, 107 insertions(+), 262 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 03c30a1..c4c3d5d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -23,18 +23,6 @@
 #include "transaction.h"
 #include "delayed-ref.h"
 
-struct __data_ref {
-	struct list_head list;
-	u64 inum;
-	u64 root;
-	u64 extent_data_item_offset;
-};
-
-struct __shared_ref {
-	struct list_head list;
-	u64 disk_byte;
-};
-
 /*
  * this structure records all encountered refs on the way up to the root
  */
@@ -964,8 +952,11 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
 	if (found_key->type != BTRFS_EXTENT_ITEM_KEY ||
 	    found_key->objectid > logical ||
-	    found_key->objectid + found_key->offset <= logical)
+	    found_key->objectid + found_key->offset <= logical) {
+		pr_debug("logical %llu is not within any extent\n",
+			 (unsigned long long)logical);
 		return -ENOENT;
+	}
 
 	eb = path->nodes[0];
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
@@ -974,6 +965,13 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
 
+	pr_debug("logical %llu is at position %llu within the extent (%llu "
+		 "EXTENT_ITEM %llu) flags %#llx size %u\n",
+		 (unsigned long long)logical,
+		 (unsigned long long)(logical - found_key->objectid),
+		 (unsigned long long)found_key->objectid,
+		 (unsigned long long)found_key->offset,
+		 (unsigned long long)flags, item_size);
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		return BTRFS_EXTENT_FLAG_TREE_BLOCK;
 	if (flags & BTRFS_EXTENT_FLAG_DATA)
@@ -1070,128 +1068,11 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 	return 0;
 }
 
-static int __data_list_add(struct list_head *head, u64 inum,
-				u64 extent_data_item_offset, u64 root)
-{
-	struct __data_ref *ref;
-
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
-	if (!ref)
-		return -ENOMEM;
-
-	ref->inum = inum;
-	ref->extent_data_item_offset = extent_data_item_offset;
-	ref->root = root;
-	list_add_tail(&ref->list, head);
-
-	return 0;
-}
-
-static int __data_list_add_eb(struct list_head *head, struct extent_buffer *eb,
-				struct btrfs_extent_data_ref *dref)
-{
-	return __data_list_add(head, btrfs_extent_data_ref_objectid(eb, dref),
-				btrfs_extent_data_ref_offset(eb, dref),
-				btrfs_extent_data_ref_root(eb, dref));
-}
-
-static int __shared_list_add(struct list_head *head, u64 disk_byte)
-{
-	struct __shared_ref *ref;
-
-	ref = kmalloc(sizeof(*ref), GFP_NOFS);
-	if (!ref)
-		return -ENOMEM;
-
-	ref->disk_byte = disk_byte;
-	list_add_tail(&ref->list, head);
-
-	return 0;
-}
-
-static int __iter_shared_inline_ref_inodes(struct btrfs_fs_info *fs_info,
-					   u64 logical, u64 inum,
-					   u64 extent_data_item_offset,
-					   u64 extent_offset,
-					   struct btrfs_path *path,
-					   struct list_head *data_refs,
-					   iterate_extent_inodes_t *iterate,
-					   void *ctx)
-{
-	u64 ref_root;
-	u32 item_size;
-	struct btrfs_key key;
-	struct extent_buffer *eb;
-	struct btrfs_extent_item *ei;
-	struct btrfs_extent_inline_ref *eiref;
-	struct __data_ref *ref;
-	int ret;
-	int type;
-	int last;
-	unsigned long ptr = 0;
-
-	WARN_ON(!list_empty(data_refs));
-	ret = extent_from_logical(fs_info, logical, path, &key);
-	if (ret & BTRFS_EXTENT_FLAG_DATA)
-		ret = -EIO;
-	if (ret < 0)
-		goto out;
-
-	eb = path->nodes[0];
-	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
-	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-
-	ret = 0;
-	ref_root = 0;
-	/*
-	 * as done in iterate_extent_inodes, we first build a list of refs to
-	 * iterate, then free the path and then iterate them to avoid deadlocks.
-	 */
-	do {
-		last = __get_extent_inline_ref(&ptr, eb, ei, item_size,
-						&eiref, &type);
-		if (last < 0) {
-			ret = last;
-			goto out;
-		}
-		if (type == BTRFS_TREE_BLOCK_REF_KEY ||
-		    type == BTRFS_SHARED_BLOCK_REF_KEY) {
-			ref_root = btrfs_extent_inline_ref_offset(eb, eiref);
-			ret = __data_list_add(data_refs, inum,
-						extent_data_item_offset,
-						ref_root);
-		}
-	} while (!ret && !last);
-
-	btrfs_release_path(path);
-
-	if (ref_root == 0) {
-		printk(KERN_ERR "btrfs: failed to find tree block ref "
-			"for shared data backref %llu\n", logical);
-		WARN_ON(1);
-		ret = -EIO;
-	}
-
-out:
-	while (!list_empty(data_refs)) {
-		ref = list_first_entry(data_refs, struct __data_ref, list);
-		list_del(&ref->list);
-		if (!ret)
-			ret = iterate(ref->inum, extent_offset +
-					ref->extent_data_item_offset,
-					ref->root, ctx);
-		kfree(ref);
-	}
-
-	return ret;
-}
-
-static int __iter_shared_inline_ref(struct btrfs_fs_info *fs_info,
-				    u64 logical, u64 orig_extent_item_objectid,
-				    u64 extent_offset, struct btrfs_path *path,
-				    struct list_head *data_refs,
-				    iterate_extent_inodes_t *iterate,
-				    void *ctx)
+static int iterate_leaf_refs(struct btrfs_fs_info *fs_info,
+				struct btrfs_path *path, u64 logical,
+				u64 orig_extent_item_objectid,
+				u64 extent_item_pos, u64 root,
+				iterate_extent_inodes_t *iterate, void *ctx)
 {
 	u64 disk_byte;
 	struct btrfs_key key;
@@ -1199,8 +1080,10 @@ static int __iter_shared_inline_ref(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *eb;
 	int slot;
 	int nritems;
-	int ret;
-	int found = 0;
+	int ret = 0;
+	int extent_type;
+	u64 data_offset;
+	u64 data_len;
 
 	eb = read_tree_block(fs_info->tree_root, logical,
 				fs_info->tree_root->leafsize, 0);
@@ -1218,149 +1101,99 @@ static int __iter_shared_inline_ref(struct btrfs_fs_info *fs_info,
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
 			continue;
 		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
-		if (!fi) {
-			free_extent_buffer(eb);
-			return -EIO;
-		}
+		extent_type = btrfs_file_extent_type(eb, fi);
+		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		/* don't skip BTRFS_FILE_EXTENT_PREALLOC, we can handle that */
 		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
-		if (disk_byte != orig_extent_item_objectid) {
-			if (found)
-				break;
-			else
-				continue;
-		}
-		++found;
-		ret = __iter_shared_inline_ref_inodes(fs_info, logical,
-							key.objectid,
-							key.offset,
-							extent_offset, path,
-							data_refs,
-							iterate, ctx);
-		if (ret)
-			break;
-	}
+		if (disk_byte != orig_extent_item_objectid)
+			continue;
 
-	if (!found) {
-		printk(KERN_ERR "btrfs: failed to follow shared data backref "
-			"to parent %llu\n", logical);
-		WARN_ON(1);
-		ret = -EIO;
+		data_offset = btrfs_file_extent_offset(eb, fi);
+		data_len = btrfs_file_extent_num_bytes(eb, fi);
+
+		if (extent_item_pos < data_offset ||
+		    extent_item_pos >= data_offset + data_len)
+			continue;
+
+		pr_debug("ref for %llu resolved, key (%llu EXTEND_DATA %llu), "
+				"root %llu\n", orig_extent_item_objectid,
+				key.objectid, key.offset, root);
+		ret = iterate(key.objectid,
+				key.offset + (extent_item_pos - data_offset),
+				root, ctx);
+		if (ret) {
+			pr_debug("stopping iteration because ret=%d\n", ret);
+			break;
+		}
 	}
 
 	free_extent_buffer(eb);
+
 	return ret;
 }
 
 /*
  * calls iterate() for every inode that references the extent identified by
- * the given parameters. will use the path given as a parameter and return it
- * released.
+ * the given parameters.
  * when the iterator function returns a non-zero value, iteration stops.
+ * path is guaranteed to be in released state when iterate() is called.
  */
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				u64 extent_item_objectid,
-				u64 extent_offset,
+				u64 extent_item_objectid, u64 extent_item_pos,
 				iterate_extent_inodes_t *iterate, void *ctx)
 {
-	unsigned long ptr = 0;
-	int last;
 	int ret;
-	int type;
-	u64 logical;
-	u32 item_size;
-	struct btrfs_extent_inline_ref *eiref;
-	struct btrfs_extent_data_ref *dref;
-	struct extent_buffer *eb;
-	struct btrfs_extent_item *ei;
-	struct btrfs_key key;
 	struct list_head data_refs = LIST_HEAD_INIT(data_refs);
 	struct list_head shared_refs = LIST_HEAD_INIT(shared_refs);
-	struct __data_ref *ref_d;
-	struct __shared_ref *ref_s;
+	struct btrfs_trans_handle *trans;
+	struct ulist *refs;
+	struct ulist *roots;
+	struct ulist_node *ref_node = NULL;
+	struct ulist_node *root_node = NULL;
+	struct seq_list seq_elem;
+	struct btrfs_delayed_ref_root *delayed_refs;
 
-	eb = path->nodes[0];
-	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
-	item_size = btrfs_item_size_nr(eb, path->slots[0]);
-
-	/* first we iterate the inline refs, ... */
-	do {
-		last = __get_extent_inline_ref(&ptr, eb, ei, item_size,
-						&eiref, &type);
-		if (last == -ENOENT) {
-			ret = 0;
-			break;
-		}
-		if (last < 0) {
-			ret = last;
-			break;
-		}
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
-			dref = (struct btrfs_extent_data_ref *)(&eiref->offset);
-			ret = __data_list_add_eb(&data_refs, eb, dref);
-		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
-			logical = btrfs_extent_inline_ref_offset(eb, eiref);
-			ret = __shared_list_add(&shared_refs, logical);
-		}
-	} while (!ret && !last);
+	pr_debug("resolving all inodes for extent %llu\n",
+			extent_item_objectid);
 
-	/* ... then we proceed to in-tree references and ... */
-	while (!ret) {
-		++path->slots[0];
-		if (path->slots[0] > btrfs_header_nritems(eb)) {
-			ret = btrfs_next_leaf(fs_info->extent_root, path);
-			if (ret) {
-				if (ret == 1)
-					ret = 0; /* we're done */
-				break;
-			}
-			eb = path->nodes[0];
-		}
-		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
-		if (key.objectid != extent_item_objectid)
-			break;
-		if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
-			dref = btrfs_item_ptr(eb, path->slots[0],
-						struct btrfs_extent_data_ref);
-			ret = __data_list_add_eb(&data_refs, eb, dref);
-		} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
-			ret = __shared_list_add(&shared_refs, key.offset);
-		}
-	}
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+	btrfs_get_delayed_seq(delayed_refs, &seq_elem);
+	spin_unlock(&delayed_refs->lock);
 
-	btrfs_release_path(path);
+	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
+				   extent_item_pos, seq_elem.seq,
+				   &refs);
 
-	/*
-	 * ... only at the very end we can process the refs we found. this is
-	 * because the iterator function we call is allowed to make tree lookups
-	 * and we have to avoid deadlocks. additionally, we need more tree
-	 * lookups ourselves for shared data refs.
-	 */
-	while (!list_empty(&data_refs)) {
-		ref_d = list_first_entry(&data_refs, struct __data_ref, list);
-		list_del(&ref_d->list);
-		if (!ret)
-			ret = iterate(ref_d->inum, extent_offset +
-					ref_d->extent_data_item_offset,
-					ref_d->root, ctx);
-		kfree(ref_d);
-	}
+	if (ret)
+		goto out;
 
-	while (!list_empty(&shared_refs)) {
-		ref_s = list_first_entry(&shared_refs, struct __shared_ref,
-					list);
-		list_del(&ref_s->list);
-		if (!ret)
-			ret = __iter_shared_inline_ref(fs_info,
-							ref_s->disk_byte,
-							extent_item_objectid,
-							extent_offset, path,
-							&data_refs,
-							iterate, ctx);
-		kfree(ref_s);
+	while (!ret && (ref_node = ulist_next(refs, ref_node))) {
+		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val, -1,
+						seq_elem.seq, &roots);
+		if (ret)
+			break;
+		while (!ret && (root_node = ulist_next(roots, root_node))) {
+			pr_debug("root %llu references leaf %llu\n",
+					root_node->val, ref_node->val);
+			ret = iterate_leaf_refs(fs_info, path, ref_node->val,
+						extent_item_objectid,
+						extent_item_pos, root_node->val,
+						iterate, ctx);
+		}
 	}
 
+	ulist_free(refs);
+	ulist_free(roots);
+out:
+	btrfs_put_delayed_seq(delayed_refs, &seq_elem);
+	btrfs_end_transaction(trans, fs_info->extent_root);
 	return ret;
 }
 
@@ -1369,19 +1202,20 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				iterate_extent_inodes_t *iterate, void *ctx)
 {
 	int ret;
-	u64 offset;
+	u64 extent_item_pos;
 	struct btrfs_key found_key;
 
 	ret = extent_from_logical(fs_info, logical, path,
 					&found_key);
+	btrfs_release_path(path);
 	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		ret = -EINVAL;
 	if (ret < 0)
 		return ret;
 
-	offset = logical - found_key.objectid;
+	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, path, found_key.objectid,
-					offset, iterate, ctx);
+					extent_item_pos, iterate, ctx);
 
 	return ret;
 }
@@ -1426,6 +1260,10 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 		for (cur = 0; cur < btrfs_item_size(eb, item); cur += len) {
 			name_len = btrfs_inode_ref_name_len(eb, iref);
 			/* path must be released before calling iterate()! */
+			pr_debug("following ref at offset %u for inode %llu in "
+				 "tree %llu\n", cur,
+				 (unsigned long long)found_key.objectid,
+				 (unsigned long long)fs_root->objectid);
 			ret = iterate(parent, iref, eb, ctx);
 			if (ret) {
 				free_extent_buffer(eb);
@@ -1466,10 +1304,14 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
 		return PTR_ERR(fspath);
 
 	if (fspath > fspath_min) {
+		pr_debug("path resolved: %s\n", fspath);
 		ipath->fspath->val[i] = (u64)(unsigned long)fspath;
 		++ipath->fspath->elem_cnt;
 		ipath->fspath->bytes_left = fspath - fspath_min;
 	} else {
+		pr_debug("missed path, not enough space. missing bytes: %ld, "
+			 "constructed so far: %s\n", fspath_min - fspath,
+			 fspath_min);
 		++ipath->fspath->elem_missed;
 		ipath->fspath->bytes_missing += fspath_min - fspath;
 		ipath->fspath->bytes_left = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c48f2e9..9b05268 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2976,7 +2976,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 {
 	int ret = 0;
 	int size;
-	u64 extent_offset;
+	u64 extent_item_pos;
 	struct btrfs_ioctl_logical_ino_args *loi;
 	struct btrfs_data_container *inodes = NULL;
 	struct btrfs_path *path = NULL;
@@ -3007,15 +3007,17 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 	}
 
 	ret = extent_from_logical(root->fs_info, loi->logical, path, &key);
+	btrfs_release_path(path);
 
 	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		ret = -ENOENT;
 	if (ret < 0)
 		goto out;
 
-	extent_offset = loi->logical - key.objectid;
+	extent_item_pos = loi->logical - key.objectid;
 	ret = iterate_extent_inodes(root->fs_info, path, key.objectid,
-					extent_offset, build_ino_list, inodes);
+					extent_item_pos, build_ino_list,
+					inodes);
 
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c27bcb6..b5edff2 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -309,7 +309,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
 	u8 ref_level;
 	unsigned long ptr = 0;
 	const int bufsize = 4096;
-	u64 extent_offset;
+	u64 extent_item_pos;
 
 	path = btrfs_alloc_path();
 
@@ -329,12 +329,13 @@ static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
 	if (ret < 0)
 		goto out;
 
-	extent_offset = swarn.logical - found_key.objectid;
+	extent_item_pos = swarn.logical - found_key.objectid;
 	swarn.extent_item_size = found_key.offset;
 
 	eb = path->nodes[0];
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
+	btrfs_release_path(path);
 
 	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
@@ -351,7 +352,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
 	} else {
 		swarn.path = path;
 		iterate_extent_inodes(fs_info, path, found_key.objectid,
-					extent_offset,
+					extent_item_pos,
 					scrub_print_warning_inode, &swarn);
 	}
 
-- 
1.7.3.4

