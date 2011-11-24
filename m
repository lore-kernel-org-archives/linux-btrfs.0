From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 94/99] btrfs: btrfs_free_fs_root should return void
Date: Wed, 23 Nov 2011 19:37:07 -0500
Message-ID: <20111124004230.698110308@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_free_fs_root has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    3 +--
 fs/btrfs/disk-io.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2733,7 +2733,7 @@ int write_ctree_super(struct btrfs_trans
 	return ret;
 }
 
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	radix_tree_delete(&fs_info->fs_roots_radix,
@@ -2746,7 +2746,6 @@ int btrfs_free_fs_root(struct btrfs_fs_i
 	__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	__btrfs_remove_free_space_cache(root->free_ino_ctl);
 	free_fs_root(root);
-	return 0;
 }
 
 static void free_fs_root(struct btrfs_root *root)
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -64,7 +64,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
-int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
+void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 void btrfs_set_buffer_uptodate(struct extent_buffer *buf);


