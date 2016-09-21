Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12097 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752098AbcIUDQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:30 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2 13/14] btrfs-progs: check: skip shared node or leaf check for low_memory mode
Date: Wed, 21 Sep 2016 11:16:03 +0800
Message-Id: <20160921031604.23334-14-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

The basic idea is simple. Assume a middle tree node A is shared and
its referenceing fs/file tree root ids are 5, 258 and 260, then we
only check node A in the tree who has the smallest root id. That means
in this case, when checking root tree(5), we check inode A, for root
tree 258 and 260, we can just skip it.

Notice even with this patch, we still may visit a shared node or leaf
multiple times. This happens when a inode metadata occupies multiple
leaves.

                 leaf_A     leaf_B
When checking inode item in leaf_A, assume inode[512] have file extents
in leaf_B, and leaf_B is shared. In the case, for inode[512], we must
visit leaf_B to have inode item check. After finishing inode[512] check,
here we walk down tree root to leaf_B to check whether node or leaf
is shared, if some node or leaf is shared, we can just skip it and below
nodes or leaf's check.

I also fill a disk partition with linux source codes and create 3
snapshots
in it. Before this patch, it averagely took 46s to finish one btrfsck
execution, with this patch, it averagely took 15s.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 390 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 321 insertions(+), 69 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 701fff5..d290a66 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -113,6 +113,24 @@ struct data_backref {
 	u32 found_ref;
 };
 
+#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
+#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
+#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
+#define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
+#define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
+#define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
+#define FILE_EXTENT_ERROR	(1<<7)	/* bad file extent */
+#define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM ERROR */
+#define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
+#define LINK_COUNT_ERROR	(1<<10)	/* INODE_ITEM nlink count error */
+#define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
+#define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
+#define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
+#define NO_INODE_ITEM		(1<<14) /* no inode_item */
+#define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
+#define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
+#define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
+
 static inline struct data_backref* to_data_backref(struct extent_backref *back)
 {
 	return container_of(back, struct data_backref, node);
@@ -1839,6 +1857,92 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	return ret;
 }
 
+struct node_refs {
+	u64 bytenr[BTRFS_MAX_LEVEL];
+	u64 refs[BTRFS_MAX_LEVEL];
+	int need_check[BTRFS_MAX_LEVEL];
+};
+
+static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
+			     struct node_refs *nrefs, u64 level);
+static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
+			    unsigned int ext_ref);
+
+static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
+			       struct node_refs *nrefs, int *level, int ext_ref)
+{
+	struct extent_buffer *cur = path->nodes[0];
+	struct btrfs_key key;
+	u64 cur_bytenr;
+	u32 nritems;
+	int root_level = btrfs_header_level(root->node);
+	int i;
+	int ret = 0; /* Final return value */
+	int err = 0; /* Positive error bitmap */
+
+	cur_bytenr = cur->start;
+
+	/* skip to first inode item in this leaf */
+	nritems = btrfs_header_nritems(cur);
+	for (i = 0; i < nritems; i++) {
+		btrfs_item_key_to_cpu(cur, &key, i);
+		if (key.type == BTRFS_INODE_ITEM_KEY)
+			break;
+	}
+	if (i == nritems) {
+		path->slots[0] = nritems;
+		return 0;
+	}
+	path->slots[0] = i;
+
+again:
+	err |= check_inode_item(root, path, ext_ref);
+
+	if (err & LAST_ITEM)
+		goto out;
+
+	/* still have inode items in thie leaf */
+	if (cur->start == cur_bytenr)
+		goto again;
+
+	/*
+	 * we have switched to another leaf, above nodes may
+	 * have changed, here walk down the path, if a node
+	 * or leaf is shared, check whether we can skip this
+	 * node or leaf.
+	 */
+	for (i = root_level; i >= 0; i--) {
+		if (path->nodes[i]->start == nrefs->bytenr[i])
+			continue;
+
+		ret = update_nodes_refs(root,
+				path->nodes[i]->start,
+				nrefs, i);
+		if (ret)
+			goto out;
+
+		if (!nrefs->need_check[i]) {
+			*level += 1;
+			break;
+		}
+	}
+
+	for (i = 0; i < *level; i++) {
+		free_extent_buffer(path->nodes[i]);
+		path->nodes[i] = NULL;
+	}
+out:
+	err &= ~LAST_ITEM;
+	/*
+	 * Convert any error bitmap to -EIO, as we should avoid
+	 * mixing positive and negative return value to represent
+	 * error
+	 */
+	if (err && !ret)
+		ret = -EIO;
+	return ret;
+}
+
 static void reada_walk_down(struct btrfs_root *root,
 			    struct extent_buffer *node, int slot)
 {
@@ -1912,10 +2016,66 @@ static int check_child_node(struct btrfs_root *root,
 	return ret;
 }
 
-struct node_refs {
-	u64 bytenr[BTRFS_MAX_LEVEL];
-	u64 refs[BTRFS_MAX_LEVEL];
-};
+/*
+ * for a tree node or leaf, if it's shared, indeed we don't need to iterate it
+ * in every fs or file tree check. Here we find its all root ids, and only check
+ * it in the fs or file tree which has the smallest root id.
+ */
+static int need_check(struct btrfs_root *root, struct ulist *roots)
+{
+	struct rb_node *node;
+	struct ulist_node *u;
+
+	if (roots->nnodes == 1)
+		return 1;
+
+	node = rb_first(&roots->root);
+	u = rb_entry(node, struct ulist_node, rb_node);
+	/*
+	 * current root id is not smallest, we skip it and let it be checked
+	 * in the fs or file tree who hash the smallest root id.
+	 */
+	if (root->objectid != u->val)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * for a tree node or leaf, we record its reference count, so later if we still
+ * process this node or leaf, don't need to compute its reference count again.
+ */
+static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
+			     struct node_refs *nrefs, u64 level)
+{
+	int check, ret;
+	u64 refs;
+	struct ulist *roots;
+
+	if (nrefs->bytenr[level] != bytenr) {
+		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+				       level, 1, &refs, NULL);
+		if (ret < 0)
+			return ret;
+
+		nrefs->bytenr[level] = bytenr;
+		nrefs->refs[level] = refs;
+		if (refs > 1) {
+			ret = btrfs_find_all_roots(NULL, root->fs_info, bytenr,
+						   0, &roots);
+			if (ret)
+				return -EIO;
+
+			check = need_check(root, roots);
+			ulist_free(roots);
+			nrefs->need_check[level] = check;
+		} else {
+			nrefs->need_check[level] = 1;
+		}
+	}
+
+	return 0;
+}
 
 static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			  struct walk_control *wc, int *level,
