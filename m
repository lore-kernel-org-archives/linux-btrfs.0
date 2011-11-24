From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 99/99] btrfs: add_excluded_extent should return void
Date: Wed, 23 Nov 2011 19:37:12 -0500
Message-ID: <20111124004231.275920669@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 add_excluded_extent has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -206,15 +206,14 @@ block_group_cache_tree_search(struct btr
 	return ret;
 }
 
-static int add_excluded_extent(struct btrfs_root *root,
-			       u64 start, u64 num_bytes)
+static void add_excluded_extent(struct btrfs_root *root,
+				u64 start, u64 num_bytes)
 {
 	u64 end = start + num_bytes - 1;
 	set_extent_bits(&root->fs_info->freed_extents[0],
 			start, end, EXTENT_UPTODATE);
 	set_extent_bits(&root->fs_info->freed_extents[1],
 			start, end, EXTENT_UPTODATE);
-	return 0;
 }
 
 static void free_excluded_extents(struct btrfs_root *root,
@@ -242,9 +241,7 @@ static int exclude_super_stripes(struct
 	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
 		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
 		cache->bytes_super += stripe_len;
-		ret = add_excluded_extent(root, cache->key.objectid,
-					  stripe_len);
-		BUG_ON(ret);
+		add_excluded_extent(root, cache->key.objectid, stripe_len);
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -256,9 +253,7 @@ static int exclude_super_stripes(struct
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
-			ret = add_excluded_extent(root, logical[nr],
-						  stripe_len);
-			BUG_ON(ret);
+			add_excluded_extent(root, logical[nr], stripe_len);
 		}
 
 		kfree(logical);
@@ -5789,8 +5784,7 @@ int btrfs_alloc_logged_file_extent(struc
 		mutex_lock(&caching_ctl->mutex);
 
 		if (start >= caching_ctl->progress) {
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			add_excluded_extent(root, start, num_bytes);
 		} else if (start + num_bytes <= caching_ctl->progress) {
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
@@ -5804,8 +5798,7 @@ int btrfs_alloc_logged_file_extent(struc
 			start = caching_ctl->progress;
 			num_bytes = ins->objectid + ins->offset -
 				    caching_ctl->progress;
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret);
+			add_excluded_extent(root, start, num_bytes);
 		}
 
 		mutex_unlock(&caching_ctl->mutex);


