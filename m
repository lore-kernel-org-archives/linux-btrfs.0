From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check items for correctness as we search V3
Date: Thu, 17 Mar 2011 14:18:35 -0400
Message-ID: <1300385915-3317-1-git-send-email-josef@redhat.com>
References: <1300305863-2609-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300305863-2609-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we have corrupted items things will blow up in spectacular ways.
So as we read in blocks and they are leaves, check the entire leaf to make sure
all of the items are correct and point to valid parts in the leaf for the item
data the are responsible for.  If the item is corrupt we will kick back EIO and
not read any of the copies since they are likely to not be correct either.  This
will catch generic corruptions, it will be up to the individual callers of
btrfs_search_slot to make sure their items are right.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V2->V3:
-Be smarter about checking the leaf
-Clear EXTENT_BUFFER_CORRUPT on read and delete

 fs/btrfs/ctree.c       |  123 ------------------------------------------------
 fs/btrfs/disk-io.c     |   90 ++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent-tree.c |    5 ++
 fs/btrfs/extent_io.h   |    1 +
 4 files changed, 95 insertions(+), 124 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..73e5300 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -732,122 +732,6 @@ static inline unsigned int leaf_data_end(struct btrfs_root *root,
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
-/*
- * extra debugging checks to make sure all the items in a key are
- * well formed and in the proper order
- */
-static int check_node(struct btrfs_root *root, struct btrfs_path *path,
-		      int level)
-{
-	struct extent_buffer *parent = NULL;
-	struct extent_buffer *node = path->nodes[level];
-	struct btrfs_disk_key parent_key;
-	struct btrfs_disk_key node_key;
-	int parent_slot;
-	int slot;
-	struct btrfs_key cpukey;
-	u32 nritems = btrfs_header_nritems(node);
-
-	if (path->nodes[level + 1])
-		parent = path->nodes[level + 1];
-
-	slot = path->slots[level];
-	BUG_ON(nritems == 0);
-	if (parent) {
-		parent_slot = path->slots[level + 1];
-		btrfs_node_key(parent, &parent_key, parent_slot);
-		btrfs_node_key(node, &node_key, 0);
-		BUG_ON(memcmp(&parent_key, &node_key,
-			      sizeof(struct btrfs_disk_key)));
-		BUG_ON(btrfs_node_blockptr(parent, parent_slot) !=
-		       btrfs_header_bytenr(node));
-	}
-	BUG_ON(nritems > BTRFS_NODEPTRS_PER_BLOCK(root));
-	if (slot != 0) {
-		btrfs_node_key_to_cpu(node, &cpukey, slot - 1);
-		btrfs_node_key(node, &node_key, slot);
-		BUG_ON(comp_keys(&node_key, &cpukey) <= 0);
-	}
-	if (slot < nritems - 1) {
-		btrfs_node_key_to_cpu(node, &cpukey, slot + 1);
-		btrfs_node_key(node, &node_key, slot);
-		BUG_ON(comp_keys(&node_key, &cpukey) >= 0);
-	}
-	return 0;
-}
-
-/*
- * extra checking to make sure all the items in a leaf are
- * well formed and in the proper order
- */
-static int check_leaf(struct btrfs_root *root, struct btrfs_path *path,
-		      int level)
-{
-	struct extent_buffer *leaf = path->nodes[level];
-	struct extent_buffer *parent = NULL;
-	int parent_slot;
-	struct btrfs_key cpukey;
-	struct btrfs_disk_key parent_key;
-	struct btrfs_disk_key leaf_key;
-	int slot = path->slots[0];
-
-	u32 nritems = btrfs_header_nritems(leaf);
-
-	if (path->nodes[level + 1])
-		parent = path->nodes[level + 1];
-
-	if (nritems == 0)
-		return 0;
-
-	if (parent) {
-		parent_slot = path->slots[level + 1];
-		btrfs_node_key(parent, &parent_key, parent_slot);
-		btrfs_item_key(leaf, &leaf_key, 0);
-
-		BUG_ON(memcmp(&parent_key, &leaf_key,
-		       sizeof(struct btrfs_disk_key)));
-		BUG_ON(btrfs_node_blockptr(parent, parent_slot) !=
-		       btrfs_header_bytenr(leaf));
-	}
-	if (slot != 0 && slot < nritems - 1) {
-		btrfs_item_key(leaf, &leaf_key, slot);
-		btrfs_item_key_to_cpu(leaf, &cpukey, slot - 1);
-		if (comp_keys(&leaf_key, &cpukey) <= 0) {
-			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad key\n", slot);
-			BUG_ON(1);
-		}
-		if (btrfs_item_offset_nr(leaf, slot - 1) !=
-		       btrfs_item_end_nr(leaf, slot)) {
-			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad\n", slot);
-			BUG_ON(1);
-		}
-	}
-	if (slot < nritems - 1) {
-		btrfs_item_key(leaf, &leaf_key, slot);
-		btrfs_item_key_to_cpu(leaf, &cpukey, slot + 1);
-		BUG_ON(comp_keys(&leaf_key, &cpukey) >= 0);
-		if (btrfs_item_offset_nr(leaf, slot) !=
-			btrfs_item_end_nr(leaf, slot + 1)) {
-			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad\n", slot);
-			BUG_ON(1);
-		}
-	}
-	BUG_ON(btrfs_item_offset_nr(leaf, 0) +
-	       btrfs_item_size_nr(leaf, 0) != BTRFS_LEAF_DATA_SIZE(root));
-	return 0;
-}
-
-static noinline int check_block(struct btrfs_root *root,
-				struct btrfs_path *path, int level)
-{
-	return 0;
-	if (level == 0)
-		return check_leaf(root, path, level);
-	return check_node(root, path, level);
-}
 
 /*
  * search for key in the extent_buffer.  The items start at offset p,
@@ -1188,7 +1072,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		}
 	}
 	/* double check we haven't messed things up */
-	check_block(root, path, level);
 	if (orig_ptr !=
 	    btrfs_node_blockptr(path->nodes[level], path->slots[level]))
 		BUG();
@@ -1798,12 +1681,6 @@ cow_done:
 		if (!cow)
 			btrfs_unlock_up_safe(p, level + 1);
 
-		ret = check_block(root, p, level);
-		if (ret) {
-			ret = -1;
-			goto done;
-		}
-
 		ret = bin_search(b, key, level, &slot);
 
 		if (level != 0) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 495b1ac..9f31e11 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -323,6 +323,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 	int num_copies = 0;
 	int mirror_num = 0;
 
+	clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 	while (1) {
 		ret = read_extent_buffer_pages(io_tree, eb, start, 1,
@@ -331,6 +332,14 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		    !verify_parent_transid(io_tree, eb, parent_transid))
 			return ret;
 
+		/*
+		 * This buffer's crc is fine, but its contents are corrupted, so
+		 * there is no reason to read the other copies, they won't be
+		 * any less wrong.
+		 */
+		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
+			return ret;
+
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      eb->start, eb->len);
 		if (num_copies == 1)
@@ -419,6 +428,73 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	return ret;
 }
 
