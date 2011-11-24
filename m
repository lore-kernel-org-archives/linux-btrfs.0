From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 59/99] btrfs: btrfs_prepare_extent_commit should return void
Date: Wed, 23 Nov 2011 19:36:32 -0500
Message-ID: <20111124004226.647371471@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -2207,8 +2207,8 @@ int btrfs_free_extent(struct btrfs_trans
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
				       u64 start, u64 len);
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root);
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4385,7 +4385,7 @@ static int btrfs_update_reserved_bytes(s
 	return ret;
 }
 
-int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
+void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4415,7 +4415,6 @@ int btrfs_prepare_extent_commit(struct b
 	up_write(&fs_info->extent_commit_sem);
 
 	update_global_block_rsv(fs_info);
-	return 0;
 }
 
 static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)