@@ -2046,6 +2206,110 @@ out:
 	return err;
 }
 
+static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
+			    unsigned int ext_ref);
+
+static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
+			     int *level, struct node_refs *nrefs, int ext_ref)
+{
+	enum btrfs_tree_block_status status;
+	u64 bytenr;
+	u64 ptr_gen;
+	struct extent_buffer *next;
+	struct extent_buffer *cur;
+	u32 blocksize;
+	int ret;
+
+	WARN_ON(*level < 0);
+	WARN_ON(*level >= BTRFS_MAX_LEVEL);
+
+	ret = update_nodes_refs(root, path->nodes[*level]->start,
+				nrefs, *level);
+	if (ret < 0)
+		return ret;
+
+	while (*level >= 0) {
+		WARN_ON(*level < 0);
+		WARN_ON(*level >= BTRFS_MAX_LEVEL);
+		cur = path->nodes[*level];
+
+		if (btrfs_header_level(cur) != *level)
+			WARN_ON(1);
+
+		if (path->slots[*level] >= btrfs_header_nritems(cur))
+			break;
+		/* Don't forgot to check leaf/node validation */
+		if (*level == 0) {
+			ret = btrfs_check_leaf(root, NULL, cur);
+			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
+				ret = -EIO;
+				break;
+			}
+			ret = process_one_leaf_v2(root, path, nrefs,
+						  level, ext_ref);
+			break;
+		} else {
+			ret = btrfs_check_node(root, NULL, cur);
+			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
+				ret = -EIO;
+				break;
+			}
+		}
+		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
+		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
+		blocksize = root->nodesize;
+
+		ret = update_nodes_refs(root, bytenr, nrefs, *level - 1);
+		if (ret)
+			break;
+		if (!nrefs->need_check[*level - 1]) {
+			path->slots[*level]++;
+			continue;
+		}
+
+		next = btrfs_find_tree_block(root, bytenr, blocksize);
+		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
+			free_extent_buffer(next);
+			reada_walk_down(root, cur, path->slots[*level]);
+			next = read_tree_block(root, bytenr, blocksize,
+					       ptr_gen);
+			if (!extent_buffer_uptodate(next)) {
+				struct btrfs_key node_key;
+
+				btrfs_node_key_to_cpu(path->nodes[*level],
+						      &node_key,
+						      path->slots[*level]);
+				btrfs_add_corrupt_extent_record(root->fs_info,
+						&node_key,
+						path->nodes[*level]->start,
+						root->nodesize, *level);
+				ret = -EIO;
+				break;
+			}
+		}
+
+		ret = check_child_node(root, cur, path->slots[*level], next);
+		if (ret < 0) 
+			break;
+
+		if (btrfs_is_leaf(next))
+			status = btrfs_check_leaf(root, NULL, next);
+		else
+			status = btrfs_check_node(root, NULL, next);
+		if (status != BTRFS_TREE_BLOCK_CLEAN) {
+			free_extent_buffer(next);
+			ret = -EIO;
+			break;
+		}
+
+		*level = *level - 1;
+		free_extent_buffer(path->nodes[*level]);
+		path->nodes[*level] = next;
+		path->slots[*level] = 0;
+	}
+	return ret;
+}
+
 static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
 			struct walk_control *wc, int *level)
 {
@@ -2070,6 +2334,27 @@ static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
 	return 1;
 }
 
