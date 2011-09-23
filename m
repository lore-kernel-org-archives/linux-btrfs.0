From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/free-space-cache.c: quiet sparse warnings
Date: Fri, 23 Sep 2011 11:25:12 -0700
Message-ID: <201109231125.12628.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the following sparse warnings:

warning: symbol '__create_free_space_inode' was not declared. Should it be static?
warning: symbol '__load_free_space_cache' was not declared. Should it be static?
warning: symbol '__btrfs_write_out_cache' was not declared. Should it be static?
warning: symbol '__btrfs_remove_free_space_cache_locked' was not declared. Should it be static?
warning: context imbalance in 'insert_into_bitmap' - unexpected unlock

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com> (maintainer:BTRFS FILE SYSTEM)

---

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6a265b9..bdd5c0e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -113,7 +113,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	return inode;
 }
 
-int __create_free_space_inode(struct btrfs_root *root,
+static int __create_free_space_inode(struct btrfs_root *root,
 			      struct btrfs_trans_handle *trans,
 			      struct btrfs_path *path, u64 ino, u64 offset)
 {
@@ -238,7 +238,7 @@ static int readahead_cache(struct inode *inode)
 	return 0;
 }
 
-int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
+static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_path *path, u64 offset)
 {
@@ -526,7 +526,7 @@ out:
 	return ret;
 }
 
-int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
+static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			    struct btrfs_free_space_ctl *ctl,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_trans_handle *trans,
@@ -1433,6 +1433,8 @@ static struct btrfs_free_space_op free_space_op = {
 
 static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info)
+	__releases(&ctl->tree_lock)
+	__acquires(&ctl->tree_lock)
 {
 	struct btrfs_free_space *bitmap_info;
 	struct btrfs_block_group_cache *block_group = NULL;
@@ -1842,7 +1844,8 @@ out:
 	return 0;
 }
 
-void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
+static void
+__btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
 	struct rb_node *node;
