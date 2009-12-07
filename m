From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make metadata chunks smaller and don't preallocate
	metadata during allocations
Date: Mon, 7 Dec 2009 16:45:59 -0500
Message-ID: <20091207214559.GE8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes us a bit less zealous about making sure we have enough free
metadata space by pearing down the size of new metadata chunks to 256mb instead
of 1gb.  Also, we used to try an allocate metadata chunks when allocating data,
but that sort of thing is done elsewhere now so we can just remove it.  With my
-ENOSPC test I used to have 3gb reserved for metadata out of 75gb, now I have
1.7gb.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   10 +---------
 fs/btrfs/volumes.c     |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 46c8c2f..9181278 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4594,17 +4594,9 @@ again:
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
 	 */
-	if (empty_size || root->ref_cows) {
-		if (!(data & BTRFS_BLOCK_GROUP_METADATA)) {
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     2 * 1024 * 1024,
-				     BTRFS_BLOCK_GROUP_METADATA |
-				     (info->metadata_alloc_profile &
-				      info->avail_metadata_alloc_bits), 0);
-		}
+	if (empty_size || root->ref_cows)
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 				     num_bytes + 2 * 1024 * 1024, data, 0);
-	}
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7eda483..198cff2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2209,7 +2209,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		max_chunk_size = 10 * calc_size;
 		min_stripe_size = 64 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		max_chunk_size = 4 * calc_size;
+		max_chunk_size = 256 * 1024 * 1024;
 		min_stripe_size = 32 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		calc_size = 8 * 1024 * 1024;
-- 
1.5.4.3