+static int walk_up_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
+			   int *level)
+{
+	int i;
+	struct extent_buffer *leaf;
+
+	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
+		leaf = path->nodes[i];
+		if (path->slots[i] + 1 < btrfs_header_nritems(leaf)) {
+			path->slots[i]++;
+			*level = i;
+			return 0;
+		} else {
+			free_extent_buffer(path->nodes[*level]);
+			path->nodes[*level] = NULL;
+			*level = i + 1;
+		}
+	}
+	return 1;
+}
+
 static int check_root_dir(struct inode_record *rec)
 {
 	struct inode_backref *backref;
@@ -3849,24 +4134,6 @@ out:
 	return err;
 }
 
-#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
-#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
-#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
-#define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
-#define INODE_ITEM_MISSING	(1<<5)	/* INODE_ITEM not found */
-#define INODE_ITEM_MISMATCH	(1<<6)	/* INODE_ITEM found but not match */
-#define FILE_EXTENT_ERROR	(1<<7)	/* bad file extent */
-#define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM ERROR */
-#define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
-#define LINK_COUNT_ERROR	(1<<10)	/* INODE_ITEM nlink count error */
-#define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
-#define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
-#define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
-#define NO_INODE_ITEM		(1<<14) /* no inode_item */
-#define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
-#define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
-#define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
-
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
  * INODE_REF/INODE_EXTREF match.
@@ -4692,69 +4959,54 @@ out:
  *
  * Return 0 if no error found.
  * Return <0 for error.
- * All internal error bitmap will be converted to -EIO, to avoid
- * mixing negative and postive return value.
  */
 static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 {
 	struct btrfs_path *path;
-	struct btrfs_key key;
-	u64 inode_id;
-	int ret, err = 0;
+	struct node_refs nrefs;
+	struct btrfs_root_item *root_item = &root->root_item;
+	int ret, wret;
+	int level;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = 0;
-	key.type = 0;
-	key.offset = 0;
-
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto out;
+	memset(&nrefs, 0, sizeof(nrefs));
+	level = btrfs_header_level(root->node);
 
-	while (1) {
-		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (btrfs_root_refs(root_item) > 0 ||
+	    btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
+		path->nodes[level] = root->node;
+		path->slots[level] = 0;
+		extent_buffer_get(root->node);
+	} else {
+		struct btrfs_key key;
 
-		/*
-		 * All check must start with inode item, skip if not
-		 */
-		if (key.type == BTRFS_INODE_ITEM_KEY) {
-			ret = check_inode_item(root, path, ext_ref);
-			err |= ret;
-			if (err & LAST_ITEM)
-				goto out;
-			continue;
-		}
-		error("root %llu ITEM[%llu %u %llu] isn't INODE_ITEM, skip to next inode",
-		      root->objectid, key.objectid, key.type,
-		      key.offset);
+		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
+		level = root_item->drop_level;
+		path->lowest_level = level;
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ret = 0;
+	}
 
-		err |= NO_INODE_ITEM;
-		inode_id = key.objectid;
+	while (1) {
+		wret = walk_down_tree_v2(root, path, &level, &nrefs, ext_ref);
+		if (wret < 0)
+			ret = wret;
+		if (wret != 0)
+			break;
 
-		/*
-		 * skip to next inode
-		 * TODO: Maybe search_slot() will be faster?
-		 */
-		do {
-			ret = btrfs_next_item(root, path);
-			if (ret > 0) {
-				goto out;
-			} else if (ret < 0) {
-				err = ret;
-				goto out;
-			}
-			btrfs_item_key_to_cpu(path->nodes[0], &key,
-					      path->slots[0]);
-		} while (inode_id == key.objectid);
+		wret = walk_up_tree_v2(root, path, &level);
+		if (wret < 0)
+			ret = wret;
+		if (wret != 0)
+			break;
 	}
 
 out:
-	err &= ~LAST_ITEM;
-	if (err && !ret)
-		ret = -EIO;
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.10.0



