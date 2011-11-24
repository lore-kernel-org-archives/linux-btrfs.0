From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 60/99] btrfs: btrfs_set_block_group_rw should return void
Date: Wed, 23 Nov 2011 19:36:33 -0500
Message-ID: <20111124004226.762957655@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -2263,8 +2263,8 @@ void btrfs_block_rsv_release(struct btrf
			     u64 num_bytes);
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
@@ -6769,7 +6769,7 @@ u64 btrfs_account_ro_block_groups_free_s
 	return free_bytes;
 }
 
-int btrfs_set_block_group_rw(struct btrfs_root *root,
+void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
@@ -6785,7 +6785,6 @@ int btrfs_set_block_group_rw(struct btrf
 	cache->ro = 0;
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
-	return 0;
 }
 
 /*



