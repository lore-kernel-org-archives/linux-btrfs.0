From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 39/65] btrfs: btrfs_set_block_group_rw should return void
Date: Mon, 03 Oct 2011 23:23:09 -0400
Message-ID: <20111004032304.389359854@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_set_block_group_rw has no error conditions and should return
 void. Its callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/extent-tree.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2262,8 +2262,8 @@ int btrfs_truncate_reserve_metadata(stru
 				    struct btrfs_block_rsv *rsv);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
-int btrfs_set_block_group_rw(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *cache);
+void btrfs_set_block_group_rw(struct btrfs_root *root,
+			      struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6732,7 +6732,7 @@ u64 btrfs_account_ro_block_groups_free_s
 	return free_bytes;
 }
 
-int btrfs_set_block_group_rw(struct btrfs_root *root,
+void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
@@ -6748,7 +6748,6 @@ int btrfs_set_block_group_rw(struct btrf
 	cache->ro = 0;
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
-	return 0;
 }
 
 /*


