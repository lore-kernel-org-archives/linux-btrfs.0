Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39781 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3CGTVG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 14:21:06 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AA67C7C0431
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 12:21:05 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id ndYwy6MTuqQ7UGMh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 12:21:04 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add a incompatible format change for smaller metadata extent refs
Date: Thu, 7 Mar 2013 14:27:57 -0500
Message-ID: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We currently store the first key of the tree block inside the reference for the
tree block in the extent tree.  This takes up quite a bit of space.  Make a new
key type for metadata which holds the level as the offset and completely removes
storing the btrfs_tree_block_info inside the extent ref.  This reduces the size
from 51 bytes to 33 bytes per extent reference for each tree block.  In practice
this results in a 30-35% decrease in the size of our extent tree, which means we
COW less and can keep more of the extent tree in memory which makes our heavy
metadata operations go much faster.  This is not an automatic format change, you
must enable it at mkfs time or with btrfstune.  This patch deals with having
metadata stored as either the old format or the new format so it is easy to
convert.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c       |    3 +-
 fs/btrfs/ctree.h       |   19 ++++-
 fs/btrfs/disk-io.c     |    3 +
 fs/btrfs/extent-tree.c |  233 ++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/relocation.c  |   73 ++++++++++++---
 fs/btrfs/scrub.c       |   25 ++++--
 7 files changed, 293 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ecd25a1..773fa4b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -863,7 +863,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 
 	if (btrfs_block_can_be_shared(root, buf)) {
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
-					       buf->len, &refs, &flags);
+					       btrfs_header_level(buf), 1,
+					       &refs, &flags);
 		if (ret)
 			return ret;
 		if (refs == 0) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d82922..e91959a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -508,6 +508,7 @@ struct btrfs_super_block {
 
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
+#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -518,7 +519,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
-	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
+	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -1808,6 +1810,12 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_EXTENT_ITEM_KEY	168
 
+/*
+ * The same as the BTRFS_EXTENT_ITEM_KEY, except it's metadata we already know
+ * the length, so we save the level in key->offset instead of the length.
+ */
+#define BTRFS_METADATA_ITEM_KEY	169
+
 #define BTRFS_TREE_BLOCK_REF_KEY	176
 
 #define BTRFS_EXTENT_DATA_REF_KEY	178
@@ -3005,7 +3013,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags);
+			     u64 offset, int metadata, u64 *refs, u64 *flags);
 int btrfs_pin_extent(struct btrfs_root *root,
 		     u64 bytenr, u64 num, int reserved);
 int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
@@ -3668,6 +3676,13 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 	}
 }
 
