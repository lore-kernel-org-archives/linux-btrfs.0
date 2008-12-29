From: "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATCH]Btrfs:Fix discard semantic
Date: Mon, 29 Dec 2008 23:23:09 +0800
Message-ID: <2c3b11250812290723t74c1f505jb0ffc8c66ebe1ead@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David.Woodhouse@intel.com, dwmw2@infradead.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
This is a patch to fix discard semantic to make Btrfs work with FTL(or
SSD?). As we know, we can improve FTL's performance by telling it
which sectors are freed by file system. But if we don't tell FTL the
information of free sectors in proper time, the transaction mechanism
of Btrfs will be destroyed and Btrfs could not roll back the previous
transaction under the power loss condition.

There are some problems in the old implementation:
1, In __free_extent(), the pinned down extents should not be discarded.
2, In free_extents(), the free extents are all pinned, so they need to
be discarded in transaction committing time instead of free_extents().
3, The reserved extent used by log tree should be discard too.

This patch change discard behavior as follows:
1, In __free_extent, we only discard the unpinned extent.
2, Delay discarding the pinned extent in btrfs_finish_extent_commit()
when committing transaction.
3, Remove discarding from free_extents()
4, Add discard interface into btrfs_free_reserved_extent()
5, Discard sectors before updating the free space cache, otherwise,
FTL will destroy file system data.

-- 
Thanks & Best Regards
Liu Hui
--

diff --git a/extent-tree.c b/extent-tree.c
index fe0e59a..7247b16 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -874,6 +874,34 @@ static void btrfs_issue_discard(struct block_device *bdev,
 	blkdev_issue_discard(bdev, start >> 9, len >> 9);
 #endif
 }
+
+static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
+				u64 num_bytes)
+{
+	int ret;
+	u64 map_length = num_bytes;
+	struct btrfs_multi_bio *multi = NULL;
+
+	/* Tell the block device(s) that the sectors can be discarded */
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+			      bytenr, &map_length, &multi, 0);
+	if (!ret) {
+		struct btrfs_bio_stripe *stripe = multi->stripes;
+		int i;
+
+		if (map_length > num_bytes)
+			map_length = num_bytes;
+
+		for (i = 0; i < multi->num_stripes; i++, stripe++) {
+			btrfs_issue_discard(stripe->dev->bdev,
+					    stripe->physical,
+					    map_length);
+		}
+		kfree(multi);
+	}
+
+	return ret;
+}
 #endif

 static int noinline free_extents(struct btrfs_trans_handle *trans,
@@ -1069,10 +1097,6 @@ search:
 		for (pos = cur, n = pos->next; pos != end;
 		     pos = n, n = pos->next) {
 			struct pending_extent_op *tmp;
-#ifdef BIO_RW_DISCARD
-			u64 map_length;
-			struct btrfs_multi_bio *multi = NULL;
-#endif
 			tmp = list_entry(pos, struct pending_extent_op, list);

 			/*
@@ -1084,28 +1108,6 @@ search:
 						 tmp->del);
 			BUG_ON(ret);

-#ifdef BIO_RW_DISCARD
-			map_length = tmp->num_bytes;
-			ret = btrfs_map_block(&info->mapping_tree, READ,
-					      tmp->bytenr, &map_length, &multi,
-					      0);
-			if (!ret) {
-				struct btrfs_bio_stripe *stripe;
-				int i;
-
-				stripe = multi->stripes;
-
-				if (map_length > tmp->num_bytes)
-					map_length = tmp->num_bytes;
-
-				for (i = 0; i < multi->num_stripes;
-				     i++, stripe++)
-					btrfs_issue_discard(stripe->dev->bdev,
-							    stripe->physical,
-							    map_length);
-				kfree(multi);
-			}
-#endif
 			list_del_init(&tmp->list);
 			unlock_extent(&info->extent_ins, tmp->bytenr,
 				      tmp->bytenr + tmp->num_bytes - 1,
@@ -2104,8 +2106,14 @@ int btrfs_finish_extent_commit(struct
btrfs_trans_handle *trans,
 					    EXTENT_DIRTY);
 		if (ret)
 			break;
+
+#ifdef BIO_RW_DISCARD
+		ret = btrfs_discard_extent(root, start, end + 1 - start);
+#endif
+
 		btrfs_update_pinned_extents(root, start, end + 1 - start, 0);
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
+
 		if (need_resched()) {
 			mutex_unlock(&root->fs_info->pinned_mutex);
 			cond_resched();
@@ -2113,7 +2121,7 @@ int btrfs_finish_extent_commit(struct
btrfs_trans_handle *trans,
 		}
 	}
 	mutex_unlock(&root->fs_info->pinned_mutex);
-	return 0;
+	return ret;
 }

 static int finish_current_insert(struct btrfs_trans_handle *trans,
@@ -2458,10 +2466,6 @@ static int __free_extent(struct
btrfs_trans_handle *trans,
 	if (refs == 0) {
 		u64 super_used;
 		u64 root_used;
-#ifdef BIO_RW_DISCARD
-		u64 map_length = num_bytes;
-		struct btrfs_multi_bio *multi = NULL;
-#endif

 		if (pin) {
 			mutex_lock(&root->fs_info->pinned_mutex);
@@ -2493,28 +2497,15 @@ static int __free_extent(struct
btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}

-		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
-					 mark_free);
-		BUG_ON(ret);
 #ifdef BIO_RW_DISCARD
-		/* Tell the block device(s) that the sectors can be discarded */
-		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      bytenr, &map_length, &multi, 0);
-		if (!ret) {
-			struct btrfs_bio_stripe *stripe = multi->stripes;
-			int i;
-
-			if (map_length > num_bytes)
-				map_length = num_bytes;
-
-			for (i = 0; i < multi->num_stripes; i++, stripe++) {
-				btrfs_issue_discard(stripe->dev->bdev,
-						    stripe->physical,
-						     map_length);
-			}
-			kfree(multi);
+		if (!pin) {
+			ret = btrfs_discard_extent(root, bytenr, num_bytes);
 		}
 #endif
+
+		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
+					 mark_free);
+		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
 	finish_current_insert(trans, extent_root, 0);
@@ -3112,16 +3103,23 @@ again:
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 {
 	struct btrfs_block_group_cache *cache;
+	int ret = 0;

 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
 		printk(KERN_ERR "Unable to find block group for %Lu\n", start);
 		return -ENOSPC;
 	}
+
+#ifdef BIO_RW_DISCARD
+	ret = btrfs_discard_extent(root, start, len);
+#endif
+
 	btrfs_add_free_space(cache, start, len);
 	put_block_group(cache);
 	update_reserved_extents(root, start, len, 0);
-	return 0;
+
+	return ret;
 }

 int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
