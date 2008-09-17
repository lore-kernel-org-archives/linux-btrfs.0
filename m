From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix cache_block_group error handling
Date: Wed, 17 Sep 2008 13:55:28 -0400
Message-ID: <20080917175504.GC26827@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had this patch last month before I started on my allocator stuff, and my
allocator patches depend on this patch (just so they apply properly).  Please
take this before my allocator patches (which should be coming along in a day or
so).  Thanks,

Josef


diff -r 4ae4b933e0eb extent-tree.c
--- a/extent-tree.c	Tue Aug 05 14:13:37 2008 -0400
+++ b/extent-tree.c	Thu Aug 07 21:37:22 2008 -0400
@@ -65,7 +65,7 @@ static int cache_block_group(struct btrf
 			     struct btrfs_block_group_cache *block_group)
 {
 	struct btrfs_path *path;
-	int ret;
+	int ret = 0;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	struct extent_io_tree *free_space_cache;
@@ -101,10 +101,10 @@ static int cache_block_group(struct btrf
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
-		return ret;
+		goto err;
 	ret = btrfs_previous_item(root, path, 0, BTRFS_EXTENT_ITEM_KEY);
 	if (ret < 0)
-		return ret;
+		goto err;
 	if (ret == 0) {
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
@@ -160,9 +160,10 @@ next:
 				 last + hole_size - 1, GFP_NOFS);
 	}
 	block_group->cached = 1;
+	ret = 0;
 err:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
