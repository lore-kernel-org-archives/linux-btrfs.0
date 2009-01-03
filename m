From: "Liu Hui" <onlyflyer@gmail.com>
Subject: Re: [PATCH]Btrfs:Fix discard semantic
Date: Sat, 3 Jan 2009 23:33:46 +0800
Message-ID: <2c3b11250901030733y9cf8994w984a4c110f42f4d0@mail.gmail.com>
References: <2c3b11250812290723t74c1f505jb0ffc8c66ebe1ead@mail.gmail.com>
	 <3d0408630901010457p5440f053tbf4fe86b2697c9cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, David.Woodhouse@intel.com,
	dwmw2@infradead.org
To: "Yan Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630901010457p5440f053tbf4fe86b2697c9cc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Yan Zheng,

Thanks in advance!

Here are the new description and the new patch(based on standalone git tree):


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
1, For the extents which need to be free at once,
   we discard them in update_block_group().
2, Delay discarding the pinned extent in btrfs_finish_extent_commit()
   when committing transaction.
3, Remove discarding from free_extents() and __free_extent()
4, Add discard interface into btrfs_free_reserved_extent()
5, Discard sectors before updating the free space cache, otherwise,
   FTL will destroy file system data.

--
Thanks & Best Regards
Liu Hui
--

--- extent-tree-old.c	2009-01-03 23:01:30.000000000 +0800
+++ extent-tree.c	2009-01-03 22:58:55.000000000 +0800
@@ -874,6 +874,34 @@
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
@@ -1069,10 +1097,6 @@
 		for (pos = cur, n = pos->next; pos != end;
 		     pos = n, n = pos->next) {
 			struct pending_extent_op *tmp;
-#ifdef BIO_RW_DISCARD
-			u64 map_length;
-			struct btrfs_multi_bio *multi = NULL;
-#endif
 			tmp = list_entry(pos, struct pending_extent_op, list);

 			/*
@@ -1084,28 +1108,6 @@
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
@@ -1965,6 +1967,13 @@
 			spin_unlock(&cache->space_info->lock);
 			if (mark_free) {
 				int ret;
+
+#ifdef BIO_RW_DISCARD
+				ret = btrfs_discard_extent(root, bytenr,
+							   num_bytes);
+				WARN_ON(ret);
+#endif
+
 				ret = btrfs_add_free_space(cache, bytenr,
 							   num_bytes);
 				WARN_ON(ret);
@@ -2104,8 +2113,14 @@
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
@@ -2113,7 +2128,7 @@
 		}
 	}
 	mutex_unlock(&root->fs_info->pinned_mutex);
-	return 0;
+	return ret;
 }

 static int finish_current_insert(struct btrfs_trans_handle *trans,
@@ -2458,10 +2473,6 @@
 	if (refs == 0) {
 		u64 super_used;
 		u64 root_used;
-#ifdef BIO_RW_DISCARD
-		u64 map_length = num_bytes;
-		struct btrfs_multi_bio *multi = NULL;
-#endif

 		if (pin) {
 			mutex_lock(&root->fs_info->pinned_mutex);
@@ -2496,25 +2507,6 @@
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0,
 					 mark_free);
 		BUG_ON(ret);
-#ifdef BIO_RW_DISCARD
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
-		}
-#endif
 	}
 	btrfs_free_path(path);
 	finish_current_insert(trans, extent_root, 0);
@@ -3112,16 +3104,23 @@
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
