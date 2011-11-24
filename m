From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 30/99] btrfs: pin_down_extent should return void
Date: Wed, 23 Nov 2011 19:36:03 -0500
Message-ID: <20111124004223.292916877@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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

 With no failure cases, it should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4290,9 +4290,9 @@ static u64 first_logical_byte(struct btr
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
@@ -4311,7 +4311,6 @@ static int pin_down_extent(struct btrfs_

	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1);
-	return 0;
 }
 
 /*



