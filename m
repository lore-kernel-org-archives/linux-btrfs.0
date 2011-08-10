From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 7/9] btrfs: Make pin_down_extent return void
Date: Wed, 10 Aug 2011 19:20:34 -0400
Message-ID: <20110810232123.300532775@suse.com>
References: <20110810232027.129702612@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 pin_down_extent performs some operations which can't fail and then calls
 set_extent_dirty, which has two failure cases via set_extent_bit:
 1) Return -EEXIST if exclusive bits are set
    - Since it doesn't use any exclusive bits, this failure case can't
       occur.
 2) Return -ENOMEM if memory can't be allocated
    - Since it's called with gfp_flags & __GFP_NOFAIL, this failure case
      can't occur.

 With no failure cases, it can return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4175,9 +4175,9 @@ static u64 first_logical_byte(struct btr
 	return bytenr;
 }
 
-static int pin_down_extent(struct btrfs_root *root,
-			   struct btrfs_block_group_cache *cache,
-			   u64 bytenr, u64 num_bytes, int reserved)
+static void pin_down_extent(struct btrfs_root *root,
+			    struct btrfs_block_group_cache *cache,
+			    u64 bytenr, u64 num_bytes, int reserved)
 {
 	spin_lock(&cache->space_info->lock);
 	spin_lock(&cache->lock);
@@ -4194,7 +4194,6 @@ static int pin_down_extent(struct btrfs_
 	/* __GFP_NOFAIL means it can't return -ENOMEM */
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
-	return 0;
 }
 
 /*


