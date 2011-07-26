From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: switch back to the old csum calculation
Date: Tue, 26 Jul 2011 16:52:52 -0400
Message-ID: <1311713572-26962-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This just switches us back to the old way of doing csum calculations.  It is
broken, but less broken than what I fixed it with, so revert it and I'll come up
with something more correct for later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2e0f87b..4256ab0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3968,6 +3968,11 @@ out:
 	return dropped_extents;
 }
 
+static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes)
+{
+	return num_bytes >>= 3;
+}
+
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3990,21 +3995,11 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 			BTRFS_I(inode)->reserved_extents;
 		BTRFS_I(inode)->reserved_extents += nr_extents;
 
-		/* For checksums we'll just reserve 2 leaves worth of metadata
-		 * and hope that works out right.
-		 *
-		 * NOTE:
-		 * The more correct way to do this would be to figure out how
-		 * much space we are going to write and figure out how many
-		 * checksums that comes out to and then adjust whenever we cross
-		 * a leafsize barrier.  But thats a huge pain in the ass, so
-		 * wing it and hope it comes out right :).
-		 */
-		nr_extents += nr_extents * 2;
 		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
 	}
 	spin_unlock(&BTRFS_I(inode)->lock);
 
+	to_reserve += calc_csum_metadata_size(inode, num_bytes);
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
 	if (ret) {
 		unsigned dropped;
@@ -4031,8 +4026,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	dropped = drop_outstanding_extent(inode);
 
-	/* See btrfs_delalloc_reserve_metadata for an explanation */
-	dropped += dropped * 2;
+	to_free = calc_csum_metadata_size(inode, num_bytes);
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
-- 
1.7.5.2

