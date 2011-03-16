From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check items for correctness as we search
Date: Wed, 16 Mar 2011 13:44:52 -0400
Message-ID: <1300297492-5375-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we have corrupted items things will blow up in spectacular ways.
So as we search check the item that we are pointing at currently to make sure it
passes sanity checks before moving on.  This will catch corruptions in the base
item, the more complex item checking will be up to various consumers of
btrfs_search_slot, but for now this gets us good sanity checking.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c |   88 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..f973ada 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -732,6 +732,12 @@ static inline unsigned int leaf_data_end(struct btrfs_root *root,
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
+#define CORRUPT(reason, eb, root, level, slot)					\
+	printk(KERN_CRIT "btrfs: corrupt %s, %s: block=%llu, root=%llu, "	\
+	       "level=%d, slot=%d\n", level ? "node" : "leaf", reason,		\
+	       (unsigned long long)btrfs_header_bytenr(eb),			\
+	       (unsigned long long)root->objectid, level, slot)
+
 /*
  * extra debugging checks to make sure all the items in a key are
  * well formed and in the proper order
@@ -757,21 +763,42 @@ static int check_node(struct btrfs_root *root, struct btrfs_path *path,
 		parent_slot = path->slots[level + 1];
 		btrfs_node_key(parent, &parent_key, parent_slot);
 		btrfs_node_key(node, &node_key, 0);
-		BUG_ON(memcmp(&parent_key, &node_key,
-			      sizeof(struct btrfs_disk_key)));
-		BUG_ON(btrfs_node_blockptr(parent, parent_slot) !=
-		       btrfs_header_bytenr(node));
+		if (memcmp(&parent_key, &node_key,
+			   sizeof(struct btrfs_disk_key))) {
+			CORRUPT("invalid node key", node, root, level, slot);
+			return -EIO;
+		}
+		if (btrfs_node_blockptr(parent, parent_slot) !=
+		    btrfs_header_bytenr(node)) {
+			CORRUPT("blockptr is not right", node, root, level,
+				slot);
+			return -EIO;
+		}
 	}
-	BUG_ON(nritems > BTRFS_NODEPTRS_PER_BLOCK(root));
+
+	if (nritems > BTRFS_NODEPTRS_PER_BLOCK(root)) {
+		CORRUPT("wrong nritems count", node, root, level, slot);
+		return -EIO;
+	}
+
 	if (slot != 0) {
 		btrfs_node_key_to_cpu(node, &cpukey, slot - 1);
 		btrfs_node_key(node, &node_key, slot);
-		BUG_ON(comp_keys(&node_key, &cpukey) <= 0);
+		if (comp_keys(&node_key, &cpukey) <= 0) {
+			CORRUPT("keys in wrong order", node, root, level,
+				slot);
+			return -EIO;
+		}
 	}
+
 	if (slot < nritems - 1) {
 		btrfs_node_key_to_cpu(node, &cpukey, slot + 1);
 		btrfs_node_key(node, &node_key, slot);
-		BUG_ON(comp_keys(&node_key, &cpukey) >= 0);
+		if (comp_keys(&node_key, &cpukey) >= 0) {
+			CORRUPT("keys in wrong order", node, root, level,
+				slot);
+			return -EIO;
+		}
 	}
 	return 0;
 }
@@ -804,24 +831,31 @@ static int check_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		btrfs_node_key(parent, &parent_key, parent_slot);
 		btrfs_item_key(leaf, &leaf_key, 0);
 
-		BUG_ON(memcmp(&parent_key, &leaf_key,
-		       sizeof(struct btrfs_disk_key)));
-		BUG_ON(btrfs_node_blockptr(parent, parent_slot) !=
-		       btrfs_header_bytenr(leaf));
+		if (memcmp(&parent_key, &leaf_key,
+			   sizeof(struct btrfs_disk_key))) {
+			CORRUPT("bad first key", leaf, root, level, slot);
+			return -EIO;
+		}
+
+		if (btrfs_node_blockptr(parent, parent_slot) !=
+		    btrfs_header_bytenr(leaf)) {
+			CORRUPT("bad block ptr", leaf, root, level, slot);
+			return -EIO;
+		}
 	}
 	if (slot != 0 && slot < nritems - 1) {
 		btrfs_item_key(leaf, &leaf_key, slot);
 		btrfs_item_key_to_cpu(leaf, &cpukey, slot - 1);
 		if (comp_keys(&leaf_key, &cpukey) <= 0) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad key\n", slot);
-			BUG_ON(1);
+			CORRUPT("offset bad key", leaf, root, level, slot);
+			return -EIO;
 		}
 		if (btrfs_item_offset_nr(leaf, slot - 1) !=
 		       btrfs_item_end_nr(leaf, slot)) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad\n", slot);
-			BUG_ON(1);
+			CORRUPT("slot offset bad", leaf, root, level, slot);
+			return -EIO;
 		}
 	}
 	if (slot < nritems - 1) {
@@ -831,19 +865,22 @@ static int check_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		if (btrfs_item_offset_nr(leaf, slot) !=
 			btrfs_item_end_nr(leaf, slot + 1)) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d offset bad\n", slot);
-			BUG_ON(1);
+			CORRUPT("slot offset bad", leaf, root, level, slot);
+			return -EIO;
 		}
 	}
-	BUG_ON(btrfs_item_offset_nr(leaf, 0) +
-	       btrfs_item_size_nr(leaf, 0) != BTRFS_LEAF_DATA_SIZE(root));
+	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
+	    BTRFS_LEAF_DATA_SIZE(root)) {
+		CORRUPT("invalid offset size pair", leaf, root, level, slot);
+		return -EIO;
+	}
+
 	return 0;
 }
 
 static noinline int check_block(struct btrfs_root *root,
 				struct btrfs_path *path, int level)
 {
-	return 0;
 	if (level == 0)
 		return check_leaf(root, path, level);
 	return check_node(root, path, level);
@@ -1188,7 +1225,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		}
 	}
 	/* double check we haven't messed things up */
-	check_block(root, path, level);
 	if (orig_ptr !=
 	    btrfs_node_blockptr(path->nodes[level], path->slots[level]))
 		BUG();
@@ -1799,10 +1835,8 @@ cow_done:
 			btrfs_unlock_up_safe(p, level + 1);
 
 		ret = check_block(root, p, level);
-		if (ret) {
-			ret = -1;
+		if (ret)
 			goto done;
-		}
 
 		ret = bin_search(b, key, level, &slot);
 
@@ -4442,6 +4476,12 @@ again:
 		if (!path->skip_locking)
 			path->locks[level] = 1;
 
+		ret = check_block(root, path, level);
+		if (ret) {
+			btrfs_release_path(root, path);
+			goto done;
+		}
+
 		if (!level)
 			break;
 
-- 
1.7.2.3

