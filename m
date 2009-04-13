From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: kill btrfs_cache_create
Date: Mon, 13 Apr 2009 15:33:09 +0200
Message-ID: <20090413133309.GB11746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just use kmem_cache_create directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/fs/btrfs/extent_io.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/extent_io.c	2008-12-17 18:33:15.000000000 +0100
+++ btrfs-unstable/fs/btrfs/extent_io.c	2008-12-17 18:35:44.000000000 +0100
@@ -18,12 +18,6 @@
 #include "ctree.h"
 #include "btrfs_inode.h"
 
-/* temporary define until extent_map moves out of btrfs */
-struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
-				       unsigned long extra_flags,
-				       void (*ctor)(void *, struct kmem_cache *,
-						    unsigned long));
-
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
 
@@ -56,15 +50,15 @@ struct extent_page_data {
 
 int __init extent_io_init(void)
 {
-	extent_state_cache = btrfs_cache_create("extent_state",
-					    sizeof(struct extent_state), 0,
-					    NULL);
+	extent_state_cache = kmem_cache_create("extent_state",
+			sizeof(struct extent_state), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_state_cache)
 		return -ENOMEM;
 
-	extent_buffer_cache = btrfs_cache_create("extent_buffers",
-					    sizeof(struct extent_buffer), 0,
-					    NULL);
+	extent_buffer_cache = kmem_cache_create("extent_buffers",
+			sizeof(struct extent_buffer), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
 		goto free_state_cache;
 	return 0;
Index: btrfs-unstable/fs/btrfs/extent_map.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/extent_map.c	2008-12-17 18:33:15.000000000 +0100
+++ btrfs-unstable/fs/btrfs/extent_map.c	2008-12-17 18:42:52.000000000 +0100
@@ -7,19 +7,14 @@
 #include <linux/hardirq.h>
 #include "extent_map.h"
 
-/* temporary define until extent_map moves out of btrfs */
-struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
-				       unsigned long extra_flags,
-				       void (*ctor)(void *, struct kmem_cache *,
-						    unsigned long));
 
 static struct kmem_cache *extent_map_cache;
 
 int __init extent_map_init(void)
 {
-	extent_map_cache = btrfs_cache_create("extent_map",
-					    sizeof(struct extent_map), 0,
-					    NULL);
+	extent_map_cache = kmem_cache_create("extent_map",
+			sizeof(struct extent_map), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_map_cache)
 		return -ENOMEM;
 	return 0;
Index: btrfs-unstable/fs/btrfs/inode.c
===================================================================
--- btrfs-unstable.orig/fs/btrfs/inode.c	2008-12-17 18:33:15.000000000 +0100
+++ btrfs-unstable/fs/btrfs/inode.c	2008-12-17 18:40:32.000000000 +0100
@@ -4519,39 +4519,35 @@ void btrfs_destroy_cachep(void)
 		kmem_cache_destroy(btrfs_path_cachep);
 }
 
-struct kmem_cache *btrfs_cache_create(const char *name, size_t size,
-				       unsigned long extra_flags,
-				       void (*ctor)(void *))
-{
-	return kmem_cache_create(name, size, 0, (SLAB_RECLAIM_ACCOUNT |
-				 SLAB_MEM_SPREAD | extra_flags), ctor);
-}
-
 int btrfs_init_cachep(void)
 {
-	btrfs_inode_cachep = btrfs_cache_create("btrfs_inode_cache",
-					  sizeof(struct btrfs_inode),
-					  0, init_once);
+	btrfs_inode_cachep = kmem_cache_create("btrfs_inode_cache",
+			sizeof(struct btrfs_inode), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, init_once);
 	if (!btrfs_inode_cachep)
 		goto fail;
-	btrfs_trans_handle_cachep =
-			btrfs_cache_create("btrfs_trans_handle_cache",
-					   sizeof(struct btrfs_trans_handle),
-					   0, NULL);
+
+	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle_cache",
+			sizeof(struct btrfs_trans_handle), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_trans_handle_cachep)
 		goto fail;
-	btrfs_transaction_cachep = btrfs_cache_create("btrfs_transaction_cache",
-					     sizeof(struct btrfs_transaction),
-					     0, NULL);
+
+	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction_cache",
+			sizeof(struct btrfs_transaction), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_transaction_cachep)
 		goto fail;
-	btrfs_path_cachep = btrfs_cache_create("btrfs_path_cache",
-					 sizeof(struct btrfs_path),
-					 0, NULL);
+
+	btrfs_path_cachep = kmem_cache_create("btrfs_path_cache",
+			sizeof(struct btrfs_path), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_path_cachep)
 		goto fail;
-	btrfs_bit_radix_cachep = btrfs_cache_create("btrfs_radix", 256,
-					      SLAB_DESTROY_BY_RCU, NULL);
+
+	btrfs_bit_radix_cachep = kmem_cache_create("btrfs_radix", 256, 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD |
+			SLAB_DESTROY_BY_RCU, NULL);
 	if (!btrfs_bit_radix_cachep)
 		goto fail;
 	return 0;
