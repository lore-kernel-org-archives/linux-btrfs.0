From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 1/4] btrfs: free space cache cleanups
Date: Fri, 20 Mar 2009 14:59:50 -0400
Message-ID: <1237575593-21101-2-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch cleans up the free space cache code a bit.  It better documents the
idiosyncrasies of tree_search_offset and makes the code make a bit more sense.
I took out the info allocation at the start of __btrfs_add_free_space and put it
where it makes more sense.  This was left over cruft from when alloc_mutex
existed.  Also all of the re-searches we do to make sure we inserted properly.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c      |    2 +-
 fs/btrfs/free-space-cache.c |   93 ++++++++++++++++++++-----------------------
 2 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8933d15..26fec19 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -291,8 +291,8 @@ next:
 			   block_group->key.objectid +
 			   block_group->key.offset);
 
-	remove_sb_from_cache(root, block_group);
 	block_group->cached = 1;
+	remove_sb_from_cache(root, block_group);
 	ret = 0;
 err:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d1e5f0e..69b023f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -68,14 +68,24 @@ static int tree_insert_bytes(struct rb_root *root, u64 bytes,
 }
 
 /*
- * searches the tree for the given offset.  If contains is set we will return
- * the free space that contains the given offset.  If contains is not set we
- * will return the free space that starts at or after the given offset and is
- * at least bytes long.
+ * searches the tree for the given offset.
+ *
+ * fuzzy == 1: this is used for allocations where we are given a hint of where
+ * to look for free space.  Because the hint may not be completely on an offset
+ * mark, or the hint may no longer point to free space we need to fudge our
+ * results a bit.  So we look for free space starting at or after offset with at
+ * least bytes size.  We prefer to find as close to the given offset as we can.
+ * Also if the offset is within a free space range, then we will return the free
+ * space that contains the given offset, which means we can return a free space
+ * chunk with an offset before the provided offset.
+ *
+ * fuzzy == 0: this is just a normal tree search.  Give us the free space that
+ * starts at the given offset which is at least bytes size, and if its not there
+ * return NULL.
  */
 static struct btrfs_free_space *tree_search_offset(struct rb_root *root,
 						   u64 offset, u64 bytes,
-						   int contains)
+						   int fuzzy)
 {
 	struct rb_node *n = root->rb_node;
 	struct btrfs_free_space *entry, *ret = NULL;
@@ -84,13 +94,14 @@ static struct btrfs_free_space *tree_search_offset(struct rb_root *root,
 		entry = rb_entry(n, struct btrfs_free_space, offset_index);
 
 		if (offset < entry->offset) {
-			if (!contains &&
+			if (fuzzy &&
 			    (!ret || entry->offset < ret->offset) &&
 			    (bytes <= entry->bytes))
 				ret = entry;
 			n = n->rb_left;
 		} else if (offset > entry->offset) {
-			if ((entry->offset + entry->bytes - 1) >= offset &&
+			if (fuzzy &&
+			    (entry->offset + entry->bytes - 1) >= offset &&
 			    bytes <= entry->bytes) {
 				ret = entry;
 				break;
@@ -190,55 +201,28 @@ static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space *right_info;
 	struct btrfs_free_space *left_info;
 	struct btrfs_free_space *info = NULL;
-	struct btrfs_free_space *alloc_info;
 	int ret = 0;
 
-	alloc_info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
-	if (!alloc_info)
-		return -ENOMEM;
-
 	/*
 	 * first we want to see if there is free space adjacent to the range we
 	 * are adding, if there is remove that struct and add a new one to
 	 * cover the entire range
 	 */
 	right_info = tree_search_offset(&block_group->free_space_offset,
-					offset+bytes, 0, 1);
+					offset+bytes, 0, 0);
 	left_info = tree_search_offset(&block_group->free_space_offset,
 				       offset-1, 0, 1);
 
-	if (right_info && right_info->offset == offset+bytes) {
+	if (right_info) {
 		unlink_free_space(block_group, right_info);
 		info = right_info;
 		info->offset = offset;
 		info->bytes += bytes;
-	} else if (right_info && right_info->offset != offset+bytes) {
-		printk(KERN_ERR "btrfs adding space in the middle of an "
-		       "existing free space area. existing: "
-		       "offset=%llu, bytes=%llu. new: offset=%llu, "
-		       "bytes=%llu\n", (unsigned long long)right_info->offset,
-		       (unsigned long long)right_info->bytes,
-		       (unsigned long long)offset,
-		       (unsigned long long)bytes);
-		BUG();
 	}
 
-	if (left_info) {
+	if (left_info && left_info->offset + left_info->bytes == offset) {
 		unlink_free_space(block_group, left_info);
 
-		if (unlikely((left_info->offset + left_info->bytes) !=
-			     offset)) {
-			printk(KERN_ERR "btrfs free space to the left "
-			       "of new free space isn't "
-			       "quite right. existing: offset=%llu, "
-			       "bytes=%llu. new: offset=%llu, bytes=%llu\n",
-			       (unsigned long long)left_info->offset,
-			       (unsigned long long)left_info->bytes,
-			       (unsigned long long)offset,
-			       (unsigned long long)bytes);
-			BUG();
-		}
-
 		if (info) {
 			info->offset = left_info->offset;
 			info->bytes += left_info->bytes;
@@ -251,13 +235,15 @@ static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (info) {
 		ret = link_free_space(block_group, info);
-		if (!ret)
-			info = NULL;
+		if (ret)
+			kfree(info);
 		goto out;
 	}
 
-	info = alloc_info;
-	alloc_info = NULL;
+	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	if (!info)
+		return -ENOMEM;
+
 	info->offset = offset;
 	info->bytes = bytes;
 
@@ -271,8 +257,6 @@ out:
 			BUG();
 	}
 
-	kfree(alloc_info);
-
 	return ret;
 }
 
@@ -283,6 +267,7 @@ __btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space *info;
 	int ret = 0;
 
+	BUG_ON(!block_group->cached);
 	info = tree_search_offset(&block_group->free_space_offset, offset, 0,
 				  1);
 
@@ -341,6 +326,18 @@ __btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 					     offset - old_start);
 		BUG_ON(ret);
 	} else {
+		if (!info) {
+			printk(KERN_ERR "couldn't find space %llu to free\n",
+			       (unsigned long long)offset);
+			printk(KERN_ERR "cached is %d, offset %llu bytes %llu\n",
+			       block_group->cached, block_group->key.objectid,
+			       block_group->key.offset);
+			btrfs_dump_free_space(block_group, bytes);
+		} else if (info) {
+			printk(KERN_ERR "hmm, found offset=%llu bytes=%llu, "
+			       "but wanted offset=%llu bytes=%llu\n",
+			       info->offset, info->bytes, offset, bytes);
+		}
 		WARN_ON(1);
 	}
 out:
@@ -351,12 +348,9 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 offset, u64 bytes)
 {
 	int ret;
-	struct btrfs_free_space *sp;
 
 	mutex_lock(&block_group->alloc_mutex);
 	ret = __btrfs_add_free_space(block_group, offset, bytes);
-	sp = tree_search_offset(&block_group->free_space_offset, offset, 0, 1);
-	BUG_ON(!sp);
 	mutex_unlock(&block_group->alloc_mutex);
 
 	return ret;
@@ -366,11 +360,8 @@ int btrfs_add_free_space_lock(struct btrfs_block_group_cache *block_group,
 			      u64 offset, u64 bytes)
 {
 	int ret;
-	struct btrfs_free_space *sp;
 
 	ret = __btrfs_add_free_space(block_group, offset, bytes);
-	sp = tree_search_offset(&block_group->free_space_offset, offset, 0, 1);
-	BUG_ON(!sp);
 
 	return ret;
 }
@@ -408,6 +399,8 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes)
 			count++;
+		printk(KERN_ERR "entry offset %llu, bytes %llu\n", info->offset,
+		       info->bytes);
 	}
 	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
 	       "\n", count);
@@ -486,7 +479,7 @@ struct btrfs_free_space *btrfs_find_free_space(struct btrfs_block_group_cache
 	struct btrfs_free_space *ret = NULL;
 
 	ret = tree_search_offset(&block_group->free_space_offset, offset,
-				 bytes, 0);
+				 bytes, 1);
 	if (!ret)
 		ret = tree_search_bytes(&block_group->free_space_bytes,
 					offset, bytes);
-- 
1.5.4.3

