From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 39/66] btrfs: btrfs_prepare_extent_commit should return void
Date: Mon, 24 Oct 2011 21:03:15 -0400
Message-ID: <20111025010855.042699283@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
 		      u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
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


