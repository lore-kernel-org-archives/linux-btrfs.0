From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 1/2] Btrfs: move btrfs_free_space_cachep into free-space-cache.c
Date: Thu, 08 Sep 2011 16:16:28 +0800
Message-ID: <4E6879DC.4040007@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_free_space_cachep is just used in free-space-cache.c, declaring it
as a static global variable in free-space-cache.c can make the source more
readable, and less coupling.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |    1 -
 fs/btrfs/free-space-cache.c |   19 +++++++++++++++++++
 fs/btrfs/free-space-cache.h |    3 +++
 fs/btrfs/inode.c            |    9 ---------
 fs/btrfs/super.c            |   10 +++++++++-
 5 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..c364d50 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -42,7 +42,6 @@ extern struct kmem_cache *btrfs_trans_handle_cachep;
 extern struct kmem_cache *btrfs_transaction_cachep;
 extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
-extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
 
 #define BTRFS_MAGIC "_BHRfS_M"
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6a265b9..e555899 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -30,9 +30,28 @@
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
+static struct kmem_cache *btrfs_free_space_cachep;
+
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 
+int __init free_space_cache_init(void)
+{
+	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space_cache",
+			sizeof(struct btrfs_free_space), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_free_space_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void free_space_cache_exit(void)
+{
+	if (btrfs_free_space_cachep)
+		kmem_cache_destroy(btrfs_free_space_cachep);
+}
+
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 					       struct btrfs_path *path,
 					       u64 offset)
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 8f2613f..c27ccba 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -46,6 +46,9 @@ struct btrfs_free_space_op {
 			   struct btrfs_free_space *info);
 };
 
+int __init free_space_cache_init(void);
+void free_space_cache_exit(void);
+
 struct inode *lookup_free_space_inode(struct btrfs_root *root,
 				      struct btrfs_block_group_cache
 				      *block_group, struct btrfs_path *path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..7a9e01f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -73,7 +73,6 @@ static struct kmem_cache *btrfs_inode_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_transaction_cachep;
 struct kmem_cache *btrfs_path_cachep;
-struct kmem_cache *btrfs_free_space_cachep;
 
 #define S_SHIFT 12
 static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -6870,8 +6869,6 @@ void btrfs_destroy_cachep(void)
 		kmem_cache_destroy(btrfs_transaction_cachep);
 	if (btrfs_path_cachep)
 		kmem_cache_destroy(btrfs_path_cachep);
-	if (btrfs_free_space_cachep)
-		kmem_cache_destroy(btrfs_free_space_cachep);
 }
 
 int btrfs_init_cachep(void)
@@ -6900,12 +6897,6 @@ int btrfs_init_cachep(void)
 	if (!btrfs_path_cachep)
 		goto fail;
 
-	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space_cache",
-			sizeof(struct btrfs_free_space), 0,
-			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
-	if (!btrfs_free_space_cachep)
-		goto fail;
-
 	return 0;
 fail:
 	btrfs_destroy_cachep();
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..63f85d3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -53,6 +53,7 @@
 #include "version.h"
 #include "export.h"
 #include "compression.h"
+#include "free-space-cache.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1246,10 +1247,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_compress;
 
-	err = extent_io_init();
+	err = free_space_cache_init();
 	if (err)
 		goto free_cachep;
 
+	err = extent_io_init();
+	if (err)
+		goto free_space_cache;
+
 	err = extent_map_init();
 	if (err)
 		goto free_extent_io;
@@ -1277,6 +1282,8 @@ free_extent_map:
 	extent_map_exit();
 free_extent_io:
 	extent_io_exit();
+free_space_cache:
+	free_space_cache_exit();
 free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
@@ -1292,6 +1299,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_delayed_inode_exit();
 	extent_map_exit();
 	extent_io_exit();
+	free_space_cache_exit();
 	btrfs_interface_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
-- 
1.7.4