+static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	disk_super = fs_info->super_copy;
+	return (btrfs_super_incompat_flags(disk_super) & flag);
+}
+
 /*
  * Call btrfs_abort_transaction as early as possible when an error condition is
  * detected, that way the exact line number is reported.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..7d4dcb6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2284,6 +2284,9 @@ int open_ctree(struct super_block *sb,
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
+	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
+		printk(KERN_ERR "btrfs: has skinny extents\n");
+
 	/*
 	 * flag our filesystem as having big metadata blocks if
 	 * they are bigger than the page size
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aaee2b7..7571a1a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -437,11 +437,16 @@ again:
 		    block_group->key.offset)
 			break;
 
-		if (key.type == BTRFS_EXTENT_ITEM_KEY) {
+		if (key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    key.type == BTRFS_METADATA_ITEM_KEY) {
 			total_found += add_new_free_space(block_group,
 							  fs_info, last,
 							  key.objectid);
-			last = key.objectid + key.offset;
+			if (key.type == BTRFS_METADATA_ITEM_KEY)
+				last = key.objectid +
+					fs_info->tree_root->leafsize;
+			else
+				last = key.objectid + key.offset;
 
 			if (total_found > (1024 * 1024 * 2)) {
 				total_found = 0;
@@ -713,15 +718,21 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 
 	key.objectid = start;
 	key.offset = len;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	key.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
 				0, 0);
+	if (ret > 0) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.objectid == start &&
+		    key.type == BTRFS_METADATA_ITEM_KEY)
+			ret = 0;
+	}
 	btrfs_free_path(path);
 	return ret;
 }
 
 /*
- * helper function to lookup reference count and flags of extent.
+ * helper function to lookup reference count and flags of a tree block.
  *
  * the head node for delayed ref is used to store the sum of all the
  * reference count modifications queued up in the rbtree. the head
@@ -731,7 +742,7 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
  */
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags)
+			     u64 offset, int metadata, u64 *refs, u64 *flags)
 {
 	struct btrfs_delayed_ref_head *head;
 	struct btrfs_delayed_ref_root *delayed_refs;
@@ -744,13 +755,31 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	u64 extent_flags;
 	int ret;
 
+	/*
+	 * If we don't have skinny metadata, don't bother doing anything
+	 * different
+	 */
+	if (metadata &&
+	    !btrfs_fs_incompat(root->fs_info,
+			       BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)) {
+		offset = root->leafsize;
+		metadata = 0;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = num_bytes;
+	if (metadata) {
+		key.objectid = bytenr;
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = offset;
+	} else {
+		key.objectid = bytenr;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = offset;
+	}
+
 	if (!trans) {
 		path->skip_locking = 1;
 		path->search_commit_root = 1;
@@ -761,6 +790,13 @@ again:
 	if (ret < 0)
 		goto out_free;
 
+	if (ret > 0 && metadata && key.type == BTRFS_METADATA_ITEM_KEY) {
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = root->leafsize;
+		btrfs_release_path(path);
+		goto again;
+	}
+
 	if (ret == 0) {
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -1448,6 +1484,9 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	int want;
 	int ret;
 	int err = 0;
+	bool skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1459,11 +1498,46 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		path->keep_locks = 1;
 	} else
 		extra_size = -1;
+
+	/*
+	 * Owner is our parent level, so we can just add one to get the level
+	 * for the block we are interested in.
+	 */
+	if (skinny_metadata && owner < BTRFS_FIRST_FREE_OBJECTID) {
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = owner;
+	}
+
+again:
 	ret = btrfs_search_slot(trans, root, &key, path, extra_size, 1);
 	if (ret < 0) {
 		err = ret;
 		goto out;
 	}
+
+	/*
+	 * We may be a newly converted file system which still has the old fat
+	 * extent entries for metadata, so try and see if we have one of those.
+	 */
+	if (ret > 0 && skinny_metadata) {
+		skinny_metadata = false;
+		if (path->slots[0]) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == num_bytes)
+				ret = 0;
+		}
+		if (ret) {
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = num_bytes;
+			btrfs_release_path(path);
+			goto again;
+		}
+	}
+
 	if (ret && !insert) {
 		err = -ENOENT;
 		goto out;
@@ -1496,11 +1570,9 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	ptr = (unsigned long)(ei + 1);
 	end = (unsigned long)ei + item_size;
 
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !skinny_metadata) {
 		ptr += sizeof(struct btrfs_tree_block_info);
 		BUG_ON(ptr > end);
-	} else {
-		BUG_ON(!(flags & BTRFS_EXTENT_FLAG_DATA));
 	}
 
 	err = -ENOENT;
@@ -1965,10 +2037,8 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 		ref_root = ref->root;
 
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
-		if (extent_op) {
-			BUG_ON(extent_op->update_key);
+		if (extent_op)
 			flags |= extent_op->flags_to_set;
-		}
 		ret = alloc_reserved_file_extent(trans, root,
 						 parent, ref_root, flags,
 						 ref->objectid, ref->offset,
@@ -2021,18 +2091,35 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	int ret;
 	int err = 0;
+	int metadata = (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
+			node->type == BTRFS_SHARED_BLOCK_REF_KEY);
 
 	if (trans->aborted)
 		return 0;
 
+	if (metadata &&
+	    !btrfs_fs_incompat(root->fs_info,
+			       BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA))
+		metadata = 0;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	key.objectid = node->bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
-	key.offset = node->num_bytes;
 
+	if (metadata) {
+		struct btrfs_delayed_tree_ref *tree_ref;
+
+		tree_ref = btrfs_delayed_node_to_tree_ref(node);
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = tree_ref->level;
+	} else {
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = node->num_bytes;
+	}
+
+again:
 	path->reada = 1;
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
@@ -2042,6 +2129,14 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 	if (ret > 0) {
+		if (metadata) {
+			btrfs_release_path(path);
+			metadata = 0;
+
+			key.offset = node->num_bytes;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			goto again;
+		}
 		err = -EIO;
 		goto out;
 	}
@@ -2081,10 +2176,9 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_key ins;
 	u64 parent = 0;
 	u64 ref_root = 0;
-
-	ins.objectid = node->bytenr;
-	ins.offset = node->num_bytes;
-	ins.type = BTRFS_EXTENT_ITEM_KEY;
+	bool skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
 	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
@@ -2092,10 +2186,18 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	else
 		ref_root = ref->root;
 
+	ins.objectid = node->bytenr;
+	if (skinny_metadata) {
+		ins.offset = ref->level;
+		ins.type = BTRFS_METADATA_ITEM_KEY;
+	} else {
+		ins.offset = node->num_bytes;
+		ins.type = BTRFS_EXTENT_ITEM_KEY;
+	}
+
 	BUG_ON(node->ref_mod != 1);
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
-		BUG_ON(!extent_op || !extent_op->update_flags ||
-		       !extent_op->update_key);
+		BUG_ON(!extent_op || !extent_op->update_flags);
 		ret = alloc_reserved_tree_block(trans, root,
 						parent, ref_root,
 						extent_op->flags_to_set,
@@ -5286,6 +5388,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	int num_to_del = 1;
 	u32 item_size;
 	u64 refs;
+	bool skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5297,6 +5402,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	BUG_ON(!is_data && refs_to_drop != 1);
 
+	if (is_data)
+		skinny_metadata = 0;
+
 	ret = lookup_extent_backref(trans, extent_root, path, &iref,
 				    bytenr, num_bytes, parent,
 				    root_objectid, owner_objectid,
@@ -5313,6 +5421,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				found_extent = 1;
 				break;
 			}
+			if (key.type == BTRFS_METADATA_ITEM_KEY &&
+			    key.offset == owner_objectid) {
+				found_extent = 1;
+				break;
+			}
 			if (path->slots[0] - extent_slot > 5)
 				break;
 			extent_slot--;
@@ -5338,8 +5451,36 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = num_bytes;
 
+			if (!is_data && skinny_metadata) {
+				key.type = BTRFS_METADATA_ITEM_KEY;
+				key.offset = owner_objectid;
+			}
+
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
+			if (ret > 0 && skinny_metadata && path->slots[0]) {
+				/*
+				 * Couldn't find our skinny metadata item,
+				 * see if we have ye olde extent item.
+				 */
+				path->slots[0]--;
+				btrfs_item_key_to_cpu(path->nodes[0], &key,
+						      path->slots[0]);
+				if (key.objectid == bytenr &&
+				    key.type == BTRFS_EXTENT_ITEM_KEY &&
+				    key.offset == num_bytes)
+					ret = 0;
+			}
+
+			if (ret > 0 && skinny_metadata) {
+				skinny_metadata = false;
+				key.type = BTRFS_EXTENT_ITEM_KEY;
+				key.offset = num_bytes;
+				btrfs_release_path(path);
+				ret = btrfs_search_slot(trans, extent_root,
+							&key, path, -1, 1);
+			}
+
 			if (ret) {
 				printk(KERN_ERR "umm, got %d back from search"
 				       ", was looking for %llu\n", ret,
@@ -5409,7 +5550,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(item_size < sizeof(*ei));
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
-	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
+	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID &&
+	    key.type == BTRFS_EXTENT_ITEM_KEY) {
 		struct btrfs_tree_block_info *bi;
 		BUG_ON(item_size < sizeof(*ei) + sizeof(*bi));
 		bi = (struct btrfs_tree_block_info *)(ei + 1);
@@ -6323,7 +6465,13 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
+	u32 size = sizeof(*extent_item) + sizeof(*iref);
+	bool skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
+
+	if (!skinny_metadata)
+		size += sizeof(*block_info);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -6344,12 +6492,16 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_set_extent_generation(leaf, extent_item, trans->transid);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
-	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 
-	btrfs_set_tree_block_key(leaf, block_info, key);
-	btrfs_set_tree_block_level(leaf, block_info, level);
+	if (skinny_metadata) {
+		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+	} else {
+		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
+		btrfs_set_tree_block_key(leaf, block_info, key);
+		btrfs_set_tree_block_level(leaf, block_info, level);
+		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
+	}
 
-	iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	if (parent > 0) {
 		BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
 		btrfs_set_extent_inline_ref_type(leaf, iref,
@@ -6364,7 +6516,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -6568,7 +6720,9 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *buf;
 	u64 flags = 0;
 	int ret;
-
+	bool skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	block_rsv = use_block_rsv(trans, root, blocksize);
 	if (IS_ERR(block_rsv))
@@ -6601,7 +6755,10 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		else
 			memset(&extent_op->key, 0, sizeof(extent_op->key));
 		extent_op->flags_to_set = flags;
-		extent_op->update_key = 1;
+		if (skinny_metadata)
+			extent_op->update_key = 0;
+		else
+			extent_op->update_key = 1;
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
 
@@ -6678,8 +6835,9 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 			continue;
 
 		/* We don't lock the tree block, it's OK to be racy here */
-		ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
-					       &refs, &flags);
+		ret = btrfs_lookup_extent_info(trans, root, bytenr,
+					       wc->level - 1, 1, &refs,
+					       &flags);
 		/* We don't care about errors in readahead. */
 		if (ret < 0)
 			continue;
@@ -6746,7 +6904,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	     (wc->stage == UPDATE_BACKREF && !(wc->flags[level] & flag)))) {
 		BUG_ON(!path->locks[level]);
 		ret = btrfs_lookup_extent_info(trans, root,
-					       eb->start, eb->len,
+					       eb->start, level, 1,
 					       &wc->refs[level],
 					       &wc->flags[level]);
 		BUG_ON(ret == -ENOMEM);
@@ -6844,7 +7002,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	btrfs_tree_lock(next);
 	btrfs_set_lock_blocking(next);
 
-	ret = btrfs_lookup_extent_info(trans, root, bytenr, blocksize,
+	ret = btrfs_lookup_extent_info(trans, root, bytenr, level - 1, 1,
 				       &wc->refs[level - 1],
 				       &wc->flags[level - 1]);
 	if (ret < 0) {
@@ -6975,7 +7133,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
-						       eb->start, eb->len,
+						       eb->start, level, 1,
 						       &wc->refs[level],
 						       &wc->flags[level]);
 			if (ret < 0) {
@@ -7185,8 +7343,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
-						path->nodes[level]->len,
-						&wc->refs[level],
+						level, 1, &wc->refs[level],
 						&wc->flags[level]);
 			if (ret < 0) {
 				err = ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ecd9c4c..09f8c53 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3641,7 +3641,7 @@ static int check_path_shared(struct btrfs_root *root,
 		eb = path->nodes[level];
 		if (!btrfs_block_can_be_shared(root, eb))
 			continue;
-		ret = btrfs_lookup_extent_info(NULL, root, eb->start, eb->len,
+		ret = btrfs_lookup_extent_info(NULL, root, eb->start, level, 1,
 					       &refs, NULL);
 		if (refs > 1)
 			return 1;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3ebe879..8445000 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -619,10 +619,13 @@ static noinline_for_stack
 int find_inline_backref(struct extent_buffer *leaf, int slot,
 			unsigned long *ptr, unsigned long *end)
 {
+	struct btrfs_key key;
 	struct btrfs_extent_item *ei;
 	struct btrfs_tree_block_info *bi;
 	u32 item_size;
 
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+
 	item_size = btrfs_item_size_nr(leaf, slot);
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (item_size < sizeof(*ei)) {
@@ -634,13 +637,18 @@ int find_inline_backref(struct extent_buffer *leaf, int slot,
 	WARN_ON(!(btrfs_extent_flags(leaf, ei) &
 		  BTRFS_EXTENT_FLAG_TREE_BLOCK));
 
-	if (item_size <= sizeof(*ei) + sizeof(*bi)) {
+	if (key.type == BTRFS_EXTENT_ITEM_KEY &&
+	    item_size <= sizeof(*ei) + sizeof(*bi)) {
 		WARN_ON(item_size < sizeof(*ei) + sizeof(*bi));
 		return 1;
 	}
 
-	bi = (struct btrfs_tree_block_info *)(ei + 1);
-	*ptr = (unsigned long)(bi + 1);
+	if (key.type == BTRFS_EXTENT_ITEM_KEY) {
+		bi = (struct btrfs_tree_block_info *)(ei + 1);
+		*ptr = (unsigned long)(bi + 1);
+	} else {
+		*ptr = (unsigned long)(ei + 1);
+	}
 	*end = (unsigned long)ei + item_size;
 	return 0;
 }
@@ -708,7 +716,7 @@ again:
 	end = 0;
 	ptr = 0;
 	key.objectid = cur->bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.type = BTRFS_METADATA_ITEM_KEY;
 	key.offset = (u64)-1;
 
 	path1->search_commit_root = 1;
@@ -766,7 +774,8 @@ again:
 				break;
 			}
 
-			if (key.type == BTRFS_EXTENT_ITEM_KEY) {
+			if (key.type == BTRFS_EXTENT_ITEM_KEY ||
+			    key.type == BTRFS_METADATA_ITEM_KEY) {
 				ret = find_inline_backref(eb, path1->slots[0],
 							  &ptr, &end);
 				if (ret)
@@ -2768,8 +2777,13 @@ static int reada_tree_block(struct reloc_control *rc,
 			    struct tree_block *block)
 {
 	BUG_ON(block->key_ready);
-	readahead_tree_block(rc->extent_root, block->bytenr,
-			     block->key.objectid, block->key.offset);
+	if (block->key.type == BTRFS_METADATA_ITEM_KEY)
+		readahead_tree_block(rc->extent_root, block->bytenr,
+				     block->key.objectid,
+				     rc->extent_root->leafsize);
+	else
+		readahead_tree_block(rc->extent_root, block->bytenr,
+				     block->key.objectid, block->key.offset);
 	return 0;
 }
 
@@ -3176,12 +3190,17 @@ static int add_tree_block(struct reloc_control *rc,
 	eb =  path->nodes[0];
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
 
-	if (item_size >= sizeof(*ei) + sizeof(*bi)) {
+	if (extent_key->type == BTRFS_METADATA_ITEM_KEY ||
+	    item_size >= sizeof(*ei) + sizeof(*bi)) {
 		ei = btrfs_item_ptr(eb, path->slots[0],
 				struct btrfs_extent_item);
-		bi = (struct btrfs_tree_block_info *)(ei + 1);
+		if (extent_key->type == BTRFS_EXTENT_ITEM_KEY) {
+			bi = (struct btrfs_tree_block_info *)(ei + 1);
+			level = btrfs_tree_block_level(eb, bi);
+		} else {
+			level = (int)extent_key->offset;
+		}
 		generation = btrfs_extent_generation(eb, ei);
-		level = btrfs_tree_block_level(eb, bi);
 	} else {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		u64 ref_owner;
@@ -3210,7 +3229,7 @@ static int add_tree_block(struct reloc_control *rc,
 		return -ENOMEM;
 
 	block->bytenr = extent_key->objectid;
-	block->key.objectid = extent_key->offset;
+	block->key.objectid = rc->extent_root->leafsize;
 	block->key.offset = generation;
 	block->level = level;
 	block->key_ready = 0;
@@ -3252,9 +3271,15 @@ static int __add_tree_block(struct reloc_control *rc,
 	ret = btrfs_search_slot(NULL, rc->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret);
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (ret > 0) {
+		if (key.objectid == bytenr &&
+		    key.type == BTRFS_METADATA_ITEM_KEY)
+			ret = 0;
+	}
+	BUG_ON(ret);
+
 	ret = add_tree_block(rc, &key, path, blocks);
 out:
 	btrfs_free_path(path);
@@ -3275,7 +3300,8 @@ static int block_use_full_backref(struct reloc_control *rc,
 		return 1;
 
 	ret = btrfs_lookup_extent_info(NULL, rc->extent_root,
-				       eb->start, eb->len, NULL, &flags);
+				       eb->start, btrfs_header_level(eb), 1,
+				       NULL, &flags);
 	BUG_ON(ret);
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
@@ -3644,12 +3670,25 @@ next:
 			break;
 		}
 
-		if (key.type != BTRFS_EXTENT_ITEM_KEY ||
+		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY) {
+			path->slots[0]++;
+			goto next;
+		}
+
+		if (key.type == BTRFS_EXTENT_ITEM_KEY &&
 		    key.objectid + key.offset <= rc->search_start) {
 			path->slots[0]++;
 			goto next;
 		}
 
+		if (key.type == BTRFS_METADATA_ITEM_KEY &&
+		    key.objectid + rc->extent_root->leafsize <=
+		    rc->search_start) {
+			path->slots[0]++;
+			goto next;
+		}
+
 		ret = find_first_extent_bit(&rc->processed_blocks,
 					    key.objectid, &start, &end,
 					    EXTENT_DIRTY, NULL);
@@ -3658,7 +3697,11 @@ next:
 			btrfs_release_path(path);
 			rc->search_start = end + 1;
 		} else {
-			rc->search_start = key.objectid + key.offset;
+			if (key.type == BTRFS_EXTENT_ITEM_KEY)
+				rc->search_start = key.objectid + key.offset;
+			else
+				rc->search_start = key.objectid +
+					rc->extent_root->leafsize;
 			memcpy(extent_key, &key, sizeof(key));
 			return 0;
 		}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 53c3501..e5e7580 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2314,8 +2314,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	key_start.type = BTRFS_EXTENT_ITEM_KEY;
 	key_start.offset = (u64)0;
 	key_end.objectid = base + offset + nstripes * increment;
-	key_end.type = BTRFS_EXTENT_ITEM_KEY;
-	key_end.offset = (u64)0;
+	key_end.type = BTRFS_METADATA_ITEM_KEY;
+	key_end.offset = (u64)-1;
 	reada1 = btrfs_reada_add(root, &key_start, &key_end);
 
 	key_start.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -2403,6 +2403,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
+
 		if (ret > 0) {
 			ret = btrfs_previous_item(root, path, 0,
 						  BTRFS_EXTENT_ITEM_KEY);
@@ -2420,6 +2421,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		}
 
 		while (1) {
+			u64 bytes;
+
 			l = path->nodes[0];
 			slot = path->slots[0];
 			if (slot >= btrfs_header_nritems(l)) {
@@ -2439,7 +2442,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			if (key.objectid >= logical + map->stripe_len)
 				break;
 
-			if (btrfs_key_type(&key) != BTRFS_EXTENT_ITEM_KEY)
+			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+			    key.type != BTRFS_METADATA_ITEM_KEY)
 				goto next;
 
 			extent = btrfs_item_ptr(l, slot,
@@ -2457,22 +2461,27 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto next;
 			}
 
+			if (key.type == BTRFS_METADATA_ITEM_KEY)
+				bytes = root->leafsize;
+			else
+				bytes = key.offset;
+
 			/*
 			 * trim extent to this stripe
 			 */
 			if (key.objectid < logical) {
-				key.offset -= logical - key.objectid;
+				bytes -= logical - key.objectid;
 				key.objectid = logical;
 			}
-			if (key.objectid + key.offset >
+			if (key.objectid + bytes >
 			    logical + map->stripe_len) {
-				key.offset = logical + map->stripe_len -
-					     key.objectid;
+				bytes = logical + map->stripe_len -
+					key.objectid;
 			}
 
 			extent_logical = key.objectid;
 			extent_physical = key.objectid - logical + physical;
-			extent_len = key.offset;
+			extent_len = bytes;
 			extent_dev = scrub_dev;
 			extent_mirror_num = mirror_num;
 			if (is_dev_replace)
-- 
1.7.7.6

