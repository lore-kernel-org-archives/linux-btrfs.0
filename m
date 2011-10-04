From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 38/65] btrfs: btrfs_prepare_extent_commit should return void
Date: Mon, 03 Oct 2011 23:23:08 -0400
Message-ID: <20111004032304.274869899@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_prepare_extent_commit has no error conditions and should return
 void. Its callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/extent-tree.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2199,8 +2199,8 @@ int btrfs_free_extent(struct btrfs_trans
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 				u64 num_bytes, int reserve, int sinfo);
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root);
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4271,7 +4271,7 @@ int btrfs_update_reserved_bytes(struct b
 	return ret;
 }
 
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4301,7 +4301,6 @@ int btrfs_prepare_extent_commit(struct b
 	up_write(&fs_info->extent_commit_sem);
 
 	update_global_block_rsv(fs_info);
-	return 0;
 }
 
 static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)


