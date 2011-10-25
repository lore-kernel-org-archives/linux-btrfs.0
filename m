From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 10/66] btrfs: pin_down_extent should return void
Date: Mon, 24 Oct 2011 21:02:46 -0400
Message-ID: <20111025010851.715007810@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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
 	int ret;
 
@@ -4311,8 +4311,6 @@ static int pin_down_extent(struct btrfs_
 			       bytenr + num_bytes - 1,
 			       GFP_NOFS | __GFP_NOFAIL);
 	BUG_ON(ret < 0); /* __GFP_NOFAIL means it can't return -ENOMEM */
-
-	return 0;
 }
 
 /*