+#define CORRUPT(reason, eb, root, slot)				\
+	printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu,"	\
+	       "root=%llu, slot=%d\n", reason,			\
+	       (unsigned long long)btrfs_header_bytenr(eb),	\
+	       (unsigned long long)root->objectid, slot)
+
+static noinline int check_leaf(struct btrfs_root *root,
+			       struct extent_buffer *leaf)
+{
+	struct btrfs_key key;
+	struct btrfs_key leaf_key;
+	u32 nritems = btrfs_header_nritems(leaf);
+	int slot;
+
+	if (nritems == 0)
+		return 0;
+
+	/* Check the 0 item */
+	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
+	    BTRFS_LEAF_DATA_SIZE(root)) {
+		CORRUPT("invalid item offset size pair", leaf, root, 0);
+		return -EIO;
+	}
+
+	/*
+	 * Check to make sure each items keys are in the correct order and their
+	 * offsets make sense.  We only have to loop through nritems-1 because
+	 * we check the current slot against the next slot, which verifies the
+	 * next slot's offset+size makes sense and that the current's slot
+	 * offset is correct.
+	 */
+	for (slot = 0; slot < nritems - 1; slot++) {
+		btrfs_item_key_to_cpu(leaf, &leaf_key, slot);
+		btrfs_item_key_to_cpu(leaf, &key, slot + 1);
+
+		/* Make sure the keys are in the right order */
+		if (btrfs_comp_cpu_keys(&leaf_key, &key) >= 0) {
+			CORRUPT("bad key order", leaf, root, slot);
+			return -EIO;
+		}
+
+		/*
+		 * Make sure the offset and ends are right, remember that the
+		 * item data starts at the end of the leaf and grows towards the
+		 * front.
+		 */
+		if (btrfs_item_offset_nr(leaf, slot) !=
+			btrfs_item_end_nr(leaf, slot + 1)) {
+			CORRUPT("slot offset bad", leaf, root, slot);
+			return -EIO;
+		}
+
+		/*
+		 * Check to make sure that we don't point outside of the leaf,
+		 * just incase all the items are consistent to eachother, but
+		 * all point outside of the leaf.
+		 */
+		if (btrfs_item_end_nr(leaf, slot) >
+		    BTRFS_LEAF_DATA_SIZE(root)) {
+			CORRUPT("slot end outside of leaf", leaf, root, slot);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level)
 {
@@ -485,8 +561,20 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	btrfs_set_buffer_lockdep_class(eb, found_level);
 
 	ret = csum_tree_block(root, eb, 1);
-	if (ret)
+	if (ret) {
 		ret = -EIO;
+		goto err;
+	}
+
+	/*
+	 * If this is a leaf block and it is corrupt, set the corrupt bit so
+	 * that we don't try and read the other copies of this block, just
+	 * return -EIO.
+	 */
+	if (found_level == 0 && check_leaf(root, eb)) {
+		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+		ret = -EIO;
+	}
 
 	end = min_t(u64, eb->len, PAGE_CACHE_SIZE);
 	end = eb->start + end - 1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8f4e8d..cd794c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4754,6 +4754,11 @@ pin:
 		}
 	}
 out:
+	/*
+	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
+	 * anymore.
+	 */
+	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
 	btrfs_put_block_group(cache);
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9318dfe..f62c544 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -31,6 +31,7 @@
 #define EXTENT_BUFFER_UPTODATE 0
 #define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
+#define EXTENT_BUFFER_CORRUPT 3
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
-- 
1.7.2.3

