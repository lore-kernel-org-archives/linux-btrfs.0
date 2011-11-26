From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: [PATCH] Btrfs: don't waste metadata block groups for clustered allocation
Date: Sat, 26 Nov 2011 12:48:04 -0200
Message-ID: <orwranrlcr.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We try to maintain about 1% of the filesystem space in free space in
data block groups, but we need not do that for metadata, since we only
allocate one block at a time.

This patch also moves the adjustment of flags to account for mixed
data/metadata block groups into the block protected by spin lock, and
before the point in which we now look at flags to decide whether or
not we should keep the free space buffer.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75bafe9..b3ec6c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3228,7 +3228,7 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 
 static int should_alloc_chunk(struct btrfs_root *root,
 			      struct btrfs_space_info *sinfo, u64 alloc_bytes,
-			      int force)
+			      u64 flags, int force)
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
@@ -3246,10 +3246,10 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	num_allocated += global_rsv->size;
 
 	/*
-	 * in limited mode, we want to have some free space up to
+	 * in limited mode, we want to have some free data space up to
 	 * about 1% of the FS size.
 	 */
-	if (force == CHUNK_ALLOC_LIMITED) {
+	if (force == CHUNK_ALLOC_LIMITED && (flags & BTRFS_BLOCK_GROUP_DATA)) {
 		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 		thresh = max_t(u64, 64 * 1024 * 1024,
 			       div_factor_fine(thresh, 1));
@@ -3310,7 +3310,16 @@ again:
 		return 0;
 	}
 
-	if (!should_alloc_chunk(extent_root, space_info, alloc_bytes, force)) {
+	/*
+	 * If we have mixed data/metadata chunks we want to make sure we keep
+	 * allocating mixed chunks instead of individual chunks.
+	 */
+	if (btrfs_mixed_space_info(space_info))
+		flags |= (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
+
+	if (!should_alloc_chunk(extent_root, space_info, alloc_bytes,
+				flags, force)) {
+		space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
 		spin_unlock(&space_info->lock);
 		return 0;
 	} else if (space_info->chunk_alloc) {
@@ -3336,13 +3345,6 @@ again:
 	}
 
 	/*
-	 * If we have mixed data/metadata chunks we want to make sure we keep
-	 * allocating mixed chunks instead of individual chunks.
-	 */
-	if (btrfs_mixed_space_info(space_info))
-		flags |= (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
-
-	/*
 	 * if we're doing a data chunk, go ahead and make sure that
 	 * we keep a reasonable number of metadata chunks allocated in the
 	 * FS as well.
@@ -5312,7 +5314,7 @@ alloc:
 			/*
 			 * whoops, this cluster doesn't actually point to
 			 * this block group.  Get a ref on the block
-			 * group is does point to and try again
+			 * group it does point to and try again
 			 */
 			if (!last_ptr_loop && last_ptr->block_group &&
 			    last_ptr->block_group != block_group &&
-- 
1.7.4.4

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
