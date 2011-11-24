From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: polish names of kmem caches
Date: Thu, 24 Nov 2011 17:56:08 +0100
Message-ID: <1322153768-28912-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Usecase:

  watch 'grep btrfs < /proc/slabinfo'

easy to watch all caches in one go.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/delayed-inode.c |    2 +-
 fs/btrfs/extent_io.c     |    4 ++--
 fs/btrfs/extent_map.c    |    2 +-
 fs/btrfs/inode.c         |   10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..5ed6162 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -29,7 +29,7 @@ static struct kmem_cache *delayed_node_cache;
 
 int __init btrfs_delayed_inode_init(void)
 {
-	delayed_node_cache = kmem_cache_create("delayed_node",
+	delayed_node_cache = kmem_cache_create("btrfs_delayed_node",
 					sizeof(struct btrfs_delayed_node),
 					0,
 					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a255136..4d57aaa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -53,13 +53,13 @@ struct extent_page_data {
 
 int __init extent_io_init(void)
 {
-	extent_state_cache = kmem_cache_create("extent_state",
+	extent_state_cache = kmem_cache_create("btrfs_extent_state",
 			sizeof(struct extent_state), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_state_cache)
 		return -ENOMEM;
 
-	extent_buffer_cache = kmem_cache_create("extent_buffers",
+	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
 			sizeof(struct extent_buffer), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..08a8c40 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -11,7 +11,7 @@ static struct kmem_cache *extent_map_cache;
 
 int __init extent_map_init(void)
 {
-	extent_map_cache = kmem_cache_create("extent_map",
+	extent_map_cache = kmem_cache_create("btrfs_extent_map",
 			sizeof(struct extent_map), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_map_cache)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index be589cc..d091166 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6866,31 +6866,31 @@ void btrfs_destroy_cachep(void)
 
 int btrfs_init_cachep(void)
 {
-	btrfs_inode_cachep = kmem_cache_create("btrfs_inode_cache",
+	btrfs_inode_cachep = kmem_cache_create("btrfs_inode",
 			sizeof(struct btrfs_inode), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, init_once);
 	if (!btrfs_inode_cachep)
 		goto fail;
 
-	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle_cache",
+	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle",
 			sizeof(struct btrfs_trans_handle), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_trans_handle_cachep)
 		goto fail;
 
-	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction_cache",
+	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction",
 			sizeof(struct btrfs_transaction), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_transaction_cachep)
 		goto fail;
 
-	btrfs_path_cachep = kmem_cache_create("btrfs_path_cache",
+	btrfs_path_cachep = kmem_cache_create("btrfs_path",
 			sizeof(struct btrfs_path), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_path_cachep)
 		goto fail;
 
-	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space_cache",
+	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space",
 			sizeof(struct btrfs_free_space), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_cachep)
-- 
1.7.6

