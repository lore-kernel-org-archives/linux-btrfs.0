From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix space leak when we fail to make an allocation
Date: Fri, 19 Aug 2011 16:29:11 -0400
Message-ID: <1313785751-17632-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When changing back to using a spin_lock to protect the extent counters I decided
that since we would only be dropping our original extent, it was ok to just drop
the extent and return.  However since somebody else could have come in and done
a reservation, we need to do the normal song and dance to clear the reservation
out properly.  So calculate how much space we need to free, and then subtract
what we just attempted to reserve.  If it's more then we know we need to drop
those bytes from the delalloc block rsv.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4075fd1..44a3107 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4025,16 +4025,24 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
 	if (ret) {
+		u64 to_free = 0;
 		unsigned dropped;
-		/*
-		 * We don't need the return value since our reservation failed,
-		 * we just need to clean up our counter.
-		 */
+
 		spin_lock(&BTRFS_I(inode)->lock);
 		dropped = drop_outstanding_extent(inode);
-		WARN_ON(dropped > 1);
-		BTRFS_I(inode)->csum_bytes -= num_bytes;
+		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
 		spin_unlock(&BTRFS_I(inode)->lock);
+		to_free += btrfs_calc_trans_metadata_size(root, dropped);
+
+		/*
+		 * Somebody could have come in and twiddled with the
+		 * reservation, so if we have to free more than we would have
+		 * reserved from this reservation go ahead and release those
+		 * bytes.
+		 */
+		to_free -= to_reserve;
+		if (to_free)
+			btrfs_block_rsv_release(root, block_rsv, to_free);
 		return ret;
 	}
 
-- 
1.7.5.2

