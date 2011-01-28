From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use a slab for the free space entries
Date: Fri, 28 Jan 2011 17:07:03 -0500
Message-ID: <1296252423-3209-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since we alloc/free free space entries a whole lot, lets use a slab to keep
track of them.  This makes some of my tests slightly faster.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/free-space-cache.c |   38 ++++++++++++++++++++------------------
 fs/btrfs/inode.c            |   10 ++++++++++
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c98b3a..94ab217 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -40,6 +40,7 @@ extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_transaction_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
+extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
 
 #define BTRFS_MAGIC "_BHRfS_M"
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 60d6842..e92a8d6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -393,7 +393,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				break;
 
 			need_loop = 1;
-			e = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+			e = kmem_cache_zalloc(btrfs_free_space_cachep,
+					      GFP_NOFS);
 			if (!e) {
 				kunmap(page);
 				unlock_page(page);
@@ -405,7 +406,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			e->bytes = le64_to_cpu(entry->bytes);
 			if (!e->bytes) {
 				kunmap(page);
-				kfree(e);
+				kmem_cache_free(btrfs_free_space_cachep, e);
 				unlock_page(page);
 				page_cache_release(page);
 				goto free_cache;
@@ -420,7 +421,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
 				if (!e->bitmap) {
 					kunmap(page);
-					kfree(e);
+					kmem_cache_free(
+						btrfs_free_space_cachep, e);
 					unlock_page(page);
 					page_cache_release(page);
 					goto free_cache;
@@ -1214,7 +1216,7 @@ again:
 		if (!bitmap_info->bytes) {
 			unlink_free_space(block_group, bitmap_info);
 			kfree(bitmap_info->bitmap);
-			kfree(bitmap_info);
+			kmem_cache_free(btrfs_free_space_cachep, bitmap_info);
 			block_group->total_bitmaps--;
 			recalculate_thresholds(block_group);
 		}
@@ -1253,7 +1255,7 @@ again:
 	} else if (!bitmap_info->bytes) {
 		unlink_free_space(block_group, bitmap_info);
 		kfree(bitmap_info->bitmap);
-		kfree(bitmap_info);
+		kmem_cache_free(btrfs_free_space_cachep, bitmap_info);
 		block_group->total_bitmaps--;
 		recalculate_thresholds(block_group);
 	}
@@ -1330,8 +1332,8 @@ new_bitmap:
 
 		/* no pre-allocated info, allocate a new one */
 		if (!info) {
-			info = kzalloc(sizeof(struct btrfs_free_space),
-				       GFP_NOFS);
+			info = kmem_cache_zalloc(btrfs_free_space_cachep,
+						 GFP_NOFS);
 			if (!info) {
 				spin_lock(&block_group->tree_lock);
 				ret = -ENOMEM;
@@ -1353,7 +1355,7 @@ out:
 	if (info) {
 		if (info->bitmap)
 			kfree(info->bitmap);
-		kfree(info);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
 	return ret;
@@ -1367,7 +1369,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space *info = NULL;
 	int ret = 0;
 
-	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	info = kmem_cache_zalloc(btrfs_free_space_cachep, GFP_NOFS);
 	if (!info)
 		return -ENOMEM;
 
@@ -1408,7 +1410,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	if (right_info && !right_info->bitmap) {
 		unlink_free_space(block_group, right_info);
 		info->bytes += right_info->bytes;
-		kfree(right_info);
+		kmem_cache_free(btrfs_free_space_cachep, right_info);
 	}
 
 	if (left_info && !left_info->bitmap &&
@@ -1416,12 +1418,12 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 		unlink_free_space(block_group, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
-		kfree(left_info);
+		kmem_cache_free(btrfs_free_space_cachep, left_info);
 	}
 
 	ret = link_free_space(block_group, info);
 	if (ret)
-		kfree(info);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 out:
 	spin_unlock(&block_group->tree_lock);
 
@@ -1491,7 +1493,7 @@ again:
 			kfree(info->bitmap);
 			block_group->total_bitmaps--;
 		}
-		kfree(info);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 		goto out_lock;
 	}
 
@@ -1527,7 +1529,7 @@ again:
 			/* the hole we're creating ends at the end
 			 * of the info struct, just free the info
 			 */
-			kfree(info);
+			kmem_cache_free(btrfs_free_space_cachep, info);
 		}
 		spin_unlock(&block_group->tree_lock);
 
@@ -1659,7 +1661,7 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 		unlink_free_space(block_group, info);
 		if (info->bitmap)
 			kfree(info->bitmap);
-		kfree(info);
+		kmem_cache_free(btrfs_free_space_cachep, info);
 		if (need_resched()) {
 			spin_unlock(&block_group->tree_lock);
 			cond_resched();
@@ -1688,7 +1690,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 		if (!entry->bytes) {
 			unlink_free_space(block_group, entry);
 			kfree(entry->bitmap);
-			kfree(entry);
+			kmem_cache_free(btrfs_free_space_cachep, entry);
 			block_group->total_bitmaps--;
 			recalculate_thresholds(block_group);
 		}
@@ -1697,7 +1699,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 		entry->offset += bytes;
 		entry->bytes -= bytes;
 		if (!entry->bytes)
-			kfree(entry);
+			kmem_cache_free(btrfs_free_space_cachep, entry);
 		else
 			link_free_space(block_group, entry);
 	}
@@ -1844,7 +1846,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 
 		if (entry->bytes == 0) {
 			rb_erase(&entry->offset_index, &cluster->root);
-			kfree(entry);
+			kmem_cache_free(btrfs_free_space_cachep, entry);
 		}
 		break;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a744a4e..2808d0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -50,6 +50,7 @@
 #include "tree-log.h"
 #include "compression.h"
 #include "locking.h"
+#include "free-space-cache.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -70,6 +71,7 @@ static struct kmem_cache *btrfs_inode_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_transaction_cachep;
 struct kmem_cache *btrfs_path_cachep;
+struct kmem_cache *btrfs_free_space_cachep;
 
 #define S_SHIFT 12
 static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -6624,6 +6626,8 @@ void btrfs_destroy_cachep(void)
 		kmem_cache_destroy(btrfs_transaction_cachep);
 	if (btrfs_path_cachep)
 		kmem_cache_destroy(btrfs_path_cachep);
+	if (btrfs_free_space_cachep)
+		kmem_cache_destroy(btrfs_free_space_cachep);
 }
 
 int btrfs_init_cachep(void)
@@ -6652,6 +6656,12 @@ int btrfs_init_cachep(void)
 	if (!btrfs_path_cachep)
 		goto fail;
 
+	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space_cache",
+			sizeof(struct btrfs_free_space), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_free_space_cachep)
+		goto fail;
+
 	return 0;
 fail:
 	btrfs_destroy_cachep();
-- 
1.7.2.3

