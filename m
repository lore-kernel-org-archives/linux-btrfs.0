From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: remove btrfs_init_path
Date: Wed, 11 Feb 2009 22:21:21 -0500
Message-ID: <499395B1.8060008@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Since btrfs_alloc_path is universally used, there's no point in keeping
 btrfs_init_path around.

 This patch removes it, and just uses the __GFP_ZERO flag for
 kmem_cache_alloc to zero out the object.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c     |   12 ++----------
 fs/btrfs/ctree.h     |    1 -
 fs/btrfs/inode-map.c |    1 -
 fs/btrfs/inode.c     |    2 --
 4 files changed, 2 insertions(+), 14 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,20 +38,12 @@ static int balance_node_right(struct btr
 static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
 
-inline void btrfs_init_path(struct btrfs_path *p)
-{
-	memset(p, 0, sizeof(*p));
-}
-
 struct btrfs_path *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
-	path = kmem_cache_alloc(btrfs_path_cachep, GFP_NOFS);
-	if (path) {
-		btrfs_init_path(path);
+	path = kmem_cache_alloc(btrfs_path_cachep, GFP_NOFS | __GFP_ZERO);
+	if (path)
 		path->reada = 1;
-	}
-	WARN_ON_ONCE(!path);
 	return path;
 }
 
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1834,7 +1834,6 @@ int btrfs_realloc_node(struct btrfs_tran
 void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
-void btrfs_init_path(struct btrfs_path *p);
 void btrfs_set_path_blocking(struct btrfs_path *p);
 void btrfs_clear_path_blocking(struct btrfs_path *p);
 void btrfs_unlock_up_safe(struct btrfs_path *p, int level);
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -84,7 +84,6 @@ int btrfs_find_free_objectid(struct btrf
 	search_key.type = 0;
 	search_key.offset = 0;
 
-	btrfs_init_path(path);
 	start_found = 0;
 	ret = btrfs_search_slot(trans, root, &search_key, path, 0, 0);
 	if (ret < 0)
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2543,8 +2543,6 @@ noinline int btrfs_truncate_inode_items(
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
 
-	btrfs_init_path(path);
-
 search_again:
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
-- 
Jeff Mahoney
SUSE Labs
